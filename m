Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58536 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbYGSAwF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2008 20:52:05 -0400
Subject: Re: [RFC 3/3] mac80211: fix requeue race
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: David Miller <davem@davemloft.net>,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
In-Reply-To: <20080719004518.846156000@sipsolutions.net> (sfid-20080719_024555_879060_770F8C6B)
References: <20080719004147.795661000@sipsolutions.net>
	 <20080719004518.846156000@sipsolutions.net>
	 (sfid-20080719_024555_879060_770F8C6B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-UOu6zb0TdA07RCEb3gol"
Date: Sat, 19 Jul 2008 02:52:00 +0200
Message-Id: <1216428721.27738.67.camel@johannes.berg> (sfid-20080719_025209_394099_D0D8A251)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UOu6zb0TdA07RCEb3gol
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +	/*
> +	 * We just requeued the all the frames that were in the
> +	 * removed queue, and since we might miss a softirq we do
> +	 * netif_schedule_queue.  ieee80211_wake_queue is not used
> +	 * here as this queue is not necessarily stopped
> +	 */
> +	netif_schedule_queue(netdev_get_tx_queue(local->mdev, agg_queue));

Come to think of it, we should probably do

netif_schedule_queue(netdev_get_tx_queue(local->mdev, ieee802_1d_to_ac[tid]=
));

since we just drained that agg_queue in favour of the tid one.

instead

--=-UOu6zb0TdA07RCEb3gol
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIgTqtAAoJEKVg1VMiehFYX3QP/Alp1fbh3DyCsThVhbgUG6Fv
o4kgG4KMN/SSMpgxabsZHozmwzRgdQuGi8f9QdS3n6UkPTbnaNoavSyTAuFc94+F
GIpa14SQGb4PLGsYXiQL0x5n7kS4hAKVc7jCSO48CHsl2zCwgzEdRbmwR1REq3kt
/cCWXzqpJjrMp4arhtV2pYV5CVJ9J1Jo5YZiWP97IejB4aKGsk7om5rKdM6Mg/dB
btoNZVMkA91Oq/OsdSfmGdBvjDX/FXhdkmQu8yRraL/YNUzMt3EoIreI2oy7/pLb
xUfouo8ehG3f5shWEklEpApQVK7iuOKJBOhrwWjOjS6JiTz7jLDP4baExWpxSkjD
uQ4RY3LLC//QWiidUOVmjmcPey8QCEoB5PEGDRskT+D6Fc/zxJ5qnyrubHaqefmV
iFSBG9WaLEzQz5K/iL4qN+jWgOzAeCUh0uZpiO/PvqLUo4C5o7m6R6H2J0U/BYMf
93pH/7MW/3CDTN/OYJahGEWDqay28Vx6cfH5oex4WulGHxjinnOxcKP+Z8aMTJJS
ELma67Ll01ydamp0hWfjyLKvG8Qr1PTbZilK8A1nCTGaPx1nkYua8SaSKyoHaYBZ
ghilQ+ZjKMEk178Zs3k8dD9VnzBp07rAfdtVEazPmmtTkH6i1xPPbvNMetXZS79A
RMsUkXxtXPbL2r6aKBzr
=IXtc
-----END PGP SIGNATURE-----

--=-UOu6zb0TdA07RCEb3gol--

