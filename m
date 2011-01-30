Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.platinumzone24.at ([88.198.159.93]:38722 "EHLO
	mail.platinumzone24.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771Ab1A3TLt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jan 2011 14:11:49 -0500
Message-ID: <4D45B7DF.1030703@davizone.at>
Date: Sun, 30 Jan 2011 20:11:27 +0100
From: David Gnedt <david.gnedt@davizone.at>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, Kalle Valo <kvalo@adurom.com>,
	Grazvydas Ignotas <notasas@gmail.com>,
	Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Subject: [PATCH 18/18] wl1251: disable retry and ACK policy for injected packets
References: <4D45A7BD.705@davizone.at>
In-Reply-To: <4D45A7BD.705@davizone.at>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set the retry limit to 0 and disable the ACK policy for injected packets.

Signed-off-by: David Gnedt <david.gnedt@davizone.at>
---
Sorry for the partly broken patches, I thought I configured my client the
right way. I tried to stop the mails at my mailserver, but it was mostly
already too late.
---
 drivers/net/wireless/wl1251/acx.c |    8 +++++++-
 drivers/net/wireless/wl1251/tx.c  |    7 ++++++-
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl1251/acx.c b/drivers/net/wireless/wl1251/acx.c
index 38d33f0..435ed08 100644
--- a/drivers/net/wireless/wl1251/acx.c
+++ b/drivers/net/wireless/wl1251/acx.c
@@ -947,12 +947,18 @@ int wl1251_acx_rate_policies(struct wl1251 *wl)
 	}
 
 	/* configure one default (one-size-fits-all) rate class */
-	acx->rate_class_cnt = 1;
+	acx->rate_class_cnt = 2;
 	acx->rate_class[0].enabled_rates = ACX_RATE_MASK_UNSPECIFIED;
 	acx->rate_class[0].short_retry_limit = ACX_RATE_RETRY_LIMIT;
 	acx->rate_class[0].long_retry_limit = ACX_RATE_RETRY_LIMIT;
 	acx->rate_class[0].aflags = 0;
 
+	/* no-retry rate class */
+	acx->rate_class[1].enabled_rates = ACX_RATE_MASK_UNSPECIFIED;
+	acx->rate_class[1].short_retry_limit = 0;
+	acx->rate_class[1].long_retry_limit = 0;
+	acx->rate_class[1].aflags = 0;
+
 	ret = wl1251_cmd_configure(wl, ACX_RATE_POLICY, acx, sizeof(*acx));
 	if (ret < 0) {
 		wl1251_warning("Setting of rate policies failed: %d", ret);
diff --git a/drivers/net/wireless/wl1251/tx.c b/drivers/net/wireless/wl1251/tx.c
index 1de4ccb..e559bc4 100644
--- a/drivers/net/wireless/wl1251/tx.c
+++ b/drivers/net/wireless/wl1251/tx.c
@@ -90,8 +90,12 @@ static void wl1251_tx_control(struct tx_double_buffer_desc *tx_hdr,
 	/* 802.11 packets */
 	tx_hdr->control.packet_type = 0;
 
-	if (control->flags & IEEE80211_TX_CTL_NO_ACK)
+	/* Also disable retry and ACK policy for injected packets */
+	if ((control->flags & IEEE80211_TX_CTL_NO_ACK) ||
+	    (control->flags & IEEE80211_TX_CTL_INJECTED)) {
+		tx_hdr->control.rate_policy = 1;
 		tx_hdr->control.ack_policy = 1;
+	}
 
 	tx_hdr->control.tx_complete = 1;
 
@@ -414,6 +418,7 @@ static void wl1251_tx_packet_cb(struct wl1251 *wl,
 	info = IEEE80211_SKB_CB(skb);
 
 	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK) &&
+	    !(info->flags & IEEE80211_TX_CTL_INJECTED) &&
 	    (result->status == TX_SUCCESS))
 		info->flags |= IEEE80211_TX_STAT_ACK;
 
-- 
1.7.0.4


