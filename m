Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.173]:18750 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbYFYUXx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2008 16:23:53 -0400
Received: by wf-out-1314.google.com with SMTP id 27so3027648wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2008 13:23:52 -0700 (PDT)
Message-ID: <69e28c910806251323j3a80b31etde8683d573dcf2fa@mail.gmail.com> (sfid-20080625_222356_890423_579F588A)
Date: Wed, 25 Jun 2008 22:23:52 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>,
	"Michael Buesch" <mb@bu3sch.de>,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	"Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: BUG(?): dev->wl->if_type is 0 for monitor interfaces (should be 5); b43_is_mode(dev->wl; IEEE80211_IF_TYPE_MNTR) is always false
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <69e28c910806251322i31a8cb4flc7b6c85e8884a5ca@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <69e28c910806251322i31a8cb4flc7b6c85e8884a5ca@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 25, 2008 at 10:22 PM, Stefanik G=E1bor
<netrolller.3d@gmail.com> wrote:
> In both b43 and b43legacy, dev->wl->if_type is 0
> (IEEE80211_IF_TYPE_INVALID) when injecting/transmitting packets on a
> monitor interface (not sure about receiving), while the logical resul=
t
> would be  5 (IEEE80211_IF_TYPE_MNTR). Due to this, the check
> b43(legacy)_is_mode(dev->wl; IEEE80211_IF_TYPE_MNTR) always returns 0=
=2E
>
> I discovered this when updating the b43/b43legacy injection patches.
> This is the latest patch I made, working around this bug by checking
> for both 0 and 5 (I added a quick printk("B43 DEBUG: dev->wl->if_type
> =3D %d", dev->wl->if_type) after the /* MAC control */ comment, which
> helped me find this bug):
>
> diff --git a/drivers/net/wireless/b43/xmit.c b/drivers/net/wireless/b=
43/xmit.c
> index f9e1cff..b7553ab 100644
> --- a/drivers/net/wireless/b43/xmit.c
> +++ b/drivers/net/wireless/b43/xmit.c
> @@ -315,9 +315,11 @@ int b43_generate_txhdr(struct b43_wldev *dev,
>        }
>
>        /* MAC control */
> -       if (!(info->flags & IEEE80211_TX_CTL_NO_ACK))
> +       if (dev->wl->if_type !=3D 5 && dev->wl->if_type !=3D 0 &&
> +             !(info->flags & IEEE80211_TX_CTL_NO_ACK))
>                mac_ctl |=3D B43_TXH_MAC_ACK;
> -       if (!(((fctl & IEEE80211_FCTL_FTYPE) =3D=3D IEEE80211_FTYPE_C=
TL) &&
> +       if (dev->wl->if_type !=3D 5 && dev->wl->if_type !=3D 0 &&
> +             !(((fctl & IEEE80211_FCTL_FTYPE) =3D=3D IEEE80211_FTYPE=
_CTL) &&
>              ((fctl & IEEE80211_FCTL_STYPE) =3D=3D IEEE80211_STYPE_PS=
POLL)))
>                mac_ctl |=3D B43_TXH_MAC_HWSEQ;
>        if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
>
> Is this intentional? I don't know, but it does looks strange for sure=
=2E
>
> --G=E1bor
>
> --
> Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
>

Oops... also CCing linux.wireless.

--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
