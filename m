Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35976 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752935AbdEGWTT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 7 May 2017 18:19:19 -0400
Subject: [PATCH v5] staging: rtl8723bs: remove re-positioned call to kfree in
 os_dep/ioctl_cfg80211.c
From: Ian W MORRISON <ianwmorrison@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, hadess@hadess.net,
        Larry.Finger@lwfinger.net, hdegoede@redhat.com,
        jes.sorensen@gmail.com, kvalo@qca.qualcomm.com
References: <b4a25189-3e3e-a051-70c3-7fbedc366a26@gmail.com>
 <8b27a07c-ecb1-21be-bf8f-e7365ec000f4@gmail.com>
Message-ID: <40c81df4-d17f-c374-e5a8-c5b8edd914b5@gmail.com> (sfid-20170508_001938_854744_B7B50478)
Date: Sun, 7 May 2017 20:04:59 +1000
MIME-Version: 1.0
In-Reply-To: <8b27a07c-ecb1-21be-bf8f-e7365ec000f4@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A kernel cloned from 
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git and 
built with the latest RTL8723BS driver included (CONFIG_RTL8723BS=m) 
fails when booting on an Intel Atom device with the RTL8723BS wifi 
chipset due to an error in 
drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c.

The kernel when booted with Ubuntu 17.04 results in an unusable system 
however with the following patch booting is successful and the system 
is usable. The patch and kernel builds have been tested against on an 
Intel Compute Stick (STCK1A32WFC model).

This version of the patch (version 5) has tabs rather than spaces, no 
wrap around, a changelog and a sign-off email. 

Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Ian W Morrison <ianwmorrison@gmail.com>
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
