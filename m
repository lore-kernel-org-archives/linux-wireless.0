Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36344 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760023AbZDQP6y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Apr 2009 11:58:54 -0400
Subject: SME/MLME notes
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kalle.valo@iki.fi>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ByJZeueAnPdwWj+tPEgp"
Date: Fri, 17 Apr 2009 16:56:43 +0200
Message-Id: <1239980203.32113.31.camel@johannes.local> (sfid-20090417_175915_676579_A93C0761)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ByJZeueAnPdwWj+tPEgp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

I have a couple of questions, and maybe some notes.

1) I think I've asked this before but don't remember the answer, why
   does nl80211 not require an SSID for AUTH? It seems wpa_supplicant's
   sme.c always requires an SSID, so we would always have one in the
   kernel -- and it would seem to be easier to implement it all too.
   Also, it seems very strange things might happen if the SSID isn't
   passed and the kernel somehow knows, from a previous scan, about a
   hidden SSID that was unwanted, but now gets selected?! Can we just
   require the SSID?
   I know technically we don't need it, we could auth with multi-SSID
   network's AP and only at assoc time select the SSID, but ...

2) We need a way to query which AP(s) we're authenticated with -- we
   should have association too but that you can get via the station
   code. But for authentications we don't add any station structs. Or do
   we not care and say that the SME needs to keep track?

3) Related to 2), when we authenticate with two or more APs, but then go
   to associate with one of them, which is possible to request in the
   current API, we might never know, due to powersaving features,
   whether the other APs deauthenticated us. Can we rely on the SME not
   doing stupid things like that?

4) When we try to authenticate while associated (FT-over-the-air), we
   need to turn off powersaving, I think?

5) Like 1) and the SSID, the SME always knows about the channel too;
   should we also require that? Might make things simpler, and not
   require scanning in the kernel?

6) The sme.c code contains a TODO about timeout -- mac80211 gives up
   authenticating when it doesn't get a reply to the frame after three
   times. Should
   a) those retries be configurable or at least discoverable, maybe
      some devices do not support configuration, or maybe both?
   b) there be an event when reached?

   If neither then we are in a situation where we don't know that the
   device/mac80211 has stopped trying. Or the device is still trying but
   we've given up in the SME.

7) Your SME code never tries to use a different authentication algorithm
   if the first one failed? Is that correct or could networks use LEAP
   _or_ OPEN?

8) The associate command takes a channel -- is that required? It seems
   that once you've authenticated you pretty much know that already, or
   do we need the SSID/BSSID/Channel to uniquely determine the BSS? The
   corresponding mac80211 code ignores it completely too.

9) Disassoc should check that we are associated, deauth is more
   complicated because of multiple authentications, cf. 3), do we care
   about auth?



Ok... Now thoughts on how I'd like to implement the cfg80211 SME.


10) I would like the cfg80211 auth/assoc ops to take cfg80211_bss
    structs. This requires having the SSID -- see 1). It would mean
    cfg80211 could hold the BSS and keep a pointer, also fixing that
    "hidden SSID scan result hold forever" issue. Also, it would mean
    that cfg80211 has to issue a scan when it cannot find the BSS, but
    that scan can be restricted to the SSID (and possibly the channel)

11) Since now cfg80211 keeps track of auth/assoc, we need a "I've given
    up" call from the driver, cf. 6), so it can unhold the BSS struct.

12) Beacon updates could update all BSS structs we know about that have
    the same BSSID (and channel?) -- also the one we're holding, just in
    case we are connected to a hidden network. Not quite sure yet how to
    do this though, the SSID might disappear then or something... Needs
    more thought.

13) For WEXT, just do most things in cfg80211.

This would reduce mac80211's mlme to just filling and sending the
frames, and filtering the responses, I think. And doing all the other
stuff inbetween, of course.

Ok, let me give you some time to digest this :P

johannes

--=-ByJZeueAnPdwWj+tPEgp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ6JioAAoJEKVg1VMiehFY1FYP/Rao9yUFGLIacrusrBd6HLTd
/5PCFZTa/Uz8wNe4o+NzvZBW524MIdBLBOE/+TJnwpt3TEz4kVrZ9Wd/YeUdPOI4
3HGvCZEC5QaCrYlys7zN5PI9yYBKyp4wShOp4QAxbUyBAQTPfRJZ+i5J4X67qF9T
d38NBC+JP2JYqncBnQScEW77fpCqSyqmzRnpFI22h7sd/gBaUARB6YJhNQmf8PbS
DZJ/qNeyUotF4Bfb2HndaJMa2eThGRpsGl/LUC8Oi24Wm+ypX55vNrTdUTsKyNl1
RZ8uqEDaJ9l1l2jlBqudA5MVTZJwb9VuplfAWXeAUswGA6TevjsA+bWWSMhU9gnP
m42CCF9jExGYqqBZjaumplAk42M8saMw4E1eYjITsRunMEvYe3unQFsiAa+Wj917
YjrQDwIb/EYVlSXMznIqCcoEsiyHU3Oql7DkfllzckiIzarpy4Kz1bPkVuGFpL/Q
GIdOXs9Fw97fwnXUiYDdwYGgZrGt1or2JsD6O1S7gQ6LM2kecm2rDAyC2KrEO0/4
j1DAow6JQ+YAt/Y6DH9cRc1Ja4hrR7ZVBU+qNL4sFED+EYluxhie6n91cs7Wzom0
Nxlef7Rd3HIhfnZtr5i8fQ2ogEMHI94qICClTOurCORnE77A2QEukYJ1QccQXvMb
VBTKYyoyw4cRPtj+KuXh
=Kto9
-----END PGP SIGNATURE-----

--=-ByJZeueAnPdwWj+tPEgp--

