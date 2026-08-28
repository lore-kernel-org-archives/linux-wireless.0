Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31BB53BB685;
	Fri, 28 Aug 2026 08:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787905394; cv=none; b=obG1/BnqxBWGXjkrvlxivZxX529oi9RnJle+0sgdbyuOXnXZv4l0cDyc1Vjq4XxRn1El+PrN8qUOrMKxtjPP4GONk79gkueggGxkhq28N6uNf5WEb7Fn9U6mGAAoJR+QbhuPQr2RuYFD16SMrbH1KPcYKf9a7voyjAVcYPHlL4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787905394; c=relaxed/simple;
	bh=/R8jR4TwTBqFmgkU4V7oNv643YF9nBtoGzXKpwQtE5M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NSMLdjMZDcTBCOuDmoU2j1dKeX3NG5sah38OwpMxFJX0D6O38y4ylqtNlC+hWZOhFFWD9jOyquK+TjIkpViYC2DeXWX6/oOF/67mehZOr1rcSE7P+fg3maVzJH8kF2cYQKtcjJunRb4WamcU5bpWQcabt2ETsuzM7GEYxAHam3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=KFx+IDfR; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="KFx+IDfR"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67S8N7YB02279850, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1787905387; bh=/R8jR4TwTBqFmgkU4V7oNv643YF9nBtoGzXKpwQtE5M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=KFx+IDfR6/nShvPbUlYowLcpijZhNYYllTW4Bq58vHeLcZ2CNTRPZP6G/DE4FIGVh
	 ObZJYPKclGXqcoTow9KPoizy5zvGj23QZbRQb9KUBUkPitmo/IWlmrT7vA1fBkGu1L
	 TIwXCojYyPal/8J3qIZdv6kw9vJW07nMKkpKZ3pLa4jDDdUczM4ACrR5yvtgF9zDLT
	 NaxFowsKY38aaZtty5b1OopEn2Nsp8zIrqxCr4ttdwwRec4Phwt0K2dgHbYAkIu70q
	 9ztQgNGtlJVok1+kW29qK+l0vHq0dKpUJrgotA6KIw1bvywsGB8rzxG9ZvdWWTOY6/
	 FVA5VBj4nFqmw==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67S8N7YB02279850
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 28 Aug 2026 16:23:07 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 28 Aug 2026 16:23:03 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 28 Aug 2026 16:23:02 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Fri, 28 Aug 2026 16:23:02 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Arsenii Pashchenko <ulijg308@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH rtw-next v7 1/3] wifi: rtw88: rtw8822c: Use bitfield
 macros for DAC IQ sampling
Thread-Topic: [PATCH rtw-next v7 1/3] wifi: rtw88: rtw8822c: Use bitfield
 macros for DAC IQ sampling
Thread-Index: AQHdNq/AK/pkaxVLEEaXiqyhMxgArLazHzcA
Date: Fri, 28 Aug 2026 08:23:01 +0000
Message-ID: <d4ae3cda5aae435d97f5b5e3a27d446d@realtek.com>
References: <cover.1787895379.git.ulijg308@gmail.com>
 <e4c9ff204ce4d6901da97a83b11dce1bd42f6b21.1787895379.git.ulijg308@gmail.com>
In-Reply-To: <e4c9ff204ce4d6901da97a83b11dce1bd42f6b21.1787895379.git.ulijg308@gmail.com>
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

Arsenii Pashchenko <ulijg308@gmail.com> wrote:
> Define proper GENMASK constants for the In-phase (I) and Quadrature
> (Q) components of the DAC IQ data register in the header file.
> Replace manual bit shifting, masking, and rtw_read32_mask() with
> standard rtw_read32() and the FIELD_GET() macro to improve code
> readability.
>=20
> Signed-off-by: Arsenii Pashchenko <ulijg308@gmail.com>

I suppose you don't have change from v6 to v7, so just take
my acked-by?

Acked-by: Ping-Ke Shih <pkshih@realtek.com>




