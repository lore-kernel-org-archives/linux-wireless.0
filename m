Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web23104.mail.ird.yahoo.com ([217.146.189.44]:46267 "HELO
	web23104.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754037AbYLDCui convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Dec 2008 21:50:38 -0500
Date: Thu, 4 Dec 2008 02:50:35 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [PATCH] rtl8187: Improve wireless statistics for RTL8187
To: John W Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	barreyromartin@gmail.com, linux-wireless@vger.kernel.org
In-Reply-To: <49373748.Wmr8pTF2+oHOugNN%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-ID: <27385.37285.qm@web23104.mail.ird.yahoo.com> (sfid-20081204_035042_559650_AD8B0C08)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- On Thu, 4/12/08, Larry Finger <Larry.Finger@lwfinger.net> wrote:

> The current wireless statistics for the RTL8187 poorly
> indicate the signal
> strength and quality. With testing, I found that the AGC
> value is inversely
> correlated with the strength as in the RTL8187B. By
> implementing a similar
> calculation, much more code becomes common to the two
> devices.
>=20
> Signed-off-by: Larry Finger
> <Larry.Finger@lwfinger.net>
> Tested by: Mart=EDn Ernesto Barreyro
> <barreyromartin@gmail.com>
> ---
Acked-by: Hin-Tak Leung <htl10@users.sourceforge.net>

Acually eveything to do with "quality" can be moved out of the if/then.

I mean these 3 lines:

+		if (quality > 100)
+			quality =3D 100;
+		....
+		rx_status.qual =3D quality;

You have removed "rx_status.qual =3D quality;" from the "then" part, bu=
t didn't put it back in the common portion afterwards?

Also, what happened to "dev->max_signal =3D 65;" at the end?



>=20
> John,
>=20
> This is 2.6.29 material.
>=20
> Larry
> ---
>=20
> Index:
> wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> ---
> wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_dev.c
> +++
> wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
> @@ -313,29 +313,17 @@ static void rtl8187_rx_cb(struct urb
> *ur
>  		struct rtl8187_rx_hdr *hdr =3D
>  			(typeof(hdr))(skb_tail_pointer(skb) - sizeof(*hdr));
>  		flags =3D le32_to_cpu(hdr->flags);
> -		signal =3D hdr->signal & 0x7f;
> +		/* As with the RTL8187B below, the AGC is used to
> calculate
> +		 * signal strength and quality. In this case, the
> scaling
> +		 * constants are derived from the output of p54usb.
> +		 */
> +		quality =3D 130 - ((41 * hdr->agc) >> 6);
> +		if (quality > 100)
> +			quality =3D 100;
> +		signal =3D -4 - ((27 * hdr->agc) >> 6);
> +		rx_status.qual =3D quality;
>  		rx_status.antenna =3D (hdr->signal >> 7) & 1;
> -		rx_status.noise =3D hdr->noise;
>  		rx_status.mactime =3D le64_to_cpu(hdr->mac_time);
> -		priv->quality =3D signal;
> -		rx_status.qual =3D priv->quality;
> -		priv->noise =3D hdr->noise;
> -		rate =3D (flags >> 20) & 0xF;
> -		if (rate > 3) { /* OFDM rate */
> -			if (signal > 90)
> -				signal =3D 90;
> -			else if (signal < 25)
> -				signal =3D 25;
> -			signal =3D 90 - signal;
> -		} else {	/* CCK rate */
> -			if (signal > 95)
> -				signal =3D 95;
> -			else if (signal < 30)
> -				signal =3D 30;
> -			signal =3D 95 - signal;
> -		}
> -		rx_status.signal =3D signal;
> -		priv->signal =3D signal;
>  	} else {
>  		struct rtl8187b_rx_hdr *hdr =3D
>  			(typeof(hdr))(skb_tail_pointer(skb) - sizeof(*hdr));
> @@ -356,15 +344,15 @@ static void rtl8187_rx_cb(struct urb
> *ur
>  		if (quality > 100)
>  			quality =3D 100;
>  		signal =3D 14 - hdr->agc / 2;
> -		rx_status.qual =3D quality;
> -		priv->quality =3D quality;
>  		rx_status.signal =3D signal;
> -		priv->signal =3D signal;
>  		rx_status.antenna =3D (hdr->rssi >> 7) & 1;
>  		rx_status.mactime =3D le64_to_cpu(hdr->mac_time);
> -		rate =3D (flags >> 20) & 0xF;
>  	}
> =20
> +	priv->quality =3D quality;
> +	rx_status.signal =3D signal;
> +	priv->signal =3D signal;
> +	rate =3D (flags >> 20) & 0xF;
>  	skb_trim(skb, flags & 0x0FFF);
>  	rx_status.rate_idx =3D rate;
>  	rx_status.freq =3D dev->conf.channel->center_freq;
> @@ -1294,6 +1282,7 @@ static int __devinit
> rtl8187_probe(struc
> =20
>  	priv->mode =3D NL80211_IFTYPE_MONITOR;
>  	dev->flags =3D IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING
> |
> +		     IEEE80211_HW_SIGNAL_DBM |
>  		     IEEE80211_HW_RX_INCLUDES_FCS;
> =20
>  	eeprom.data =3D dev;
> @@ -1409,13 +1398,8 @@ static int __devinit
> rtl8187_probe(struc
>  		(*channel++).hw_value =3D txpwr >> 8;
>  	}
> =20
> -	if (priv->is_rtl8187b) {
> +	if (priv->is_rtl8187b)
>  		printk(KERN_WARNING "rtl8187: 8187B chip
> detected.\n");
> -		dev->flags |=3D IEEE80211_HW_SIGNAL_DBM;
> -	} else {
> -		dev->flags |=3D IEEE80211_HW_SIGNAL_UNSPEC;
> -		dev->max_signal =3D 65;
> -	}
> =20
>  	/*
>  	 * XXX: Once this driver supports anything that requires


     =20
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
