Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB134252D1;
	Fri, 14 Aug 2026 08:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786695049; cv=none; b=EJ8/01FLP6Nb8nG3IWkcNGwpEnXcRQpr6nyQ8z674KgRVoNfEApMp7JB8pBd5HAp23AbAvS7o71UUNrdqjZeHoOrrC8HVR6HV2pEvqbdCZTHjhx0Tf//tOilXK8Z1mxEpwyJRcMnQQeFV+6LU8L8+efB3tdChcD+PZRPeLYlGro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786695049; c=relaxed/simple;
	bh=3UGvGaZC/heE1E9C0jRRxrGLSBi8ouG/CoDC8l216JQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cp1nmNBOulFkuLiZSUjUTkegnd0mA5582+268LC45k4CR/Z9EyGxbd51V0i1B2S5FaFEGc3FfSx9RFMZ42iNfI4wGJ3Z95Qw1/yffkdQ+qmIbs09FC2596vuoKbiOLd14qTTOsRGzCldR6frRkOIea6o0vRJXDnNxDU9fRSlLAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=oBtsj25E; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="oBtsj25E"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67E8AbX321081109, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1786695038; bh=vgz3yBsy2FvtYOCw4H9uJ5mxPDH46x6lBmLm8ELN/Ak=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=oBtsj25E3/jnpwAzQAC4OpI9NZfu5MUneIKyxWpJrNFt6OgP3eymiVIe3Qd8CtDCv
	 D8X7383vULmASdfRbRhyictZ8nG185oZB01fpCncWz0Wh4q5cbJ0lommJ7w3CQzNn2
	 J8h0WaSouc7r+kGpkx3dL5+Daq1xGp6CApE/lkfN3/ppSoXHdM1pk6npxLlEubzCP+
	 J6l+FQZuwcbh4x9jasuqVzL+o7Lht+Ndy1JqWSATYUYSgGTBTpDopFZk5bdX0AuGD/
	 SgkcaOMg7yLxKYd60HiP9XK+xWX2jYCCuGMQNAcqYwaeaWNvmtSNXIkc+27k5sXqhQ
	 CRbV+6sX2Gmcw==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67E8AbX321081109
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 14 Aug 2026 16:10:38 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 14 Aug 2026 16:10:33 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Fri, 14 Aug 2026 16:10:33 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Arsenii Pashchenko <ulijg308@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 4/4] wifi: rtw88: rtw8822c: simplify amplitude search and
 offset via s32
Thread-Topic: [PATCH 4/4] wifi: rtw88: rtw8822c: simplify amplitude search and
 offset via s32
Thread-Index: AQHdKmlVOxsiWjpZdky/3c9i6asNtLadMkJg
Date: Fri, 14 Aug 2026 08:10:33 +0000
Message-ID: <e73b9600122d4e708601914acf4238c0@realtek.com>
References: <cover.1786545572.git.ulijg308@gmail.com>
 <0bb6e2fb78d0b2def623210938204a0efbbe2034.1786545572.git.ulijg308@gmail.com>
In-Reply-To: <0bb6e2fb78d0b2def623210938204a0efbbe2034.1786545572.git.ulijg308@gmail.com>
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
> Complete the signed data transition by removing the complex
> rtw8822c_rf_minmax_cmp() helper. On a true linear s32 scale, finding
> the delta amplitude simplifies to a direct difference (max - min)
> without any nested circular wrap-around conditions.
>=20
> Refactor rtw8822c_dac_iq_offset() to directly calculate the trimmed
> arithmetic mean, casting back to the hardware register's offset
> orientation only at the final assignment using a ternary operator.
>=20
> Signed-off-by: Arsenii Pashchenko <ulijg308@gmail.com>
> ---
>  drivers/net/wireless/realtek/rtw88/rtw8822c.c | 103 +++++-------------
>  1 file changed, 25 insertions(+), 78 deletions(-)
>=20
> diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
> b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
> index 642ac2e2b..6fcdfc64c 100644
> --- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
> +++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
> @@ -155,38 +155,6 @@ static void rtw8822c_dac_restore_reg(struct rtw_dev =
*rtwdev,
>         }
>  }
>=20
> -static void rtw8822c_rf_minmax_cmp(struct rtw_dev *rtwdev, s32 value_s32=
,
> -                                  s32 *min_s32, s32 *max_s32)
> -{
> -       u32 value =3D (u32)value_s32;
> -       u32 *min =3D (u32 *)min_s32;
> -       u32 *max =3D (u32 *)max_s32;
> -       if (value >=3D 0x200) {
> -               if (*min >=3D 0x200) {
> -                       if (*min > value)
> -                               *min =3D value;
> -               } else {
> -                       *min =3D value;
> -               }
> -               if (*max >=3D 0x200) {
> -                       if (*max < value)
> -                               *max =3D value;
> -               }
> -       } else {
> -               if (*min < 0x200) {
> -                       if (*min > value)
> -                               *min =3D value;
> -               }
> -
> -               if (*max  >=3D 0x200) {
> -                       *max =3D value;
> -               } else {
> -                       if (*max < value)
> -                               *max =3D value;
> -               }
> -       }
> -}
> -
>  static int rtw8822c_dac_iq_cmp_s32(const void *a, const void *b)
>  {
>         s32 va =3D *(const s32 *)a;
> @@ -201,31 +169,16 @@ static void rtw8822c_dac_iq_sort(struct rtw_dev *rt=
wdev, s32 *iv, s32 *qv)
>         sort(qv, DACK_SN_8822C, sizeof(s32), rtw8822c_dac_iq_cmp_s32, NUL=
L);
>  }
>=20
> -static void rtw8822c_dac_iq_offset(struct rtw_dev *rtwdev, s32 *vec_s32,=
 u32 *val)
> +static s32 rtw8822c_dac_iq_offset(struct rtw_dev *rtwdev, s32 *vec)
>  {
> -       u32 *vec =3D (u32 *)vec_s32;
> -       u32 p, m, t, i;
> +       s32 sum =3D 0;
>=20
> -       m =3D 0;
> -       p =3D 0;
> -       for (i =3D 10; i < DACK_SN_8822C - 10; i++) {
> -               if (vec[i] > 0x200)
> -                       m =3D (0x400 - vec[i]) + m;
> -               else
> -                       p =3D vec[i] + p;
> -       }
> +       for (u32 i =3D 10; i < DACK_SN_8822C - 10; i++)
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
> +       s32 avg =3D sum / (DACK_SN_8822C - 20);

No declaration in the middle.=20

>=20
> -       *val =3D t;
> +       return avg >=3D 0 ? avg : 0x400 + avg;

Return type is 's32', but here doesn't do sign_extension()?

>  }
>=20
>  static u32 rtw8822c_get_path_write_addr(u8 path)


