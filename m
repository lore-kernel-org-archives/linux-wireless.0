Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4055831E855;
	Mon,  3 Aug 2026 02:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785725692; cv=none; b=YEkbxHh3OHSs8LfyKY8kn28kFtPkiQGNpkkdBu16Uxv7L/KlcnejELspinIqMLUgjQRtdctKX9Gc+LwCqVJ/SgpoN+iEMeKJRJ+Gr16KRUWPXGDXHKTSjWU7VbRO/OPD8PPtgSf4p4c8v1PsYfOlJH7AJFriWfv/zIYs7lFmHXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785725692; c=relaxed/simple;
	bh=zhAtrB6D/O/p8hrKiExjN21o00WMUNl5on2nLr8WwQg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZIWss2RVsDy+91edVJITohJZ5B4Qj502gh3bfS3fH2J7lyJJQIevb/06Tzb4DLqD5ir1aMmXJxYE8EQjjClmfsYOWYoOKbUfJx8TZR8ue0P01MwiVv7SdSK+Ys7v3ci7TAqMTS7nJy0jY9cwj6L62CZYJ++EfmpZ5jmMvOTQG3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=q/kv6toy; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="q/kv6toy"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6732sag073832010, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1785725676; bh=zhAtrB6D/O/p8hrKiExjN21o00WMUNl5on2nLr8WwQg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=q/kv6toyOaz87XY7Hk4eJ48P2264/kqteCMda+2KLB2/1iQ6QE0D7NaBXuDh37xXU
	 s7UvlNm3zcTOi+741kysaBcU37RwfJwFzlOvdfaasujGf4MneGOrGrCia49v/sgNBN
	 rKmJeJ3MXRgQkeoah6OqtfWTEUx5B3VUJzBl2HMF31A736SZCqajNSnI5J/yg6yExe
	 XbLeK3YHFpX8Ea0wF7xMHlBUlb6b4AyADxZusbFXq2z0ofN52WaLXaLZCDZhJdMruE
	 GjeNLQbW0QJ29nKOwCOJJQBlB4ObtjxI3CY8O7UHYe49Dgmil60/MYIapFZ9o5LEvS
	 bHA4YSYPoKKDQ==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6732sag073832010
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 3 Aug 2026 10:54:36 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 3 Aug 2026 10:54:36 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 3 Aug 2026 10:54:35 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::e6fd:5a3f:8946:92c4%10]) with mapi id
 15.02.2562.017; Mon, 3 Aug 2026 10:54:34 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Luka Gejak <luka.gejak@linux.dev>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: RE: [PATCH v2 01/11] wifi: rtw88: add the RTL8723B chip type and SDIO
 helper
Thread-Topic: [PATCH v2 01/11] wifi: rtw88: add the RTL8723B chip type and
 SDIO helper
Thread-Index: AQHdHEb43bJAs6El90WByPxHzpdzD7aA9VHggAQ6pICAAJ8VQP//0bMAgAE4QfCAAAcnAIAExo0Q
Date: Mon, 3 Aug 2026 02:54:34 +0000
Message-ID: <73128dc41c964b9eaeae0ae9a108f5b6@realtek.com>
References: <774407603bef4fd38290f6b5d4b4a26c@realtek.com>
 <20260730074504.19725-1-luka.gejak@linux.dev>
 <6c2d5972971f48548a58dc3fba890793@realtek.com>
 <6872BF49-855E-42A5-A06F-98C4602B2C25@linux.dev>
 <db7e5e0ee9fd4259a05db2e3fc08a5b1@realtek.com>
 <2AE57F1B-84FE-4BC6-A0E1-D8B61A90F3F0@linux.dev>
In-Reply-To: <2AE57F1B-84FE-4BC6-A0E1-D8B61A90F3F0@linux.dev>
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

