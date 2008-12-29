Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58913 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbYL2VGo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Dec 2008 16:06:44 -0500
Subject: Re: [PATCH] mac80211: Add IWSPY support to mac80211 stack
From: Johannes Berg <johannes@sipsolutions.net>
To: Ville Nuorvala <ville.nuorvala@gmail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <46fdfd70812291023q62f146edhbbfe7d9f9b9beb1f@mail.gmail.com> (sfid-20081229_192409_507086_3B774237)
References: <1230567920-16623-1-git-send-email-ville.nuorvala@gmail.com>
	 <1230568151.3116.63.camel@johannes>
	 <46fdfd70812291023q62f146edhbbfe7d9f9b9beb1f@mail.gmail.com>
	 (sfid-20081229_192409_507086_3B774237)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ZgD5JE5brWr3UUKSiXaR"
Date: Mon, 29 Dec 2008 22:07:08 +0100
Message-Id: <1230584828.3116.67.camel@johannes> (sfid-20081229_220648_165918_D4764796)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZgD5JE5brWr3UUKSiXaR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-12-29 at 20:23 +0200, Ville Nuorvala wrote:

> to my knowledge it is currently the only way to get a realtime
> indication that the wireless link quality has changed, please correct
> me if I'm wrong.

You should be able to obtain information out of nl80211 about the AP
you're currently associated with, namely via listing the stations.
Currently you can only get rate information, but that's a feature, since
the "quality" information "defined" by wext is anything but defined.

> Such a feature can be used as an early indication that the link is
> going down, and may help prepare a vertical IP layer handover to for
> example 3G or just another WLAN interface. The predictive nature of
> the event allows you (most of the time) to set up the other link
> before the WLAN link is down, which allows a make-before-break
> handover without packet loss. In fact such events are described in the
> IEEE 802.21 Media Independent Handover document. Ideally these events
> might be produced by the 802.11 firmware or at least somewhere lower
> in the stack, but lacking that, it can at least be emulated by the
> IWSPY interface. Also, as an added bonus for using IWSPY, you can
> choose the trigger signal levels yourself and don't have to rely on
> any preset levels chosen by the device manufacturer.

I really really don't like the iwspy interface, it also requires that
you explicitly monitor the AP you're associated to etc. IMHO any such
tool needs something that is more reliable and predictable than iwspy.

> I'm not bringing any new functionality to the wireless stack, I'm just
> reintroducing a feature that got lost when the wireless stack was
> changed.

For good measure, if you ask me!

> Sure a pure netlink interface without any ugly IOCTL hacks would be
> nice, but last time I checked the documentation for nl80211 and
> cfg80211 was nonexistent, and even driver_nl80211.c straight from the
> hostap GIT repository uses WEXT IOCTLs internally for several
> different purposes. To me at least it seems like the nl80211 interface
> is still far from ready. As my resources are currently very limited, I
> don't have time to implement the necessary netlink API and userspace
> tools at the moment. The logical conclusion for me was therefore to
> just use the old WEXT interface for now.

Then can you afford to keep porting the iwspy hack? I really don't want
to see this in the tree, especially not since the implementation is ugly
too by implementing purely wext stuff in the core mac80211 code.

johannes

--=-ZgD5JE5brWr3UUKSiXaR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJWTv6AAoJEKVg1VMiehFYyLYP+we/T6emvuguWSYRkMiHdMqW
pYOCTWb7NjqCu6IelRE/oLIceHRxR/UA9ihxWO3AIX/3YBFifg2HL/Km2PJFIr2g
T9Nyunj5dhi8Jip67oelhV3iaaZcWAEN07+sPLDz/a8FyIGKxXRF67jMRWF1UlrM
/fu+C/EzuAqNi6V23tqceu3wYN6455hxi6i1bHkW14BvDM4ILFvkpSDJJWlj9eT4
rOajuyLUPbOkofbyApQbbvS4RiQhVc07fD3aU8sYp3OQ+O0W/WULTaheToaYEdEc
yAG5OVAvCqVylxAX8e/BlUtaau5uX1vI0qfluNDRh4JfDjJngh1F9b9uES1+Mtk1
QMBjldkUNF6dV3A2XxzopwGLZmeQ60qv8nv2W/YW5FcUMf61iANvywCptVMIgUq4
BjEMRsche9DEYPk0NZE35+zSaFG5s6HNDMSeh4hjsCblEwVEvKz+ASNo12D5ZNs+
a4kqOIk1UXFuP8EnP3WLnQBHm1UmxKzPRZ4KCfCg2EoqKjiAeARl2PbO43rCT7bt
sOUR5oAB3klQWwvQpgE9T8FyqWWc57Teh/ZnnBfMW+PiPIqZMcFbhxkfXX4qZrGk
fnzBOtW56klK+ZhQcY2ur4NRfvfFdqO6DRbAINqtuFJKIiFeta1JYZtR+AUZUjxQ
fydYGb9yobbfPgQgpEoQ
=jGPz
-----END PGP SIGNATURE-----

--=-ZgD5JE5brWr3UUKSiXaR--

