Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from chaos.universe-factory.net ([37.72.148.22]:39932 "EHLO
        chaos.universe-factory.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932816AbcKPOkH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Nov 2016 09:40:07 -0500
Subject: Re: [PATCH] ath9k: fix ath9k_hw_gpio_get() to return 0 or 1 on
 success
To: Kalle Valo <kvalo@codeaurora.org>
References: <44116a7bca8524a187083916bdea535145e7a23a.1479232041.git.mschiffer@universe-factory.net>
 <8760nno6th.fsf@kamboji.qca.qualcomm.com>
Cc: ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath9k-devel@lists.ath9k.org, miaoqing@codeaurora.org
From: Matthias Schiffer <mschiffer@universe-factory.net>
Message-ID: <6d1da72b-33b5-b99e-69ac-8b8307ce60f0@universe-factory.net> (sfid-20161116_154021_423510_F29112B0)
Date: Wed, 16 Nov 2016 15:40:02 +0100
MIME-Version: 1.0
In-Reply-To: <8760nno6th.fsf@kamboji.qca.qualcomm.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="wCFaC2wrbntND5Mxwg8sigTxkf2OdfmV3"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--wCFaC2wrbntND5Mxwg8sigTxkf2OdfmV3
Content-Type: multipart/mixed; boundary="uLQ2strP7l1DpuImEW24jCSxigxHvxmQF";
 protected-headers="v1"
From: Matthias Schiffer <mschiffer@universe-factory.net>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
 ath9k-devel@lists.ath9k.org, miaoqing@codeaurora.org
Message-ID: <6d1da72b-33b5-b99e-69ac-8b8307ce60f0@universe-factory.net>
Subject: Re: [PATCH] ath9k: fix ath9k_hw_gpio_get() to return 0 or 1 on
 success
References: <44116a7bca8524a187083916bdea535145e7a23a.1479232041.git.mschiffer@universe-factory.net>
 <8760nno6th.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <8760nno6th.fsf@kamboji.qca.qualcomm.com>

--uLQ2strP7l1DpuImEW24jCSxigxHvxmQF
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 11/16/2016 03:08 PM, Kalle Valo wrote:
> Matthias Schiffer <mschiffer@universe-factory.net> writes:
>=20
>> Commit b2d70d4944c1 ("ath9k: make GPIO API to support both of WMAC and=

>> SOC") refactored ath9k_hw_gpio_get() to support both WMAC and SOC GPIO=
s,
>> changing the return on success from 1 to BIT(gpio). This broke some ca=
llers
>> like ath_is_rfkill_set().
>>
>> Instead of fixing all callers, change ath9k_hw_gpio_get() back to only=

>> return 0 or 1.
>>
>> Fixes: b2d70d4944c1 ("ath9k: make GPIO API to support both of WMAC and=
 SOC")
>> Cc: <stable@vger.kernel.org> # v4.7+
>> Signed-off-by: Matthias Schiffer <mschiffer@universe-factory.net>
>=20
> Can you describe more about the symptoms, how did this break from user'=
s
> point of view? I can add that to the commit log.
>=20

I did actually not experience an issue myself with a mainline kernel.

Looking at the functions ath_is_rfkill_set() and ath9k_rfkill_poll_state(=
)
in gpio.c, this issue causes wiphy_rfkill_set_hw_state() always to be
passed false when ah->rfkill_polarity=3D=3D1, breaking rfkill. I don't kn=
ow how
common devices with ah->rfkill_polarity=3D=3D1 are.

I became aware of this issue when rebasing an out-of-tree patch in LEDE
which uses the WMAC GPIOs to configure some kind of bandpass filter found=

in Ubiquiti hardware. (I hope to find time to get this patch upsteam at
some point...)

Matthias


--uLQ2strP7l1DpuImEW24jCSxigxHvxmQF--

--wCFaC2wrbntND5Mxwg8sigTxkf2OdfmV3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCgAGBQJYLG/CAAoJEBbvP2TLIB2cW4oQAN6YJrZkp8o2NabvqCm1WL5l
sHOjVH4VG2HdRPG8pjg2bnenNfqlxl2AZ/Nmc2ct/XciFnLpAj9dILiCzhB87Iig
tlBs5KHIKpm4aQ8g1I8Sp6rs+2X8YBZ4ucpmiwjJMsjnvXrSBBlQW7lEGUFLk0oc
8T4RCTHnKMz9dt+No6THgFw8y1E2KDg3rDx66rkJDD+AZFcNF5P6XVyYyGDlebll
H4JPGEMIY2Y+aRj0QeE+ijI/RucpBKtIf4oAHxoebtBO+bAyWvdE3ppuynaRRliR
4xXDCQTAa5odc4501zo1ZrPk25Lig+Vq03wIeGeu8yA+E/B57Kp9C6KFFHEn5L8Z
R2dBMbOh3AFDAPKzz7rGlNTCRbL4+GRuNYsH6hcg6jqFQ7HE+ft/3nrwybtBXXQ1
46RaH80zqMuDEwr0pEHC+GEYS+iu3Zpx4KGzboEhbTsFwO4D31NlsyL1/ZASRs0R
KUpGrjm/1LQO6keysKoqXthV0sAwC3LO0inuAGzOAl/LNxyebNB6J4RUaMPXUbrx
fgoB7Of4oc9Krr3dGY+iPMyFw7caNFl7YyUOppX6EYpo/bUOY6GB2ncg0dTZNArk
XkuBnnJ1niZO0tbqxpJPF5U38i8HILtusbiKosGXQDMFZS4Gz2/x8BgeD+SsjV0N
id+YruDA9hNYXrThdPAi
=pJTG
-----END PGP SIGNATURE-----

--wCFaC2wrbntND5Mxwg8sigTxkf2OdfmV3--
