Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33323 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752064AbdEGVmA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 7 May 2017 17:42:00 -0400
To: gregkh@linuxfoundation.org
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, hadess@hadess.net,
        Larry.Finger@lwfinger.net, hdegoede@redhat.com,
        jes.sorensen@gmail.com, kvalo@qca.qualcomm.com
From: Ian W MORRISON <ianwmorrison@gmail.com>
Subject: [PATCH v3] staging: rtl8723bs: remove re-positioned call to kfree in
 os_dep/ioctl_cfg80211.c
Message-ID: <b4a25189-3e3e-a051-70c3-7fbedc366a26@gmail.com> (sfid-20170507_234510_842370_C1670B86)
Date: Sun, 7 May 2017 13:37:39 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A kernel cloned from git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git and built with the latest RTL8723BS driver included (CONFIG_RTL8723BS=m) fails when booting on an Intel Atom device with the RTL8723BS wifi chipset due to an error in drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c.

The kernel when booted with Ubuntu 17.04 results in an unusable system however with the following patch booting is successful and the system is usable. The patch and kernel builds have been tested against on an Intel Compute Stick (STCK1A32WFC model).

This version of the patch (version 3) has tabs rather than spaces and no wrap around. The patch has received one review:

Patch looks good to me:
Reviewed-by: Hans de Goede <hdegoede@redhat.com>

Regards,
Ian

From: Ian W Morrison <linuxium@linuxium.com.au>
Date: Fri, 28 Apr 2017 02:20:38 +1000
Subject: [PATCH] staging: rtl8723bs: remove a call to kfree in
 os_dep/ioctl_cfg80211.c

Signed-off-by: Ian W Morrison <linuxium@linuxium.com.au>
---
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
