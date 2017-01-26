Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:52654 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751762AbdAZKPD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Jan 2017 05:15:03 -0500
From: Simon Wunderlich <sw@simonwunderlich.de>
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org
Subject: Re: [PATCH 3/4] ath9k: check for deaf rx path state
Date: Thu, 26 Jan 2017 11:15:00 +0100
Message-ID: <2448336.mzt5URIzpg@prime> (sfid-20170126_111621_999033_E3B9824B)
In-Reply-To: <809a5011-4361-0459-2937-5dd5b0d619c2@nbd.name>
References: <20170125163654.66431-1-nbd@nbd.name> <4839692.lfma8z9lJt@prime> <809a5011-4361-0459-2937-5dd5b0d619c2@nbd.name>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1823785.qAtEKLY57C"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1823785.qAtEKLY57C
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hey,

On Thursday, January 26, 2017 11:02:53 AM CET Felix Fietkau wrote:
> On 2017-01-26 10:50, Simon Wunderlich wrote:
> > Hey Felix,
> > 
> > On Wednesday, January 25, 2017 5:36:53 PM CET Felix Fietkau wrote:
> >> Various chips occasionally run into a state where the tx path still
> >> appears to be working normally, but the rx path is deaf.
> >> 
> >> There is no known register signature to check for this state explicitly,
> >> so use the lack of rx interrupts as an indicator.
> >> 
> >> This detection is prone to false positives, since a device could also
> >> simply be in an environment where there are no frames on the air.
> >> However, in this case doing a reset should be harmless since it's
> >> obviously not interrupting any real activity. To avoid confusion, call
> >> the reset counters in this case "Rx path inactive" instead of something
> >> like "Rx path deaf", since it may not be an indication of a real
> >> hardware failure.
> >> 
> >> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> > 
> > As we observed in the field, it may happen that there are still RX
> > interrupts triggered, but just a very low number - in which case I
> > believe your version wouldn't fix the problem. Therefore we had a
> > threshold in our original patch [1].
> 
> It seems that you were seeing something different than what I was seeing
> in my tests. Though it could be that my issues were actually caused by
> something else. I had queued up these changes a while back before I
> finally found and fixed the IRQ issue.

What we found a good threshold was to check for less than 1 RX interrupt per 
second, and check the mean average (about) every 30 seconds. If there is any 
other AP or a station connected, it will not reset the chip, and also there 
will be no reset on short outages.

However, Access Points "alone" somewhere without users may still accumulate a 
lot of false resets. Your name choice is better than ours in this regard, lets 
hope users understand that as well. :)

> 
> > We would also appreciate if you can at least briefly mention our work if
> > you resend/rework our stuff.
> 
> Sorry about that. I rebased this from older experimental patches and
> forgot to put in all the relevant context.

Cool, thanks!
    Simon

--nextPart1823785.qAtEKLY57C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE1ilQI7G+y+fdhnrfoSvjmEKSnqEFAliJzCQACgkQoSvjmEKS
nqHrIg//fNje1r5JUtyLM2CdkSdDlAbWJMSztPFsfcgfHBhmQimtmGIuHvEB4hVM
7HuGXAT56DNfa4JSR+IKeWM3m7tms7kMeWznrV6O1XWOE6A6v6tQ4e9E/vN9xilc
GMFzzE29EyEDrAbxUDSmAd4gevLXFJSdxzMqtWmmrspobDy5krNC7VjUIz4uTmV2
sTd+XR9Pn8oKKCIpqSQny+eouEOIIC/9vaFne2lMrSibips8i+p7Q9pzISbMenCz
kjWxT4Y6cPfK1xL6jmo4HCkYXNiywekTB0I8TZtpl6of4OevmF4ULPPDsFIHl9UB
e/GR6KCQJAHQ+d8B1QqOIs5nGtmJ1olTIi4bm63bGCfoUf4jMqSqMBvDWEBElu0L
buNKA9yj7T0UVt2DPASykT95caKf3wlNPL+KEbPE31DR1wc55NhsWO394iVStUxh
xlw96etPwc6R7NAOeiNstzSxkJ6OrXaGnfOIVjPRBxIGaEgskslT+bRiyPx1+dUg
zx0AE7R0OcfzblpKW/67AvsLJEEMqb0hgaFp/BmaWyo/m5ipcnQW7snfm/iCbbDe
Bpy1YljS93HfrDn63KxoiOyf7HjdJ7OYmEoeiJKvcvIMdpUrRGjsWRlj3MZm/dVp
0ddnsbEq6R57gL9lxakOnXb6jb6S1wow/H5G0BH0eKVixundH98=
=arT4
-----END PGP SIGNATURE-----

--nextPart1823785.qAtEKLY57C--
