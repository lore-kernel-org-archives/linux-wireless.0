Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C392C86D
	for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 01:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786412932; cv=none; b=XyOqbFDafSkiQgyvvT1TQiDkJrBMCf0quQyhbXq19Xu8+3KM3qRBeOT8a9rS+F5B6HfR1k1lcpttV++mGJbmPGYUIu4ec5/+8Zi52rNCbkKbyw/XmtFm4qQgp0NilqbegHbO79s3e8z17PyXv6p890VqjxKqeBmc2HHC5FdbE18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786412932; c=relaxed/simple;
	bh=PFT78P3V7FaLPcguJCctSxHJFgOpnpFA3uF988EGXW4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=l+Ho+ghnI6c+7cWDI+Z7k3n3M8prCsV58bMv1Ux7OsuRlALSbvIyLvbcBqb55Pj0xOJBQum61lxCVbGolMwXKwlW1ehPl61feM3a/w83BghQsSvjKfeP8hlfcbvgtrVDc2YvtoCjW/GjeG8TQZweiGP4rBTLXjhkyuccW15qWCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=KSY/gDxI; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="KSY/gDxI"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67B1mkUG32191702, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1786412926; bh=PFT78P3V7FaLPcguJCctSxHJFgOpnpFA3uF988EGXW4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=KSY/gDxI7hqU13HenHjQECrXMCbn7gfuKQLKg6A/F+WRXXpfK6S7nHgFnXS/QU4Je
	 ukqUCzyOs7IT4uSlt/kr2qJ0Mz//6wVyn0RRC+hllaHex9x1XWKzW01UW47x5NY9AQ
	 IaU5I7j+GAyfYoXMqfP8gp7jEn8tcOGnrzaxc/XHeHXLSi7mpr5l3U+my1q5f+oZ+j
	 0UoMrvgKuEDLO4X12SADRs+TrqZN2wSmuy8TRcqm3PQZnIt8tpgRCuFOHWTa9ioFSU
	 cmV83Idsa3uwvzq9K8e66bbsE+L8kXCMcieasi7TwkVcIG1w0em5v2rfNd5Nz1xZ6q
	 JL9vD408xeKdA==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67B1mkUG32191702
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 11 Aug 2026 09:48:46 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 11 Aug 2026 09:48:46 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 11 Aug 2026 09:48:45 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Tue, 11 Aug 2026 09:48:45 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Adrodoc <adrodoc55@googlemail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: Error in rtw89 using Kernel 7.1.4
Thread-Topic: Error in rtw89 using Kernel 7.1.4
Thread-Index: AQHdHdZdU24pRS7N10KrgD20Ysr2qbaCFWPAgAAJV2CAAAS0AIAAjzyAgAD0dVCAAAXTgIAAAl0AgAn324CAAQ3XcP//9hYAgABhDACAB7IeQP//21yAgAGLWLA=
Date: Tue, 11 Aug 2026 01:48:45 +0000
Message-ID: <c52840cf65464f659635eec6fcd6de12@realtek.com>
References: <CAOQMLZVB3_wedJ89yNoCKTXOsuXWNq+T785bVQBSr3Yh-TPqeA@mail.gmail.com>
 <ea2f5ee46c064fb9b3a45e9d705e2f59@realtek.com>
 <1f8a2a023b064bca87a8f1e6712bca3d@realtek.com>
 <CAOQMLZWhvwxTk9PNa0E=73pBOoah8X-2C+xN5-VY_gCSVtBkVg@mail.gmail.com>
 <CAOQMLZWpPDbm5yiBg89GjzXnCwuQn+t5V=AP617MoH6q8Zu2zw@mail.gmail.com>
 <fe2f2e2a52ed4565b5c2927d872d82cc@realtek.com>
 <CAOQMLZU31dc6ZvNi_veM6uU1fSXYNBdnWLkOwH5xXR45uOFx1w@mail.gmail.com>
 <CAOQMLZWPMq=CCFpdg5wwsJ_QnrUKx_0YouTxdaSePO_0YPqcLA@mail.gmail.com>
 <CAOQMLZUn30NJwU4pR0hL=nz38Mbp=73wgqd+CoQE2qSO3cf4_w@mail.gmail.com>
 <013f7d3cf223417c94df41a2a45fa540@realtek.com>
 <CAOQMLZXiOBsjn=UEO6UryngzkfCzKdo+Xa1RmE_vTtZoFKN0Ew@mail.gmail.com>
 <CAOQMLZVMALBLeCZUB3Jdvk75znt0D7HxrXyPMhGPvcKLx3j-Yg@mail.gmail.com>
 <0912165f66394229b4f2b4114ae28a50@realtek.com>
 <CAOQMLZUbZhNhOQyxGXW7YSOU-z6w-4jWqfqVkaeMhdx2kLDrmg@mail.gmail.com>
