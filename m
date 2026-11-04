Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793753278;
	b=Ys3CZdYUJguGLByFCE/0AO0hiKilx2l6Tw+vHmStj3+/ZZFSqEdSugtNf4DEhs2S48+m
	 BwqMIONJnkDqzMMPg69cbWVzAkEP3SlxV3Q22uf5nBsuCIRhlS5cPhgtBObQQ+RQWYZNR
	 Fsa54lxSQVQlylFJiPwnshED572OpbK71YOoorIASA+dE1tkgGXp9OgJrOiQCJEcfI/yA
	 lQWOgu9+YcU4WP2L6XbsimObEI0WkL17A6492y1D0vUrxyklPuyjILMVWcBZevB0eA2CX
	 WdqZLkViQBYgsdsJUtNYjg71zJLB3Km3ujt1Hp3EwCgjeNshvlofq1kQFVFNXO7W2eQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793753278;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:Received:From:To:CC:Subject:Thread-Topic:Thread-Index:Date:
	 Message-ID:References:In-Reply-To:Accept-Language:Content-Language:
	 x-originating-ip:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=YN/E4Wyz1aUm1HWs+wbm+jXeIr2CMZ7iG+W7kfP+FaU=;
	b=L6SwKJKalEjrbgLC1BupA6O6Fy5Z8D+hpWHL7lZ2ODNmaip4vgJLA+q6w40Ik1UYAUH6
	 gwbSf1V0WVonhGezY1dD9hmyOu5adRY6vf5SHWJwVMctm7uJWL2uAVoiMVVFrF/CeUQCn
	 5ADOclTDZs9Nly324ZO7OD0/MCgKxC8G69BuHYp7fBMYwWUfAuqw68Uq3w0Xa5Bb5nroA
	 Znbs29evM5tpcpxyyV3QpV9DTPf+VNpdygzbWUBozba2+wTNTyG/Q+17ZJkg9GYASCqSF
	 taFGRP7zW1b6ajUKwYhbkCmpoiKH/dproYsGVKF/oLQlmxfY4zTCnfU8s4/jHJmNSgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b="hW54/rkd";
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E475E606A326;
	Wed,  4 Nov 2026 00:47:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E475E606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=hW54/rkd
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6A40lrleF3534673, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1793753273; bh=YN/E4Wyz1aUm1HWs+wbm+jXeIr2CMZ7iG+W7kfP+FaU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=hW54/rkdtQhqxW9Ck1Z1CduipITb/T/BeRWtJaAyI1v+VwNmP0371jqjEFu3ssfWa
	 tdOKQQDxxSeUTcFiMZlLRGwetNpFBw7SR1Qy9HBI2chK5Lm3x5OOuC4hzcB10pqIA/
	 yCs4IUAeekllVdl3kaMytVQQlCvvT/BbdSOu+EdmrgUgct2r7fngeJEgWc2sTYlnyc
	 6cllcUOo5/1UuwVBncbavGf7AjvxLZtPceNMx+DhL8cecfcSyXiBY209cHVf8qPHpr
	 BZ7KhXmuL7EII2LtxLl1y1gALgMLT/yRTsd8XsRSLqKUpwZkf9JIt8S5/5z8uQtR0W
	 NBkYlYAtB9Nsw==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6A40lrleF3534673
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 4 Nov 2026 08:47:53 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Wed, 4 Nov 2026 08:47:53 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Wed, 4 Nov 2026 08:47:53 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([fe80::eeeb:c765:ca73:5eef]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::eeeb:c765:ca73:5eef%10]) with mapi id
 15.02.2562.056; Wed, 4 Nov 2026 08:47:53 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Rosen Penev <rosenp@gmail.com>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>
CC: open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH rtw-next v2] wifi: rtw89: acpi: check for _DSM function
 support before evaluating it
Thread-Topic: [PATCH rtw-next v2] wifi: rtw89: acpi: check for _DSM function
 support before evaluating it
Thread-Index: AQHda94e8ktfMF9qOEe8mjt2M2R0LbcdE7IQ
Date: Wed, 4 Nov 2026 00:47:53 +0000
Message-ID: <a5f044a803a64a1eb68815f075bda2ee@realtek.com>
References: <20261103215557.183459-1-rosenp@gmail.com>
In-Reply-To: <20261103215557.183459-1-rosenp@gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Rosen Penev <rosenp@gmail.com> wrote:
> When the WiFi device has no ACPI companion, or the firmware does not
> implement a given rtw89 _DSM function, rtw89_acpi_evaluate_dsm() calls
> acpi_evaluate_dsm() anyway. ACPI core then warns on every probe:
>=20
>   ACPI: \: failed to evaluate _DSM e8c3a8d2-694b-004f-82bd-fe8607803aa7 r=
ev:0 func:10 (0x1001)
>   ACPI: \: failed to evaluate _DSM e8c3a8d2-694b-004f-82bd-fe8607803aa7 r=
ev:0 func:6 (0x1001)
>=20
> Here the handle is NULL, and acpi_evaluate_object() returns
> AE_BAD_PARAMETER. All callers already treat failure as "no policy
> provided by the platform", so this is only noise.
>=20
> Bail out early when there is no ACPI handle, as acpi_check_dsm() would
> otherwise hit the same warning while querying function 0. Then use
> acpi_check_dsm() so that functions the firmware does not advertise fail
> quietly at debug level, as rtw89_acpi_evaluate_method() already does.

Adding this check is fine to me. But my question in v1 is that=20
acpi_check_dsm() checks func 0 to determine if BIT(func) is existing.
Is it possible func 0 not existing, but BIT(func) existing?

>=20
> Seen on an RTL8852BE in a desktop PCIe slot.
>=20
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> ---
>  v2: check handle separately. Remove Fixes.
>  drivers/net/wireless/realtek/rtw89/acpi.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/wireless/realtek/rtw89/acpi.c b/drivers/net/wire=
less/realtek/rtw89/acpi.c
> index ebb6cf555747..3396d42594b3 100644
> --- a/drivers/net/wireless/realtek/rtw89/acpi.c
> +++ b/drivers/net/wireless/realtek/rtw89/acpi.c
> @@ -372,11 +372,22 @@ int rtw89_acpi_evaluate_dsm(struct rtw89_dev *rtwde=
v,
>                             enum rtw89_acpi_dsm_func func,
>                             struct rtw89_acpi_dsm_result *res)
>  {
> +       acpi_handle handle =3D ACPI_HANDLE(rtwdev->dev);
>         union acpi_object *obj;
>         int ret;
>=20
> -       obj =3D acpi_evaluate_dsm(ACPI_HANDLE(rtwdev->dev), &rtw89_guid,
> -                               0, func, NULL);
> +       if (!handle) {
> +               rtw89_debug(rtwdev, RTW89_DBG_ACPI, "acpi dsm no handle\n=
");
> +               return -ENODEV;
> +       }
> +
> +       if (!acpi_check_dsm(handle, &rtw89_guid, 0, BIT(func))) {
> +               rtw89_debug(rtwdev, RTW89_DBG_ACPI,
> +                           "acpi dsm func %d not supported\n", func);
> +               return -ENOENT;
> +       }
> +
> +       obj =3D acpi_evaluate_dsm(handle, &rtw89_guid, 0, func, NULL);
>         if (!obj) {
>                 rtw89_debug(rtwdev, RTW89_DBG_ACPI,
>                             "acpi dsm fail to evaluate func: %d\n", func)=
;
> --
> 2.56.0

