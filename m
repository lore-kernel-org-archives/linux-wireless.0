Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:59608 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753653Ab3CLNpi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Mar 2013 09:45:38 -0400
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 05/13] wlcore: consolidate tx_seq handling on recovery
Date: Tue, 12 Mar 2013 15:44:16 +0200
Message-ID: <1363095864-24422-6-git-send-email-coelho@ti.com> (sfid-20130312_144550_959233_0E91E886)
In-Reply-To: <1363095864-24422-1-git-send-email-coelho@ti.com>
References: <1363095864-24422-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Accumulate the total number of sent packets per-link to find out how far
the encryption sequence number has progressed. Use this number as the
initial security sequence number after recovery.

This consolidates security sequence handling for both chip families, as
we no longer have to rely on 12xx specific Tx completion.

A fortunate side effect of this is correct management of seq numbers for
AP roles and multi-role scenarios.

When a link is removed we save the last seq number on a persistent part
of the wlvif. This helps the data survive through recoveries/suspends,
which also entail changes in the hlid of the link.

This functionality is STA only currently.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/cmd.c      |   26 ++++++++++++++
 drivers/net/wireless/ti/wlcore/debugfs.c  |    3 +-
 drivers/net/wireless/ti/wlcore/main.c     |   55 +++++++++++++++--------------
 drivers/net/wireless/ti/wlcore/tx.c       |   19 ----------
 drivers/net/wireless/ti/wlcore/wlcore_i.h |   19 +++++-----
 5 files changed, 66 insertions(+), 56 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index 6331f9e..56d248a 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -327,6 +327,14 @@ int wl12xx_allocate_link(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 *hlid)
 	wl->links[link].prev_freed_pkts =
 			wl->fw_status_2->counters.tx_lnk_free_pkts[link];
 	wl->links[link].wlvif = wlvif;
+
+	/*
+	 * Take saved value for total freed packets from wlvif, in case this is
+	 * recovery/resume
+	 */
+	if (wlvif->bss_type != BSS_TYPE_AP_BSS)
+		wl->links[link].total_freed_pkts = wlvif->total_freed_pkts;
+
 	*hlid = link;
 
 	wl->active_link_count++;
@@ -358,6 +366,24 @@ void wl12xx_free_link(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 *hlid)
 	wl1271_tx_reset_link_queues(wl, *hlid);
 	wl->links[*hlid].wlvif = NULL;
 
+	if (wlvif->bss_type != BSS_TYPE_AP_BSS) {
+		/*
+		 * save the total freed packets in the wlvif, in case this is
+		 * recovery or suspend
+		 */
+		wlvif->total_freed_pkts = wl->links[*hlid].total_freed_pkts;
+
+		/*
+		 * increment the initial seq number on recovery to account for
+		 * transmitted packets that we haven't yet got in the FW status
+		 */
+		if (test_bit(WL1271_FLAG_RECOVERY_IN_PROGRESS, &wl->flags))
+			wlvif->total_freed_pkts +=
+					WL1271_TX_SQN_POST_RECOVERY_PADDING;
+	}
+
+	wl->links[*hlid].total_freed_pkts = 0;
+
 	*hlid = WL12XX_INVALID_LINK_ID;
 	wl->active_link_count--;
 	WARN_ON_ONCE(wl->active_link_count < 0);
