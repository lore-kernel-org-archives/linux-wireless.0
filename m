Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D66148C40B
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 09:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789549290; cv=none; b=JfYoDX3DvZGDF9CVsUFYUr82myd3Xhw9RKtAdSZOphJMoqV7lveweuQ5rnDKqYeYc3dzANbaSJd2WJhvkmvCJ2vqZ2Z1geLTQ16eEw587u07dEJGvaDrZEW2sCml6zAOUzFJVh02BSUiMNtnL5VmP31VHI5SLTUwJo1Qc35iQQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789549290; c=relaxed/simple;
	bh=E4pA8mrhVzi8aijfss9MrTzwC4ghHE1lUJvjCb5iOYs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=P7XB0egVj40T29chjUpLZug45rjmjia7YjIk/b9D3fKA3alt3UessSR0xPwn5GrEFKWKKrIAGEqmm54nx34EMQyL1aOjaGk6swvFFODUxvDK4wlr2Y6NJeoDxsivX3rLeCxmNCTJBgw4mNcGIooYzh9cHGT17g3uJlBhZxJMrVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=KXQ6S7Zb; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="KXQ6S7Zb"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68G90ocmE2241907, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789549251; bh=E4pA8mrhVzi8aijfss9MrTzwC4ghHE1lUJvjCb5iOYs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=KXQ6S7ZbQNruFjmKo4XxkP9otfQF/t1OMVAAs2s0PdUDCLb9+ndiHxIMCGkTVh+26
	 BEZNBeR4GIwdiEswBCfnbK8P5eIKmrxU2GU9EjcumfoGbIb09puw1bYSVu53Q/8wgx
	 DSp9YhV6Q7iLbjh7NhkaO2wWCCBWf3n24/NleKUkClxPJvdBhg4NmWHPivDDqZmrLP
	 ouELO8wFzuRZIZ+u2mB93uZR5+SFIE7D1YYVDa0Vm7hJVYGvkhbfrp9qdxeXxH75Oq
	 mIpvkNAXZwxgD/LT2PImt46n1qsQWPnurkpx9KWZoOtNbIFGYXVeohu2P+ITnxzS+v
	 rDUzcj+dUl2+A==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68G90ocmE2241907
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 16 Sep 2026 17:00:51 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 16 Sep 2026 17:00:50 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 16 Sep 2026 17:00:50 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Wed, 16 Sep 2026 17:00:50 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "i.mafifi17@gmail.com" <i.mafifi17@gmail.com>
Subject: RE: [PATCH rtw-next v3] wifi: rtw88: usb: Download the reserved page
 synchronously
Thread-Topic: [PATCH rtw-next v3] wifi: rtw88: usb: Download the reserved page
 synchronously
Thread-Index: AQHdRIZF9nRMVUbxQUC9Ami7rwCNVrbQ3QpwgAANbpA=
Date: Wed, 16 Sep 2026 09:00:49 +0000
Message-ID: <874dbf3b9c11407cb6106efb29eddce3@realtek.com>
References: <5e0ce93e-0615-405e-956c-0f8dd8a543d9@gmail.com>
 <40bf5c51a1c24677bbd5e1ede8cbc5ce@realtek.com>
In-Reply-To: <40bf5c51a1c24677bbd5e1ede8cbc5ce@realtek.com>
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

