Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793608437;
	b=aQLYAoOXKQNUVhkeO5We7A+PID9Z40o97NOTonulrBYHZHyaP96wTzGFi9CuYP6882Y6
	 sYISMMZoGr9UH0HhWaxBhT6pOq6/Upc76FRfB27QfK/DuVGNkDYjtzEsdYcQgXT95uUgT
	 8HGODpvEPW9RMMbxDNEQfl2Qk6cw21HUsw2wjHgl7w3GeOvh5xn7anagjiKJagGZnXeoS
	 +I8nxwjkB7bMwZaKiD3GpqQCpvWKEtmE8En20YjWl6pNl11LinqUlkv3ITaRaEkDmx5Df
	 weZqm/nF9HHZMyh6tuKCuLE1A6C7v+J3F+ES0igZULY1nfbsSS9b3d5oe6/vbf8krYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793608437;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:From:To:CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:
	 References:In-Reply-To:Accept-Language:Content-Language:
	 x-originating-ip:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=g8EWVB6NAcHHC1xLplrEf4bEuJELTSFruRZ2R14orvM=;
	b=EWCod7TR4qkav67qFdgRiy7FhnqNvYl6T2/aPLfxYusfDYuRaQdFriNrfC0jvNHFSyF8
	 4cJLKdS8GmU7yLMG/AauqV8YOpt6hQQ52tMfRRZ3sYl8uD9uBeMl6EW3wfTFf+vAv5t1a
	 RA9GYIJ8V5dzZK6zwkFoOfEq/3XAyFiBU9jTdT4/RlfWMhmS9I2tu2vl0h0HKE7ECuuFv
	 rYrSC6tYRNZUtFJGhJW5af1xXBNtotT6mm1J0SiKBWlQddNuihPUejkgPRO6mg5z+cNzg
	 sevj6G1yA6MosCgMjhObp7exbXUF1nenKYsC6TDs2lOymHvz+jo4K8EY8PSBkreUljQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=RZZ3q5rD;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE2E606A324
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 08:33:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2BE2E606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=RZZ3q5rD
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6A28XcskE1988724, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1793608418; bh=g8EWVB6NAcHHC1xLplrEf4bEuJELTSFruRZ2R14orvM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=RZZ3q5rDpQcTUICRdPoSYeKM5PwyikfwVLUz38g1e52e3RM5yLOKcZ+ij372hwBFb
	 DzhVw7XmoKxrNBFi+2HsbTWDrykjdjrEP6HkZHlo3sDPwpoRnynkP3ZwJbXGAuctWR
	 0RvTN+ZqNX3ePGwm6+Sd5hyjOQXrAmO17SUz/r1YraIxW/usmryTzVoT3gig5K+DUR
	 4tgNlvattWcgg0VOgj2Oy7RDlPfIidFBW0Twnc9IDqtbrLYOTbq+/FheO7liosyWIY
	 3k2delxvGjqImtRYoPcwuoN3/P7U3TTRf0o7pJQx9Y220S7WGxPqhl/k/F27uXeRI3
	 2cHqnyiZtWTiw==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6A28XcskE1988724
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 2 Nov 2026 16:33:38 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 2 Nov 2026 16:33:32 +0800
Received: from RTKEXHMBS05.realtek.com.tw ([fe80::bbab:78ea:8d39:6f1e]) by
 RTKEXHMBS05.realtek.com.tw ([fe80::bbab:78ea:8d39:6f1e%4]) with mapi id
 15.02.2562.056; Mon, 2 Nov 2026 16:33:32 +0800
From: Bernie Huang <phhuang@realtek.com>
To: Robert Beckett <bob.beckett@collabora.com>, Ping-Ke Shih
	<pkshih@realtek.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>, "Luka
 Gejak" <luka.gejak@linux.dev>, Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Timlee <timlee@realtek.com>, "matthew.leach@collabora.com"
	<matthew.leach@collabora.com>, "kernel@collabora.com" <kernel@collabora.com>
