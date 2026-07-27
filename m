Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9AC3175A94;
	Mon, 27 Jul 2026 07:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785137843; cv=none; b=plbwyffTQIvmJ7m9pGcC0f+F6S7jccZXOcRvmeFKF4Q+jxg7XUCpUpmWRSdql2ZxBKTOb+C3RzbPQ7KzG39j7DLLB0rBg0DMQOJDu0IjGWCU0BhMO0lpGkUTl8OYb/CxEfGWZ5d7ve7P5EEYhgjjI2j1SYoMaKRqSyl68Lkmlyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785137843; c=relaxed/simple;
	bh=Dlvc7a0BWI84OlH1ml8ExRpkcTbVawiwBjkQqZEgPXQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HRzh1HAJ8xrsZ4QLruHwgqljK3pFn74NdnmMr7HkeaytLMc2P98rXjW8+q5KuEOTJETgq3T8pSrR4jPxCGuGSoVOqeNXePw12XIeAXtcyOZeQZosUJ0+IqrVgI0AbK1za4b3VYpUdYtknefqYtpDH9VuVXvwZpgCnwlwD/9FY50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=iCY0hWbL; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="iCY0hWbL"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66R7bAwsD2930889, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1785137830; bh=7qDp2V5bXBkkMNFxa9OUKROo4Iq+q7lUQAMwhy+XPK4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=iCY0hWbLGSIHqL+wRiFrG03CkDg6x81p4hfS7qIZh+BcusRiFx7tI+CuPjFEGwVeF
	 Fqbltah4QzToKS8uVIRLfOKSRfUSATj+sqnL6oBZTimdsKmOUKrxRc2JUDMi7OpEme
	 m20kUPOgm+GQvFJLU1+BLT5tzdr6oUDVlJDV5+8DpfKkXAZZMUfLTe5VIKnmJFt6a/
	 uuynGH96ARnqYOt0gxFwSleO9maFrIP5e4cRc+3E2YbU5loSqtVRAI7ObGnD8wZE3/
	 mxs/X2i0BiSI8aqzH5BhSrvaMMnc0rNKH02aNo2penK7amkfeAT7zRAZqXa5eSJIuu
	 0koHfZ95GRFgw==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66R7bAwsD2930889
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 15:37:10 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 27 Jul 2026 15:37:10 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::e6fd:5a3f:8946:92c4%10]) with mapi id
 15.02.2562.017; Mon, 27 Jul 2026 15:37:10 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: "luka.gejak@linux.dev" <luka.gejak@linux.dev>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: RE: [PATCH v2 04/11] wifi: rtw88: fw: fix the reserved page upload on
 RTL8723BS
Thread-Topic: [PATCH v2 04/11] wifi: rtw88: fw: fix the reserved page upload
 on RTL8723BS
Thread-Index: AQHdHEb4g47EmczZqkKghtqj2fzBgLaA+60g
Date: Mon, 27 Jul 2026 07:37:10 +0000
Message-ID: <1415f8a22c99437f8137304690edbcb3@realtek.com>
References: <20260725150427.93887-1-luka.gejak@linux.dev>
 <20260725150427.93887-5-luka.gejak@linux.dev>
In-Reply-To: <20260725150427.93887-5-luka.gejak@linux.dev>
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

[...]

> diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wirele=
ss/realtek/rtw88/fw.c
> index dd6595b8175e..7c17086cac32 100644
> --- a/drivers/net/wireless/realtek/rtw88/fw.c
> +++ b/drivers/net/wireless/realtek/rtw88/fw.c
> @@ -1477,10 +1477,14 @@ void rtw_add_rsvd_page_sta(struct rtw_dev *rtwdev=
,
>         rtw_add_rsvd_page(rtwdev, rtwvif, RSVD_LPS_PG_INFO, true);
>  }
>=20
> +/* REG_DWBCN1_CTRL bit 20 (SW_BCN_SEL for port 0), relative to byte +2 *=
/
> +#define BIT_OFFSET_DWBCN1_SW_BCN_SEL_PORT0     (20 - 16)

define along its register REG_DWBCN1_CTRL

> +
>  int rtw_fw_write_data_rsvd_page(struct rtw_dev *rtwdev, u16 pg_addr,
>                                 u8 *buf, u32 size)
>  {
> -       u8 bckp[3];
> +       const bool is_8723bs_sdio =3D rtw_is_8723bs(rtwdev);
> +       u8 bckp[4];
>         u8 val;
>         u16 rsvd_pg_head;
>         u32 bcn_valid_addr;
> @@ -1510,13 +1514,28 @@ int rtw_fw_write_data_rsvd_page(struct rtw_dev *r=
twdev, u16 pg_addr,
>         rtw_write8(rtwdev, REG_BCN_CTRL,
>                    (bckp[2] & ~BIT_EN_BCN_FUNCTION) | BIT_DIS_TSF_UDT);
>=20
> -       if (rtw_hci_type(rtwdev) =3D=3D RTW_HCI_TYPE_PCIE) {
> +       /* Clear BIT_EN_BCNQ_DL so the chip does not treat the reserved-p=
age
> +        * upload as a real beacon; otherwise BIT_BCN_VALID never asserts=
. The
> +        * vendor rtl8723bs driver does this unconditionally; rtw88 only =
did it
> +        * for PCIe, which left 8723BS SDIO's BCN_VALID handshake failing=
.
> +        */
> +       if (rtw_hci_type(rtwdev) =3D=3D RTW_HCI_TYPE_PCIE || is_8723bs_sd=
io) {
>                 val =3D rtw_read8(rtwdev, REG_FWHW_TXQ_CTRL + 2);
>                 bckp[1] =3D val;
>                 val &=3D ~(BIT_EN_BCNQ_DL >> 16);
>                 rtw_write8(rtwdev, REG_FWHW_TXQ_CTRL + 2, val);
>         }
>=20
> +       /* 8723BS SDIO: point the SW beacon download path at port 0, else
> +        * BIT_BCN_VALID is never asserted after the SDIO upload complete=
s.
> +        */

Currently, not use networking specific comment style anymore

   /*
    * first line
    * second
    */

> +       if (is_8723bs_sdio) {
> +               val =3D rtw_read8(rtwdev, REG_DWBCN1_CTRL + 2);
> +               bckp[3] =3D val;
> +               val &=3D ~BIT(BIT_OFFSET_DWBCN1_SW_BCN_SEL_PORT0);

define along its register REG_DWBCN1_CTRL. Then, here

 val &=3D ~(BIT_DWBCN1_SW_BCN_SEL_PORT0 >> 16);


> +               rtw_write8(rtwdev, REG_DWBCN1_CTRL + 2, val);
> +       }
> +
>         ret =3D rtw_hci_write_data_rsvd_page(rtwdev, buf, size);
>         if (ret) {
>                 rtw_err(rtwdev, "failed to write data to rsvd page\n");


