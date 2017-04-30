Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50270 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1165057AbdD3U4m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 30 Apr 2017 16:56:42 -0400
Subject: Re: [PATCH v2] staging: rtl8723bs: remove re-positioned call to kfree
 in os_dep/ioctl_cfg80211.c
To: Ian W MORRISON <ianwmorrison@gmail.com>,
        linux-wireless@vger.kernel.org
Cc: Bastien Nocera <hadess@hadess.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Jes Sorensen <jes.sorensen@gmail.com>
References: <CAFXWsS8TnyA=PnLLL-QJzn00RDLfKwUZ_6XpsYPhd6eRSSKnnw@mail.gmail.com>
From: Hans de Goede <hdegoede@redhat.com>
Message-ID: <5e5303d6-aaef-1b52-ea52-27de4bf86cc9@redhat.com> (sfid-20170430_225646_884945_FDB327BD)
Date: Sun, 30 Apr 2017 22:56:38 +0200
MIME-Version: 1.0
In-Reply-To: <CAFXWsS8TnyA=PnLLL-QJzn00RDLfKwUZ_6XpsYPhd6eRSSKnnw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 28-04-17 00:50, Ian W MORRISON wrote:
> This patch is to remove the re-positioned call to kfree() in
> drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c which otherwise
> results in segmentation fault.
> 
> Signed-off-by: Ian W Morrison <linuxium@linuxium.com.au>

Patch looks good to me:

Reviewed-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans


> ---
>   drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
> b/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
> index f17f4fb..2ee9df5 100644
> --- a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
> +++ b/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
> @@ -3527,7 +3527,6 @@ int rtw_wdev_alloc(struct adapter *padapter,
> struct device *dev)
>                  pwdev_priv->power_mgmt = true;
>          else
>                  pwdev_priv->power_mgmt = false;
> -       kfree((u8 *)wdev);
> 
>          return ret;
> 
