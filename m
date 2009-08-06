Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56831 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbZHFHkI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2009 03:40:08 -0400
Subject: Re: [RFC 0/4] orinoco: use cfg80211 for key manipulation
From: Johannes Berg <johannes@sipsolutions.net>
To: David Kilroy <kilroyd@googlemail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1249504372-17063-1-git-send-email-kilroyd@googlemail.com>
References: <1249504372-17063-1-git-send-email-kilroyd@googlemail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-NricAagi//1TVfMqg97i"
Date: Thu, 06 Aug 2009 09:40:03 +0200
Message-Id: <1249544403.3617.5.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-NricAagi//1TVfMqg97i
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> - The cfg80211 notification functions like cfg80211_connect_result
>   are not called in this series. Does the driver need to keep track of
>   each call and make sure it calls the right notifer? Right now orinoco
>   arbitrarily sends SIOCGIWAP, IWEVASSOCRESPIE and IWEVASSOCREQIE on
>   ?authorisation? Also not sure how this will tie in with
>   cfg80211_send_rx_auth/assoc.

You don't have to worry about send_rx_auth/assoc -- those are for
drivers like mac80211 that leave the SME up to cfg80211 or userspace.
All you need to implement is a call to cfg80211_connect_result() and
possibly cfg80211_roamed() when the card can roam itself if no BSSID is
set. Those take the assoc request/response IEs too. You don't need to
call wireless_send_event at all :)

> - In station mode, is the connect crypto struct fully filled in
>   regardless of WEP/WPA? I'd like to set priv->encode_alg at this stage,
>   and then only accept keys of that type via add_key. Unfortunately
>   join_ibss doesn't have similar info.

Yes, it should be filled in. I'm uncertain whether iw does it correctly
for WEP right now, if not I can fix that. For IBSS, nl80211 can actually
pass that info, but doesn't right now, it probably should do that
though.

> - In adhoc mode, how do you set open/shared WEP? i.e. how does orinoco
>   know to set priv->wep_restrict?

What's priv->wep_restrict? open/shared in ad-hoc seems very strange
since you have no authentication frames?

> - Digging around cfg80211, it looks like set_default_key isn't called
>   when authentication is TKIP. How does the driver tell which key to use
>   for transmit? Are we supposed to assume the group key is the transmit
>   key?

The pairwise key, of course. But you knew that, so I think I just don't
understand the question.

> - TKIP pairwise keys. I think orinoco has always ignored them. The Agere
>   driver installed pairwaise keys to index 0. Should I attempt anything?

I don't think it can have ignored them for proper operation? When you're
doing WPA, you can only receive with the group key, and transmit with
the pairwise key negotiated with the AP.

> - TKIP and ad-hoc. err... I plan on leaving this alone.

:)
So far I've only really supported WEP with IBSS in all this. I'm happy
to work with somebody to add support for more, but I have to admit that
I'm not particularly interested myself.

johannes

--=-NricAagi//1TVfMqg97i
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKeojPAAoJEODzc/N7+Qmaab8QAIVSx+mMEtPHZ8i7eHZv007d
9ScUUbNQMJ4epJke3T1TCN817CL/kBK0NOtbOCFAgrGPA9NxmAPNbqaIYilMpLr6
eplhLhcVmETpKmbOos03Z5VAgvnW0tzzidIvOMeHFCA22jekyMmO9mYf0ozoaZ6C
PYbIXd/Qzi1NmceA4at+Ygd9Va2hExDHHfDtbmuxsogeBzSiVqBd/NhGyxpfjsTT
N+dOSw6SIo6WabNszS6H+2XfX9rjJEJ05761+eylaEZVAQM81F5g5dLmPQ8gmzt5
YUMK8bCyojdqXAbg5b4n2CtiSy1bnu36sBq48HuUohH12WlY72CkfTEbnOMa2wG4
QfHmPAnw0Zdooe9cIO9Y7oMMFb8VZIqP9g06OspinFhj4e1X0uRGVxrZ97+59cBc
/jjTsHPMQ2uImpONCaxX3q9o9k0vpNqahdm/wXTYApDLiGPon7ezcJfGoiJFz7Gp
GtoEXLc0JAzI2yxx3S4JOq+H/zhbI+2+3Ar3uKk75Mn9JMkcPZieC0MHLifwlHcD
S/1Uz+YB6lLCLJIqjCpQ2JWTxHh+gwM7lF//+Fs87vFZNxa4VDt6Y19u1G6MyAEM
ztcCIGDdDCHdGYtMhJoXUipXRFaVFEk6no0/mk1+XNzDbGvB0b1WXonNJ2sGvCf5
9Rd9BFMe++Tc6e7ENdAj
=fIaG
-----END PGP SIGNATURE-----

--=-NricAagi//1TVfMqg97i--

