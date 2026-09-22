Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8643438BA;
	Tue, 22 Sep 2026 00:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790038258; cv=none; b=NPc/fZlaecwVjrr58tZN3HGLmqzyUXPLz/SnoBPe3hpiL/MQe/AXdYOs/ag2qhv4E+LcfIYHHlIuJOu4GE90r1q/L4QEfF19fjHbqXwvq1gNvNoPhGgqJe47GHe2gZ+Kd5PFgk51l0bJvqVZKDZHcBf8znGrPov9ZxKAVsiyWDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790038258; c=relaxed/simple;
	bh=YOLCm5FEtJIoAHb/Ji+85gBMLrz8YBnJO2jDp3A+PyI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KycZ+iBzx4AJZveSBS+OA9GrHJZMuyuEhAnlHCQmSWmDm+w92nXxuQ7ZExttrly931Rfz57E9m33jZRfQ7+OAyPnbFwcgRxmAFPHGAC8uqM6gwrDo3ylw9Pmjyz5INz8++0HQ8tsB7D3TVr9M3VHvUTmvIjt9/LYHC0NufZH0js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=fkeImGOV; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="fkeImGOV"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68M0oZHd93076243, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790038236; bh=YOLCm5FEtJIoAHb/Ji+85gBMLrz8YBnJO2jDp3A+PyI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=fkeImGOV0a9EOP+78k9eFmCRyqMv628R+n8msrzniMNme20ntxAeK2PFsPwTSnl92
	 StUDGIGqZs292dNcbAa3IcFra/UeiTihPzNTZBU7LNmp6VeqGb4hFaL6CwdeNVg6GI
	 ZHNhdiU3b0UdYBj96zvlEgmEQOux2YuQJBTJ5XXQTN7Q92rYLnA9jtGw1sfVPq2jJ0
	 7NvYq7ZrFPLgrGJsxtVCaNDKq9PVYHg0JM1PPog7TUXKijrBVRnljr7JuZvijd8krA
	 B+jgiw4BNmAGd1i0TU6bdjXfztNbv/i7dqepKifyZavCmPpxq3DD+20B/+171S/nDR
	 P7kz5wtx0ja5Q==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68M0oZHd93076243
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 22 Sep 2026 08:50:36 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 22 Sep 2026 08:50:36 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 22 Sep 2026 08:50:35 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Tue, 22 Sep 2026 08:50:35 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Luka Gejak <luka.gejak@linux.dev>, Jeff Johnson
	<jeff.johnson@oss.qualcomm.com>, Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
  Straube" <straube.linux@gmail.com>, Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: RE: [PATCH v3 6/6] MAINTAINERS: add entry for the RTL8723B rtw88
 driver
Thread-Topic: [PATCH v3 6/6] MAINTAINERS: add entry for the RTL8723B rtw88
 driver
Thread-Index: AQHdSeAeQzf2/kHhyEaOG4CaLogmfLbYsc0AgAAGuQCAABezgIAASM4AgAAWAACAAI0MQP//gOSAgACGXzA=
Date: Tue, 22 Sep 2026 00:50:35 +0000
Message-ID: <2694defa2e284ee894005c59197325a0@realtek.com>
References: <20260921154347.82317-1-luka.gejak@linux.dev>
 <20260921154347.82317-7-luka.gejak@linux.dev>
 <45eb7d5908f8fff9a18cba603fd3a4abfe8695f9.camel@sipsolutions.net>
 <31285267ebc43aab631a4199059a247a8d937814@linux.dev>
 <c208152fc5cb45e19ae7d4660394dbf2bc5e0271.camel@sipsolutions.net>
 <bcd5a280-8184-4457-ae52-47a9e0fe763c@oss.qualcomm.com>
 <ffe834a8a469d5febb7e73de371d662f9a0d115f@linux.dev>
 <fe3c6884a96b476799f415a06314f1ba@realtek.com>
 <c419df59280e52baa5e25f665eff599592f3cdff@linux.dev>
In-Reply-To: <c419df59280e52baa5e25f665eff599592f3cdff@linux.dev>
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

