Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:36575 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161041AbXBOUst (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Feb 2007 15:48:49 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH v2] d80211: Add software sequence support
Date: Thu, 15 Feb 2007 15:48:20 -0500
Cc: Jiri Benc <jbenc@suse.cz>,
	"John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200702141423.27823.IvDoorn@gmail.com>
In-Reply-To: <200702141423.27823.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1708701.9ocFW7MOAr";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200702151548.25041.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1708701.9ocFW7MOAr
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 14 February 2007 08:23, Ivo van Doorn wrote:
> diff --git a/net/d80211/ieee80211_i.h b/net/d80211/ieee80211_i.h
> index 5ab9eb5..1891e05 100644
> --- a/net/d80211/ieee80211_i.h
> +++ b/net/d80211/ieee80211_i.h
> @@ -80,6 +80,7 @@ struct ieee80211_sta_bss {
>  	u8 ssid[IEEE80211_MAX_SSID_LEN];
>  	size_t ssid_len;
>  	u16 capability; /* host byte order */
> +	u16 sequence;
>  	int hw_mode;
>  	int channel;
>  	int freq;
I am not so sure that storing this information in struct ieee80211_sta_bss =
is=20
correct. As far as I can tell, that is strictly for storing information sca=
n=20
results and beacon information. Nothing outside of ieee80211_sta.c uses it.=
=20
struct sta_info or struct ieee80211_if_ap (sta interfaces have a pointer to=
=20
the struct ieee80211_if_ap on the master device) may be a better choice. I=
=20
think struct sta_info is the right one though there is a problem - it isn't=
=20
allocated until a successful association.

=2DMichael Wu

--nextPart1708701.9ocFW7MOAr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBF1McYT3Oqt9AH4aERAvC3AJ9YZ6S0wTHyWPzXgpmP65SutR1KEgCdHqhQ
kVn9/WBHZ23hPTWLpIZhNA0=
=QslU
-----END PGP SIGNATURE-----

--nextPart1708701.9ocFW7MOAr--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
