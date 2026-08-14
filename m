Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B36141E6B9;
	Fri, 14 Aug 2026 07:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786693354; cv=none; b=AMHtKB8iWW7u+znqkr20Sibk7Ju5opAQ/OClztGQH5GLLNuFGl5mDHpPo+PzGwhRP0LbTUDOHceTZaSjI+lHMksMlUEwer1gwyyWuEk18f2ybcR34uyLLWZX88mmjFToFlkeh27RSQ11YuFL7YPFDAs203UULlzC7zBtv8Hv8gU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786693354; c=relaxed/simple;
	bh=3eCV8FrKDGTKtf8+iFXsrNYY3dF6Bhx1J+LuybP8slY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SfSnagq2s3pWvZ6KBEg0mrwPBjq5UHr2c/qZ+O+Wt+gp19XsZhtLqHWD0JUPVOcoMaym3wNb33eLtpUzhrrxSED7NV6aAO0P+QgW5U5gZz8mZnJMBIPgGvq1NvN3sN6Abj1sez/n1GrVH71nkENxvBtxfi1I4x0yhwE06TsIrao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=Euf32JLX; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="Euf32JLX"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67E7gL9H11069418, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1786693341; bh=2XswULKOY5y+g2oNf80HpLhvKky+eA1EJSu/WTmGD2U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=Euf32JLXPxnoE+dKHuIOOp0YrWyKPYHOCfu8cyW2e3LrPnFLahzuvOGicszAJ/wG4
	 lsO/BkEKv/ahqieetna0h2jOA/RkEgPbA6+wtDm/zj+L0D0vFrWbbg1omRCvDTXnp2
	 0FjScVxnWZ//cC8C9FXVDOTdHOw6cNQ9TBfcICCcCTDx097Az3G4VGXEoKPC0oBq/n
	 aivourWK57QbZLFEUz/G4MJw+zmifc4HN0lcTGXMihOWZwOfteZyqqZZAtbvU0r4qn
	 2dAzlCEBIFVNyfs9jaPKzsDw4qE220uAO5ByQ6YfdV4JMW4vkn88x7wK99jDKOd2Es
	 /xetRLUUFfN4g==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67E7gL9H11069418
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 14 Aug 2026 15:42:21 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 14 Aug 2026 15:42:21 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 14 Aug 2026 15:42:21 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Fri, 14 Aug 2026 15:42:21 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Arsenii Pashchenko <ulijg308@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/4] wifi: rtw88: rtw8822c: convert DAC IQ buffers and
 signatures to s32
Thread-Topic: [PATCH 1/4] wifi: rtw88: rtw8822c: convert DAC IQ buffers and
 signatures to s32
Thread-Index: AQHdKmlURevl7O5D/UerTagkxaMdMbadKh8Q
Date: Fri, 14 Aug 2026 07:42:20 +0000
Message-ID: <9242742673fc4ac09e8a9b0d2a4c5eb7@realtek.com>
References: <cover.1786545572.git.ulijg308@gmail.com>
 <12e170032b884c8693a08c780fb8aa677aa4af4c.1786545572.git.ulijg308@gmail.com>
In-Reply-To: <12e170032b884c8693a08c780fb8aa677aa4af4c.1786545572.git.ulijg308@gmail.com>
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
> Prepare the DAC IQ calibration path for signed math by converting the
> temporary stack arrays 'iv' and 'qv' from u32 to s32. Update all
> internal function signatures to accept s32 pointers.
>=20
> To guarantee bisectability, wrap the existing unsigned logic in
> temporary casts to u32. This maintains identical mathematical behavior
> and avoids any compiler sign-compare warnings.
>=20
> Signed-off-by: Arsenii Pashchenko <ulijg308@gmail.com>
> ---
>  drivers/net/wireless/realtek/rtw88/rtw8822c.c | 49 +++++++++++--------
>  1 file changed, 28 insertions(+), 21 deletions(-)
>=20
> diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
> b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
> index 244c80264..896e3e7b9 100644
> --- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
> +++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
> @@ -153,9 +153,12 @@ static void rtw8822c_dac_restore_reg(struct rtw_dev =
*rtwdev,
>         }
>  }
>=20
> -static void rtw8822c_rf_minmax_cmp(struct rtw_dev *rtwdev, u32 value,
> -                                  u32 *min, u32 *max)
> +static void rtw8822c_rf_minmax_cmp(struct rtw_dev *rtwdev, s32 value_s32=
,
> +                                  s32 *min_s32, s32 *max_s32)
>  {
> +       u32 value =3D (u32)value_s32;
> +       u32 *min =3D (u32 *)min_s32;
> +       u32 *max =3D (u32 *)max_s32;

blank line

Also, it is possible to avoid all casting from s32 to u32, even just a
transition patch? I guess compiler can silently ignore this, and it'd
be much easier to review. Otherwise, I need to check if you remove
these casting clearly.=20

>         if (value >=3D 0x200) {
>                 if (*min >=3D 0x200) {
>                         if (*min > value)
> @@ -182,8 +185,10 @@ static void rtw8822c_rf_minmax_cmp(struct rtw_dev *r=
twdev, u32 value,
>         }
>  }
>=20
> -static void __rtw8822c_dac_iq_sort(struct rtw_dev *rtwdev, u32 *v1, u32 =
*v2)
> +static void __rtw8822c_dac_iq_sort(struct rtw_dev *rtwdev, s32 *v1_s32, =
s32 *v2_s32)
>  {
> +       u32 *v1 =3D (u32 *)v1_s32;
> +       u32 *v2 =3D (u32 *)v2_s32;

blank line

>         if (*v1 >=3D 0x200 && *v2 >=3D 0x200) {
>                 if (*v1 > *v2)
>                         swap(*v1, *v2);

[...]

