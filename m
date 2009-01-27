Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60042 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbZA0ItQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2009 03:49:16 -0500
Subject: Re: [PATCH] mac80211: do not TX injected frames when not allowed
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, Jouni.Malinen@atheros.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1233015771-1309-1-git-send-email-lrodriguez@atheros.com>
References: <1233015771-1309-1-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-KsGmsE4Gc1MsZbWOhptd"
Date: Tue, 27 Jan 2009 09:49:08 +0100
Message-Id: <1233046148.4012.6.camel@johannes.local> (sfid-20090127_094920_638110_445A89B7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-KsGmsE4Gc1MsZbWOhptd
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-01-26 at 16:22 -0800, Luis R. Rodriguez wrote:
> Monitor mode is able to TX by using injected frames. We should
> not allow injected frames to be sent unless allowed by regulatory
> rules. Since AP mode uses a monitor interfaces to transmit
> management frames we have to take care to not break AP mode as
> well while resolving this. We deal with this by allowing compliant
> APs solutions to inform mac80211 if their monitor interface is
> intended to be used for an AP by setting a cfg80211 flag for the
> monitor interface. hostapd, for example, currently does its own
> checks to ensure AP mode is not used on channels which require radar
> detection. Once such solutions are available it can can enable this
> flag.
>=20
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>=20
> This now works, I moved the check as recommended by Johannes to
> ieee80211_monitor_start_xmit(), the issues I ran into earlier seem
> to be due to a work around set in place for 11w.
>=20
>  include/linux/nl80211.h |    3 +++
>  include/net/cfg80211.h  |    4 ++++
>  net/mac80211/tx.c       |   14 ++++++++++++++
>  net/wireless/nl80211.c  |    1 +
>  4 files changed, 22 insertions(+), 0 deletions(-)
>=20
> diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
> index 76aae3d..3357907 100644
> --- a/include/linux/nl80211.h
> +++ b/include/linux/nl80211.h
> @@ -705,6 +705,8 @@ enum nl80211_reg_rule_flags {
>   * @NL80211_MNTR_FLAG_OTHER_BSS: disable BSSID filtering
>   * @NL80211_MNTR_FLAG_COOK_FRAMES: report frames after processing.
>   *	overrides all other flags.
> + * @NL80211_MNTR_FLAG_AP_MGT: this monitor interface is used for AP mode
> + * 	to be able to inject management frames.
>   *
>   * @__NL80211_MNTR_FLAG_AFTER_LAST: internal use
>   * @NL80211_MNTR_FLAG_MAX: highest possible monitor flag
> @@ -716,6 +718,7 @@ enum nl80211_mntr_flags {
>  	NL80211_MNTR_FLAG_CONTROL,
>  	NL80211_MNTR_FLAG_OTHER_BSS,
>  	NL80211_MNTR_FLAG_COOK_FRAMES,
> +	NL80211_MNTR_FLAG_AP_MGT,
> =20
>  	/* keep last */
>  	__NL80211_MNTR_FLAG_AFTER_LAST,
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index dd1fd51..fe65c64 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -255,6 +255,9 @@ struct station_info {
>   * @MONITOR_FLAG_CONTROL: pass control frames
>   * @MONITOR_FLAG_OTHER_BSS: disable BSSID filtering
>   * @MONITOR_FLAG_COOK_FRAMES: report frames after processing
> + * @MONITOR_FLAG_AP_MGT: informs us this monitor interface is
> + *	used by a driver for AP mode to be able to inject management
> + * 	frames.
>   */
>  enum monitor_flags {
>  	MONITOR_FLAG_FCSFAIL		=3D 1<<NL80211_MNTR_FLAG_FCSFAIL,
> @@ -262,6 +265,7 @@ enum monitor_flags {
>  	MONITOR_FLAG_CONTROL		=3D 1<<NL80211_MNTR_FLAG_CONTROL,
>  	MONITOR_FLAG_OTHER_BSS		=3D 1<<NL80211_MNTR_FLAG_OTHER_BSS,
>  	MONITOR_FLAG_COOK_FRAMES	=3D 1<<NL80211_MNTR_FLAG_COOK_FRAMES,
> +	MONITOR_FLAG_AP_MGT		=3D 1<<NL80211_MNTR_FLAG_AP_MGT,
>  };
> =20
>  /**
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index 7b013fb..e752f6d 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -1432,11 +1432,25 @@ int ieee80211_master_start_xmit(struct sk_buff *s=
kb, struct net_device *dev)
>  int ieee80211_monitor_start_xmit(struct sk_buff *skb,
>  				 struct net_device *dev)
>  {
> +	struct ieee80211_sub_if_data *sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
>  	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
> +	struct ieee80211_channel *chan =3D local->hw.conf.channel;
>  	struct ieee80211_radiotap_header *prthdr =3D
>  		(struct ieee80211_radiotap_header *)skb->data;
>  	u16 len_rthdr;
> =20
> +	/* Frame injection is not allowed if beaconing is not allowed

Comment style, /* on a single line please :)

> +	 * or if we need radar detection. Beaconing is usually not allowed when
> +	 * the mode or operation (Adhoc, AP, Mesh) does not support DFS.
> +	 * Since AP mode uses monitor interfaces to inject/TX management
> +	 * frames we make AP mode the exception to this rule as its
> +	 * implementation can deal with radar detection by itself. */

and end with */ on its own line.

> +	if (WARN_ON(sdata->vif.type !=3D NL80211_IFTYPE_MONITOR))
> +		return TX_DROP;

Huh? You're in monitor_start_xmit. If that goes wrong, something is
horribly broken and beyond WARN_ON. Please just remove this.

Other than that, looks good.

johannes

--=-KsGmsE4Gc1MsZbWOhptd
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJfsqCAAoJEKVg1VMiehFYCy4P/1t/TwOEcN72xAP5qHhEfRDw
1tDKI7c/4w8jzmxZnHfnqwAEOz5HkdQEHIFROTh95pYxsL4IDDEAblrMSDSsSb7J
L7fASl7Y6WphqsxQpTB9/sySX5De7OBXC71dJf4ngoKHRMh1EWJnAwwZb0WM7qw4
sLkv5aP7iE/Vumd7DA0zILhp1Get6IH9rcQIY3Jz9tINEQ3gOBwx+edG1ptTYTw+
riSXSUhwzD7P9vPy+a5s9W7urPZ1Vwlebff/YeYh6830fWKbjOja0EQgWD6ZekCN
bTMoFTtCvI9N/1YCJ49wh0eJyuEe5dscHl7L41pbdwRiFbMh1OMgcpM8i9fYaHQO
391C7m+7dSyi6tVhV6qa96bvx4bDgQLs3AjAMJRE0H0ylo3ZbOjoslAIdGvo8SbQ
JdR31bZ2FrlDr/5NJjEjaCpJ0N8q1zco1QLyBKdzChrzUaV86e1fRrA1IpgomUkg
j/3/eDyhPfX58OFllMjvrDnM69ffDZ+YZJgzigGaGQPqvGfwmVul2UCkNj79qVDo
QNhv5H5sUWzVocrCOn3pt8HIBW+Y5PJFR6GPy4JsN4SfjKrBH5WrVbk++pHF5gr4
SaYNTFgXcbBtST1zm/Wqy1VBLReSqulQr70cRpZFJ5nw/kOSfPQ56Fk0Kblha1kD
t4cdtqEPVgkrDPWoaQr2
=5Cfp
-----END PGP SIGNATURE-----

--=-KsGmsE4Gc1MsZbWOhptd--

