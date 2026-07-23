Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A6C2BCF46;
	Thu, 23 Jul 2026 01:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784769674; cv=none; b=jK7QpTK2jbUl99oi1rG5R2dgTOQXHVZphwAT2pwMrg7xItl7ggwXOx9H+srKdHjpFMIaKd3QPOXK9Z8fuwhQo5iliryhSb+nFpTOcHuoHBMDynMn99vRGsTbrLLMoKiUOk5xYQyUK9CD/4LDMSHp5yiknqIspsoxtCrLLu8jI3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784769674; c=relaxed/simple;
	bh=l+BcWxEYxghnenlldtXOwu+zC99qYehVhMZWM49Kkzk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=On6T/Tt7LaKEjyhiWfgOQUb2DZYaD1Irof5mXfqyA33GRGZ3dcKxq501M6Xvd10UffSCRhzW9WzRoxmbEFmGzuz9jyQiRTFmuJoHsO8TdCsQmOnQaUhYAUi/jQR+fv4AZACE+ZMo8bPvr8xglU5uey9QXLNY77xbD0KLcR1N2cY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=HV/hg6pu; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="HV/hg6pu"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66N1JmFU2096485, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784769588; bh=l+BcWxEYxghnenlldtXOwu+zC99qYehVhMZWM49Kkzk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=HV/hg6puvpwQe9ORCUlxRgkV/B22MlLrGYspS1yYlv80QkBDjvjTBORNAWpBvckxP
	 hcf3621kkn+yWd8jQiKIbCzljy1OpmY9yGZiGD7ZSk0rSovfktxcUKiJESd7162HCK
	 OEZ4mmxIHg7iA9qXia99x9Rn82qU39ewR0CuGvRCJTPoAR+sa/jM026szBRPb0JQlY
	 2R/0Ie1yW3L9pW/XMQuFefhditcPVTdUOmVH6bwcgynk17W89d9FAMBifc94kfxXPD
	 HHi7dbOtXZ0aTBy1jlBcnoQFLk9u45FELFf4xMrlxUhxWy04AaWSv/n2T28NxMncSs
	 I6WM2YNJz5DnA==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66N1JmFU2096485
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 23 Jul 2026 09:19:48 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 23 Jul 2026 09:19:48 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 23 Jul 2026 09:19:48 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::e6fd:5a3f:8946:92c4%10]) with mapi id
 15.02.2562.017; Thu, 23 Jul 2026 09:19:48 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>, Bjorn Helgaas
	<bhelgaas@google.com>, Yixun Lan <dlan@kernel.org>, Lorenzo Pieralisi
	<lpieralisi@kernel.org>, =?utf-8?B?S3J6eXN6dG9mIFdpbGN6ecWEc2tp?=
	<kwilczynski@kernel.org>, Manivannan Sadhasivam <mani@kernel.org>, "Rob
 Herring" <robh@kernel.org>, Inochi Amaoto <inochiama@gmail.com>, "Aurelien
 Jarno" <aurelien@aurel32.net>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
	"spacemit@lists.linux.dev" <spacemit@lists.linux.dev>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH v2 1/2] PCI: Move Spacemit vendor and device IDs to
 linux/pci_ids.h
Thread-Topic: [PATCH v2 1/2] PCI: Move Spacemit vendor and device IDs to
 linux/pci_ids.h
Thread-Index: AQHdFXehTbmbDPtnB0KyE0vFNWAFDLZ6Vr7g
Date: Thu, 23 Jul 2026 01:19:47 +0000
Message-ID: <073fbf4b41804285b2df6fbb4efce0ed@realtek.com>
References: <20260716-rtw89-spacemit-k3-v2-0-392b577ebf75@oss.tenstorrent.com>
 <20260716-rtw89-spacemit-k3-v2-1-392b577ebf75@oss.tenstorrent.com>
In-Reply-To: <20260716-rtw89-spacemit-k3-v2-1-392b577ebf75@oss.tenstorrent.com>
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

