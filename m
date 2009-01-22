Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52329 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641AbZAVNE1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 08:04:27 -0500
Subject: Re: [RFC PATCH v2 0/2] mac80211: ps-poll implementation
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: vivek.natraj@gmail.com, linux-wireless@vger.kernel.org
In-Reply-To: <20090122114240.31443.18218.stgit@tikku>
References: <20090122114240.31443.18218.stgit@tikku>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1qPDJXbabphJs1JCUU5B"
Date: Thu, 22 Jan 2009 14:00:09 +0100
Message-Id: <1232629209.4224.2.camel@johannes.local> (sfid-20090122_140433_042549_C63C9D1B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1qPDJXbabphJs1JCUU5B
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-01-22 at 13:45 +0200, Kalle Valo wrote:
> Here's my suggestion for how to implement ps-poll in mac80211. Also
> this fixes the case when dynamic_ps_timeout is zero.

Looks good to me.

> I decided to use ps-polling when dynamic_ps_timeout is zero. If
> userspace sets timeout to zero, it means that it's ready to sacrifice
> throughput over power consumption. But in case there throughput is
> more, userspace can set timeout to a non-zero value and null frame
> wakeup is used instead, throughput is higher but power consumption
> also increases.

Not a bad choice.

> Most probably this patchset breaks ath9k multicast handling. I
> recommend ath9k to try do multicast tim bit handling in hardware, I
> would really assume that to be possible. But if that's really
> impossible, then it can be done in the driver. But having support for
> waking up multicast tim bits in mac80211 is unreliable and complicated
> the implementation, I just recommend dropping it.

I agree, we should push this as close to the device as possible.
mac80211 has to defer to a workqueue which adds latency, while if this
really needs to be done in software the driver can do it much faster
because it doesn't necessarily have any generic workqueue requirement
and can possibly even wake the hardware in irq context.

> Open question is that should power save be disabled whenever mac80211
> is ps-polling the frames. For example, p54/stlc45xx does not require to
> disable power save in that case, it just stays awake long enough to
> receive the data frame from the AP. So I did not disable power save
> mode in this case, but I would like to hear comments what other
> hardware needs.

I just checked, Broadcom's hardware/firmware definitely requires doing
this in software.

johannes

--=-1qPDJXbabphJs1JCUU5B
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJeG3VAAoJEKVg1VMiehFYtkQQAKBUVBHQ/CG2qnrknO2rVrW0
GriWjSILb/Ii482mzbfLMNVy0a6DvuNznCGSj8zxrIOLpCgeJHlwqnkH5ho5pMUG
768zXDDHhTYhyHVF9E2uEOMtryPVS00aFMbRTSpu0PF3U8AG/ZN5igQQ0t1zMF1V
sjSL3RdbEjNfqgqteMr8bwd5dGky9CsNVJ07t5KUlMV0uF/q8pjQF1nE6eIlu6HP
R+7RHczkh0ObT2k3wu0aoWDFbzlVWP39I4OhLo25HPKQQkNyCX3ame+EDPAyIoyO
g/5zsLTxDSaijKco5WwBmI3QtrNp0EI5bs6oVtOME+E9ijb2H4A6wRsN5VJ/SvCa
x6lBMl/hEy5ziPs1P79U+G0g3GxiamOSV2wUXIB2XVzgikY9e/lBAtr/PDPI32yL
twkPPbtQTVsO5AW2XasLkze8c+VVZS0v428j6TN2X1ILsCwtDoWig+6Dp7BT5XkA
fVb6Nw3VLIsGVX0vHHpofGgVY3W9DfxMv/I9dC9MrtJz57SgRfzexMhXrH7yviZg
8NfaoWBuBpMTy2adzzZtIkFX/KbyONflJ5qSEEtsCt95qEaHyW3UugQw5CpXcaHC
/08kBmFSR4yaQIMDiKi6hpRO2Xjdxagiyls10m5zpdgiaLCl4YTxm2KygBYNBkpZ
TN2miHdzIAzPlOJIRdWG
=BRpp
-----END PGP SIGNATURE-----

--=-1qPDJXbabphJs1JCUU5B--

