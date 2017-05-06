Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53000 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751618AbdEFOrG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 6 May 2017 10:47:06 -0400
Date: Sat, 6 May 2017 07:46:57 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Ian W MORRISON <ianwmorrison@gmail.com>
Cc: driverdev-devel@linuxdriverproject.org,
        Jes Sorensen <jes.sorensen@gmail.com>,
        linux-wireless@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        Bastien Nocera <hadess@hadess.net>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH v2] staging: rtl8723bs: remove re-positioned call to
 kfree in os_dep/ioctl_cfg80211.c
Message-ID: <20170506144657.GC30980@kroah.com> (sfid-20170506_164856_390147_5A06082D)
References: <CAFXWsS8TnyA=PnLLL-QJzn00RDLfKwUZ_6XpsYPhd6eRSSKnnw@mail.gmail.com>
 <CAFXWsS8t7aAE-9zABufrTy63z8Cs5fHDXOXgTKmZKj6ZLhR1Lw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAFXWsS8t7aAE-9zABufrTy63z8Cs5fHDXOXgTKmZKj6ZLhR1Lw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 06, 2017 at 03:47:50AM +1000, Ian W MORRISON wrote:
> The following patch was sent to linux-wireless@vger.kernel.org and
> various wifi driver developers however I've just realized that I
> should have sent it to driverdev-devel@linuxdriverproject.org. It was
> reviewed on 01 May with the following comment: "Patch looks good to
> me: Reviewed-by: Hans de Goede <hdegoede@redhat.com>".
> 
> This patch is to remove the re-positioned call to kfree() in
> drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c which otherwise
> results in segmentation fault.
> 
> Signed-off-by: Ian W Morrison <linuxium@linuxium.com.au>
> ---
>  drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
> b/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
> index f17f4fb..2ee9df5 100644
> --- a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
> +++ b/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
> @@ -3527,7 +3527,6 @@ int rtw_wdev_alloc(struct adapter *padapter,
> struct device *dev)
>                 pwdev_priv->power_mgmt = true;
>         else
>                 pwdev_priv->power_mgmt = false;
> -       kfree((u8 *)wdev);
> 
>         return ret;

Whitespace is also messed up here :(
