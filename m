Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:36080 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1423461AbdD0WuH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Apr 2017 18:50:07 -0400
Received: by mail-yw0-f195.google.com with SMTP id j9so3766637ywj.3
        for <linux-wireless@vger.kernel.org>; Thu, 27 Apr 2017 15:50:07 -0700 (PDT)
MIME-Version: 1.0
From: Ian W MORRISON <ianwmorrison@gmail.com>
Date: Fri, 28 Apr 2017 08:50:05 +1000
Message-ID: <CAFXWsS8TnyA=PnLLL-QJzn00RDLfKwUZ_6XpsYPhd6eRSSKnnw@mail.gmail.com> (sfid-20170428_005128_744829_C1C83BE4)
Subject: [PATCH v2] staging: rtl8723bs: remove re-positioned call to kfree in os_dep/ioctl_cfg80211.c
To: linux-wireless@vger.kernel.org
Cc: Bastien Nocera <hadess@hadess.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Jes Sorensen <jes.sorensen@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch is to remove the re-positioned call to kfree() in
drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c which otherwise
results in segmentation fault.

Signed-off-by: Ian W Morrison <linuxium@linuxium.com.au>
---
 drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
b/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
index f17f4fb..2ee9df5 100644
--- a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
+++ b/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
@@ -3527,7 +3527,6 @@ int rtw_wdev_alloc(struct adapter *padapter,
struct device *dev)
                pwdev_priv->power_mgmt = true;
        else
                pwdev_priv->power_mgmt = false;
-       kfree((u8 *)wdev);

        return ret;

-- 
1.9.1
