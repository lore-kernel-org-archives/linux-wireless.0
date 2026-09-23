Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4504562BB;
	Wed, 23 Sep 2026 07:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790149860; cv=none; b=EKaO7KSFhPuscp/81u3YUcuK6oYQw9zR7Lp2JaRdlB1uhtYkT3YO4IOEHcrCjBts7WxRS41vMw9VHqBxpTyPBQmBknU36ZKB0lY16Mby9/mKFUPHw98SSPAQuCq9CYFxvXoqMLMjvQBPPmpQ4E9LNm2SZDG67+ZQXaF75vdYsnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790149860; c=relaxed/simple;
	bh=Ec5v5NaaRW5K3ptykL0Fh6ijvJIq0SpB7Y+NUY5XMaE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NmDH0QwIBUe83dhBJ+rJQr4NElebCaWhdMYONk8WrgNVARXB3uUgfKoIz3napAFG56pg4qTkbXKQRJP2wGvihIGHnD2HgOTvXNdPbDeZ30kbPHyHz0JhKfE5QidY47lyLEd9r7qQ8kHWS109WBfODt0ROZUAhJiH9Q9wNPq3P0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=vQiMkndh; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="vQiMkndh"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68N7okXR3144777, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790149846; bh=1SvcaZZzNQwcBflCyJ29C45gmpZKYnrv8J+pt5vqubw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=vQiMkndhUzmHB49/EapVAyjn7S9i91KypE5pk+k6viYIxCRSBBPpRSrSEvswQWnZz
	 7wYB2QIGqsH6wLiNfYoYFA2poKW5tUTgWJVaqnBbgACYOb/eztoY1Pho8GH7L9oqGj
	 zgkdRVCSg9K929NadLP23VH/xRFDDM0GuIQYyEsf90STW7Z6Z2ODscMgQ2QUgMJ+LQ
	 azza/TBhsN5ExgHlS9DCAP9qhLu1wkWjdehtzzqiQhI0fnYvb6O+Cbl5PpbhcxcAP9
	 UjY1NBjjDK1BpZ/FjVtUZqIHZjIetByZkRqVPnS7MhHmsbV9x+UOy8ExroAmK+bF7K
	 k2lOwdDnh6Iig==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68N7okXR3144777
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 23 Sep 2026 15:50:46 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 23 Sep 2026 15:50:44 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Wed, 23 Sep 2026 15:50:44 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Luka Gejak <luka.gejak@linux.dev>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: RE: [PATCH v3 2/6] wifi: rtw88: 8723b: add the RTL8723B BB, RF and
 AGC tables
Thread-Topic: [PATCH v3 2/6] wifi: rtw88: 8723b: add the RTL8723B BB, RF and
 AGC tables
Thread-Index: AQHdSeATpI0NUCgP0kmEYeuJr1vdNLbby2HQ
Date: Wed, 23 Sep 2026 07:50:44 +0000
Message-ID: <0a6ea4337e004faa97595b1b62d2cad9@realtek.com>
References: <20260921154347.82317-1-luka.gejak@linux.dev>
 <20260921154347.82317-3-luka.gejak@linux.dev>
In-Reply-To: <20260921154347.82317-3-luka.gejak@linux.dev>
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

Luka Gejak <luka.gejak@linux.dev> wrote:
> Add the baseband, RF and AGC parameter tables for the RTL8723B, and the
> transmit power limit and power by rate tables, in the layout the shared
> rtw88 phy code expects.
>=20
> These are split out from the chip driver so the driver patch that
> follows is easier to read. Nothing references them yet.
>=20
> The RTL8723B chip support is based on the initial work by
> Michael Straube <straube.linux@gmail.com>.
> Link: https://github.com/mistraube/rtw88/tree/rtl8723bs
>=20
> Co-developed-by: Michael Straube <straube.linux@gmail.com>
> Signed-off-by: Michael Straube <straube.linux@gmail.com>
> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
> ---
>  .../wireless/realtek/rtw88/rtw8723b_table.c   | 862 ++++++++++++++++++
>  .../wireless/realtek/rtw88/rtw8723b_table.h   |  18 +
>  2 files changed, 880 insertions(+)
>  create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723b_table.c
>  create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723b_table.h
>=20
> diff --git a/drivers/net/wireless/realtek/rtw88/rtw8723b_table.c
> b/drivers/net/wireless/realtek/rtw88/rtw8723b_table.c
> new file mode 100644
> index 000000000000..49989da3b8aa
> --- /dev/null
> +++ b/drivers/net/wireless/realtek/rtw88/rtw8723b_table.c
> @@ -0,0 +1,862 @@
> +// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
> +/*
> + * Copyright(c) 2007-2017  Realtek Corporation
> + * Copyright(c) Michael Straube <straube.linux@gmail.com>
> + * Copyright(c) 2024-2026 Luka Gejak <luka.gejak@linux.dev>

I'm not sure if we should claim copyright year back to 2007?

[...]

> diff --git a/drivers/net/wireless/realtek/rtw88/rtw8723b_table.h
> b/drivers/net/wireless/realtek/rtw88/rtw8723b_table.h
> new file mode 100644
> index 000000000000..49291fd1dd9d
> --- /dev/null
> +++ b/drivers/net/wireless/realtek/rtw88/rtw8723b_table.h
> @@ -0,0 +1,18 @@
> +/* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
> +/*
> + * Copyright(c) 2007-2017  Realtek Corporation
> + * Copyright(c) Michael Straube <straube.linux@gmail.com>
> + * Copyright(c) 2024-2026 Luka Gejak <luka.gejak@linux.dev>

ditto.


