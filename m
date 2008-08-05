Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41007 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756525AbYHETBM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2008 15:01:12 -0400
Subject: Re: [PATCH] mac80211: fix use of skb->cb for mesh forwarding
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <48989ce7.2533440a.381b.ffff88f4@mx.google.com> (sfid-20080805_203321_417358_2008E391)
References: <48989ce7.2533440a.381b.ffff88f4@mx.google.com>
	 (sfid-20080805_203321_417358_2008E391)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-p9TiLbKSjE+JMK5qJLD8"
Date: Tue, 05 Aug 2008 21:00:09 +0200
Message-Id: <1217962809.3603.56.camel@johannes.berg> (sfid-20080805_210117_145734_9E82ABA0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-p9TiLbKSjE+JMK5qJLD8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


>  static ieee80211_rx_result debug_noinline
> +ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
> +{


> @@ -1683,6 +1697,8 @@ static void ieee80211_invoke_rx_handlers(struct iee=
e80211_sub_if_data *sdata,
>  	/* must be after MMIC verify so header is counted in MPDU mic */
>  	CALL_RXH(ieee80211_rx_h_remove_qos_control)
>  	CALL_RXH(ieee80211_rx_h_amsdu)
> +	if (ieee80211_vif_is_mesh(&sdata->vif))
> +		CALL_RXH(ieee80211_rx_h_mesh_fwding);

CALL_RXH cannot be used like that, it's not a statement, you should
probably make it one or put the vif_is_mesh test into the
ieee80211_rx_h_mesh_fwding function instead.

> +#define skb_get_80211_fc(skb) (((struct ieee80211_hdr *) skb->data) \
> +				->frame_control)
> +	if (ieee80211_vif_is_mesh(&osdata->vif) &&

I'd rather just define the hdr struct you have two lines down before,
it'll just be optimised out when mesh isn't there.

johannes

--=-p9TiLbKSjE+JMK5qJLD8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJImKM1AAoJEKVg1VMiehFYMX4QALfUOouhzmVsiOa4fNLKxvPP
veCPRIyXB10oYKc6drdFOReEjfFsVlwY9femwqXxP3hWPA4wtpkGea9XbVmOA3A+
9wby0wIrkX15TLYf2j8fzy9r5x/24bsIEVLLTYEBVuns4vDUJglrv53IG4aLtiHh
yS3C8TBuUOIJkNkgqq6M97ERZIpxKeV9Zct5iXu/tToAMBubIRxwjaeTU7+ZWXXm
sH1xDRfiukw12W8N+zQ6hxbyRgognqNg63OrLr7t68VRh+tyDhVCUGO6dsgf+g4g
mSCQbh0VU6I8V8IT0F5cgPrNcvi8piikXBYfkHrhmJU72PM/qCEGyQ7E7Nc8e+SP
KATtGDMMIAptZfIz+Iar0FggbFdthY3DeLe34oHVNKVFBG1LJdAgjU3Bh74c/pSg
qVilVvhdCa2FR82SXUVybE26QPsLRW7yo3R6PEfkLLF6bQPeNHMwYKiT8799ODfa
vsZMvdAWr2Ep0H9WlSrxJo5VqvR6J6ofKITbDaz3WZl5W2Hc4eRfJZai0DRUFPb6
dzD6DmHtfUU44lsJCztfLYN7379N2xnX+PpnxdNTyW5noSlh/EHCIwXsc3ZlSt3O
tJY+mWpw2KUzYbui0eQcID2zi/iNtO8CbwFsujnfhKDrxmlGDoeW+A1F4R9+acua
B9fhkSxhFY+78JTHD0FR
=+6MX
-----END PGP SIGNATURE-----

--=-p9TiLbKSjE+JMK5qJLD8--

