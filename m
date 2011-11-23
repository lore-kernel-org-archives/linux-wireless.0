Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:50114 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab1KWWm5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Nov 2011 17:42:57 -0500
Received: by qyd20 with SMTP id 20so855234qyd.19
        for <linux-wireless@vger.kernel.org>; Wed, 23 Nov 2011 14:42:57 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1318515394-9284-1-git-send-email-hauke@hauke-m.de>
References: <1318515394-9284-1-git-send-email-hauke@hauke-m.de>
Date: Wed, 23 Nov 2011 23:42:56 +0100
Message-ID: <CA+icZUV_0nBu5o2xFSeDS-3T0O7AqbwqK1+iFq7DAD4T9HEjZA@mail.gmail.com> (sfid-20111123_234315_136441_9E5BA279)
Subject: Re: [PATCH] compat-wireless: adapt moving brcm80211 to main area
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: mcgrof@gmail.com, mcgrof@qca.qualcomm.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 13, 2011 at 4:16 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> brcm80211 is no staging driver any more and can be found in the main
> area where all the other wireless drivers are now. There where some
> changes needed for the move.
> And BRCMFMAC does not depend on WEXT any more so remove that from
> config.
> BRCMFMAC does not build with kernel < 2.6.29, because
> ndev->netdev_ops = NULL and ndev->netdev_ops == &brcmf_netdev_ops_pri
> are not supported by the backport code for netdev_ops.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
[...]
> --- a/scripts/driver-select
> +++ b/scripts/driver-select
[...]
> -       brcm80211)
> +       brcmsmac)
> +               disable_staging
> +               disable_bt_usb_ethernet_var
> +               select_drivers          CONFIG_BRCMUTIL CONFIG_BRCMFMAC
> +               select_brcm80211_driver CONFIG_BRCMSMAC
> +               ;;

On IRC someone reported problems building brcmsmac.ko, while trying to
help I fell over this:
Shouldn't that be CONFIG_BRCM*S*MAC in select_drivers line?
( Just FYI: The guy tried building linux-2.6.39 with
compat-wireless-3.2-rc1-1.tar.bz2 )

- Sedat -

> +       brcmfmac)
> +               disable_staging
>                disable_bt_usb_ethernet_var
> -               select_driver           CONFIG_NOTHING
> +               select_drivers          CONFIG_BRCMUTIL CONFIG_BRCMFMAC
> +               select_brcm80211_driver CONFIG_BRCMFMAC
>                ;;
>        zd1211rw)
>                select_driver           CONFIG_COMPAT_ZD1211RW
> --
> 1.7.4.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
