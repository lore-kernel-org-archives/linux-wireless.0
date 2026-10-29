Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793233914;
	b=QLi6WULPF1FBtmU01ZFe35BnftwKxunqzMBFQnG9qJoZ4h/v1ddoGoWsqNicQ4rFd0oQ
	 5C4FHdselpVwAd7B6BP3Klz78lxNQywfsUJJw5JN0cxor1jF4+kKn92kUO7L+wkLqhfIB
	 t0qwRzD6kVLuhYgXE42b4kypDQmy4ojMdqgxUqQKJEtpMNga9qEF2S6ZI7uw4UncTbFD/
	 qsWo1LYxKtQJvjwFCKJbrX4PQ7v6HrU4cypvlBgikQYXqQ2U1uWwLxIQ4czpE1wN1Cjnj
	 YiTy1d8T74PoIZesmaaIBnYNmgDnRAhgql6U+PU9oi9oSVM9sQeKJHlUXQzjesMzI8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793233914;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:From:To:Subject:Thread-Topic:Thread-Index:Date:Message-ID:
	 References:In-Reply-To:Accept-Language:Content-Language:
	 x-originating-ip:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=UG2x04dhDm9AfhKu3OfnYbCQnci11rvf2HUlvvmkeWg=;
	b=4CuNWk1NzrWQ1PznHLBn7+av1yP3Z0Zp6fwPrIj5Hr99h5Yv/TFMAavwp1gTIzPGVb0w
	 EsFrIewPzPR0XUXdfvxycUnJSvB0JRf9b/vvRAp7jw18U/Nix+u9vUDXTBjAyP+1N1WMd
	 OQeiSJfMs7sFK5YsNsKt+4N24zVSF0Mb0TZwtarHwecenwcJlpAcCTO8//xLV/QHP/WTA
	 wi/KWrHJFlc9J7iw7DFz4d3v1/ae0ZphP3aONcq543w/scTO/gm62ro4EeNiaj1R70zo0
	 dFfbT6I+fW38yzONyrM5eCAPF6wEvAH9f4+FyVRaitZ/sFDSppXBAjNqYyVCIavNppw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=QM9I1wqJ;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12516606A31C
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 00:31:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 12516606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=QM9I1wqJ
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69T0VmjzE2376184, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1793233908; bh=UG2x04dhDm9AfhKu3OfnYbCQnci11rvf2HUlvvmkeWg=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=QM9I1wqJOn4woBp7LWFvQfQti/zxIKqhOPmzGqgO5rwndrLwxYZU/+Zj2/VLRQzFd
	 Lg11pPKHt/GIUZDaceEUrcSEiT1QUBZirajJ8mESsXBx0Iq4Wrl1QtX2lryL1JXUdf
	 p8FJpI/1ox8G7zsGxcDpvR66ugxe/JPpvU6UZfybuOBvGH6A9FUOYGL2F+WqFresWS
	 H11ylXIxFZmwuXd153kKOitpyU5GNlIeLz/wFcEGat8iiTEwARUe4LkFS2BIxfe3Yb
	 XZC2lMk3IMnP0ebalgMHO9m/d6ioHT59TnpJNqiOwDeqEATyEMzxxqGNmcFZKrWnkc
	 IeuDNFuGtnodw==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69T0VmjzE2376184
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 29 Oct 2026 08:31:48 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 29 Oct 2026 08:31:48 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([fe80::eeeb:c765:ca73:5eef]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::eeeb:c765:ca73:5eef%10]) with mapi id
 15.02.2562.056; Thu, 29 Oct 2026 08:31:48 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Dev Narayan <devnarayan08807@gmail.com>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>
Subject: RE: rtw89_8852be (RTL8852BE): PCIe device not ready after s2idle
 resume, probe fails with -110
Thread-Topic: rtw89_8852be (RTL8852BE): PCIe device not ready after s2idle
 resume, probe fails with -110
