Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E7AC40D568;
	Mon, 29 Jun 2026 02:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782698502; cv=none; b=XcTO9sa3SuXWbrRqTLxEoBeQzolpzNgqfEzBJLlJTXLjvflYNHuTu2oSTIRbrFHI+DPtZk82aRBBzQ/lusG3pPUAokT5mdxoM9rwKzvs+86kucVYU/1hPOgALlZvrQw9dxYUUPGB3CtvFjXEP4Gb7kVihyf445L11oztXcZ07o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782698502; c=relaxed/simple;
	bh=AkkTQtyLRV097Sms5de69DLZID2tlhNlWXMdF+M4o9E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=J0dWQFZ2heuTV1pOq2+HjKBjOay1w8fJxHdhjBi8suJiVUJN3rrZKmpkhjo4K6URurC1qIXEgI2CUiYRul0OK31el8vu2iJprQkpS0YQtHZ4XrtMS50uskyn90I3biReH5YEv585bmWDkffrkrIKsKwN8YTZlrXqhslTeI41WR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=aOXr044e; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="aOXr044e"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 65T21be563310360, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1782698497; bh=9b13Tp4GggjSaqurMEtCAd0qWj54OWNCOoCrY+wmap0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=aOXr044eUjNuYbILSIxfOukoC/DF7i08KVIYvCfubmPnpH6E3i2PwMrwNeCVo0l1O
	 ivTJNUZmOuSPQzWbna+0/tHL1sUBg1s3A/G5uUmRFmmKfAJvq+ZDCGpgTw71ngoOeo
	 rNhLdqL/ZzF2AP553I+ZhH0lNHCf8ZzJ/p5pb7ZKQsVZ44x0z4txod6JYbzoe5D4WL
	 HN+SoI8K6JMzDryCfTjG7Yd2LgxNoWcCzrwl1uT+FukiJ7kvLzR4oCQ3PKbGvjGNSm
	 qDGBN1+C5Ai+1UgKfJkG7txu9hxUJbUUC3CVcDwXtr4Eh7v8gfr7qyuQB1/12e0dHn
	 xnmnbMkTXrxAg==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 65T21be563310360
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 29 Jun 2026 10:01:37 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 29 Jun 2026 10:01:36 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 29 Jun 2026 10:01:36 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::e6fd:5a3f:8946:92c4%10]) with mapi id
 15.02.2562.017; Mon, 29 Jun 2026 10:01:36 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: William Hansen-Baird <william.hansen.baird@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH rtw-next v3 2/3] wifi: rtlwifi: convert pci if-statement
 to ID table
Thread-Topic: [PATCH rtw-next v3 2/3] wifi: rtlwifi: convert pci if-statement
 to ID table
Thread-Index: AQHdBVIkcZkQT/mQz0GSNcfIj7+lj7ZUy39w
Date: Mon, 29 Jun 2026 02:01:36 +0000
Message-ID: <a7d55ea808d54d98ab5be41d53f41a65@realtek.com>
References: <20260626095648.1124924-1-william.hansen.baird@gmail.com>
 <20260626095648.1124924-3-william.hansen.baird@gmail.com>
In-Reply-To: <20260626095648.1124924-3-william.hansen.baird@gmail.com>
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

Acked-by: Ping-Ke Shih <pkshih@realtek.com>


> ---
>  drivers/net/wireless/realtek/rtlwifi/pci.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c
> b/drivers/net/wireless/realtek/rtlwifi/pci.c
> index 38eca8d91581..44121203671c 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/pci.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
> @@ -31,6 +31,12 @@ static const u8 ac_to_hwq[] =3D {
>         BK_QUEUE
>  };
>=20
> +static const struct pci_device_id rtl_aspm_quirks[] =3D {
> +       /* ASUSTek F441U/X555UQ */
> +       { PCI_DEVICE_SUB(PCI_VENDOR_ID_REALTEK, 0xb723, 0x11ad, 0x1723) }=
,
> +       { }

nit: we can just '{}' (without a space).

> +};
> +
>  static u8 _rtl_mac_to_hwqueue(struct ieee80211_hw *hw, struct sk_buff *s=
kb)
>  {
>         struct rtl_hal *rtlhal =3D rtl_hal(rtl_priv(hw));

