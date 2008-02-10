Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:56213 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbYBJPKw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Feb 2008 10:10:52 -0500
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 08/12] Remove support the legacy stack
To: linux-wireless@vger.kernel.org
Cc: Pavel Roskin <proski@gnu.org>
Date: Sun, 10 Feb 2008 17:00:49 +0200
Message-ID: <20080210150049.17592.10280.stgit@tikku> (sfid-20080210_151056_242195_9397D345)
In-Reply-To: <20080210145733.17592.61729.stgit@tikku>
References: <20080210145733.17592.61729.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now the mac80211 interface will only work, the interface using the legacy
stack will be defunct. The legacy interface will removed in following
patches.

Signed-off-by: Kalle Valo <kalle.valo@iki.fi>
---

 drivers/net/wireless/at76_usb.c |    6 +-----
 drivers/net/wireless/at76_usb.h |    1 -
 2 files changed, 1 insertions(+), 6 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index 4ffae92..017c36c 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -5046,7 +5046,7 @@ static void at76_rx_tasklet(unsigned long param)
 		 priv->netdev->name, buf->rx_rate, buf->rssi, buf->noise_level,
 		 buf->link_quality, hex2str(i802_11_hdr, 48));
 
-	if (priv->use_mac80211) {
+	{
 		struct ieee80211_rx_status rx_status = {0};
 		skb_pull(priv->rx_skb, AT76_RX_HDRLEN);
 		skb_trim(priv->rx_skb, le16_to_cpu(buf->wlength));
@@ -5285,8 +5285,6 @@ static int at76_mac80211_start(struct ieee80211_hw *hw)
 
 	mutex_lock(&priv->mtx);
 
-	priv->use_mac80211 = 1;
-
 	ret = at76_submit_rx_urb(priv);
 	if (ret < 0) {
 		printk(KERN_ERR "%s: open: submit_rx_urb failed: %d\n",
@@ -5313,8 +5311,6 @@ static void at76_mac80211_stop(struct ieee80211_hw *hw)
 
 	mutex_lock(&priv->mtx);
 
-	priv->use_mac80211 = 0;
-
 	if (!priv->device_unplugged) {
 		/* We are called by "ifconfig ethX down", not because the
 		 * device is not available anymore. */
diff --git a/drivers/net/wireless/at76_usb.h b/drivers/net/wireless/at76_usb.h
index baa85a5..5375f75 100644
--- a/drivers/net/wireless/at76_usb.h
+++ b/drivers/net/wireless/at76_usb.h
@@ -560,7 +560,6 @@ struct at76_priv {
 
 	struct ieee80211_hw *hw;
 	struct ieee80211_tx_status tx_status;
-	int use_mac80211;
 	int mac80211_registered;
 };
 

