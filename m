Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C17D3F105B;
	Wed, 23 Sep 2026 08:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790153989; cv=none; b=YojXlRe+xK00hfhASbY19/s0ak6Fm6WeGskq/F8lpK4A1crN7prIb7bIko0EeWJRWvEGE5zHHWfxy59FUsRiUH1X730dasFxkHGPE/gQc3/YV/ZodvXEhZCwk1WmziU8H1AWm8xhkp91iK0+7XZwKdtFRdZgwRF376ZpyliU5jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790153989; c=relaxed/simple;
	bh=UF/XgH4255aSGWQgDSj8/OqvKw0xbQCie6ZgV1fNFVQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GkDM75M/0enQ/TsKduFVF3MNnIEZkTmNlskvwlHd0deFCTe9xq3ioPEOUtpVhfF2bGv9lao/D0bTDI+wYiHfQ6HbNMHkQFYoMBZK4fHBgo7CLZH6hkHxFqmmj1IXIxoRni+abNug9i40TIM2pibe5FKkt+L9057BotY+yi/bD5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=OgyThMr0; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="OgyThMr0"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68N8xaE13169129, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790153977; bh=UF/XgH4255aSGWQgDSj8/OqvKw0xbQCie6ZgV1fNFVQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=OgyThMr0G9FSOugnyo6WPOcFoBAcC7BhzP+Zjtauz56+Q81U6ZLAUXlcgzQORsgm7
	 AmrgYmtbLOoAuqn/4n5EqbHV2VIOR1nwNYbDgX7RAoAfdnGqmj2S79r9O4txT5TNoq
	 BT7+ckd8+tWUM6meF03lzBbe2fT/yoZwqam9GtkDSCbE2oh1nlejcjpFE8bqa+oA/W
	 aT2mmF9ZhdKb/Qx/EtyPGHNEheRuwD/ZhA8r/CWjb8s4V4LaPO3Tqrmm7CTQ57Bapq
	 r1KOb1EkpnSjEtBrgy9JBsVrKpN5YZLov/rpHARgFgU/gnKFVf2BsDjAFRahfzpf1q
	 QR65xhreUq6tQ==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68N8xaE13169129
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 23 Sep 2026 16:59:37 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 23 Sep 2026 16:59:36 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Wed, 23 Sep 2026 16:59:36 +0800
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
Thread-Index: AQHdSeATpI0NUCgP0kmEYeuJr1vdNLbby2HQ//+FlwCAAIc+QP//fYCAgACI3aA=
Date: Wed, 23 Sep 2026 08:59:35 +0000
Message-ID: <16eeca262aab43a798afeb806e88aac8@realtek.com>
References: <20260921154347.82317-1-luka.gejak@linux.dev>
 <20260921154347.82317-3-luka.gejak@linux.dev>
 <0a6ea4337e004faa97595b1b62d2cad9@realtek.com>
 <6c14fabffc6984a5e7cd91c9b7fe6e4caceeaf70@linux.dev>
 <3ce6a66b25274fb0b58f259529359bfe@realtek.com>
 <09c6a890906e4d4e93d8dcde41e2b808b7d9582c@linux.dev>
In-Reply-To: <09c6a890906e4d4e93d8dcde41e2b808b7d9582c@linux.dev>
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

DQpMdWthIEdlamFrIDxsdWthLmdlamFrQGxpbnV4LmRldj4gd3JvdGU6DQo+ID4NCj4gPiBMdWth
IEdlamFrIDxsdWthLmdlamFrQGxpbnV4LmRldj4gd3JvdGU6DQo+ID4NCj4gPiA+DQo+ID4gPiBM
dWthIEdlamFrIDxsdWthLmdlamFrQGxpbnV4LmRldj4gd3JvdGU6DQo+ID4gPiAgPiArLy8gU1BE
WC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjAgT1IgQlNELTMtQ2xhdXNlDQo+ID4gPiAgPiAr
LyoNCj4gPiA+ICA+ICsgKiBDb3B5cmlnaHQoYykgMjAwNy0yMDE3IFJlYWx0ZWsgQ29ycG9yYXRp
b24NCj4gPiA+ICA+ICsgKiBDb3B5cmlnaHQoYykgTWljaGFlbCBTdHJhdWJlIDxzdHJhdWJlLmxp
bnV4QGdtYWlsLmNvbT4NCj4gPiA+ICA+ICsgKiBDb3B5cmlnaHQoYykgMjAyNC0yMDI2IEx1a2Eg
R2VqYWsgPGx1a2EuZ2VqYWtAbGludXguZGV2Pg0KPiA+ID4gID4NCj4gPiA+ICBJJ20gbm90IHN1
cmUgaWYgd2Ugc2hvdWxkIGNsYWltIGNvcHlyaWdodCB5ZWFyIGJhY2sgdG8gMjAwNz8NCj4gPiA+
DQo+ID4gPiAgV2hhdCB3b3VsZCB5b3UgcHJlZmVyLCBqdXN0IHRlbGwgbWUgYW5kIEkgd2lsbCBj
aGFuZ2UgaXQ/DQo+ID4gPg0KPiA+IFlvdSBjYW4gcmVmZXJlbmNlIHdoYXQgQml0dGVyYmx1ZSBk
aWQgWzFdLiBJIGRvbid0IGhhdmUgbXVjaCBzdHVkeQ0KPiA+IGFib3V0IHRoZSBjb3B5cmlnaHQu
DQo+ID4NCj4gPiBbMV0gMWE3NTQ1Nzg0NjQyICgid2lmaTogcnR3ODg6IEFkZCBydHc4ODE0YS57
YyxofSIpDQo+ID4NCj4gDQo+IEhlIHVzZXMgMjAyNSwgc28gc2hvdWxkIEkgY29weSBoaXMgbGlu
ZSBmb3IgUmVhbHRlayBjb3B5cmlnaHQgaGVhZGVyPw0KDQpNYXliZSAiQ29weXJpZ2h0KGMpIDIw
MjYgUmVhbHRlayBDb3Jwb3JhdGlvbiINCg0KSWYgbmVlZGVkLCBtb3JlIGNvcHlyaWdodCBhcmUg
YWxzbyBva2F5LCBidXQgSSBkb24ndCBrbm93IG11Y2ggYWJvdXQgdGhhdC4NCllvdSBjYW4gc3R1
ZHkgRG9jdW1lbnRhdGlvbiBvciBzb21ld2hlcmUgdG8ga25vdyBtb3JlLg0KDQo+IA0KPiBBbHNv
IEkgd2lsbCBhZGRyZXNzIGFsbCBjb21tZW50cyBhbmQgc2VuZCB2NCB0b25pZ2h0L3RvbW9ycm93
IG1vcm5pbmcuDQoNCk5vIHJ1c2guIERlZXBseSB3aGF0IHJldmlldyB0aGUgcGF0Y2hlcyBiZWZv
cmUgc2VuZGluZyBpcyBtb3JlIGltcG9ydGFudC4NCkFzIHRoaXMgcGF0Y2hzZXQgaXMgbGFyZ2Ug
TE9DLCBvbmUgaXRlcmF0aW9uIHNwZW5kcyBtZSBhIGxvdCBvZiB0aW1lLiBJJ2QNCm1pbmltaXpl
IGl0ZXJhdGlvbiBhcyBmZXcgYXMgcG9zc2libGUuDQoNClBpbmctS2UNCg0K
