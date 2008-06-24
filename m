Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35047 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759446AbYFXJ2w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2008 05:28:52 -0400
Subject: Re: mac80211: workqueue & RTNL lock
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <a32f33a40806240220s3ef070bdr591d4775ee57cb81@mail.gmail.com> (sfid-20080624_112031_465193_4527E183)
References: <200806230042.41219.IvDoorn@gmail.com>
	 <200806230030.42776.mb@bu3sch.de>
	 <a32f33a40806230130t11022b31p3d9997ab5e449fe6@mail.gmail.com>
	 <200806231120.41519.mb@bu3sch.de>
	 <a32f33a40806230417i68e4d19aj76a481d7dbf2c611@mail.gmail.com>
	 <1214297515.8967.253.camel@johannes.berg>
	 <a32f33a40806240203w29d0caf7p6e2956d82d48e013@mail.gmail.com>
	 <1214298658.8967.266.camel@johannes.berg>
	 <a32f33a40806240220s3ef070bdr591d4775ee57cb81@mail.gmail.com>
	 (sfid-20080624_112031_465193_4527E183)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-wEC/nbl2X1U0RXdwYugH"
Date: Tue, 24 Jun 2008 11:28:13 +0200
Message-Id: <1214299693.8967.273.camel@johannes.berg> (sfid-20080624_112922_468405_06FAD69F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-wEC/nbl2X1U0RXdwYugH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > However, the interface iterator will simply not run at all if ->stop ha=
s
> > already succeeded since no interfaces would be UP, so you don't really
> > have to protect it against that, you only have to make sure it's not
> > running when you unregister your hardware struct, and _that_ doesn't
> > have the rtnl taken so you can use cancel_work_sync() there.
>=20
> True, but the race condition happens when ieee80211_stop() is called,
> and the rt2x00 work is triggered before before
> rt2x00->remove_interface() or rt2x00>stop() is called. when stop() is
> then called it cannot use cancel_work_sync() because
> the work structure is waiting until stop() has completed which will
> not end until cancel_work_sync() has completed.

No, but I'm saying that ->stop doesn't need to cancel_work_sync(). You
should have a work struct that you exclusively use for whatever you need
to do with interfaces, so the code looks something like this:

void work(...)
{
	iterate_interfaces();
}

maybe with some additional locking. You also use schedule_work() and not
the mac80211-provided workqueue.

This work will do exactly nothing if triggered before ->stop and running
after ->stop because all interfaces will be gone. Hence, you don't need
to cancel it in ->stop, you don't care whether it'll run or not.

Hence, the only thing you need to take care of is that it's canceled
before unregister_hw(), and for that you can use cancel_work_sync().

Am I missing something?

johannes

--=-wEC/nbl2X1U0RXdwYugH
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIYL4qAAoJEKVg1VMiehFYjW8QAIqdA9bfQqlbdGLeZVTDaiuj
od6QFXFfZBnIAXa93YjX+GGzms8UgG5XG1uTLr+Bt2NgtgI4CWuUSlkYj7qJsIN/
P4oBmi6JEwsdFXZ1IO1iNdOObDfEQ+usz/3zkR0b5zeTN91f0pAzrNZCVbjMCIUm
ZB/HP3brGFurLROE9noQ4Hb0ta/gYCMcmRia9/jFv8jNoGWA/p17RbiOUfuVfD2a
f3Gl9ZRu/8wCtY9A5wxFscmFl0RBV2Kuny9UiwaoNr0l5Na9eZwojZOAe7PlRtLG
Tg1r6NaAeMY+z1vDP/hrMrTf/WzaILjClXg1rIdrkrL8EmBhfjW8JuPz0znG6XgY
1Iyn3bnn3WWUUGJovPO4kZ0v5iDR/BTyujqKa8Y4/Cj2U65pgGEn+4uHbo/Lcj7i
g5xJ0GeiqN7JxuiUQLk2BLIvClebtbS+UPlljbRdYT0nM8vRV/p+fFwAlS2CtxBs
mklYykXsw61NUEmrgyFwDd1AUXoH6lMamNr0yAftYy8QZirX7xHtoKNHj4yrjZfG
7e4S2X0yv7uMatazsIed5AHRZHPSM1aQIz542GLkvUrQxkWvsnaltfm6TOxHUmJi
erGDR8upp7WirYpHTG5kd4BLVkPsF7aH+rzwQbN0A4t2zm+IfhbW2LlEBLjxpTQU
TI23B/vEmIxTLbC4uswt
=9jv7
-----END PGP SIGNATURE-----

--=-wEC/nbl2X1U0RXdwYugH--

