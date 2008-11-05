Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40091 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbYKEVFq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 16:05:46 -0500
Subject: Re: Thoughts about mac80211 client PS implementation
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <87fxm5ki6s.fsf@nokia.com>
References: <87k5bhkjf1.fsf@nokia.com>
	 <1225917235.3619.180.camel@johannes.berg>  <87fxm5ki6s.fsf@nokia.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-fPWDSQbzVc2hCjHG30sC"
Date: Wed, 05 Nov 2008 22:05:46 +0100
Message-Id: <1225919146.3619.190.camel@johannes.berg> (sfid-20081105_220550_521907_ED296486)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fPWDSQbzVc2hCjHG30sC
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-11-05 at 22:54 +0200, Kalle Valo wrote:

> >> PS should be disabled while associated and running software scan, and
> >> naturally re-enabled after the scan has finished. I assume hardware
> >> scanning implementations are clever enough to disable PS when scanning
> >> and we don't have to worry about that case.
> >
> > And on that too. And should there be a monitor flag that disables PS, s=
o
> > that we can "refcount" the PS bit in a way?
>=20
> Sorry, I don't follow you here. What do you mean by a monitor flag?

Well if you add a monitor interface you may want to turn off PS, but I
suppose you can just do that on the wlan0 interface you're associated
on.

> >> The dynamic PS implementation is still a bit open issue for me. I have
> >> been thinking something like that in tx.c frames will be queued if PS
> >> is enabled, PS will be disabled in a workqueue by calling
> >> ieee80211_hw_config() and only after that the queued frames are
> >> transfered. So something similar as sta->ps_tx_buf does in AP mode. No
> >> idea if this is feasible or not.
> >
> > Not sure I understand the dynamic PS yet.=20
>=20
> Basically the idea is to disable PS whenever we are transmitting (and
> maybe also receiving, don't know yet) frames, but whenever there's a
> long enough idle period PS would be enabled again. So in principle
> this would be a compromise of low power consumption and low latency.
>=20
> Naturally the idle period would be configurable with siwpower() and
> whatever nl80211 equivalent we will have in future.
>=20
> > Why would you queue up frames? To reduce the number of radio wakeups
> > when TX traffic is low?
>=20
> Just because I assume that invoke_tx_handlers() cannot sleep but
> ieee80211_hw_config() sleeps. I didn't think of any other way to solve
> this, but I haven't thought that much about this. What do you think?

But wouldn't that mean the other way around, i.e. whenever we transmit
we disable it and then start a timer that re-enables it? Ah, you're
thinking because TX handlers cannot sleep and the config callback may
sleep? Hmm. I suppose then we'd have to defer the actual disable PS mode
to a work struct.

Maybe we don't want to disable PS for a single frame though, so how
about this:

 * When a frame is transmitted, store the current frame counter (do we
   have one? we could add one) somewhere and arm a timer to fire N
   milliseconds in the future.
 * The timer checks that we have transmitted
   more than M frames in the time since it was started, and if so queues
   a work struct to disable PS.
 * The work function also sets a flags somewhere "dynamic PS has
   disabled PS" and arms another timer to fire after R millisecinds,
   that timer will queue work to enable PS again
 * the TX code, when the "dynamic PS has disabled PS" flag is set, mods
   the re-enable timer to be R milliseconds in the future again

That way, M frames within a period of N milliseconds will disable PS,
and it'll still disabled until R milliseconds elapse without traffic,
and no timers are fired unless they are needed.

johannes

--=-fPWDSQbzVc2hCjHG30sC
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJEgqnAAoJEKVg1VMiehFY/dIQAMHaVMK7dMBgY3zivYsZvaDR
6zcoGioj22dVWdGOL0pKpXfo8idjFUUBJDOqRUHhsws7fw92vhSB2kEpjUTV33Kn
MjXEKpfG8TIMw39o6tnVh07yErJmICpENyekM+SRRMXTjfrhoQe+JivwBOXZ57zj
4hqMfiONR2/Th99/7jUpBnxbLz+NKwvA3XcEzQZHvMXegac67j+3tp0lSDDMWIlX
CxbteooU0+kjOHrYqQYkN+OHV3p53BKy+7qeJLeBFQkHLsZQiSO01wXoOLseRRvx
P4J2E4xc98SrOaHQgUDJPA2wg9OCclhTD2HPBuHufJxcmxDlWSRN3O/kOyukTaWt
fiPPWfsyuaHa+ek2DhvI93iVKk5Ft2Y2Dqp1ZbZURTGTMkQBCYs/vSL+bfPmkhgl
ppmZkUYPeOH4TPqwoOmidXGF0+oKE1ybM3RVAuGXOi7s+5BcueFG15F1/T+weryV
v2mtE9JGXAEulTbOkRRKbwSA2r+lMS7VaqOO/ybJX4j/igWgg2C2XvkExGFJ+FB7
PUIQ8x4bNA3WtqetHgEvaJbG2l+VdMAbYT0TbFaVAh3KecNqcE2Ft+w/2AyckRHu
91a9EyTHm1RWejohND+JQdk0ua4LCsUEI8vXeShszjF+z+R43VwnIEQxiAHRktXV
qkVY+8ggk1Ql3Gxk+Dns
=uoi+
-----END PGP SIGNATURE-----

--=-fPWDSQbzVc2hCjHG30sC--

