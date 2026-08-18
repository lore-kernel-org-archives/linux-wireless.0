Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED25C34FF41
	for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2026 19:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787081617; cv=pass; b=FH3OiUJmGddY4WRLHhdJVbaH1ZTwGpUevjZVeo+SKxFjNpaGD7mvjsUlj3Rx2GixVBwBaXb9Xg2HMA/nDMCEQV9zGZXes+VrKfcBuNH0yS97ppVYIqrpQPPlzwq7UwlNBqS703Kdjgz3QTIvhY6gcruZRR6Z8nRUwGWDrLemGYk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787081617; c=relaxed/simple;
	bh=LS1lg/+kYXkIhlFDfpbXSFVis7CA7YDdmdJ2HIqSl9Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=r9hJMDDmgR5LuWgf9mQmJwM5TnlEXjqlsDf/EeTUs5i01FTmKs5zoH5nfH47VDXnVtkaOrlEghc2xdiixN+VUf4qUYtgR4MVsvdxmKxzZE8WUMndPJNtBZ5HkA/QD6tVFn3ATF8JRVDRl5FSaN/OtEIUanTO90lDb3XN1GBbaGo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GQFOg0gD; arc=pass smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GQFOg0gD"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-84867f07d63so315672b3a.2
        for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2026 12:33:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787081615; cv=none;
        d=google.com; s=arc-20260327;
        b=ayq0chD+HWjZlOvPnAg7PvaV6zjY9n7kd9TV1ErBByW71mkD75Ii37icv+VGwfDJIX
         rIHlmAEHgGkn+f62XFGts442OFtqoidk1PelHE8tXI3P79wkZ6mCsI9IjcMs+LskPtO7
         ETbsl1F7v7LypXL4RnNx/tVRSYAf1XllB3oh3tulOnkCH/Gj4SaS5AatBb2i92IVmQ1O
         ALT6frZ/qA+NpiI/omzMojK75f9rSRfydkm3smG7l3u2BQH269wV7gZv72TD8IPQHu/f
         oNnJ1A+JdWr1cNhDU9Ua88NjuPMnXbmZxRacSst+BxrppV8AVDB9u7EkquJYla10oDKF
         FR5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hKlxb/uQ//1aFUTumth3gCBlse1oEA7VHxvzlAi8txQ=;
        fh=b0ApMsg7DIADToELxJ2/MehYFf89pV1U30cD0l4qPdc=;
        b=kKxf1NjJy8yJaz47VDVN6BUF62sshGCiKqGNEpR1+s3a+S9HYnh/rJ+3Cb7Kc3Dm4Z
         d1IJGIwgmfXkh3dFgb364jwfWTHDg25p7Mqqab5QMe/P//IlokWixHF46uWsuda67qMD
         cpKM7VvM9/NNsv5kwlsa14Ec5A5Pi4wMwyF8Zm+64MvV5wWJgiRm3BEIwC8+Naomr7sp
         nseQ/iJ+CxYSoAnQLiLUn8RCY3mA6AWhUvYrSBNnHw1QoL+yuc5OSVeZMXl3vNqVzPU7
         +g2PvNIXaa5Cuq/NENF1jgg4Xyh5GzG3YZhfMn6nEUBtcrHvrNY3mJa8Q1rkRxSBRy4L
         PA9Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787081615; x=1787686415; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:to:subject:message-id:date
         :from:in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hKlxb/uQ//1aFUTumth3gCBlse1oEA7VHxvzlAi8txQ=;
        b=GQFOg0gD77/3Jk7tlrBd3XoKeoBuwu7Q6ckChvwDRqkq9nTa43XMF+CIOpykaWRfU5
         rHhyZba6Yf0C9+2I6PNpcqm0fi/o3ZuTeNqm/16AD7gCf4wHBl0ednccwxfFu67XXU+M
         D6etwyB98rKdoehXGlOaouNzqJN8t5rCy5XqtNneVkmI3tjAIdWGvbvuIYMKBAFozE9E
         PCp3CotBsYXIIIWnT7G6/803m5vzpYg5zATD2NAIOPiO1sN273OhsgzQ++NLV0pTpGMv
         7rkM5EBxn6iOUkXgLf3rNHX0dG2TF8MZQuJD/JyBmKKy+5CbjEknxXUEj4rPWb2XUgcr
         kckQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787081615; x=1787686415;
        h=content-transfer-encoding:content-type:to:subject:message-id:date
         :from:in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=hKlxb/uQ//1aFUTumth3gCBlse1oEA7VHxvzlAi8txQ=;
        b=MOLiY9k29gXdEWxwRiL9GnpAHcXNGcEcguccfGwynwROwZ2tfUVokbieQvsrDBR9SH
         7xvIJ53q+OXw8JQ3dIFmevNp0qcjeF6vzrtCF3HwaDHYZFBT4p8cwxazcHtyxN6frsyZ
         K7cdtM8cBNrTrQ15YENF8MKfHgqcYKWa5/sTheCUZzoaaxwkPGFSmE0TTFEsRq/MhZcy
         c66YPvYwymwPMSi+Yp30eCE6nAgqRqOnek+nHXjmhCTZl0wUvj7ka0t9N/E9GjmVsazK
         PRm6fuKznc8RcRCX8It3SLCmBsGLIMsEDtLU3BAD2mCi8KO0YSaO0dwlprYyq+Dgoq13
         ApqA==
