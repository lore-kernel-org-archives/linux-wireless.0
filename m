Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45028 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752039AbcIISB1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Sep 2016 14:01:27 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 1/2] rtl8xxxu: Reset device on module unload if still attached
Date: Fri,  9 Sep 2016 14:01:24 -0400
Message-Id: <1473444085-6363-2-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160909_200131_482663_E803DA5F)
In-Reply-To: <1473444085-6363-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1473444085-6363-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

If the USB dongle is still attached, reset it on module unload to
avoid scans failing when reloading the driver.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index c362083..d2611a4 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -6129,6 +6129,11 @@ static void rtl8xxxu_disconnect(struct usb_interface *interface)
 	mutex_destroy(&priv->usb_buf_mutex);
 	mutex_destroy(&priv->h2c_mutex);
 
+	if (priv->udev->state != USB_STATE_NOTATTACHED) {
+		dev_info(&priv->udev->dev,
+			 "Device still attached, trying to reset\n");
+		usb_reset_device(priv->udev);
+	}
 	usb_put_dev(priv->udev);
 	ieee80211_free_hw(hw);
 }
-- 
2.7.4
