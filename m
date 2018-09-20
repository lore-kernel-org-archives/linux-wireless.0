Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:54322 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727165AbeITQJ4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 12:09:56 -0400
From: Simon Wunderlich <sw@simonwunderlich.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
        mathias.kretschmer@fit.fraunhofer.de
Subject: Re: [PATCH] mac80211: allow scans on radar channels, unless there is CAC or CSA
Date: Thu, 20 Sep 2018 12:27:05 +0200
Message-ID: <2969898.mUHQksrBSp@prime> (sfid-20180920_122711_665008_BF9608CC)
In-Reply-To: <1537435276.3874.14.camel@sipsolutions.net>
References: <20180918141633.10282-1-sw@simonwunderlich.de> <1537435276.3874.14.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1879084.TGnE82qFNz"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1879084.TGnE82qFNz
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Thursday, September 20, 2018 11:21:16 AM CEST Johannes Berg wrote:
> On Tue, 2018-09-18 at 16:16 +0200, Simon Wunderlich wrote:
> > Operating on a DFS channel doesn't mean we can't leave it for a short
> > time - actually, some features like off-channel CAC work by leaving the
> > operation channel to check other channels for availability (although
> > off-channel CAC isn't implemented in mac80211). In our case, we want to
> > use mesh while doing background surveys on other channels from time to
> > time.
> 
> Actually ... as far as I can tell it *does* mean that, at least
> currently for FCC.


Mhm. I remember you said that before. But I can't find references for it. I 
checked the FCC 15.407 document [1] but couldn't find anything in favor or 
against that. Same for the measurement procedures [2]. I also couldn't find 
off-channel CAC in FCC, which I used for my argument in ETSI:

In ETSI 301 893 [3] they talk about non-continuous checks for off-channel CAC 
(in 4.2.6.2.3, second paragraph) and continuous period for CAC (4.2.6.2.2.2, 
first paragraph). Continuity is not mentioned for in-service monitoring 
(4.2.6.2.4), but off-channel CAC could only work when continuity is not 
required.

I'd appreciate if you (or someone else) can point me to where it's stated that 
we can't leave the channel for the a short time. I'm assuming that we are back 
fast enough to ensure the required detection probability.

Cheers,
     Simon

[1] https://www.law.cornell.edu/definitions/index.php?
width=840&height=800&iframe=true&def_id=41106ee4d951847389e55571a5e5e8aa&term_occur=1&term_src=Title:
47:Chapter:I:Subchapter:A:Part:15:Subpart:E:15.407
[2] https://apps.fcc.gov/kdb/GetAttachment.html?id=V2DzGgztnfxjTcht59nQ7Q%3D
%3D&desc=905462%20D02%20UNII%20DFS%20Compliance%20Procedures%20New%20Rules
%20v02&tracking_number=27155
[3] https://www.etsi.org/deliver/etsi_en/301800_301899/301893/02.01.01_60/
en_301893v020101p.pdf
> 
> johannes


--nextPart1879084.TGnE82qFNz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE1ilQI7G+y+fdhnrfoSvjmEKSnqEFAlujdfoACgkQoSvjmEKS
nqFvBQ//Wsu8aiPOeNCWk0RfPRtwFmiRdnO9JRH4IldRTciucij8/89jSI88Q22E
+57w4aP6vb1WNH4GE5K3nQ1iRBujxfrutPa0kr27hWUfvp3MEaUTyKsBWP6P6uAp
8MMIL/zML0r4p2cwLGnbyLrzewvv1HixsT19LrDFQ7aofw6lCMHsaHNcZpwc0kUc
IqCRBY3QuG+oYMoLjw3v2gw9uqYnbTNWSor7xbqEEsj6ZWYnuSl7wIAYAYjb76rP
e6Zw0lud1rF1oTUxdaeYSTHVj52mC70w23XypghwQwHhQBMFPZlvgu7tf1p3AnIy
379uSeV2Yp/0qxTCdY79uDEPd+c7VnJTRQJEtXyt6HXH14Bj4xEjqf1VdV4XmOVY
0kORnmb1z+MhFSm5HbtUZv/MeZI689oJFMbwZaMAsvHBZXsvMy0tVOsiC0rd1B1f
wiXHNlNgFM51/LNUKVqeDBiGMyplYp7Hn0OvGIMfcHQDqW9GS9ZTQF6GdHrk4/a8
+IDEHvNruzQygv4EINmtf0FUIrltxQttr2dCrj3UnLKK1ZxYvgGK7yjPU+yh99gq
NDdTvo+QwD6xVE3XLs4ERCWZZNPlqYn48Lp2zYRa50HF9AvJ1Cyd/lig+/OBh9wE
E14YUoqDqxlXZoE77LBjKSHBDYY1q0UCF6GLHGOi+klG86SuR2o=
=lURY
-----END PGP SIGNATURE-----

--nextPart1879084.TGnE82qFNz--