Thread-Index: AQHdZsWTqwawiRHQuEOp8JqhEgulwbcTqqXQ
Date: Thu, 29 Oct 2026 00:31:48 +0000
Message-ID: <b1111942b19d46f88ac7392e58ee2ca0@realtek.com>
References: <CADD=N5x9JCh+jaf50Tr13+m3541gqM4iCLSF+KVLOnf7_rW1cA@mail.gmail.com>
In-Reply-To: <CADD=N5x9JCh+jaf50Tr13+m3541gqM4iCLSF+KVLOnf7_rW1cA@mail.gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Ly8gaW4gcGxhaW4gdGV4dCBmb3JtYXQgcGxlYXNlLg0KDQpEZXYgTmFyYXlhbiA8ZGV2bmFyYXlh
bjA4ODA3QGdtYWlsLmNvbT4gd3JvdGU6DQo+IEhlbGxvLA0KPiANCj4gSSBhbSByZXBvcnRpbmcg
YSBXaS1GaSBmYWlsdXJlIGFmdGVyIHN1c3BlbmQvcmVzdW1lIHdpdGggdGhlIHJ0dzg5Xzg4NTJi
ZSANCj4gZHJpdmVyLiBBZnRlciByZXN1bWUgdGhlIGNhcmQgbmV2ZXIgcmVzcG9uZHMsIGFuZCBv
bmx5IGEgZnVsbCByZWJvb3QgYnJpbmdzIA0KPiBXaS1GaSBiYWNrLg0KPiANCj4gSEFSRFdBUkUg
QU5EIFNPRlRXQVJFDQo+IC0gTGFwdG9wOiBBU1VTIFRVRiBHYW1pbmcgRjE2IEZYNjA3VkpCIChJ
bnRlbCBDb3JlIDUgMjEwSCkNCj4gLSBCSU9TOiBBbWVyaWNhbiBNZWdhdHJlbmRzIEZYNjA3VkpC
LjMzOCwgMjAyNS0wOC0yNyA8RklMTCBJTjogImxhdGVzdCANCj4gYXZhaWxhYmxlIGZyb20gQVNV
UyBhcyBvZiBEQVRFIiBvciAidXBkYXRlZCB0byBWRVJTSU9OIGFuZCByZXRlc3RlZCINCj4NCj4g
LSBXaS1GaTogUmVhbHRlayBSVEw4ODUyQkUgUENJZSA4MDIuMTFheCBbMTBlYzpiODUyXSwgc3Vi
c3lzdGVtIEF6dXJlV2F2ZSANCj4gWzFhM2I6NTQ3MV0sIGF0IDAwMDA6MDQ6MDAuMA0KPiAtIEJs
dWV0b290aDogVVNCLCBJTUMgTmV0d29ya3MgWzEzZDM6MzU3MV0gKGJ0dXNiLCBSZWFsdGVrIGZp
cm13YXJlIA0KPiBydGw4ODUyYnUpDQo+IC0gRGlzdHJvOiBLYWxpIExpbnV4IChyb2xsaW5nKQ0K
PiAtIEtlcm5lbDogNy4xLjUra2FsaS1hbWQ2NA0KPiAtIEZpcm13YXJlOiBydHc4OS9ydHc4ODUy
Yl9mdy0yLmJpbg0KDQpJdCdkIGJldHRlciB0byBwb2ludCBvdXQgdGhlIGZpcm13YXJlIHZlcnNp
b24geW91IGFyZSB1c2luZy4NCg0KPiAtIFNsZWVwIG1vZGU6IHMyaWRsZSAoY2F0IC9zeXMvcG93
ZXIvbWVtX3NsZWVwIHNob3dzICJbczJpZGxlXSBkZWVwIikNCj4gDQo+IFNURVBTIFRPIFJFUFJP
RFVDRQ0KPiAxLiBCb290IHdpdGggZGVmYXVsdCBzZXR0aW5ncy4gV2ktRmkgd29ya3MuDQo+IDIu
IFJ1bjogc3lzdGVtY3RsIHN1c3BlbmQNCj4gMy4gV2FpdCBhYm91dCAxMCBzZWNvbmRzIGFuZCB3
YWtlIHRoZSBsYXB0b3AuDQo+IA0KPiBFWFBFQ1RFRCBSRVNVTFQNCj4gV2ktRmkgcmVzdW1lcyBh
bmQgcmVjb25uZWN0cy4NCj4gDQo+IEFDVFVBTCBSRVNVTFQNCj4gVGhlIFdpLUZpIGRldmljZSBp
cyBnb25lIGZyb20gTmV0d29ya01hbmFnZXIgKG5tY2xpIGRldmljZSBsaXN0cyBvbmx5IGxvIA0K
PiBhbmQgZXRoMCkuIGxzcGNpIHN0aWxsIHNob3dzIHRoZSBjYXJkIGF0IDA0OjAwLjAsIGJ1dCB3
aXRoIG5vICJLZXJuZWwgDQo+IGRyaXZlciBpbiB1c2UiLiBCbHVldG9vdGggcmVjb3ZlcnMgZmlu
ZSBhZnRlciByZXN1bWU7IG9ubHkgdGhlIFdpLUZpIGNhcmQgDQo+IGlzIGFmZmVjdGVkLg0KPiAN
Cj4gS0VZIEtFUk5FTCBMT0cgTElORVMNCj4gcnR3ODlfODg1MmJlIDAwMDA6MDQ6MDAuMDogbm90
IHJlYWR5IDEwMjNtcyBhZnRlciByZXN1bWU7IHdhaXRpbmcNCj4gLi4uDQo+IHJ0dzg5Xzg4NTJi
ZSAwMDAwOjA0OjAwLjA6IG5vdCByZWFkeSA2NTUzNW1zIGFmdGVyIHJlc3VtZTsgZ2l2aW5nIHVw
DQo+IHJ0dzg5Xzg4NTJiZSAwMDAwOjA0OjAwLjA6IGZhaWxlZCB0byB3cml0ZSBEQkkgcmVnaXN0
ZXIsIGFkZHI9MHhCNDgNCj4gcnR3ODlfODg1MmJlIDAwMDA6MDQ6MDAuMDogZmFpbGVkIHRvIHJl
YWQgUENJIGNhcCwgcmV0PTEzNA0KPiBydHc4OV84ODUyYmUgMDAwMDowNDowMC4wOiB4dGFsIHNp
IG5vdCByZWFkeShXKTogb2Zmc2V0PTkwIHZhbD0xMCBtYXNrPTEwDQo+IHJ0dzg5Xzg4NTJiZSAw
MDAwOjA0OjAwLjA6IG1hYyBwcmVpbml0IGZhaWwsIHJldDogLTExMA0KPiANCj4gTWFudWFsbHkg
cmVsb2FkaW5nIHRoZSBtb2R1bGUgYWZ0ZXJ3YXJkcyBhbHNvIGZhaWxzIGV2ZXJ5IHRpbWU6DQo+
IHJ0dzg5Xzg4NTJiZSAwMDAwOjA0OjAwLjA6IGxvYWRlZCBmaXJtd2FyZSBydHc4OS9ydHc4ODUy
Yl9mdy0yLmJpbg0KPiBydHc4OV84ODUyYmUgMDAwMDowNDowMC4wOiB4dGFsIHNpIG5vdCByZWFk
eShSKTogb2Zmc2V0PTQxDQo+IHJ0dzg5Xzg4NTJiZSAwMDAwOjA0OjAwLjA6IGZhaWxlZCB0byBw
b3dlciBvbg0KPiBydHc4OV84ODUyYmUgMDAwMDowNDowMC4wOiBmYWlsZWQgdG8gc2V0dXAgY2hp
cCBpbmZvcm1hdGlvbg0KPiBydHc4OV84ODUyYmUgMDAwMDowNDowMC4wOiBwcm9iZSB3aXRoIGRy
aXZlciBydHc4OV84ODUyYmUgZmFpbGVkIHdpdGggZXJyb3IgDQo+IC0xMTANCj4gDQo+IFdPUktB
Uk9VTkRTIFRSSUVEIChub25lIHJlc3RvcmVkIFdpLUZpIGFmdGVyIHJlc3VtZSkNCj4gLSBydHc4
OV9wY2kgZGlzYWJsZV9hc3BtX2wxPXkgZGlzYWJsZV9hc3BtX2wxc3M9eSBkaXNhYmxlX2Nsa3Jl
cT15DQoNClRoZXNlIHdvcmthcm91bmRzIHRha2UgZWZmZWN0IGFmdGVyIHlvdSBjb2xkIHJlYm9v
dC4gUGxlYXNlIGNvbmZpcm0gdGhpcy4NCg0KPiAtIHJ0dzg5X2NvcmUgZGlzYWJsZV9wc19tb2Rl
PXkNCj4gLSBOZXR3b3JrTWFuYWdlciB3aWZpLnBvd2Vyc2F2ZSA9IDINCj4gLSBidHVzYi5lbmFi
bGVfYXV0b3N1c3BlbmQ9biAoQmx1ZXRvb3RoIG9ubHkpDQo+IC0gbW9kcHJvYmUgLXIgLyBtb2Rw
cm9iZSBvZiBydHc4OV84ODUyYmUNCj4gLSBQQ0kgcmVtb3ZlIGFuZCByZXNjYW4gb2YgMDAwMDow
NDowMC4wIChlY2hvIDEgPiAvc3lzL2J1cy9wY2kvZGV2aWNlcy8NCj4gMDAwMDowNDowMC4wL3Jl
bW92ZSwgdGhlbiBlY2hvIDEgPiAvc3lzL2J1cy9wY2kvcmVzY2FuKQ0KPiANCj4gT1RIRVIgTk9U
RVMNCj4gLSBUaGUgc2FtZSBzeW1wdG9tIG9jY3VycmVkIG9uIE5peE9TIG9uIHRoaXMgbGFwdG9w
IGJlZm9yZSBJIG1vdmVkIHRvIEthbGksIA0KPiBzbyBpdCBkb2VzIG5vdCBhcHBlYXIgdG8gYmUg
ZGlzdHJvLXNwZWNpZmljLg0KPiAtIG1lbV9zbGVlcF9kZWZhdWx0PWRlZXAgcmVzdWx0OiA8RklM
TCBJTjogZml4ZWQgaXQgLyBkaWQgbm90IGZpeCBpdCAvIA0KPiBsYXB0b3AgZmFpbGVkIHRvIHdh
a2UgLyBub3QgdGVzdGVkDQo+DQo+IC0gcGNpZV9hc3BtPW9mZiByZXN1bHQ6IDxGSUxMIElOIG9y
IGRlbGV0ZSB0aGlzIGxpbmUNCj4NCj4gDQo+IExPR1MNCj4gRnVsbCBsb2dzIGFyZSBsaW5rZWQg
YmVsb3cgKHBsYWluIHRleHQpOg0KPiAtIGRtZXNnIG9uIGRlZmF1bHQgc2V0dGluZ3MgYWZ0ZXIg
dGhlIGZhaWx1cmU6IDxMSU5LPg0KPiAtIGRtZXNnIHdpdGggdGhlIHdvcmthcm91bmRzIGFib3Zl
IGFwcGxpZWQ6IDxMSU5LPg0KPiAtIGxzcGNpIC1ubnZ2IC1zIDA0OjAwLjA6IDxMSU5LPg0KPiAt
IEtlcm5lbCwgY21kbGluZSwgRE1JIGFuZCBCSU9TIGluZm86IDxMSU5LPg0KPiANCj4gSSBjYW4g
dGVzdCBwYXRjaGVzIG9yIHByb3ZpZGUgbW9yZSBkZWJ1ZyBvdXRwdXQgKGZvciBleGFtcGxlIHdp
dGggcnR3ODkgDQo+IGRlYnVnX21hc2sgc2V0LCBvciBhZGRpdGlvbmFsIGtlcm5lbCBwYXJhbWV0
ZXJzKSBpZiB0aGF0IGhlbHBzLg0KDQpQbGVhc2UgdHJ5IHBhdGNoIFsxXSwgYnV0IHVuY29uZGl0
aW9uYWxseSBkbyBwY2lfZDNjb2xkX2Rpc2FibGUoKSBubyBtYXR0ZXINCmRtaSBtYXRjaCBvciBu
b3QuIA0KDQpbMV0gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzIwMjYwOTExMDY1MzU4LjM0
Mzc1LTEtcGtzaGloQHJlYWx0ZWsuY29tLw0KDQoNCg0K
