Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 542A42BE043;
	Mon,  5 Oct 2026 03:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791171692; cv=none; b=aQsEUWilZ+M3fFtIXkpi9M80go85QIJYRDmfrA7srj/0req5gufBaMG1gWiW2HgcItBfAM7JZr6n4mfSI9bfHRNy4aZ3OPlr3PQ6uZhyfJ8vlUCVrkBKY7RD4ij3ReAEX5YsCeVZByfPPSn/BSGLyv3eYI/hc86Z34Gwl5RGTWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791171692; c=relaxed/simple;
	bh=IJh/ofbxCY10RlRYjfqH2PVRLDvlVC+iScxeXJMMXMc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nRbdzMfTE2kVUP2pF31vwqkYvV82THW9R0iZZRwlCI7y0xiBatf04ubrIyzGt66tbIJPLxfIuBIi/XGEb335/Btf96rPgi9Jukli8H5fgTP41XqGRrrW9jm0olsX6ubYoFSKlcSSQ58mqvmnapIE7QZUzFfx3myBP//ymNGM9pY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=Cm9f5AEO; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="Cm9f5AEO"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6953f5qqD1632714, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791171666; bh=c5Xt0XMyRVXVrkgn7Ii43fPzkHCoAHvIW0OjsO2zIBg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=Cm9f5AEOkYOLF1TboA5T9zrj5J3GVT2jAerF5p1MlA8xvxgefJdj1enfc0TPgPHZK
	 ++Qk3g72ohBQGrIN6X/0StYmPwzt4sWf62E0ciwwHVg83277SbJ5+1ZiTHf7Hat9J+
	 GAtwyNdDxUozt44l25HNitANx4RvJHulKcoM3soSX7QZnu9q5KceJ8apQ5SPTrNjFs
	 cyrP+z/RtLFc26fbUr4Jbvd1Yy6J+bvlm8cQCWFnq0hkaBWCa9luKB+c1vBFqce/o3
	 y7IGrf0tdLuxtYpdjNwNeArbra8CAlXeMUNoNAEWNBx/ffkxSbi+nS5+T+6dfzLZXc
	 ylB20Sa7Gav/A==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6953f5qqD1632714
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 5 Oct 2026 11:41:05 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 5 Oct 2026 11:41:02 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 5 Oct 2026 11:41:02 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Mon, 5 Oct 2026 11:41:02 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Alastair D'Silva <alastair@d-silva.org>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>
CC: Martin Blumenstingl <martin.blumenstingl@googlemail.com>, Ulf Hansson
	<ulfh@kernel.org>, Jernej Skrabec <jernej.skrabec@gmail.com>, Kalle Valo
	<kvalo@kernel.org>, Luka Gejak <luka.gejak@linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 2/2] wifi: rtw88: sdio: Split rtw_sdio_rx_isr into 8051
 and 3081 variants
Thread-Topic: [PATCH v3 2/2] wifi: rtw88: sdio: Split rtw_sdio_rx_isr into
 8051 and 3081 variants
Thread-Index: AQHdUTiKKWkXA8JaR02in+sl4VQ6RbbuU0Lw
Date: Mon, 5 Oct 2026 03:41:02 +0000
Message-ID: <21f8844f6131464e8e4c59b99055a6c1@realtek.com>
References: <20261001000303.3505264-1-alastair@d-silva.org>
 <20261001000303.3505264-3-alastair@d-silva.org>
In-Reply-To: <20261001000303.3505264-3-alastair@d-silva.org>
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

Alastair D'Silva <alastair@d-silva.org> wrote:
> Following the split of rtw_sdio_handle_interrupt(), the receive FIFO drai=
n
> loop in rtw_sdio_rx_isr() still contained a growing number of special
> cases between 8051 and 3081 chips, evaluated twice per packet in the RX
> hot path:
>=20
> 1. Register width: 8051 uses a 16-bit read of REG_SDIO_RX0_REQ_LEN,
>    while 3081 uses a 32-bit read.
> 2. Loop termination: 8051 must re-read REG_SDIO_HISR on each iteration
>    because the RX buffer may contain data while HW or FW is still filling
>    it. Conversely, 3081 has improved HW/FW that can use rx_len
>    unconditionally, previously requiring a synthetic assignment of
>    hisr =3D REG_SDIO_HISR_RX_REQUEST to trick the loop condition into
>    continuing.
>=20
> To avoid accumulating further special cases and eliminate per-packet
> branching in the RX hot path, split rtw_sdio_rx_isr() into separate
> rtw_sdio_rx_isr_8051() and rtw_sdio_rx_isr_3081() functions.
>=20
> This removes the artificial hisr assignment on 3081 and keeps the RX
> processing logic cleanly separated by architecture.

It looks like you didn't change logic at all, just split into two=20
variants. If so, please mention this in commit message.=20

And, please reduce your commit message. For me, just mention that you
split rtw_sdio_rx_isr() into two variants to be clear, and the two
points are register size and hsir behavior. (as well as first patch;=20
LLM always give too much stuffs)

>=20
> Assisted-by: LLM
> Signed-off-by: Alastair D'Silva <alastair@d-silva.org>


