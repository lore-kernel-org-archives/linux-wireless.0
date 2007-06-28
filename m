Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57719 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808AbXF1Jis (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2007 05:38:48 -0400
Subject: RE: ieee80211_rx_mgmt: pushing fake 'management' frames  intouserspace
From: Johannes Berg <johannes@sipsolutions.net>
To: Mandy.Peng@infineon.com
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
In-Reply-To: <A2CE5E0A70B68046A98EB5145552E2770119C773@sinse303.ap.infineon.com>
References: <A2CE5E0A70B68046A98EB5145552E27701173B8F@sinse303.ap.infineon.com>
	 <1182952910.4769.20.camel@johannes.berg>
	 <A2CE5E0A70B68046A98EB5145552E2770119C773@sinse303.ap.infineon.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-cdk1X43bw19YKe1G6atc"
Date: Thu, 28 Jun 2007 11:38:56 +0200
Message-Id: <1183023537.4769.69.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-cdk1X43bw19YKe1G6atc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-06-28 at 16:40 +0800, Mandy.Peng@infineon.com wrote:

> Yes, I have to worry about it. Since our chipset only handle the data
> path task, the host software has to take care of all the management
> tasks.

Oh. That's an interesting setup, and will require changes to mac80211 to
avoid the 802.3 -> 802.11 reframing and much of the transmit patch.
Interesting, and probably not the simplest thing to do right now. If
you're willing to share some specification on the chipset or such we
should be able to help you with the driver and required mac80211
changes.

And if your device handles all of the datapath, then how can you
transmit raw 802.11 management frames? Is there a bit in the
device-specific transmit header you can set to have it avoid using the
data path handling in firmware? [1]

> If we write a netdevice driver and register to cfg80211. Then we
> should use the similar way to pass through the management frame as
> mac80211.

Ah. That works too, but then you'll be relying on the userspace MLME.
That's fine, however all this stuff hasn't really been worked out
properly yet.

>  So I wondering how do you testing the mac80211 management
> action ? Which version of hostapd and wpa_supplicant are you used to
> verify the mac80211 ? We will set up the set environment.

I have to admit that I've never ran any userspace MLME besides hostapd,
but right now you're probably more managed in managed mode, i.e.
wpa_supplicant, I've never tried that. You might want to talk to Jouni
(CC'ed).

johannes

[1] if that's the case, then you should be able to write a mac80211
driver right now that puts the transmit path into software. That would
allow you to have a driver now and change things accordingly later.

--=-cdk1X43bw19YKe1G6atc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGg4Gw/ETPhpq3jKURAqg/AJ9kBDQwa32l5GlNDusMKSWXVy6UvQCfXpQr
ivvNSA8X2ENnSidjHZwSE+8=
=/EyZ
-----END PGP SIGNATURE-----

--=-cdk1X43bw19YKe1G6atc--

