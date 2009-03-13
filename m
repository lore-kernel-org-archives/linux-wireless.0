Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42211 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382AbZCMK7C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2009 06:59:02 -0400
Subject: Re: [PATCH v2] mac80211: resume properly, add suspend/resume test
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Jouni Malinen <j@w1.fi>
In-Reply-To: <1236941339.5235.14.camel@johannes.local> (sfid-20090313_114936_050438_5FF0B5AA)
References: <1236939917.5235.7.camel@johannes.local>
	 (sfid-20090313_112555_620577_8A85228F)  <1236941058.5235.12.camel@johannes.local>
	 (sfid-20090313_114453_238290_13C307AD)  <1236941339.5235.14.camel@johannes.local>
	 (sfid-20090313_114936_050438_5FF0B5AA)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RvrGI9R6vsAzDvJyDfz0"
Date: Fri, 13 Mar 2009 11:58:27 +0100
Message-Id: <1236941908.5235.27.camel@johannes.local> (sfid-20090313_115907_922289_27DD0822)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-RvrGI9R6vsAzDvJyDfz0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-03-13 at 11:48 +0100, Johannes Berg wrote:
> On Fri, 2009-03-13 at 11:44 +0100, Johannes Berg wrote:
> > When mac80211 resumes, it currently doesn't reconfigure the interfaces
> > entirely and also doesn't reconfigure BSS information -- fix this.
> >=20
> > Also, to be able to test this, add a debugfs file that just calls
> > the suspend/resume code to see what happens when we go through that,
> > without needing the time-consuming suspend/resume cycle.
> >=20
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> > ---
> > v2: rebased on top of "stop queues across suspend/resume"
> >=20
> > zd1211rw currently doesn't survive this properly, I'm not sure why,
> > but it keeps saying
> > 	zd1211rw 1-1:1.0: error ioread32(CR_REG1): -11
> >=20
> > Please test with other hardware, we need to figure out whether or
> > not something is missing in mac80211.
>=20
> ath9k survives ping -f without even blinking.

Actually, not quite:

[  289.753866]=20
[  289.753869] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[  289.754164] [ INFO: inconsistent lock state ]
[  289.754372] 2.6.29-rc7-wl-17155-g2f7ab92-dirty #29
[  289.754598] ---------------------------------
[  289.754805] inconsistent {in-softirq-W} -> {softirq-on-W} usage.
[  289.755090] bash/5240 [HC0[0]:SC0[0]:HE1:SE1] takes:
[  289.755324]  (&txq->axq_lock){-+..}, at: [<d0000000023de2e8>] .ath_tx_no=
de_cleanup+0xa4/0x1cc [ath9k]
[  289.755828] {in-softirq-W} state was registered at:
[  289.756058]   [<c00000000008b3c8>] .__lock_acquire+0x6e4/0x908
[  289.756350]   [<c00000000008b690>] .lock_acquire+0xa4/0xec
[  289.756621]   [<c00000000042b980>] ._spin_lock_bh+0x58/0xb8
[  289.756898]   [<d0000000023e0938>] .ath_tx_processq+0x9c/0x564 [ath9k]
[  289.757243]   [<d0000000023e0e78>] .ath_tx_tasklet+0x78/0xa0 [ath9k]
[  289.757579]   [<d0000000023db574>] .ath9k_tasklet+0x8c/0xbc [ath9k]
[  289.757910]   [<c00000000005ca18>] .tasklet_action+0x150/0x248
[  289.758200]   [<c00000000005da60>] .__do_softirq+0xf4/0x218
[  289.758477]   [<c00000000000c4c8>] .do_softirq+0x5c/0xb8
[  289.758741]   [<c00000000005d850>] .local_bh_enable+0xd4/0x128
[  289.759030]   [<c000000000397ae4>] .dev_queue_xmit+0x428/0x47c
[  289.759320]   [<d0000000022e0620>] .ieee80211_tx_skb+0x5c/0x70 [mac80211=
]
[  289.759700]   [<d0000000022c772c>] .ieee80211_scan_work+0x158/0x1c0 [mac=
80211]
[  289.760081]   [<c00000000006dd50>] .run_workqueue+0x16c/0x298
[  289.771199]   [<c00000000006dfa4>] .worker_thread+0x128/0x154
[  289.782275]   [<c00000000007365c>] .kthread+0x78/0xc4
[  289.793327]   [<c000000000022908>] .kernel_thread+0x54/0x70
[  289.804332] irq event stamp: 96461
[  289.815187] hardirqs last  enabled at (96461): [<c000000000428908>] .__m=
utex_unlock_slowpath+0x1cc/0x218
[  289.826501] hardirqs last disabled at (96460): [<c0000000004287bc>] .__m=
utex_unlock_slowpath+0x80/0x218
[  289.837782] softirqs last  enabled at (96424): [<c00000000000c4c8>] .do_=
softirq+0x5c/0xb8
[  289.849079] softirqs last disabled at (96413): [<c00000000000c4c8>] .do_=
softirq+0x5c/0xb8
[  289.860229]=20
[  289.860230] other info that might help us debug this:
[  289.882122] 1 lock held by bash/5240:
[  289.893117]  #0:  (rtnl_mutex){--..}, at: [<c0000000003a46ac>] .rtnl_loc=
k+0x20/0x38
[  289.904375]=20
[  289.904376] stack backtrace:
[  289.926731] Call Trace:
[  289.937918] [c00000020484b490] [c00000000000fef8] .show_stack+0x6c/0x174=
 (unreliable)
