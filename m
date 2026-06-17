Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 896E838A71E;
	Wed, 17 Jun 2026 08:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781684586; cv=none; b=aXnheIJ5bFeMQ/f2fNLM9bUSixMED5DtRz/eLxDkB9qIfdk0S4Ckx+SFiWBbMeHo5+0WWnuIJbLmMFfLhDtdOmx5RkhXXax8ILEbORfJQMInZ51n6SzNRDfylPil/agY5wkXpKeLdem65xk6LlDiNbXQd8cLFhHtVeP7boUVT6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781684586; c=relaxed/simple;
	bh=tKOFrbXG5tGepQdHI5N6gsYX8IqD16sw0hyajSyynn4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=S/RaRYvz+R6U4HjlmQsCOw8JUfADLgJ9+osb08R0rPvXFkcV6EWhsCdrP1TuL7dMZNw/d7n6vj2UqHHoJ7GIiYqUojjCTGSFLSIbXCCmKP2PmpJBkfvONVhLr5KdDoi3qDsWnAhrn69I429UjcL5lzIsQEiGRGJaGJwRQiGiJiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=Xdpl1+WB; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="Xdpl1+WB"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 65H8MwRC22575580, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1781684578; bh=nQd6QJg86tFJ+b5Wd/ykEZ1kfNhGKKdtw8S/blKST4Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=Xdpl1+WBhEzibt5+yNHyS3QRl11oniQzGeAnEZqsw+zwHhyD32P3lFqqa3Isd3zr6
	 YgMhiCNet1spz4T5K4+7BSvZtU4/Gsb6DeF8iJb1cX5RYIqBW5loExqgpYaE+ehkAJ
	 4IzpH5hF8dZtM6NUtIer1jxShYzOiB1EeIZlyHV4vKc9CV19f6TXDGW6R8mNf632qV
	 uq4nV2pEzaPv4N1wEVmls4/U0dlmK3SjfbdcfkKk1F9ssriBKYuv3u7alBdycf22NQ
	 iT7PDuMZieuJ0NtxCtgyGApM2lEBMT2ZoOwpOTN5oUGIs+Bv2f7+ZdLTBH0wjDSgPg
	 jN3Oqa2pt9EpQ==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 65H8MwRC22575580
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 17 Jun 2026 16:22:58 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 17 Jun 2026 16:22:58 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::e6fd:5a3f:8946:92c4%10]) with mapi id
 15.02.2562.017; Wed, 17 Jun 2026 16:22:58 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: William Hansen-Baird <william.hansen.baird@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH rtw-next v2 2/3] wifi: rtlwifi: convert pci if-statement
 to ID table
Thread-Topic: [PATCH rtw-next v2 2/3] wifi: rtlwifi: convert pci if-statement
 to ID table
Thread-Index: AQHc/ZrK3uV6y6HQeUWq5f1dBt6h07ZCaKFQ
Date: Wed, 17 Jun 2026 08:22:57 +0000
Message-ID: <e383445f6fc54f4dbe374ec364269d42@realtek.com>
References: <20260614135508.70307-1-william.hansen.baird@gmail.com>
 <20260616141620.91081-1-william.hansen.baird@gmail.com>
 <20260616141620.91081-3-william.hansen.baird@gmail.com>
In-Reply-To: <20260616141620.91081-3-william.hansen.baird@gmail.com>
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

William Hansen-Baird <william.hansen.baird@gmail.com> wrote:
> Refactor the ASUSTek quirk logic from an if-statement to a standard
> rtl_aspm_quirks pci_device_id table. This allows future devices with
> the same quirk to be added more easily while avoiding a large if-chain.
>=20
> Signed-off-by: William Hansen-Baird <william.hansen.baird@gmail.com>
> ---
>  drivers/net/wireless/realtek/rtlwifi/pci.c | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c
> b/drivers/net/wireless/realtek/rtlwifi/pci.c
> index a5bab06f2b61..9de396879806 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/pci.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
> @@ -31,6 +31,11 @@ static const u8 ac_to_hwq[] =3D {
>         BK_QUEUE
>  };
>=20
> +static const struct pci_device_id rtl_aspm_quirks[] =3D {
> +       { PCI_DEVICE_SUB(PCI_VENDOR_ID_REALTEK, 0xb723, 0x11ad, 0x1723) }=
,

Would you leave a comment ASUSTek F441U/X555UQ?

> +       { 0 }

Just "{}"

> +};
> +
>  static u8 _rtl_mac_to_hwqueue(struct ieee80211_hw *hw, struct sk_buff *s=
kb)
>  {
>         struct rtl_hal *rtlhal =3D rtl_hal(rtl_priv(hw));
> @@ -328,21 +333,17 @@ static void rtl_pci_parse_configuration(struct pci_=
dev *pdev,
>=20
>  static void rtl_pci_init_aspm(struct ieee80211_hw *hw)
>  {
> -       struct rtl_priv *rtlpriv =3D rtl_priv(hw);
>         struct rtl_ps_ctl *ppsc =3D rtl_psc(rtl_priv(hw));
>         struct rtl_pci *rtlpci =3D rtl_pcidev(rtl_pcipriv(hw));
>=20
>         _rtl_pci_update_default_setting(hw);
>=20
> -       /* RTL8723BE found on some ASUSTek laptops, such as F441U and
> -        * X555UQ with subsystem ID 11ad:1723 are known to output large
> +       /* Certain pci devices are known to output large

Now we don't use net specific comment. Use below style:

/*
 * (first line)
 */

(we should apply this style to patch 1/3 as well)

>          * amounts of PCIe AER errors during and after boot up, causing
>          * heavy lags, poor network throughput, and occasional lock-ups.
>          */
> -       if (rtlpriv->rtlhal.hw_type =3D=3D HARDWARE_TYPE_RTL8723BE &&
> -           (rtlpci->pdev->subsystem_vendor =3D=3D 0x11ad &&
> -            rtlpci->pdev->subsystem_device =3D=3D 0x1723)) {
> +       if (pci_match_id(rtl_aspm_quirks, rtlpci->pdev)) {
>                 __rtl_pci_disable_aspm(hw);
>                 ppsc->support_aspm =3D false;
>         }
>=20
> --
> 2.54.0

