Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758356Ab3EWMTv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 May 2013 08:19:51 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Jake Edge <jake@lwn.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [RFT/RFC 3/4] iwlegacy: workaround for firmware frame tx rejection
Date: Thu, 23 May 2013 14:20:59 +0200
Message-Id: <1369311660-15378-4-git-send-email-sgruszka@redhat.com> (sfid-20130523_141954_021377_4414C58B)
In-Reply-To: <1369311660-15378-1-git-send-email-sgruszka@redhat.com>
References: <1369311660-15378-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware can reject to transmit frame on passive channel, when it
did not yet received any beacon on that channel. Workaround this
problem in the driver.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/4965-mac.c | 19 +++++++++++++++++++
 drivers/net/wireless/iwlegacy/common.c   | 10 ++++++++++
 2 files changed, 29 insertions(+)

diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 9a95045..72b8c4e 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -588,6 +588,13 @@ il4965_pass_packet_to_mac80211(struct il_priv *il, struct ieee80211_hdr *hdr,
 		return;
 	}
 
+	if (unlikely(test_bit(IL_STOP_REASON_PASSIVE, &il->stop_reason)) &&
+	    ieee80211_is_beacon(fc) &&
+	    ether_addr_equal(hdr->addr3, il->active.bssid_addr)) {
+		il_wake_queues_by_reason(il, IL_STOP_REASON_PASSIVE);
+		D_INFO("Woke queues - beacon received on passive channel\n");
+	}
+
 	/* In case of HW accelerated crypto and bad decryption, drop */
 	if (!il->cfg->mod_params->sw_crypto &&
 	    il_set_decrypted_flag(il, hdr, ampdu_status, stats))
@@ -2806,6 +2813,18 @@ il4965_hdl_tx(struct il_priv *il, struct il_rx_buf *rxb)
 		return;
 	}
 
+	/*
+	 * Firmware will not transmit frame on passive channel, if it not yet
+	 * received beacon frame on that channel. When this error happen, we
+	 * have to wait until firmware will unblock itself i.e. when we note
+	 * received beacon (see il4965_pass_packet_to_mac80211).
+	 */
+	if (unlikely(status == TX_STATUS_FAIL_PASSIVE_NO_RX) &&
+	    il->iw_mode == NL80211_IFTYPE_STATION) {
+		il_stop_queues_by_reason(il, IL_STOP_REASON_PASSIVE);
+		D_INFO("Stopped queues - RX waiting on passive channel\n");
+	}
+
 	spin_lock_irqsave(&il->sta_lock, flags);
 	if (txq->sched_retry) {
 		const u32 scd_ssn = il4965_get_scd_ssn(tx_resp);
diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index e9a3cbc..9360d1f 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -5307,6 +5307,16 @@ il_mac_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		D_MAC80211("BSSID %pM\n", bss_conf->bssid);
 
 		/*
+		 * On passive channel we wait with blocked queues for a beacon.
+		 * If beacon will not be received (what is very unlikely, but
+		 * theoretically possible), mac80211 associate procedure will
+		 * time out and mac80211 will call us with NULL bssid. We have
+		 * to unblock queues on such condition.
+		 */
+		if (is_zero_ether_addr(bss_conf->bssid))
+			il_wake_queues_by_reason(il, IL_STOP_REASON_PASSIVE);
+
+		/*
 		 * If there is currently a HW scan going on in the background,
 		 * then we need to cancel it, otherwise sometimes we are not
 		 * able to authenticate (FIXME: why ?)
-- 
1.7.11.7

