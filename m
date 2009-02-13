Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59603 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbZBMLAL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 06:00:11 -0500
Subject: Re: [PATCH] nl80211: Optional IEs into scan request
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni.malinen@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090213105306.GA18754@jm.kir.nu>
References: <20090213105306.GA18754@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-fETSyGV/r6u97WOd+xrJ"
Date: Fri, 13 Feb 2009 12:00:04 +0100
Message-Id: <1234522804.4219.13.camel@johannes.local> (sfid-20090213_120015_912239_A7680D33)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fETSyGV/r6u97WOd+xrJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-02-13 at 12:53 +0200, Jouni Malinen wrote:
> This extends the NL80211_CMD_TRIGGER_SCAN command to allow applications
> to specify a set of information element(s) to be added into Probe
> Request frames with NL80211_ATTR_IE. This provides support for the
> MLME-SCAN.request primitive parameter VendorSpecificInfo and can be
> used, e.g., to implement WPS scanning.
>=20
> Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

Looks like this will conflict with my ibss splitout patch?

>=20
> ---
>  include/net/cfg80211.h     |    4 ++++
>  net/mac80211/ieee80211_i.h |    3 ++-
>  net/mac80211/mlme.c        |   14 +++++++++-----
>  net/mac80211/scan.c        |    3 ++-
>  net/wireless/nl80211.c     |   21 ++++++++++++++++++++-
>  5 files changed, 37 insertions(+), 8 deletions(-)
>=20
> --- wireless-testing.orig/include/net/cfg80211.h	2009-02-13 12:47:56.0000=
00000 +0200
> +++ wireless-testing/include/net/cfg80211.h	2009-02-13 12:48:45.000000000=
 +0200
> @@ -525,6 +525,8 @@ struct cfg80211_ssid {
>   * @n_ssids: number of SSIDs
>   * @channels: channels to scan on.
>   * @n_channels: number of channels for each band
> + * @ie: optional information element(s) to add into Probe Request or %NU=
LL
> + * @ie_len: length of ie in octets
>   * @wiphy: the wiphy this was for
>   * @ifidx: the interface index
>   */
> @@ -533,6 +535,8 @@ struct cfg80211_scan_request {
>  	int n_ssids;
>  	struct ieee80211_channel **channels;
>  	u32 n_channels;
> +	u8 *ie;
> +	size_t ie_len;
> =20
>  	/* internal */
>  	struct wiphy *wiphy;
> --- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-02-13 12:47:56.=
000000000 +0200
> +++ wireless-testing/net/mac80211/ieee80211_i.h	2009-02-13 12:48:45.00000=
0000 +0200
> @@ -911,7 +911,8 @@ u32 ieee80211_sta_get_rates(struct ieee8
>  			    struct ieee802_11_elems *elems,
>  			    enum ieee80211_band band);
>  void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *d=
st,
> -			      u8 *ssid, size_t ssid_len);
> +			      u8 *ssid, size_t ssid_len,
> +			      u8 *ie, size_t ie_len);
>  void ieee80211_send_pspoll(struct ieee80211_local *local,
>  			   struct ieee80211_sub_if_data *sdata);
> =20
> --- wireless-testing.orig/net/mac80211/mlme.c	2009-02-13 12:47:56.0000000=
00 +0200
> +++ wireless-testing/net/mac80211/mlme.c	2009-02-13 12:48:45.000000000 +0=
200
> @@ -139,7 +139,8 @@ static void add_extra_ies(struct sk_buff
> =20
>  /* also used by scanning code */
>  void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *d=
st,
> -			      u8 *ssid, size_t ssid_len)
> +			      u8 *ssid, size_t ssid_len,
> +			      u8 *ie, size_t ie_len)
>  {
>  	struct ieee80211_local *local =3D sdata->local;
>  	struct ieee80211_supported_band *sband;
> @@ -149,7 +150,7 @@ void ieee80211_send_probe_req(struct iee
>  	int i;
> =20
>  	skb =3D dev_alloc_skb(local->hw.extra_tx_headroom + sizeof(*mgmt) + 200=
 +
> -			    sdata->u.sta.ie_probereq_len);
> +			    ie_len + sdata->u.sta.ie_probereq_len);
>  	if (!skb) {
>  		printk(KERN_DEBUG "%s: failed to allocate buffer for probe "
>  		       "request\n", sdata->dev->name);
> @@ -196,6 +197,7 @@ void ieee80211_send_probe_req(struct iee
>  		*pos =3D rate->bitrate / 5;
>  	}
> =20
> +	add_extra_ies(skb, ie, ie_len);
>  	add_extra_ies(skb, sdata->u.sta.ie_probereq,
>  		      sdata->u.sta.ie_probereq_len);
> =20
> @@ -891,7 +893,7 @@ static void ieee80211_direct_probe(struc
>  	 * will not answer to direct packet in unassociated state.
>  	 */
>  	ieee80211_send_probe_req(sdata, NULL,
> -				 ifsta->ssid, ifsta->ssid_len);
> +				 ifsta->ssid, ifsta->ssid_len, NULL, 0);
> =20
>  	mod_timer(&ifsta->timer, jiffies + IEEE80211_AUTH_TIMEOUT);
>  }
> @@ -1116,7 +1118,8 @@ static void ieee80211_associated(struct=20
>  			} else
>  				ieee80211_send_probe_req(sdata, ifsta->bssid,
>  							 ifsta->ssid,
> -							 ifsta->ssid_len);
> +							 ifsta->ssid_len,
> +							 NULL, 0);
>  			ifsta->flags ^=3D IEEE80211_STA_PROBEREQ_POLL;
>  		} else {
>  			ifsta->flags &=3D ~IEEE80211_STA_PROBEREQ_POLL;
> @@ -1125,7 +1128,8 @@ static void ieee80211_associated(struct=20
>  				ifsta->last_probe =3D jiffies;
>  				ieee80211_send_probe_req(sdata, ifsta->bssid,
>  							 ifsta->ssid,
> -							 ifsta->ssid_len);
> +							 ifsta->ssid_len,
> +							 NULL, 0);
>  			}
>  		}
>  	}
> --- wireless-testing.orig/net/mac80211/scan.c	2009-02-13 12:47:56.0000000=
00 +0200
> +++ wireless-testing/net/mac80211/scan.c	2009-02-13 12:48:45.000000000 +0=
200
> @@ -367,7 +367,8 @@ void ieee80211_scan_work(struct work_str
>  			ieee80211_send_probe_req(
>  				sdata, NULL,
>  				local->scan_req->ssids[i].ssid,
> -				local->scan_req->ssids[i].ssid_len);
> +				local->scan_req->ssids[i].ssid_len,
> +				local->scan_req->ie, local->scan_req->ie_len);
>  		next_delay =3D IEEE80211_CHANNEL_TIME;
>  		break;
>  	}
> --- wireless-testing.orig/net/wireless/nl80211.c	2009-02-13 12:47:56.0000=
00000 +0200
> +++ wireless-testing/net/wireless/nl80211.c	2009-02-13 12:48:45.000000000=
 +0200
