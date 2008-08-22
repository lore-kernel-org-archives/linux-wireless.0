Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47984 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbYHVUGd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Aug 2008 16:06:33 -0400
Subject: Re: [PATCH] p54: Fix potential concurrent access to private data
From: Johannes Berg <johannes@sipsolutions.net>
To: Chr <chunkeey@web.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200808222157.55851.chunkeey@web.de>
References: <4896381c.abQmtcnBFB3TpLyf%Larry.Finger@lwfinger.net>
	 <200808062321.53120.chunkeey@web.de> <489A4829.5080704@lwfinger.net>
	 <200808222157.55851.chunkeey@web.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-TZSs3jETmsWhl2DPdq+8"
Date: Fri, 22 Aug 2008 22:06:25 +0200
Message-Id: <1219435585.3479.12.camel@johannes.berg> (sfid-20080822_220637_796947_A331CDED)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-TZSs3jETmsWhl2DPdq+8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-08-22 at 21:57 +0200, Chr wrote:
> On Thursday 07 August 2008 02:56:09 Larry Finger wrote:
> > Chr wrote:
> > > Well the reason why there isn't any bug report about it is maybe
> > > because unlike most other devices we don't program one single
> > > setting per time, but always a "group of similar ones" at once so
> > > the device should always be in a sane state in theory.
> > >
> > > So as long as mac80211 provides at least some kind of protection
> > > against it's own concurrency, we are in save waters even without
> > > any fancy kind of locking.
> > >
> > > Regards,
> > > 	Chr
> >
> > For the config callback, mac80211 does not protect against concurrency.=
 We
> > learned that with rtl8187, where this routine ran somewhat longer. Afte=
r
> > the power setting routine was added to the wext interface in mac80211, =
the
> > driver broke due to concurrent calls to the config routine and was fixe=
d by
> > just this kind of mutex, which is why I added this protection for p54.
> >
> I just got a reply from an anonymous p54pci (2.6.27-rc4) user, with the=20
> following problem:
>=20
> INFO: task prism54pci:10881 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> prism54pci    D 0000000000000001     0 10881      2
> ffff8800780dbde0 0000000000000046 0000000000000000 ffffffff802375cb
> ffffffff80778740 0000000000000286 ffff88007c632f38 ffff88007c5d8b40
> ffffffff806c2330 ffff88007c5d8d70 0000000001018740 ffff88007c5d8d70
> Call Trace:
> [<ffffffff802375cb>] __mod_timer+0xb7/0xc5
> [<ffffffff802297d7>] dequeue_task_fair+0x4d/0xce
> [<ffffffff805446ff>] __mutex_lock_slowpath+0x6a/0xa0
> [<ffffffff805445a9>] mutex_lock+0x1a/0x1e
> [<ffffffffa01d48f0>] p54_config+0x1a/0x46 [p54common]
> [<ffffffffa01a7e73>] ieee80211_sta_scan_work+0xf8/0x1b8 [mac80211]
> [<ffffffffa01a7d7b>] ieee80211_sta_scan_work+0x0/0x1b8 [mac80211]
> [<ffffffff8023d158>] run_workqueue+0x79/0xfe
> [<ffffffff8023d42e>] worker_thread+0x96/0xa5
> [<ffffffff8024056c>] autoremove_wake_function+0x0/0x2e
> [<ffffffff8023d398>] worker_thread+0x0/0xa5
> [<ffffffff8024025a>] kthread+0x47/0x73
> [<ffffffff8022c919>] schedule_tail+0x27/0x5f
> [<ffffffff8020c279>] child_rip+0xa/0x11
> [<ffffffff80240213>] kthread+0x0/0x73
> [<ffffffff8020c26f>] child_rip+0x0/0x11
>=20
> I have no idea going on here since locking is so simple here that it
> shouldn't misbehave at all!?!

Maybe some error path is missing an unlock or something simple like
that? I haven't got a clue.

johannes

--=-TZSs3jETmsWhl2DPdq+8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIbBAABAgAGBQJIrxw+AAoJEKVg1VMiehFYnCgP93O/OWwrLEk0WmQC8EUyN0Xr
a4kXTdgw/Yo3QWONsxCME1G0vKfvQlNBFwZ7seQ413T7vexHSlY4gtmUhAvDZPQV
UpmxKitZwPq3G0N42ok+ZXU+oHut728zLToFRMVASGt4HMZAEmfuEXRVFmS6cdu8
dIR+3pPB/NxqhxYhHgKDJVg99ig9/umZaaEL059JuEyryfqbHLGYd3I8HjtOEdEe
IOh3UEw1opQzBRT2KMDrGSKJpQKG4CgIRv9mxiyyhU/KeKvULSeRoK5aHrehvmn+
Qgk9xTfz7wjbkkjBQKM1aVUTFBazM20+we8Y1QEZCv4fMNJvrdS9+Bsp30n1o97l
GKwHNvpUdBvSaTN1mBoa1BFiJDc+Vh+9voVV8tfLBbI/M9UOC3oM8rAIf7+dTbPh
sC7WGRafZydaxggivSQOT57vcTpdSBNwx8cAobRHnngBr8SEjPFTY47WChiTfCol
xbxuQK6Eskn9FA637cXfTCypC0R1ElJpH3Zv2stHEi8D+a0khKWepyPRw53HpBwl
5ys3u+kwv1NVFxTqqHHlhnL806hOm7htyw43Ltq0TigIaIM7P+fd2dY65xb1xaTN
9gS/+NKjzX7IpeDF7uIK4DLQw5+pmxe2GAuH6nOwG8D4la5sl5QEjSChCS+0LR/w
Hic6d7yITA5VijleQEo=
=Qj4D
-----END PGP SIGNATURE-----

--=-TZSs3jETmsWhl2DPdq+8--

