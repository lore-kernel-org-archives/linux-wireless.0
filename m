Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:33396 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751791AbdEHNkm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 May 2017 09:40:42 -0400
Subject: [PATCH v6] staging: rtl8723bs: remove re-positioned call to kfree in
 os_dep/ioctl_cfg80211.c
From: Ian W MORRISON <ianwmorrison@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, hadess@hadess.net,
        Larry.Finger@lwfinger.net, hdegoede@redhat.com,
        jes.sorensen@gmail.com, kvalo@qca.qualcomm.com
References: <b4a25189-3e3e-a051-70c3-7fbedc366a26@gmail.com>
 <8b27a07c-ecb1-21be-bf8f-e7365ec000f4@gmail.com>
 <40c81df4-d17f-c374-e5a8-c5b8edd914b5@gmail.com>
Message-ID: <862374c4-39ac-8f0a-e5d1-c239d6910e1f@gmail.com> (sfid-20170508_154113_509830_0E410A08)
Date: Mon, 8 May 2017 23:40:35 +1000
MIME-Version: 1.0
In-Reply-To: <40c81df4-d17f-c374-e5a8-c5b8edd914b5@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A re-positioned call to kfree() in 
drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
causes a segmentation error. This patch removed the kfree() call.

Fixes 6557ddfec348 ("staging: rtl8723bs: Fix various errors in os_dep/ioctl_cfg80211.c")
Signed-off-by: Ian W Morrison <ianwmorrison@gmail.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
---
This version of the patch (version 6) fixes errors in the patch submission.
 drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c b/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
index f17f4fb..2ee9df5 100644
--- a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
+++ b/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
@@ -3527,7 +3527,6 @@ int rtw_wdev_alloc(struct adapter *padapter, struct device *dev)
 		pwdev_priv->power_mgmt = true;
 	else
 		pwdev_priv->power_mgmt = false;
-	kfree((u8 *)wdev);
 
 	return ret;
 
-- 
1.9.1