> @@ -2286,6 +2286,7 @@ static int nl80211_trigger_scan(struct s
>  	struct wiphy *wiphy;
>  	int err, tmp, n_ssids =3D 0, n_channels =3D 0, i;
>  	enum ieee80211_band band;
> +	size_t ie_len;
> =20
>  	err =3D get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
>  	if (err)
> @@ -2327,9 +2328,15 @@ static int nl80211_trigger_scan(struct s
>  		goto out_unlock;
>  	}
> =20
> +	if (info->attrs[NL80211_ATTR_IE])
> +		ie_len =3D nla_len(info->attrs[NL80211_ATTR_IE]);
> +	else
> +		ie_len =3D 0;
> +
>  	request =3D kzalloc(sizeof(*request)
>  			+ sizeof(*ssid) * n_ssids
> -			+ sizeof(channel) * n_channels, GFP_KERNEL);
> +			+ sizeof(channel) * n_channels
> +			+ ie_len, GFP_KERNEL);
>  	if (!request) {
>  		err =3D -ENOMEM;
>  		goto out_unlock;
> @@ -2340,6 +2347,12 @@ static int nl80211_trigger_scan(struct s
>  	if (n_ssids)
>  		request->ssids =3D (void *)(request->channels + n_channels);
>  	request->n_ssids =3D n_ssids;
> +	if (ie_len) {
> +		if (request->ssids)
> +			request->ie =3D (void *)(request->ssids + n_ssids);
> +		else
> +			request->ie =3D (void *)(request->channels + n_channels);
> +	}
> =20
>  	if (info->attrs[NL80211_ATTR_SCAN_FREQUENCIES]) {
>  		/* user specified, bail out if channel not found */
> @@ -2380,6 +2393,12 @@ static int nl80211_trigger_scan(struct s
>  		}
>  	}
> =20
> +	if (info->attrs[NL80211_ATTR_IE]) {
> +		request->ie_len =3D nla_len(info->attrs[NL80211_ATTR_IE]);
> +		memcpy(request->ie, nla_data(info->attrs[NL80211_ATTR_IE]),
> +		       request->ie_len);
> +	}
> +
>  	request->ifidx =3D dev->ifindex;
>  	request->wiphy =3D &drv->wiphy;
> =20
>=20

--=-fETSyGV/r6u97WOd+xrJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJlVKtAAoJEKVg1VMiehFYJJUQALtvT6qrINRCU5/Mq1pWiPvs
JHTPjhsSDZu3hXgmUoKohdDoSeNivqI1fOkFegQlS5LCqfQxsODhFsBSSb5kEDpb
a7SOgB8Hqio8FyoXuwS+OC1PUmn2mNkNPRpndjp5Ff+AOvnJ4HXqf06jce8cclWd
hAjk2+YgUjuYMMci2GmzI8zSucZTb9hc/kXIyV3hvgm937tlWKiZ0PXJxmcNCNDv
KBDBz07Q08GlRDaCNcuvpoCA5IsbijiXieKBfVQX+xwJG75mU93yHdYOB+Eea2f1
kQn2edA0qTfEdp2Rgsr1tIhdpruKTDvJJ0Fhqdyel5UAxKTjapEbhvDLuoV7ri6H
p4I4xwBd8vmLJ2jPmEYFJ3Q4oLVwkjZQre0f5/DjbhGRnnaAHod4UwvMD/qOax/g
8ZYQ7Wh+QzBH1clQoe+wlEKTOIm2TYDTtXh4J9YLHZLhI7BFlMQCK9BDtASuZs3w
BpfuK5W+xH4dNbWkMJJSG4YXlanUPtX2gr2uD2t1M6aw2wZJQSgzhSDoohTY3WLK
BjSE6xCDI6vvb3/7vMTjEKFAI7AqWtzTUYOaL9a3RTXckOeV6ZUz9I0gEijDHYZW
NEHUo0mCxWd7jy8RL87nyrtdk3XOmsWmWgJtNnZvS2zd2KFbTprhOm4dfkTns6SN
/+Is8K5Dz3taDhQUEGjG
=U1da
-----END PGP SIGNATURE-----

--=-fETSyGV/r6u97WOd+xrJ--

