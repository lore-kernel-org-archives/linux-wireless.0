Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2AB5422E08;
	Wed, 23 Sep 2026 09:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790154288; cv=none; b=Hxj2joueTiqZhMZuqevUY6pBV3tEocu+ojwLTJvg9xFuBAkJCo9xUDhP434dRfvNRXglguGWWJ1i/Qi4OVrEH96Nxza5vBbwX9+NJH0c/PwsDJ+RYmCp+mplwg7W5qDHgfUstiluqdJdJmQ/fYQHlPUrAlaxOJaxlwluThbUr5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790154288; c=relaxed/simple;
	bh=bQJjiXtTzOqoGmkBZP8ZCJLiWls36N6/2Iha1boc+jk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YrhXuhvYyg+qePihQeZCENIqlDjbnVcCuUegNrttbc184zzMsYju8YRHXpEt8qy7AS7vcYwM4UQTbuhnT+4V2zelpP3VHdTvmTI4sbyBHjecvvjWxAS1uD6trZE51I72kGEASGURiq6A2tJcNxnvq1VWvP9ifm5nUygv6aMJxEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=pahjhf7K; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="pahjhf7K"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68N94YJ90172052, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790154274; bh=jeyRsNDIR0xGSsUeZ5dqgd/NeTZVzhL1efROpfADM38=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=pahjhf7KAByC8RyCRPNfF8fH4tS4OtVjgJP+gnPBdp8e8vcXzblldRZpTR6ZkSmUL
	 ztfb8WDd/Q1EkD1BfLqyJrzjs7NgQQ5QIyaDOA2QkqAW1BvuCVZleqDzy03K/MhgWv
	 l8JbP2dpDn4eSu5SNXqndUi6ykS8V8d4atoZjOzzyfp+Ui9RDGXEd2rDnIGaa+9QLQ
	 uYqsamUMZNpQeSqQDvYH2+np6d3JaHBor1mdMxXPNaniOU48ZZNeUmT+p3/XvMx0Mo
	 mb1RTvG+kCBMZFhNZPWGvuNywPupVEeqo/V/jpkuUPHDN+2HSt0YUorpKE3RygFzqs
	 X7hlL4h/2GDfQ==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68N94YJ90172052
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 23 Sep 2026 17:04:34 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 23 Sep 2026 17:04:34 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 23 Sep 2026 17:04:34 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Wed, 23 Sep 2026 17:04:34 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Luka Gejak <luka.gejak@linux.dev>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: RE: [PATCH v3 4/6] wifi: rtw88: 8723bs: add the RTL8723BS SDIO bind
Thread-Topic: [PATCH v3 4/6] wifi: rtw88: 8723bs: add the RTL8723BS SDIO bind
Thread-Index: AQHdSeAYhR9eRhv8Qk+DJdy7EkB6b7bb4DfA
Date: Wed, 23 Sep 2026 09:04:34 +0000
Message-ID: <6f9643f8704c4745a508c0960be85fd4@realtek.com>
References: <20260921154347.82317-1-luka.gejak@linux.dev>
 <20260921154347.82317-5-luka.gejak@linux.dev>
In-Reply-To: <20260921154347.82317-5-luka.gejak@linux.dev>
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
> Add the SDIO module for the RTL8723BS, the SDIO variant of the
> RTL8723B. It binds the Realtek SDIO device ids to the shared rtw88 SDIO
> probe and points it at the RTL8723B chip information.
>=20
> The device id table carries the same six ids the staging rtl8723bs
> driver binds to this chip, so the staging driver can be dropped without
> losing hardware support. I only have the 0xb723 variant to test with;
> the other five are included for parity with staging, which has carried
> them for years, rather than being left behind.
>=20
> The driver is not built yet; the Kconfig and Makefile entries follow.

I think no need this. The Kconfig/Makefile is ready in the same patchset.

>=20
> The RTL8723B chip support is based on the initial work by
> Michael Straube <straube.linux@gmail.com>.
> Link: https://github.com/mistraube/rtw88/tree/rtl8723bs
>=20
> Co-developed-by: Michael Straube <straube.linux@gmail.com>
> Signed-off-by: Michael Straube <straube.linux@gmail.com>
> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
> ---
>  .../net/wireless/realtek/rtw88/rtw8723bs.c    | 67 +++++++++++++++++++
>  1 file changed, 67 insertions(+)
>  create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723bs.c
>=20
> diff --git a/drivers/net/wireless/realtek/rtw88/rtw8723bs.c
> b/drivers/net/wireless/realtek/rtw88/rtw8723bs.c
> new file mode 100644
> index 000000000000..f0c0fe6ee2b3
> --- /dev/null
> +++ b/drivers/net/wireless/realtek/rtw88/rtw8723bs.c
> @@ -0,0 +1,67 @@
> +// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
> +/*
> + * Copyright(c) 2007-2017  Realtek Corporation
> + * Copyright(c) Michael Straube <straube.linux@gmail.com>
> + * Copyright(c) 2024-2026 Luka Gejak <luka.gejak@linux.dev>
> + */
> +
> +#include <linux/mmc/sdio_func.h>
> +#include <linux/mmc/sdio_ids.h>
> +#include <linux/module.h>
> +#include "main.h"
> +#include "rtw8723b.h"
> +#include "sdio.h"
> +
> +static const struct sdio_device_id rtw_8723bs_id_table[] =3D {
> +       {
> +               SDIO_DEVICE(SDIO_VENDOR_ID_REALTEK,
> +                           SDIO_DEVICE_ID_REALTEK_RTW8723BS),
> +               .driver_data =3D (kernel_ulong_t)&rtw8723b_hw_spec,
> +       },
> +       /*
> +        * The remaining ids are the other RTL8723BS SDIO ids the staging
> +        * rtl8723bs driver binds to this chip. They have no
> +        * SDIO_DEVICE_ID_REALTEK_* names in <linux/mmc/sdio_ids.h> and a=
re
> +        * carried here for parity with staging; only 0xb723 above has be=
en
> +        * verified on hardware.
> +        */

I think no need this comment.=20

Just keep these IDs, or remove all of them you have not tested.=20

If you think this is important, add to commit message