THVrYSBHZWphayA8bHVrYS5nZWpha0BsaW51eC5kZXY+IHdyb3RlOg0KPiBPbiBKdWx5IDMxLCAy
MDI2IDM6Mjk6NDAgQU0gR01UKzAyOjAwLCBQaW5nLUtlIFNoaWggPHBrc2hpaEByZWFsdGVrLmNv
bT4gd3JvdGU6DQo+ID4gU2hvdWxkIHJlY2VpdmUgZmlsdGVyIGltcGxlbWVudCBpbiBydHdfb3Bz
X2NvbmZpZ3VyZV9maWx0ZXIoKT8NCj4gDQo+IE1vb3Qgbm93LCB0aGUgcmVjZWl2ZSBmaWx0ZXIg
aGFuZGxpbmcgZ29lcyB3aXRoIHRoZSBwYXRjaCBJIGFtDQo+IGRyb3BwaW5nLiBGb3IgdGhlIHJl
Y29yZCB5b3Ugd2VyZSBwb2ludGluZyBhdCBzb21ldGhpbmcgcmVhbCwgYWx0aG91Z2gNCj4gbm90
IHF1aXRlIHdoZXJlIEkgZmlyc3QgcGxhY2VkIGl0Lg0KPiANCj4gcnR3ODcyM2IuYyBkb2VzIHNl
ZWQgaGFsLnJjciBpbiBtYWNfaW5pdCwgc28gaXQgaXMgbm90IHRoZSBwcm9ibGVtLiBUaGUNCj4g
YXN5bW1ldHJ5IGlzIGluIHJ0d19vcHNfY29uZmlndXJlX2ZpbHRlcigpIGl0c2VsZjogZW50ZXJp
bmcgcHJvbWlzY3VvdXMNCj4gY2xlYXJzIEJJVF9DQlNTSURfQkNOIGFuZCBCSVRfQ0JTU0lEX0RB
VEEgdG9nZXRoZXIsIGJ1dCBsZWF2aW5nIGl0DQo+IHJlc3RvcmVzIG9ubHkgQklUX0NCU1NJRF9C
Q04uIENCU1NJRF9EQVRBIGlzIHRoZXJlZm9yZSBnb25lIGZyb20NCj4gaGFsLnJjciBmb3IgZ29v
ZCBhZnRlciB0aGUgZmlyc3Qgc2Nhbiwgb24gYW55IGNoaXAsIHVudGlsIHRoZSBuZXh0DQo+IG1h
Y19pbml0LiBUaGF0IGlzIHdoYXQgdGhlIHBlci1hc3NvY2lhdGlvbiBmb3JjaW5nIHdhcyBjb21w
ZW5zYXRpbmcNCj4gZm9yLg0KPiANCj4gVGhlcmUgaXMgYSBzZWNvbmQgb25lIG5leHQgdG8gaXQ6
IHJ0dzg3MjN4LmMgd3JpdGVzIFdMQU5fUkNSX0NGRw0KPiBzdHJhaWdodCB0byBSRUdfUkNSIGlu
IG1hY19pbml0IHdpdGhvdXQgcHV0dGluZyBpdCBpbnRvIGhhbC5yY3IsIHNvIG9uDQo+IDg3MjNE
IGFuZCA4NzAzQiB0aGUgZmlyc3QgY29uZmlndXJlX2ZpbHRlcigpIGNhbGwgcmVwbGFjZXMgaXQg
d2l0aCB0aGUNCj4gY29yZSBkZWZhdWx0IGZyb20gcnR3X2NvcmVfaW5pdCgpLCB3aGljaCBjYXJy
aWVzIG5laXRoZXIgQ0JTU0lEIGJpdCBub3INCj4gQU1GLg0KPiANCj4gQm90aCBsb29rIHdvcnRo
IGZpeGluZyBvbiB0aGVpciBvd24gYW5kIEkgYW0gaGFwcHkgdG8gc2VuZCB0aGF0DQo+IHNlcGFy
YXRlbHkgaWYgeW91IGFncmVlIHdpdGggdGhlIHJlYWRpbmcuIEl0IGlzIHVucmVsYXRlZCB0byB0
aGlzDQo+IHNlcmllcy4NCg0KSSdtIG5vdCBzdXJlIGlmIHRoZXNlIHNwZWNpZmljIHRoaW5ncyBh
cmUgaGFyZGx5IG5lY2Vzc2FyeS4gQXMgeW91IGhhdmUNCmRyb3BwZWQgbWFueSB1bm5lY2Vzc2Fy
eSBwYXRjaGVzIGNvcGllZCBmcm9tIHZlbmRvciBkcml2ZXIsIEkgdGhpbmsNCnlvdSBjYW4gY29u
c2lkZXIgaWYgdGhlc2UgY2FuIGJlIGRyb3BwZWQgb3IgaW50ZWdyYXRlIHRvIGV4aXN0aW5nIA0K
Y2hpcF9vcHMuIEkgbWVhbiBpZiB5b3Ugc2VlIHNvbWV3aGVyZSB5b3UgYWRkIHJ0d19pc184NzIz
YnMoKSwganVzdCBhc2sNCnlvdXJzZWxmIHRoYXQgaXMgaXQgYWN0dWFsbHkgbmVjZXNzYXJ5PyBX
aHkgZG9uJ3QgZXhpc3RpbmcgY2hpcHMgbmVlZCBpdD8NCg0KPiBIYXBweSB0byB0cnkgdGhhdC4g
RHJvcHBpbmcgdGhlIGNoaXAgdGVzdCB3b3VsZCBtYWtlIHRoZSB6ZXJvIGxlbmd0aA0KPiBjaGVj
ayBhcHBseSB0byBldmVyeSBjaGlwLCBzbyBJIHdvdWxkIHJhdGhlciBtZWFzdXJlIGl0IG9uIHRo
ZSA4NzAzQg0KPiBwYXRoIHRoYW4gYXNzdW1lOyBJIGRvIG5vdCBoYXZlIHRoYXQgaGFyZHdhcmUu
IElmIHlvdSBhcmUgY29tZm9ydGFibGUNCj4gd2l0aCBpdCBvbiBpbnNwZWN0aW9uIEkgd2lsbCBz
ZW5kIGl0IGFzIGEgc2VwYXJhdGUgcGF0Y2ggdGhhdCByZW1vdmVzDQo+IHRoZSB0ZXN0IGVudGly
ZWx5IHJhdGhlciB0aGFuIGZvbGQgaXQgaW4gaGVyZS4NCg0KSSBkb24ndCBoYXZlIGFsbCBoYXJk
d2FyZSwgc28gaXQgaXMgaGFyZCB0byBtZSB0byB2ZXJpZnkgdGhlIHplcm8gbGVuZ3RoDQpjaGVj
ay4gRXZlbiB0aG91Z2ggSSBoYXZlIGhhcmR3YXJlLCBpdCBtaWdodCBoYXBwZW4gcmFyZWx5LiBT
bywgbWF5YmUganVzdA0Ka2VlcCBpdCBhcyB3YXMuLi4gDQoNClBpbmctS2UNCg0K
