Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E9A403B00;
	Fri, 14 Aug 2026 07:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786693790; cv=none; b=cHD/9OAyMeAlHr7deBMwtkFwG2gPHElk3aM2qtXEeRHprT0GH0U0xICHraBv4MmYfS+GPzF5CEk9MGFWiKE7uxs9iYJhgtNSbzn9BavFYVu3cfgIBvAj0vsRzFwyVdP2fat0Od6g5+AuoLM2awypi3Cp5hF837lbeC0K+WTWp2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786693790; c=relaxed/simple;
	bh=klqhahOqBQxvi3DBedDhjfv2XrG9PjO4XiT7IxiSjzw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=a3KnmExjg9B5S0BV/4+MQksupZUkIfm7dpdj67JtMffIEmHklNqVyGkKbAo+KdmLkv7T9VVZJR/RqlBQxsU4pqdYMNW5KpX6OLJsyDiycGl+4yXIE5IvpS3GZmhodSSSYB35GsSd5oopSoDeNcpiqdd0DBn7126xXsu74TREgSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=L0dR+/JN; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="L0dR+/JN"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67E7nghgF1072674, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1786693782; bh=dfrFegEasyq9FdWAyIzt4hiWfvnwwFpzwyLLK8ctAcg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=L0dR+/JNvFzyaPg6AxXl347x980I0aA6rgtT4A3pNCyrl311gt2iw4rcxoF0qCxf2
	 8sXN+UzRLZy+Amua27vz6mmThu02XvKNfjMrSI1kytquCxWT6rd71UQ+xjjtR/+rCv
	 2iBeVrXttEBwDqSY4E4zTcF1FKhGxKm+Tcjw1ppa79MFofrdwrgXo6KJJ4jnWEuokN
	 qE4a2D3KMFXlGyvbMNw3kJ7Mc5hPd8yr4TeeicBcRatOxq+HxYAjkVaZKmKxBdhhjt
	 TR3MVzFAyGsS8G4VMldjraTY5llBbPKQpLCV8Df0aNx6iPlZSeQs2CWfkLpMScLhw/
	 lrl0WH3NqS8Ug==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67E7nghgF1072674
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 14 Aug 2026 15:49:42 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 14 Aug 2026 15:49:42 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Fri, 14 Aug 2026 15:49:42 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Arsenii Pashchenko <ulijg308@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/4] wifi: rtw88: rtw8822c: use sign_extend32 for DAC IQ
 validation
Thread-Topic: [PATCH 2/4] wifi: rtw88: rtw8822c: use sign_extend32 for DAC IQ
 validation
Thread-Index: AQHdKmlUAXzXV8VvpUCXWdcBWAD1ILadLBAg
Date: Fri, 14 Aug 2026 07:49:41 +0000
Message-ID: <9be26fe7c6814b17baf2bb08fbfff6eb@realtek.com>
References: <cover.1786545572.git.ulijg308@gmail.com>
 <a016d09710dce6f27a60e8fb3c16cdc28ef24a08.1786545572.git.ulijg308@gmail.com>
In-Reply-To: <a016d09710dce6f27a60e8fb3c16cdc28ef24a08.1786545572.git.ulijg308@gmail.com>
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
> Leverage the kernel's native sign_extend32() macro to properly
> interpret the 10-bit raw values from hardware registers as signed
> 32-bit (s10) integers covering the [-512, 511] range.

New API FIELD_GET_SIGNED() is introduced. I think this is suitable
to this case.

>=20
> This allows us to completely rewrite rtw8822c_dac_iq_check() to use
> a simple, clean amplitude boundary check instead of complex, nested
> unsigned boundary conditions. Drop the temporary u32 casts inside
> the check and sampling routines.
>=20
> Signed-off-by: Arsenii Pashchenko <ulijg308@gmail.com>
> ---
>  drivers/net/wireless/realtek/rtw88/rtw8822c.c | 24 +++++++++----------
>  1 file changed, 11 insertions(+), 13 deletions(-)
>=20
> diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
> b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
> index 896e3e7b9..d06986d09 100644
> --- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
> +++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
> @@ -3,6 +3,7 @@
>   */
>=20
>  #include <linux/module.h>
> +#include <linux/bitops.h>

