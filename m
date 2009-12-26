Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from parez.praha12.net ([78.108.102.1]:35414 "EHLO parez.praha12.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752321AbZLZRzp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Dec 2009 12:55:45 -0500
From: =?utf-8?q?Luk=C3=A1=C5=A1_Turek?= <8an@praha12.net>
Reply-To: 8an@praha12.net
To: =?utf-8?q?=E6=B5=B7=E8=97=BB=E6=95=AC=E4=B9=8B?=
	<tkaiso@thinktube.com>
Subject: Re: [ath5k-devel] [PATCH 4/5] ath5k: Reimplement clock rate to usec conversion
Date: Sat, 26 Dec 2009 18:55:38 +0100
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
References: <4B32B76D.3090508@thinktube.com>
In-Reply-To: <4B32B76D.3090508@thinktube.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3838743.Ctjo2bnkjL";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200912261855.42408.8an@praha12.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart3838743.Ctjo2bnkjL
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 24.12.2009 01:35 =E6=B5=B7=E8=97=BB=E6=95=AC=E4=B9=8B wrote:
> ( sorry again for my last post which was corrupted. I do not why... some
> coding issue.. please be patient. )
=46or some reason your client tries to send the mail in UTF-16 instead of U=
TF-8,=20
so mailserver cuts the mail at the zero byte in the first character of=20
message body.

> My work did not include "coverage class". I just applied [3/5], [4/5].
> Before applying [4/5], ath5k_hw_clocktoh() takes care of 11a but 11g/b,
> and your new ath5k_he_get_clockrate() handles both 11a and 11b/g, correct=
 ?
> Therefore, I thought this can make difference in throughput. am I wrong
> on this point ?
But ath5k_hw_get_clockrate() is just a dead code until [5/5] is applied, an=
d=20
even after applying [5/5] it's only called on set_coverage() path, so it=20
couldn't make any difference in your case.

> 3Mbps/TCP is so low, isn't it ? how long is it between the two nodes ?
It's 3 megabytes per seconds, not megabits, as reported by wget. I haven't=
=20
done any real throughput test with iperf yet, so your results might be more=
=20
correct, but they shouldn't depend on my patches.

Lukas Turek

--nextPart3838743.Ctjo2bnkjL
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iQIcBAABAgAGBQJLNk4eAAoJEEBjvk/UOfYwJw8QALvune0TG6aozsN3HH24qUZl
9NR17n1HYpZLu6RTCwEgYQFzbZAMtWzyFvvabesmfsFjIXqTmNnvRflRM7Ju1Wa0
Zyn98+EGiu2/Cg2ZPCn8IS2Vk41nD/t5SyMQo2ZzLqWO458jvDqs/LXKVoMHEFhB
YA2d79rFWI2cT/sfn84ZXaj7gr4gPW+rsEDNbpFRxGFYNKMnVB3fYd/copuA/Ig0
74ZgJ/Dvq1telKRf9yq2hIv6WX3F0d8CX1ICPxQmzyOexPzv/MWUyAEo5Z/3J4oP
MecVrPNpsXQqQBIlQDIpt4kEIVzkCFG3EFbvcxEcdGzdnZXnWb3p2tFVbVoRH1mX
a8rCsl2z0AkXLtA5kWvZaf4tHXF2iWvds8CMVVnuc2xtdwCeCdWPwRozbOaB4kcp
aRrDyTWMxjxgmby3/wk2yatfdK3e0CzKrdWT6V78h0BhC4TLwxQ0z3t8Gq7tvAok
o85jvIOA6Ah5M2K/z443XsQJQTc79JDypSZAHDW+lxsbwTA0T1hOfkUhvt5dxOoB
XRkhrXaW9RqfCUximLLfcADEyHHkSL1KUQhGZf52xsfDpr/hHlE5PF46TsbERTdM
szYxq7eu+/OmhVO0lJHPhBx+IQKrEL7gE7WEXW/5SR87YuGJNS7n2rt1gZovquPz
RAyTXxmMd4j9mPIoVZUV
=d9qp
-----END PGP SIGNATURE-----

--nextPart3838743.Ctjo2bnkjL--
