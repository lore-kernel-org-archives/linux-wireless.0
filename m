Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49434 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbYFTMrI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jun 2008 08:47:08 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1K9g1C-0002LK-0d
	for linux-wireless@vger.kernel.org; Fri, 20 Jun 2008 14:47:06 +0200
Subject: mac80211 suspend gotchas
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-67u/TvxjrR/V0plcHses"
Date: Fri, 20 Jun 2008 14:46:58 +0200
Message-Id: <1213966018.8967.176.camel@johannes.berg> (sfid-20080620_144713_398577_1A3758FC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-67u/TvxjrR/V0plcHses
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi driver authors :)

I suggest you guys get together and write some proper suspend support
for mac80211. We can discuss in Ottawa, but I just wanted to let you
know that I just ran into this:

[...]
[55292.062873] adb: starting probe task...
[55292.063012] adb: finished probe task...
[55292.502871] wlan0: No ProbeResp from current AP 00:1a:2a:2c:a2:c5 - assu=
me out of range
=EF=BB=BF[55292.502883] phy2: Removed STA 00:1a:2a:2c:a2:c5
[55292.562874] mac80211-phy2: failed to remove key (0, 00:1a:2a:2c:a2:c5) f=
rom hardware (-19)
[55292.563229] phy2: Destroyed STA 00:1a:2a:2c:a2:c5
[55292.768591] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[55292.776295] hda: UDMA/100 mode selected
[55292.777058] ide-cdrom 1.0: resuming
[55292.779026] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[55292.779210] hdc: MWDMA2 mode selected
[55292.779533] therm_adt746x 8-002e: resuming
[55292.779548] b43 ssb0:0: resuming
[55292.779552] b43-phy2 debug: Resuming...
[...]

As you can see, mac80211 "noticed" that the AP was "out of range",
probably because it sent a probe request just before or during
suspending and the time till now was about an hour.

We _really_ need to tie mac80211's workqueues and everything to the
hardware so we don't try to do these things before the driver resumes.

As you can see, mac80211 also complained that the key couldn't be
removed; that is because b43 didn't like being called when the hardware
was still shut down.

I don't even know if b43 keeps hardware keys across suspend (if not that
might explain some of the wpa problems I had with suspend) but it
shouldn't have to. In fact, I think it shouldn't even have to keep the
MAC address setting (it does that now.)

This is not a hard problem to solve.

What needs to be done is:
 - extend the ieee80211_notify_mac callback with two new paramters:
   suspend and resume
 - suspend is called by drivers when suspending _before_ taking any
   driver-specific locks, allowing mac80211 to call all callbacks as a
   response to that
 - resume is called by drivers when resuming _after_ having resumed the
   hardware
 - suspend does, in this order (callback used):
    * stop aggregation (ampdu_action)
    * remove all keys (set_key)
    * remove all STAs (sta_notify)
    * remove all interfaces (remove_interface)
    * stop the hardware (stop)
 - resume does the opposite in opposite order, and additionally
    * updates TKIP phase 1 keys (?)
    * re-sets RTS/frag threshold, retry limits
    * re-configures hardware (config)
=EF=BB=BF    * re-configures TX parameters (conf_tx)
    * re-configures filters (configure_filter)
    * [probably more that I missed on first sight]

All the values should be there in software state inside mac80211 anyway,
so doing it shouldn't need a significant amount of new state, though one
may have to add something depending on the up/down state of interfaces
to the sdata struct.

It's not _extremely_ complicated, but testing it all and getting it
right is a significant effort. TBH, I'm not bored enough right now to
spend a significant amount of time on it; I know how to recover should
anything go wrong (b43 is a very good driver in that respect, it handles
all those stupid cases that shouldn't happen.)

johannes

--=-67u/TvxjrR/V0plcHses
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIW6a+AAoJEKVg1VMiehFYiu4P/2VJxT3lFac/wlqFRz73P4GH
B7QYz61ym1MQUkNDghEyRSX/H7y/0rjI4ZVxCYV4OJ0DHi81CZ7ZFNZ8aYeNG1dZ
xgU08klpOoV4B2A2CENYubmjO+ggEA8h0QQMusMWLyogNbsDVGAHXTpX33mzC+Zq
iYTZbrIDR8XZVelfO8ffiGY4072DOLoxJrTWmsYsg5HK9WbRgjP5Seva8nBq6cNR
S85hJSoFX3I1owTSzw/mkJ2E1WQuXdWQJHGuNNrwWGdalk5NSp35inJ8sHHOFMVh
HZCdEViTdYxeMm0TS4Hq3dOAzkZklcLB9lgIuJ0fK9P2a4yO+zcAL+oQ65zv66Yl
1yBADCA46kMSQf+RCiMUJRMmZkn/VZyZg2wxtQf6b/f43UrKgkd42mNBCGAgG8GG
c/MY7YA3Dwjx80KDeASAJhDGqgqrDcghkhCx8i3nojD0BRMb9sPVaKLtGomwG7om
ZKRfnwjr3TrKc4jhnCe/JhxhX/6c7UxUSBADLWHZ3CWWoeNelGxbJlR0ZbSpdo9+
O26k3gt4f3BzsZgGj/rlv4+NcXoKsEDj2zgxSaPavETHAevrhWXodyMuwwiHewoI
yY/9wVHuEke1aiHYwj4GfxBAl6Fa2vuaOLPB3CphADNWKfdX4JZSEIO/OuHFonB5
FJzAnnPkDEBP1DXhDSFc
=JYeu
-----END PGP SIGNATURE-----

--=-67u/TvxjrR/V0plcHses--

