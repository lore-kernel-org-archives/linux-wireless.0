Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309AbcDNUhX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 16:37:23 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 08/16] rtl8xxxu: Unregister from mac80211 before shutting down the device
Date: Thu, 14 Apr 2016 16:37:13 -0400
Message-Id: <1460666241-5365-9-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160414_225528_869687_F8611034)
In-Reply-To: <1460666241-5365-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460666241-5365-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This fixes a long standing bug where mac80211 would send disconnect
packets to the device, after we had shut down the device.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 5685fd7..2b71a2b 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -8003,13 +8003,6 @@ exit:
 	return ret;
 }
 
-static void rtl8xxxu_disable_device(struct ieee80211_hw *hw)
-{
-	struct rtl8xxxu_priv *priv = hw->priv;
-
-	priv->fops->power_off(priv);
-}
-
 static void rtl8xxxu_cam_write(struct rtl8xxxu_priv *priv,
 			       struct ieee80211_key_conf *key, const u8 *mac)
 {
@@ -9726,13 +9719,14 @@ static void rtl8xxxu_disconnect(struct usb_interface *interface)
 	hw = usb_get_intfdata(interface);
 	priv = hw->priv;
 
-	rtl8xxxu_disable_device(hw);
+	ieee80211_unregister_hw(hw);
+
+	priv->fops->power_off(priv);
+
 	usb_set_intfdata(interface, NULL);
 
 	dev_info(&priv->udev->dev, "disconnecting\n");
 
-	ieee80211_unregister_hw(hw);
-
 	kfree(priv->fw_data);
 	mutex_destroy(&priv->usb_buf_mutex);
 	mutex_destroy(&priv->h2c_mutex);
-- 
2.5.5

