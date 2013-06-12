Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48161 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862Ab3FLOm6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jun 2013 10:42:58 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Jake Edge <jake@lwn.net>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 4/4] iwl3945: workaround for firmware frame tx rejection
Date: Wed, 12 Jun 2013 16:44:50 +0200
Message-Id: <1371048290-8015-4-git-send-email-sgruszka@redhat.com> (sfid-20130612_164300_904166_87151E14)
In-Reply-To: <1371048290-8015-1-git-send-email-sgruszka@redhat.com>
References: <1371048290-8015-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware can reject to transmit frame on passive channel, when it
did not yet received any frame with valid CRC on that channel.
Workaround this problem in the driver.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/wireless/iwlegacy/3945.c b/drivers/net/wireless/iwlegacy/3945.c
index dc1e6da..c092033 100644
--- a/drivers/net/wireless/iwlegacy/3945.c
+++ b/drivers/net/wireless/iwlegacy/3945.c
@@ -331,6 +331,19 @@ il3945_hdl_tx(struct il_priv *il, struct il_rx_buf *rxb)
 		return;
 	}
 
+	/*
+	 * Firmware will not transmit frame on passive channel, if it not yet
+	 * received some valid frame on that channel. When this error happen
+	 * we have to wait until firmware will unblock itself i.e. when we
+	 * note received beacon or other frame. We unblock queues in
+	 * il3945_pass_packet_to_mac80211 or in il_mac_bss_info_changed.
+	 */
+	if (unlikely((status & TX_STATUS_MSK) == TX_STATUS_FAIL_PASSIVE_NO_RX) &&
+	    il->iw_mode == NL80211_IFTYPE_STATION) {
+		il_stop_queues_by_reason(il, IL_STOP_REASON_PASSIVE);
+		D_INFO("Stopped queues - RX waiting on passive channel\n");
+	}
+
 	txq->time_stamp = jiffies;
 	info = IEEE80211_SKB_CB(txq->skbs[txq->q.read_ptr]);
 	ieee80211_tx_info_clear_status(info);
@@ -488,6 +501,11 @@ il3945_pass_packet_to_mac80211(struct il_priv *il, struct il_rx_buf *rxb,
 		return;
 	}
 
+	if (unlikely(test_bit(IL_STOP_REASON_PASSIVE, &il->stop_reason))) {
+		il_wake_queues_by_reason(il, IL_STOP_REASON_PASSIVE);
+		D_INFO("Woke queues - frame received on passive channel\n");
+	}
+
 	skb = dev_alloc_skb(128);
 	if (!skb) {
 		IL_ERR("dev_alloc_skb failed\n");
-- 
1.7.11.7

