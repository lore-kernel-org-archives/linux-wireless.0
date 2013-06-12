Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50924 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862Ab3FLOnC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jun 2013 10:43:02 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Jake Edge <jake@lwn.net>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 3/4] iwl4965: workaround for firmware frame tx rejection
Date: Wed, 12 Jun 2013 16:44:49 +0200
Message-Id: <1371048290-8015-3-git-send-email-sgruszka@redhat.com> (sfid-20130612_164306_046632_09D5C514)
In-Reply-To: <1371048290-8015-1-git-send-email-sgruszka@redhat.com>
References: <1371048290-8015-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware can reject to transmit frame on passive channel, when it
did not yet received any frame with valid CRC on that channel.
Workaround this problem in the driver.

Tested-by: Jake Edge <jake@lwn.net>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/4965-mac.c | 18 ++++++++++++++++++
 drivers/net/wireless/iwlegacy/common.c   | 11 +++++++++++
 2 files changed, 29 insertions(+)

diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 9a95045..1c44bb5 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -588,6 +588,11 @@ il4965_pass_packet_to_mac80211(struct il_priv *il, struct ieee80211_hdr *hdr,
 		return;
 	}
 
+	if (unlikely(test_bit(IL_STOP_REASON_PASSIVE, &il->stop_reason))) {
+		il_wake_queues_by_reason(il, IL_STOP_REASON_PASSIVE);
+		D_INFO("Woke queues - frame received on passive channel\n");
+	}
+
 	/* In case of HW accelerated crypto and bad decryption, drop */
 	if (!il->cfg->mod_params->sw_crypto &&
 	    il_set_decrypted_flag(il, hdr, ampdu_status, stats))
@@ -2806,6 +2811,19 @@ il4965_hdl_tx(struct il_priv *il, struct il_rx_buf *rxb)
 		return;
 	}
 
+	/*
+	 * Firmware will not transmit frame on passive channel, if it not yet
+	 * received some valid frame on that channel. When this error happen
+	 * we have to wait until firmware will unblock itself i.e. when we
+	 * note received beacon or other frame. We unblock queues in
+	 * il4965_pass_packet_to_mac80211 or in il_mac_bss_info_changed.
+	 */
+	if (unlikely((status & TX_STATUS_MSK) == TX_STATUS_FAIL_PASSIVE_NO_RX) &&
+	    il->iw_mode == NL80211_IFTYPE_STATION) {
+		il_stop_queues_by_reason(il, IL_STOP_REASON_PASSIVE);
+		D_INFO("Stopped queues - RX waiting on passive channel\n");
+	}
+
 	spin_lock_irqsave(&il->sta_lock, flags);
 	if (txq->sched_retry) {
 		const u32 scd_ssn = il4965_get_scd_ssn(tx_resp);
diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index e9a3cbc..3195aad 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -5307,6 +5307,17 @@ il_mac_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		D_MAC80211("BSSID %pM\n", bss_conf->bssid);
 
 		/*
+		 * On passive channel we wait with blocked queues to see if
+		 * there is traffic on that channel. If no frame will be
+		 * received (what is very unlikely since scan detects AP on
+		 * that channel, but theoretically possible), mac80211 associate
+		 * procedure will time out and mac80211 will call us with NULL
+		 * bssid. We have to unblock queues on such condition.
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

