Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:47924 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066Ab3DEL3d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 07:29:33 -0400
Date: Fri, 5 Apr 2013 13:29:21 +0200
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCH] mac80211: fix recalc_radar hwconf sync problem
Message-ID: <20130405112921.GA29188@pandem0nium> (sfid-20130405_132938_404010_BD997187)
References: <1364920789-14629-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1364993200.8351.35.camel@jlt4.sipsolutions.net>
 <515D8259.1030208@neratec.com>
 <20130404182219.GA24704@pandem0nium>
 <515EA285.5010004@neratec.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6c2NcOVqGQ03X4Wi"
In-Reply-To: <515EA285.5010004@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Zefir,

On Fri, Apr 05, 2013 at 12:08:05PM +0200, Zefir Kurtisi wrote:
> On 04/04/2013 08:22 PM, Simon Wunderlich wrote:
> > [...]
> >=20
> > So the patch does not resolve the problem for you? I've checked it agai=
n with
> > a little printk in ath9ks config function.
> >=20
> > With the patch the radar_enabled flag gets disabled when changing the c=
hannel (5500 -> 5200).
> > If I don't apply the patch, it stays enabled. I did the same thing (sta=
rt hostapd on
> > channel 5500, wait for CAC, echo 1 > /sys/kernel/debug/ieee80211/phy0/a=
th9k/simulate_radar).
> >=20
> > Maybe I'm missing something?
> >=20
> Hi Simon,
>=20
> here is how to reproduce (assuming you are using the patches for DFS test=
ing on
> ath9k posted yesterday).
>=20
> 1) enable DFS log output at ath9k
> echo 1 > /sys/kernel/debug/ieee80211/phy0/ath9k/debug
>=20
> 2) run hostapd on DFS channel, my config is as follows
> interface=3Dwlan3
> driver=3Dnl80211
> ssid=3Dtestap
> hw_mode=3Da
> channel=3D108
> wmm_enabled=3D1
> ieee80211d=3D1
> ieee80211h=3D1
> country_code=3DDE
> wpa_group_rekey=3D300
> wpa_gmk_rekey=3D640
> wpa=3D2
> wpa_key_mgmt=3DWPA-PSK
> wpa_pairwise=3DCCMP
> wpa_passphrase=3Dtesttest
>=20
> The log output I see is:
> Apr 5 11:44:00: [ 335.210749] IPv6: ADDRCONF(NETDEV_UP): wlan3: link is n=
ot ready
> Apr 5 11:44:00: [ 335.221152] ath: phy0: DFS enabled at freq 5540
> Apr 5 11:44:04: [ 339.234487] ath: phy0: DFS enabled at freq 5540
> Apr 5 11:44:04: [ 339.260298] ath: phy0: DFS enabled at freq 5540
> Apr 5 11:44:04: [ 339.262750] ath: phy0: DFS enabled at freq 5540
> Apr 5 11:44:04: [ 339.262786] IPv6: ADDRCONF(NETDEV_CHANGE): wlan3: link =
becomes ready
>=20
> So we passed the (shortened to 4s) CAC and AP is operating.
>=20
> 3) fire radar
> echo 1 > /sys/kernel/debug/ieee80211/phy0/ath9k/simulate_radar
>=20
> I see:
> Apr 5 11:44:25: [  360.294667] ath: phy0: DFS enabled at freq 5540
> Apr 5 11:44:25: [  360.297217] ath: phy0: DFS enabled at freq 5240
>=20
>=20
> The 'DFS enabled ...' message is print if ath9k_config() is called with
> hw->conf.radar_enabled, which should never happen for freq 5240.
>=20
>=20
> I wish I had time to learn using ftrace to track it down... As said befor=
e, it is
> not critical for ath9k, but might be a hint to something going wrong abov=
e.


Thanks for explaining, I could now see what's happening. I've added another
debug messages for "DFS not enabled" in the other case. What I get when run=
ning
your example (and with my patch applied) is:

NOTE: hostapd started
[  668.576380] ath: phy0: DFS not enabled at freq 5540
[  668.594108] ath: phy0: DFS enabled at freq 5540
[  672.607996] ath: phy0: DFS enabled at freq 5540
[  672.928911] ath: phy0: DFS enabled at freq 5540
[  672.939416] ath: phy0: DFS enabled at freq 5540
[  704.128876] ath: phy0: DFS enabled at freq 5540
NOTE: radar triggered here
[  704.138482] ath: phy0: DFS enabled at freq 5240
[  704.149684] ath: phy0: DFS not enabled at freq 5240

Now what happens is:
1. vif_use_channel() calls ieee80211_new_chanctx(), which calls ieee80211_h=
w_config().
   radar flags are not "recalc"d, so the previous value is used
2. Later in vif_use_channel(), ieee80211_recalc_radar_chanctx() is called, =
which
   sets the radar flag and calls ieee80211_hw_config() again.

As you can see in the output, the right value is applied ~10 - 20ms after t=
he wrong
value, at least with the patch originally posted here.

Of course this is not beautiful, but should work in practice.

We could consider changing this by already applying the correct radar flag =
in
ieee80211_new_chanctx()? If you want, I can post a patch for that. SMPS pro=
bably
has a similar problem to have the wrong value you set for a short time ...

Cheers,
	Simon

--6c2NcOVqGQ03X4Wi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlFetZEACgkQrzg/fFk7axZeFACg1MQLggiRzv7nR7MCyjofCSPs
v40AoJoLv5NgNoMq21TF4vxS6sjYrlBp
=7Kzn
-----END PGP SIGNATURE-----

--6c2NcOVqGQ03X4Wi--
