Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55828 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbZGaNjq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 09:39:46 -0400
Subject: Re: [PATCH] mac80211: use beacons for connection monitoring
From: Johannes Berg <johannes@sipsolutions.net>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1249046380.6418.6.camel@maxim-laptop>
References: <1248903159-17024-1-git-send-email-reinette.chatre@intel.com>
	 <1249024097.7653.6.camel@maxim-laptop>
	 <1249026181.29587.14.camel@johannes.local>
	 <1249046380.6418.6.camel@maxim-laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-tcASE0EEJFeGMn9m54LG"
Date: Fri, 31 Jul 2009 15:39:36 +0200
Message-Id: <1249047576.29587.76.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tcASE0EEJFeGMn9m54LG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-07-31 at 16:19 +0300, Maxim Levitsky wrote:

> First patch makes the probe requests be retried (and with it and only
> it, my connection is very stable, it never retries more that 3 times,
> and I set max retries to 5)
>=20
> Second patch, trivial one bumps up the timeouts (30 for ping, and 1/2
> for response, so device won't send out frames too often)

Thank you!

> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index ee83125..38ef7f2 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -31,6 +31,7 @@
>  #define IEEE80211_AUTH_MAX_TRIES 3
>  #define IEEE80211_ASSOC_TIMEOUT (HZ / 5)
>  #define IEEE80211_ASSOC_MAX_TRIES 3
> +#define IEEE80211_ASSOC_RETRIES 5

I'd prefer that be named PROBE_TRIES or something like that?

> @@ -1209,6 +1210,7 @@ static void ieee80211_mgd_probe_ap(struct ieee80211=
_sub_if_data *sdata,
>  	ieee80211_recalc_ps(sdata->local, -1);
>  	mutex_unlock(&sdata->local->iflist_mtx);
> =20
> +	sdata->u.mgd.probe_miss_count =3D 0;
>  	ssid =3D ieee80211_bss_get_ie(&ifmgd->associated->cbss, WLAN_EID_SSID);
>  	ieee80211_send_probe_req(sdata, ifmgd->associated->cbss.bssid,
>  				 ssid + 2, ssid[1], NULL, 0);

That appears to be in the wrong place. Shouldn't that be in the
_set_associated function? Otherwise you're always setting it to 0 before
sending the probe?

> @@ -2072,17 +2074,36 @@ static void ieee80211_sta_work(struct work_struct=
 *work)
>  	if (ifmgd->flags & (IEEE80211_STA_BEACON_POLL |
>  			    IEEE80211_STA_CONNECTION_POLL) &&
>  	    ifmgd->associated) {
> +
> +		u8 bssid[ETH_ALEN];

drop that empty line please

> +		const u8 *ssid;
> +
> +		memcpy(bssid, ifmgd->associated->cbss.bssid, ETH_ALEN);
> +
>  		if (time_is_after_jiffies(ifmgd->probe_timeout))
>  			run_again(ifmgd, ifmgd->probe_timeout);
> -		else {
> -			u8 bssid[ETH_ALEN];
> +
> +		else if (ifmgd->probe_miss_count < IEEE80211_ASSOC_RETRIES) {
> +
> +			printk(KERN_DEBUG "No probe response from AP %pM"

and that one too

> +				" after %dms, try %d\n", bssid,
> +				(1000 * IEEE80211_PROBE_WAIT)/HZ,
> +				(int)ifmgd->probe_miss_count);
> +
> +			ifmgd->probe_miss_count++;
> +			ifmgd->probe_timeout =3D jiffies + IEEE80211_PROBE_WAIT;
> +			run_again(ifmgd, ifmgd->probe_timeout);
> +
> +			ssid =3D ieee80211_bss_get_ie(&ifmgd->associated->cbss, WLAN_EID_SSID=
);
> +			ieee80211_send_probe_req(sdata, ifmgd->associated->cbss.bssid,
> +				ssid + 2, ssid[1], NULL, 0);
> +		} else {

Shouldn't this just call _probe_ap() again? After you move the setting
to 0 out of it, that is?

> From: Maxim Levitsky <maximlevitsky@gmail.com>
>=20
> Do a poll every 30 seconds, and wait for response half a second
>=20
> Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> ---
>=20
>  net/mac80211/mlme.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>=20
>=20
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 38ef7f2..a8ab40c 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -42,13 +42,13 @@
>   * Time the connection can be idle before we probe
>   * it to see if we can still talk to the AP.
>   */
> -#define IEEE80211_CONNECTION_IDLE_TIME	(2 * HZ)
> +#define IEEE80211_CONNECTION_IDLE_TIME	(30 * HZ)
>  /*
>   * Time we wait for a probe response after sending
>   * a probe request because of beacon loss or for
>   * checking the connection still works.
>   */
> -#define IEEE80211_PROBE_WAIT		(HZ / 5)
> +#define IEEE80211_PROBE_WAIT		(HZ / 2)


Fine with me.

johannes

--=-tcASE0EEJFeGMn9m54LG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKcvQUAAoJEODzc/N7+QmaH6AP/RCLOlWlaq+Jrwp7j0OUkpEX
HxwAbQYNVCT/qMSCC0KG/M2sMeN80UMGnHTwwBCnGyMTWiuuYK2tr3oqWkhfouv/
d7RrmOgbDH9x23tpCoYoiQgD0o5ZB1jLeC4MBNEX6FJsD4gzPl2pFf243wTXyQa0
GGJ3at+L03jdjsrMUv1YluFuIZ+qJgysmrUlna4LiOaDfO8QkIBviGfm2PRg513H
ihouDEaXJ542pjqDyEEdoaC2AOKnVez5CW9Elj2nQ407uizpnJ30C3QWfrKGLWp+
4xnr2if3asyC56dCP4FoXVWXAo33epZAav2Vb3png8wv4VorFeWk35muHJ+G5ke4
A+t4z6rUGk48l8ujw64fQ95Ogigt0kZo3bTmeOJ09TTm3TVmlTcF5yyGTW1Pj6Ve
J7lo8TvYaV1IeOS+xcc9sV4irMB051V067r1ee3RBc9T8nsTdYccYTZ0itFlcNQo
D1/TZVFoqVQ0tY+Yop/iZrpgjbh1WaFXLAmCOZIAM8QTrkieJ2wRgbOCzwuKUw06
tAlBe3eyO0oshs6llTaPealYio/NQ0dNCun4lPl0RV4DvnmJKBVctn1+Sgqn0YYA
nfpxQtSX1Cd2l2i5do/wFHYlsYxwwVytRlylYGq2rRmuwPMnVrfC5wG7S8p7zGzS
XFoO3PqbcFiRdkl21wYk
=3YLk
-----END PGP SIGNATURE-----

--=-tcASE0EEJFeGMn9m54LG--