[  289.949404] [c00000020484b540] [c000000000087918] .print_usage_bug+0x1d8=
/0x210
[  289.960846] [c00000020484b600] [c000000000088458] .mark_lock_irq+0x5d0/0=
x83c
[  289.972185] [c00000020484b690] [c000000000088998] .mark_lock+0x2d4/0x474
[  289.983384] [c00000020484b730] [c000000000088c60] .mark_irqflags+0x128/0=
x160
[  289.994515] [c00000020484b7c0] [c00000000008b3c8] .__lock_acquire+0x6e4/=
0x908
[  290.005626] [c00000020484b8c0] [c00000000008b690] .lock_acquire+0xa4/0xe=
c
[  290.016727] [c00000020484b980] [c00000000042b8c8] ._spin_lock+0x50/0xb0
[  290.027837] [c00000020484ba10] [d0000000023de2e8] .ath_tx_node_cleanup+0=
xa4/0x1cc [ath9k]
[  290.038983] [c00000020484bb00] [d0000000023d90b0] .ath9k_sta_notify+0xf8=
/0x118 [ath9k]
[  290.050108] [c00000020484bb90] [d0000000022ecc44] .__ieee80211_suspend+0=
xb0/0x1e0 [mac80211]
[  290.061261] [c00000020484bc50] [d0000000022e3914] .reset_write+0x2c/0x60=
 [mac80211]
[  290.072397] [c00000020484bce0] [c00000000010b7c0] .vfs_write+0xd0/0x1bc
[  290.083465] [c00000020484bd80] [c00000000010b9b4] .SyS_write+0x58/0xa0
[  290.094494] [c00000020484be30] [c000000000007554] syscall_exit+0x0/0x40

Looks like we need to disable BHs for the sta functions or something?

johannes

--=-RvrGI9R6vsAzDvJyDfz0
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJujxRAAoJEKVg1VMiehFYeAEP/Rxl8/rR1APvZWrcxyqnrx0E
ZA9pxLQM2GbSPp7Yo9ADe3fJDn+6XuNC5918K1DVR0uXyBzkDMGiEV3pAX70Qi8x
LXPKoJn+00+gSImnwPhTtIs8GKgApsyFzEuZfyG/FLSBjx+PoWEWflvEN/f4s2W7
EU1R7EBPKHuCdB/O6KGrERUSuh6mjSb9V1Br0aj3koJkk1HKapKdTcslHQcAgC0X
BwZwjYliEXn4KFL0rUXN+a/J9kXkFgYEgQOe9jBI6n0NpXW26eHlZNqnz0XmjY8e
RreQJwUtYNxdl7+2hCV9xfkFOKVGInTm/xZOUGE6PLTL7Hr651hyynziCxMnb4B9
sVK0a4bG9XJRIjXfqUrQ4mGmC2nLEKELMe+YeyTgPH8gmOQHAWUof48YkRk8563r
LrQwVfk7jAO5UbrH+MaGl29ortiZ39pPLoGL9LNC5F04PNvHnmuD+X6AWEhW2eDf
AkKjQp6ENiZAkUEmT70H0hgZ49GTdmqg9l4kiSHSt/wwdJmDBqOsoLTsgwtH0gN/
T+NVZCz4+OZe39Kz4y74eRtqsRvfCHiIK8do9mllFlnj0lQpVlQceryIDsbD/3Uf
aC7xJi+Wlgdr8taTcdTzBzFJc3WtzmcQFu6gBXWQ3A3LCu0lqOMcOAR7yfs7jK4s
5C7eAzyVWqS6VxaalYzF
=AMEr
-----END PGP SIGNATURE-----

--=-RvrGI9R6vsAzDvJyDfz0--

