Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:48692 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbXC2LHv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Mar 2007 07:07:51 -0400
Subject: Re: [patch 5/5] IEEE 802.11n management action frame handling
From: Johannes Berg <johannes@sipsolutions.net>
To: mohamed <mabbas@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1174909425.1364.63.camel@dell-4965.jf.intel.com>
References: <1174909425.1364.63.camel@dell-4965.jf.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-iLFD3p+OiwexCVijOkip"
Date: Wed, 28 Mar 2007 22:15:01 +0200
Message-Id: <1175112901.5151.141.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-iLFD3p+OiwexCVijOkip
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-03-26 at 04:43 -0700, mohamed wrote:

> +static void ieee80211_send_addba_resp(struct net_device *dev,
> +				      struct ieee80211_mgmt *mgmt_src,
> +				      size_t len,
> +				      u16 status)
> +{
> +	struct ieee80211_sub_if_data *sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
> +        struct ieee80211_if_sta *ifsta =3D &sdata->u.sta;
> +	struct sk_buff *skb;
> +	struct ieee80211_mgmt *mgmt;
> +
> +	skb =3D dev_alloc_skb(sizeof(*mgmt) + 50 );

Why +50? And isn't sizeof(ieee80211_mgmt) a bit dangerous since that
structure might increase in size?

> +static void ieee80211_rx_mgmt_action(struct net_device *dev,
> +				     struct ieee80211_if_sta *ifsta,
> +				     struct ieee80211_mgmt *mgmt,
> +				     size_t len)
> +{
> +	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
> +
> +	if (len < 24 + 1) {

Why 25? Some #define maybe?

> +			printk(KERN_ERR "%s: recieved back unsupported \n",
> +								dev->name);

"Received unsupported block-ack action"? And you need a ratelimit on
that printk or somebody can flood you with kernel messages by sending
tiny frames with invalid fields there. Possibly on other printks too.

Oh and one more smallish thing: Can you post your patches 1-5/5 as
replies to 0/5? Makes the whole thing more readable in most mail
programs, and I think it also simplifies John's life when merging.
=20
johannes

--=-iLFD3p+OiwexCVijOkip
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGCszF/ETPhpq3jKURAhOSAKCl39AHh6KPHM+g4bwGtfas/ZEZ4QCfUZqJ
6Hfj+qOjMnNiET0/ieHIC2g=
=Jfq8
-----END PGP SIGNATURE-----

--=-iLFD3p+OiwexCVijOkip--