THVrYSBHZWphayA8bHVrYS5nZWpha0BsaW51eC5kZXY+IHdyb3RlOg0KPiBTZXB0ZW1iZXIgMjIs
IDIwMjYgYXQgMDM6MjgsICJQaW5nLUtlIFNoaWgiIDxwa3NoaWhAcmVhbHRlay5jb20+IHdyb3Rl
Og0KPiANCj4gDQo+ID4NCj4gPiBMdWthIEdlamFrIDxsdWthLmdlamFrQGxpbnV4LmRldj4gd3Jv
dGU6DQo+ID4NCj4gPiA+DQo+ID4gPiBTZXB0ZW1iZXIgMjIsIDIwMjYgYXQgMTozNSBBTSwgIkpl
ZmYgSm9obnNvbiIgPGplZmYuam9obnNvbkBvc3MucXVhbGNvbW0uY29tPiB3cm90ZToNCj4gPiA+
DQo+ID4gPg0KPiA+ID4NCj4gPiA+ICBPbiA5LzIxLzIwMjYgMTE6MTQgQU0sIEpvaGFubmVzIEJl
cmcgd3JvdGU6DQo+ID4gPg0KPiA+ID4gID4NCj4gPiA+ICA+IE9uIE1vbiwgMjAyNi0wOS0yMSBh
dCAxNjo0OSArMDAwMCwgTHVrYSBHZWphayB3cm90ZToNCj4gPiA+ICA+DQo+ID4gPiAgPiA+DQo+
ID4gPiAgPiA+IEl0IGlzIHN1cHBvc2VkIHRvIHdvcmsgaW4gdGhlIHNhbWUgd2F5IGl0IHdvcmtz
IGZvciBvdGhlciBkcml2ZXINCj4gPiA+ICA+ID4gbWFpbnRhaW5lcnMuIEkgd291bGQgcmV2aWV3
IHBhdGNoZXMgYW5kIHByb3ZpZGUgbXkgYWNrZWQgYnkgb3INCj4gPiA+ICA+ID4gcmV2aWV3ZWQg
YnkgdGhlbSBhbmQgUGluZy1LZSB3b3VsZCBhcHBseSB0aGVtIHRvIGhpcyBydHctbmV4dCBicmFu
Y2guDQo+ID4gPiAgPiA+DQo+ID4gPiAgPg0KPiA+ID4gID4gSSBkb24ndCB0aGluayB3ZSBoYXZl
IGEgbG90IG9mIGZvbGtzIGJlbG93IHRoZSBkcml2ZXIgbWFpbnRhaW5lcnMgd2hvIHMNCj4gPiA+
ICA+IGVuZCBtZSBwdWxsIHJlcXVlc3RzIChleGNlcHQgVG9rZSBtYXliZT8pIC0gYnV0IGFzIGxv
bmcgYXMgSSBkb24ndCBuZWVkDQo+ID4gPiAgPiB0byBkZWFsIHdpdGggaXQgSSdtIGhhcHB5LCB5
b3UgY2FuIGZpZ3VyZSBpdCBvdXQgYmV0d2VlbiB5b3Vyc2VsdmVzIDopDQo+ID4gPiAgPg0KPiA+
ID4gIEZvciBhdGguZ2l0IHRoZXJlIGFyZSBzdWItbWFpbnRhaW5lcnMgZm9yIGF0aDVrIChNdWx0
aXBsZSksIGF0aDlrIChUb2tlKSwNCj4gPiA+ICBjYXJsOTE3MCAoQ2hyaXN0aWFuKSwgYW5kIHdj
bjM2eHggKExvaWMpLg0KPiA+ID4NCj4gPiA+ICBUb2tlIGhhcyBhIGxpbnV4LXdpcmVsZXNzIHBh
dGNod29yayBhY2NvdW50IHNvIHRoZSBhdGg5ayBwYXRjaGVzIGFyZSBpbml0aWFsbHkNCj4gPiA+
ICBhc3NpZ25lZCB0byBoaW0gaW4gcGF0Y2h3b3JrLCBhbmQgaGUgQWNrcyBvbiB0aGUgbGlzdCBh
bmQgYXNzaWducyB0aGUNCj4gPiA+ICBwYXRjaHdvcmsgcmVjb3JkcyB0byBtZSB3aGVuIGhlIGFw
cHJvdmVzIHBhdGNoZXMuDQo+ID4gPg0KPiA+ID4gIEZvciB0aGUgb3RoZXJzIHRoZSBtYWludGFp
bmVycyBqdXN0IEFjayBvbiB0aGUgbGlzdCwgYW5kIEkgdGFrZSB0aGVtIGZyb20gdGhlcmUuDQo+
ID4gPg0KPiA+ID4gIFNvIHRoZSBxdWVzdGlvbiBpcyBkbyBob3cgZG8geW91IHdhbnQgdG8gaGFu
ZGxlIHRoaXMgaW4gcGF0Y2h3b3JrPw0KPiA+ID4NCj4gPiA+ICAvamVmZg0KPiA+ID4NCj4gPiA+
DQo+ID4gPiAgV2hhdCBkbyB5b3UgdGhpbmsgbWFrZXMgbW9yZSBzZW5zZSBoZXJlOiBwYXRjaHdv
cmsgZGVsZWdhdGUNCj4gPiA+ICBhY2Nlc3MgbGlrZSBUb2tlIGhhcyBmb3IgYXRoOWssIG9yIG9u
IGxpc3QgYWNrIGJhc2VkPyBJJ2QgbGVhbg0KPiA+ID4gIHRvd2FyZHMgZGVsZWdhdGUgYWNjZXNz
IGlmIGl0J3Mgbm90IGEgYmlnIGFzayBvbiB5b3VyIGVuZCwgYnV0DQo+ID4gPiAgaGFwcHkgdG8g
Z28gd2l0aCB3aGF0ZXZlciB3b3JrcyBiZXN0IG9wZXJhdGlvbmFsbHkgZm9yIHlvdS4NCj4gPiA+
DQo+ID4gSSdtIGhhcHB5IHRoYXQgcGVvcGxlIGpvaW4gcnR3ODggcmV2aWV3ZXJzLg0KPiA+DQo+
ID4gUGVyc29uYWxseSBJIHByZWZlciBwZW9wbGUgZ2l2ZSBSZXZpZXdlZC1ieSB0YWcgdG8gdGhl
IHBhdGNoZXMsIGFuZA0KPiA+IEkgY2FuIG15c2VsZiB0YWtlIHRoZSBwYXRjaGVzIGJ5IHBhdGNo
d29yayBzdGF0ZSBhbmQgc2VuZCBwdWxsLXJlcXVlc3QNCj4gPiB0byBKb2hhbm5lcy4NCj4gPg0K
PiA+IFdpdGggYWRkaXRpb25hbCBmbG93cyBvZiBwYXRjaHdvcmsgYW5kIHB1bGwtcmVxdWVzdCwg
aXQgbG9va3MgbXVjaA0KPiA+IGhhcmQgdG8gbWFpbnRhaW4sIHNpbmNlIEkgZG9uJ3QgdGhpbmsg
dGhlcmUgd2lsbCBiZSBhIGxvdCBvZiBwYXRjaGVzIG9mDQo+ID4gZHJpdmVycy9uZXQvd2lyZWxl
c3MvcmVhbHRlay9ydHc4OC9ydHc4NzIzYioue2MsaH0NCj4gPg0KPiA+IEJ5IHRoZSB3YXksIGlm
IHlvdSBhcmUgaW50ZXJlc3RlZCBpbiBydHc4OCwgbWF5YmUgYWRkIGEgIlI6Ig0KPiA+IGVudHJ5
IHRvIGJlIGEgcmV2aWV3ZXIgb2YgcnR3ODg/DQo+ID4NCj4gPiBQaW5nLUtlDQo+ID4NCj4gDQo+
IEhpIFBpbmctS2UsDQo+IA0KPiBJIGFncmVlIHRoYXQgYXBwcm9hY2ggaXMgc2ltcGxlciBhbmQg
SSBhbSBwZXJmZWN0bHkgZmluZSB3aXRoDQo+IGl0LCBpZiBpdCB3b3JrcyBiZXR0ZXIgZm9yIHlv
dS4gQW5kIGFib3V0IGJlaW5nIHJ0dzg4IHJldmlld2VyOiBJDQo+IHdvdWxkIGhhcHBpbHkgdGFr
ZSB0aGF0IHJvbGUsIHNvIEkgd2lsbCBzZW5kIGEgc2VwYXJhdGUgcGF0Y2gNCj4gb3V0c2lkZSB0
aGlzIHNlcmllcy4NCg0KSSB0aGluayB5b3UgY2FuIGNoYW5nZSB0aGUgY29udGVudCBvZiB0aGlz
IHBhdGNoIHRvIGFkZCB5b3Vyc2VsZiB0bw0KcnR3ODggcmV2aWV3ZXIuIE5vIG5lZWQgb3RoZXIg
cGF0Y2guIA0KDQpJbiBmYWN0LCBldmVuIHlvdSBhcmVuJ3QgaW4gbGlzdCBvZiBNQUlOVEFJTkVS
UywgeW91IGNhbiBzdGlsbCByZXZpZXcNCnBhdGNoZXMuIEp1c3Qgc3Vic2NyaWJlIGxpbnV4LXdp
cmVsZXNzIG1haWxpbmcgbGlzdCAoSSB0aGluayB5b3UgZGlkKSwNCmFuZCByZXBseSBwYXRjaGVz
IHlvdSBoYXZlIHJldmlld2VkLiANCg0KUGluZy1LZQ0KDQo=
