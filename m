Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C12535893;
	Fri, 31 Jul 2026 01:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785461393; cv=none; b=nQnyuEXnnRa+rcelXMucWjSEZU0DAKjZUISO/cN92gzSiNpM6AZ56pFn6prgkj+YpEDNEHKGFdeuzUO7Neom+C9ragsDIyaSrPmAeVYXL++TCQ3Zdo5CS6Aq+7QbiWEccc2BjWqMLFwbA2HzOZf25EC3qsnTuf+n8CdlNOHHRPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785461393; c=relaxed/simple;
	bh=dZunTpYfEoNwfACPFjr8TmXl1ZAkUBEglPDXm0VHzHg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WoMmgo87AnMmpNBr5tlFkKDZsbBVomdNT09dxU4JoHNNMtnJtZ0+v7de/AoPMp/8Hfdb+RkCVn67jAvwTePPPUV7wUnHc0QtkTYvifN0ZXO6127a3TgS9oDmS/qHgiPd5C5E+L7pqcdnvCMJC+rcwP4rSB9/bWRhKTABxUimOBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=KuLR9aFB; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="KuLR9aFB"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66V1TeYeA1558825, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1785461380; bh=dZunTpYfEoNwfACPFjr8TmXl1ZAkUBEglPDXm0VHzHg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=KuLR9aFBMU876y/Y5drJj5HS7Y1tfotyvVKx/g/3J3VG+b+ngIAPm302o3vK9y2vj
	 5fiEDcibyEocFP87B2sSIEf2HABWzZ1cS+eRPm9IYiwsGj/9Hakk1ECokPIqpYGMXa
	 dQ3a1+RiS5dZq1MScnF+am7h1VZ1YCpO42LJ28QB57loDCQHtmW53/BpNt/W2/O/nJ
	 hJ4RiibH5yVH2RgohQrIOFfmuZzKDAsq/UoKFMYRUlkYRs0bCmufwdQ0xB4dExb3sV
	 +nHdhbArudYHOY+ywtB+V29WEisAPWF/36vuBakm2rgUM2LNPwLO08PaT1anuuBqUI
	 sajp7vFvFtldg==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66V1TeYeA1558825
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 31 Jul 2026 09:29:40 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 31 Jul 2026 09:29:41 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 31 Jul 2026 09:29:40 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::e6fd:5a3f:8946:92c4%10]) with mapi id
 15.02.2562.017; Fri, 31 Jul 2026 09:29:40 +0800
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
Thread-Index: AQHdHEb43bJAs6El90WByPxHzpdzD7aA9VHggAQ6pICAAJ8VQP//0bMAgAE4QfA=
Date: Fri, 31 Jul 2026 01:29:40 +0000
Message-ID: <db7e5e0ee9fd4259a05db2e3fc08a5b1@realtek.com>
References: <774407603bef4fd38290f6b5d4b4a26c@realtek.com>
 <20260730074504.19725-1-luka.gejak@linux.dev>
 <6c2d5972971f48548a58dc3fba890793@realtek.com>
 <6872BF49-855E-42A5-A06F-98C4602B2C25@linux.dev>
In-Reply-To: <6872BF49-855E-42A5-A06F-98C4602B2C25@linux.dev>
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