X-Forwarded-Encrypted: i=1; AHgh+Rq8MxNCjQq9CSgjtzLN3Ld9e/q3UnRlu/N+uVFg8eaEyzMcPC4P+wFMZ++fE6zLQoev+0UUOBa8wLUZ7vAWmw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwSpa4tgOOehx53iGM4AOvhh4nKYx0E1ceKLB+WYUFevDfFfLBe
	fTK72A+B0spY4Ckx00Uj6/lvr9G19d48P+kBFB0Z1CyawiUk8vEjLFZbRfpKXgmUrH2OjkiTPir
	rPpZRkZSV4GMrcdp2fMY1CKMSSVi6vb20hNr+
X-Gm-Gg: AR+sD13C4yZSzGSm1e1X2BIeX+iaiXaIDs7Ips74WP8JmO5LMmorAt/f1xw+SFRyapP
	ee+C1MuC/FOB+duQbvd5rMVPL8J7y9wGKaaIkbcKI+drM+DGdGn5GwQt7ks4emqFw/PHd54kImm
	WOcSecq+usNtQBRj47d0vS9lVGsyatTzG0LhHMroBvBTbb4Wsbs80F8l+u1oXTq9NW7Wz6K/XIV
	3b9SPJWHtOOM2FqSUumShpucQU6YQxcc3b3gfIVwTQZLvPp65u1ghLxpRS8ddgpznrrkNTha48d
	JopGaazfzzuXrpXRX2IVBy45W34k10u39q7yPWYK5blmZte2yEU84P5ontS7FIplwdqYYF3yb0f
	/eQ==
X-Received: by 2002:a05:6a21:9089:b0:3bf:6222:2e7e with SMTP id
 adf61e73a8af0-3ccff1df24cmr134315637.4.1787081614886; Tue, 18 Aug 2026
 12:33:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260818190957.2093486-1-rafad900@gmail.com>
In-Reply-To: <20260818190957.2093486-1-rafad900@gmail.com>
From: =?UTF-8?Q?Rafael_Alejandro_D=C3=ADaz_Cruz?= <rafad900@gmail.com>
Date: Tue, 18 Aug 2026 12:33:22 -0700
X-Gm-Features: AcwNN1XCdNKiRV5VRH0aex23Jtjs20FLxnhNZ2HzDtEU2xRDBLx3o6s2zB3um1c
Message-ID: <CALp66yG--f1c0p9BB50jMUjs6Qtonp_strEyrUYDRSzuQ_KFFg@mail.gmail.com>
Subject: Re: [PATCH] wifi: rtl8xxxu: Use local 'dev' variable for dev_warn()
To: Jes.Sorensen@gmail.com, linux-kernel@vger.kernel.org, 
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

