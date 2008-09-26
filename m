Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53165 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768AbYIZTXd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2008 15:23:33 -0400
Subject: Re: hostapd - mac80211 - rt2x00 - rt73usb  AP mode bug
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Iwo Mergler <iwo@call-direct.com.au>,
	linux-wireless@vger.kernel.org, hostap@lists.shmoo.com,
	Ivo van Doorn <ivdoorn@gmail.com>
In-Reply-To: <20080926165007.GP4791@jm.kir.nu> (sfid-20080926_185113_941662_B54B793E)
References: <48C9CD51.1060107@call-direct.com.au>
	 <20080926165007.GP4791@jm.kir.nu> (sfid-20080926_185113_941662_B54B793E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-QdOous1hgjXmIY+/Vrhv"
Date: Fri, 26 Sep 2008 21:23:17 +0200
Message-Id: <1222456997.3798.22.camel@johannes.berg> (sfid-20080926_212336_900050_2308343A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QdOous1hgjXmIY+/Vrhv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

[remove rt2400-devel, it always annoys me]

On Fri, 2008-09-26 at 19:50 +0300, Jouni Malinen wrote:

> I believe the current version is not calling driver add_interface for
> monitor events by design.

Right.

> Whether this leaves some confusing information
> for tx() handler is an open question, though, or well, at least I did
> not go through the current code now to verify what exactly is happening
> there.

No, it does, there's a bug in that despite never telling the driver
about monitor interfaces, we still pass it the monitor interface vif
pointer in TX.

> There has been some discussion on the use of monitor interfaces for
> injecting frames in the context of how management frame protection (IEEE
> 802.11w) should work with hostapd. The current design is not ideal and
> mac80211 should really be converting the netdev from mon.wlan# to wlan#;
> it just does not have enough information to do this if there may be more
> than one virtual netdev for the radio..

Right. What I've done in

commit 166a7cfdff64211f90b9ea60ec7dc302cf39b20f
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Fri Sep 12 22:52:47 2008 +0200

    mac80211: fix virtual interfaces vs. injection

is that it takes the TA to match up, that is incomplete when you have
WDS or something configured but should be better than the current
behaviour.

>  One option that has been
> discussed is to add a radiotap parameter to indicate the interface for
> the injected frame. This way mac80211 should be able to map it to the
> correct interface and the driver would not get into this sort of
> situation where it gets a frame from an unexpected interface.

That's what I'm aiming for.

> As far as the crash itself is concerned, this may be an issue in the
> driver. Please note that net/mac80211.h explicitly notes that vif can be
> NULL for injected frames (i.e., frame from monitor interface).

Note that this is new behaviour after the patch above, in the patch
above I fixed rt2x00 to not crash when this happens. Hence, the affected
system is most likely before the crash above.

>  rt2x00
> seems to be doing some kind of mapping from vif to rt2x00_intf with
> vif_to_intf() in rt2x00queue_create_tx_descriptor(). That function
> handles the NULL case by not allocating a sequence number which itself
> seems incorrect;

That was intentionally done in my patch, people have been asking for
being able to inject sequence numbers, and when the TA is known then
mac80211 will not pass NULL.

> I'll leave the following details in for whoever is reading
> linux-wireless and may have missed the original message..

Thanks.

Based on the information, I believe that this is fixed by the patch
above.

johannes

--=-QdOous1hgjXmIY+/Vrhv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI3TahAAoJEKVg1VMiehFYwQoP/RUnX18wWSor7jop43fDZLgG
B3QMU6Mjro1LgaArBJX0v4F2QH3EEQUIx4AnG0DZudbKoHXAI0rZ+hYLXzp4ysTM
sqkePt2hM7I1BS4IyLaeZ4DU9qNpSss8P4vpJtqX9f6Xl1bmXSLz8Z4cr4Hkdxz/
/qsTU8jt2CCPlK1Vki9aOh5axXdOsZgyJ0ksAe82os9zF0EnhmYXNvtpdBKReRmB
NVLHbNmw+962uzyiXM7SuEAeVN4VuREs+9voUgax4PMZ/SFQbAeTb4hmKFwlKw9t
kEz5EB+q2Cl1Fw+7kGOtq+RTqNZRLG8Gipo++Glkfdls1ZbY8AdT+SF7QxvzHs6z
2bn6QELZH8iL1n6wIbw1VBPLtBElfG6zzSGON9d4BeEXIIvr4bXuXRqkl00wmOs8
odKu5BeYgAqz7Y+rcv2AVaQLztJDT0moY4rcJEP/7v60q3Mh5/GkGdS+ZhW6yxTZ
xGutmoSNu84xJ+D5ldCHnQYqqwE9B87f/v9fRriGdlf2+qVrsSnIFwG3369oZmfg
QxcyeHXhzEyYY2xch4SV6kzz8WQm969QPG09P/7vrAqgUrg88raK5ElI22qJDV+z
wg0yAIOQ51iOXeendOz3EBJl2jc9+4+fwakVAzV3uICquNQ30z23jrylyHPc84Xl
gTSrXbtRsAMs1PACmQuE
=m2lM
-----END PGP SIGNATURE-----

--=-QdOous1hgjXmIY+/Vrhv--

