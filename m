Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57057 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760740AbYEPOvF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2008 10:51:05 -0400
Subject: iwlwifi injection bug
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Andy Green <andy@warmcat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-V1qlc81CBWPM8iOUuyuZ"
Date: Fri, 16 May 2008 15:47:11 +0200
Message-Id: <1210945631.6381.11.camel@johannes.berg> (sfid-20080516_165137_266097_F65A104F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-V1qlc81CBWPM8iOUuyuZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

I don't know why you want to disallow sending frames when in monitor
mode (especially since reportedly it works), but this is not a good way
to go about it:

static int iwl4965_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
{
        struct iwl_priv *priv =3D hw->priv;

        IWL_DEBUG_MAC80211("enter\n");

        if (priv->iw_mode =3D=3D IEEE80211_IF_TYPE_MNTR) {
                IWL_DEBUG_MAC80211("leave - monitor\n");
                return -1;
        }

You see, this will cause mac80211 to resubmit the frame and most likely
will totally mess up queue handling and various other things.

johannes

--=-V1qlc81CBWPM8iOUuyuZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASC2QXqVg1VMiehFYAQJYNw//Vj6GOwtgrclY3efSeuv+5ZWBF+Cqsytm
7z7RVkQwwxVIqSsd3z8FYgUFyh6aP7ZDM2d+SlRu1bsxBR3JO8x5oVyuzKq9bcDF
eb3KcHZhhErU1V8MEkGHy+rabHPIi7RzaHW5bSCc/G/B354GcY9JQXecT0uM/Kou
AhK1N/4vSW9P7sp6WQDe38+ET9mXuinE90YWmnfpvyg1DdJ/0VI+Y9PMGiepehJ8
R8Q73rwl64gNLH9qzaqTXEJb947VZ8sOLH8EEtnZG7D4kJll/buywd2Mv5pDyP0s
gglLniSOGdMmJBaJ4oC3Kha7YYFgr/ewo0tjiT5/foXZeMsK3aIYpssSPHOOfdnF
VsDFfqmaaLJtu3hUzR/ZEmrb0ulmGJR637TtKvxotyFOGeeVaNZWd3+0OdUYDcE/
mh2ltR6xfsImHA5KKX8heLWPcrmqy35It3g4FyYJ8Oq3OdbIHHN8GAp2LOXOTTi4
NAzqZJFrsI/89GoKfaQIiN+18xNof440NifGIph9fkdhgMf5NcSwbGp/cyL7vh0H
ck6ce9ypjGuxq3ZjtIUsnmX719rqtPDaXZkTdZjXMl7oAi6ZO6MG/wc4aikwy/Uf
jlKP2p3IN1JrA616rdMKsFxkgHaOQ8WiT0FiSDJ+ECW8AZ6OHZKX6GkPWoIip56F
bGnKpCTkYfU=
=xug4
-----END PGP SIGNATURE-----

--=-V1qlc81CBWPM8iOUuyuZ--

