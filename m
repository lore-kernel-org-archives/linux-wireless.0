Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089F23D522C;
	Tue, 25 Aug 2026 07:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787643665; cv=none; b=QFb8nOTIzVgQqdwzpxeWJMIuslxGM8HYLKFJzmhTzliebCUngQA7Dt70QutJavENlAd3TyKZ4M/goTrVJlfgobUu1t6WG2LTVNigAeMxQphlri20rve4dHg3pLAYiw/+5fjnlWwcGKymEbHFUHlrI5Lx+Pmri1083PKI8jP9X7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787643665; c=relaxed/simple;
	bh=HmvKbHJDVWQv8tWpQxdV070We84jmxUnpYnkXIF7+ig=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PceCxmCsSbdzbuXtsOTwq+1QR5SaTNg263RMa0114GbzB5lxkD2tVXq1WliweY4jX+5QOTZZbKOvAAcCVFgCHTaW2h5GHqQaX9RsnhRrCivjQuopW9gW0nm7BUeMQGq9Yfpuco+0q+L1bwSB7Lky3GaKJpHkv16wzuaZeDc/M9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=o+PKPHim; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="o+PKPHim"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67P7ewIgB3610813, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1787643658; bh=GAX5c1DK5expN7bg/5Sz6kR3Q3xrEGSKsLdHcGnUpvY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=o+PKPHimQmjnhKZrCTC37qazDJWgtwOuhPnHZx8O/dqm+Y6R6NT9dGSxZFQ198x5L
	 hSqwtdMUZVihM4K0n7ndke9f8FdW3WUUHdeYQPI5X+Vnm9/VUoGLdSMOpw9OX8/u2P
	 ZP6mDR5uJUDfojAC3upk8RujSmAPEJn4ebFFoUQ7rvy0Xgr52t3UTQrStGO9KJKZMm
	 8xXQtdtpGlSQCiPXVxadQ8sZf9+upD13UK9ETNRGs3DphUaKtyTYeGOPfH+NloYk5d
	 Y/Z5rlK2TRpEWiGxHRJOVZGY8klSsXrfmHMQCCWHKb/h0EhZEU6Ucqbd7SqKPMjC9q
	 yZXJsNMaVOqGw==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67P7ewIgB3610813
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 25 Aug 2026 15:40:58 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 25 Aug 2026 15:40:58 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 25 Aug 2026 15:40:58 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Tue, 25 Aug 2026 15:40:58 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Arsenii Pashchenko <ulijg308@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH rtw-next v6 2/3] wifi: rtw88: rtw8822c: Convert DAC IQ
 calibration path to signed math
Thread-Topic: [PATCH rtw-next v6 2/3] wifi: rtw88: rtw8822c: Convert DAC IQ
 calibration path to signed math
Thread-Index: AQHdLJn8dVeNcXFtLUaKJxZvalYK+LauabDg
Date: Tue, 25 Aug 2026 07:40:58 +0000
Message-ID: <6428e718fefd4bbeaa3506b898375299@realtek.com>
References: <cover.1786784750.git.ulijg308@gmail.com>
 <cf7aaa2f7ff162f3d3a729a5bec9c572277b805c.1786784750.git.ulijg308@gmail.com>
In-Reply-To: <cf7aaa2f7ff162f3d3a729a5bec9c572277b805c.1786784750.git.ulijg308@gmail.com>
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
> Use sign_extend32() combined with FIELD_GET() to properly interpret
> the 10-bit hardware values as signed integers.=20

Forgot to update commit message as FIELD_GET_SIGNED()...

> This allows flattening
> the complex nested unsigned boundary conditions in
> rtw8822c_dac_iq_check() into a simple amplitude boundary check. Ensure
> rtw8822c_dac_iq_offset() properly maps the signed average back to a
> 10-bit unsigned format expected by the hardware registers.
>=20
> Signed-off-by: Arsenii Pashchenko <ulijg308@gmail.com>
> ---

[...]

> @@ -207,30 +172,16 @@ static void rtw8822c_dac_iq_sort(struct rtw_dev *rt=
wdev, u32 *iv, u32 *qv)
>         }
>  }
>=20
> -static void rtw8822c_dac_iq_offset(struct rtw_dev *rtwdev, u32 *vec, u32=
 *val)
