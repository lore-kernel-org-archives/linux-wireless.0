Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58803 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaAGMKw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jan 2014 07:10:52 -0500
Date: Tue, 7 Jan 2014 13:10:51 +0100
From: Pavel Machek <pavel@ucw.cz>
To: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH v3 10/13] wl1251: disable retry and ACK policy for injected
 packets
Message-ID: <20140107121051.GJ10836@amd.pavel.ucw.cz> (sfid-20140107_131055_329907_06CDD71D)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Gnedt <david.gnedt@davizone.at>

Set the retry limit to 0 and disable the ACK policy for injected packets.

Signed-off-by: David Gnedt <david.gnedt@davizone.at>
Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>

---
 drivers/net/wireless/ti/wl1251/acx.c |    8 +++++++-
 drivers/net/wireless/ti/wl1251/tx.c  |    7 ++++++-
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wl1251/acx.c b/drivers/net/wireless/ti/wl1251/acx.c
index f772e62..8f420d0 100644
--- a/drivers/net/wireless/ti/wl1251/acx.c
+++ b/drivers/net/wireless/ti/wl1251/acx.c
@@ -943,12 +943,18 @@ int wl1251_acx_rate_policies(struct wl1251 *wl)
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
diff --git a/drivers/net/wireless/ti/wl1251/tx.c b/drivers/net/wireless/ti/wl1251/tx.c
index 216334d..4516180 100644
--- a/drivers/net/wireless/ti/wl1251/tx.c
+++ b/drivers/net/wireless/ti/wl1251/tx.c
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
 
@@ -422,6 +426,7 @@ static void wl1251_tx_packet_cb(struct wl1251 *wl,
 	info = IEEE80211_SKB_CB(skb);
 
 	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK) &&
+	    !(info->flags & IEEE80211_TX_CTL_INJECTED) &&
 	    (result->status == TX_SUCCESS))
 		info->flags |= IEEE80211_TX_STAT_ACK;
 