I guess you need this because of sign_extend32(). Have you tried to build
without this? I feel it is existing in include chain already.

>  #include "main.h"
>  #include "coex.h"
>  #include "fw.h"
> @@ -277,18 +278,15 @@ static u32 rtw8822c_get_path_read_addr(u8 path)
>         return base_addr;
>  }
>=20
> -static bool rtw8822c_dac_iq_check(struct rtw_dev *rtwdev, s32 value_s32)
> +static bool rtw8822c_dac_iq_check(struct rtw_dev *rtwdev, s32 value)
>  {
> -       u32 value =3D (u32)value_s32;
> -       bool ret =3D true;
>=20
> -       if ((value >=3D 0x200 && (0x400 - value) > 0x64) ||
> -           (value < 0x200 && value > 0x64)) {
> -               ret =3D false;
> +       if (value > 100 || value < -100) {

The change is identical?

>                 rtw_dbg(rtwdev, RTW_DBG_RFK, "[DACK] Error overflow\n");
> +               return false;
>         }
>=20
> -       return ret;
> +       return true;
>  }
>=20
>  static void rtw8822c_dac_cal_iq_sample(struct rtw_dev *rtwdev, s32 *iv, =
s32 *qv)
> @@ -299,8 +297,8 @@ static void rtw8822c_dac_cal_iq_sample(struct rtw_dev=
 *rtwdev, s32 *iv, s32 *qv)
>         while (i < DACK_SN_8822C && cnt < 10000) {
>                 cnt++;
>                 temp =3D rtw_read32_mask(rtwdev, 0x2dbc, 0x3fffff);
> -               iv[i] =3D (s32)((temp & 0x3ff000) >> 12);
> -               qv[i] =3D (s32)(temp & 0x3ff);
> +               iv[i] =3D sign_extend32((temp & 0x3ff000) >> 12, 9);
> +               qv[i] =3D sign_extend32(temp & 0x3ff, 9);

FIELD_GET_SIGNED()

>=20
>                 if (rtw8822c_dac_iq_check(rtwdev, iv[i]) &&
>                     rtw8822c_dac_iq_check(rtwdev, qv[i]))
> @@ -352,11 +350,11 @@ static void rtw8822c_dac_cal_iq_search(struct rtw_d=
ev *rtwdev,
>=20
>                 if (i_delta > 5 || q_delta > 5) {
>                         temp =3D rtw_read32_mask(rtwdev, 0x2dbc, 0x3fffff=
);
> -                       iv[0] =3D (s32)((temp & 0x3ff000) >> 12);
> -                       qv[0] =3D (s32)(temp & 0x3ff);
> +                       iv[0] =3D sign_extend32((temp & 0x3ff000) >> 12, =
9);
> +                       qv[0] =3D sign_extend32(temp & 0x3ff, 9);

FIELD_GET_SIGNED()

>                         temp =3D rtw_read32_mask(rtwdev, 0x2dbc, 0x3fffff=
);
> -                       iv[DACK_SN_8822C - 1] =3D (s32)((temp & 0x3ff000)=
 >> 12);
> -                       qv[DACK_SN_8822C - 1] =3D (s32)(temp & 0x3ff);
> +                       iv[DACK_SN_8822C - 1] =3D sign_extend32((temp & 0=
x3ff000) >> 12, 9);
> +                       qv[DACK_SN_8822C - 1] =3D sign_extend32(temp & 0x=
3ff, 9);

FIELD_GET_SIGNED()

Please use real hardware to verify the values.

>                 } else {
>                         break;
>                 }
> --
> 2.55.0

