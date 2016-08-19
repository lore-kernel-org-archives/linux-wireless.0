Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59596 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754449AbcHSVrY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Aug 2016 17:47:24 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
        Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 03/20] rtl8xxxu: Fix error handling if rtl8xxxu_init_device() fails
Date: Fri, 19 Aug 2016 17:46:25 -0400
Message-Id: <1471643202-26250-4-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160819_234734_949205_AB1624C3)
In-Reply-To: <1471643202-26250-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1471643202-26250-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

For some reason we lost the code bailing if rtl8xxxu_init_device()
returned an error.

This catches the error and also cleans up the error handling.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c    | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index ca4c40d..9c6305b 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -5947,7 +5947,7 @@ static int rtl8xxxu_probe(struct usb_interface *interface,
 	struct ieee80211_hw *hw;
 	struct usb_device *udev;
 	struct ieee80211_supported_band *sband;
-	int ret = 0;
+	int ret;
 	int untested = 1;
 
 	udev = usb_get_dev(interface_to_usbdev(interface));
@@ -5995,6 +5995,7 @@ static int rtl8xxxu_probe(struct usb_interface *interface,
 	hw = ieee80211_alloc_hw(sizeof(struct rtl8xxxu_priv), &rtl8xxxu_ops);
 	if (!hw) {
 		ret = -ENOMEM;
+		priv = NULL;
 		goto exit;
 	}
 
@@ -6043,6 +6044,8 @@ static int rtl8xxxu_probe(struct usb_interface *interface,
 	}
 
 	ret = rtl8xxxu_init_device(hw);
+	if (ret)
+		goto exit;
 
 	hw->wiphy->max_scan_ssids = 1;
 	hw->wiphy->max_scan_ie_len = IEEE80211_MAX_DATA_LEN;
@@ -6093,9 +6096,20 @@ static int rtl8xxxu_probe(struct usb_interface *interface,
 		goto exit;
 	}
 
+	return 0;
+
 exit:
-	if (ret < 0)
-		usb_put_dev(udev);
+	usb_set_intfdata(interface, NULL);
+
+	if (priv) {
+		kfree(priv->fw_data);
+		mutex_destroy(&priv->usb_buf_mutex);
+		mutex_destroy(&priv->h2c_mutex);
+	}
+	usb_put_dev(udev);
+
+	ieee80211_free_hw(hw);
+
 	return ret;
 }
 
-- 
2.7.4