SGkgUENJIG1haW50YWluZXJzLA0KDQpBbmlydWRoIFNyaW5pdmFzYW4gPGFzcmluaXZhc2FuQG9z
cy50ZW5zdG9ycmVudC5jb20+IHdyb3RlOg0KPiBNb3ZlIHRoZSB2ZW5kb3IgYW5kIGRldmljZSBJ
RCBmb3IgdGhlIGV4aXN0aW5nIFNwYWNlbWl0IEsxIFBDSWUgUm9vdA0KPiBDb21wbGV4IHRvIGlu
Y2x1ZGUvbGludXgvcGNpX2lkcy5oLiBBbHNvIGFkZCBLMydzIFJvb3QgQ29tcGxleCBkZXZpY2Ug
SUQNCj4gdG8gdGhpcyBoZWFkZXIuIFRoaXMgaXMgZG9uZSBzbyB0aGF0IHRoZXNlIHZhbHVlcyBj
YW4gYmUgcmVmZXJlbmNlZCBpbg0KPiB0aGUgcnR3ODkgZHJpdmVyIHRvIGVuYWJsZSAzNi1iaXQg
RE1BIGFiaWxpdHkgaW4gaXQgZm9yIFdpRmkgdG8gZnVuY3Rpb24NCj4gb24gdGhlIEszIFBpY28g
SVRYIGJvYXJkLg0KPiANCj4gQWNrZWQtYnk6IEJqb3JuIEhlbGdhYXMgPGJoZWxnYWFzQGdvb2ds
ZS5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IEFuaXJ1ZGggU3Jpbml2YXNhbiA8YXNyaW5pdmFzYW5A
b3NzLnRlbnN0b3JyZW50LmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJzL3BjaS9jb250cm9sbGVyL2R3
Yy9wY2llLXNwYWNlbWl0LWsxLmMgfCAzIC0tLQ0KPiAgaW5jbHVkZS9saW51eC9wY2lfaWRzLmgg
ICAgICAgICAgICAgICAgICAgICAgIHwgNCArKysrDQo+ICAyIGZpbGVzIGNoYW5nZWQsIDQgaW5z
ZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Bj
aS9jb250cm9sbGVyL2R3Yy9wY2llLXNwYWNlbWl0LWsxLmMNCj4gYi9kcml2ZXJzL3BjaS9jb250
cm9sbGVyL2R3Yy9wY2llLXNwYWNlbWl0LWsxLmMNCj4gaW5kZXggYmUyMGE1MjAyNTViNi4uZjg5
YzZkNDZjNzY4NCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9wY2kvY29udHJvbGxlci9kd2MvcGNp
ZS1zcGFjZW1pdC1rMS5jDQo+ICsrKyBiL2RyaXZlcnMvcGNpL2NvbnRyb2xsZXIvZHdjL3BjaWUt
c3BhY2VtaXQtazEuYw0KPiBAQCAtMjEsOSArMjEsNiBAQA0KPiANCj4gICNpbmNsdWRlICJwY2ll
LWRlc2lnbndhcmUuaCINCj4gDQo+IC0jZGVmaW5lIFBDSV9WRU5ET1JfSURfU1BBQ0VNSVQgICAg
ICAgICAweDIwMWYNCj4gLSNkZWZpbmUgUENJX0RFVklDRV9JRF9TUEFDRU1JVF9LMSAgICAgIDB4
MDAwMQ0KPiAtDQo+ICAvKiBPZmZzZXRzIGFuZCBmaWVsZCBkZWZpbml0aW9ucyBmb3IgbGluayBt
YW5hZ2VtZW50IHJlZ2lzdGVycyAqLw0KPiAgI2RlZmluZSBLMV9QSFlfQUhCX0lSUV9FTiAgICAg
ICAgICAgICAgICAgICAgICAweDAwMDANCj4gICNkZWZpbmUgUENJRV9JTlRFUlJVUFRfRU4gICAg
ICAgICAgICAgIEJJVCgwKQ0KPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9wY2lfaWRzLmgg
Yi9pbmNsdWRlL2xpbnV4L3BjaV9pZHMuaA0KPiBpbmRleCAxYzlkNDBlMDkxMDdkLi5kNmYyNmNh
Y2M4ZTM1IDEwMDY0NA0KPiAtLS0gYS9pbmNsdWRlL2xpbnV4L3BjaV9pZHMuaA0KPiArKysgYi9p
bmNsdWRlL2xpbnV4L3BjaV9pZHMuaA0KPiBAQCAtMjY0MCw2ICsyNjQwLDEwIEBADQo+ICAjZGVm
aW5lIFBDSV9WRU5ET1JfSURfU1VOSVggICAgICAgICAgICAweDFmZDQNCj4gICNkZWZpbmUgUENJ
X0RFVklDRV9JRF9TVU5JWF8xOTk5ICAgICAgIDB4MTk5OQ0KPiANCj4gKyNkZWZpbmUgUENJX1ZF
TkRPUl9JRF9TUEFDRU1JVCAgICAgICAgIDB4MjAxZg0KPiArI2RlZmluZSBQQ0lfREVWSUNFX0lE
X1NQQUNFTUlUX0sxICAgICAgMHgwMDAxDQo+ICsjZGVmaW5lIFBDSV9ERVZJQ0VfSURfU1BBQ0VN
SVRfSzMgICAgICAweDAwMDINCj4gKw0KPiAgI2RlZmluZSBQQ0lfVkVORE9SX0lEX0hJTlQgICAg
ICAgICAgICAgMHgzMzg4DQo+ICAjZGVmaW5lIFBDSV9ERVZJQ0VfSURfSElOVF9WWFBST0lJX0lE
RSAweDgwMTMNCg0KQXMgcGF0Y2ggMi8yIG9idmlvdXNseSBnb2VzIHRvIHdpcmVsZXNzLW5leHQg
dHJlZSwgY2FuIEkgdGFrZSB0aGlzIA0KZGVwZW5kZW5jeSBwYXRjaCB0byBteSB0cmVlPyANCg0K
UGluZy1LZQ0KDQoNCg==