> +static u32 rtw8822c_dac_iq_offset(struct rtw_dev *rtwdev, s32 *vec)
>  {
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

No declaration in the middle.

>=20
> -       *val =3D t;
> +       return avg >=3D 0 ? (u32)avg : (u32)(0x400 + avg);

Maybe, we can give an example to understand easier, like

  avg =3D -1, return 0x3FF. (signed 10 bits value)


>  }
>=20
>  static u32 rtw8822c_get_path_write_addr(u8 path)
> @@ -271,20 +222,18 @@ static u32 rtw8822c_get_path_read_addr(u8 path)
>         return base_addr;
>  }
>=20
> -static bool rtw8822c_dac_iq_check(struct rtw_dev *rtwdev, u32 value)
> +static bool rtw8822c_dac_iq_check(struct rtw_dev *rtwdev, s32 value)
>  {
> -       bool ret =3D true;
>=20
> -       if ((value >=3D 0x200 && (0x400 - value) > 0x64) ||
> -           (value < 0x200 && value > 0x64)) {
> -               ret =3D false;
> +       if (value > 100 || value < -100) {
>                 rtw_dbg(rtwdev, RTW_DBG_RFK, "[DACK] Error overflow\n");
> +               return false;
>         }
>=20
> -       return ret;
> +       return true;
>  }
>=20
> -static void rtw8822c_dac_cal_iq_sample(struct rtw_dev *rtwdev, u32 *iv, =
u32 *qv)
> +static void rtw8822c_dac_cal_iq_sample(struct rtw_dev *rtwdev, s32 *iv, =
s32 *qv)
>  {
>         u32 temp;
>         int i =3D 0, cnt =3D 0;
> @@ -292,8 +241,8 @@ static void rtw8822c_dac_cal_iq_sample(struct rtw_dev=
 *rtwdev, u32 *iv, u32 *qv)
>         while (i < DACK_SN_8822C && cnt < 10000) {
>                 cnt++;
>                 temp =3D rtw_read32(rtwdev, 0x2dbc);
> -               iv[i] =3D FIELD_GET(RTW8822C_DAC_IV_MASK, temp);
> -               qv[i] =3D FIELD_GET(RTW8822C_DAC_QV_MASK, temp);
> +               iv[i] =3D FIELD_GET_SIGNED(RTW8822C_DAC_IV_MASK, temp);
> +               qv[i] =3D FIELD_GET_SIGNED(RTW8822C_DAC_QV_MASK, temp);
>=20
>                 if (rtw8822c_dac_iq_check(rtwdev, iv[i]) &&
>                     rtw8822c_dac_iq_check(rtwdev, qv[i]))
> @@ -302,67 +251,63 @@ static void rtw8822c_dac_cal_iq_sample(struct rtw_d=
ev *rtwdev, u32 *iv, u32 *qv)
>  }
>=20
>  static void rtw8822c_dac_cal_iq_search(struct rtw_dev *rtwdev,
> -                                      u32 *iv, u32 *qv,
> +                                      s32 *iv, s32 *qv,
>                                        u32 *i_value, u32 *q_value)
>  {
> -       u32 i_max =3D 0, q_max =3D 0, i_min =3D 0, q_min =3D 0;
> +       s32 i_max =3D 0, q_max =3D 0, i_min =3D 0, q_min =3D 0;
>         u32 i_delta, q_delta;
>         u32 temp;
> -       int i, cnt =3D 0;
> +       u32 i, cnt =3D 0;

Why did you need changing 'int' to 'u32'?

>=20
>         do {
>                 i_min =3D iv[0];
>                 i_max =3D iv[0];
>                 q_min =3D qv[0];
>                 q_max =3D qv[0];
> -               for (i =3D 0; i < DACK_SN_8822C; i++) {
> -                       rtw8822c_rf_minmax_cmp(rtwdev, iv[i], &i_min, &i_=
max);
> -                       rtw8822c_rf_minmax_cmp(rtwdev, qv[i], &q_min, &q_=
max);
> +               for (i =3D 1; i < DACK_SN_8822C; i++) {
> +                       if (iv[i] < i_min)
> +                               i_min =3D iv[i];
> +                       if (iv[i] > i_max)
> +                               i_max =3D iv[i];
> +                       if (qv[i] < q_min)
> +                               q_min =3D qv[i];
> +                       if (qv[i] > q_max)
> +                               q_max =3D qv[i];
>                 }
>=20
> -               if (i_max < 0x200 && i_min < 0x200)
> -                       i_delta =3D i_max - i_min;
> -               else if (i_max >=3D 0x200 && i_min >=3D 0x200)
> -                       i_delta =3D i_max - i_min;
> -               else
> -                       i_delta =3D i_max + (0x400 - i_min);
> +               i_delta =3D i_max - i_min;
> +               q_delta =3D q_max - q_min;
>=20
> -               if (q_max < 0x200 && q_min < 0x200)
> -                       q_delta =3D q_max - q_min;
> -               else if (q_max >=3D 0x200 && q_min >=3D 0x200)
> -                       q_delta =3D q_max - q_min;
> -               else
> -                       q_delta =3D q_max + (0x400 - q_min);
>=20
>                 rtw_dbg(rtwdev, RTW_DBG_RFK,
> -                       "[DACK] i: min=3D0x%08x, max=3D0x%08x, delta=3D0x=
%08x\n",
> +                       "[DACK] i: min=3D%d, max=3D%d, delta=3D%d\n",
>                         i_min, i_max, i_delta);
>                 rtw_dbg(rtwdev, RTW_DBG_RFK,
> -                       "[DACK] q: min=3D0x%08x, max=3D0x%08x, delta=3D0x=
%08x\n",
> +                       "[DACK] q: min=3D%d, max=3D%d, delta=3D%d",
>                         q_min, q_max, q_delta);
>=20
>                 rtw8822c_dac_iq_sort(rtwdev, iv, qv);
>=20
>                 if (i_delta > 5 || q_delta > 5) {
>                         temp =3D rtw_read32(rtwdev, 0x2dbc);
> -                       iv[0] =3D FIELD_GET(RTW8822C_DAC_IV_MASK, temp);
> -                       qv[0] =3D FIELD_GET(RTW8822C_DAC_QV_MASK, temp);
> +                       iv[0] =3D FIELD_GET_SIGNED(RTW8822C_DAC_IV_MASK, =
temp);
> +                       qv[0] =3D FIELD_GET_SIGNED(RTW8822C_DAC_QV_MASK, =
temp);
>                         temp =3D rtw_read32(rtwdev, 0x2dbc);
> -                       iv[DACK_SN_8822C - 1] =3D FIELD_GET(RTW8822C_DAC_=
IV_MASK, temp);
> -                       qv[DACK_SN_8822C - 1] =3D FIELD_GET(RTW8822C_DAC_=
QV_MASK, temp);
> +                       iv[DACK_SN_8822C - 1] =3D FIELD_GET_SIGNED(RTW882=
2C_DAC_IV_MASK, temp);
> +                       qv[DACK_SN_8822C - 1] =3D FIELD_GET_SIGNED(RTW882=
2C_DAC_QV_MASK, temp);
>                 } else {
>                         break;
>                 }
>         } while (cnt++ < 100);
>=20
> -       rtw8822c_dac_iq_offset(rtwdev, iv, i_value);
> -       rtw8822c_dac_iq_offset(rtwdev, qv, q_value);
> +       *i_value =3D rtw8822c_dac_iq_offset(rtwdev, iv);
> +       *q_value =3D rtw8822c_dac_iq_offset(rtwdev, qv);
>  }
>=20
>  static void rtw8822c_dac_cal_rf_mode(struct rtw_dev *rtwdev,
>                                      u32 *i_value, u32 *q_value)
>  {
> -       u32 iv[DACK_SN_8822C], qv[DACK_SN_8822C];
> +       s32 iv[DACK_SN_8822C], qv[DACK_SN_8822C];
>         u32 rf_a, rf_b;
>=20
>         rf_a =3D rtw_read_rf(rtwdev, RF_PATH_A, 0x0, RFREG_MASK);
> --
> 2.55.0

