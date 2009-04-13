Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:52147 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbZDMUoQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2009 16:44:16 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFT/RFC] rtl8187: Remove redundant quality calculation
Date: Mon, 13 Apr 2009 17:44:17 -0300
Cc: "Hin-Tak Leung" <htl10@users.sourceforge.net>,
	linux-wireless@vger.kernel.org
References: <49e289df.b/+c2+59HqherrPx%Larry.Finger@lwfinger.net>
In-Reply-To: <49e289df.b/+c2+59HqherrPx%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Message-Id: <200904131744.17959.herton@mandriva.com.br> (sfid-20090413_224426_352007_5C6D9A1F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Em Domingo 12 Abril 2009, =E0s 21:39:59, Larry Finger escreveu:
> Now that mac80211 does the link quality calculation, that code can be
> removed from this driver. In addition, the signal noise calculation
> used by the vendor driver has been implemented for RYL8187B. The valu=
e
> for RTL8187L is fictional.
>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>
> Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187.h
> +++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187.h
> @@ -37,8 +37,8 @@ struct rtl8187_rx_info {
>
>  struct rtl8187_rx_hdr {
>  	__le32 flags;
> -	u8 noise;
> -	u8 signal;
> +	u8 sq;
> +	u8 rssi;
>  	u8 agc;
>  	u8 reserved;
>  	__le64 mac_time;
> Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_dev.c
> +++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
> @@ -315,7 +315,6 @@ static void rtl8187_rx_cb(struct urb *ur
>  	struct ieee80211_rx_status rx_status =3D { 0 };
>  	int rate, signal;
>  	u32 flags;
> -	u32 quality;
>  	unsigned long f;
>
>  	spin_lock_irqsave(&priv->rx_queue.lock, f);
> @@ -338,13 +337,13 @@ static void rtl8187_rx_cb(struct urb *ur
>  			(typeof(hdr))(skb_tail_pointer(skb) - sizeof(*hdr));
>  		flags =3D le32_to_cpu(hdr->flags);
>  		/* As with the RTL8187B below, the AGC is used to calculate
> -		 * signal strength and quality. In this case, the scaling
> -		 * constants are derived from the output of p54usb.
> +		 * signal strength. In this case, the scaling constants are
> +		 * derived from the output of p54usb.
>  		 */
> -		quality =3D 130 - ((41 * hdr->agc) >> 6);
>  		signal =3D -4 - ((27 * hdr->agc) >> 6);
> -		rx_status.antenna =3D (hdr->signal >> 7) & 1;
> +		rx_status.antenna =3D (hdr->rssi >> 7) & 1;
>  		rx_status.mactime =3D le64_to_cpu(hdr->mac_time);
> +		rx_status.noise =3D hdr->sq - 100;
>  	} else {
>  		struct rtl8187b_rx_hdr *hdr =3D
>  			(typeof(hdr))(skb_tail_pointer(skb) - sizeof(*hdr));
> @@ -354,23 +353,18 @@ static void rtl8187_rx_cb(struct urb *ur
>  		 * In testing, none of these quantities show qualitative
>  		 * agreement with AP signal strength, except for the AGC,
>  		 * which is inversely proportional to the strength of the
> -		 * signal. In the following, the quality and signal strength
> -		 * are derived from the AGC. The arbitrary scaling constants
> -		 * are chosen to make the results close to the values obtained
> -		 * for a BCM4312 using b43 as the driver. The noise is ignored
> -		 * for now.
> +		 * signal. In the following, the signal strength is derived
> +		 * from the AGC. The arbitrary scaling constants are chosen
> +		 * to make the results close to the values obtained for a
> +		 * BCM4312 using b43 as the driver.
>  		 */
>  		flags =3D le32_to_cpu(hdr->flags);
> -		quality =3D 170 - hdr->agc;
>  		signal =3D 14 - hdr->agc / 2;
>  		rx_status.antenna =3D (hdr->rssi >> 7) & 1;
>  		rx_status.mactime =3D le64_to_cpu(hdr->mac_time);
> +		rx_status.noise =3D hdr->snr_long2end;

While testing here I get on a 8187B what looks like a way of noise valu=
e,=20
ranging from -140/-160 dBm. It looks like to not be noise, but real SNR=
, so=20
may be we should do signal - snr? (I tested hdr->sq - hdr->snr_long2end=
 and it=20
looked a bit closer to an expected noise level, -80/-120dBm, but I don'=
t know=20
much about this stuff).

>  	}
>
> -	if (quality > 100)
> -		quality =3D 100;
> -	rx_status.qual =3D quality;
> -	priv->quality =3D quality;
>  	rx_status.signal =3D signal;
>  	priv->signal =3D signal;
>  	rate =3D (flags >> 20) & 0xF;
> @@ -1357,6 +1351,7 @@ static int __devinit rtl8187_probe(struc
>  	priv->mode =3D NL80211_IFTYPE_MONITOR;
>  	dev->flags =3D IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
>  		     IEEE80211_HW_SIGNAL_DBM |
> +		     IEEE80211_HW_NOISE_DBM |
>  		     IEEE80211_HW_RX_INCLUDES_FCS;
>
>  	eeprom.data =3D dev;

--
[]'s
Herton
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
