Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97CC42248A5;
	Tue, 18 Aug 2026 00:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787013501; cv=none; b=bl03DByWxn9j8cvWqhKc09cvnnFQruojsVhYIYBzEEkPt061n5cJOFqBlhsgTaqKQNyLiVxOLLYUIJJrzhvcnw70EsqSkrYnQSZWMeagcq1jpxbduW1a4FhH6nnlkE7AHvqB/kYgI8PS/mnwJKI2UblI/CHm60wqdkvbn9iu7Tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787013501; c=relaxed/simple;
	bh=bmBX111I2SkMSE07VJ9vSz59E/+0vvIdhKTrR1Z7pDo=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Oex9V4SAALx7rQY44xwab11X0+74fBCMGlH9q+FPvQkOIrP9t2inUQZlX1SoAwQG7L469DBMeA9KPY8g+VPIfCevyYNXyNvewvQ9J6ZJi7U7SpgEvIcbgivkFInV03J7hL3L+Z+4Qy+ISFDmUHrHYGUJG7LxF3dxVP2166AZ1hY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=s2GLJGfV; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="s2GLJGfV"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67I0cESu9316605, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1787013494; bh=R5wMLCsRtK6VO8sUW1AhOUyqARf2huAIg/6cMpOcXE8=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=s2GLJGfVX9xT+qlDy0gNjBLHOoXrEkxq9IcSck/8KIFxNh5QtZbkx9PhK6lG3ORZ6
	 HjCaEBBqZydOmsAsc7stSIXamBV19GMN1SMPgsvr3yGY3uZfkegI+dfk1VM/1+MrQV
	 SKYkUIQrnI6E287UZM/aO+/OZsnegbpOGFDZGhwoTf3JrXZIHFy3KZH2r+M0FBXim/
	 oEAyzPz2B0o6mcZ2PTqCgS/fuuYKiefEj9OFuRqI2G1JNe18URk+Qw64n/j02VbFwU
	 74nutw39UgN043lJ6XCQt4ncs7UR/f3/50qEKAlMckqOXChkdvV5RXy9I4LccXy7oP
	 LSA+mmklCEgMQ==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67I0cESu9316605
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 18 Aug 2026 08:38:14 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 18 Aug 2026 08:38:14 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Tue, 18 Aug 2026 08:38:14 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: rafad900 <rafad900@gmail.com>, "Jes.Sorensen@gmail.com"
	<Jes.Sorensen@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>
Subject: RE: [PATCH rtw-next v3] wifi: rtl8xxxu: Use local 'dev' variable for
 dev_warn()
Thread-Topic: [PATCH rtw-next v3] wifi: rtl8xxxu: Use local 'dev' variable for
 dev_warn()
Thread-Index: AQHdLpp/U7jX/Me9EEigBVStdQDq+rai9MtQ
Date: Tue, 18 Aug 2026 00:38:14 +0000
Message-ID: <c11e6b265c294f3aaf94057a44b8d447@realtek.com>
References: <20260817224104.1462505-1-rafad900@gmail.com>
In-Reply-To: <20260817224104.1462505-1-rafad900@gmail.com>
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
> From: Rafael Alejandro Diaz Cruz <rafad900@gmail.com>
>=20
> To ensure consistent patterns, the device struct was
> defined and used when dev_warn() is called.
> This follows the logging pattern used in most of
> rtl8xxxu files.
>=20
> Signed-off-by: Rafael Alejandro Diaz Cruz <rafad900@gmail.com>
> ---
>  drivers/net/wireless/realtek/rtl8xxxu/8188e.c |  3 ++-
>  drivers/net/wireless/realtek/rtl8xxxu/8188f.c |  3 ++-
>  drivers/net/wireless/realtek/rtl8xxxu/8192e.c | 12 ++++++---
>  drivers/net/wireless/realtek/rtl8xxxu/8192f.c |  9 ++++---
>  drivers/net/wireless/realtek/rtl8xxxu/8723a.c |  3 ++-
>  drivers/net/wireless/realtek/rtl8xxxu/8723b.c |  3 ++-
>  drivers/net/wireless/realtek/rtl8xxxu/core.c  | 26 ++++++++++++-------
>  7 files changed, 39 insertions(+), 20 deletions(-)
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
>                          __func__);

