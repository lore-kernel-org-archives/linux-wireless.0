Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44818 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755149AbZHUJnB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 05:43:01 -0400
Subject: Re: Few warnings from master-2009-08-17
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890908171804t2279c750j7baeaf37ad4ff205@mail.gmail.com>
References: <43e72e890908171804t2279c750j7baeaf37ad4ff205@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-GjZuJKgLWM5mfjwqZsiq"
Date: Fri, 21 Aug 2009 11:42:59 +0200
Message-Id: <1250847779.17888.5.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-GjZuJKgLWM5mfjwqZsiq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-08-17 at 18:04 -0700, Luis R. Rodriguez wrote:

> Aug 17 17:45:06 tux kernel: [  380.596120] usb 1-3: firmware:
> requesting ar9170.fw

it would help if you turned off linebreaks for messages just like for
patches :)

> Aug 17 17:45:50 tux kernel: [  424.812910] ------------[ cut here ]------=
------
> Aug 17 17:45:50 tux kernel: [  424.812928] WARNING: at
> net/wireless/sme.c:610 __cfg80211_disconnected+0x1fb/0x260
> [cfg80211]()
> Aug 17 17:45:50 tux kernel: [  424.812931] Hardware name: 7660A14
> Aug 17 17:45:50 tux kernel: [  424.812933] deauth failed: -67

what was before that?

> It seems I can get the second warning triggered when I disconnect due
> to no probe response from AP:
>=20
>=20
> [ 1060.261105] No probe response from AP <AP-MAC-ADDRESS>after 500ms,
> disconnecting.
> [ 1060.264257] phy1: device now idle
> [ 1060.268293] phy1: Removed STA <AP-MAC-ADDRESS>
> [ 1060.290788] phy1: Destroyed STA <AP-MAC-ADDRESS>
> [ 1060.290961] wlan6: deauthenticating by local choice (reason=3D3)
> [ 1060.291025] ------------[ cut here ]------------
> [ 1060.291057] WARNING: at net/wireless/sme.c:610
> __cfg80211_disconnected+0x1fb/0x260 [cfg80211]()

Hmm, I can't:

# ip link set wlan0 down # that's the AP

[  311.040157] wlan1: detected beacon loss from AP - sending probe request
[  311.540219] No probe response from AP 02:00:00:00:00:00 after 500ms, try=
 1
[  312.040147] No probe response from AP 02:00:00:00:00:00 after 500ms, try=
 2
[  312.540138] No probe response from AP 02:00:00:00:00:00 after 500ms, try=
 3
[  313.040170] No probe response from AP 02:00:00:00:00:00 after 500ms, try=
 4
[  313.540203] No probe response from AP 02:00:00:00:00:00 after 500ms, dis=
connecting.
[  313.543275] phy1:mac80211_hwsim_conf_tx (queue=3D0 txop=3D47 cw_min=3D3 =
cw_max=3D7 aifs=3D2)
[  313.546169] phy1:mac80211_hwsim_conf_tx (queue=3D1 txop=3D94 cw_min=3D7 =
cw_max=3D15 aifs=3D2)
[  313.549090] phy1:mac80211_hwsim_conf_tx (queue=3D2 txop=3D0 cw_min=3D15 =
cw_max=3D1023 aifs=3D3)
[  313.579536] phy1:mac80211_hwsim_conf_tx (queue=3D3 txop=3D0 cw_min=3D15 =
cw_max=3D1023 aifs=3D7)
[  313.582070] phy1: device now idle
[  313.583148] phy1:mac80211_hwsim_config (freq=3D2432 idle=3D1 ps=3D0)
[  313.585026] phy1:mac80211_hwsim_bss_info_changed(changed=3D0x8f)
[  313.586871] phy1:mac80211_hwsim_bss_info_changed: BSSID changed: 00:00:0=
0:00:00:00
[  313.589350]   phy1: ASSOC: assoc=3D0 aid=3D1
[  313.590685]   phy1: ERP_CTS_PROT: 0
[  313.591840]   phy1: ERP_PREAMBLE: 0
[  313.592979]   phy1: ERP_SLOT: 0
[  313.594020] phy1: Removed STA 02:00:00:00:00:00
[  313.630576] phy1: Destroyed STA 02:00:00:00:00:00
[  313.790503] phy1: device no longer idle - scanning


Ok, so this is hwsim, but shouldn't make a difference at this level.

johannes

--=-GjZuJKgLWM5mfjwqZsiq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKjmwgAAoJEODzc/N7+QmaDhsP/1grfrITHDQ/Zq7hpYdHqNW8
o02QINA5FjFC7D+HsFiRP+u9JTiuQimsAew5mOiuMwToYzS9QU2rQ2mHo3vcaSGz
aqMbi/0F4r46Nv+1GztvNf7vrVW16ia39w+tHRsWNpM+SrPDm3Nqk83Q0Uz/iMex
eJWMScZUHDuWG1DGqJmadSLEPIQPPRcWeuXfwXJuKjjAXXlyCs35ua7sZrPUet1m
6inaaBa3hwRfiJ8NfM3t6478yLfEkaHMy5tWJM4ZR4V2Z9H+MAXPUEH4LZlMpS15
aIVOnRFlDfBtdjKqGilRrlOIIxhMGCtHnxWdH/vZthaRUyG8fAUThEf8rbWRG3lE
Lmunxjhmju54oQKLfqUTnAdN2aj177TjI6irvLN9S+zvLp5aro4KICBJoJjBJYVx
QCJktZcMOnfysRbITIlil45pvMpTZ4qaaqqJnZsHYRDkeOVpZsZyltlKdyELR7p2
vWd+QDok7wCCPI7NUJYCVo6nEBD7MOqsZb6E1A9Q+RCHOSLmg/RFpV2jz2HMq1Fb
BPNGd8NnjKGFfdK0N/LcU8XbMogqYny6hE4BqpFLS8KLrmVPppP4ewh6oruFQ8+e
bYtYvDozHMnL+dPdJ3g8/cvYCREqsXNBK5be2xJOGJv4s2KwU6kgz1NKXVbVLUjF
5UAOtEPV7RdPaIOWT28W
=0kf4
-----END PGP SIGNATURE-----

--=-GjZuJKgLWM5mfjwqZsiq--

