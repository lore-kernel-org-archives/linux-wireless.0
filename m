Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45231 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306AbXLMLiV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 06:38:21 -0500
Subject: [FYI] hostapd with mac80211 progress
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Michael Wu <flamingice@sourmilk.net>, Jouni Malinen <j@w1.fi>,
	hostap <hostap@shmoo.com>,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-t6ciuG8Eu8DQvOVHq7GN"
Date: Thu, 13 Dec 2007 03:23:34 +0100
Message-Id: <1197512614.6558.224.camel@johannes.berg> (sfid-20071213_113823_799536_82B49721)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-t6ciuG8Eu8DQvOVHq7GN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

I thought I'd write another update because I'm much further than last
time, I've been able to remove the management interface.

With my "[RFC] mac80211: clean up frame receive handling" patch and a
few more patches like "[PATCH] mac80211: fix header ops" I've been able
to implement hostapd without the management interface.

That requires a whole bunch of patches which, as always, you can find on
http://johannes.sipsolutions.net/patches/. I will be sending them out as
I feel appropriate. There are, contrary to what some think, reasons I
haven't done so yet. For example, I just found a bug with multicast keys
in my hostapd key patches.

The only ioctls I now still need are:

020-prism2-ioctl-bridge-packets.patch
021-prism2-ioctl-8021x.patch
022-hostapd-ioctl-hw-features.patch

However, a few more things are missing:
 * set_rate_sets <*>
 * set_channel_flag <*>
 * set_regulatory_domain <*>
 * set_tx_queue_params
 * set_cts_protect
 * set_preamble
 * set_short_slot_time
 * sta_clear_stats

hostapd works without these, but obviously not actually correctly (it
advertises WMM without being able to set queue parameters etc). The
items marked with <*> depend on the regulatory stuff we're going to
implement in the kernel.

The big thing with removing the management interface was the receive
frame handling cleanup that also made EAPOL frames show up on the
respective data interface rather than requiring the management
interface. This means that we can now use a monitor interface for
getting the management frames (and TX status callbacks) instead of the
management interface. Michael Wu is working on optimising this by adding
a "cooked" monitor mode that doesn't show data frames that were handled
by other virtual interfaces, but right now that's only an optimisation.
It will matter again when 802.11w is implemented where "cooked" will
give us decrypted frames, but w/o 802.11w management frames are always
sent in clear (and never fragmented in either case) so the regular
monitor interfaces work fine.

Also, using the monitor interfaces here means that we'll again send
deauth/disassoc frames when receiving class three frames from
not-associated stations as soon as the cooked monitor is used instead of
the socket filter. That still needs to be fixed up to work with PS-poll
packets, but that's a SMOP.

Other things to do include:
 * key threshold notifications
 * Michael MIC failure notifications (disable TKIP for now)

Ron, have you started working on traffic flows for hostapd yet? If so, I
guess I should set up a git tree or simply push all my hostapd patches
to Jouni (and send fixes as I find the bugs) because otherwise we're
going to produce many conflicts, most of my changes are quite large.
OTOH, I guess the only thing you need to do in the nl80211 driver stuff
is add support for flows to the station management. Let me know how you
want to proceed.

All, any help with hostapd would be much appreciated. In case I forget
to publish my hostapd patches though, ping me rather than working from
older ones. Any patches older than this mail are too old.

johannes

--=-t6ciuG8Eu8DQvOVHq7GN
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2CXpaVg1VMiehFYAQKp4RAAkkgf2B0LiuROXce/0+IaOAbiIxM4gWqV
SSE0ALaOtmROAIIaXl9KMevm1CMbrjvSjGqxyfZNmpBIUbgW3xOCHwkbFHXB5bJY
FTTWkUp2tIE7c8y4jFo9OLecOwB7p7Qcu6YPztaSYOnRyhoomuCDojkfd5BkR4oz
I173iUnhFx/wgXyDBt4hLqmfC8sIicJTEPxSctcBMjXfzVNeQi4aUrK/qXb3JZy5
QGYE8F9kkRGU+GFPqV/JeSnhIohc98T3xLnOnPMmye1kwGuS70OWyHVdPvUCD0qy
QygJEQK881Qxb0CdYa1ctvdZ1v8ZsO7BLtxVdRypwPfcWkiq42XlcSZ7l1C5GHFL
7kdCm2H0Vky6GraYxUuf7iRovH/I3oy4KY7qOVGeUJcCMfUU/xvPeobU6XE1w6G0
dly/XgwsaxLcyZvwxBxv5VrFpEjbb1/M8x3uO7gPV05J+vtdTUmMFG1vlonxNOYW
reMIuZ3oIibJfaGIZ0eM4NTbsiql2EaaCPO7ZucI/sU7aDxmhb1CsNNwAJpHm2Va
NB5cWbJMxfrOqB8Ttz15S09jtUsiqapYWDUnQJUS2+ZNuMg45WM/ZP6VEH2jQ2vl
/YDnNUrtdQmjo1GyXHudH0TAz67dPI9CeqEqhS7y9dPJoykhSxxjZ2xtoPWOe6ck
tdSj2+SH/9U=
=GVCi
-----END PGP SIGNATURE-----

--=-t6ciuG8Eu8DQvOVHq7GN--

