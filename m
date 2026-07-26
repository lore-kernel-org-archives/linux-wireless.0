Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E07B1ABED9;
	Sun, 26 Jul 2026 01:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785029722; cv=none; b=r91dsR3pTNFb3RL24sTCre7Ql+6pkXxlkkallUiBVDiTPbsYUJzqPvMrC6lpPBfzZTn63Z46vw+lSDrfdk43L5+qqw49Y/7hSQPJTOesabvXIWnpgocrl8zwuOK/6vHrvmRouK0z4ncu/P6Kq5eZApShsRjse6GPGszmeraF060=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785029722; c=relaxed/simple;
	bh=bWU8qEpwWbMDqgx5TEXLxspC1SVaMXdFnugbkcF2BVY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ouxe+z5bpVJ6vNVeBdz9o51anCCo0iL20zbEa9p0+8689gl2uvONThgOBV8+qhP1ew5lrkQrIPUcMM/KRzSKST8pWXiCpK48h0xdtMHHJR4pCjA/OTQHEs2SPkNvBbiMuMVBVCXaROCBL8574ttew3sk59dNlVFeQZJKABN1PJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=BfSQNV06; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="BfSQNV06"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66Q1Z2E902143558, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1785029702; bh=bWU8qEpwWbMDqgx5TEXLxspC1SVaMXdFnugbkcF2BVY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=BfSQNV06/p2F3Yu86sRsUnxf30ZlvU3rCda8ULOLm1NgBRkH/Bxl4j9nn3jYyc6qc
	 TbS08HnqwT86lxd3zkiX/xl1OpbIN6JV9GDHTZLigAZExq91q2RlYosySiBZMo4ht3
	 coRQbjok6fy2obFW8LrFH9T4FQgqv5OnVPHk5wANrm+0reBuqG16Kgk+YqoRCoIHmz
	 BrmP5tHHSI2O7HY4edAj7TBJcsTNHBvmWfTOCC1SeZPBASD8yqwjR7QqqBdfUSWLEJ
	 k0DxGRxMX2mQIQ6eKsUNgPWJ1Aq6ROHerun/IT5dIn2XtPS/SzPblL6rJ91Tzis1Pj
	 DaY9Eg6fjoinw==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66Q1Z2E902143558
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sun, 26 Jul 2026 09:35:02 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sun, 26 Jul 2026 09:35:02 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sun, 26 Jul 2026 09:35:02 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::e6fd:5a3f:8946:92c4%10]) with mapi id
 15.02.2562.017; Sun, 26 Jul 2026 09:35:02 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Bitterblue Smith <rtl8821cerfe2@gmail.com>, "luka.gejak@linux.dev"
	<luka.gejak@linux.dev>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Peter Robinson <pbrobinson@gmail.com>
Subject: RE: [PATCH 13/19] wifi: rtw88: sdio: set up RX aggregation and
 interrupts for RTL8723BS
Thread-Topic: [PATCH 13/19] wifi: rtw88: sdio: set up RX aggregation and
 interrupts for RTL8723BS
Thread-Index: AQHdG5rRupGbQ0HR0UWK68XjWP1haLZ9kyMAgAFxNlA=
Date: Sun, 26 Jul 2026 01:35:02 +0000
Message-ID: <25a64bfc14c14c9ebe544d5d55bc8a45@realtek.com>
References: <20260724181858.192903-1-luka.gejak@linux.dev>
 <20260724183235.196908-1-luka.gejak@linux.dev>
 <8ded63af-64cf-484b-977b-e4458278f9c1@gmail.com>
In-Reply-To: <8ded63af-64cf-484b-977b-e4458278f9c1@gmail.com>
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

