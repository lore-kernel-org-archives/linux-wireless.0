Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DCAF2609DC;
	Mon, 27 Jul 2026 02:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785117896; cv=none; b=PB9yCbM23Ir+WMiaHEOjLs0cfKxR6I+sg+Z+epUzt/RPP/gcX6Wlbt6I9bimBVTafKXccyvAJ8jU21QJJyasVvF6DkkXEEHs/221pDI96A0ATLAs0vddbW7Yx6PRoRNga0MPKLqmVa6YUcxNHy/+oT0OIMr2eFgIdlPUtxmXZzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785117896; c=relaxed/simple;
	bh=qkuWlV4NNJoBjCtTZWfvXsRTJUPE9FjrQ/ixkf0B7kI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hAGnehzR/yuOZfuApwQ0BUaisd7hdTflJzQnmc64MPBDGg7lgDiSSw35h8pip+d+R/qcIXfmTbH2//LyVCS7xJ7qkOU20hSGtjOmNBCNniqV1gIyt21rK8bpgI3GYZwrxkxEsBZfX2+f88x7idxYWiZPW+s5bOVhcS1pnSRBWwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=bhUfTR/I; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="bhUfTR/I"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66R24pD622754143, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1785117891; bh=qkuWlV4NNJoBjCtTZWfvXsRTJUPE9FjrQ/ixkf0B7kI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=bhUfTR/IHoutEvgsLfu1ts+L2b1KPrcrjQR1VehKzFLXU1WfJOm4/J6v1OoRsDGj7
	 NpY92CeQ5mLwBtArHBncNRkU9KO9oA0e9GvGhXML1gCZ6xunkVW7V+ceIYqfIPEt3i
	 azv75yLmsFtR8bqKPr2HA6mHrVyxhrEhfu9pzlgQsroKIqFtdU2+larI/AmZ9rkFDs
	 7L3Ecp9bI+535LZH4y8oJjTW7ru4A1S6x51xa5IGSvRNXmvutOGY+5g73k8Z9QQ0TQ
	 nhbdY3ivnjdVDhRP3Slq88cqvpLhWmOKwrg02s0Z4EF/fV4fFjQ20frH6Yam8PilpR
	 3PYXuC6TSrupQ==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66R24pD622754143
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 10:04:51 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 27 Jul 2026 10:04:51 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 27 Jul 2026 10:04:51 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::e6fd:5a3f:8946:92c4%10]) with mapi id
 15.02.2562.017; Mon, 27 Jul 2026 10:04:51 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH rtw-next v2 1/2] wifi: rtlwifi: rtl8821ae: remove
 conditional return with no effect
Thread-Topic: [PATCH rtw-next v2 1/2] wifi: rtlwifi: rtl8821ae: remove
 conditional return with no effect
Thread-Index: AQHdHQRccTWbR+yjzUO4+qCV+SikebaAnn5g
Date: Mon, 27 Jul 2026 02:04:51 +0000
Message-ID: <a46d352db44243d0a18e2312d614cde1@realtek.com>
References: <20260726134034.1385834-1-ekffu200098@gmail.com>
 <20260726134034.1385834-2-ekffu200098@gmail.com>
In-Reply-To: <20260726134034.1385834-2-ekffu200098@gmail.com>
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

Sang-Heon Jeon <ekffu200098@gmail.com> wrote:
> Both branches of the check return the same value, so the check has
> no effect. Remove it and return the value directly.
>=20
> This is the result of running the Coccinelle script from
> scripts/coccinelle/misc/cond_return_no_effect.cocci.
>=20
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>

