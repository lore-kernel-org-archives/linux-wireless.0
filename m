Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=109.224.244.121
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793194040;
	b=5GbzLNzh+1RB0K3pIFtcHqfX1b3s3ykw5m3p7Pm5KMsqdnkobc+8k45TzwX5J72n93oN
	 2wK1oZmiiZ+xHHd6KlwfR5OIn5u5xP4dx+7iiks228CXpwTfzcsXJm5s4kC/gwXwSidFA
	 SY74tnwMVXkPwCwNhdVdHq7O5vBgL3GHPouTPD/4+tIpkgrbQdicFwR9c8b3+P8ORbhd0
	 s2zwUdEhO3pHQUIwWBHyKkNPoQAye4ItmxAdndF5JAxiOIlxJMbpRkP4TerPnCJz3nK2J
	 bf26LRYc5l7hic9JrnLf/Rau08UJDXoKUCHcLTM2LQjLSzumxPMJCvZP+yVpjUsMfHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793194040;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 In-Reply-To:References:Feedback-ID:X-Pm-Message-ID:MIME-Version:
	 Content-Type;
	bh=A6GJLofawO/+zi4/7sWpSsUpHgHBirqyy+AePLtW8L8=;
	b=3RS4wpCrFu6Cmfeevqt2Zmbp6tdJZTC6eM77Gc42+Y6yJKaqfCyXes/VkzAazgz7w35V
	 ghIZeNctmle6wzIyC82HgCwl3o7tm/RvjuxIqeQAjPbYYM3ib0p2J+JrVS0OOHizQ0P9y
	 +RsgBu3gPUzX65kE5oAvoUo/0C6IoKgi8k10Efrmk+ZrrJwt97wQ/wCYWn58EFpd6jNS+
	 iBw0ldQ1CtfdiM0d913P/U0wtX9yvlndK+IxREvNFgdv+YqsQW+CSk/WWblVL2WlRnO26
	 v7Qvtbt9pd6FPEmsbnrdiTM7YgaHsvyGNWygsZIL+D5t5aogG08zbG0JBDo5nvDQilw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=protonmail.com;
	spf=pass smtp.mailfrom=protonmail.com;
	dkim=pass header.d=protonmail.com header.i=@protonmail.com header.a=rsa-sha256 header.s=protonmail3 header.b=UkuY5UVZ;
	arc=none smtp.remote-ip=109.224.244.121
Received: from mail-244121.protonmail.ch (mail-244121.protonmail.ch [109.224.244.121])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81FCA606A33F;
	Wed, 28 Oct 2026 13:27:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 81FCA606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=protonmail.com header.i=@protonmail.com header.a=rsa-sha256 header.s=protonmail3 header.b=UkuY5UVZ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1793194036; x=1793453236;
	bh=A6GJLofawO/+zi4/7sWpSsUpHgHBirqyy+AePLtW8L8=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=UkuY5UVZ9i0jdy+CiIvBdmzYu1dcC/Zokz6IQqSzWyRapk+PfNrV9uqQgx1yprV2P
	 D8z6PaT6+WXDQrGIaV8ps6DvxazII31dPMvpzsO4/ezXbyGZcPga3e8bXylj5G6gSw
	 d1kzwt/WfTa8l0icF4jH85JWUt8+AnjLpTvOz7UB4eG96gKvZlFGYnPTlWxlOI9+8l
	 WXu0pSeJHvZBnJELSDN709eEGZ7YQAEmiKaybb70Q/EUePKWorvJygHfuZZeS53SBl
	 v35KS/CXjoLOB+KWkPjU/Ds/foE0d2LVX+fknUUJ/No/8FXF4h9zZABIwu71dnqfSM
	 5BmfA3IBPJhTg==
Date: Wed, 28 Oct 2026 13:27:11 +0000
To: Alessio Ferri <alessio.ferri@mythread.it>
From: vit9696 <vit9696@protonmail.com>
Cc: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>, Michael Buesch <m@bues.ch>, linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org
Subject: Re: [PATCH wireless-next v2 7/8] firmware: bcm47xx_sprom: read boardflags3 and AvVmid_c0..2 from NVRAM
Message-ID: <C5853649-F843-4533-89D7-7E36B54372E4@protonmail.com>
In-Reply-To: <20261027-bcma-ac-rev1-v2-7-b69b61c31920@mythread.it>
References: <20261027-bcma-ac-rev1-v2-0-b69b61c31920@mythread.it> <20261027-bcma-ac-rev1-v2-7-b69b61c31920@mythread.it>
Feedback-ID: 739018:user:proton
X-Pm-Message-ID: 3f3119bd226a7b628a6c5713a0831c5712485f21
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha256; boundary="------bef7a0702c170b7e09f9f09c7e068bdd4556e7264843297ddaaf53831cec5aec"; charset=utf-8

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------bef7a0702c170b7e09f9f09c7e068bdd4556e7264843297ddaaf53831cec5aec
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.4\))
Subject: Re: [PATCH wireless-next v2 7/8] firmware: bcm47xx_sprom: read
 boardflags3 and AvVmid_c0..2 from NVRAM
