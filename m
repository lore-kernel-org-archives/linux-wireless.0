Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E09621FF30;
	Thu, 23 Jul 2026 00:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784767086; cv=none; b=bmBsq1cqJxtHVTYRyGa6GCTwmSOT3ywB5SoG8RXuW73W/DcNjHm5siCFy7ohNVMjetsXEq/c2oyZ21SbAfsOZMiGdMosuT4xcZOTPWxvNXTjZa2ugPeLVn8NPmUyZp7lgjVurYYnf+NYrDnpP7B9fexIbFoogdamoFpU1lwFJn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784767086; c=relaxed/simple;
	bh=bcyBS2aaQcQfFmCj89mjAa4ld+wq0FH3UzX4j/14olY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MqUM/G+xM0uMQUh7HtRG34yb4cZ+d3yGmmVvJnzpR2rRQhKxjtTysnSwJTYOHehMBFkV9mpsglaTuqn0RZ1mG2SLzq1BtIvyUnU7NIXtSHbWPpbqExRoF6jXYvIWExuLiMKase6v6qoVjLrHt7E1X6Y1IbCFaiCzRnPU4FMhxu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=PS+QQi9Q; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="PS+QQi9Q"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66N0bxlJ7061667, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784767079; bh=7/hgvnyxrPX7HiLkhw0hexDzjVDg/Ub3p9h7F1I40eY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=PS+QQi9QBnWmdoweJKtKsncUQYrW4nOlULVKXbATO0iu9oPKfO7QuR32E6HCumblD
	 kZSECLg8njEJifvW0gQVXuDskFrZSMUi344UfBeugfLxan1bQwUCLBhPJ/0ayVga/Q
	 Ubz5nU/sYAElsz4oCfZOn/YHsd9OpPqoRc1ENPGGvgZ3tBEI+yeVzFSm+omSBpFgqG
	 X7vcAncfud7sc50Q94HdO8nZ2MQP/1sbCuUh60bO/EyFs3PSxMEyTb5WBZ4B5Y9FSF
	 4mVvHUJU3heYzQ5g7SJ9g/APcCxJ/vL/I7V2nce/5tVzCg4TVUYHfutp4hTZHas00j
	 4Y9WZvE2oWARg==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66N0bxlJ7061667
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 23 Jul 2026 08:37:59 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 23 Jul 2026 08:37:59 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::e6fd:5a3f:8946:92c4%10]) with mapi id
 15.02.2562.017; Thu, 23 Jul 2026 08:37:59 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Abdun Nihaal <nihaal@cse.iitm.ac.in>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] wifi: rtlwifi: pci: fix error path in rtl_pci_probe()
Thread-Topic: [PATCH] wifi: rtlwifi: pci: fix error path in rtl_pci_probe()
Thread-Index: AQHdGdCaJnjzDQlNhEaziF2HHa+gP7Z6QU2Q
Date: Thu, 23 Jul 2026 00:37:59 +0000
Message-ID: <7fcf4f31fbcc48348496e564174ada91@realtek.com>
References: <20260722115217.131458-1-nihaal@cse.iitm.ac.in>
In-Reply-To: <20260722115217.131458-1-nihaal@cse.iitm.ac.in>
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

Abdun Nihaal <nihaal@cse.iitm.ac.in> wrote:
> In the last error path in rtl_pci_probe(), the cleanup functions are
> skipped due to a wrong goto label. Moreover, the successful call to
> rtl_init_rfkill() and ieee80211_register_hw() have to be reverted.
> Fix this issue by updating the labels and adding the relevant cleanup
> functions to the last error path.
>=20
> Fixes: 0c8173385e54 ("rtl8192ce: Add new driver")
> Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
> ---
> Compile tested only. Issue found using static analysis.
>=20
>  drivers/net/wireless/realtek/rtlwifi/pci.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c
> b/drivers/net/wireless/realtek/rtlwifi/pci.c
> index 73018a0498b4..98365176a901 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/pci.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
> @@ -2227,13 +2227,16 @@ int rtl_pci_probe(struct pci_dev *pdev,
>                 rtl_dbg(rtlpriv, COMP_INIT, DBG_DMESG,
>                         "%s: failed to register IRQ handler\n",
>                         wiphy_name(hw->wiphy));
> -               goto fail3;
> +               goto fail6;
>         }
>         rtlpci->irq_alloc =3D 1;
>=20
>         set_bit(RTL_STATUS_INTERFACE_START, &rtlpriv->status);
>         return 0;
>=20
> +fail6:
> +       rtl_deinit_rfkill(hw);

rtl_debug_remove_one(hw) ?

> +       ieee80211_unregister_hw(hw);
>  fail5:
>         rtl_pci_deinit(hw);
>  fail4:
> --
> 2.43.0

