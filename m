Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907573C414F
	for <linux-wireless@vger.kernel.org>; Thu,  8 Oct 2026 06:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791441554; cv=none; b=JFD96y2YczU9saPyMyrGtMPR0BwU+KwS++xA/VfZGxZYQMZYsA5XVha9ice0M3DMHDOqCofRM9QE+RdOQCsDYNTLsKkSt3X3Og6OPOICOiGbs5ujF7hRUqGzOqBUSm9TxcZ6Ub7RbhqJI+9Ojgpz/q8NaNFhWHDVXiFS8gUuSek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791441554; c=relaxed/simple;
	bh=65gdorVDtKnZqOW7viKSydrlxQ24JGogJHIiO3NZvXY=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ELTcmXvjpoTAo1nzI+HYihrPwfB6Xgn4P2zFl94VmtoexFu7EpTnqs4M9EDMqylV3frgj61i5GBnwoRz3slG6btoMVqF94anj+a1nt5MLnBUctTLlc1kA32nnK3hpBA4LGW0V5B+c2ONLFlDzLduHetyC0YoUm9Se71Ok0Dsj0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=SjNThrDp; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="SjNThrDp"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6986d8CD1274725, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791441548; bh=65gdorVDtKnZqOW7viKSydrlxQ24JGogJHIiO3NZvXY=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=SjNThrDpCMblNWl1eaIfgO9qgWkKXDYomIMQxxTzPFh0LK6sXWEQhKJhFQnE2AwcL
	 HDOuT+uRHqi7O5jvd8yDDniIvk9fjDKNjxZ3NBWpVwsZgfLwW72djOiTG9vAs225ux
	 Po7oimazce4rxYEPXnS04LK3aWB2eh+oMo9rTkBC0dDLCdj1qkHVe7gs+4je2lU+wf
	 kydjMCxdX72gSHYvwPANyZwWcVIO41f4yvP1IvhbCid0U34bRNr0Iay4MKHwjVTRoQ
	 Z8IiCLC3wKuYBop9VNI4y+XfnLY7FOzWoYQ61xYwy8JZqvS5+9tPhrqs+kmhqZmaW5
	 femNJt7w3GBOA==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6986d8CD1274725
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Thu, 8 Oct 2026 14:39:08 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 8 Oct 2026 14:39:08 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 8 Oct 2026 14:39:08 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Thu, 8 Oct 2026 14:39:08 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: pull-request: rtw-next-2026-10-08
Thread-Topic: pull-request: rtw-next-2026-10-08
Thread-Index: AQHdVuloBrGlWerlLE6wvc8385OznrbzMHVQ
Date: Thu, 8 Oct 2026 06:39:07 +0000
Message-ID: <eb6cb2ad074e46f28614824b9c3b12c2@realtek.com>
References: <199af849-ecce-4518-8629-e6abd16be1de@RTKEXHMBS05.realtek.com.tw>
In-Reply-To: <199af849-ecce-4518-8629-e6abd16be1de@RTKEXHMBS05.realtek.com.tw>
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

UGluZy1LZSBTaGloIDxwa3NoaWhAcmVhbHRlay5jb20+IHdyb3RlOg0KPiANCj4gSGksDQo+IA0K
PiBBIHB1bGwtcmVxdWVzdCBvZiBydHctbmV4dCB0byB3aXJlbGVzcy1uZXh0IHRyZWUuIEknZCBu
b3RlIHRoYXQgUlRMODcyM0JTDQo+IGlzIGFkZGVkIGJ5IHRoaXMgcHVsbC1yZXF1ZXN0LCBhbmQg
SSByZWNlaXZlZCBhY2sgZnJvbSBHcmVnIHRvIHJlbW92ZQ0KPiBzdGFnaW5nIHJ0bDg3MjNicyBi
eSB0aGUgd2F5Lg0KPiANCj4gTW9yZSBpbmZvIGJlbG93LiBQbGVhc2UgbGV0IG1lIGtub3cgaWYg
YW55IHByb2JsZW1zLg0KPiANCj4gVGhhbmtzDQo+IFBpbmctS2UNCj4gDQo+IC0tLQ0KPiANCj4g
VGhlIGZvbGxvd2luZyBjaGFuZ2VzIHNpbmNlIGNvbW1pdCAxYjc4MDcwYWFlZjYzNTEyNjg4YWVi
ZmJjODIzNjVlZjlkNjY2MGYxOg0KPiANCj4gICBNZXJnZSB0YWcgJ25ldC03LjMtcmMxJyBvZiBn
aXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvbmV0ZGV2L25ldCAo
MjAyNi0wOC0yNw0KPiAxMzo1Mzo0MyAtMDcwMCkNCj4gDQo+IGFyZSBhdmFpbGFibGUgaW4gdGhl
IEdpdCByZXBvc2l0b3J5IGF0Og0KPiANCj4gICBodHRwczovL2dpdGh1Yi5jb20vcGtzaGloL3J0
dy5naXQgdGFncy9ydHctbmV4dC0yMDI2LTEwLTA4DQo+IA0KPiBmb3IgeW91IHRvIGZldGNoIGNo
YW5nZXMgdXAgdG8gODNkZTNhMTZjN2IzNzA2NGE1OTMwNTA0MGJhOWIwZjkzYjgzMjc5NDoNCj4g
DQo+ICAgd2lmaTogcnR3ODk6IHVzYjogc2hvcnRlbiB0aGUgUlggYWdncmVnYXRpb24gaG9sZCBv
biBSVEw4OTIyQVUgb3ZlciBVU0IgMyAoMjAyNi0xMC0wOCAxMzozMjo0MyArMDgwMCkNCj4gDQoN
CkkgZm91bmQgTklQQSByZXBvcnRlZCB0aGlzIHB1bGwtcmVxdWVzdCBjYW4ndCBhcHBseSB0byB3
aXJlbGVzcy1uZXh0Lg0KTXkgbG9jYWwgdGVzdCBmb3VuZCB0aHJlZSBmaWxlcyB3ZXJlIG1vZGlm
aWVkOg0KDQogICAgICAgIGRlbGV0ZWQgYnkgdGhlbTogZHJpdmVycy9zdGFnaW5nL3J0bDg3MjNi
cy9jb3JlL3J0d19pZWVlODAyMTEuYw0KICAgICAgICBkZWxldGVkIGJ5IHRoZW06IGRyaXZlcnMv
c3RhZ2luZy9ydGw4NzIzYnMvY29yZS9ydHdfbWxtZS5jDQogICAgICAgIGRlbGV0ZWQgYnkgdGhl
bTogZHJpdmVycy9zdGFnaW5nL3J0bDg3MjNicy9vc19kZXAvaW9jdGxfY2ZnODAyMTEuYw0KDQpQ
bGVhc2UgJ2dpdCBybScgdGhlbSB0byByZXNvbHZlIGNvbmZsaWN0cy4NCg0KVGhhbmtzDQpQaW5n
LUtlDQoNCg==