In-Reply-To: <CAOQMLZUbZhNhOQyxGXW7YSOU-z6w-4jWqfqVkaeMhdx2kLDrmg@mail.gmail.com>
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

QWRyb2RvYyA8YWRyb2RvYzU1QGdvb2dsZW1haWwuY29tPiB3cm90ZToNCj4gPiBCeSB0aGUgd2F5
LCB0aGUgZmlyc3QgbG9nIHlvdSBzaGFyZWQgc2hvd3MgdGhhdCBkaXNjb25uZWN0aW9uIGhhcHBl
bmVkIGFmdGVyIFNFUiBMMSBhYm91dCA1MCBzZWNvbmRzLg0KPiBTRVIgTDEgc2VlbXMgbm90IGEg
cmVsYXRlZCBldmVudC4NCj4gDQo+IEkgYW0gcHJldHR5IHN1cmUgU0VSIEwxIChvciBtYXliZSAi
ZmlybXdhcmUgZmFpbGVkIHRvIGFjayBmb3IgbGVhdmluZw0KPiBwcyBtb2RlIikgaXMgYSByZWxl
dmFudCBldmVudCwgYmVjYXVzZSB0aGUgY29ubmVjdGlvbiB3YXMgbm90DQo+IGZ1bmN0aW9uaW5n
IHByb3Blcmx5IGR1cmluZyB0aGVzZSA1MCBzZWNvbmRzLg0KDQpGb3IgbGF0ZXIgZXhwZXJpbWVu
dHMgKHN1Y2ggYXMga2VybmVsIDYuNi45KSwgZGlkIHlvdSBhbHNvIGNvbmZpcm0gdGhpcyBhZnRl
cg0KU0VSIGhhcHBlbmVkPyBNYXliZSwgeW91IGNhbiBhIHBpbmcgd2l0aCB0aW1lc3RhbXAgaW4g
YmFja2dyb3VuZDoNCg0KICAgcGluZyA4LjguOC44IHwgd2hpbGUgcmVhZCBkdDsgZG8gZWNobyAi
JChkYXRlICcrJVktJW0tJWQgJUg6JU06JVMnKSAtICRkdCI7IGRvbmUNCg0KPiA+IFRoZSBzZWNv
bmQgd2F5IGlzIHRvIGRlYnVnIG9uIHRoZSBsYXRlc3Qga2VybmVsIGFuZCBhcHBseSBkZWJ1ZyBw
YXRjaCB0byBkdW1wIG1vcmUgZGV0YWlsIG5lZWRlZCBieQ0KPiBpbnRlcm5hbCBleHBlcnRzLiBC
dXQgaXQgc2VlbXMgbGlrZSB0aGlzIGlzIHN0aWxsIHVuY2VydGFpbiBiZWNhdXNlIG9mIGhhcmR3
YXJlIGZsYXcgdGhleSBtZW50aW9uZWQuDQo+IA0KPiBJcyB0aGF0IHN0aWxsIGFuIG9wdGlvbj8g
SSB0aGluayBpdCBtaWdodCB5aWVsZCByZXN1bHRzIGZhc3Rlci4gU2luY2UNCj4gSSBoYXZlIHRv
IGtlZXAgYSBrZXJuZWwgcnVubmluZyBmb3IgYWJvdXQgYSBkYXkgdG8gbWFrZSBzdXJlIGl0DQo+
IGRvZXNuJ3QgaGF2ZSB0aGUgZGlzY29ubmVjdCBpc3N1ZSwgYmlzZWN0aW5nIHdpbGwgdGFrZSBx
dWl0ZSBzb21lDQo+IHRpbWUuDQoNClRoZSBwYXRoIHRvIGRlYnVnIFNFUiBkdW1wIGlzIGxvbmdl
ciwgYmVjYXVzZSBJIHBlcnNvbmFsbHkgZG9uJ3QgdW5kZXJzdGFuZA0KdGhlIG51bWJlcnMsIHNv
IEkgd2lsbCBuZWVkIGludGVybmFsIGV4cGVydHMgdG8gaGVscCBhbmFseXppbmcgeW91ciBmZWVk
YmFjay4gDQpTaW5jZSBSVEw4ODUyQUUgaXMgZWFybGllciBjaGlwLCB0aGUgcHJvZ3Jlc3Mgd2ls
bCBiZSBzbG93ZXIuIFNvIGJlIHBhdGllbnQNCmlmIHdlIGNob29zZSB0aGlzIHdheS4NCg0KUGVy
c29uYWxseSBJIHByZWZlciB0byBiaXNlY3Qga2VybmVsIGZpcnN0ICh0aG91Z2ggaXQgdGFrZXMg
dGltZSB0b28pLg0KSWYgdGhlIGNhdXNlIGlzbid0IGZyb20gZHJpdmVyIHNpZGUsIGxldCdzIG1v
dmUgdG8gZGVidWcgU0VSIGR1bXAuIA0KDQoNCg==