sorry, please ignore this patch. It was a test email that I messed up.

On Tue, Aug 18, 2026 at 12:09=E2=80=AFPM rafad900 <rafad900@gmail.com> wrot=
e:
>
> From: Rafael Alejandro Diaz Cruz <rafad900@gmail.com>
>
> To ensure consistent patterns, the device struct was
> defined and used when dev_warn() is called.
> This follows the logging pattern used in most of
> rtl8xxxu files.
>
> Signed-off-by: Rafael Alejandro Diaz Cruz <rafad900@gmail.com>
> ---
>  drivers/net/wireless/realtek/rtl8xxxu/8188e.c |  4 +--
>  drivers/net/wireless/realtek/rtl8xxxu/8188f.c |  3 +-
>  drivers/net/wireless/realtek/rtl8xxxu/8192e.c | 16 +++++-----
>  drivers/net/wireless/realtek/rtl8xxxu/8192f.c | 11 ++++---
>  drivers/net/wireless/realtek/rtl8xxxu/8723a.c |  4 +--
>  drivers/net/wireless/realtek/rtl8xxxu/8723b.c |  4 +--
>  drivers/net/wireless/realtek/rtl8xxxu/core.c  | 31 ++++++++++---------
>  7 files changed, 39 insertions(+), 34 deletions(-)
>
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/8188e.c b/drivers/net/=
wireless/realtek/rtl8xxxu/8188e.c
> index fea5aec9ced9..040f4bbbeae4 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/8188e.c
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/8188e.c
> @@ -643,6 +643,7 @@ static int rtl8188eu_iqk_path_a(struct rtl8xxxu_priv =
*priv)
>
>  static int rtl8188eu_rx_iqk_path_a(struct rtl8xxxu_priv *priv)
>  {
> +       struct device *dev =3D &priv->udev->dev;
>         u32 reg_ea4, reg_eac, reg_e94, reg_e9c, val32;
>         int result =3D 0;
>
> @@ -740,8 +741,7 @@ static int rtl8188eu_rx_iqk_path_a(struct rtl8xxxu_pr=
iv *priv)
>             ((reg_eac & 0x03ff0000) !=3D 0x00360000))
>                 result |=3D 0x02;
>         else
> -               dev_warn(&priv->udev->dev, "%s: Path A RX IQK failed!\n",
> -                        __func__);
> +               dev_warn(dev, "%s: Path A RX IQK failed!\n", __func__);
>
>  out:
>         return result;
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/8188f.c b/drivers/net/=
wireless/realtek/rtl8xxxu/8188f.c
> index 5556aad1a7ad..68609ce37ab0 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/8188f.c
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/8188f.c
> @@ -789,6 +789,7 @@ static int rtl8188fu_init_phy_rf(struct rtl8xxxu_priv=
 *priv)
