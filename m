Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57599 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbYLHINQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2008 03:13:16 -0500
Subject: Re: Userspace tools: Roadmap?
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan E <trg_info@mailhaven.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1228692546.8826.1288759933@webmail.messagingengine.com> (sfid-20081208_002919_244971_30E436F9)
References: <1228692546.8826.1288759933@webmail.messagingengine.com>
	 (sfid-20081208_002919_244971_30E436F9)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ZAc7hpdLfn2X2S2u1vv3"
Date: Mon, 08 Dec 2008 09:13:13 +0100
Message-Id: <1228723993.22164.65.camel@johannes.berg> (sfid-20081208_091320_676894_F94903F1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZAc7hpdLfn2X2S2u1vv3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-12-07 at 18:29 -0500, Dan E wrote:
> Looking at some of the Linux Wireless website pages it appears as though
> "iw" is meant to be the successor to the older pre-mac80211 userspace
> tools.  In that category we have ifconfig, iproute2, iwconfig and
> iwpriv.  For an AP there's also hostapd and wpa_supplicant.  Probably
> some others I've missed, not to mention Network Manager.  I can see how
> configuration and setup wouldn't necessarily be limited to "iw" using
> nl/cfg80211, but in the short term is that the tool of choice for
> migrating the functionality of the old tools to the new mac80211
> infrastructure?

Not really, in the short term, you still are using iwconfig (wireless
extensions) with anything but hostapd.

> Here's my situation: [snip]

nice

> Userspace tools.  I want to proceed as if Wireless Extensions never
> existed.  Is that even possible?

No, it's not.

>   For instance, how do I command a
> channel change from userspace?  iw doesn't have that.  Should it?

Yes, it should, and nl80211 even supports it, but iw itself doesn't yet.
That's fairly easy to fix, too, but then iw won't support actually
telling mac80211 to scan and associate etc.

> Or do
> I need to drop back to iwconfig? =20

For now.

> Is iw the preferred command-line way
> to do everything the old tools did, but using nl/cfg80211 instead of
> ioctls?

Not _yet_.

>   When we get to AP mode, will hostapd be re-written to speak
> nl/cfg80211, or is a new config tool needed?  The same questions apply
> to wpa_supplicant.

That's already been done. The plan is to keep wext compatibility around
though, obviously, so iwconfig will work in the foreseeable future.

> In general, what's the way forward for new userspace tools?  nl80211 and
> cfg80211 are a given, I understand that, but what's the recommended
> approach from the perspective of a developer looking to make a clean
> break from Wireless Extensions with a new cleanroom driver written from
> scratch with no pre-existing baggage to worry about?  Start making
> additions to iw's capabilities?  Adapt some other existing tool to use
> nl/cfg80211, or write something completely new?

If you're writing a mac80211-based driver, there's no point where you
could possibly get in touch with the userspace API. You're writing the
driver completely to mac80211's internal driver API, and mac80211
completely shields you from the userspace API. You'll never interact
with either wireless extensions or nl80211.

> If somone could answer only 1 question (okay, it's a two-parter) the one
> I would most like answered is this:  How does one, from userspace, ask
> the driver to switch to a specific channel, and what callback(s) from
> mac80211 should my driver expect to receive as a result? =20

iwconfig wlan0 channel 7

then mac80211 calls your _ops->config() with the channel flag. Have you
looked at the mac80211 book and the other documentation on
http://wireless.kernel.org/?

johannes

--=-ZAc7hpdLfn2X2S2u1vv3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJPNcUAAoJEKVg1VMiehFYTSUP+gLqgMK1HG807M0Ysi0ByY4d
d8WMdJyx8BNmhJ7bP15skbG2bpVDKV4CWyjSWLGdHJj10ToJ/4cq5iqABCJVi33o
6u96LbRgtz0AmhADEyt3vHofRFwgD0r0clGmQsUD1zHdsv5igbjCdXHmjQgdHdEv
eNjhpMbxICH+b/NZiCO3L/DKujDctwC8zJ+361e6MsGFv4B9h1c2mnv1Fxaf3wf9
qg4sAecncDqMay/Mlxp1Yu/ik42cxenUhtih0FVc7kRU5M6607vXCLcqEI1Gmsgv
+nirBBxPOzmiM2GM+coBEr09C9qV2pkn8pFKlXmLF/BToLonkTJlir7lDDnTNSgb
qdrjvRxbx8/pyAzUPbhlWjDX/DHl6Rr5oYPIai1A4tD0T89cK45H+VVUIE8AEo5x
Hk9ImDg9PX+9eSuXOdzPAmsZV4HYKSqb/X8lUtcUlW0Dhb6juunvj15VX3pv5LF4
UE5uM45fBfS7cFGEgPfRmEiwloasBhmoc7Ek7kJdGQkBWmHv09alUXiASVCLH2ph
WBxWwEU3UdKOflYC+yhJW7UyhBDEO/PifXxPvKGPKL+tLvaeOUTWqOYtRoHpOpjR
JLAb+8cUgVXc2wph2EraiM3yevY74JDd5Jmy/A8CcrILIsez6Isrk4vwfH8o+q5R
z1/z5EOm+JYqfuHpanfM
=W8Wg
-----END PGP SIGNATURE-----

--=-ZAc7hpdLfn2X2S2u1vv3--

