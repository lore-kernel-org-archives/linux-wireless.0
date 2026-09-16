Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F404483AF
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 08:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789546707; cv=none; b=OgVZ5Mc3sqNvFhxIH4lPGw3oXhtM19mTnWq4QW0khRSBNq0B0wk6sI8akp3aQHs2Vg127ub3SPEn3x2ljVA9w3VOluMcn0dxeb5NeF7PxafgvrSWPTF0v3cny641PRqvHE5UFPoHTXa1TFHhusfxLXoCII0slpx7+BOKTfMMdBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789546707; c=relaxed/simple;
	bh=vq836d4vF9XEXuxlefBUXGa6qhCq1ugKXG14vQbYAoU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fimi7UJQyg2ck4AeKxHflaEj2GfpeqRslQaF34XI7fe2o33L3+XyyWSB+vs3fyVvJni3svUcFiQELnR6GHiQ6Gee6L+KCP2f/qR792cSrDCjINMM883FtlQlFU4yCRBeNFoiojsUHyiF9dbecGoKs6flrVYmB2nXbQ2DYAI2rRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=TjJzr8oH; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="TjJzr8oH"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68G8IB0F02224246, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789546692; bh=vq836d4vF9XEXuxlefBUXGa6qhCq1ugKXG14vQbYAoU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=TjJzr8oHxDaWuIkkOUkvifvhFBzebfBJ/piSYu7swkrLJLBN/u4fSDrEaIJZ5sdOi
	 XlXf9Fsd9iAzhtM3vyNAst3PUG+WQkiAQZ0CDW4fPRkpnBD5SCZvZYHxGKDQaTrvIJ
	 +eF47QrhnlPxi3sHtM9+Pcej0adjv0elXGMQ2D43X4WvOyDSGxA+aqWBnJzQcsOjPu
	 EHug7hBn6EK9dcsj/LH+jn3SOacsFpJB3fAYTQBwtZz7CU3GWL4tW6MVYV4C4SpsIi
	 +CyUdtM0BNK8zmLWPc3mhjH4nsyTphUyW5+vy+JKeFYNgEd82lsXFdz4srtzgx+/U8
	 uRwiH8to7CWUg==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68G8IB0F02224246
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 16 Sep 2026 16:18:12 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 16 Sep 2026 16:18:10 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Wed, 16 Sep 2026 16:18:10 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "i.mafifi17@gmail.com" <i.mafifi17@gmail.com>
Subject: RE: [PATCH rtw-next v3] wifi: rtw88: usb: Download the reserved page
 synchronously
Thread-Topic: [PATCH rtw-next v3] wifi: rtw88: usb: Download the reserved page
 synchronously
Thread-Index: AQHdRIZF9nRMVUbxQUC9Ami7rwCNVrbQ3Qpw
Date: Wed, 16 Sep 2026 08:18:10 +0000
Message-ID: <40bf5c51a1c24677bbd5e1ede8cbc5ce@realtek.com>
References: <5e0ce93e-0615-405e-956c-0f8dd8a543d9@gmail.com>
In-Reply-To: <5e0ce93e-0615-405e-956c-0f8dd8a543d9@gmail.com>
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