diff --git a/drivers/net/wireless/ti/wlcore/debugfs.c b/drivers/net/wireless/ti/wlcore/debugfs.c
index e70a7c8..c3e1f79 100644
--- a/drivers/net/wireless/ti/wlcore/debugfs.c
+++ b/drivers/net/wireless/ti/wlcore/debugfs.c
@@ -598,8 +598,7 @@ static ssize_t vifs_state_read(struct file *file, char __user *user_buf,
 		VIF_STATE_PRINT_INT(last_rssi_event);
 		VIF_STATE_PRINT_INT(ba_support);
 		VIF_STATE_PRINT_INT(ba_allowed);
-		VIF_STATE_PRINT_LLHEX(tx_security_seq);
-		VIF_STATE_PRINT_INT(tx_security_last_seq_lsb);
+		VIF_STATE_PRINT_LLHEX(total_freed_pkts);
 	}
 
 #undef VIF_STATE_PRINT_INT
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index c3e2471..c1a60cd 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -418,13 +418,21 @@ static int wlcore_fw_status(struct wl1271 *wl,
 
 
 	for_each_set_bit(i, wl->links_map, WL12XX_MAX_LINKS) {
+		u8 diff;
 		lnk = &wl->links[i];
+
 		/* prevent wrap-around in freed-packets counter */
-		lnk->allocated_pkts -=
-			(status_2->counters.tx_lnk_free_pkts[i] -
-			 lnk->prev_freed_pkts) & 0xff;
+		diff = (status_2->counters.tx_lnk_free_pkts[i] -
+		       lnk->prev_freed_pkts) & 0xff;
+
+		if (diff == 0)
+			continue;
 
+		lnk->allocated_pkts -= diff;
 		lnk->prev_freed_pkts = status_2->counters.tx_lnk_free_pkts[i];
+
+		/* accumulate the prev_freed_pkts counter */
+		lnk->total_freed_pkts += diff;
 	}
 
 	/* prevent wrap-around in total blocks counter */
@@ -923,18 +931,6 @@ static void wl1271_recovery_work(struct work_struct *work)
 		goto out_unlock;
 	}
 
-	/*
-	 * Advance security sequence number to overcome potential progress
-	 * in the firmware during recovery. This doens't hurt if the network is
-	 * not encrypted.
-	 */
-	wl12xx_for_each_wlvif(wl, wlvif) {
-		if (test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags) ||
-		    test_bit(WLVIF_FLAG_AP_STARTED, &wlvif->flags))
-			wlvif->tx_security_seq +=
-				WL1271_TX_SQN_POST_RECOVERY_PADDING;
-	}
-
 	/* Prevent spurious TX during FW restart */
 	wlcore_stop_queues(wl, WLCORE_QUEUE_STOP_REASON_FW_RESTART);
 
@@ -2864,10 +2860,6 @@ static int wlcore_unset_assoc(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 				     wlvif->sta.klv_template_id,
 				     ACX_KEEP_ALIVE_TPL_INVALID);
 
-	/* reset TX security counters on a clean disconnect */
-	wlvif->tx_security_last_seq_lsb = 0;
-	wlvif->tx_security_seq = 0;
-
 	return 0;
 }
 
