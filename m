Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D5A30C371;
	Mon,  2 Mar 2026 06:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772431502; cv=none; b=enjAZhmTxA6Dzy3cyvW5iqIRUWADq02tPNGFLM1rntvG8pStf3r6barWw6MVE7pDCrGQjdlaY778IX89+E3fGGNYUK8BIUU08V4co1+WcO/W0vJpgxvWjTKntuVNTFoeP2pRSSjmeCYi272ocdLbvquuJGDZXwmOdKyhXCIy14c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772431502; c=relaxed/simple;
	bh=fUbRHij6DgtYURf6cEDohVQB51YcufBUpG4ybn68els=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nIxayiyfaR150pjcNFdfX0SRJlfkndAfH2UPzi+jhm6rwJvi/Z7VuAci/5fwdSfixw+IPos7bYgwG1Nc8tLdGBsUsAWYrd9SCNrvIptAhSlvgUBLKUElvxJj90oFNcaaaoVhAtUZmiyeJ0IcV+vFWbTRZollggmJaQW/Dw5vpT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=l6xF/xfh; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="l6xF/xfh"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 62264pGnA2475953, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1772431491; bh=fUbRHij6DgtYURf6cEDohVQB51YcufBUpG4ybn68els=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=l6xF/xfh4J7Yxp2MyIq6Gf+sY/BLe1zGYIakU4Rp/hqG02nSnM8M+RzNKX38JHF2g
	 tkKT9BuvBfevNEFck+Q0+XHGMspESUvvaE9OCskRPCcN54YoJZmestNABqX94pjcNz
	 7gj0cDyC0i3A0SzXE4EUBksi9PWhzO5rgmlJ0A9qJAmB/Mp7z/wuT2Eb0a5CLSHRl7
	 rDoBiqP4Ts9+6gC+mloecOgn1mBqpijiDkb3JQEd86/3+b25pZwG4hu9MlJrd60Css
	 Wo0dtNMtrn6avwfW9otqyoTiUW/jJ4RffwY1CXO0Z4v7DWULldX515q/3UicootXnN
	 8MAIpFG8N0YBA==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.21/5.94) with ESMTPS id 62264pGnA2475953
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 2 Mar 2026 14:04:51 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Mon, 2 Mar 2026 14:04:51 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Mon, 2 Mar 2026 14:04:51 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([fe80::4cbd:6c6c:b92b:3913]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::4cbd:6c6c:b92b:3913%10]) with mapi id
 15.02.1748.010; Mon, 2 Mar 2026 14:04:51 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Christian Hewitt <christianshewitt@gmail.com>
CC: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] wifi: rtw89: retry efuse physical map dump on transient
 failure
Thread-Topic: [PATCH] wifi: rtw89: retry efuse physical map dump on transient
 failure
Thread-Index: AQHcqTNMihHWcqnNfk6dLicVJRRJxLWavE1Q//99hoCAAIbrQA==
Date: Mon, 2 Mar 2026 06:04:51 +0000
Message-ID: <c764f16a880a400686c8c5f639fa98c3@realtek.com>
References: <20260301042422.195491-1-christianshewitt@gmail.com>
 <c751f9505a664f6895bacecb62bc534a@realtek.com>
 <E6E752BD-5F3D-4F30-9820-CB44FA767E69@gmail.com>
In-Reply-To: <E6E752BD-5F3D-4F30-9820-CB44FA767E69@gmail.com>
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