>
>  void rtl8188f_phy_lc_calibrate(struct rtl8xxxu_priv *priv)
>  {
> +       struct device *dev =3D &priv->udev->dev;
>         u32 val32;
>         u32 rf_amode, lstf;
>         int i;
> @@ -819,7 +820,7 @@ void rtl8188f_phy_lc_calibrate(struct rtl8xxxu_priv *=
priv)
>         }
>
>         if (i =3D=3D 100)
> -               dev_warn(&priv->udev->dev, "LC calibration timed out.\n")=
;
> +               dev_warn(dev, "LC calibration timed out.\n");
>
>         rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_MODE_AG, rf_amode);
>
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/8192e.c b/drivers/net/=
wireless/realtek/rtl8xxxu/8192e.c
> index 690ace303150..131da162d9fb 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/8192e.c
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/8192e.c
> @@ -742,6 +742,7 @@ static int rtl8192eu_iqk_path_a(struct rtl8xxxu_priv =
*priv)
>
>  static int rtl8192eu_rx_iqk_path_a(struct rtl8xxxu_priv *priv)
>  {
> +       struct device *dev =3D &priv->udev->dev;
>         u32 reg_ea4, reg_eac, reg_e94, reg_e9c, val32;
>         int result =3D 0;
>
> @@ -860,8 +861,7 @@ static int rtl8192eu_rx_iqk_path_a(struct rtl8xxxu_pr=
iv *priv)
>             ((reg_eac & 0x03ff0000) !=3D 0x00360000))
>                 result |=3D 0x02;
>         else
> -               dev_warn(&priv->udev->dev, "%s: Path A RX IQK failed!\n",
> -                        __func__);
> +               dev_warn(dev, "%s: Path A RX IQK failed!\n", __func__);
>
>  out:
>         return result;
> @@ -869,6 +869,7 @@ static int rtl8192eu_rx_iqk_path_a(struct rtl8xxxu_pr=
iv *priv)
>
>  static int rtl8192eu_iqk_path_b(struct rtl8xxxu_priv *priv)
>  {
> +       struct device *dev =3D &priv->udev->dev;
>         u32 reg_eac, reg_eb4, reg_ebc;
>         int result =3D 0;
>
> @@ -910,14 +911,14 @@ static int rtl8192eu_iqk_path_b(struct rtl8xxxu_pri=
v *priv)
>             ((reg_ebc & 0x03ff0000) !=3D 0x00420000))
>                 result |=3D 0x01;
>         else
> -               dev_warn(&priv->udev->dev, "%s: Path B IQK failed!\n",
> -                        __func__);
> +               dev_warn(dev, "%s: Path B IQK failed!\n", __func__);
>
>         return result;
>  }
>
>  static int rtl8192eu_rx_iqk_path_b(struct rtl8xxxu_priv *priv)
>  {
> +       struct device *dev =3D &priv->udev->dev;
>         u32 reg_eac, reg_eb4, reg_ebc, reg_ec4, reg_ecc, val32;
>         int result =3D 0;
>
> @@ -1040,8 +1041,7 @@ static int rtl8192eu_rx_iqk_path_b(struct rtl8xxxu_=
priv *priv)
>             ((reg_ecc & 0x03ff0000) !=3D 0x00360000))
>                 result |=3D 0x02;
>         else
> -               dev_warn(&priv->udev->dev, "%s: Path B RX IQK failed!\n",
> -                        __func__);
> +               dev_warn(dev, "%s: Path B RX IQK failed!\n", __func__);
>
>  out:
>         return result;
> @@ -1495,6 +1495,7 @@ static int rtl8192eu_active_to_lps(struct rtl8xxxu_=
priv *priv)
>
>  static int rtl8192eu_active_to_emu(struct rtl8xxxu_priv *priv)
>  {
> +       struct device *dev =3D &priv->udev->dev;
>         u8 val8;
>         int count, ret =3D 0;
>
> @@ -1521,8 +1522,7 @@ static int rtl8192eu_active_to_emu(struct rtl8xxxu_=
priv *priv)
>         }
>
>         if (!count) {
> -               dev_warn(&priv->udev->dev, "%s: Disabling MAC timed out\n=
",
> -                        __func__);
> +               dev_warn(dev, "%s: Disabling MAC timed out\n", __func__);
>                 ret =3D -EBUSY;
>                 goto exit;
>         }
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/8192f.c b/drivers/net/=
wireless/realtek/rtl8xxxu/8192f.c
> index 5f076da4b550..e1a10fe38b9a 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/8192f.c
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/8192f.c
> @@ -681,6 +681,7 @@ static void rtl8192fu_init_aggregation(struct rtl8xxx=
u_priv *priv)
>
>  static int rtl8192fu_parse_efuse(struct rtl8xxxu_priv *priv)
>  {
> +       struct device *dev =3D &priv->udev->dev;
>         struct rtl8192fu_efuse *efuse =3D &priv->efuse_wifi.efuse8192fu;
>         int i;
>
> @@ -731,7 +732,7 @@ static int rtl8192fu_parse_efuse(struct rtl8xxxu_priv=
 *priv)
>         priv->rfe_type =3D efuse->rfe_option & 0x1f;
>
>         if (priv->rfe_type !=3D 5 && priv->rfe_type !=3D 1)
> -               dev_warn(&priv->udev->dev,
> +               dev_warn(dev,
>                          "%s: RFE type %d was not tested. Please send an =
email to linux-wireless@vger.kernel.org about this.\n",
>                          __func__, priv->rfe_type);
>
> @@ -1022,6 +1023,7 @@ static int rtl8192fu_rx_iqk_path_a(struct rtl8xxxu_=
priv *priv)
>
>  static int rtl8192fu_iqk_path_b(struct rtl8xxxu_priv *priv)
>  {
> +       struct device *dev =3D &priv->udev->dev;
>         u32 reg_eac, reg_eb4, reg_ebc, val32;
>         u32 rf_0x58_i, rf_0x58_q;
>         u8 rfe =3D priv->rfe_type;
> @@ -1109,14 +1111,14 @@ static int rtl8192fu_iqk_path_b(struct rtl8xxxu_p=
riv *priv)
>             ((reg_ebc & 0x03ff0000) !=3D 0x00420000))
>                 result |=3D 0x01;
>         else
> -               dev_warn(&priv->udev->dev, "%s: Path B IQK failed!\n",
> -                        __func__);
> +               dev_warn(dev, "%s: Path B IQK failed!\n", __func__);
>
>         return result;
>  }
>
>  static int rtl8192fu_rx_iqk_path_b(struct rtl8xxxu_priv *priv)
>  {
> +       struct device *dev =3D &priv->udev->dev;
>         u32 reg_eac, reg_eb4, reg_ebc, reg_ec4, reg_ecc, val32;
>         int result =3D 0;
>         int ktime;
> @@ -1246,8 +1248,7 @@ static int rtl8192fu_rx_iqk_path_b(struct rtl8xxxu_=
priv *priv)
>             ((reg_ecc & 0x03ff0000) !=3D 0x00360000))
>                 result |=3D 0x02;
>         else
> -               dev_warn(&priv->udev->dev, "%s: Path B RX IQK failed!\n",
> -                        __func__);
> +               dev_warn(dev, "%s: Path B RX IQK failed!\n", __func__);
>
>         return result;
>  }
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/8723a.c b/drivers/net/=
wireless/realtek/rtl8xxxu/8723a.c
> index 18e038b82f49..a68e89c06cf1 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/8723a.c
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/8723a.c
> @@ -413,6 +413,7 @@ static int rtl8723au_power_on(struct rtl8xxxu_priv *p=
riv)
>
>  static int rtl8723au_active_to_emu(struct rtl8xxxu_priv *priv)
>  {
> +       struct device *dev =3D &priv->udev->dev;
>         u8 val8;
>         int count, ret =3D 0;
>
> @@ -439,8 +440,7 @@ static int rtl8723au_active_to_emu(struct rtl8xxxu_pr=
iv *priv)
>         }
>
>         if (!count) {
> -               dev_warn(&priv->udev->dev, "%s: Disabling MAC timed out\n=
",
> -                        __func__);
> +               dev_warn(dev, "%s: Disabling MAC timed out\n", __func__);
>                 ret =3D -EBUSY;
>                 goto exit;
>         }
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/8723b.c b/drivers/net/=
wireless/realtek/rtl8xxxu/8723b.c
> index 24c6d8ae76ec..2edcb6f34867 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/8723b.c
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/8723b.c
> @@ -1216,6 +1216,7 @@ static void rtl8723bu_phy_iq_calibrate(struct rtl8x=
xxu_priv *priv)
>
>  static int rtl8723bu_active_to_emu(struct rtl8xxxu_priv *priv)
>  {
> +       struct device *dev =3D &priv->udev->dev;
>         u8 val8;
>         u16 val16;
>         u32 val32;
> @@ -1247,8 +1248,7 @@ static int rtl8723bu_active_to_emu(struct rtl8xxxu_=
priv *priv)
>         }
>
>         if (!count) {
> -               dev_warn(&priv->udev->dev, "%s: Disabling MAC timed out\n=
",
> -                        __func__);
> +               dev_warn(dev, "%s: Disabling MAC timed out\n", __func__);
>                 ret =3D -EBUSY;
>                 goto exit;
>         }
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/core.c b/drivers/net/w=
ireless/realtek/rtl8xxxu/core.c
> index bddbd0990de7..f36cfaa2442f 100644
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
> @@ -2200,8 +2201,7 @@ rtl8xxxu_init_mac(struct rtl8xxxu_priv *priv)
>
>                 ret =3D rtl8xxxu_write8(priv, reg, val);
>                 if (ret !=3D 1) {
> -                       dev_warn(&priv->udev->dev,
> -                                "Failed to initialize MAC "
> +                       dev_warn(dev, "Failed to initialize MAC "
>                                  "(reg: %04x, val %02x)\n", reg, val);
>                         return -EAGAIN;
>                 }
> @@ -2228,6 +2228,7 @@ rtl8xxxu_init_mac(struct rtl8xxxu_priv *priv)
>  int rtl8xxxu_init_phy_regs(struct rtl8xxxu_priv *priv,
>                            const struct rtl8xxxu_reg32val *array)
>  {
> +       struct device *dev =3D &priv->udev->dev;
>         int i, ret;
>         u16 reg;
>         u32 val;
> @@ -2241,8 +2242,7 @@ int rtl8xxxu_init_phy_regs(struct rtl8xxxu_priv *pr=
iv,
>
>                 ret =3D rtl8xxxu_write32(priv, reg, val);
>                 if (ret !=3D sizeof(val)) {
> -                       dev_warn(&priv->udev->dev,
> -                                "Failed to initialize PHY\n");
> +                       dev_warn(dev, "Failed to initialize PHY\n");
>                         return -EAGAIN;
>                 }
>                 udelay(1);
> @@ -2386,6 +2386,7 @@ static int rtl8xxxu_init_rf_regs(struct rtl8xxxu_pr=
iv *priv,
>                                  const struct rtl8xxxu_rfregval *array,
>                                  enum rtl8xxxu_rfpath path)
>  {
> +       struct device *dev =3D &priv->udev->dev;
>         int i, ret;
>         u8 reg;
>         u32 val;
> @@ -2420,8 +2421,7 @@ static int rtl8xxxu_init_rf_regs(struct rtl8xxxu_pr=
iv *priv,
>
>                 ret =3D rtl8xxxu_write_rfreg(priv, path, reg, val);
>                 if (ret) {
> -                       dev_warn(&priv->udev->dev,
> -                                "Failed to initialize RF\n");
> +                       dev_warn(dev, "Failed to initialize RF\n");
>                         return -EAGAIN;
>                 }
>                 udelay(1);
> @@ -2557,6 +2557,7 @@ int rtl8xxxu_init_llt_table(struct rtl8xxxu_priv *p=
riv)
>
>  int rtl8xxxu_auto_llt_table(struct rtl8xxxu_priv *priv)
>  {
> +       struct device *dev =3D &priv->udev->dev;
>         u32 val32;
>         int ret =3D 0;
>         int i;
> @@ -2574,7 +2575,7 @@ int rtl8xxxu_auto_llt_table(struct rtl8xxxu_priv *p=
riv)
>
>         if (!i) {
>                 ret =3D -EBUSY;
> -               dev_warn(&priv->udev->dev, "LLT table init failed\n");
> +               dev_warn(dev, "LLT table init failed\n");
>         }
>
>         return ret;
> @@ -3088,6 +3089,7 @@ void rtl8xxxu_mac_calibration(struct rtl8xxxu_priv =
*priv,
>
>  static int rtl8xxxu_iqk_path_a(struct rtl8xxxu_priv *priv)
>  {
> +       struct device *dev =3D &priv->udev->dev;
>         u32 reg_eac, reg_e94, reg_e9c, reg_ea4, val32;
>         int result =3D 0;
>
> @@ -3137,14 +3139,14 @@ static int rtl8xxxu_iqk_path_a(struct rtl8xxxu_pr=
iv *priv)
>             ((reg_eac & 0x03ff0000) !=3D 0x00360000))
>                 result |=3D 0x02;
>         else
> -               dev_warn(&priv->udev->dev, "%s: Path A RX IQK failed!\n",
> -                        __func__);
> +               dev_warn(dev, "%s: Path A RX IQK failed!\n", __func__);
>  out:
>         return result;
>  }
>
>  static int rtl8xxxu_iqk_path_b(struct rtl8xxxu_priv *priv)
>  {
> +       struct device *dev =3D &priv->udev->dev;
>         u32 reg_eac, reg_eb4, reg_ebc, reg_ec4, reg_ecc;
>         int result =3D 0;
>
> @@ -3173,7 +3175,7 @@ static int rtl8xxxu_iqk_path_b(struct rtl8xxxu_priv=
 *priv)
>             (((reg_ecc & 0x03ff0000) >> 16) !=3D 0x36))
>                 result |=3D 0x02;
>         else
> -               dev_warn(&priv->udev->dev, "%s: Path B RX IQK failed!\n",
> +               dev_warn(dev, "%s: Path B RX IQK failed!\n",
>                          __func__);
>  out:
>         return result;
> @@ -3637,6 +3639,7 @@ static void rtl8xxxu_set_ampdu_min_space(struct rtl=
8xxxu_priv *priv, u8 density)
>
>  int rtl8xxxu_active_to_lps(struct rtl8xxxu_priv *priv)
>  {
> +       struct device *dev =3D &priv->udev->dev;
>         u8 val8;
>         u8 val32;
>         int count, ret =3D 0;
> @@ -3654,8 +3657,7 @@ int rtl8xxxu_active_to_lps(struct rtl8xxxu_priv *pr=
iv)
>         }
>
>         if (!count) {
> -               dev_warn(&priv->udev->dev,
> -                        "%s: RX poll timed out (0x05f8)\n", __func__);
> +               dev_warn(dev, "%s: RX poll timed out (0x05f8)\n", __func_=
_);
>                 ret =3D -EBUSY;
>                 goto exit;
>         }
> @@ -5862,6 +5864,7 @@ static void rtl8xxxu_queue_rx_urb(struct rtl8xxxu_p=
riv *priv,
>  static void rtl8xxxu_rx_urb_work(struct work_struct *work)
>  {
>         struct rtl8xxxu_priv *priv;
> +       struct device *dev;
>         struct rtl8xxxu_rx_urb *rx_urb, *tmp;
>         struct list_head local;
>         struct sk_buff *skb;
> @@ -5869,6 +5872,7 @@ static void rtl8xxxu_rx_urb_work(struct work_struct=
 *work)
>         int ret;
>
>         priv =3D container_of(work, struct rtl8xxxu_priv, rx_urb_wq);
> +       dev =3D &priv->udev->dev;
>         INIT_LIST_HEAD(&local);
>
>         spin_lock_irqsave(&priv->rx_urb_lock, flags);
> @@ -5894,8 +5898,7 @@ static void rtl8xxxu_rx_urb_work(struct work_struct=
 *work)
>                         rtl8xxxu_queue_rx_urb(priv, rx_urb);
>                         break;
>                 default:
> -                       dev_warn(&priv->udev->dev,
> -                                "failed to requeue urb with error %i\n",=
 ret);
> +                       dev_warn(dev, "failed to requeue urb with error %=
i\n", ret);
>                         skb =3D (struct sk_buff *)rx_urb->urb.context;
>                         dev_kfree_skb(skb);
>                         usb_free_urb(&rx_urb->urb);
> --
> 2.43.0
>