@@ -3266,6 +3258,7 @@ int wlcore_set_key(struct wl1271 *wl, enum set_key_cmd cmd,
 	u32 tx_seq_32 = 0;
 	u16 tx_seq_16 = 0;
 	u8 key_type;
+	u8 hlid;
 
 	wl1271_debug(DEBUG_MAC80211, "mac80211 set key");
 
@@ -3275,6 +3268,22 @@ int wlcore_set_key(struct wl1271 *wl, enum set_key_cmd cmd,
 		     key_conf->keylen, key_conf->flags);
 	wl1271_dump(DEBUG_CRYPT, "KEY: ", key_conf->key, key_conf->keylen);
 
+	if (wlvif->bss_type == BSS_TYPE_AP_BSS)
+		if (sta) {
+			struct wl1271_station *wl_sta = (void *)sta->drv_priv;
+			hlid = wl_sta->hlid;
+		} else {
+			hlid = wlvif->ap.bcast_hlid;
+		}
+	else
+		hlid = wlvif->sta.hlid;
+
+	if (hlid != WL12XX_INVALID_LINK_ID) {
+		u64 tx_seq = wl->links[hlid].total_freed_pkts;
+		tx_seq_32 = WL1271_TX_SECURITY_HI32(tx_seq);
+		tx_seq_16 = WL1271_TX_SECURITY_LO16(tx_seq);
+	}
+
 	switch (key_conf->cipher) {
 	case WLAN_CIPHER_SUITE_WEP40:
 	case WLAN_CIPHER_SUITE_WEP104:
@@ -3284,22 +3293,14 @@ int wlcore_set_key(struct wl1271 *wl, enum set_key_cmd cmd,
 		break;
 	case WLAN_CIPHER_SUITE_TKIP:
 		key_type = KEY_TKIP;
-
 		key_conf->hw_key_idx = key_conf->keyidx;
-		tx_seq_32 = WL1271_TX_SECURITY_HI32(wlvif->tx_security_seq);
-		tx_seq_16 = WL1271_TX_SECURITY_LO16(wlvif->tx_security_seq);
 		break;
 	case WLAN_CIPHER_SUITE_CCMP:
 		key_type = KEY_AES;
-
 		key_conf->flags |= IEEE80211_KEY_FLAG_PUT_IV_SPACE;
-		tx_seq_32 = WL1271_TX_SECURITY_HI32(wlvif->tx_security_seq);
-		tx_seq_16 = WL1271_TX_SECURITY_LO16(wlvif->tx_security_seq);
 		break;
 	case WL1271_CIPHER_SUITE_GEM:
 		key_type = KEY_GEM;
-		tx_seq_32 = WL1271_TX_SECURITY_HI32(wlvif->tx_security_seq);
-		tx_seq_16 = WL1271_TX_SECURITY_LO16(wlvif->tx_security_seq);
 		break;
 	default:
 		wl1271_error("Unknown key algo 0x%x", key_conf->cipher);
diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index 07a3e42..8599556 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -932,25 +932,6 @@ static void wl1271_tx_complete_packet(struct wl1271 *wl,
 
 	wl->stats.retry_count += result->ack_failures;
 
-	/*
-	 * update sequence number only when relevant, i.e. only in
-	 * sessions of TKIP, AES and GEM (not in open or WEP sessions)
-	 */
-	if (info->control.hw_key &&
-	    (info->control.hw_key->cipher == WLAN_CIPHER_SUITE_TKIP ||
-	     info->control.hw_key->cipher == WLAN_CIPHER_SUITE_CCMP ||
-	     info->control.hw_key->cipher == WL1271_CIPHER_SUITE_GEM)) {
-		u8 fw_lsb = result->tx_security_sequence_number_lsb;
-		u8 cur_lsb = wlvif->tx_security_last_seq_lsb;
-
-		/*
-		 * update security sequence number, taking care of potential
-		 * wrap-around
-		 */
-		wlvif->tx_security_seq += (fw_lsb - cur_lsb) & 0xff;
-		wlvif->tx_security_last_seq_lsb = fw_lsb;
-	}
-
 	/* remove private header from packet */
 	skb_pull(skb, sizeof(struct wl1271_tx_hw_descr));
 
diff --git a/drivers/net/wireless/ti/wlcore/wlcore_i.h b/drivers/net/wireless/ti/wlcore/wlcore_i.h
index 508f5b0..1ae26ff 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore_i.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore_i.h
@@ -274,6 +274,13 @@ struct wl1271_link {
 
 	/* The wlvif this link belongs to. Might be null for global links */
 	struct wl12xx_vif *wlvif;
+
+	/*
+	 * total freed FW packets on the link - used for tracking the AES/TKIP
+	 * PN across recoveries. Re-initialized each time from the wl1271_station
+	 * structure.
+	 */
+	u64 total_freed_pkts;
 };
 
 #define WL1271_MAX_RX_FILTERS 5
@@ -449,16 +456,12 @@ struct wl12xx_vif {
 	 */
 	struct {
 		u8 persistent[0];
+
 		/*
-		 * Security sequence number
-		 *     bits 0-15: lower 16 bits part of sequence number
-		 *     bits 16-47: higher 32 bits part of sequence number
-		 *     bits 48-63: not in use
+		 * total freed FW packets on the link - used for storing the AES/TKIP
+		 * PN during recovery, as this structure is not zeroed out.
 		 */
-		u64 tx_security_seq;
-
-		/* 8 bits of the last sequence number in use */
-		u8 tx_security_last_seq_lsb;
+		u64 total_freed_pkts;
 	};
 };
 
-- 
1.7.10.4