DQpDaHJpc3RpYW4gSGV3aXR0IDxjaHJpc3RpYW5zaGV3aXR0QGdtYWlsLmNvbT4gd3JvdGU6DQo+
ID4gT24gMiBNYXIgMjAyNiwgYXQgOTo0N+KAr2FtLCBQaW5nLUtlIFNoaWggPHBrc2hpaEByZWFs
dGVrLmNvbT4gd3JvdGU6DQo+ID4NCj4gPiBDaHJpc3RpYW4gSGV3aXR0IDxjaHJpc3RpYW5zaGV3
aXR0QGdtYWlsLmNvbT4gd3JvdGU6DQo+ID4+IE9uIFJhZHhhIFJvY2sgNUIgd2l0aCBhIFJUTDg4
NTJCRSBjb21ibyBXaUZpL0JUIGNhcmQsIHRoZSBlZnVzZQ0KPiA+PiBwaHlzaWNhbCBtYXAgZHVt
cCBpbnRlcm1pdHRlbnRseSBmYWlscyB3aXRoIC1FQlVTWSBkdXJpbmcgcHJvYmUuDQo+ID4+IFRo
ZSBmYWlsdXJlIG9jY3VycyBpbiBydHc4OV9kdW1wX3BoeXNpY2FsX2VmdXNlX21hcF9kZHYoKSB3
aGVyZQ0KPiA+PiByZWFkX3BvbGxfdGltZW91dF9hdG9taWMoKSB0aW1lcyBvdXQgd2FpdGluZyBm
b3IgdGhlIEJfQVhfRUZfUkRZDQo+ID4+IGJpdCBhZnRlciAxIHNlY29uZC4NCj4gPg0KPiA+IEkn
bSBjaGVja2luZyBpbnRlcm5hbGx5IGhvdyB3ZSBoYW5kbGUgdGhpcyBjYXNlLg0KPiA+DQo+ID4g
Wy4uLl0NCj4gPg0KPiA+Pg0KPiA+PiBGb3IgY29udGV4dCwgZmlybXdhcmUgYWxzbyBmYWlscyAo
YW5kIHJlY292ZXJzKSBzb21ldGltZXM6DQo+ID4NCj4gPiBEaWQgeW91IG1lYW4gdGhpcyBkb2Vz
bid0IGFsd2F5cyBoYXBwZW4/IHNvbWV0aW1lcz8NCj4gDQo+IEl04oCZcyBhbm90aGVyIGludGVy
bWl0dGVudCBiZWhhdmlvdXIgb2JzZXJ2ZWQgb24gdGhpcyBib2FyZCAoYW5kIG5vdA0KPiByZWxh
dGVkIHRvIHRoZSBpc3N1ZSB0aGlzIHBhdGNoIHRhcmdldHMpLiBJdCBvY2N1cnMgbGVzcyBmcmVx
dWVudGx5DQo+IHRoYW4gdGhlIGVmdXNlIGlzc3VlIGFuZCB0aGUgZXhpc3RpbmcgcmV0cnkgbWVj
aGFuaXNtIGluIHRoZSBkcml2ZXINCj4gZW5zdXJlcyBmaXJtd2FyZSBsb2FkIGFsd2F5cyBzdWNj
ZWVkcy4NCg0KQXMgaW50ZXJtaXR0ZW50IGJlaGF2aW91ciwgaXQgbWlnaHQgYmUgbm90IHdvcnRo
IHRvIHRyeSBETUEuIA0KDQpSZWNlbnRseSwgd2UgaGF2ZSBzb21lIHBhdGNoZXMgcmVsYXRlZCB0
byBQQ0kgaGFyZHdhcmUgc2V0dGluZ3MuIFBsZWFzZQ0KdXNlIHRoZSBsYXRlc3QgZHJpdmVyIGlu
Y2x1ZGluZyBwYXRjaCBbMV0gdG8gc2VlIGlmIGl0IGNhbiBiZSBzdGFibGUuDQoNClsxXSBhZjFl
ODIyMzJiOTggKCJ3aWZpOiBydHc4OTogcGNpOiByZXN0b3JlIExETyBzZXR0aW5nIGFmdGVyIGRl
dmljZSByZXN1bWUiKQ0KDQo+IA0KPiA+IFdlIGhhcyBzZWVuIHNpbWlsYXIgbG9nIGJlY2F1c2Ug
b2YgMzYtYml0IERNQS4gVHJ5IGJlbG93IHRvIGZvcmNlIDMyLSBvciAzNi0NCj4gPiBiaXQgRE1B
IHRvIHNlZSBpZiBpdCBjYW4gcmVzb2x2ZSBwcm9ibGVtIGluIHlvdXIgcGxhdGZvcm0uDQo+IA0K
PiBJIGNhbiBleHBlcmltZW50IGJ1dCB0aGlzIGRvZXNu4oCZdCBoYXBwZW4gb2Z0ZW4gc28gSSBw
cm9iYWJseSBjYW7igJl0DQo+IHByb3ZpZGUgbWVhbmluZ2Z1bCBmZWVkYmFjay4NCg0KDQoNCg==
