Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C175733E;
	Mon, 17 Aug 2026 03:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786936618; cv=none; b=tuOShl0H1Al9p3jXcirwm4g1WnaBzJ7yLFnkPNttg64/BOcpEWpHf/iabYW49bNpvR2nVhdijXfwaAp/K+0pyNDe5IOERCjwFc+BAbxx+DCDasJNQcgNby2ob7JMFidZdzmPa3PeV6ZEp8ncvODrh0gJK7t1EBD7tgI+1OB/aSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786936618; c=relaxed/simple;
	bh=/Bx01W19s4v1/YaliKWmuOMhYLju7gVpLKY6sdSfbNA=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dfzl6DbG+31uVieGmMKeEugdTGfStjC2l1iFvkDWDBMDS0/n9F1k1cfWPwD87BMzF+bbn46Terj3EkIt8o79BctUUe99zW03e9OJYRzOz7JFO42sb3Wm36LTZDnIxiDfvS8Ng6A4bvA/E1M8D9T6NqevmSiuRm7xH0IXomzy4X4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=YaaBpI5E; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="YaaBpI5E"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67H3GpTjA3549043, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1786936611; bh=GCsxWCw5oVIegtFTFT00GFgPIj1lA6mAZ2TygQnK/Rk=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=YaaBpI5E4Q4dtGymGfwWnvZabKEvRRuAOYEqQYXugF46/nGswDxbAInZraESt36Rp
	 vqDOjE7FY/TpBx6PuSe7q0PdyW5fiE018X2HaCrpRFu++vZNfIaLRwgDxr58osnidK
	 dFcwO112aMPjOdTeqda9ciR0yJfcAUiYDz3Zz8+2IPJcZPaSArgxkHHHkPlbXRHJyD
	 0UvLwEgewAMNMFOCmq4Mr1IluO9Jl/RfoK2fQCgL+fDt7s938yEeXRVYw+6omKsj5X
	 7H+pgpFeAXnijRqQNpcveohcvL4zzHhRNGl/VpQnudJS/67lUj8Y7u02nefM4EZdy+
	 CqqaDZA9+X1YA==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67H3GpTjA3549043
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 17 Aug 2026 11:16:51 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 17 Aug 2026 11:16:51 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 17 Aug 2026 11:16:45 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Mon, 17 Aug 2026 11:16:45 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: rafad900 <rafad900@gmail.com>, "Jes.Sorensen@gmail.com"
	<Jes.Sorensen@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] wifi: rtl8xxxu: Adjust logging pattern
Thread-Topic: [PATCH] wifi: rtl8xxxu: Adjust logging pattern
Thread-Index: AQHdLapWgXnPfwwxQUW0Y25OjPa26rahkXWA
Date: Mon, 17 Aug 2026 03:16:45 +0000
Message-ID: <adb34509bb6c4767bd1e1f24cc99a62d@realtek.com>
References: <20260816180857.4122090-1-rafad900@gmail.com>
In-Reply-To: <20260816180857.4122090-1-rafad900@gmail.com>
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

rafad900 <rafad900@gmail.com> wrote:
> To ensure consistent patterns, the device struct was
> defined and used when dev_warn() is called within
> rtl8188eu_rx_iqk_path_a().
> This follows the logging pattern used by all the
> other functions defined in the file.
>=20
> Signed-off-by: rafad900 <rafad900@gmail.com>

Please use your real name.=20

The subject can explicitly point out that you are adjusting to use a
local 'dev' variable for dev_warn().=20

> ---
>  drivers/net/wireless/realtek/rtl8xxxu/8188e.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/8188e.c
> b/drivers/net/wireless/realtek/rtl8xxxu/8188e.c
> index fea5aec9ced9..4a64633b2da3 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/8188e.c
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/8188e.c
> @@ -643,6 +643,7 @@ static int rtl8188eu_iqk_path_a(struct rtl8xxxu_priv =
*priv)
>=20
>  static int rtl8188eu_rx_iqk_path_a(struct rtl8xxxu_priv *priv)
>  {
> +       struct device *dev =3D &priv->udev->dev;
>         u32 reg_ea4, reg_eac, reg_e94, reg_e9c, val32;
>         int result =3D 0;
>=20
> @@ -740,7 +741,7 @@ static int rtl8188eu_rx_iqk_path_a(struct rtl8xxxu_pr=
iv *priv)
>             ((reg_eac & 0x03ff0000) !=3D 0x00360000))
>                 result |=3D 0x02;
>         else
> -               dev_warn(&priv->udev->dev, "%s: Path A RX IQK failed!\n",
> +               dev_warn(dev, "%s: Path A RX IQK failed!\n",

The counts of individual use case are:

$ git grep "dev_warn(&priv->udev->dev" drivers/net/wireless/realtek/rtl8xxx=
u/ | wc -l
19
$ git grep "dev_warn(dev" drivers/net/wireless/realtek/rtl8xxxu/ | wc -l
35

If it is worth to do, please convert all of them.

>                          __func__);
>=20
>  out:
> --
> 2.43.0
>=20