UGluZy1LZSBTaGloIHdyb3RlOg0KPiBCaXR0ZXJibHVlIFNtaXRoIDxydGw4ODIxY2VyZmUyQGdt
YWlsLmNvbT4gd3JvdGU6DQo+ID4gQEAgLTQ5OSwxNiArNTA2LDIxIEBAIHN0YXRpYyB2b2lkIHJ0
d191c2JfdHhfcXVldWVfcHVyZ2Uoc3RydWN0IHJ0d191c2IgKnJ0d3VzYikNCj4gPg0KPiA+ICBz
dGF0aWMgdm9pZCBydHdfdXNiX3dyaXRlX3BvcnRfY29tcGxldGUoc3RydWN0IHVyYiAqdXJiKQ0K
PiA+ICB7DQo+ID4gLSAgICAgICBzdHJ1Y3Qgc2tfYnVmZiAqc2tiID0gdXJiLT5jb250ZXh0Ow0K
PiA+ICsgICAgICAgc3RydWN0IHJ0d191c2Jfd3JpdGVfZGF0YV9jYiAqY2IgPSB1cmItPmNvbnRl
eHQ7DQo+ID4NCj4gDQo+IEkgdGhpbmsgaGVyZSBpcyBhIHJhY2luZyB3aXRoIHRpbWVvdXQgY2Fz
ZSBvZiB3YWl0X2Zvcl9jb21wbGV0aW9uX3RpbWVvdXQoKS4NCj4gDQo+ICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIENQVTAgICAgICAgICAgICAgICAgICAgICAgQ1BVMQ0KPiAgICAgICAgICAg
IChydHdfdXNiX3dyaXRlX3BvcnRfY29tcGxldGUpICAgICAgICAgKHJ0d191c2Jfd3JpdGVfZGF0
YSkNCj4gDQo+ICAgICAgICAgICAgY2IgPSB1cmItPmNvbnRleHQNCj4gICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgd2FpdF9mb3JfY29tcGxldGlvbl90aW1l
b3V0KCkgdGltZW91dA0KPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICBrZnJlZShjYik7DQo+ICAgICAgICAgICAgY2ItPnN0YXR1cyA9IHVyYi0+c3RhdHVz
Ow0KPiAgICAgICAgICAgKGNiIGlzIGZyZWUtYWZ0ZXItdXNlKQ0KDQpmaXggdHlwbw0KICAgICAg
ICAgICAgKGNiIGlzIHVzZS1hZnRlci1mcmVlKQ0KDQoNCj4gDQo+IHJ0dzg5IGhhbmRsZXMgdGhp
cyBraW5kIG9mIHByb2JsZW0gYnkgUkNVLiBZb3UgY2FuIHJlZmVyZW5jZQ0KPiBydHc4OV93YWl0
X2Zvcl9jb25kX2V2YWwoKSB0byBrbm93IGhvdyBpdCBkb2VzLg0KPiANCj4gPiAtICAgICAgIGRl
dl9rZnJlZV9za2JfYW55KHNrYik7DQo+ID4gKyAgICAgICBjYi0+c3RhdHVzID0gdXJiLT5zdGF0
dXM7DQo+ID4gKyAgICAgICBjb21wbGV0ZSgmY2ItPmRvbmUpOw0KPiA+ICsgICAgICAgZGV2X2tm
cmVlX3NrYl9hbnkoY2ItPnNrYik7DQo+ID4gKyAgICAgICBpZiAoIWNiLT5zeW5jKQ0KPiA+ICsg
ICAgICAgICAgICAgICBrZnJlZShjYik7DQo+ID4gIH0NCj4gPg0KPiA+ICBzdGF0aWMgaW50IHJ0
d191c2Jfd3JpdGVfZGF0YShzdHJ1Y3QgcnR3X2RldiAqcnR3ZGV2LA0KPiA+ICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIHN0cnVjdCBydHdfdHhfcGt0X2luZm8gKnBrdF9pbmZvLA0KPiA+
IC0gICAgICAgICAgICAgICAgICAgICAgICAgICAgIHU4ICpidWYpDQo+ID4gKyAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgdTggKmJ1ZiwgYm9vbCBzeW5jKQ0KPiA+ICB7DQo+ID4gICAgICAg
ICBjb25zdCBzdHJ1Y3QgcnR3X2NoaXBfaW5mbyAqY2hpcCA9IHJ0d2Rldi0+Y2hpcDsNCj4gPiAr
ICAgICAgIHN0cnVjdCBydHdfdXNiX3dyaXRlX2RhdGFfY2IgKmNiOw0KPiA+ICAgICAgICAgc3Ry
dWN0IHNrX2J1ZmYgKnNrYjsNCj4gPiAgICAgICAgIHVuc2lnbmVkIGludCBzaXplOw0KPiA+ICAg
ICAgICAgdTggcXNlbDsNCj4gPiBAQCAtNTI4LDExICs1NDAsMjkgQEAgc3RhdGljIGludCBydHdf
dXNiX3dyaXRlX2RhdGEoc3RydWN0IHJ0d19kZXYgKnJ0d2RldiwNCj4gPiAgICAgICAgIHJ0d190
eF9maWxsX3R4X2Rlc2MocnR3ZGV2LCBwa3RfaW5mbywgc2tiKTsNCj4gPiAgICAgICAgIHJ0d190
eF9maWxsX3R4ZGVzY19jaGVja3N1bShydHdkZXYsIHBrdF9pbmZvLCBza2ItPmRhdGEpOw0KPiA+
DQo+ID4gKyAgICAgICBjYiA9IGttYWxsb2Nfb2JqKCpjYiwgR0ZQX0tFUk5FTCk7DQo+ID4gKyAg
ICAgICBpZiAoIWNiKSB7DQo+ID4gKyAgICAgICAgICAgICAgIGRldl9rZnJlZV9za2JfYW55KHNr
Yik7DQo+ID4gKyAgICAgICAgICAgICAgIHJldHVybiAtRU5PTUVNOw0KPiA+ICsgICAgICAgfQ0K
PiA+ICsNCj4gPiArICAgICAgIGluaXRfY29tcGxldGlvbigmY2ItPmRvbmUpOw0KPiA+ICsgICAg
ICAgY2ItPnN0YXR1cyA9IC1FSU5QUk9HUkVTUzsNCj4gPiArICAgICAgIGNiLT5za2IgPSBza2I7
DQo+ID4gKyAgICAgICBjYi0+c3luYyA9IHN5bmM7DQo+ID4gKw0KPiA+ICAgICAgICAgcmV0ID0g
cnR3X3VzYl93cml0ZV9wb3J0KHJ0d2RldiwgcXNlbCwgc2tiLA0KPiA+IC0gICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIHJ0d191c2Jfd3JpdGVfcG9ydF9jb21wbGV0ZSwgc2tiKTsNCj4g
PiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBydHdfdXNiX3dyaXRlX3BvcnRfY29t
cGxldGUsIGNiKTsNCj4gPiAgICAgICAgIGlmICh1bmxpa2VseShyZXQpKSB7DQo+ID4gICAgICAg
ICAgICAgICAgIHJ0d19lcnIocnR3ZGV2LCAiZmFpbGVkIHRvIGRvIFVTQiB3cml0ZSwgcmV0PSVk
XG4iLCByZXQpOw0KPiA+ICAgICAgICAgICAgICAgICBkZXZfa2ZyZWVfc2tiX2FueShza2IpOw0K
PiA+ICsgICAgICAgICAgICAgICBrZnJlZShjYik7DQo+ID4gKyAgICAgICB9IGVsc2UgaWYgKHN5
bmMpIHsNCj4gPiArICAgICAgICAgICAgICAgaWYgKCF3YWl0X2Zvcl9jb21wbGV0aW9uX3RpbWVv
dXQoJmNiLT5kb25lLCBzZWNzX3RvX2ppZmZpZXMoNSkpKQ0KPiA+ICsgICAgICAgICAgICAgICAg
ICAgICAgIHJldCA9IC1FVElNRURPVVQ7DQo+ID4gKyAgICAgICAgICAgICAgIGVsc2UNCj4gPiAr
ICAgICAgICAgICAgICAgICAgICAgICByZXQgPSBjYi0+c3RhdHVzOw0KPiA+ICsgICAgICAgICAg
ICAgICBrZnJlZShjYik7DQo+ID4gICAgICAgICB9DQo+ID4NCj4gPiAgICAgICAgIHJldHVybiBy
ZXQ7DQo+IA0KDQo=
