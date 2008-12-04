Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f11.google.com ([209.85.221.11]:33997 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbYLDMoL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Dec 2008 07:44:11 -0500
Received: by qyk4 with SMTP id 4so4874468qyk.13
        for <linux-wireless@vger.kernel.org>; Thu, 04 Dec 2008 04:44:09 -0800 (PST)
Message-ID: <69e28c910812040444l5d76632ah288078bd3db172d4@mail.gmail.com> (sfid-20081204_134417_113566_D2687588)
Date: Thu, 4 Dec 2008 13:44:09 +0100
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Larry Finger" <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH V2] rtl8187: Improve wireless statistics for RTL8187
Cc: "John W Linville" <linville@tuxdriver.com>,
	"Herton Ronaldo Krzesinski" <herton@mandriva.com.br>,
	"Hin-Tak Leung" <htl10@users.sourceforge.net>,
	barreyromartin@gmail.com, linux-wireless@vger.kernel.org
In-Reply-To: <49375ac0.z1uZDBLv3IxmmMgD%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <49375ac0.z1uZDBLv3IxmmMgD%Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 4, 2008 at 5:21 AM, Larry Finger <Larry.Finger@lwfinger.net=
> wrote:
> The current wireless statistics for the RTL8187 poorly indicate the s=
ignal
> strength and quality. With testing, I found that the AGC value is inv=
ersely
> correlated with the strength as in the RTL8187B. By implementing a si=
milar
> calculation, much more code becomes common to the two devices.
>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Tested by: Mart=EDn Ernesto Barreyro <barreyromartin@gmail.com>
> ---
>
> John,
>
> This is 2.6.29 material.
>
> Larry
> ---
>
> Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_dev.c
> +++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
> @@ -313,29 +313,14 @@ static void rtl8187_rx_cb(struct urb *ur
>                struct rtl8187_rx_hdr *hdr =3D
>                        (typeof(hdr))(skb_tail_pointer(skb) - sizeof(*=
hdr));
>                flags =3D le32_to_cpu(hdr->flags);
> -               signal =3D hdr->signal & 0x7f;
> +               /* As with the RTL8187B below, the AGC is used to cal=
culate
> +                * signal strength and quality. In this case, the sca=
ling
> +                * constants are derived from the output of p54usb.
> +                */
> +               quality =3D 130 - ((41 * hdr->agc) >> 6);
> +               signal =3D -4 - ((27 * hdr->agc) >> 6);
>                rx_status.antenna =3D (hdr->signal >> 7) & 1;
> -               rx_status.noise =3D hdr->noise;
>                rx_status.mactime =3D le64_to_cpu(hdr->mac_time);
> -               priv->quality =3D signal;
> -               rx_status.qual =3D priv->quality;
> -               priv->noise =3D hdr->noise;
> -               rate =3D (flags >> 20) & 0xF;
> -               if (rate > 3) { /* OFDM rate */
> -                       if (signal > 90)
> -                               signal =3D 90;
> -                       else if (signal < 25)
> -                               signal =3D 25;
> -                       signal =3D 90 - signal;
> -               } else {        /* CCK rate */
> -                       if (signal > 95)
> -                               signal =3D 95;
> -                       else if (signal < 30)
> -                               signal =3D 30;
> -                       signal =3D 95 - signal;
> -               }
> -               rx_status.signal =3D signal;
> -               priv->signal =3D signal;
>        } else {
>                struct rtl8187b_rx_hdr *hdr =3D
>                        (typeof(hdr))(skb_tail_pointer(skb) - sizeof(*=
hdr));
> @@ -353,18 +338,18 @@ static void rtl8187_rx_cb(struct urb *ur
>                 */
>                flags =3D le32_to_cpu(hdr->flags);
>                quality =3D 170 - hdr->agc;
> -               if (quality > 100)
> -                       quality =3D 100;
>                signal =3D 14 - hdr->agc / 2;
> -               rx_status.qual =3D quality;
> -               priv->quality =3D quality;
> -               rx_status.signal =3D signal;
> -               priv->signal =3D signal;
>                rx_status.antenna =3D (hdr->rssi >> 7) & 1;
>                rx_status.mactime =3D le64_to_cpu(hdr->mac_time);
> -               rate =3D (flags >> 20) & 0xF;
>        }
>
> +       if (quality > 100)
> +               quality =3D 100;
> +       rx_status.qual =3D quality;
> +       priv->quality =3D quality;
> +       rx_status.signal =3D signal;
> +       priv->signal =3D signal;
> +       rate =3D (flags >> 20) & 0xF;
>        skb_trim(skb, flags & 0x0FFF);
>        rx_status.rate_idx =3D rate;
>        rx_status.freq =3D dev->conf.channel->center_freq;
> @@ -1294,6 +1279,7 @@ static int __devinit rtl8187_probe(struc
>
>        priv->mode =3D NL80211_IFTYPE_MONITOR;
>        dev->flags =3D IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
> +                    IEEE80211_HW_SIGNAL_DBM |
>                     IEEE80211_HW_RX_INCLUDES_FCS;
>
>        eeprom.data =3D dev;
> @@ -1409,13 +1395,8 @@ static int __devinit rtl8187_probe(struc
>                (*channel++).hw_value =3D txpwr >> 8;
>        }
>
> -       if (priv->is_rtl8187b) {
> +       if (priv->is_rtl8187b)
>                printk(KERN_WARNING "rtl8187: 8187B chip detected.\n")=
;
> -               dev->flags |=3D IEEE80211_HW_SIGNAL_DBM;
> -       } else {
> -               dev->flags |=3D IEEE80211_HW_SIGNAL_UNSPEC;
> -               dev->max_signal =3D 65;
> -       }
>
>        /*
>         * XXX: Once this driver supports anything that requires
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wirel=
ess" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

BTW using RTL8187B's scaling constants for RTL8187L also work well
with this patch - I get almost identical readings from my BCM4318 and
my RTL8187L. (I haven't yet submitted my version of the patch because
it's pretty messy, with #if 0'd code and such.) I wonder whether b43
or p54usb is more correct... However, it looks like the same algorithm
is applicable for both RTL8187 variants.

--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