From: vit9696 <vit9696@protonmail.com>
In-Reply-To: <20261027-bcma-ac-rev1-v2-7-b69b61c31920@mythread.it>
Date: Wed, 28 Oct 2026 16:26:57 +0300
Cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
 Michael Buesch <m@bues.ch>,
 linux-wireless@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 linux-mips@vger.kernel.org
Message-Id: <C5853649-F843-4533-89D7-7E36B54372E4@protonmail.com>
References: <20261027-bcma-ac-rev1-v2-0-b69b61c31920@mythread.it>
 <sTt-cgVrqE0COhM_6wYkpmZJbQu8hUP8ZIA0l6gf74lag0S47_DPBAt2USH3vcEFulu2KOgvDOioL-DQm5sFoA==@protonmail.internalid>
 <20261027-bcma-ac-rev1-v2-7-b69b61c31920@mythread.it>
To: Alessio Ferri <alessio.ferri@mythread.it>
X-Mailer: Apple Mail (2.3864.700.51.1.4)

I think my previous message regarding 6/8 also relates to the change here i=
n 7/8.

You are right to observe that NVRAM overrides are generally used to set not=
 just GPIO leds but also PHY properties. Some of these variables are actual=
ly present in the open-source driver[1].

Whether or not you need to support them generally depends on the hardware. =
I personally do not remember seeing AvVmid_cX being set on BCM4360, I think=
 it is generally set only for BCM4354. The proprietary driver might observe=
 these variables regardless of the general configuration presence perhaps f=
or unification purposes, but I am not sure this is needed for any BCM4360 i=
n the wild.

Do you have an NVRAM dump with AvVmid_cX set for any BCM4360 hardware? If n=
ot, the AvVmid part is probably a no-op and I would not rush adding that. T=
he amount of overrides supported by Broadcom drivers in general is quite la=
rge, dozens of vars, and it is probably best to add them based on NVRAM dum=
ps to reduce the amount of potential format parsing bugs.

In general defaultsromvars_4360 array[2] is a good reference of which varia=
bles are generally found in the NVRAM. You can see e.g. boardflags3 there.

Best,
Vitaly

[1] https://github.com/RMerl/asuswrt-merlin.ng/blob/ca72a61f8bc5ef920e29d63=
d53d9864262208f0c/release/src-rt-5.04behnd.4916/bcmdrivers/broadcom/net/wl/=
impl103/main/src/shared/bcmsrom.c#L2823
[2] https://github.com/RMerl/asuswrt-merlin.ng/blob/ca72a61f8bc5ef920e29d63=
d53d9864262208f0c/release/src-rt-5.02axhnd/bcmdrivers/broadcom/net/wl/impl5=
1/main/src/shared/bcmsrom.c#L598


