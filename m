Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:55902 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750765AbdEPMFC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 May 2017 08:05:02 -0400
From: Simon Wunderlich <sw@simonwunderlich.de>
To: Bastian Bittorf <bb@npl.de>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        benjamin@sipsolutions.net
Subject: Re: [PATCH 0/7] extend mac80211 mesh DFS and CSA functionality
Date: Tue, 16 May 2017 14:04:58 +0200
Message-ID: <1769212.Lb3ncQ3XiW@prime> (sfid-20170516_140505_785228_41B49E55)
In-Reply-To: <20170516115546.GZ18518@medion.lan>
References: <20170516092316.15636-1-sw@simonwunderlich.de> <4020776.cO0ANP896r@prime> <20170516115546.GZ18518@medion.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2150044.bgWHYhYXW0"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2150044.bgWHYhYXW0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Tuesday, May 16, 2017 1:55:46 PM CEST Bastian Bittorf wrote:
> * Simon Wunderlich <sw@simonwunderlich.de> [16.05.2017 12:24]:
> >  * station A detects a Radar, and informs userspace
> >  * userspace of station A will initiate a CSA, kernel will execute it
> >  (action> 
> > frame, beacons)
> > 
> >  * station B picks up the CSA, and executes it as well
> >  * station B also marks the channel as unavailable
> >  * both station A and station B will send an event to userspace once the
> > 
> > channel switch is complete
> 
> ah, I remember the slides from last battlemesh.
> 
> The "problems" in userspace are: we must maintain a global list
> (so each node) which channel is the next best and we must time
> the final channel switch. IMHO the specs are saying, that we must
> switch within 30 secs after detecting the first radar-pattern.
> Also we must mark/show the new channel somehow for new/crashed/upcoming
> nodes. quite hard...

The timing is not a big problem, since the switch does not happen immediately 
but is performed after a "countdown" which is part of the channel switch 
announcement IEs. The specific rules for the countdown depend on the regulatory 
domain, but it's usually something between 1 and 5 seconds where payload traffic 
must not be transmitted (at least for the DFS case).

The bigger problem appears when a node is missing the CSA for whatever reason, 
or is joining the network - worst case, the mesh network can split into clouds 
on different channels. This is where we need the global list, or showing the 
next channel, etc. :)

Cheers,
     Simon

--nextPart2150044.bgWHYhYXW0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE1ilQI7G+y+fdhnrfoSvjmEKSnqEFAlka6uoACgkQoSvjmEKS
nqFNzxAAxEhjW9tVzQg/OXxDcXrFBeZwnBltFI5k3Wrlt3PyqYMEFzG8YHskxJ+F
LnS8qD5tW4i9tRUXzRLkMBMat0ot6+y/BwYMY+uUyy38s52gIu3qPqzYq4Yj/qaX
DbHUoZIYCB2KbUqRwWc8j8e/5/33BTfXdXWsWJnJWzYXhr2+5Bmg22cYxneqet/n
ogJVt15hbWamNxEoHmhEZZHWmRVB/nfvAIP6xAkA1E52ng0sJmA4B5regbP9zJPu
y9SE73/e927OsP/zKhxLSyLIaqj7DImBiam0ekI6tQ5nZ/PAwiUiP2eINHAHHnrk
n0c9vbpEvpOoXgh7XLj7T+plC9nzJv0u/z6eq7+4V507xKtiJirvdm2JMPtcG/HJ
x3M0bXv7g6BDwORA27cu8s74LMck/j+4EbzU52clo/0JtQaqCn6Os95npYhzx62F
uaxrI2UpvjZ6K99vwK4uEqqpyBUA/EKfA1GCGqGdIbg+lSgKcJZeZkDACLxD3daY
e+CKQXE72+k/OvwO5DrVJoPdKcJcbEtM8IymjrepQ9A/uQjwaopizan14hp6Xpad
EZA9esFFPdMoW/59XELBpJtwt/o3uj5UwEe1Aq9pMhXCMGBkilQ/nWkO8lHt/hgx
yEFIYItq2Mfrt1CK0ouQWSIPEf2DMa3iSN2dEN8O5K7m8PH18uc=
=xA8c
-----END PGP SIGNATURE-----

--nextPart2150044.bgWHYhYXW0--
