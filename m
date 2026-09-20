Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B9B35F5E7;
	Sun, 20 Sep 2026 03:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789876027; cv=none; b=N5fQEhuWrTA05SEJ2vyhhKIHSxwozfRiGX2rDo1XQZik9E0ibvevImHW01DD6M2ErrZYL/weuxqeqATkNNObTriTYtmNP1Mb3jy+FClrMWDMvRB/Gw/3O9nYPtB8G1abdyqQXP8BkAhO9kDqTj+01t+BVG36OxMhq8KnPEbOQKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789876027; c=relaxed/simple;
	bh=jt5UpzIIcFALqUTKExKkZFsYBWvAkf6805Ri0Rf4FOk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eipgtXX3bmbKyQdVTyBJaMczqkD1jVXFjdRmaFXf+ZyUX83k6Vi2tfkJ8TErKzSJfXLqgdbUaz6yA1Dpz07YWt3NtDYq9mpMGYXR49sGOY22JrbiliTgQtL4GbybcdM/K1PGf7C2QOArnQrdnxTtqV7YiCqJnlvaWZDcsa0wZRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=VhdOUDQn; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="VhdOUDQn"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68K3ktI131407681, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789876015; bh=jt5UpzIIcFALqUTKExKkZFsYBWvAkf6805Ri0Rf4FOk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=VhdOUDQnf8Trm/JQiUPyBJgTyakdo3Y6kyuYumC71Gk2PziZL21Q+bq2DYGCojW+T
	 tkZ0y5+wc91qzO0SB3kTxR4RB9p1lE/7us79qSM8t02ou4fdTIe3nUkC2Id7KslcOH
	 Dginqcwfgvav+1iNNAmLcoV54DTOgvGVj7Al6xvTB2PgUFY3AjKQ88U3qrPKasYN1b
	 RDiO4paaJmeY5Jbcf1KZCr+o95fnqdJWag8fofjO/Of/+Iedns2GRBWumxjNSo7u9p
	 tEZ7XcVQ/kyOhh35tAd5p55xiiC6aFRRXQoYAidQ7H3dhgQUS93vQOtId8150z1vE7
	 ig+TU1yMlY6Uw==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68K3ktI131407681
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sun, 20 Sep 2026 11:46:55 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 20 Sep 2026 11:46:55 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Sun, 20 Sep 2026 11:46:55 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: "5mghybrid@khu.ac.kr" <5mghybrid@khu.ac.kr>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "kvalo@kernel.org" <kvalo@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Jes.Sorensen@gmail.com"
	<Jes.Sorensen@gmail.com>
Subject: RE: [PATCH rtw-next v3 3/3] wifi: rtl8xxxu: preserve RX requests
 across recoverable transfer errors
Thread-Topic: [PATCH rtw-next v3 3/3] wifi: rtl8xxxu: preserve RX requests
 across recoverable transfer errors
Thread-Index: AQHdSHefc/MCcPjZN023IjBlQWSIu7bW0LzQ
Date: Sun, 20 Sep 2026 03:46:55 +0000
Message-ID: <9b5c31541fc8430b9d4205dcdff9e76e@realtek.com>
References: <20260920-codex-rtl-rx-v3-submit-v3-0-883d11351963@khu.ac.kr>
 <20260920-codex-rtl-rx-v3-submit-v3-3-883d11351963@khu.ac.kr>
In-Reply-To: <20260920-codex-rtl-rx-v3-submit-v3-3-883d11351963@khu.ac.kr>
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