> On 27 Oct 2026, at 02:53, Alessio Ferri <alessio.ferri@mythread.it> wrote=
:
>=20
> Read them along with ledbh4..ledbh15. AvVmid_cN holds the Av/Vmid pairs
> of chain N's power detector per band; avvmid_valid marks the chains
> whose list parsed. A boardflags3 in NVRAM overrides the SPROM word.
>=20
> Signed-off-by: Alessio Ferri <alessio.ferri@mythread.it>
> ---
> drivers/firmware/broadcom/bcm47xx_sprom.c | 32 ++++++++++++++++++++++++++=
+++++
> include/linux/ssb/ssb.h                   |  3 +++
> 2 files changed, 35 insertions(+)
>=20
> diff --git a/drivers/firmware/broadcom/bcm47xx_sprom.c b/drivers/firmware=
/broadcom/bcm47xx_sprom.c
> index 75604cd70..581dd867d 100644
> --- a/drivers/firmware/broadcom/bcm47xx_sprom.c
> +++ b/drivers/firmware/broadcom/bcm47xx_sprom.c
> @@ -173,6 +173,32 @@ static void nvram_read_alpha2(const char *prefix, co=
nst char *name,
> memcpy(val, buf, 2);
> }
>=20
> +/*
> + * AvVmid_c<core>: Av,Vmid of the chain's power detector for 2g, 5gl, 5g=
ml,
> + * 5gmu and 5gh. The chain is marked valid only if all ten values parse.
> + */
> +static void nvram_read_avvmid(const char *prefix, int core,
> +      struct ssb_sprom *sprom, bool fallback)
> +{
> + char name[sizeof("AvVmid_c0")];
> + char buf[64], *p =3D buf, *tok;
> + u8 v[10];
> + int n =3D 0;
> +
> + snprintf(name, sizeof(name), "AvVmid_c%d", core);
> + if (get_nvram_var(prefix, NULL, name, buf, sizeof(buf), fallback) < 0)
> + return;
> + while (n < ARRAY_SIZE(v) && (tok =3D strsep(&p, ",")) !=3D NULL) {
> + if (kstrtou8(strim(tok), 0, &v[n]))
> + return;
> + n++;
> + }
> + if (n !=3D ARRAY_SIZE(v))
> + return;
> + memcpy(sprom->avvmid[core], v, sizeof(v));
> + sprom->avvmid_valid |=3D BIT(core);
> +}
> +
> /* Variables read from NVRAM whether or not the SPROM itself comes from i=
t. */
> static void bcm47xx_sprom_fill_nvram_only(struct ssb_sprom *sprom,
>  const char *prefix, bool fallback)
> @@ -185,6 +211,12 @@ static void bcm47xx_sprom_fill_nvram_only(struct ssb=
_sprom *sprom,
> nvram_read_u8(prefix, NULL, name, &sprom->gpio_ext[i], 0xff,
>      fallback);
> }
> +
> + nvram_read_u32(prefix, NULL, "boardflags3", &sprom->boardflags3, 0,
> +       fallback);
> + sprom->avvmid_valid =3D 0;
> + for (i =3D 0; i < ARRAY_SIZE(sprom->avvmid); i++)
> + nvram_read_avvmid(prefix, i, sprom, fallback);
> }
>=20
> /* This is one-function-only macro, it uses local "sprom" variable! */
> diff --git a/include/linux/ssb/ssb.h b/include/linux/ssb/ssb.h
> index 02e6c9054..5a4daa76d 100644
> --- a/include/linux/ssb/ssb.h
> +++ b/include/linux/ssb/ssb.h
> @@ -77,6 +77,9 @@ struct ssb_sprom {
> u8 gpio2; /* GPIO pin 2 */
> u8 gpio3; /* GPIO pin 3 */
> u8 gpio_ext[12]; /* GPIO pins 4-15, NVRAM ledbh4-15 only */
> + /* NVRAM AvVmid_c0..2: {Av, Vmid} for 2g, 5gl, 5gml, 5gmu, 5gh */
> + u8 avvmid[3][5][2];
> + u8 avvmid_valid; /* bit per chain whose AvVmid_cN parsed */
> u8 maxpwr_bg; /* 2.4GHz Amplifier Max Power (in dBm Q5.2) */
> u8 maxpwr_al; /* 5.2GHz Amplifier Max Power (in dBm Q5.2) */
> u8 maxpwr_a; /* 5.3GHz Amplifier Max Power (in dBm Q5.2) */
>=20
> --
> 2.34.1
>=20


--------bef7a0702c170b7e09f9f09c7e068bdd4556e7264843297ddaaf53831cec5aec
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: ProtonMail

wsCpBAEBCABdBYJq4fguCRBPsoxt7Hy0xTUUAAAAAAAcABBzYWx0QG5vdGF0
aW9ucy5vcGVucGdwanMub3JnF8Z1/uXcH+9FW8tp6UrVzBYhBERSlkTqW1Te
3v1Bj0+yjG3sfLTFAABehgf/Xoqr6Y2LViLXrDck2wIs+j6LIR0df/G97Vpu
8q6PBbs0rz03t8o9FH+M/dzthx74PiW7YhXARH+OCudSrjrOBr7nQWSdrnHf
tF6tWAVwjeZOjv2AyeXaahH7alaJg0VB9PDEXYJS16+HkZ3KLzHNheXulfpn
g/u6bYSNaD0VVYCCf9tCr9CcjqppM40IxvIPfludWsSeIaxf6j1mlJK3rf/r
yyok3UeB73TluoOhMgLU2bBANcbee5oh9J5E7zrzw6qpMBDB7r+0rs5u+eFB
VqX7ClEZFHaTRYSd47axYAvTkdA8l8ihfDtSpFii8yLzFlek1qQZOwlPVLnT
aLLLOg==
=qryN
-----END PGP SIGNATURE-----


--------bef7a0702c170b7e09f9f09c7e068bdd4556e7264843297ddaaf53831cec5aec--

