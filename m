Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:59687 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941992AbcJZNaw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Oct 2016 09:30:52 -0400
From: Simon Wunderlich <sw@simonwunderlich.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Antonio Quartulli <a@unstable.cc>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mac80211: passively scan DFS channels if requested
Date: Wed, 26 Oct 2016 15:30:44 +0200
Message-ID: <3695104.eT68DNvmi1@prime> (sfid-20161026_153107_304978_9EC9BDDC)
In-Reply-To: <1477486736.4059.36.camel@sipsolutions.net>
References: <1447464560-28104-1-git-send-email-antonio@meshcoding.com> <3164753.QVH0CDzpbV@prime> <1477486736.4059.36.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart18943545.SbMCB4qdcx"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart18943545.SbMCB4qdcx
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"

On Wednesday, October 26, 2016 2:58:56 PM CEST Johannes Berg wrote:
> > (NOTE: going off-channel while operating is a different topic).
>=20
> Why do you think it's different?
>=20
> Seems exactly the same to me, since you come back to the channel and
> start sending without any new checking?

There are two ways to leave a channel:

1.) Leave the operating channel "permanently". Then the ETSI 301 893 says:
"If no radar was detected on an Operating Channel but the RLAN stops operat=
ing=20
on that channel, then the channel becomes an Available Channel." (4.7.1.4=20
Master Devices (c))

Then we can select a new operating channel and re-start the process.

2.) Off-Channel CAC: This is an optional feature. Simply spoken, we keep th=
e=20
channel operating, but try to do CAC-checking on a different channel by=20
shortly switching to that new channel from time to time. The new channel mu=
st=20
be checked for a longer time than the standard CAC time (6 minutes for non-
weather radar channels in ETSI).

The main difference is that we keep the current channel as "operating chann=
el"=20
and are also required to be able to detect radars with the same probability.

Also note that this feature is not implemented in Linux as far as I know, a=
nd=20
personally I haven't seen it in the wild yet.

=46rom 4.7.2.3.1:

"Off-Channel CAC is defined as an optional mechanism by which an RLAN devic=
e=20
monitors channel(s), different from the Operating Channel(s), for the prese=
nce=20
of radar signals. The Off-Channel CAC may be used in addition to the Channe=
l=20
Availability Check defined in clause 4.7.2.2, for identifying Available=20
Channels.

Off-Channel CAC is performed by a number of non-continuous checks spread ov=
er=20
a period in time. This period, which is required to determine the presence =
of=20
radar signals, is defined as the Off-Channel CAC Time.

If no radars have been detected in a channel, then that channel becomes an=
=20
Available Channel."

Cheers,
     Simon
--nextPart18943545.SbMCB4qdcx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCgAGBQJYELAEAAoJEKEr45hCkp6hmNkP/iLv9+2LoKX6gzPzNs++uS7i
0xwb19FvgweTl4/Pq/oKuB+7rJ73zU+kYsUzX2J6F7W39ellagj1HJgmyEqzSmCW
w+x60P7UcxgrrDzoQ6oR7aeopvwpJKX6z32tV280llXgfL8eQC6Td+DYWZ5rY5M2
FNsw80x15PzvcAjCqvGAoi+PEB9O1m9ApmgTxOCHyoMR3FYfZA2OrQmeGYwomDDP
GTxSbnL4J1AKyc8s1ah2OWgzl6Jn1LnilGa0Zh4xS2gZTKTmgHjFB2sg5IvT3V/7
WjeyLOfZAt0K1q/8/EbBcum0oHjw93eaR5QE59c9xoNbMiHoh1EtYAvmWGgAxB93
t15GJGD3pJbSZAqBeMGBw4o3cp+zEOvYRah99H3JV+SO+v1J82HjBNh49QtAKCuM
sYIegWWlXGAo+sFpK9IyDE5Yz2nt6oCUr8DmoGzIWZuCXPYh7IgvFIc0W7y2jCjs
HXmFBn2fwcpik79HtvoBo/B/NaxdOyEduJWvDtpKEFZm8ileOpefTwgqdaog7kxB
JxdomyX4EO7BYK2mKq5u0dRTvIJX+JI4rKTBR/L0pl1JhCm2Jo9Ga6ByIO+gdMqp
AUaBZGAqeIvUFe2y9msvOkrha5xM/fDMM+lqGkh9YqrIV/+Z0dhIw/X4RauIc6/E
f0UVBU1hpDmVLSs5GVjy
=xxgA
-----END PGP SIGNATURE-----

--nextPart18943545.SbMCB4qdcx--
