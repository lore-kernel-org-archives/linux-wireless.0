Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33593 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756436AbZEOIi4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2009 04:38:56 -0400
Subject: Re: [PATCH] mac80211: fix some unforgotten items on suspend
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1242375725.5799.39.camel@johannes.local>
References: <1242362919-9788-1-git-send-email-lrodriguez@atheros.com>
	 <1242375725.5799.39.camel@johannes.local>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-jq3I2uqoXOVYmxPohMZm"
Date: Fri, 15 May 2009 10:38:27 +0200
Message-Id: <1242376707.5799.45.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jq3I2uqoXOVYmxPohMZm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-05-15 at 10:22 +0200, Johannes Berg wrote:

> > +++ b/net/mac80211/pm.c
> > @@ -18,6 +18,10 @@ int __ieee80211_suspend(struct ieee80211_hw *hw)
> > =20
> >  	flush_workqueue(local->hw.workqueue);
> > =20
> > +	/* Don't stuff our workqueue during suspend->resume cycle */
> > +	del_timer_sync(&local->dynamic_ps_timer);
> > +	cancel_work_sync(&local->dynamic_ps_enable_work);
> > +
>=20
> ack, but you forgot to add a comment why dynamic_ps_disable_work doesn't
> need to be handled (actually it does need to handled with the current
> code but shouldn't be necessary... up for a challenge? -- why? and how
> to fix that better than handling it here?)
>=20
> If you ever suspend in AP mode there's also an issue with each station's
> cleanup timer, and for mesh each station's plink timer.

Hmm, actually, this isn't safe. We might still be receiving frames at
this point, which would start the timer again.

> I don't think that helps, like I said the timers are still set up, you
> need to actually queue the work now. However that kinda sucks for small
> suspend times. Not really sure what to do.

Instead of doing the setup_timer dance you were doing, we should simply
do add_timer /iff/ del_timer_sync() returned 1, because that means we
actually cancelled the timer.

johannes


--=-jq3I2uqoXOVYmxPohMZm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKDSn/AAoJEODzc/N7+QmaSm4QAJ5lPFCIKWJhrIE+zZA4/B3d
hRNifrED1Qju7KXewjnqzMM3RbEUpppjcOdRGlTwlktz1C5EVwdYvF4jOOF+KSXh
Ih4rWze1oL5Zny6imdKzesk2P9YcrK2EftS0qtqeTP9FKvimPhUqacTio4fhQiSy
UXlCHdGy7pbAUxHCWDcX2RinfbrsHbhepKaRnxsqiaS21WNSRv8WMVbrpOjLtMfC
RRMQqF0D9ic/e78nySos6BkbgBtrzRCRuRQZ6iQa8fNHlP2M/GgjxNpzd4Tu0vcn
EbTnAzBduDJHdO/Wgv+r/zOf4xTcCk64c93GBlwy1lnZUYEBIB5SYNU2ds6rWTFr
erRHwRRDYRuWqrt9VJIK+V+QNnG15OBp3h/rHYGaMK5LXUlKWzN1JoziPkMJQWMO
XX6C65CvBpz/hO9dqYhMZE8brjUOY/Nw93ifGdEe06RwjRkLUGY+f2cP9M8fwM/8
gOY2LRDinzLT9PeobH84JEUaHhmjKYkEnbbTRNgugTVCGyWerFRrzdzFf7DcwPd4
Ibl6AQYXaiWyPCDdJXCroqTkPmT9/3mxM1FSEYQmtDCTQ7RMiUB53XazPxzqcVYM
Jy/GsM4G3tVL5kZwLDFEKnGByQbbpMXFZFSYd26ecZfepVQDyk391cDsVfmymws7
f+XiQbvuDJggIOYcYmZI
=4sql
-----END PGP SIGNATURE-----

--=-jq3I2uqoXOVYmxPohMZm--

