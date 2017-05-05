Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:32853 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750805AbdEERrw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 May 2017 13:47:52 -0400
Received: by mail-yw0-f193.google.com with SMTP id 203so953461ywe.0
        for <linux-wireless@vger.kernel.org>; Fri, 05 May 2017 10:47:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFXWsS8TnyA=PnLLL-QJzn00RDLfKwUZ_6XpsYPhd6eRSSKnnw@mail.gmail.com>
References: <CAFXWsS8TnyA=PnLLL-QJzn00RDLfKwUZ_6XpsYPhd6eRSSKnnw@mail.gmail.com>
From: Ian W MORRISON <ianwmorrison@gmail.com>
Date: Sat, 6 May 2017 03:47:50 +1000
Message-ID: <CAFXWsS8t7aAE-9zABufrTy63z8Cs5fHDXOXgTKmZKj6ZLhR1Lw@mail.gmail.com> (sfid-20170505_195030_132085_DDAC7711)
Subject: Re: [PATCH v2] staging: rtl8723bs: remove re-positioned call to kfree
 in os_dep/ioctl_cfg80211.c
To: driverdev-devel@linuxdriverproject.org
Cc: Bastien Nocera <hadess@hadess.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Jes Sorensen <jes.sorensen@gmail.com>,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following patch was sent to linux-wireless@vger.kernel.org and
various wifi driver developers however I've just realized that I
should have sent it to driverdev-devel@linuxdriverproject.org. It was
reviewed on 01 May with the following comment: "Patch looks good to
me: Reviewed-by: Hans de Goede <hdegoede@redhat.com>".

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