S2ltIFdvb3Nlb2sgdmlhIEI0IFJlbGF5IDxkZXZudWxsKzVtZ2h5YnJpZC5raHUuYWMua3JAa2Vy
bmVsLm9yZz4gd3JvdGU6DQoNClsuLi5dDQoNCj4gQEAgLTU4NTUsOSArNTg1Niw4IEBAIHN0YXRp
YyBpbnQgcnRsOHh4eHVfYWxsb2NfcnhfdXJicyhzdHJ1Y3QgcnRsOHh4eHVfcHJpdiAqcHJpdikN
Cj4gIH0NCj4gDQo+ICBzdGF0aWMgdm9pZCBydGw4eHh4dV9xdWV1ZV9yeF91cmIoc3RydWN0IHJ0
bDh4eHh1X3ByaXYgKnByaXYsDQo+IC0gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBz
dHJ1Y3QgcnRsOHh4eHVfcnhfdXJiICpyeF91cmIpDQo+ICsgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBzdHJ1Y3QgcnRsOHh4eHVfcnhfdXJiICpyeF91cmIsIGJvb2wgcmV0cnkpDQoN
CidyZXRyeScgLS0+ICdkZWZlcl9zY2hlZHVsZSc/DQoNCj4gIHsNCj4gLSAgICAgICBzdHJ1Y3Qg
c2tfYnVmZiAqc2tiOw0KPiAgICAgICAgIHVuc2lnbmVkIGxvbmcgZmxhZ3M7DQo+IA0KPiAgICAg
ICAgIHNwaW5fbG9ja19pcnFzYXZlKCZwcml2LT5yeF91cmJfbG9jaywgZmxhZ3MpOw0KPiBAQCAt
NTg2NSwxNiArNTg2NSwxMyBAQCBzdGF0aWMgdm9pZCBydGw4eHh4dV9xdWV1ZV9yeF91cmIoc3Ry
dWN0IHJ0bDh4eHh1X3ByaXYgKnByaXYsDQo+ICAgICAgICAgaWYgKCFwcml2LT5zaHV0ZG93bikg
ew0KPiAgICAgICAgICAgICAgICAgbGlzdF9hZGRfdGFpbCgmcnhfdXJiLT5saXN0LCAmcHJpdi0+
cnhfdXJiX3BlbmRpbmdfbGlzdCk7DQo+ICAgICAgICAgICAgICAgICBwcml2LT5yeF91cmJfcGVu
ZGluZ19jb3VudCsrOw0KPiAtICAgICAgICAgICAgICAgLyoNCj4gLSAgICAgICAgICAgICAgICAq
IEFybSB0aGUgd29ya2VyIHVuZGVyIHJ4X3VyYl9sb2NrIHNvIHRoaXMgaXMgYXRvbWljIHdpdGgg
dGhlDQo+IC0gICAgICAgICAgICAgICAgKiBzaHV0ZG93biBjaGVjazogbW92aW5nIGl0IG91dCBv
ZiB0aGUgbG9jayB3b3VsZCBsZXQgYQ0KPiAtICAgICAgICAgICAgICAgICogY29tcGxldGlvbiBh
cm0gdGhlIHdvcmsgYWZ0ZXIgcnRsOHh4eHVfc3RvcCgpIGNhbmNlbGVkIGl0Lg0KPiAtICAgICAg
ICAgICAgICAgICovDQo+IC0gICAgICAgICAgICAgICBpZiAocHJpdi0+cnhfdXJiX3BlbmRpbmdf
Y291bnQgPiBSVEw4WFhYVV9SWF9VUkJfUEVORElOR19XQVRFUikNCj4gLSAgICAgICAgICAgICAg
ICAgICAgICAgc2NoZWR1bGVfd29yaygmcHJpdi0+cnhfdXJiX3dxKTsNCj4gKyAgICAgICAgICAg
ICAgIC8qIFNlcmlhbGl6ZSBzY2hlZHVsaW5nIHdpdGggdGhlIHNodXRkb3duIGNoZWNrIGFuZCBj
YW5jZWxsYXRpb24uICovDQo+ICsgICAgICAgICAgICAgICBpZiAocmV0cnkpDQo+ICsgICAgICAg
ICAgICAgICAgICAgICAgIHF1ZXVlX2RlbGF5ZWRfd29yayhzeXN0ZW1fd3EsICZwcml2LT5yeF91
cmJfd3EsDQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBtc2Vj
c190b19qaWZmaWVzKFJUTDhYWFhVX1JYX1VSQl9SRVRSWV9ERUxBWV9NUykpOw0KPiArICAgICAg
ICAgICAgICAgZWxzZSBpZiAocHJpdi0+cnhfdXJiX3BlbmRpbmdfY291bnQgPiBSVEw4WFhYVV9S
WF9VUkJfUEVORElOR19XQVRFUikNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgbW9kX2RlbGF5
ZWRfd29yayhzeXN0ZW1fd3EsICZwcml2LT5yeF91cmJfd3EsIDApOw0KDQpOb3QgcHJlZmVyIHVz
aW5nIGJhcmUgc3lzdGVtX3dxLg0KQ2FuIGJvdGggdXNlIHNjaGVkdWxlX2RlbGF5ZWRfd29yaygp
PyANCg0KPiAgICAgICAgIH0gZWxzZSB7DQo+IC0gICAgICAgICAgICAgICBza2IgPSAoc3RydWN0
IHNrX2J1ZmYgKilyeF91cmItPnVyYi5jb250ZXh0Ow0KPiAtICAgICAgICAgICAgICAgZGV2X2tm
cmVlX3NrYl9pcnEoc2tiKTsNCj4gICAgICAgICAgICAgICAgIHVzYl9mcmVlX3VyYigmcnhfdXJi
LT51cmIpOw0KPiAgICAgICAgIH0NCj4gDQoNClsuLi5dDQoNCj4gQEAgLTY1ODUsMTAgKzY1ODMs
MjMgQEAgc3RhdGljIHZvaWQgcnRsOHh4eHVfcnhfY29tcGxldGUoc3RydWN0IHVyYiAqdXJiKQ0K
PiANCj4gICAgICAgICAgICAgICAgIHNrYiA9IE5VTEw7DQo+ICAgICAgICAgICAgICAgICByeF91
cmItPnVyYi5jb250ZXh0ID0gTlVMTDsNCj4gLSAgICAgICAgICAgICAgIHJ0bDh4eHh1X3F1ZXVl
X3J4X3VyYihwcml2LCByeF91cmIpOw0KPiArICAgICAgICAgICAgICAgcnRsOHh4eHVfcXVldWVf
cnhfdXJiKHByaXYsIHJ4X3VyYiwgZmFsc2UpOw0KPiAgICAgICAgIH0gZWxzZSB7DQo+ICAgICAg
ICAgICAgICAgICBkZXZfZGJnKGRldiwgIiVzOiBzdGF0dXMgJWlcbiIsIF9fZnVuY19fLCB1cmIt
PnN0YXR1cyk7DQoNCm5pdDogYSBibGFuayBsaW5lDQoNCj4gLSAgICAgICAgICAgICAgIGdvdG8g
Y2xlYW51cDsNCj4gKyAgICAgICAgICAgICAgIHN3aXRjaCAodXJiLT5zdGF0dXMpIHsNCj4gKyAg
ICAgICAgICAgICAgIGNhc2UgLUVQUk9UTzoNCj4gKyAgICAgICAgICAgICAgIGNhc2UgLUVJTFNF
UToNCj4gKyAgICAgICAgICAgICAgIGNhc2UgLUVUSU1FOg0KPiArICAgICAgICAgICAgICAgY2Fz
ZSAtRU9WRVJGTE9XOg0KPiArICAgICAgICAgICAgICAgY2FzZSAtRUNPTU06DQo+ICsgICAgICAg
ICAgICAgICBjYXNlIC1FTk9TUjoNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgZGV2X2tmcmVl
X3NrYihza2IpOw0KPiArICAgICAgICAgICAgICAgICAgICAgICB1cmItPmNvbnRleHQgPSBOVUxM
Ow0KPiArICAgICAgICAgICAgICAgICAgICAgICBydGw4eHh4dV9xdWV1ZV9yeF91cmIocHJpdiwg
cnhfdXJiLCB0cnVlKTsNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgcmV0dXJuOw0KPiArICAg
ICAgICAgICAgICAgZGVmYXVsdDoNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgZ290byBjbGVh
bnVwOw0KPiArICAgICAgICAgICAgICAgfQ0KPiAgICAgICAgIH0NCj4gICAgICAgICByZXR1cm47
DQo+IA0KDQpbLi4uXQ0KDQo=
