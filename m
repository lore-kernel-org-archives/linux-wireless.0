Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A521E348C7F
	for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2026 02:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792377562; cv=none; b=B8Bby3/xiX1ialSIwvJnoiUpud3qdAb/g2lx6gdb2mUYxVRkqrc7jSqqG7ojXYsSp8FpR9ZUQGBCuaIzZffFEgZXHDYSde054NadfPEJ1xEmOfvXC926bkrdYWN+bSCwC5LkR4itlv76ALk15r/OvG9c67FtnL2hYHCL78+Z5EM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792377562; c=relaxed/simple;
	bh=9uT9XNVhx0W2OqO4j6rjKYnwE5k4DrNuzWLpMWpREpk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OFarQUpTiH/8zIW/deQoYl5Cy3pWAg5uMOb36w2zKGRewaH9ACF/x8XUwWf4GmLB0NEbZIM0NKORQVsXsuACEizIr+7/3kT6smcGNPap+bxtfXr5SrUh7dsBDPoWFeHenlRSMt72z2CSPaHALVis5kgRJu3TxZJ5Kh+Na6PcU6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=oetj5OCV; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="oetj5OCV"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69J2d8KO11508392, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1792377548; bh=9uT9XNVhx0W2OqO4j6rjKYnwE5k4DrNuzWLpMWpREpk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=oetj5OCVoYSu2jb478QKYOsTt9VL5FV1VfLdo6F75TUbZ+PaGKq/6gyEuxorHjPBT
	 KkoBocdml//J7vM2KIEwCp3f9KFpMlEQCJct74/BiR8vvQ7LWreVNIXrFO+pK7jIww
	 WFhZtfhXa5CdSymAcPrbpTQ+g/6JSxkeBtB8U809TryonIo6DVlcWN8uOqabfts3wJ
	 /UCcv91o0H8aeiNnV5Gti1khm3SyLgggpCVfth7DnHWjnEzHxtIdwMsQbPaC/5EZVg
	 nD1DIQb23Mz2qGToNOHNMOI+s/solcK/MBW3mccOgHLy8npGo1Pets6yW2UgND3Go0
	 a862H8608Lxdw==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69J2d8KO11508392
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 19 Oct 2026 10:39:08 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 19 Oct 2026 10:39:08 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Mon, 19 Oct 2026 10:39:08 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Luka Gejak <luka.gejak@linux.dev>
Subject: RE: [PATCH rtw-next] wifi: rtw88: 8723b: Read the package type from
 efuse
Thread-Topic: [PATCH rtw-next] wifi: rtw88: 8723b: Read the package type from
 efuse
Thread-Index: AQHdXk4lzo00xlPiA0KUCKW0Zm5qUbcEJbOg
Date: Mon, 19 Oct 2026 02:39:08 +0000
Message-ID: <425c1552139b4f09a5db42459fa74a08@realtek.com>
References: <d22c9202-d019-4ca1-8534-c23244d612d4@gmail.com>
In-Reply-To: <d22c9202-d019-4ca1-8534-c23244d612d4@gmail.com>
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

