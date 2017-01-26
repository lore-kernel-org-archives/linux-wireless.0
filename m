Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:52762 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752936AbdAZKdB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Jan 2017 05:33:01 -0500
From: Simon Wunderlich <sw@simonwunderlich.de>
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org
Subject: Re: [PATCH 3/4] ath9k: check for deaf rx path state
Date: Thu, 26 Jan 2017 11:32:58 +0100
Message-ID: <2081606.z26xgMiW1A@prime> (sfid-20170126_113304_574685_1C753E1A)
In-Reply-To: <8306f20d-ca2a-60fd-b0d9-5155f3bbd094@nbd.name>
References: <20170125163654.66431-1-nbd@nbd.name> <2448336.mzt5URIzpg@prime> <8306f20d-ca2a-60fd-b0d9-5155f3bbd094@nbd.name>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart5325287.0CA6Mu7U11"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart5325287.0CA6Mu7U11
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi Felix,

On Thursday, January 26, 2017 11:26:03 AM CET Felix Fietkau wrote:
> On 2017-01-26 11:15, Simon Wunderlich wrote:
> > Hey,
> > 
> > On Thursday, January 26, 2017 11:02:53 AM CET Felix Fietkau wrote:
> >> On 2017-01-26 10:50, Simon Wunderlich wrote:
> >> > Hey Felix,
> >> > 
> >> > On Wednesday, January 25, 2017 5:36:53 PM CET Felix Fietkau wrote:
> >> >> Various chips occasionally run into a state where the tx path still
> >> >> appears to be working normally, but the rx path is deaf.
> >> >> 
> >> >> There is no known register signature to check for this state
> >> >> explicitly,
> >> >> so use the lack of rx interrupts as an indicator.
> >> >> 
> >> >> This detection is prone to false positives, since a device could also
> >> >> simply be in an environment where there are no frames on the air.
> >> >> However, in this case doing a reset should be harmless since it's
> >> >> obviously not interrupting any real activity. To avoid confusion, call
> >> >> the reset counters in this case "Rx path inactive" instead of
> >> >> something
> >> >> like "Rx path deaf", since it may not be an indication of a real
> >> >> hardware failure.
> >> >> 
> >> >> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> >> > 
> >> > As we observed in the field, it may happen that there are still RX
> >> > interrupts triggered, but just a very low number - in which case I
> >> > believe your version wouldn't fix the problem. Therefore we had a
> >> > threshold in our original patch [1].
> >> 
> >> It seems that you were seeing something different than what I was seeing
> >> in my tests. Though it could be that my issues were actually caused by
> >> something else. I had queued up these changes a while back before I
> >> finally found and fixed the IRQ issue.
> > 
> > What we found a good threshold was to check for less than 1 RX interrupt
> > per second, and check the mean average (about) every 30 seconds. If there
> > is any other AP or a station connected, it will not reset the chip, and
> > also there will be no reset on short outages.
> 
> But if there's less than 1 Rx interrupt per second, then my patch should
> also trigger, right?

yes, that function you hooked in is called once a second. However, this will 
likely lead to one reset per second one a "lonely" access point, which could 
create problems for clients connecting the first time, or power-saving clients 
who don't talk much. It's not so unlikely that an AP will not hear anything 
for a full second, and the reset puts it out of operation for some time, too. 
(Not sure how much beacons etc are affected, for example) If you can check 
only every 30 seconds on the average, you would reduce this problem.

Cheers,
     Simon
--nextPart5325287.0CA6Mu7U11
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE1ilQI7G+y+fdhnrfoSvjmEKSnqEFAliJ0FoACgkQoSvjmEKS
nqFgmBAAuamsa/O3uksAUvFz5RY4aXWLpaPgRPTHWIEIacGHKOM6MWFlpQaK2Q6O
PJF7iu2Og2nellAANds9mtR05rrturYxB4uzafWQZrlN/Hy47wF8xLuzNIqly7K2
TRZR/YgbLGu4dnubiarizA8S+iVqOaYjKyjV3Owd/SjUs/h+HAM84bh50hP54DqT
lA5NmFsaidI7Dm5gYXPnXDFusZUgwG0UyGmCF6eLYYd8tgYOhNtP4IaTRv8vrO6M
LdiHC0r9BzXLcHHW3baIR1VzXkI1teXQoTIpFasJYSOBSK0xYRNWjcPvGGQcv8kM
tBGhcA2Zf8xfS2AVWZ/EgADQ2iMq+YnjyXQ2dyyz397UJEeHtRVPxwR0wJQg6akQ
BfWa+uZZaXCjBkQBReUqZYZ3fA5ad4C4ujIQCGBdxfwcl72zfzdHfUDmj8i3YDFY
+DkmZsfDnJOWAylpbZUE5IdN8VPXEYmaIUMk+tDXuGhiSCjsbzVA55HoE+jWJKU4
4mR/MbimC9cmgfFieJICbZM8eKu44oVjeqOowEilg3X1l/KW5aqoID6LQPFantZl
Eri6Dk+LIFYVAkIBXwhx49OGkF+0rRxD8xqyCbMId5gtsNcO6HsbbVMaGQmZsMOs
D0/JktJ2whco0Zye3I0JHSMR6LEwtccxEPlT6gCzudMprsRtVlU=
=3C6c
-----END PGP SIGNATURE-----

--nextPart5325287.0CA6Mu7U11--