Qml0dGVyYmx1ZSBTbWl0aCA8cnRsODgyMWNlcmZlMkBnbWFpbC5jb20+IHdyb3RlOg0KPiBPbiAy
NC8wNy8yMDI2IDIxOjMyLCBsdWthLmdlamFrQGxpbnV4LmRldiB3cm90ZToNCj4gPiBGcm9tOiBM
dWthIEdlamFrIDxsdWthLmdlamFrQGxpbnV4LmRldj4NCj4gPg0KPiA+IEVuYWJsZSB0aGUgZXhp
c3RpbmcgUlggYWdncmVnYXRpb24gc2V0dXAgZm9yIHRoaXMgY2hpcCBhbmQgc2VsZWN0IHRoZQ0K
PiA+IGxhcmdlciBETUEgYWdncmVnYXRpb24gbW9kZSBpdCBuZWVkcy4gVGhlIFJUTDg3MjNCUyBk
b2VzIG5vdCByYWlzZQ0KPiA+IENQV00xLCBzbyBsZWF2ZSB0aGF0IHNvdXJjZSBvdXQgb2YgaXRz
IGludGVycnVwdCBtYXNrLCBhbmQgc2V0IHRoZSBTRElPDQo+ID4gVFggY29udHJvbCBiaXQgdGhl
IHZlbmRvciBkcml2ZXIgdXNlcyB0byBoYXZlIHRyYW5zZmVycyBhbHdheXMNCj4gPiByZWNvZ25p
c2VkLg0KPiA+DQo+ID4gSW50ZXJydXB0IHN0YXR1cyBpcyBhbHNvIGFja25vd2xlZGdlZCBkaWZm
ZXJlbnRseTogd3JpdGUgYmFjayBvbmx5IHRoZQ0KPiA+IGJpdHMgdGhhdCBhcmUgYWN0dWFsbHkg
ZGVmaW5lZCwgYW5kIGZvciB0aGlzIGNoaXAgb25seSB0aG9zZSB0aGF0IGFyZQ0KPiA+IHVubWFz
a2VkLCByYXRoZXIgdGhhbiB3cml0aW5nIHRoZSByYXcgc3RhdHVzIHdvcmQgYmFjay4gV3JpdGlu
ZyBiYWNrDQo+ID4gdW5kZWZpbmVkIGJpdHMgbGVhdmVzIHRoZSBSVEw4NzIzQlMgcmFpc2luZyBh
IHBlcnNpc3RlbnQgaW50ZXJydXB0IGFmdGVyDQo+ID4gcmVzdW1lLiBOb3RlIHRoYXQgcmVzdHJp
Y3RpbmcgdGhlIGFja25vd2xlZGdtZW50IHRvIGRlZmluZWQgYml0cw0KPiA+IGFwcGxpZXMgdG8g
dGhlIG90aGVyIFNESU8gcGFydHMgYXMgd2VsbC4NCj4gDQo+IFdoeSBkb2VzIGl0IGFwcGx5IHRv
IHRoZSBvdGhlcnM/DQoNCkx1a2EsIGNvdWxkIHlvdSBhbnN3ZXIgQml0dGVyYmx1ZSdzIHF1ZXN0
aW9ucyBiZWZvcmUgc2VuZGluZyB2Mj8NCllvdSBtaWdodCB3cml0ZSB0aGUgY2hhbmdlIGluIGNv
dmVyIGxldHRlciBvZiB2MiwgYnV0IGl0IGlzIHZlcnkgaGFyZA0KZm9yIHJldmlld2VycyB0byBr
bm93IGlmIHlvdSBkaWQgY2hhbmdlcyBiYXNlZCBvbiByZXZpZXdlcnMnIG9waW5pb25zDQpvciB5
b3UgaGF2ZSBkaWZmZXJlbnQgcmVhc29ucy4gTW9yZSwgcGxlYXNlIGdpdmUgcmV2aWV3ZXJzIG1v
cmUgdGltZSB0bw0KZGlzY3VzcyBlbnRpcmVseS4gSSBkb24ndCBrbm93IHRoYXQgSSBzaG91bGQg
cmVwbHkgeW91ciB2MSBvciB2MiBvciBSRkM/DQoNCkkgYWRtaXQgdGhhdCBJIGhhdmUgbm90IHll
dCByZXZpZXdlZCB5b3VyIHBhdGNoZXMsIGJ1dCBpdCBnZXRzIGhhcmRlcg0KdG8gbWUgc2luY2Ug
dGhlcmUgYXJlIG1hbnkgdmVyc2lvbnMuIA0KDQpQaW5nLUtlDQoNCg==
