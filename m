Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 887617DA66
	for <linux-wireless@vger.kernel.org>; Mon, 26 Jan 2026 03:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769398802; cv=none; b=Ge+1VbS64mSwaef1EPvovG+kfJ3Zyb+tfTbGKsDUB5qkP8ziFe/Ab+u4p2pyI/K1Taw/xe2Ozk6cv6Eanv/rSh9/tizKgmd9hSF7iQcR0gd7HUGv1GM6l0NxS5a23egfDelvzxhb9UvISZUzdJCCvndgiH+pnDY6pLhzwo9c15k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769398802; c=relaxed/simple;
	bh=+7Fqkm68kqoynN0jGfR8X7JLiBNDwGnV3YsY5H8GB0c=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LLP5Eo5HyN3QuKrIt/vNq8My9p2c3gaSATdvarXPCBU3CsiJxaCrsFy4MxVPMgCd/UgSUT4TNJvdBH3g9yxiiHvWDe5PZkeQnPLgvctO5Du1FgTtqGHhldON6yMVWJDWKxkdOJO43ugylM8VygKmbwLzHt/QOFhqYvyp+hSMIGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=OxH4HCjG; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="OxH4HCjG"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 60Q3dlX93111740, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1769398787; bh=+7Fqkm68kqoynN0jGfR8X7JLiBNDwGnV3YsY5H8GB0c=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=OxH4HCjGj7ectbCMqd6b2rsFpDheSg+C0dyEbnT9Xgwr2bSyl1/4rhxJjSPNgSET8
	 r42nCfvL7Ooa8N3UTi6US6t9ZeHoyYLtBUI5fIVEaQj3+9A6KgNsmmthNNl5H5+yzq
	 In0ir7UOSXRFVI2krzTtleTcdzzKjo5JfUJzOjXT8MkgW8MymPsvuqwJtACGHVOOL0
	 0Y99Th0H+52mRU+DXYOPN7uWGkskr37Wdgv+eNFUZsoAt/GvMco6w6siMhW1kCBVAj
	 BRyTloo5993WXPWhvFI41GuseYoubLZKffiNIRkpkP1SZT3Nv2lk78s9uZalwnQsOI
	 LZDWBKakU42EA==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.21/5.94) with ESMTPS id 60Q3dlX93111740
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Jan 2026 11:39:47 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Mon, 26 Jan 2026 11:39:47 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([fe80::4cbd:6c6c:b92b:3913]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::4cbd:6c6c:b92b:3913%10]) with mapi id
 15.02.1748.010; Mon, 26 Jan 2026 11:39:47 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Lucid Duck <lucid_duck@justthetip.ca>,
        "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>,
        Bitterblue Smith <rtl8821cerfe2@gmail.com>,
        Mh_chen <mh_chen@realtek.com>
Subject: RE: [PATCH] wifi: rtw89: usb: fix TX flow control by tracking
 in-flight URBs
Thread-Topic: [PATCH] wifi: rtw89: usb: fix TX flow control by tracking
 in-flight URBs
Thread-Index: AQHcjkpOprwyThrh+0qoaRiP29pAsrVjy/ZQ
Date: Mon, 26 Jan 2026 03:39:47 +0000
Message-ID: <290226f1d7144477a668f045cbd8eb56@realtek.com>
References: <20260125221943.36001-1-lucid_duck@justthetip.ca>
In-Reply-To: <20260125221943.36001-1-lucid_duck@justthetip.ca>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
Content-Type: text/plain; charset="big5"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

