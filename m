Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2A337E2E9;
	Mon, 27 Jul 2026 07:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785136347; cv=none; b=M5YCmjxt7O//bj54NXx1wsae/vUqlg1oHMSi6gsdXIYMe3OrEJslBjl/8uxNr3sjI12N/A/a0keI16ZcAQXg5T26vV70cAARCU5UZ62ZQRbysjvyIlg8011l8CLaqOENm9WnzR6lC4LDU1U4EG9t1iwCgnF59XqgKjc2OwHaFBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785136347; c=relaxed/simple;
	bh=cxIbtdP4uQ+KaLCv89kdNu54idZq63l5HRHM1fNVjh0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=r0a23LgzYnrdMX7V0ZYEwvGsPvX4Db7qMkr1sK6Fi1mG07ezu2wBMH+DXTwVC44J9SpvFZU0dOdg265rtc+lIar8fWcEemslmVZDHMAbjOxDZUs2BKN590EVaEgQCB/q+kaLZnzCEOUXI89cy8W7GMa5LAPIw2mxLy5zk+AUGqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=ojLAVcnE; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="ojLAVcnE"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66R7CC6u82922539, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1785136333; bh=ybfLMdu+Wvls+zjAq6G9kSjkD9K9E0w27SPXVKDoOgg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=ojLAVcnEmgx3ucTwTTU6GeAl5F1FZ00PnT++tB3tuv7cB/EIn7u11OYTaCp4wUu2N
	 sbs5uyuXWuiG9fyHtM5AkvsUY6ef3Iaa+T0h6QAPMOLIw2xZjWTtjM4ObF7GKJrusL
	 Hz+RkZNrpWVxIhsnYypJpeWHMbyj/j6SQ48sxHOeQ03frRWfZN8R94LgbJk7N2hsqb
	 rA7fXAVW7MCR8rxwGdZY8yH963RHz3CjlYpGbKM00XVn93Mfn61kyca4QLhfkCxq35
	 5XHzJbFWtU0FzFZaWISb9SaqNshT+XswKfY+1OquAxv0UoyW0ECqDlhgj7VcVoRO2P
	 w234wFGO30R0g==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66R7CC6u82922539
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 15:12:13 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 27 Jul 2026 15:12:11 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::e6fd:5a3f:8946:92c4%10]) with mapi id
 15.02.2562.017; Mon, 27 Jul 2026 15:12:11 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: "luka.gejak@linux.dev" <luka.gejak@linux.dev>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: RE: [PATCH v2 01/11] wifi: rtw88: add the RTL8723B chip type and SDIO
 helper
Thread-Topic: [PATCH v2 01/11] wifi: rtw88: add the RTL8723B chip type and
 SDIO helper
Thread-Index: AQHdHEb43bJAs6El90WByPxHzpdzD7aA9VHg
Date: Mon, 27 Jul 2026 07:12:11 +0000
Message-ID: <774407603bef4fd38290f6b5d4b4a26c@realtek.com>
References: <20260725150427.93887-1-luka.gejak@linux.dev>
 <20260725150427.93887-2-luka.gejak@linux.dev>
In-Reply-To: <20260725150427.93887-2-luka.gejak@linux.dev>
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

luka.gejak@linux.dev <luka.gejak@linux.dev> wrote:
> From: Luka Gejak <luka.gejak@linux.dev>
>=20
> The RTL8723B is a 802.11n combo chip whose SDIO variant, RTL8723BS, runs
> a Realtek vendor firmware that differs from the firmware used by the
> other rtw88 8723 family devices. Supporting it needs a number of small
> adjustments spread across the shared core, all of which have to be
> restricted to this one chip and bus combination.
>=20
> Add the chip type and a helper that tests for it, so the changes that
> follow can be gated without repeating the chip and bus comparison.
>=20
> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
> ---
>  drivers/net/wireless/realtek/rtw88/main.h | 7 +++++++
>  1 file changed, 7 insertions(+)
>=20
> diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wire=
less/realtek/rtw88/main.h
> index c6e981ba7986..8f86f7c12de5 100644
> --- a/drivers/net/wireless/realtek/rtw88/main.h
> +++ b/drivers/net/wireless/realtek/rtw88/main.h
> @@ -194,6 +194,7 @@ enum rtw_chip_type {
>         RTW_CHIP_TYPE_8723D,
>         RTW_CHIP_TYPE_8821C,
>         RTW_CHIP_TYPE_8703B,
> +       RTW_CHIP_TYPE_8723B,
>         RTW_CHIP_TYPE_8821A,
>         RTW_CHIP_TYPE_8812A,
>         RTW_CHIP_TYPE_8814A,
> @@ -2194,6 +2195,12 @@ static inline bool rtw_chip_has_tx_stbc(struct rtw=
_dev *rtwdev)
>         return rtwdev->chip->tx_stbc;
>  }
>=20
> +static inline bool rtw_is_8723bs(struct rtw_dev *rtwdev)

As RTL8723B generation is very different from other chips, you need to add
this to deliver different flow. I'd think if we need a set of ops to make
code clearer.=20

> +{
> +       return rtwdev->chip->id =3D=3D RTW_CHIP_TYPE_8723B &&
> +              rtwdev->hci.type =3D=3D RTW_HCI_TYPE_SDIO;
> +}
> +
>  static inline u8 rtw_acquire_macid(struct rtw_dev *rtwdev)
>  {
>         unsigned long mac_id;
> --
> 2.55.0

