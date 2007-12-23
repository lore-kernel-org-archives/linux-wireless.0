Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:57442 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751208AbXLWXsw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Dec 2007 18:48:52 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC] cfg80211 API for channels/bitrates, mac80211 and driver conversion
Date: Sun, 23 Dec 2007 18:50:32 -0500
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <1198448108.4103.6.camel@johannes.berg>
In-Reply-To: <1198448108.4103.6.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4209474.V5orX19Xvp";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200712231850.37136.flamingice@sourmilk.net> (sfid-20071223_234859_011991_6634F587)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart4209474.V5orX19Xvp
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 23 December 2007 17:15:08 Johannes Berg wrote:
> + * @power_dBm: requested transmit power
> + * @max_antenna_gain_dBi: maximum antenna gain
Mixed case is bad.

> + * @IEEE80211_HW_2GHZ_SHORT_PREAMBLE_INCAPABLE:
> + *	Hardware is not capable of receiving frames with short preamble on
> + *	the 2.4 GHz band.
Let's add it when we actually find hardware that needs it.

> + * @max_antenna_gain_dBi: maximum antenna gain in dBi
> + * @max_power_dBm: maximum transmission power
Again, no mixed case.

> @@ -136,4 +294,14 @@ extern void wiphy_unregister(struct wiph
>   */
>  extern void wiphy_free(struct wiphy *wiphy);
>
> +/**
> + * ieee80211_channel_to_frequency - convert channel number to frequency
> + */
> +extern int ieee80211_channel_to_frequency(int chan);
> +
> +/**
> + * ieee80211_frequency_to_channel - convert frequency to channel number
> + */
> +extern int ieee80211_frequency_to_channel(int freqMhz);
Mixed case again. Do you really need to add units to these names? They shou=
ld=20
just be all the same throughout the code.

> everything/net/mac80211/ieee80211_i.h	2007-12-23 22:05:39.489081868 +0100
> @@ -79,9 +79,8 @@ struct ieee80211_sta_bss {
>  	u8 ssid[IEEE80211_MAX_SSID_LEN];
>  	size_t ssid_len;
>  	u16 capability; /* host byte order */
> -	int hw_mode;
> -	int channel;
> -	int freq;
> +	enum ieee80211_band band;
> +	int freqMhz;
Ditto.

> --- everything.orig/net/mac80211/ieee80211_ioctl.c	2007-12-23
> 22:02:18.509098090 +0100 +++
> everything/net/mac80211/ieee80211_ioctl.c	2007-12-23 22:05:39.509081760
> +0100 @@ -129,22 +129,7 @@ static int ieee80211_ioctl_giwname(struc
>  				   struct iw_request_info *info,
>  				   char *name, char *extra)
>  {
> -	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
> -
> -	switch (local->hw.conf.phymode) {
> -	case MODE_IEEE80211A:
> -		strcpy(name, "IEEE 802.11a");
> -		break;
> -	case MODE_IEEE80211B:
> -		strcpy(name, "IEEE 802.11b");
> -		break;
> -	case MODE_IEEE80211G:
> -		strcpy(name, "IEEE 802.11g");
> -		break;
> -	default:
> -		strcpy(name, "IEEE 802.11");
> -		break;
> -	}
> +	strcpy(name, "mac80211");
>
>  	return 0;
>  }
It's simple, sure, but no. Let's not change userspace facing behavior if we=
=20
can. If you really need to, use "IEEE 802.11".

Also.. do you really need to rename ieee80211_rate to ieee80211_bitrate? Se=
ems=20
all the same to me and I would prefer a shorter name.

Thanks,
=2DMichael Wu

--nextPart4209474.V5orX19Xvp
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBHbvRNT3Oqt9AH4aERAsBvAJ45laFwR2B1aY1LHKCGIMoiA5XSnwCgo6JE
7EHBHb5VZSalU20mhHRIfEs=
=u2V+
-----END PGP SIGNATURE-----

--nextPart4209474.V5orX19Xvp--