DQpMdWthIEdlamFrIDxsdWthLmdlamFrQGxpbnV4LmRldj4gd3JvdGU6DQo+IE9uIEp1bHkgMzAs
IDIwMjYgMTE6MTc6NDEgQU0gR01UKzAyOjAwLCBQaW5nLUtlIFNoaWggPHBrc2hpaEByZWFsdGVr
LmNvbT4gd3JvdGU6DQo+ID5sdWthLmdlamFrQGxpbnV4LmRldiA8bHVrYS5nZWpha0BsaW51eC5k
ZXY+IHdyb3RlOg0KPiA+PiBpdCB3b3VsZCBiZSBmb3VyIGNhbGxiYWNrcyAoZnJlZSBwYWdlIGNo
ZWNrLCBwYWdlDQo+ID4+IGFjY291bnRpbmcsIG91dHB1dCBxdWV1ZSB3YWl0LCB0cmFuc2ZlciBz
aXppbmcpIGFuZCBJIGRpZCBub3Qgd2FudCB0bw0KPiA+PiBpbnRyb2R1Y2UgdGhhdCBzdHJ1Y3R1
cmUgd2l0aG91dCBhc2tpbmcgZmlyc3QuDQo+ID4gSWYgdGhlc2UgYXJlIGNhbGxlZCBmcm9tIHNk
aW8uYywganVzdCBjaGVjayBjaGlwIElEIGluIHNkaW8uYy4NCj4gDQo+IFRoYXQgaXMgd2hhdCB2
MyBhbHJlYWR5IGRvZXMsIHNvIG5vdGhpbmcgY2hhbmdlcyB0aGVyZS4gQWxsIGZvdXIgYXJlDQo+
IHJlYWNoZWQgZnJvbSBzZGlvLmMgb25seS4NCj4gDQo+ID4gSWYgdGhleSBhcmUgdXNlZCBieSBj
b21tb24gZmxvdyBsaWtlIGNvZXguYywgSSBwcmVmZXIgdG8gaW1wbGVtZW50DQo+ID4gdGhlbSBi
eSBjaGlwX29wcy4NCj4gDQo+IExldCBtZSBsaXN0IHRoZW0gYWxsIHNvIHlvdSBjYW4gcnVsZSBv
biBhbGwgb2YgdGhlbSBhdCBvbmNlIHJhdGhlciB0aGFuDQo+IGEgZmlsZSBhdCBhIHRpbWUuDQo+
IA0KPiBUd28gZ28gcmVnYXJkbGVzcyBvZiB5b3VyIGFuc3dlcjogdGhlIGNoaXAgdGVzdCBpbnNp
ZGUNCj4gcnR3ODcyM2JzX2FwcGx5X2Jhc2ljX3JhdGVzKCkgYW5kIHJ0dzg3MjNic19hcHBseV9i
c3NfY2FwKCkgaXMNCj4gcmVkdW5kYW50LCBib3RoIGNhbGxlcnMgYWxyZWFkeSBlc3RhYmxpc2gg
dGhlIGNoaXAuIEluIHRoZSBzZWNvbmQgb25lDQo+IHRoZSBOTDgwMjExX0lGVFlQRV9TVEFUSU9O
IGhhbGYgb2YgdGhlIHNhbWUgZ3VhcmQgaXMgc3RpbGwgbmVlZGVkLCBzbw0KPiBvbmx5IHRoZSBj
aGlwIGhhbGYgZ29lcyB0aGVyZS4NCj4gDQo+IFRoYXQgbGVhdmVzIHRoZSBmb2xsb3dpbmcgb3V0
c2lkZSBzZGlvLmMuDQo+IA0KPiBjb2V4LmMsIDIgc2l0ZXM6DQo+IA0KPiAgIHJ0d19jb2V4X3Nj
YW5fbm90aWZ5KCkgICAgLT4gcnR3X2NvZXhfODcyM2JzX3NjYW5fbm90aWZ5KCkNCj4gICBydHdf
Y29leF9jb25uZWN0X25vdGlmeSgpIC0+IHJ0d19jb2V4Xzg3MjNic19jb25uZWN0X25vdGlmeSgp
DQo+IA0KPiAgIEVhY2ggdGVzdHMgdGhlIGNoaXAgYW5kIGJ0X2Rpc2FibGVkIG9uY2UgYW5kIHJl
dHVybnMgdHJ1ZSB3aGVuIGl0IGhhcw0KPiAgIGhhbmRsZWQgdGhlIG5vdGlmaWNhdGlvbjsgZXZl
cnl0aGluZyBiZWxvdyB0aGVtIGFzc3VtZXMgYm90aC4NCj4gDQo+IG1hYzgwMjExLmMsIDYgc2l0
ZXMgaW4gcnR3X29wc19ic3NfaW5mb19jaGFuZ2VkKCk6IHRoZSByZWNlaXZlIGZpbHRlcg0KDQpT
aG91bGQgcmVjZWl2ZSBmaWx0ZXIgaW1wbGVtZW50IGluIHJ0d19vcHNfY29uZmlndXJlX2ZpbHRl
cigpPw0KDQo+IG9uIGFzc29jIGFuZCBvbiBkaXNhc3NvYywgQlNTSUQgY2hhbmdlIGJvb2trZWVw
aW5nLCBhbmQgdGhlDQo+IEJTU19DSEFOR0VEX0VSUF9QUkVBTUJMRSBhbmQgQlNTX0NIQU5HRURf
RVJQX1NMT1QgaGFuZGxlcnMuDQo+IA0KPiBtYWM4MDIxMS5jLCAyIHNpdGVzIGluIHJ0d19vcHNf
c2V0X2tleSgpOiBlbmFibGluZyBhbmQgZGlzYWJsaW5nDQo+IGRlZmF1bHQga2V5IHNlYXJjaCBm
b3IgZ3JvdXAga2V5cy4NCg0KUGxlYXNlIGNoZWNrIGV4aXN0aW5nIGNvZGVzIHJlbGF0ZWQgdG8g
c2VjLT5kZWZhdWx0X2tleV9zZWFyY2ggdG8gc2VlDQpob3cgdG8gc3VwcG9ydCBSVEw4NzIzQlMg
YnkgdGhlIHNhbWUgZmxvdy4NCg0KPiANCj4gcnguYywgMSBzaXRlIGluIHJ0d19yeF9maWxsX3J4
X3N0YXR1cygpLCB0aGUgemVybyBsZW5ndGggcGFja2V0IHRlc3QuDQo+IFRoaXMgb25lIHJ1bnMg
cGVyIHJlY2VpdmVkIGZyYW1lLCBzbyBhbiBpbmRpcmVjdCBjYWxsIHRoZXJlIGxvb2tzIGxpa2UN
Cj4gdGhlIHdyb25nIHRyYWRlIHRvIG1lLiBJIHdvdWxkIGtlZXAgaXQgaW5saW5lIHVubGVzcyB5
b3UgZGlzYWdyZWUuDQoNCkkgZG9uJ3Qgb2JqZWN0IHRoaXMuIE1vcmUsIEknbSBjb25zaWRlcmlu
ZyBpZiBubyBuZWVkIHRvIGNoZWNrIGNoaXBzLCBqdXN0DQpiZSBhIGNvbW1vbiBmbG93LiAgDQoN
Cj4gDQo+IGZ3LmMsIDEgc2l0ZSBpbiBydHdfZndfd3JpdGVfZGF0YV9yc3ZkX3BhZ2UoKSwgdHdv
IHJlZ2lzdGVyDQo+IHNhdmUvcmVzdG9yZSBibG9ja3MgaW50ZXJsZWF2ZWQgd2l0aCB0aGUgZ2Vu
ZXJpYyBvbmVzLiBJIGRvIG5vdCBzZWUgaG93DQo+IHRvIGxpZnQgdGhvc2UgaW50byBhbiBvcCB3
aXRob3V0IHJlc3RydWN0dXJpbmcgdGhlIHdob2xlIGZ1bmN0aW9uLCBzbyBJDQo+IHdvdWxkIGtl
ZXAgdGhhdCBpbmxpbmUgdG9vLg0KDQpUaGF0IGxvb2tzIGZpbmUuIEkgcmVtZW1iZXIgSSBkb24n
dCBoYXZlIGNvbW1lbnRzIG9uIHRoaXMgcGFydCwgbm8/DQoNCj4gDQo+IEZvciBjb2V4LmMgYW5k
IHRoZSB0d28gbWFjODAyMTEuYyBjYWxsYmFja3MgSSBhbSBoYXBweSB0byBhZGQgb3BzLiBPbmUN
Cj4gY29uc3RyYWludCBvbiBjb2V4LmM6IHRoZSA4NzIzQlMgY29kZSBjYWxscyBydHdfY29leF9z
ZXRfYW50X3BhdGgoKSBhbmQNCj4gcnR3X2NvZXhfc2V0X3RhYmxlKCksIHdoaWNoIGFyZSBzdGF0
aWMgaW4gY29leC5jLiBJbXBsZW1lbnRpbmcgdGhlIG9wcw0KPiBpbiBydHc4NzIzYi5jIHdvdWxk
IG1lYW4gbWFraW5nIHRob3NlIHR3byBub24tc3RhdGljLCB3aGljaCBzZWVtcyB3b3JzZQ0KPiB0
aGFuIHRoZSBjaGlwIHRlc3QgaXQgcmVwbGFjZXMuIFdoYXQgSSBoYWQgaW4gbWluZCBpcyBsZWF2
aW5nIHRoZQ0KPiBmdW5jdGlvbnMgaW4gY29leC5jLCBkZWNsYXJpbmcgdGhlbSBpbiBjb2V4Lmgs
IGFuZCBoYXZpbmcgcnR3ODcyM2IuYw0KPiBwb2ludCB0aGUgb3BzIGF0IHRoZW0sIHRoZSBzYW1l
IHNoYXBlIGFzIHRoZSBjaGlwX29wczo6cHJlcGFyZV90eCB0aGF0DQo+IHYzIGFkZHMgZm9yIHRo
ZSBhc3NvY2lhdGlvbiBzZXF1ZW5jZS4gVGhlIGdlbmVyaWMgaGVscGVycyBzdGF5IHN0YXRpYw0K
PiB0aGF0IHdheS4NCg0KRGlkIHlvdSBtZWFuIGNhbGxlZXMgb2YgcnR3X2NvZXhfODcyM2JzX3Nj
YW5fd29ya2Fyb3VuZCgpID8NCkkgdGhpbmsgeW91IGNhbiBnbyB3aXRoIHlvdXIgbWluZC4NCg0K
PiANCj4gVGVsbCBtZSB3aGljaCBvZiB0aG9zZSB5b3Ugd2FudCBhcyBvcHMgYW5kIEkgd2lsbCBk
byBpdC4NCg0KSSdkIHNheSB0aGUgdmVyc2lvbiBjb3B5IG1hbnkgc3R1ZmZzIGZyb20gdmVuZG9y
IGRyaXZlci4gSG93ZXZlciwgd2Ugc2hvdWxkDQpyZXdyaXRlIGFuZCBjb25zaWRlciB0aGUgcHJv
cGVyIHBsYWNlcywgYW5kIGlmIGl0IGlzIGFjdHVhbGx5IG5lY2Vzc2FyeS4gDQpUaGUgdmVuZG9y
IGRyaXZlciBpcyBiYXNlZCBvbiBjZmc4MDIxMSwgYW5kIG1hbnkgc3R1ZmZzIGhhdmUgYmVlbiBk
b25lDQpieSBtYWM4MDIxMSwgc28gd2UgZG9uJ3QgbmVlZCB0byBpbXBsZW1lbnQgdGhlbSBpbiBy
dHc4OC4gDQoNClBpbmctS2UNCg0K