Subject: RE: rtw88: 8822CE passes corrupted A-MSDUs as hw-decrypted, poisoning
 CCMP replay counter
Thread-Topic: rtw88: 8822CE passes corrupted A-MSDUs as hw-decrypted,
 poisoning CCMP replay counter
Thread-Index: AQHdXaL8zmsOj0CE6U6ENy6Km2GOWLcHlFUQgABIg4CAATP90P//8EsAgBGMU4A=
Date: Mon, 2 Nov 2026 08:33:32 +0000
Message-ID: <0497033bfcda4a348d18399da1f264ac@realtek.com>
References: <a615f09bb6f54128b792a13ebcbf8970@realtek.com>
 <20261021190529.3893821-1-bob.beckett@collabora.com>
 <90c40c3223c34562b2c171c52d987c2e@realtek.com>
 <1a163984687.46e4c9841111898.2085291868591283475@collabora.com>
In-Reply-To: <1a163984687.46e4c9841111898.2085291868591283475@collabora.com>
Accept-Language: zh-TW, en-US
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

PiAgPiBCb2IgQmVja2V0dCA8Ym9iLmJlY2tldHRAY29sbGFib3JhLmNvbT4gd3JvdGU6DQo+ICA+
ID4gT24gV2VkLCAyMSBPY3QgMjAyNiAwNzozMDo1OCArMDAwMCwgUGluZy1LZSBTaGloDQo+IDxw
a3NoaWhAcmVhbHRlay5jb20+IHdyb3RlOg0KPiAgPiA+ID4gQm9iIEJlY2tldHQgPGJvYi5iZWNr
ZXR0QGNvbGxhYm9yYS5jb20+IHdyb3RlOg0KPiAgPiA+ID4gPg0KPiAgPiA+ID4gPiBUaGUgQVAn
cyBvd24gUE4gc2VxdWVuY2UgaXMgY29uc2lzdGVudCBiZWZvcmUgYW5kIGFmdGVyIHRoZSBiYWQN
Cj4gZnJhbWUsICA+ID4gPiA+IHNvIHRoZSBjb3JydXB0aW9uIGhhcHBlbnMgb24gdGhlIHJlY2Vp
dmUgc2lkZS4NCj4gID4gPiA+DQo+ICA+ID4gPiBNYXliZSB0aGlzIGlzIGEgaGludCB0byBtYWtl
IGEgcGF0Y2ggdG8gZGVmZXIgKGRyb3ApIHJlcG9ydGluZyB3ZWlyZA0KPiBwYWNrZXQsICA+ID4g
PiBhcyBMdWthIGhhcyBmaXhlZCAzIG9mIDQgcHJvYmxlbXMuDQo+ICA+DQo+ICA+IEkgcXVpY2ts
eSBjaGVja2VkIHRoZSBkZWJ1ZyBwYXRjaGVzLCB3aGljaCBzZWVtIG5vdCBkZXRlY3QgaWYgUE4g
c2VxdWVuY2UNCj4gaXMgID4gY29ycmVjdCBhZnRlciB0aGUgYmFkIGZyYW1lLCBmb3IgZXhhbXBs
ZQ0KPiAgPiAgIHNlcSAgICAgUE4NCj4gID4gICAgMSAgICAgIDEwMQ0KPiAgPiAgICAyICAgICAg
OTk5OTkgICAvLyBiYWQgZnJhbWUuIHNob3VsZCBiZSAxMDIuDQo+ICA+ICAgIDMgICAgICAxMDMg
ICAgIC8vIG5vdCBkZXRlY3QgdGhpcw0KPiAgPg0KPiAgPiBPciBJIG1pc3NlZCBzb21ldGhpbmc/
DQo+IA0KPiBpZiBwbiBqdW1wcywgcnR3X3J4X3BuX2d1YXJkIHJldHVybnMgZWFybHkgYmVmb3Jl
IGxhdGNoaW5nIHBuLCBzbyB0aGUgbmV4dA0KPiBjb3JyZWN0ZWQgcG4gd291bGQganVzdCBiZSBh
IHJlZ3VsYXIgaW5jcmVhc2UgYW5kIG5vdCBnZXQgZHJvcHBlZC4NCj4gDQo+ICA+DQo+ICA+ID4g
PiA+IDQuIEZvciBjb21wbGV0ZW5lc3M6IG9uIHRoZXNlIGNoaXBzIGNhbiBSWEJEX0lEWCBvciB0
aGUNCj4gID4gPiA+ID4gICAgYnVmZmVyLWRlc2NyaXB0b3IgUlggdGFnIGV2ZXIgYmUgdXBkYXRl
ZCBiZWZvcmUgdGhlIHBhY2tldCBkYXRhDQo+IERNQQ0KPiAgPiA+ID4gPiAgICBoYXMgY29tcGxl
dGVkLCBhcyBkZXNjcmliZWQgZm9yIFdpRmkgNyBpbiBydHc4OSAwYmM3ZDFkNGU2M2M/DQo+ICA+
ID4gPg0KPiAgPiA+ID4gVGhlIFJYIHRhZyBpbiBydHc4OCBsb2NhdGVkIG9uIG1lbW9yeSBhbGxv
Y2F0ZWQgYnkNCj4gZG1hX2FsbG9jX2NvaGVyZW50KCksIGFuZCAgPiA+ID4gdGhlIFJYIHRhZyBt
dXN0IGJlIHNldCBhZnRlciBwYWNrZXQgZGF0YQ0KPiBNQUMgY29tcGxldGVkLg0KPiAgPg0KPiAg
PiAoZml4IHR5cG86ICAgICAgICAgICAgICAgICAgICAgICAgICAuLi4gZGF0YSBETUEgY29tcGxl
dGVkLikNCj4gID4NCj4gID4gPg0KPiAgPiA+IFVuZGVyc3Rvb2QgdGhhdCB0aGlzIGlzIHRoZSBk
ZXNpZ24gaW50ZW50LiBNeSBxdWVzdGlvbiB3YXMgd2hldGhlciB0aGUNCj4gaG9zdCBjYW4gID4g
PiBldmVyIG9ic2VydmUgdGhlIHRhZyBiZWZvcmUgdGhlIGRhdGEuIGRtYV9hbGxvY19jb2hlcmVu
dCgpDQo+IG9ubHkgbWFrZXMgdGhlIHRhZyAgPiA+IHZpc2libGUgdG8gdGhlIENQVSB3aXRob3V0
IGNhY2hlIG1haW50ZW5hbmNlOyB0aGUNCj4gcGF5bG9hZCBpcyBpbiBhIHNlcGFyYXRlICA+ID4g
c3RyZWFtaW5nIG1hcHBpbmcgKGEgU1dJT1RMQiBib3VuY2UgYnVmZmVyIG9uDQo+IHRoaXMgcGxh
dGZvcm0pLCBzbyB0aGUgb3JkZXIgaW4gID4gPiB3aGljaCB0aGUgaG9zdCBzZWVzIHRoZW0gZGVw
ZW5kcyBvbiB0aGUNCj4gb3JkZXIgb2YgdGhlIGRldmljZSdzIFBDSWUgd3JpdGVzLg0KPiAgPiA+
IFJlbGF4ZWQgT3JkZXJpbmcgaXMgZW5hYmxlZCBvbiB0aGUgODgyMkNFIGhlcmUgKERldkN0bCBS
bHhkT3JkKykuDQo+ICA+ID4gRG9lcyB0aGUgODgyMkNFIHNldCB0aGUgUk8gYXR0cmlidXRlIG9u
IFJYIERNQSB3cml0ZXMsIGluIHBhcnRpY3VsYXIgdGhlDQo+ID4gPiBidWZmZXItZGVzY3JpcHRv
ci90YWcgdXBkYXRlPyBJZiBpdCBkb2VzLCB0aGUgdGFnIHdyaXRlIG1heSBwYXNzIHRoZSBwYXls
b2FkDQo+ID4gPiB3cml0ZXMuDQo+ICA+ID4NCj4gID4gPiBXZSBhcmUgaG9waW5nIHRvIHRlc3Qg
dGhpcyBkaXJlY3RseSB3aXRoIHRoZSBuZXh0IHJvdW5kIG9mIHRlc3RzLiB0aGUNCj4gcnhfZGVi
dWcgID4gPiBvcHRpb24gcmUtc3luY3MgYSBzdXNwZWN0IGJ1ZmZlciAxMDAgdXMgbGF0ZXIsIHNv
IGxhdGUgcGF5bG9hZA0KPiB3cml0ZXMgbWlnaHQgID4gPiBzaG93IHVwIGFzIGNoYW5nZWQgYnl0
ZXMsIGFuZCB3ZSBjYW4gcmVwZWF0IHRoZSB0ZXN0IHdpdGgNCj4gUmVsYXhlZCBPcmRlcmluZyAg
PiA+IGRpc2FibGVkLg0KPiAgPg0KPiAgPiBJJ2xsIGNoZWNrIHRoZSBiZWhhdmlvciBpbnRlcm5h
bGx5IGFuZCBnZXQgYmFjayB0byB5b3UuDQo+ICA+DQo+ICA+DQo+ICA+DQo+IA0KDQpIaSBCb2Is
DQoNCkRvIHlvdSBtaW5kIHRlc3RpbmcgdGhpcyBwYXRjaD8NClJlcHJvZHVjZSBhZ2FpbiB3aXRo
IHRoZSBzYW1lIGZ0cmFjZSBhbmQgc25pZmZlciBsb2dzDQpCeSB0aGUgcmVzdWx0IHdlIGNhbiBk
aWZmZXJlbnRpYXRlIHdoaWNoIGlzIHRoZSBjYXNlOg0KKDEpIEFQIHNlbmRzIGluY29ycmVjdCBD
Q01QIGhlYWRlciAobGVzcyBsaWtlbHkpDQooMikgRE1BIGluY29tcGxldGUgYXQgc29tZSBtb21l
bnQsIGJ1dCBsYXRlciB0aGUgY29ycmVjdCBkYXRhIGNhbiBiZSByZXRyaWV2ZWQNCigzKSBETUEg
aW5jb21wbGV0ZSwgZGF0YSBuZXZlciByZWNvdmVycw0KDQpJSVVDLCBvdXIgaGFyZHdhcmUgd3Jp
dGVzIHBheWxvYWQgZmlyc3QgdGhlbiB0aGUgdGFnLg0KVGhlIFJPIGF0dHJpYnV0ZSBpcyBuZXZl
ciBzZXQgaW4gb3VyIFRMUCwgc28gZGVzcGl0ZSB0aGUgY29uZmlndXJhdGlvbiBzcGFjZSwgUENJ
RSBSQyBzaG91bGRuJ3QgZG8gcmVvcmRlcmluZy4NCkkgYW0gd2FpdGluZyBmb3IgcHJvdG9jb2wg
YW5hbHl6ZXIgdG8gdmVyaWZ5IHRoaXMsIGFuZCB3aWxsIHVwZGF0ZSB3aGVuIEkgaGF2ZSB0aGUg
cmVzdWx0Lg0KSWYgdGhlIGJ1ZmZlciBwb2lzb25pbmcgc29tZWhvdyBjaGFuZ2VzIHRoZSB0aW1p
bmcsIGFuZCBmYWlsIGJlY29tZXMgbm90IHJlcHJvZHVjaWJsZSwgcGxlYXNlIGxldCB1cyBrbm93
LCB0aGFua3MhDQo=
