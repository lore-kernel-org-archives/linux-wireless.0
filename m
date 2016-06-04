Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:54053 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbcFDUDN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jun 2016 16:03:13 -0400
Subject: Re: [PATCH] rtlwifi: Change long delays to sleeps
To: Kalle Valo <kvalo@codeaurora.org>
References: <1455574327-2591-1-git-send-email-Larry.Finger@lwfinger.net>
 <57530495.50302@web.de> <87fusssxqn.fsf@kamboji.qca.qualcomm.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
From: Jan Kiszka <jan.kiszka@web.de>
Message-ID: <575333EB.1060101@web.de> (sfid-20160604_220317_385956_F9AF9369)
Date: Sat, 4 Jun 2016 22:02:51 +0200
MIME-Version: 1.0
In-Reply-To: <87fusssxqn.fsf@kamboji.qca.qualcomm.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="WCFEgWEdhRMKoUtf3IA1a5bAtHd55m729"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WCFEgWEdhRMKoUtf3IA1a5bAtHd55m729
Content-Type: multipart/mixed; boundary="SJCbkLx6VuddDrprM5aWcrKxVsxLdncTu"
From: Jan Kiszka <jan.kiszka@web.de>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, devel@driverdev.osuosl.org,
 linux-wireless@vger.kernel.org,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <575333EB.1060101@web.de>
Subject: Re: [PATCH] rtlwifi: Change long delays to sleeps
References: <1455574327-2591-1-git-send-email-Larry.Finger@lwfinger.net>
 <57530495.50302@web.de> <87fusssxqn.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87fusssxqn.fsf@kamboji.qca.qualcomm.com>

--SJCbkLx6VuddDrprM5aWcrKxVsxLdncTu
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 2016-06-04 18:52, Kalle Valo wrote:
> Jan Kiszka <jan.kiszka@web.de> writes:
>=20
>> On 2016-02-15 23:12, Larry Finger wrote:
>>> Routine rtl_addr_delay() uses delay statements in code that can
>>> sleep. To improve system responsiveness, the various delay statements=

>>> are changed.
>>>
>>> In addition, routines rtl_rfreg_delay() and rtl_bb_delay() are
>>> rewritten to use the code in rtl_addr_delay() for most of their
>>> input values.
>>>
>>> Suggested-by: Byeoungwook Kim <quddnr145@gmail.com>
>>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>=20
> [...]
>=20
>> This breaks spectacularly when turning on a little bit of correctness
>> checking:
>>
>> BUG: scheduling while atomic: wpa_supplicant/1116/0x00000002
>=20
> This should fix it:
>=20
> https://git.kernel.org/cgit/linux/kernel/git/kvalo/wireless-drivers.git=
/commit/?id=3Dde26859dcf363d520cc44e59f6dcaf20ebe0aadf
>=20

Probably, will test later. But you should really work on making all
these task-context-only. Threaded IRQs?

Jan


--SJCbkLx6VuddDrprM5aWcrKxVsxLdncTu--

--WCFEgWEdhRMKoUtf3IA1a5bAtHd55m729
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAldTM+sACgkQitSsb3rl5xS13gCghEWxFzlOLXs+fIf7EQRLGpVu
7VEAnAsYE+V9V8nziVl7hwi3ge7UZEpF
=OAtT
-----END PGP SIGNATURE-----

--WCFEgWEdhRMKoUtf3IA1a5bAtHd55m729--
