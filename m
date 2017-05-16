Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:55440 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751960AbdEPKSf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 May 2017 06:18:35 -0400
From: Simon Wunderlich <sw@simonwunderlich.de>
To: Bastian Bittorf <bb@npl.de>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        benjamin@sipsolutions.net
Subject: Re: [PATCH 0/7] extend mac80211 mesh DFS and CSA functionality
Date: Tue, 16 May 2017 12:18:28 +0200
Message-ID: <4020776.cO0ANP896r@prime> (sfid-20170516_121838_947409_D5E168EF)
In-Reply-To: <20170516094403.GX18518@medion.lan>
References: <20170516092316.15636-1-sw@simonwunderlich.de> <20170516094403.GX18518@medion.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4518552.tkm0uLzUUv"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart4518552.tkm0uLzUUv
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi Basti,

On Tuesday, May 16, 2017 11:44:04 AM CEST Bastian Bittorf wrote:
> * Simon Wunderlich <sw@simonwunderlich.de> [16.05.2017 11:35]:
> > This patchset adds DFS and CSA functionality:
> thanks a lot. can you give a brief 'iw event' output when applied:
> for a two-node mesh, where station A detects CSA and station B
> should emit an event...

The idea would be:

 * station A detects a Radar, and informs userspace
 * userspace of station A will initiate a CSA, kernel will execute it (action 
frame, beacons)
 * station B picks up the CSA, and executes it as well
 * station B also marks the channel as unavailable
 * both station A and station B will send an event to userspace once the 
channel switch is complete
> 
> question: there is no userspace part for now, or maybe planned?

I've got some patches for wpa_supplicant here, but they are still quite dirty 
...

> 
> bye, bastian - now it's time for battlemesh.org 8-)

See you at battlemesh :)

Cheers,
     Simon


--nextPart4518552.tkm0uLzUUv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE1ilQI7G+y+fdhnrfoSvjmEKSnqEFAlka0fQACgkQoSvjmEKS
nqEJTg//QCn3OKk4xOXi0Mz0Osp12XcN4ROhHak0bHEW6V3x0rJ5uSeq1rXKmwtr
cryZakEOQbtvIKlq03QQjakNkgFb0a/NvRzzR8Uz+uqH2qjeKEBfLRCKbEIbqo22
UHc/wgzoHKcM8aJCZQX/pNcnRvk741AQ0aeJM+IAIUy6KxYuoH8tEqAIG+JjUB0d
Tmre5w/9s+ELC4er9JpQCGJM4+7VjgK1fKKAtSKI08NU7COagEIKdHx6+37jffcZ
R9xMeFMwo9PamQr8FZhxFV9iH7H7CHe/zPvwrQtLJ+jsOPaqwap5lpIu58Kl2+Yo
ZR8pahFlTTPYodGflyfeXC5ZxObHvWqdtwWiwVDWmeiUVly2tC9mMbeJssljvHc6
BQDYF/rT1VZGomShnjg3/pzY09OCgWnPfZ0+Oy8JLtui0v54K9X7Xbvegw3nU7O+
cIkZH+VSHfA965b5V7e2E3tStRUigc5y9vAxS/SbJjuuBDsj7toxH50gYNubGVY1
YyuEvKg6/y47ndVCWfVPSP3xe3GIKXl/A2ft6AiKSPnKQVFrmPcPU4R9Nr1KLGIk
3RC34suksEeERh8UHainKbPuWLA3GMAmEUV18ZO+uOnq/HN+ansVHBpZqi0OrkbX
x5M6JehQD7pUKBPGkxT2tvIyb1mj5PGF/WQdEuq7WsTyK85ov/g=
=g3Sl
-----END PGP SIGNATURE-----

--nextPart4518552.tkm0uLzUUv--
