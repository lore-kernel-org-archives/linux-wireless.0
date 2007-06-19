Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:43948 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752685AbXFSFO3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2007 01:14:29 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Hong Liu <hong.liu@intel.com>
Subject: Re: [patch]mac80211: add support for iwlist channel
Date: Mon, 18 Jun 2007 22:12:51 -0700
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
References: <1182156425.15928.7.camel@napa-sdv1.sh.intel.com>
In-Reply-To: <1182156425.15928.7.camel@napa-sdv1.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3663441.YNQDIpp2UW";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200706182212.55862.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart3663441.YNQDIpp2UW
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 18 June 2007 01:47, Hong Liu wrote:
> +static int is_duplicate_channel(struct ieee80211_channel *chan,
> +				struct iw_freq *freq, int count)
> +{
> +	int i;
> +
> +	for (i =3D 0; i < count; i++, freq++)
> +		if (chan->chan =3D=3D freq->i)
> +			return 1;
> +
> +	return 0;
> +}
> +
Currently, the only situation in which channels are duplicated is when ther=
e's=20
an 11g mode registered. The scanning code in ieee80211_sta.c=20
(ieee80211_sta_scan_work) checks for this specifically:

(local->hw_modes & local->enabled_modes & (1 << MODE_IEEE80211G) &&
 mode->mode =3D=3D MODE_IEEE80211B)

MODE_IEEE80211B is skipped if MODE_IEEE80211G is enabled. Modes should be=20
skipped instead of channels.

> +static void ieee80211_get_supp_channels(struct ieee80211_local *local,
> +				struct iw_range *range)
> +{
> +	struct ieee80211_hw_mode *mode =3D NULL;
> +	int c =3D 0, j;
> +
> +	list_for_each_entry(mode, &local->modes_list, list) {
> +		for (j =3D 0;
> +		     j < mode->num_channels && c < IW_MAX_FREQUENCIES; j++) {
This looks somewhat awkward. How about something like:

int j =3D 0;
(check if this mode is disabled or duplicates channels here)
while (j++ < mode->num_channels && c++ < IW_MAX_FREQUENCIES) {

> +			struct ieee80211_channel *chan =3D &mode->channels[j];
> +
> +			if (is_duplicate_channel(chan, range->freq, c))
> +				continue;
> +			range->freq[c].i =3D chan->chan;
> +			range->freq[c].m =3D chan->freq * 100000;
> +			range->freq[c].e =3D 1;
> +			c++;
> +		}
> +	}
> +	range->num_channels =3D c;
> +	range->num_frequency =3D c;
> +}
>
>  static int ieee80211_ioctl_giwrange(struct net_device *dev,
>  				 struct iw_request_info *info,
> @@ -1533,6 +1567,8 @@ static int ieee80211_ioctl_giwrange(struct net_devi=
ce
> *dev, range->enc_capa =3D IW_ENC_CAPA_WPA | IW_ENC_CAPA_WPA2 |
>  			  IW_ENC_CAPA_CIPHER_TKIP | IW_ENC_CAPA_CIPHER_CCMP;
>
> +	ieee80211_get_supp_channels(local, range);
> +
Should be fine to just put all the logic here. No other code will use that=
=20
function.

=2DMichael Wu

--nextPart3663441.YNQDIpp2UW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGd2XXT3Oqt9AH4aERAkwrAJ9lbmI7Eki6rvp+dbg60J0paC1sKwCfc1wa
4xPjF8i4HDx5tN18yMldacg=
=QkMf
-----END PGP SIGNATURE-----

--nextPart3663441.YNQDIpp2UW--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