Qml0dGVyYmx1ZSBTbWl0aCA8cnRsODgyMWNlcmZlMkBnbWFpbC5jb20+IHdyb3RlOg0KPiBAQCAt
NDk5LDE2ICs1MDYsMjEgQEAgc3RhdGljIHZvaWQgcnR3X3VzYl90eF9xdWV1ZV9wdXJnZShzdHJ1
Y3QgcnR3X3VzYiAqcnR3dXNiKQ0KPiANCj4gIHN0YXRpYyB2b2lkIHJ0d191c2Jfd3JpdGVfcG9y
dF9jb21wbGV0ZShzdHJ1Y3QgdXJiICp1cmIpDQo+ICB7DQo+IC0gICAgICAgc3RydWN0IHNrX2J1
ZmYgKnNrYiA9IHVyYi0+Y29udGV4dDsNCj4gKyAgICAgICBzdHJ1Y3QgcnR3X3VzYl93cml0ZV9k
YXRhX2NiICpjYiA9IHVyYi0+Y29udGV4dDsNCj4gDQoNCkkgdGhpbmsgaGVyZSBpcyBhIHJhY2lu
ZyB3aXRoIHRpbWVvdXQgY2FzZSBvZiB3YWl0X2Zvcl9jb21wbGV0aW9uX3RpbWVvdXQoKS4NCg0K
ICAgICAgICAgICAgICAgICAgICAgICAgICAgQ1BVMCAgICAgICAgICAgICAgICAgICAgICBDUFUx
DQogICAgICAgICAgIChydHdfdXNiX3dyaXRlX3BvcnRfY29tcGxldGUpICAgICAgICAgKHJ0d191
c2Jfd3JpdGVfZGF0YSkNCg0KICAgICAgICAgICBjYiA9IHVyYi0+Y29udGV4dA0KICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgd2FpdF9mb3JfY29tcGxldGlv
bl90aW1lb3V0KCkgdGltZW91dA0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAga2ZyZWUoY2IpOw0KICAgICAgICAgICBjYi0+c3RhdHVzID0gdXJiLT5zdGF0
dXM7DQogICAgICAgICAgKGNiIGlzIGZyZWUtYWZ0ZXItdXNlKQ0KDQpydHc4OSBoYW5kbGVzIHRo
aXMga2luZCBvZiBwcm9ibGVtIGJ5IFJDVS4gWW91IGNhbiByZWZlcmVuY2UNCnJ0dzg5X3dhaXRf
Zm9yX2NvbmRfZXZhbCgpIHRvIGtub3cgaG93IGl0IGRvZXMuDQoNCj4gLSAgICAgICBkZXZfa2Zy
ZWVfc2tiX2FueShza2IpOw0KPiArICAgICAgIGNiLT5zdGF0dXMgPSB1cmItPnN0YXR1czsNCj4g
KyAgICAgICBjb21wbGV0ZSgmY2ItPmRvbmUpOw0KPiArICAgICAgIGRldl9rZnJlZV9za2JfYW55
KGNiLT5za2IpOw0KPiArICAgICAgIGlmICghY2ItPnN5bmMpDQo+ICsgICAgICAgICAgICAgICBr
ZnJlZShjYik7DQo+ICB9DQo+IA0KPiAgc3RhdGljIGludCBydHdfdXNiX3dyaXRlX2RhdGEoc3Ry
dWN0IHJ0d19kZXYgKnJ0d2RldiwNCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgc3Ry
dWN0IHJ0d190eF9wa3RfaW5mbyAqcGt0X2luZm8sDQo+IC0gICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIHU4ICpidWYpDQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHU4ICpidWYs
IGJvb2wgc3luYykNCj4gIHsNCj4gICAgICAgICBjb25zdCBzdHJ1Y3QgcnR3X2NoaXBfaW5mbyAq
Y2hpcCA9IHJ0d2Rldi0+Y2hpcDsNCj4gKyAgICAgICBzdHJ1Y3QgcnR3X3VzYl93cml0ZV9kYXRh
X2NiICpjYjsNCj4gICAgICAgICBzdHJ1Y3Qgc2tfYnVmZiAqc2tiOw0KPiAgICAgICAgIHVuc2ln
bmVkIGludCBzaXplOw0KPiAgICAgICAgIHU4IHFzZWw7DQo+IEBAIC01MjgsMTEgKzU0MCwyOSBA
QCBzdGF0aWMgaW50IHJ0d191c2Jfd3JpdGVfZGF0YShzdHJ1Y3QgcnR3X2RldiAqcnR3ZGV2LA0K
PiAgICAgICAgIHJ0d190eF9maWxsX3R4X2Rlc2MocnR3ZGV2LCBwa3RfaW5mbywgc2tiKTsNCj4g
ICAgICAgICBydHdfdHhfZmlsbF90eGRlc2NfY2hlY2tzdW0ocnR3ZGV2LCBwa3RfaW5mbywgc2ti
LT5kYXRhKTsNCj4gDQo+ICsgICAgICAgY2IgPSBrbWFsbG9jX29iaigqY2IsIEdGUF9LRVJORUwp
Ow0KPiArICAgICAgIGlmICghY2IpIHsNCj4gKyAgICAgICAgICAgICAgIGRldl9rZnJlZV9za2Jf
YW55KHNrYik7DQo+ICsgICAgICAgICAgICAgICByZXR1cm4gLUVOT01FTTsNCj4gKyAgICAgICB9
DQo+ICsNCj4gKyAgICAgICBpbml0X2NvbXBsZXRpb24oJmNiLT5kb25lKTsNCj4gKyAgICAgICBj
Yi0+c3RhdHVzID0gLUVJTlBST0dSRVNTOw0KPiArICAgICAgIGNiLT5za2IgPSBza2I7DQo+ICsg
ICAgICAgY2ItPnN5bmMgPSBzeW5jOw0KPiArDQo+ICAgICAgICAgcmV0ID0gcnR3X3VzYl93cml0
ZV9wb3J0KHJ0d2RldiwgcXNlbCwgc2tiLA0KPiAtICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICBydHdfdXNiX3dyaXRlX3BvcnRfY29tcGxldGUsIHNrYik7DQo+ICsgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIHJ0d191c2Jfd3JpdGVfcG9ydF9jb21wbGV0ZSwgY2IpOw0KPiAg
ICAgICAgIGlmICh1bmxpa2VseShyZXQpKSB7DQo+ICAgICAgICAgICAgICAgICBydHdfZXJyKHJ0
d2RldiwgImZhaWxlZCB0byBkbyBVU0Igd3JpdGUsIHJldD0lZFxuIiwgcmV0KTsNCj4gICAgICAg
ICAgICAgICAgIGRldl9rZnJlZV9za2JfYW55KHNrYik7DQo+ICsgICAgICAgICAgICAgICBrZnJl
ZShjYik7DQo+ICsgICAgICAgfSBlbHNlIGlmIChzeW5jKSB7DQo+ICsgICAgICAgICAgICAgICBp
ZiAoIXdhaXRfZm9yX2NvbXBsZXRpb25fdGltZW91dCgmY2ItPmRvbmUsIHNlY3NfdG9famlmZmll
cyg1KSkpDQo+ICsgICAgICAgICAgICAgICAgICAgICAgIHJldCA9IC1FVElNRURPVVQ7DQo+ICsg
ICAgICAgICAgICAgICBlbHNlDQo+ICsgICAgICAgICAgICAgICAgICAgICAgIHJldCA9IGNiLT5z
dGF0dXM7DQo+ICsgICAgICAgICAgICAgICBrZnJlZShjYik7DQo+ICAgICAgICAgfQ0KPiANCj4g
ICAgICAgICByZXR1cm4gcmV0Ow0KDQoNCg==