Qml0dGVyYmx1ZSBTbWl0aCA8cnRsODgyMWNlcmZlMkBnbWFpbC5jb20+IHdyb3RlOg0KDQpbLi4u
XQ0KDQo+ICtzdGF0aWMgdm9pZCBydHc4NzIzYl9yZWFkX3BhY2thZ2VfdHlwZShzdHJ1Y3QgcnR3
X2RldiAqcnR3ZGV2KQ0KPiArew0KPiArICAgICAgIHN0cnVjdCBydHdfaGFsICpoYWwgPSAmcnR3
ZGV2LT5oYWw7DQo+ICsgICAgICAgdTggdmFsXzFmYjsNCj4gKw0KPiArICAgICAgIHJ0dzg3MjNi
X2VmdXNlX2dyYW50KHJ0d2RldiwgdHJ1ZSk7DQo+ICsgICAgICAgcnR3X3JlYWQ4X3BoeXNpY2Fs
X2VmdXNlKHJ0d2RldiwgMHgxZmIsICZ2YWxfMWZiKTsNCj4gKyAgICAgICBydHc4NzIzYl9lZnVz
ZV9ncmFudChydHdkZXYsIGZhbHNlKTsNCg0KSW4gcnR3X3BhcnNlX2VmdXNlX21hcCgpLCB3ZSBj
YW4gcGFzcyAncGh5X21hcCcgdG8gcmVhZF9lZnVzZSgpPw0KLWNoaXAtPm9wcy0+cmVhZF9lZnVz
ZShydHdkZXYsIGxvZ19tYXApOw0KK2NoaXAtPm9wcy0+cmVhZF9lZnVzZShydHdkZXYsIGxvZ19t
YXAsIHBoeV9tYXApOw0KDQpBcyAucGh5X2VmdXNlX3NpemUgPSA1MTIgZm9yIFJUTDc4MjNCLCBJ
IHRoaW5rIGl0IHdpbGwgd29yay4gDQoNCj4gKw0KPiArICAgICAgIHN3aXRjaCAodThfZ2V0X2Jp
dHModmFsXzFmYiwgR0VOTUFTSygyLCAwKSkpIHsNCg0KQml0IDJ+MCBzZWVtcyBsaWtlIFBLR19U
WVBFLiBEZWZpbmUgYW4gZW51bT8NCg0KPiArICAgICAgIGNhc2UgMHg0Og0KPiArICAgICAgICAg
ICAgICAgaGFsLT5wa2dfdHlwZSA9IFJUVzg3MjNCX1BBQ0tBR0VfVEZCR0E3OTsNCj4gKyAgICAg
ICAgICAgICAgIGJyZWFrOw0KPiArICAgICAgIGNhc2UgMHg1Og0KPiArICAgICAgICAgICAgICAg
aGFsLT5wa2dfdHlwZSA9IFJUVzg3MjNCX1BBQ0tBR0VfVEZCR0E5MDsNCj4gKyAgICAgICAgICAg
ICAgIGJyZWFrOw0KPiArICAgICAgIGNhc2UgMHg2Og0KPiArICAgICAgICAgICAgICAgaGFsLT5w
a2dfdHlwZSA9IFJUVzg3MjNCX1BBQ0tBR0VfUUZONjg7DQo+ICsgICAgICAgICAgICAgICBicmVh
azsNCj4gKyAgICAgICBjYXNlIDB4NzoNCj4gKyAgICAgICAgICAgICAgIGhhbC0+cGtnX3R5cGUg
PSBSVFc4NzIzQl9QQUNLQUdFX1RGQkdBODA7DQo+ICsgICAgICAgICAgICAgICBicmVhazsNCj4g
KyAgICAgICBkZWZhdWx0Og0KPiArICAgICAgICAgICAgICAgaGFsLT5wa2dfdHlwZSA9IFJUVzg3
MjNCX1BBQ0tBR0VfREVGQVVMVDsNCj4gKyAgICAgICAgICAgICAgIGJyZWFrOw0KPiArICAgICAg
IH0NCj4gKw0KPiArICAgICAgIGlmIChydHdfaGNpX3R5cGUocnR3ZGV2KSA9PSBSVFdfSENJX1RZ
UEVfU0RJTyAmJg0KPiArICAgICAgICAgICB1OF9nZXRfYml0cyh2YWxfMWZiLCBHRU5NQVNLKDUs
IDQpKSA9PSAweDIpDQoNCkNhbiB5b3UgZGVmaW5lIGVudW1zIGZvciBiaXQgNS00IGFuZCB2YWx1
ZSAweDI/DQpJJ20gbm90IHN1cmUgaWYgdmVuZG9yIGRyaXZlciBoYXMgc29tZSBjb21tZW50cyBw
b2ludGluZyBvdXQgdGhpcyBvciBub3QuDQoNCj4gKyAgICAgICAgICAgICAgIHJ0d2Rldi0+ZWZ1
c2UuaHdfY2FwLmJ3ICY9IH5CSVQoUlRXX0NIQU5ORUxfV0lEVEhfNDApOw0KPiArfQ0KPiArDQo+
ICBzdGF0aWMgaW50IHJ0dzg3MjNiX3JlYWRfZWZ1c2Uoc3RydWN0IHJ0d19kZXYgKnJ0d2Rldiwg
dTggKmxvZ19tYXApDQo+ICB7DQo+ICAgICAgICAgc3RydWN0IHJ0d19lZnVzZSAqZWZ1c2UgPSAm
cnR3ZGV2LT5lZnVzZTsNCg0KDQo=
