Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9335C3AA1BF;
	Fri, 28 Aug 2026 08:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787905808; cv=none; b=nrw4o+RjTlJUS8gvcaKHZPg6Mf5e9dxV3t+hZOuqFTOKlmehJZBoKG/zMe1nxijakCpMT/EHrHViqDNxAT1B+6NQFQSpq3oxlIMzmzuhCkSWLJRIrS3yDWi28xGgdhEdjNYi/N7RBKNRcZwjjuxWNX99LwGLYTLtXbWvW40Medg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787905808; c=relaxed/simple;
	bh=3/yWqAXxEde08/GoJAuePB1HdSb5B2lQjcA4TeN41oE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=T3/0OwadlOSZDL3eO2xCGJxGAfI9xrIh6IZVvuvMEW+6PhGR/qpFuH69BPHJqRgMarmMtalsF5wEukg5ilGltdVjp1y10VAADVeeC/pTnXnc6VozXxK/+jbz64xJaYosFM04o5hoJGIs5dqIhceKWDkNpv18X3vaP8yGyM5NfUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=h+goBKdd; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="h+goBKdd"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67S8U0Wu82281999, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1787905801; bh=hWxYNoilRcMGhgNBlmtDzpp3ri7Rh4ODBP1ghMUje1Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=h+goBKddn1QHdImlhYjBXt93FzU//9lkXAptzOwi/aYcZ54+GiTBjMgNu/klsxCYS
	 rl0TRy25AlvVwkamX97gvDs8G5PBLwMqBUtln/wbhSfejZKP2b6kh+Us7vn8/G0j1o
	 n2XF1ljS+sAEW6Id1gk7CGlwT53ExuFZWWnLNEm23h1uhIexO9qZO6FZ4R/oNV0KJe
	 Jb+u2rVkqAdVhS5atEnGHyGDUQ1ZUF+bFhtte8UWogkLEqbITZhEbqXBggu1VTIdgz
	 OBCOEhCvBfCVYg9bob6GX7zS5VZwT11p3G4YcMYaEXajTDOIw8rUKw6yzZpp/2zKnw
	 B0mofs/J4ecYg==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67S8U0Wu82281999
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 28 Aug 2026 16:30:01 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 28 Aug 2026 16:29:59 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Fri, 28 Aug 2026 16:29:59 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Arsenii Pashchenko <ulijg308@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH rtw-next v7 2/3] wifi: rtw88: rtw8822c: Convert DAC IQ
 calibration path to signed math
Thread-Topic: [PATCH rtw-next v7 2/3] wifi: rtw88: rtw8822c: Convert DAC IQ
 calibration path to signed math
Thread-Index: AQHdNq/AQRXlT+oz0UyK6Oom3YOr/bazIEsg
Date: Fri, 28 Aug 2026 08:29:58 +0000
Message-ID: <d662dcab866042c08f050cfe035c7c70@realtek.com>
References: <cover.1787895379.git.ulijg308@gmail.com>
 <86bde9882c56a1245a4c903b607e23d551dde1b9.1787895379.git.ulijg308@gmail.com>
In-Reply-To: <86bde9882c56a1245a4c903b607e23d551dde1b9.1787895379.git.ulijg308@gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Arsenii Pashchenko <ulijg308@gmail.com> wrote:
> Convert the temporary stack arrays 'iv' and 'qv' from u32 to s32.
> Update all internal function signatures to accept s32 pointers and
> handle signed values natively.
>=20
> Use sign_extend32() combined with FIELD_GET_SIGNED() to properly interpre=
t
> the 10-bit hardware values as signed integers. This allows flattening
> the complex nested unsigned boundary conditions in
> rtw8822c_dac_iq_check() into a simple amplitude boundary check. Ensure
> rtw8822c_dac_iq_offset() properly maps the signed average back to a
> 10-bit unsigned format expected by the hardware registers via GENMASK().
>=20
> Signed-off-by: Arsenii Pashchenko <ulijg308@gmail.com>

[...]

> -static void rtw8822c_dac_iq_offset(struct rtw_dev *rtwdev, u32 *vec, u32=
 *val)
> +static u32 rtw8822c_dac_iq_offset(struct rtw_dev *rtwdev, s32 *vec)
>  {
> -       u32 p, m, t, i;
> +       s32 sum =3D 0;
> +       s32 avg;
> +       u32 i;
>=20
> -       m =3D 0;
> -       p =3D 0;
> -       for (i =3D 10; i < DACK_SN_8822C - 10; i++) {
> -               if (vec[i] > 0x200)
> -                       m =3D (0x400 - vec[i]) + m;
> -               else
> -                       p =3D vec[i] + p;
> -       }
> +       for (i =3D 10; i < DACK_SN_8822C - 10; i++)
> +               sum +=3D vec[i];
>=20
> -       if (p > m) {
> -               t =3D p - m;
> -               t =3D t / (DACK_SN_8822C - 20);
> -       } else {
> -               t =3D m - p;
> -               t =3D t / (DACK_SN_8822C - 20);
> -               if (t !=3D 0x0)
> -                       t =3D 0x400 - t;
> -       }
> +       avg =3D sum / (DACK_SN_8822C - 20);
>=20
> -       *val =3D t;
> +       /* Map the signed average back to a 10-bit hardware format.
> +        * Example: avg =3D -1, returns 0x3FF (signed 10-bit value)
> +        */

The first line of comment block should be empty, like

/*
 * comment start here.
 * second.
 */

> +       return avg & GENMASK(9, 0);
>  }
>=20
>  static u32 rtw8822c_get_path_write_addr(u8 path)


