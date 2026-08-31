Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6977B2DA768;
	Mon, 31 Aug 2026 01:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788140628; cv=none; b=f8N/XVSfy6r/n3snuISUOq0ROeCulzA6ir1HNI2FmelvO6FptfSiU58KotiOLm0+UaKeDPhlusGJCRrvsSItwTwaDdX99Z85gyMfpXdT/Qt3uV2VSu03svtVLOjfmRLSJqJA9o1puJBFoq9aGlyYOb6PO18i+i50eZGCUYcdDWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788140628; c=relaxed/simple;
	bh=HOwdIDtcUou9CpkdxrwwecM7kXRP2Gq3GEcFTLUxbVA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pSDw7nZDyrDndYHM3YbLZ3fqp4M2aXRR0so/8km3aucs88cOxj+qv9j9V7/mpJlup0MvtzJ+6fLEhVKTgkHpSsxDDTFqD1nSFScyn3VJw2SEinuLyk8be4BzWVJvUjxBAw/5bulVT6KmblpVgVhfUzUTieDt7F1ZhhkJViIKfaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=Cn/DD6GK; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="Cn/DD6GK"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67V1hVhS5350852, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788140611; bh=HOwdIDtcUou9CpkdxrwwecM7kXRP2Gq3GEcFTLUxbVA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=Cn/DD6GKmOidOi9zDcD6zBLnsqB9vQZV/+gX7z0kx3eTQPtVAYf6rjYMk7Rkz0qBN
	 +RBF2GFe1NLGhloWg1dHPE8QkRwbLWLh+KLIXaVuy9IKrRLSJKW+istxTXblg5qy3L
	 rmzEPLvAIVLlgpXur6suYC4wyzCKtNg9H++ckwrZ0JWCpZDeaGZDinc4Zy+Az1yyzj
	 0H9BViH/1IS+1Pa1eOIq/pIH92xMiVPi6W696ylRhCx3rW1uNu8QUACWVioN4nWC4+
	 19Qlu0zvBqzt4P52PITzMiVKr36YtWL9WxucEiJ+gz4q+/GHIEUeO4gYVw65PVAGqW
	 I+9CZnNRzbSnw==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67V1hVhS5350852
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 31 Aug 2026 09:43:31 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 31 Aug 2026 09:43:32 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 31 Aug 2026 09:43:32 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Mon, 31 Aug 2026 09:43:32 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Luka Gejak <luka.gejak@linux.dev>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Bitterblue Smith
	<rtl8821cerfe2@gmail.com>, Peter Robinson <pbrobinson@gmail.com>, "Hans de
 Goede" <johannes.goede@oss.qualcomm.com>
Subject: RE: [PATCH v8 6/6] wifi: rtw88: sdio: add TX back-pressure and retry
 on page starvation
Thread-Topic: [PATCH v8 6/6] wifi: rtw88: sdio: add TX back-pressure and retry
 on page starvation
Thread-Index: AQHdNK+IjpEKOkCBYUSn8WCDtzqU1bazNQUQ//9/8ICABLNCoA==
Date: Mon, 31 Aug 2026 01:43:31 +0000
Message-ID: <7f4ad29ef3ab447492fc7467eae8c2d1@realtek.com>
References: <20260825163314.1590-1-luka.gejak@linux.dev>
 <20260825163314.1590-7-luka.gejak@linux.dev>
 <abbadda4537640eab1bce5620ade5f47@realtek.com>
 <FCC54106-9CBC-4987-899B-4C7E0C997063@linux.dev>
In-Reply-To: <FCC54106-9CBC-4987-899B-4C7E0C997063@linux.dev>
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

