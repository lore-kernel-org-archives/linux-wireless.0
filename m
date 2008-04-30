Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55658 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755907AbYD3UIR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Apr 2008 16:08:17 -0400
Subject: RE: [RFC/RFT 4/4] mac80211: use multi-queue master netdevice
From: Johannes Berg <johannes@sipsolutions.net>
To: "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	"Rindjunsky, Ron" <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomasw@gmail.com>,
	Ivo van Doorn <ivdoorn@gmail.com>
In-Reply-To: <D5C1322C3E673F459512FB59E0DDC32904FE144F@orsmsx414.amr.corp.intel.com>
References: <20080430124055.091382000@sipsolutions.net>
	 <20080430130051.397094000@sipsolutions.net>
	 <D5C1322C3E673F459512FB59E0DDC32904FE144F@orsmsx414.amr.corp.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-IfX5slhbi/cr/hHkbFhB"
Date: Wed, 30 Apr 2008 22:07:27 +0200
Message-Id: <1209586047.18659.93.camel@johannes.berg> (sfid-20080430_220808_027952_FEECB17D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-IfX5slhbi/cr/hHkbFhB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > +void ieee80211_start_queue(struct ieee80211_hw *hw, int queue)
> > +{
> > +	struct ieee80211_local *local =3D hw_to_local(hw);
> > +#ifdef CONFIG_MAC80211_QOS
> > +	netif_start_subqueue(local->mdev, queue);
> > +#else
> > +	WARN_ON(queue !=3D 0);
> > +	netif_start_queue(local->mdev);
> > +#endif
> > +}
> > +EXPORT_SYMBOL(ieee80211_start_queue);
> > +
>=20
> I would suggest that you enable the netdev feature flag for
> NETIF_F_MULTI_QUEUE on devices when you create them.  That way you can
> have things like ieee80211_start_queue() key on that instead of a
> compile-time option, in case wireless devices come along that won't
> support multiple queues, if that's possible.=20

Ah. I thought that then I'd just create a device with alloc_mq with a
single queue.

> If you think this is a decent idea, I'd suggest that any function that
> has a compile-time check for multiqueue being changed to use the runtime
> check.  Then in your device setup, where you call netdev_alloc_mq(),
> there you set the flag NETIF_F_MULTI_QUEUE based on the device features.

Hah, indeed, I don't currently set it at all. Yes, I guess I should do
it that way.

> Other than that, this patch looks great.  Exciting to see this starting
> to take flight.

:)

johannes

--=-IfX5slhbi/cr/hHkbFhB
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASBjRfqVg1VMiehFYAQKn7A/9F/HBqLJyKCqADyvK255Mw5JmrSvlg461
HAyS4LxgcvgVRZz8P6EQMzWvSvLC+A2mvuCkgoDtu3jLwmt5w2uLz+zJBxUtAeJN
pDM0FruiUnzJ4s2YkNRLnn3xePtwVs4HfX99p9ipv3FPAIHRGYnHOHwya/9bpVWD
LMLPUA3Mc4rOeyzObG2TNEPsFWE1r8XFG9TmGwFN1myxA+DO7evYXLhxFLcw/5qW
WqGp6lbLsUW3HzhPlPJQkjgjS5Nlb7Fa4RMcmfKRZybmCZefufaVOWVYazTQt9cV
ozXeUfc7VprfRysWO9pTbib9bVOC+6H+HKyXoZ3Qbn6eoWqQUeHu46L7Qx3rQkH9
LV9jAlqlUt8eJZSmljH09AP4yeT01mzi+m4CPnVPxvIH/jVNeapNEfxEfwDQUEle
GAFTEksEBZlDyalXdIIOHs2vovvkkzxFMQmZWlkghSlNGaezRdk0XQGQVabvUTCN
+LfeitTAY5Esu/jm6c3ytdNF1zwCzaY08MYPjZfigjGIQoShfCFxjPCfbIzmQVL4
sfp2qgFYR+E7dzZOUpJCXdpAE4TJCD3aTgit9l/oIsLyvIA6bl/nr9CdCLJ28ClF
NivDO0cbqZGUngs7x5/xeMD4If0eUCIgXpxPa0DjKRpQh7esVkJhXv35luUhVBuE
8kzSLVYwXX8=
=mP4V
-----END PGP SIGNATURE-----

--=-IfX5slhbi/cr/hHkbFhB--