KyBkZXZlbG9wZXJzIG9mIFdpRmkgVVNCIGFkYXB0ZXJzIA0KDQpMdWNpZCBEdWNrIDxsdWNpZF9k
dWNrQGp1c3R0aGV0aXAuY2E+IHdyb3RlOg0KPiBydHc4OV91c2Jfb3BzX2NoZWNrX2FuZF9yZWNs
YWltX3R4X3Jlc291cmNlKCkgY3VycmVudGx5IHJldHVybnMgYQ0KPiBoYXJkY29kZWQgcGxhY2Vo
b2xkZXIgdmFsdWUgb2YgNDIsIHZpb2xhdGluZyBtYWM4MDIxMSdzIFRYIGZsb3cgY29udHJvbA0K
PiBjb250cmFjdC4gVGhpcyBjYXVzZXMgdW5jb250cm9sbGVkIFVSQiBhY2N1bXVsYXRpb24gdW5k
ZXIgc3VzdGFpbmVkIFRYDQo+IGxvYWQgc2luY2UgbWFjODAyMTEgYmVsaWV2ZXMgcmVzb3VyY2Vz
IGFyZSBhbHdheXMgYXZhaWxhYmxlLg0KDQpUaGVuIFVSQiBiZWNvbWVzIGV4aGF1c3RlZD8gDQoN
Cj4gDQo+IEZpeCB0aGlzIGJ5IGltcGxlbWVudGluZyBwcm9wZXIgVFggYmFja3ByZXNzdXJlOg0K
PiANCj4gLSBBZGQgcGVyLWNoYW5uZWwgYXRvbWljIGNvdW50ZXJzICh0eF9pbmZsaWdodFtdKSB0
byB0cmFjayBVUkJzIGJldHdlZW4NCj4gICBzdWJtaXNzaW9uIGFuZCBjb21wbGV0aW9uDQo+IC0g
SW5jcmVtZW50IGNvdW50ZXIgYmVmb3JlIHVzYl9zdWJtaXRfdXJiKCkgd2l0aCByb2xsYmFjayBv
biBmYWlsdXJlDQo+IC0gRGVjcmVtZW50IGNvdW50ZXIgaW4gY29tcGxldGlvbiBjYWxsYmFjaw0K
PiAtIFJldHVybiBhdmFpbGFibGUgc2xvdHMgKG1heCAtIGluZmxpZ2h0KSB0byBtYWM4MDIxMSwg
b3IgMCBhdCBjYXBhY2l0eQ0KPiAtIEV4Y2x1ZGUgZmlybXdhcmUgY29tbWFuZCBjaGFubmVsIChD
SDEyKSBmcm9tIGZsb3cgY29udHJvbA0KPiANCj4gVGVzdGVkIG9uIEQtTGluayBEV0EtWDE4NTAg
KFJUTDg4MzJBVSkgd2l0aDoNCj4gLSBTdXN0YWluZWQgaGlnaC10aHJvdWdocHV0IHRyYWZmaWMN
Cj4gLSBNb2R1bGUgbG9hZC91bmxvYWQgc3RyZXNzIHRlc3RzDQo+IC0gSG90LXVucGx1ZyBkdXJp
bmcgYWN0aXZlIHRyYW5zbWlzc2lvbg0KPiAtIDMwLW1pbnV0ZSBzb2FrIHRlc3QgdmVyaWZ5aW5n
IGNvdW50ZXJzIGJhbGFuY2UgYXQgaWRsZQ0KPiANCj4gU2lnbmVkLW9mZi1ieTogTHVjaWQgRHVj
ayA8bHVjaWRfZHVja0BqdXN0dGhldGlwLmNhPg0KDQpbLi4uXQ0KDQo+IGRpZmYgLS1naXQgYS9k
cml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg5L3VzYi5oIGIvZHJpdmVycy9uZXQvd2ly
ZWxlc3MvcmVhbHRlay9ydHc4OS91c2IuaA0KPiBpbmRleCAyMDNlYzhlOTkuLmY3MmE4YjFiMiAx
MDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OS91c2IuaA0K
PiArKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg5L3VzYi5oDQo+IEBAIC0y
MCw2ICsyMCw5IEBADQo+ICAjZGVmaW5lIFJUVzg5X01BWF9FTkRQT0lOVF9OVU0gICAgICAgICA5
DQo+ICAjZGVmaW5lIFJUVzg5X01BWF9CVUxLT1VUX05VTSAgICAgICAgICA3DQo+IA0KPiArLyog
VFggZmxvdyBjb250cm9sOiBtYXggaW4tZmxpZ2h0IFVSQnMgcGVyIGNoYW5uZWwgKi8NCj4gKyNk
ZWZpbmUgUlRXODlfVVNCX01BWF9UWF9VUkJTX1BFUl9DSCAgIDMyDQoNCkN1cmlvdXNseS4gSG93
IGRpZCB5b3UgZGVjaWRlIHRoaXMgdmFsdWU/IEhhdmUgeW91IHRlc3RlZCBVU0IyIGFuZCBVU0Iz
IGRldmljZXM/DQpIb3cgYWJvdXQgdGhlaXIgdGhyb3VnaHB1dCBiZWZvcmUvYWZ0ZXIgdGhpcyBw
YXRjaD8NCg0KPiArDQo+ICBzdHJ1Y3QgcnR3ODlfdXNiX2luZm8gew0KPiAgICAgICAgIHUzMiB1
c2JfaG9zdF9yZXF1ZXN0XzI7DQo+ICAgICAgICAgdTMyIHVzYl93bGFuMF8xOw0KPiBAQCAtNjMs
NiArNjYsOSBAQCBzdHJ1Y3QgcnR3ODlfdXNiIHsNCj4gICAgICAgICBzdHJ1Y3QgdXNiX2FuY2hv
ciB0eF9zdWJtaXR0ZWQ7DQo+IA0KPiAgICAgICAgIHN0cnVjdCBza19idWZmX2hlYWQgdHhfcXVl
dWVbUlRXODlfVFhDSF9OVU1dOw0KPiArDQo+ICsgICAgICAgLyogVFggZmxvdyBjb250cm9sOiB0
cmFjayBpbi1mbGlnaHQgVVJCcyBwZXIgY2hhbm5lbCAqLw0KDQpJIGZlZWwgd2UgZG9uJ3QgbmVl
ZCByZXBlYXRlZGx5IGFkZGluZyB0aGlzIGNvbW1lbnQuIElmIHlvdSBsaWtlIGl0LCBqdXN0DQpr
ZWVwIG9uZS4NCg0KPiArICAgICAgIGF0b21pY190IHR4X2luZmxpZ2h0W1JUVzg5X1RYQ0hfTlVN
XTsNCj4gIH07DQo+IA0KPiAgc3RhdGljIGlubGluZSBzdHJ1Y3QgcnR3ODlfdXNiICpydHc4OV91
c2JfcHJpdihzdHJ1Y3QgcnR3ODlfZGV2ICpydHdkZXYpDQo+IC0tDQo+IDIuNTIuMA0KPiANCg0K
