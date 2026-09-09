Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E515333E35B
	for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2026 03:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788925151; cv=none; b=S5SMeY8/sV1WYbb78BR4JS5E14GyK7HBg7q3y3j481ohkfv1TZGdSzTSYNmXKxp/bn8AfsHiTF5vfSXMDCGWwEsV72ccfGFmC6RpSAraaKzPWiHfxEcDfu+FIiFMfni411UzHuZMBoD1CYowYwW6CefmQ1NNde7OraUCMHarqDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788925151; c=relaxed/simple;
	bh=zvJiT6CzSYNz+mpYBVJcMtPXqZN14Oe0Rry7eRzT4z8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WzOaGZ+B60omug9lA6NnkLhJZ7mTbbQcxih8Ir94/2xZhgTyIX3wSh7p3QNiGNkLVpJ8XP2+ftqHBNkkSj5rIwufLBJwq2DElksL/t/X0i+2Qcwc+baKUVXw2zgQ18nlFYI1ptQpCjleJXzLp0cslNJG0uEX/4Pq7J2cl5Rqy3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=S8iiRbve; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="S8iiRbve"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6893coIaB262022, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788925130; bh=zvJiT6CzSYNz+mpYBVJcMtPXqZN14Oe0Rry7eRzT4z8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=S8iiRbvenUfTYOcjbjwPxWd3cGVPl/nN8ov06oCBYIHFXAqfNwnd9myxFkpd3ncG1
	 8i3JCe1ANdc5+0u4EzMd5BxqqsJbSiPnrIJryT88PV9IWQlZl7OrLwGVc2Sai/rMUH
	 /uuqLlybtDxE87DRRExIY4CssY2yknUaPbf+r7ljKmAob36DVhVCr2VTgjkpwY+ROD
	 gY2r7Ma6Q2mxzoy2p/xSxn0+tMVQcZ6e30oB6jjS7vmcKmQkRtwI4CPcQ7QN1YOT/D
	 2KOOnFNYm4Rmefq1b2v0RjU9SOskQqfYcYXRLfNvvKRNAwYcC599NE9pNvrcP+L6x2
	 cB1HZI5WOC7DA==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6893coIaB262022
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 9 Sep 2026 11:38:50 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 9 Sep 2026 11:38:49 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Wed, 9 Sep 2026 11:38:49 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: secure_email <securelevelone@gmail.com>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>
CC: "kvalo@kernel.org" <kvalo@kernel.org>
Subject: RE: [BUG] rtw89: kernel panic in rtw89_core_acquire_sta_ba_entry
 (list_del corruption)
Thread-Topic: [BUG] rtw89: kernel panic in rtw89_core_acquire_sta_ba_entry
 (list_del corruption)
Thread-Index: AQHdPzy+XXA+M7j+KES4OgpoSQSJbLbEUWVQgAFIb9A=
Date: Wed, 9 Sep 2026 03:38:49 +0000
Message-ID: <05d59bc0ceeb4dab92979504626ca868@realtek.com>
References: <CACj-1MxFTc1CUgVbbUC3VQxi-DBBNvDkPmsN1OLxn1e0t+PgnQ@mail.gmail.com>
 <CAH-fA9oS2N-D05BSd0DDp_hGtBEH==cLuxr1XCUiL_UC3CN+bg@mail.gmail.com>
 <6b2ba863e0ec4251bcf6216f289e8bcf@realtek.com>
In-Reply-To: <6b2ba863e0ec4251bcf6216f289e8bcf@realtek.com>
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