THVrYSBHZWphayA8bHVrYS5nZWpha0BsaW51eC5kZXY+IHdyb3RlOg0KPiBIaSBQaW5nLUtlLA0K
PiANCj4gT24gQXVndXN0IDI4LCAyMDI2IDExOjI5OjI5IEFNIEdNVCswMjowMCwgUGluZy1LZSBT
aGloIDxwa3NoaWhAcmVhbHRlay5jb20+IHdyb3RlOg0KPiANCj4gPiBBdCB0aGUgbGFzdCByZXZp
ZXcgKEkgdGhpbmsgdjkpLCBJIHdpbGwgZm9jdXMgb24gdGhlIGNoYW5nZXMgb2YgdGhpcw0KPiA+
IHBhdGNoc2V0IGRvZXNuJ3QgYWZmZWN0IGV4aXN0aW5nIGNoaXBzLg0KPiANCj4gVGhhdCBpcyB0
aGUgcmlnaHQgdGhpbmcgdG8gZm9jdXMgb24gYW5kIGl0IGlzIHRoZSBwYXJ0IEkgY2Fubm90IHRl
c3QsIHNvDQo+IGxldCBtZSBzZXQgb3V0IHdoYXQgdGhlIG90aGVyIHBhcnRzIGFjdHVhbGx5IHJ1
biwgYW5kIGNvcnJlY3Qgc29tZXRoaW5nDQo+IGluIHRoZSB2OCBjb3ZlciBsZXR0ZXIgd2hpbGUg
SSBhbSBhdCBpdC4NCj4gDQo+IE5ldyBjb2RlIHRoYXQgaXMgbm90IGJlaGluZCBydHdfaXNfODcy
M2JzKCksIGFsbCBvZiBpdCBzdHJ1Y3R1cmFsOg0KPiANCj4gICBzZGlvLmggICAgICAgICAgICAg
ICAgICAgc3RydWN0IGRlbGF5ZWRfd29yayB3b3JrDQo+ICAgcnR3X3NkaW9faW5pdF90eCgpICAg
ICAgIElOSVRfREVMQVlFRF9XT1JLKCksIG11dGV4X2luaXQoKSwgYW5kDQo+ICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIG11dGV4X2Rlc3Ryb3koKSBvbiBpdHMgZXJyb3IgcGF0aA0KPiAgIHJ0
d19zZGlvX3R4X2tpY2tfb2ZmKCkgICBtb2RfZGVsYXllZF93b3JrKC4uLiwgMCkgaW4gcGxhY2Ug
b2YNCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgcXVldWVfd29yaygpDQo+ICAgcnR3X3Nk
aW9fZGVpbml0X3R4KCkgICAgIGNhbmNlbF9kZWxheWVkX3dvcmtfc3luYygpLCBtdXRleF9kZXN0
cm95KCkNCj4gDQo+IE9ubHkgdGhpcyBjaGlwIGV2ZXIgYXJtcyBhIGRlbGF5LCBzbyBvbiB0aGUg
b3RoZXIgcGFydHMgdGhlIHdvcmsgaXMNCj4gc3RpbGwgcXVldWVkIGltbWVkaWF0ZWx5LCBhbmQg
b25seSB0aGlzIGNoaXAgZXZlciB0YWtlcyB0aGUgbXV0ZXguDQo+IA0KPiBUd28gZXhpc3Rpbmcg
ZnVuY3Rpb25zIHdlcmUgYWxzbyByZXN0cnVjdHVyZWQgYW5kIGV2ZXJ5IGNoaXAgcnVucw0KPiB0
aHJvdWdoIHRoZW0sIHNvIEkgc2hvdWxkIG5vdCBkZXNjcmliZSB0aGUgYWJvdmUgYXMgdGhlIHdo
b2xlIHN0b3J5Lg0KPiBydHdfc2Rpb19wcm9jZXNzX3R4X3F1ZXVlKCkgbm93IHJldHVybnMgYSB2
YWx1ZSBpbnN0ZWFkIG9mIHZvaWQsIGFuZA0KPiBydHdfc2Rpb190eF9oYW5kbGVyKCkgdXNlcyBp
dC4gVGhlIGJlaGF2aW91ciBpcyBtZWFudCB0byBiZSBpZGVudGljYWwNCj4gZm9yIHRoZSBvdGhl
ciBwYXJ0czogb24gYW4gZW1wdHkgcXVldWUgdGhlIG5ldyAiaWYgKHJldCA+IDApIGJyZWFrIg0K
PiB0YWtlcyB0aGUgcGxhY2Ugb2YgdGhlIG9sZCBza2JfcXVldWVfZW1wdHkoKSBicmVhaywgYW5k
IG9uIGEgZmFpbGVkDQo+IHdyaXRlIHRoZSBmcmFtZSBpcyBzdGlsbCByZXF1ZXVlZCBhbmQgdGhl
IGxvb3Agc3RpbGwgcmV0cmllcywgc2luY2UNCj4gcnR3X3NkaW9fODcyM2JzX3Jlc2NoZWR1bGVf
dHgoKSByZXR1cm5zIGZhbHNlIGZvciBhbnl0aGluZyB0aGF0IGlzIG5vdA0KPiB0aGlzIGNoaXAu
IFRoYXQgaXMgdGhlIHBpZWNlIEkgd291bGQgbW9zdCBsaWtlIHlvdSB0byBjaGVjay4NCg0KVGhh
bmtzIGZvciB0aGUgaW5mby4gRm9yIG1lLCBJJ2QgY2hlY2sgYWN0dWFsIHBhdGNoIGNvbnRlbnQg
aW4gY2FzZQ0Kc29tZXRoaW5nIGlzIG5vdCBleHBlY3RlZC4gVGhhdCBtZWFucyBpZiB5b3UgY2Fu
IGVsYWJvcmF0ZSBwYXRjaGVzDQp3aXRob3V0IHN0cmluZyB1bm5lY2Vzc2FyeSBwYXJ0IChzb21l
dGhpbmcgbGlrZSBtb3ZpbmcgYSBjaHVuayB0bw0KYW5vdGhlciBwbGFjZSB0byBoZWxwICdnaXQg
ZGlmZicgdG8gZ2VuZXJhdGUgdGhlIHBhdGNoLiBUaGlzIGlzIG9ubHkNCmEgcHJhY3RpY2UsIGJ1
dCBJIGRvbid0IHNwZWNpZmljYWxseSBwb2ludCB0byBzb21ld2hlcmUgeW91ciBwYXRjaGVzDQpu
ZWVkIHRoZSBjaGFuZ2VzKSwgaXQgd2lsbCBiZSBoZWxwZnVsIHRvIHJldmlldyB3aGV0aGVyIHRo
aXMgcGF0Y2hzZXQNCmFmZmVjdHMgZXhpc3RpbmcgY2hpcHMuIA0KDQoNCg==
