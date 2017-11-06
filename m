Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:48439 "EHLO
        mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751092AbdKFIXT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Nov 2017 03:23:19 -0500
Received: by mail-qk0-f176.google.com with SMTP id a142so1148850qkb.5
        for <linux-wireless@vger.kernel.org>; Mon, 06 Nov 2017 00:23:19 -0800 (PST)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>, ath10k@lists.infradead.org,
        akolli@qti.qualcomm.com, linux-wireless@vger.kernel.org
Subject: Re: ath10k: Fix reported HT MCS rates with NSS > 1
Date: Mon, 06 Nov 2017 09:23:13 +0100
Message-ID: <1728147.6Xy77nSgBU@bentobox> (sfid-20171106_092323_462516_23114937)
In-Reply-To: <94091927-c8a1-2918-749a-dc289686c268@dd-wrt.com>
References: <20170511090930.18205-1-sven.eckelmann@openmesh.com> <0a29ec25ec374a12adbc222af9a7dda1@euamsexm01a.eu.qualcomm.com> <94091927-c8a1-2918-749a-dc289686c268@dd-wrt.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart6482983.QmbLQlt97p"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart6482983.QmbLQlt97p
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Sonntag, 5. November 2017 10:22:22 CET Sebastian Gottschall wrote:
> the assumption made in this patch is obviously wrong (at least for more 
> recent firmwares and 9984)
> my log is flooded with messages like
> [208802.803537] ath10k_pci 0001:03:00.0: Invalid VHT mcs 15 peer stats
> [208805.108515] ath10k_pci 0001:03:00.0: Invalid VHT mcs 15 peer stats
> [208821.747621] ath10k_pci 0001:03:00.0: Invalid VHT mcs 15 peer stats
> [208822.516599] ath10k_pci 0001:03:00.0: Invalid VHT mcs 15 peer stats
> [208841.257780] ath10k_pci 0001:03:00.0: Invalid VHT mcs 15 peer stats
> 
> 
> i tested this with the 10.4.3.5-0038 firmware which isnt official 
> published but made from athwlan.bin i got from qca chipcode

Hm, yes there is most likely something wrong. But not sure whether this patch 
is actually the culprit. It looks to me like this would also be reported the 
same way without the patch. cec17c382140 ("ath10k: add per peer htt tx stats 
support for 10.4") seems to be your problem, right?

This patch only splits WMI_RATE_PREAMBLE_HT & WMI_RATE_PREAMBLE_VHT. And for 
WMI_RATE_PREAMBLE_HT (*not VHT*), it uses a slightly different approach. But 
the WMI_RATE_PREAMBLE_VHT part (which you see in your logs) is basically 
untouched.

Kind regards,
	Sven

--nextPart6482983.QmbLQlt97p
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAloAG/EACgkQXYcKB8Em
e0YPCBAAicvm6yibKn0b+LVu2oPiz3ca7xTVsaxLqudAu9dPCWPhWmm+9jNRwqMY
l3rll7Q0BYWDteRqYK9NvTzqeiFNETfdtYszfdR3z3OQ1Yj3IHLhmMIfjIQiNCyT
v8frzJdsPQs4wb0yzdUAqsHL1kKZ38XlD6YWvVIkYnkoI2TnF1ONpjSwkpOFWS4o
o8fum65Wtd+wplwHEopcIfM2WxDjHDVu6Yfk9ATJ2Od5RnmUwD9yzBk3RE86jV56
2ndCWP+0l9GKvmUq/txjqVToF4HZ/TCZWUdnYA2Bd3if0ruSvsnJNG/pXct45Sqi
XmZfkwVtmRlTLkh8EG2sonvj8tIXrwdYotFDNIDKUBtrXcjtpbEi2BGqLFd5ekRa
4cZY6c8E5YNJW/vG2suQwJHVCLoMQdF5iC+hHl0FAcR/bkL6XHGZEp/p2ggOJTUP
tXK6RRCpxJfxZslVYT6JVvr0hMUjah0tKHEYstjPlfamvdXU8tXx1VABXRRtXCbA
A6Q18NVly9gK9q0XePeDbaIzkiQxchBd3TZnrLIuNGGZDAewNfaSp4yOpfkFEtXy
t2dgi8hZ5Mn46lR+b/t/bjpxeKo9o+WsGNzyAqxNU212ZAlhb3IDIY4S0rgWp9BI
pzSUW7i3iyDIm1Vo5KjEGigNa4hoh5UC0XLywOipkFXxjHZ7lmI=
=ZukK
-----END PGP SIGNATURE-----

--nextPart6482983.QmbLQlt97p--