UGluZy1LZSBTaGloIHdyb3RlOg0KPiAocGxlYXNlIHVzZSBwbGFpbiB0ZXh0IGFuZCBub3QgdG9w
IHBvc3RpbmcpDQo+IA0KPiBzZWN1cmVfZW1haWwgPHNlY3VyZWxldmVsb25lQGdtYWlsLmNvbT4g
IHdyb3RlOg0KPiA+IEhhcmR3YXJlOiBSZWFsdGVrIFJUTDg5MjJBRSAocnR3ODlfODkyMmFlKQ0K
PiA+IEtlcm5lbCB2ZXJzaW9uOiA3LjEuNi0yMDEuZmM0NC54ODZfNjQNCj4gPiBEaXN0cmlidXRp
b246IEZlZG9yYSBDb3NtaWMgQXRvbWljIDQ0DQo+ID4NCj4gPiBEZXNjcmlwdGlvbjoNCj4gPiBB
IGtlcm5lbCBwYW5pYyBvY2N1cnMgZHVyaW5nIEJsb2NrIEFjayAoQkEpIHNlc3Npb24gYWNxdWlz
aXRpb24vDQo+ID4gdGVhcmRvd24gaW4gdGhlIHJ0dzg5IGRyaXZlci4NCj4gPiBUaGUga2VybmVs
IHJlcG9ydHMgYSAibGlzdF9kZWwgY29ycnVwdGlvbiIgaW5zaWRlDQo+ID4gcnR3ODlfY29yZV9h
Y3F1aXJlX3N0YV9iYV9lbnRyeSwgd2hpY2ggcG9pbnRzIHRvIGEgcG90ZW50aWFsIHJhY2UNCj4g
PiBjb25kaXRpb24gb3IgbWlzc2luZyBsb2NrIGR1cmluZyBCQSBlbnRyeSBtYW5hZ2VtZW50IHVu
ZGVyIFdpLUZpIGxvYWQuDQo+IA0KPiBCb3RoIHJ0dzg5X2NvcmVfYWNxdWlyZV9zdGFfYmFfZW50
cnkoKSBhbmQgcnR3ODlfY29yZV9yZWxlYXNlX3N0YV9iYV9lbnRyeSgpDQo+IGhvbGQgd2lwaHlf
bG9jaygpLCBzbyBJIHRoaW5rIHRoZXJlIHNob3VsZCBiZSBubyByYWNlIGNvbmRpdGlvbi4NCj4g
DQo+ID4NCj4gPiBTdGVwcyB0byByZXByb2R1Y2U6DQo+ID4gMS4gVXNlIGNvbXB1dGVyIHJlZ3Vs
YXJseSAoc3BlY2lmaWNhbGx5IG9uIHdpZmkgYXMgdGhhdCBpcyBob3cgYnVnIGlzDQo+ID4gdHJp
Z2dlcmVkKSBubyBtYXR0ZXIgaWYgZG93bmxvYWRpbmcgc29tZSBmaWxlcywgc3VyZmluZyB0aGUg
d2ViLA0KPiA+IGdhbWluZyBvciBzdGVwcGluZyBhd2F5IGZyb20gUEMuDQo+ID4gMi4gV2l0aGlu
IGEgZmV3IG1pbnV0ZXMgYW5kIHVwIHRvIGFyb3VuZCA0MCBtaW51dGVzIGJ1ZyBpcyB0cmlnZ2Vy
ZWQuDQo+IA0KPiBGcm9tIHRoaXMgcG9pbnQsIGl0IGRpZCBjb25uZWN0aW9uIGFuZCBkaXNjb25u
ZWN0aW9uIGZyZXF1ZW50bHkuIEFyZSB0aGV5DQo+IGludGVudGlvbmFsIG9yIHNvbWV0aGluZyB3
cm9uZz8NCj4gDQo+IE1heSAxOSAyMzo0Nzo1MiBrZXJuZWw6IHdscDhzMDogYXV0aGVudGljYXRl
IHdpdGggeHg6eHg6eHg6eHg6eHg6eHgNCj4gDQo+IFRoZSBjb25uZWN0aW9uIGJlY29tZXMgZGlz
Y29ubmVjdGVkIGFib3V0IDF+NSBtaW51dGVzLiBEaWQgeW91IGNvbnRyb2wNCj4gV2lGaSB2aWEg
R1VJPw0KPiANCj4gTWF5IDE5IDIzOjUzOjA2IGtlcm5lbDogd2xwOHMwOiBhc3NvY2lhdGVkDQo+
IE1heSAxOSAyMzo1NDowNiBrZXJuZWw6IHdscDhzMDogZGVhdXRoZW50aWNhdGluZyBmcm9tIHh4
Onh4Onh4Onh4Onh4Onh4DQo+IA0KPiBUcnkgdG8gZGlzYWJsZSBwb3dlciBzYXZlIHRvIHNlZSBp
ZiBpdCBjYW4gYmVjb21lIGJldHRlcjoNCj4gDQo+ICAgIHN1ZG8gaXcgd2xhbjAgc2V0IHBvd2Vy
X3NhdmUgb2ZmDQo+IA0KPiA+DQo+ID4gU3lzdGVtIGJlaGF2aW9yOg0KPiA+IFdpZmkgdG9nZ2xl
IGluIHNldHRpbmdzIHN0b3BzIGZ1bmN0aW9uaW5nIChzdHVjayBvbiAiZW5hYmxlZCIpLA0KPiA+
IGZvbGxvd2VkIGJ5IGRlZ3JhZGF0aW9uIGluIGNlcnRhaW4gYXBwbGljYXRpb25zLCBsb3NzIG9m
IGludGVybmV0DQo+ID4gY29ubmVjdGl2aXR5IGJvdGggaW4gdGVybWluYWwgYW5kIGJyb3dzZXIs
IGV0Yy4sIGFuZCBpZiBJIGRlY2lkZSB0bw0KPiA+IHJlYm9vdCB0aGUgc3lzdGVtIGl0IHdpbGwg
aGFuZyBpbmRlZmluaXRlbHkgdW5sZXNzIEkgZG8gYSBoYXJkDQo+ID4gc2h1dGRvd24uDQo+ID4N
Cj4gPiBDYWxsIFRyYWNlIC8gUGFuaWMgTG9ncyBjYW4gYmUgZm91bmQgaW4gdGhlIGF0dGFjaG1l
bnRzIGJlbG93Lg0KPiA+DQo+ID4gQWRkaXRpb25hbCBpbmZvOg0KPiA+IEkgaW5pdGlhbGx5IHJl
cG9ydGVkIHRoaXMgb24gUmVkIEhhdCBCdWd6aWxsYSAoQnVnIDI0OTc5NzMpLCBidXQgYW0NCj4g
PiBzZW5kaW5nIHRoaXMgdXBzdHJlYW0gYXMgcmVxdWVzdGVkIHRvIGhlbHAgZ2V0IHRoZSBwYW5p
YyBiYWNrdHJhY2UgaW4NCj4gPiBmcm9udCBvZiBydHc4OSBtYWludGFpbmVycy4NCj4gPg0KPiA+
DQo+IA0KPiBQbGVhc2UgYXBwbHkgYXR0YWNoZWQgZGVidWcgcGF0Y2gsIGFuZCBjb2xsZWN0IGFu
ZCBzaGFyZSBsb2cgdG8gbWUuDQo+IA0KDQpXZSBoYXZlIHJlcHJvZHVjZWQgdGhpcyBwcm9ibGVt
IGFuZCBvbmdvaW5nIHRvIHNwaW4gYSBwYXRjaCwgc28gbm8gbmVlZA0KdG8gdGVzdCB0aGUgZGVi
dWcgcGF0Y2guIA0KDQpJbiBzaG9ydCB0ZXJtLCB5b3UgY2FuIGNvbm5lY3Qgbm9uLU1MTyBBUCB0
byBhdm9pZCB0aGUgcHJvYmxlbS4gSWYNCnlvdSBjYW4gYnVpbGQgZHJpdmVyIGFuZCB3YW50IHNo
b3J0IHRlcm0gd29ya2Fyb3VuZCwgSSBjYW4gc2hhcmUNCm9uZSB0byB5b3UuDQoNCkNvdWxkIHlv
dSBzaGFyZSB5b3VyIHJlYWwgbmFtZT8gU28sIEkgY2FuIGFkZCBSZXBvcnRlZC1ieSB0YWcgaW4g
dGhlDQpwYXRjaC4NCg0KUGluZy1LZQ0KDQo=
