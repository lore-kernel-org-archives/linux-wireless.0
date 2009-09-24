Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:58785 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481AbZIXSDT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2009 14:03:19 -0400
Received: from vaebh105.NOE.Nokia.com (vaebh105.europe.nokia.com [10.160.244.31])
	by mgw-mx03.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id n8OI3DDI008403
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2009 21:03:14 +0300
Received: from [127.0.1.1] (essapo-nirac25264.europe.nokia.com [10.162.252.64])
	by mgw-da01.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id n8OI2lwf028438
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2009 21:02:49 +0300
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 2/2] at76c50x-usb: set firmware and hardware version in wiphy
To: linux-wireless@vger.kernel.org
Date: Thu, 24 Sep 2009 11:02:51 -0700
Message-ID: <20090924180251.14503.64152.stgit@tikku>
In-Reply-To: <20090924180048.14503.9579.stgit@tikku>
References: <20090924180048.14503.9579.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set firmware and hardware version in wiphy so that user space can access
it.

Signed-off-by: Kalle Valo <kalle.valo@iki.fi>
---

 drivers/net/wireless/at76c50x-usb.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/at76c50x-usb.c b/drivers/net/wireless/at76c50x-usb.c
index 8e1a55d..b6de657 100644
--- a/drivers/net/wireless/at76c50x-usb.c
+++ b/drivers/net/wireless/at76c50x-usb.c
@@ -2217,6 +2217,8 @@ static struct ieee80211_supported_band at76_supported_band = {
 static int at76_init_new_device(struct at76_priv *priv,
 				struct usb_interface *interface)
 {
+	struct wiphy *wiphy;
+	size_t len;
 	int ret;
 
 	/* set up the endpoint information */
@@ -2254,6 +2256,7 @@ static int at76_init_new_device(struct at76_priv *priv,
 	priv->device_unplugged = 0;
 
 	/* mac80211 initialisation */
+	wiphy = priv->hw->wiphy;
 	priv->hw->wiphy->max_scan_ssids = 1;
 	priv->hw->wiphy->max_scan_ie_len = 0;
 	priv->hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
@@ -2265,6 +2268,18 @@ static int at76_init_new_device(struct at76_priv *priv,
 	SET_IEEE80211_DEV(priv->hw, &interface->dev);
 	SET_IEEE80211_PERM_ADDR(priv->hw, priv->mac_addr);
 
+	len = sizeof(wiphy->fw_version);
+	snprintf(wiphy->fw_version, len, "%d.%d.%d-%d",
+		 priv->fw_version.major, priv->fw_version.minor,
+		 priv->fw_version.patch, priv->fw_version.build);
+
+	len = sizeof(wiphy->hw_version);
+	snprintf(wiphy->hw_version, len, "%d", priv->board_type);
+
+	/* null terminate the strings in case they were truncated */
+	wiphy->fw_version[len - 1] = '\0';
+	wiphy->hw_version[len - 1] = '\0';
+
 	ret = ieee80211_register_hw(priv->hw);
 	if (ret) {
 		printk(KERN_ERR "cannot register mac80211 hw (status %d)!\n",

