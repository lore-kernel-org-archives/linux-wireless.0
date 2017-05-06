Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52984 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751935AbdEFOqy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 6 May 2017 10:46:54 -0400
Date: Sat, 6 May 2017 07:46:45 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Ian W MORRISON <ianwmorrison@gmail.com>
Cc: linux-wireless@vger.kernel.org, Bastien Nocera <hadess@hadess.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH v2] staging: rtl8723bs: remove re-positioned call to
 kfree in os_dep/ioctl_cfg80211.c
Message-ID: <20170506144645.GB30980@kroah.com> (sfid-20170506_164855_862734_E77FD149)
References: <CAFXWsS8TnyA=PnLLL-QJzn00RDLfKwUZ_6XpsYPhd6eRSSKnnw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAFXWsS8TnyA=PnLLL-QJzn00RDLfKwUZ_6XpsYPhd6eRSSKnnw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 28, 2017 at 08:50:05AM +1000, Ian W MORRISON wrote:
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
> 

Patch has whitespace all turned into spaces :(

Please fix up.

thanks,

greg k-h
