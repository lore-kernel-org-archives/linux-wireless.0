Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.219
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792443937;
	b=KWJmd8oh415Ov0UbaW7RnsjlSHyWnnTXLwzJflrpMOhQHXSEmfMc31FiVZo0wDkZnHvE
	 RIMYFY/eeHNHxUrYgWQXklzjHBssM/UEclczvJdg0fGhKr3hanaQhP3PcDey1vP/n627e
	 Pb0xkBjk+Vgpc712fvsZ3n84hAaNpDv4Jh7In2cVXegkJCwTbm5yX0rpF69Kpv8AWt0no
	 yWxG050jRitPOCT6CLhUT9aGWb0Peb0k7KWSod1dood77Z6S7GWzKQ6LiT5yRaAy3W7qd
	 gsJcktaU4I58JNkBA2DtbVsqRhACs4360cINwfMSLfC3vhumkwpDarIx9UgwEl9j9eA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792443937;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:MIME-Version:Date:Content-Type:
	 Content-Transfer-Encoding:From:Message-ID:TLS-Required:Subject:To:
	 In-Reply-To:References;
	bh=Qdrj+8KDmXaKDWRZWRLUm1DHcz9Z8tRX9DZt/1oNYQg=;
	b=mzm78OMZ4w+aIWmQMhh1VQMV44gTfB7ArtfSUFzO/DaQ1oCZs9rbuBYt3CL+h3+lbCu+
	 cSMwmxMAWSJz4UWJvYba2u9NeQM/wr7INqhGHT989DxJoPMP1PT2pSiSEg3aw079ZWBk6
	 1kSPGaGK1WB6uyKHxcFE6IUgsnDkf1jFiulQcQg39FsULBugVA5zUlyBrspcmBLEuZZRH
	 BtyGcJCcUTIVN7TCiP0BFfVQHcIkRRYBXfHUuBCemUnlx4MMwCEXquClHE6Ysm3Cxy12l
	 axvjzPfkiKERUf8ce4i/jN5ftaChHpn53STkiuPmLRsz1TAZyjpdPXqNi/2ivR3/tLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=xm4k3OwD;
	arc=none smtp.remote-ip=95.215.58.219
Received: from mta1.migadu.com (out-219.mta1.migadu.com [95.215.58.219])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01261606A31A
	for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2026 21:05:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 01261606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=xm4k3OwD
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=AxdsP9PcP9L5x4QJdkJLqlCY5nzDb8qTupTvsF18jMU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792443933; v=1; x=1793048733;
 b=xm4k3OwD2YxQHG1py4llS5A2TQOAQ73PcObytIzkcGnXYh+crXUV92URtp8evHsoFOivPbT/
 Eq70lMvU54J7MVVoS4wuJvU1kuFz2VuQyt5+fXCJ5Jtq8hrV6/9PkyT6SRFsg/Uc5UMlSuqKTfT
 nEHZ2SB/PaLh8gIbpzq0ez2k=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 52c2f0f4d942003a;
	Mon, 19 Oct 2026 21:05:22 +0000
X-Mizu-Trace-ID: 52c2f0f4d942003a
X-Migadu-Flow: FLOW_OUT
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Mon, 19 Oct 2026 21:05:20 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <a7791242312c71dfaa96c25aff7be7fb147dea8a@linux.dev>
TLS-Required: No
Subject: Re: [PATCH rtw-next] wifi: rtw88: 8723b: Read the package type from
 efuse
To: "Bitterblue Smith" <rtl8821cerfe2@gmail.com>, "Ping-Ke Shih"
 <pkshih@realtek.com>, linux-wireless@vger.kernel.org
In-Reply-To: <f82ea5e6-d9ef-4978-9658-7e8ce760c7ae@gmail.com>
References: <d22c9202-d019-4ca1-8534-c23244d612d4@gmail.com>
 <425c1552139b4f09a5db42459fa74a08@realtek.com>
 <f82ea5e6-d9ef-4978-9658-7e8ce760c7ae@gmail.com>

Hi Bitterblue,

October 19, 2026 at 10:37 PM, "Bitterblue Smith" <rtl8821cerfe2@gmail.com=
> wrote:

>=20
>=20On 19/10/2026 05:39, Ping-Ke Shih wrote:
>=20
>=20>=20
>=20> Bitterblue Smith <rtl8821cerfe2@gmail.com> wrote:
> >=20=20
>=20>  [...]
> >=20=20
>=20>=20
>=20> >=20
>=20> > +static void rtw8723b_read_package_type(struct rtw_dev *rtwdev)
> > >  +{
> > >  + struct rtw_hal *hal =3D &rtwdev->hal;
> > >  + u8 val_1fb;
> > >  +
> > >  + rtw8723b_efuse_grant(rtwdev, true);
> > >  + rtw_read8_physical_efuse(rtwdev, 0x1fb, &val_1fb);
> > >  + rtw8723b_efuse_grant(rtwdev, false);
> > >=20
>=20>=20=20
>=20>  In rtw_parse_efuse_map(), we can pass 'phy_map' to read_efuse()?
> >  -chip->ops->read_efuse(rtwdev, log_map);
> >  +chip->ops->read_efuse(rtwdev, log_map, phy_map);
> >=20=20
>=20>  As .phy_efuse_size =3D 512 for RTL7823B, I think it will work.
> >=20
>=20Yes, that should work.
>=20
>=20>=20
>=20> >=20
>=20> > +
> > >  + switch (u8_get_bits(val_1fb, GENMASK(2, 0))) {
> > >=20
>=20>=20=20
>=20>  Bit 2~0 seems like PKG_TYPE. Define an enum?
> >=20=20
>=20>=20
>=20> >=20
>=20> > + case 0x4:
> > >  + hal->pkg_type =3D RTW8723B_PACKAGE_TFBGA79;
> > >  + break;
> > >  + case 0x5:
> > >  + hal->pkg_type =3D RTW8723B_PACKAGE_TFBGA90;
> > >  + break;
> > >  + case 0x6:
> > >  + hal->pkg_type =3D RTW8723B_PACKAGE_QFN68;
> > >  + break;
> > >  + case 0x7:
> > >  + hal->pkg_type =3D RTW8723B_PACKAGE_TFBGA80;
> > >  + break;
> > >  + default:
> > >  + hal->pkg_type =3D RTW8723B_PACKAGE_DEFAULT;
> > >  + break;
> > >  + }
> > >  +
> > >  + if (rtw_hci_type(rtwdev) =3D=3D RTW_HCI_TYPE_SDIO &&
> > >  + u8_get_bits(val_1fb, GENMASK(5, 4)) =3D=3D 0x2)
> > >=20
>=20>=20=20
>=20>  Can you define enums for bit 5-4 and value 0x2?
> >  I'm not sure if vendor driver has some comments pointing out this or=
 not.
> >=20
>=20I guess bits 5-4 identify the chip variant:
>=20
>=20 /* RTL8703AS: 0x1FB[5:4] 2b'10 */
>  /* RTL8723BS: 0x1FB[5:4] 2b'11 */
>  if ((efuseContent & 0x30) =3D=3D 0x20) {
>  pAdapter->registrypriv.bw_mode &=3D 0xF0;
>  RTW_INFO("This is the case of 8703AS\n");
>  }
>=20
>=20RTL8703AS appears to be a (cheaper?) version of RTL8723BS. Ten years =
ago
> Hans de Goede was saying:
>=20
>=20 The rtl8703as in reality is a rtl8723bs in a different package.
>  (it has the same sdio-id).
>=20
>=20 In android the rtl8703as uses the rtl8723bs-vq0 driver instead of th=
e
>  regular rtl8732bs driver. Looking at a diff between the 2 the only
>  difference is that the vq0 driver forces the antenna-path to
>  ODM_RF_PATH_B.
>=20
>=20 It seems that we can identify the rtl8703as by its package, as it co=
mes
>  in a QNF68 package, where as the rtl8723bs comes in a TFBGA79 package,
>  so we can simply support both in the same driver.
>=20
>=20https://github.com/hadess/rtl8723bs/pull/93/changes/ebec0ae8ccedc05a9=
45478926d52c99277f500ee

So 8703AS should work just fine with rtw8723b. The one thing I'm not
sure about is antenna path. The vq0 driver hardcodes path B, but the
normal driver reads it from efuse, same as rtw88. If some 8703AS boards
have it wrong in efuse we might need a quirk. Have you come across such?

Best regards,
Luka Gejak
