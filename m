Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33804 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384AbYJGRB2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2008 13:01:28 -0400
Subject: mac80211 driver API
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Tomas Winkler <tomasw@gmail.com>, Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Chr <chunkeey@web.de>, Ivo van Doorn <ivdoorn@gmail.com>,
	Pavel Roskin <proski@gnu.org>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Kalle Valo <kalle.valo@nokia.com>,
	Luis Carlos Cobo <luisca@cozybit.com>,
	Javier Cardona <javier@cozybit.com>,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-nOgtkW4z3uLLc3bCNxaN"
Date: Tue, 07 Oct 2008 19:01:25 +0200
Message-Id: <1223398885.7328.47.camel@johannes.berg> (sfid-20081007_190131_170941_F44BEC87)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-nOgtkW4z3uLLc3bCNxaN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

Another thing I noticed when looking at the short slot stuff is that a
number of drivers do not use the use_short_preamble flag but also do not
set IEEE80211_HW_2GHZ_SHORT_PREAMBLE_INCAPABLE; this seems like a bug
affecting at least b43legacy, ath5k, at76_usb, rtl8180, rtl8187.

You should review the mac80211 driver API for things you aren't using
but should be using, this affects a number of drivers, for example
adm8211, p54, stlc45xx, ath5k, ath9k, libertas_tf, rtl8180, rtl8187
don't use radio_enabled; a number of drivers don't use power_level.

There are also still drivers (ath5k, adm8211, rtl8180, iwlwifi,
libertas_tf, zd1211rw, mac80211_hwsim, ...?) not using the
IEEE80211_TX_CTL_ASSIGN_SEQ flag, I can fix those since I broke them,
but help from the authors would be appreciated since I don't know the hw
in all cases, I know that stlc45xx for example can use a corresponding
firmware flag for it.


Do we need a document that indicates which parts of the API must be
implemented? Or should we mark such things in mac80211.h? Would
something like this help? I've thrown this together quickly so it
probably isn't complete yet...

A driver must (alternatives in order of preference)
 * either honour the IEEE80211_TX_CTL_USE_RTS_CTS flag
   or implement the set_rts_threshold call
 * either honour the IEEE80211_TX_CTL_USE_CTS_PROTECT flag
   or honour bss_conf's use_cts_prot value
 * either honour IEEE80211_TX_CTL_SHORT_PREAMBLE
   or honour bss_conf's use_short_preamble
   or set the IEEE80211_HW_2GHZ_SHORT_PREAMBLE_INCAPABLE hw flag
 * honour bss_conf's use_short_slot or set the
   IEEE80211_HW_2GHZ_SHORT_SLOT_INCAPABLE hw flag
 * honour bss_conf's basic_rates bitmap to set up the control response
   frame bitrate (cf. IEEE 802.11-2007 9.6 "Multirate support" paragraph 7)
 * honour IEEE80211_TX_CTL_NO_ACK unless the hardware does based on the
   multicast bit
 * honour IEEE80211_TX_CTL_ASSIGN_SEQ (we could make this depend on
   IBSS/AP/MESH modes)
 * honour IEEE80211_TX_CTL_REQ_TX_STATUS or always report TX status
 * honour the radio_enabled value of the hw config
 * not change it's operating mode based on IEEE80211_CONF_RADIOTAP
 * clear/set MAC address filters/control response frame generation based
   on the interface add/remove callbacks
 * set up beacon access parameters based on the interface mode (ibss/ap)
 * use SET_IEEE80211_DEV and SET_IEEE80211_PERM_ADDR
 * set the wiphy interface modes
 * set one of the IEEE80211_HW_SIGNAL_* hw flags (?)
 * set channel_change_time
 * ...

For QoS/WME, it must
 * support at least four queues
 * support configurable access parameters for those queues
 * ...

For AP mode, it must
 * honour IEEE80211_TX_CTL_SEND_AFTER_DTIM
 * ...

For MESH mode, it must
 * [anything special other than beaconing?]
 * ...

For HT, it must
 * support QoS
 * [need help, Tomas/Ron?]
 * ...

For spectrum management, it must
 * [unfinished]
 * ...

johannes

--=-nOgtkW4z3uLLc3bCNxaN
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI65XhAAoJEKVg1VMiehFYmhIP/1SNkcf/lnv+33vXfDxD4Sz9
xjZKw2x5nqJN5tjYdWjRnBRfntERBrHEUXtC9JATe/u43ECapGaRDTcn1WAiPVmx
APgr3lsONEkPLKb13aAh8OinnMVFLFZIa7im3vvLhJTZYaRz/aorZJeU65AjY44c
DsBx/RVyUNa3ObJv2zoaDtcL6XLZT1ZLKEQOD+YpTVRyNk1HL03umJYOI8ceGX6Q
uywAfIQLvRvx5hdz0mo6W53dIGh+LeBoDxXs1y6oZ5aDQP98xudOikvKCB7Cv1XX
4LCGUoJLDLXXxJpcbl8fLtpfF99JbJhfIRmbSrllLS1UvPy3Xkh6YuCZG1r/uY5R
LfwdDvfqQ1GYFD42Y+0oJrZlclXtBOJcKMTbxC0vYc4ILnO36anM+LbTsA14iIex
YJGZysA9zcw5Ea3k9Nh8Rc9ym19Ur7y47BTVsqWVx3pjpqN1HzW4Z9Pqx+R2VW8I
u+Ru4J6linT4mlNsP56JKFy9Bz8Ai/sgSVwziUNrgfRBfJaL4TOt5njLgXYFj9yt
y3UbTdpLWpkuxCAHIVzIfUSFcfEtpu6/x9r4rMzZha8lIbes79sQJKKdA63cg2BY
0tV82UEOWqi65P+G7duK5ZBn0kcsAb2VrILsl2joh2nM2210s/w/zOY/enonjZ4K
xYJiCRgo4or94rZtsimG
=Ry8K
-----END PGP SIGNATURE-----

--=-nOgtkW4z3uLLc3bCNxaN--