Straighten

>=20
>  out:
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/8188f.c
> b/drivers/net/wireless/realtek/rtl8xxxu/8188f.c
> index 5556aad1a7ad..68609ce37ab0 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/8188f.c
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/8188f.c
> @@ -789,6 +789,7 @@ static int rtl8188fu_init_phy_rf(struct rtl8xxxu_priv=
 *priv)
>=20
>  void rtl8188f_phy_lc_calibrate(struct rtl8xxxu_priv *priv)
>  {
> +       struct device *dev =3D &priv->udev->dev;
>         u32 val32;
>         u32 rf_amode, lstf;
>         int i;
> @@ -819,7 +820,7 @@ void rtl8188f_phy_lc_calibrate(struct rtl8xxxu_priv *=
priv)
>         }
>=20
>         if (i =3D=3D 100)
> -               dev_warn(&priv->udev->dev, "LC calibration timed out.\n")=
;
> +               dev_warn(dev, "LC calibration timed out.\n");
>=20
>         rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_MODE_AG, rf_amode);
>=20
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/8192e.c
> b/drivers/net/wireless/realtek/rtl8xxxu/8192e.c
> index 690ace303150..8385ada532b3 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/8192e.c
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/8192e.c
> @@ -742,6 +742,7 @@ static int rtl8192eu_iqk_path_a(struct rtl8xxxu_priv =
*priv)
>=20
>  static int rtl8192eu_rx_iqk_path_a(struct rtl8xxxu_priv *priv)
>  {
> +       struct device *dev =3D &priv->udev->dev;
>         u32 reg_ea4, reg_eac, reg_e94, reg_e9c, val32;
>         int result =3D 0;
>=20
> @@ -860,7 +861,7 @@ static int rtl8192eu_rx_iqk_path_a(struct rtl8xxxu_pr=
iv *priv)
>             ((reg_eac & 0x03ff0000) !=3D 0x00360000))
>                 result |=3D 0x02;
>         else
> -               dev_warn(&priv->udev->dev, "%s: Path A RX IQK failed!\n",
> +               dev_warn(dev, "%s: Path A RX IQK failed!\n",
>                          __func__);

Straighten

>=20
>  out:
> @@ -869,6 +870,7 @@ static int rtl8192eu_rx_iqk_path_a(struct rtl8xxxu_pr=
iv *priv)
>=20
>  static int rtl8192eu_iqk_path_b(struct rtl8xxxu_priv *priv)
>  {
> +       struct device *dev =3D &priv->udev->dev;
>         u32 reg_eac, reg_eb4, reg_ebc;
>         int result =3D 0;
>=20
> @@ -910,7 +912,7 @@ static int rtl8192eu_iqk_path_b(struct rtl8xxxu_priv =
*priv)
>             ((reg_ebc & 0x03ff0000) !=3D 0x00420000))
>                 result |=3D 0x01;
>         else
> -               dev_warn(&priv->udev->dev, "%s: Path B IQK failed!\n",
> +               dev_warn(dev, "%s: Path B IQK failed!\n",
>                          __func__);

Straighten

>=20
>         return result;
> @@ -918,6 +920,7 @@ static int rtl8192eu_iqk_path_b(struct rtl8xxxu_priv =
*priv)
>=20
>  static int rtl8192eu_rx_iqk_path_b(struct rtl8xxxu_priv *priv)
>  {
> +       struct device *dev =3D &priv->udev->dev;
>         u32 reg_eac, reg_eb4, reg_ebc, reg_ec4, reg_ecc, val32;
>         int result =3D 0;
>=20
> @@ -1040,7 +1043,7 @@ static int rtl8192eu_rx_iqk_path_b(struct rtl8xxxu_=
priv *priv)
>             ((reg_ecc & 0x03ff0000) !=3D 0x00360000))
>                 result |=3D 0x02;
>         else
> -               dev_warn(&priv->udev->dev, "%s: Path B RX IQK failed!\n",
> +               dev_warn(dev, "%s: Path B RX IQK failed!\n",
>                          __func__);

Straighten

>=20
>  out:
> @@ -1495,6 +1498,7 @@ static int rtl8192eu_active_to_lps(struct rtl8xxxu_=
priv *priv)
>=20
>  static int rtl8192eu_active_to_emu(struct rtl8xxxu_priv *priv)
>  {
> +       struct device *dev =3D &priv->udev->dev;
>         u8 val8;
>         int count, ret =3D 0;
>=20
> @@ -1521,7 +1525,7 @@ static int rtl8192eu_active_to_emu(struct rtl8xxxu_=
priv *priv)
>         }
>=20
>         if (!count) {
> -               dev_warn(&priv->udev->dev, "%s: Disabling MAC timed out\n=
",
> +               dev_warn(dev, "%s: Disabling MAC timed out\n",
>                          __func__);

Straighten

>                 ret =3D -EBUSY;
>                 goto exit;
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/8192f.c
> b/drivers/net/wireless/realtek/rtl8xxxu/8192f.c
> index 5f076da4b550..0b8c068215d7 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/8192f.c
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/8192f.c
> @@ -681,6 +681,7 @@ static void rtl8192fu_init_aggregation(struct rtl8xxx=
u_priv *priv)
>=20
>  static int rtl8192fu_parse_efuse(struct rtl8xxxu_priv *priv)
>  {
> +       struct device *dev =3D &priv->udev->dev;
>         struct rtl8192fu_efuse *efuse =3D &priv->efuse_wifi.efuse8192fu;
>         int i;
>=20
> @@ -731,7 +732,7 @@ static int rtl8192fu_parse_efuse(struct rtl8xxxu_priv=
 *priv)
>         priv->rfe_type =3D efuse->rfe_option & 0x1f;
>=20
>         if (priv->rfe_type !=3D 5 && priv->rfe_type !=3D 1)
> -               dev_warn(&priv->udev->dev,
> +               dev_warn(dev,
>                          "%s: RFE type %d was not tested. Please send an =
email to
> linux-wireless@vger.kernel.org about this.\n",
>                          __func__, priv->rfe_type);
>=20
> @@ -1022,6 +1023,7 @@ static int rtl8192fu_rx_iqk_path_a(struct rtl8xxxu_=
priv *priv)
>=20
>  static int rtl8192fu_iqk_path_b(struct rtl8xxxu_priv *priv)
>  {
> +       struct device *dev =3D &priv->udev->dev;
>         u32 reg_eac, reg_eb4, reg_ebc, val32;
>         u32 rf_0x58_i, rf_0x58_q;
>         u8 rfe =3D priv->rfe_type;
> @@ -1109,7 +1111,7 @@ static int rtl8192fu_iqk_path_b(struct rtl8xxxu_pri=
v *priv)
>             ((reg_ebc & 0x03ff0000) !=3D 0x00420000))
>                 result |=3D 0x01;
>         else
> -               dev_warn(&priv->udev->dev, "%s: Path B IQK failed!\n",
> +               dev_warn(dev, "%s: Path B IQK failed!\n",
>                          __func__);

Straighten

>=20
>         return result;
> @@ -1117,6 +1119,7 @@ static int rtl8192fu_iqk_path_b(struct rtl8xxxu_pri=
v *priv)
>=20
>  static int rtl8192fu_rx_iqk_path_b(struct rtl8xxxu_priv *priv)
>  {
> +       struct device *dev =3D &priv->udev->dev;
>         u32 reg_eac, reg_eb4, reg_ebc, reg_ec4, reg_ecc, val32;
>         int result =3D 0;
>         int ktime;
> @@ -1246,7 +1249,7 @@ static int rtl8192fu_rx_iqk_path_b(struct rtl8xxxu_=
priv *priv)
>             ((reg_ecc & 0x03ff0000) !=3D 0x00360000))
>                 result |=3D 0x02;
>         else
> -               dev_warn(&priv->udev->dev, "%s: Path B RX IQK failed!\n",
> +               dev_warn(dev, "%s: Path B RX IQK failed!\n",
>                          __func__);

Straighten

>=20
>         return result;
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/8723a.c
> b/drivers/net/wireless/realtek/rtl8xxxu/8723a.c
> index 18e038b82f49..3525ecf07b48 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/8723a.c
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/8723a.c
> @@ -413,6 +413,7 @@ static int rtl8723au_power_on(struct rtl8xxxu_priv *p=
riv)
>=20
>  static int rtl8723au_active_to_emu(struct rtl8xxxu_priv *priv)
>  {
> +       struct device *dev =3D &priv->udev->dev;
>         u8 val8;
>         int count, ret =3D 0;
>=20
> @@ -439,7 +440,7 @@ static int rtl8723au_active_to_emu(struct rtl8xxxu_pr=
iv *priv)
>         }
>=20
>         if (!count) {
> -               dev_warn(&priv->udev->dev, "%s: Disabling MAC timed out\n=
",
> +               dev_warn(dev, "%s: Disabling MAC timed out\n",
>                          __func__);

Straighten

>                 ret =3D -EBUSY;
>                 goto exit;
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/8723b.c
> b/drivers/net/wireless/realtek/rtl8xxxu/8723b.c
> index 24c6d8ae76ec..caf0f59aeeaf 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/8723b.c
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/8723b.c
> @@ -1216,6 +1216,7 @@ static void rtl8723bu_phy_iq_calibrate(struct rtl8x=
xxu_priv *priv)
>=20
>  static int rtl8723bu_active_to_emu(struct rtl8xxxu_priv *priv)
>  {
> +       struct device *dev =3D &priv->udev->dev;
>         u8 val8;
>         u16 val16;
>         u32 val32;
> @@ -1247,7 +1248,7 @@ static int rtl8723bu_active_to_emu(struct rtl8xxxu_=
priv *priv)
>         }
>=20
>         if (!count) {
> -               dev_warn(&priv->udev->dev, "%s: Disabling MAC timed out\n=
",
> +               dev_warn(dev, "%s: Disabling MAC timed out\n",
>                          __func__);

Straighten=20

>                 ret =3D -EBUSY;
>                 goto exit;
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/core.c
> b/drivers/net/wireless/realtek/rtl8xxxu/core.c
> index bddbd0990de7..b3ef8e5c96a8 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/core.c
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/core.c
> @@ -2186,6 +2186,7 @@ void rtl8xxxu_firmware_self_reset(struct rtl8xxxu_p=
riv *priv)
>  static int
>  rtl8xxxu_init_mac(struct rtl8xxxu_priv *priv)
>  {
> +       struct device *dev =3D &priv->udev->dev;
>         const struct rtl8xxxu_reg8val *array =3D priv->fops->mactable;
>         int i, ret;
>         u16 reg;
> @@ -2200,7 +2201,7 @@ rtl8xxxu_init_mac(struct rtl8xxxu_priv *priv)
>=20
>                 ret =3D rtl8xxxu_write8(priv, reg, val);
>                 if (ret !=3D 1) {
> -                       dev_warn(&priv->udev->dev,
> +                       dev_warn(dev,
>                                  "Failed to initialize MAC "

Straighten=20

>                                  "(reg: %04x, val %02x)\n", reg, val);
>                         return -EAGAIN;
> @@ -2228,6 +2229,7 @@ rtl8xxxu_init_mac(struct rtl8xxxu_priv *priv)
>  int rtl8xxxu_init_phy_regs(struct rtl8xxxu_priv *priv,
>                            const struct rtl8xxxu_reg32val *array)
>  {
> +       struct device *dev =3D &priv->udev->dev;
>         int i, ret;
>         u16 reg;
>         u32 val;
> @@ -2241,7 +2243,7 @@ int rtl8xxxu_init_phy_regs(struct rtl8xxxu_priv *pr=
iv,
>=20
>                 ret =3D rtl8xxxu_write32(priv, reg, val);
>                 if (ret !=3D sizeof(val)) {
> -                       dev_warn(&priv->udev->dev,
> +                       dev_warn(dev,
>                                  "Failed to initialize PHY\n");

Straighten=20

>                         return -EAGAIN;
>                 }
> @@ -2386,6 +2388,7 @@ static int rtl8xxxu_init_rf_regs(struct rtl8xxxu_pr=
iv *priv,
>                                  const struct rtl8xxxu_rfregval *array,
>                                  enum rtl8xxxu_rfpath path)
>  {
> +       struct device *dev =3D &priv->udev->dev;
>         int i, ret;
>         u8 reg;
>         u32 val;
> @@ -2420,7 +2423,7 @@ static int rtl8xxxu_init_rf_regs(struct rtl8xxxu_pr=
iv *priv,
>=20
>                 ret =3D rtl8xxxu_write_rfreg(priv, path, reg, val);
>                 if (ret) {
> -                       dev_warn(&priv->udev->dev,
> +                       dev_warn(dev,
>                                  "Failed to initialize RF\n");

Straighten

>                         return -EAGAIN;
>                 }

[...]

> @@ -3637,6 +3643,7 @@ static void rtl8xxxu_set_ampdu_min_space(struct rtl=
8xxxu_priv *priv, u8 density)
>=20
>  int rtl8xxxu_active_to_lps(struct rtl8xxxu_priv *priv)
>  {
> +       struct device *dev =3D &priv->udev->dev;
>         u8 val8;
>         u8 val32;
>         int count, ret =3D 0;
> @@ -3654,7 +3661,7 @@ int rtl8xxxu_active_to_lps(struct rtl8xxxu_priv *pr=
iv)
>         }
>=20
>         if (!count) {
> -               dev_warn(&priv->udev->dev,
> +               dev_warn(dev,
>                          "%s: RX poll timed out (0x05f8)\n", __func__);

Straighten.

>                 ret =3D -EBUSY;
>                 goto exit;
> @@ -5867,8 +5874,9 @@ static void rtl8xxxu_rx_urb_work(struct work_struct=
 *work)
>         struct sk_buff *skb;
>         unsigned long flags;
>         int ret;
> -
> +
>         priv =3D container_of(work, struct rtl8xxxu_priv, rx_urb_wq);
> +       struct device *dev =3D &priv->udev->dev;

No declaration in the middle.=20

>         INIT_LIST_HEAD(&local);
>=20
>         spin_lock_irqsave(&priv->rx_urb_lock, flags);
> @@ -5894,7 +5902,7 @@ static void rtl8xxxu_rx_urb_work(struct work_struct=
 *work)
>                         rtl8xxxu_queue_rx_urb(priv, rx_urb);
>                         break;
>                 default:
> -                       dev_warn(&priv->udev->dev,
> +                       dev_warn(dev,
>                                  "failed to requeue urb with error %i\n",=
 ret);

Straighten.=20

>                         skb =3D (struct sk_buff *)rx_urb->urb.context;
>                         dev_kfree_skb(skb);
> --
> 2.43.0
>=20

Using local 'dev' decreases the length of statements, so for many cases we
can straighten the next line (if it's shorter than 80 charachters).

Please run checkpatch before sending out.=20

ERROR: trailing whitespace
#362: FILE: drivers/net/wireless/realtek/rtl8xxxu/core.c:5877:
+^I$

total: 1 errors, 0 warnings, 0 checks, 288 lines checked


