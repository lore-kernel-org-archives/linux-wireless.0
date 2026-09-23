Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7770F3B776F;
	Wed, 23 Sep 2026 08:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790152514; cv=none; b=fezvtChQstQ1G5MWtGQcoYlX3CJy9vNzovFJ8pNsD9PMKbdIxZTPVsA9s2ULkZYDQBqKUazTlmtZQhb7jZMpr61vDjEDhaJmYZ9zyyfpyXSwsQrRi9p7nNTT68oSEhkMR6F3K3KO28nIVOBy9xXacH0IC9y8Su0ASMRCmhRLvHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790152514; c=relaxed/simple;
	bh=KomC0RRIPzf4oWXD0y0rcfhZGcojCLF9pTG0YP6l0U8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=udh4oJBQ89UTEZ1MzZxIc5Y6hTjEji8cw3onFSCzlOXeFox8CPAI6JyO6Cm9ZMrcLX16jm7xnajDU4NymgEKKYwM7ou+qy3foVhyRryqezu4aW0AvmP8h8F4wSwRz9tQWx58JeYrTaXS+lyXQVs0Rnvs7hea0F5elCkxErJX4IA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=LI1EIoLX; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="LI1EIoLX"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68N8Yrz16161206, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790152493; bh=KomC0RRIPzf4oWXD0y0rcfhZGcojCLF9pTG0YP6l0U8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=LI1EIoLXptNlHm8xaBYADnXKRlPxeZif+woKHUb0X30BQfO+26qSkErXPvvwnOzf9
	 KRTMLxMljDZrZsh8ZqflvENObj1O4DQgloM6Bo3seaTpbDj+EscfaBqh/cUEPcwLJD
	 l6ykzULat25bdL6LLbMiHWIf6nGZmMRmiCwedBeEYr9pKQJM9AJpKjKmBIcERbCBbU
	 0Jf5NbnrF2Mw0wtKyqXmk37oymjYUsJ10hUEyc/inJp95ZGDKdNGi5+qbIBPpuNKMV
	 h+7mNmJ6pCUV48D33pb6YbV1oCPJ7YcPiRsj0cVHrUDR7dfny4wMlfBjtgeqoJTkA0
	 qP3St2LRN/xNg==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68N8Yrz16161206
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 23 Sep 2026 16:34:53 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 23 Sep 2026 16:34:52 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 23 Sep 2026 16:34:37 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Wed, 23 Sep 2026 16:34:37 +0800
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
Thread-Index: AQHdSeATpI0NUCgP0kmEYeuJr1vdNLbby2HQ//+FlwCAAIc+QA==
Date: Wed, 23 Sep 2026 08:34:37 +0000
Message-ID: <3ce6a66b25274fb0b58f259529359bfe@realtek.com>
References: <20260921154347.82317-1-luka.gejak@linux.dev>
 <20260921154347.82317-3-luka.gejak@linux.dev>
 <0a6ea4337e004faa97595b1b62d2cad9@realtek.com>
 <6c14fabffc6984a5e7cd91c9b7fe6e4caceeaf70@linux.dev>
In-Reply-To: <6c14fabffc6984a5e7cd91c9b7fe6e4caceeaf70@linux.dev>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

DQpMdWthIEdlamFrIDxsdWthLmdlamFrQGxpbnV4LmRldj4gd3JvdGU6DQo+ID4gTHVrYSBHZWph
ayA8bHVrYS5nZWpha0BsaW51eC5kZXY+IHdyb3RlOg0KPiA+ID4gICsvLyBTUERYLUxpY2Vuc2Ut
SWRlbnRpZmllcjogR1BMLTIuMCBPUiBCU0QtMy1DbGF1c2UNCj4gPiA+ICArLyoNCj4gPiA+ICAr
ICogQ29weXJpZ2h0KGMpIDIwMDctMjAxNyBSZWFsdGVrIENvcnBvcmF0aW9uDQo+ID4gPiAgKyAq
IENvcHlyaWdodChjKSBNaWNoYWVsIFN0cmF1YmUgPHN0cmF1YmUubGludXhAZ21haWwuY29tPg0K
PiA+ID4gICsgKiBDb3B5cmlnaHQoYykgMjAyNC0yMDI2IEx1a2EgR2VqYWsgPGx1a2EuZ2VqYWtA
bGludXguZGV2Pg0KPiA+ID4NCj4gPiBJJ20gbm90IHN1cmUgaWYgd2Ugc2hvdWxkIGNsYWltIGNv
cHlyaWdodCB5ZWFyIGJhY2sgdG8gMjAwNz8NCj4gDQo+IFdoYXQgd291bGQgeW91IHByZWZlciwg
anVzdCB0ZWxsIG1lIGFuZCBJIHdpbGwgY2hhbmdlIGl0Pw0KDQpZb3UgY2FuIHJlZmVyZW5jZSB3
aGF0IEJpdHRlcmJsdWUgZGlkIFsxXS4gSSBkb24ndCBoYXZlIG11Y2ggc3R1ZHkNCmFib3V0IHRo
ZSBjb3B5cmlnaHQuIA0KDQpbMV0gMWE3NTQ1Nzg0NjQyICgid2lmaTogcnR3ODg6IEFkZCBydHc4
ODE0YS57YyxofSIpDQoNCg0K
