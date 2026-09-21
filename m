Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15943182D6;
	Mon, 21 Sep 2026 00:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789950299; cv=none; b=CqGCLXiY8qF+JkoH93+M9GR+xpeDgajdXWE5Y1CsTy/keiDAWb3Ey65hxSItXGQIz12YJ85RaDhDsul9FaiWo5Of/hZ/2G6jkGx4SnTfI5AT124UgIgl4htOqYvsNkPPHa+ZGJYwkpyPs6jKM3bvk6siPDJtPlW4LUWH6KaRpso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789950299; c=relaxed/simple;
	bh=RTps4b7AgCDUzJ6XTlVnLeDVbfPbV1Q4UVbT5Frtu/E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jV0DDG/ULMMU4Liy7HK9t5bUXhLXsYjoqb4JuMHKW8J6xlgU280cR9ULGwwlv2OzXcVnUoJi48erpcem2wrmOZbTFZkK8tJGTbu5sU1Hnh1HWpoNZA603fYM7s+kU5IWkYNRADDMruEJ7GxKzT6xBStDtmgXIBCaiTv6wpPICUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=TyhtAqQ5; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="TyhtAqQ5"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68L0Oli862112443, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789950287; bh=RTps4b7AgCDUzJ6XTlVnLeDVbfPbV1Q4UVbT5Frtu/E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=TyhtAqQ5HfDosoK/ZhaU1lQ1Cp1D0xmbStY90zjU0LefPp6dMNE2HgWZwcog24jkP
	 7CsIG58XQLzyf07ZbHxJX/CkUbFOYVJKes+jlK+gvSBzdsFdrVZvYJPSBe9TC5L9By
	 lUMOcrFdtCmbKA++58192HDJI4MczZAIDSfbfk+QOqDlRuTeTMgzYVfmLjJMWW6mMN
	 +Z3i/yRxoDRn9dq8B22Uc/9R67MjsOliXnqOBaUwCBT3YJUm6s/MZWnXTWsSytL8G+
	 hYIh0xo+Pc5E221h5n9ztdJwj85/fu0Ry0dwGudfghlioJHsIo7ArtAotOQVgXXDw5
	 BKUgx7PErSDJg==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68L0Oli862112443
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 21 Sep 2026 08:24:47 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 21 Sep 2026 08:24:47 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 21 Sep 2026 08:24:47 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Mon, 21 Sep 2026 08:24:47 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Kim Wooseok <5mghybrid@khu.ac.kr>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>, "Jes
 Sorensen" <Jes.Sorensen@gmail.com>, Kalle Valo <kvalo@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH rtw-next v3 3/3] wifi: rtl8xxxu: preserve RX requests
 across recoverable transfer errors
Thread-Topic: [PATCH rtw-next v3 3/3] wifi: rtl8xxxu: preserve RX requests
 across recoverable transfer errors
Thread-Index: AQHdSHefc/MCcPjZN023IjBlQWSIu7bW0LzQ///JSYCAAZIJUA==
Date: Mon, 21 Sep 2026 00:24:47 +0000
Message-ID: <8d8e60e260254dc2a2cc1f37cd1b3832@realtek.com>
References: <20260920-codex-rtl-rx-v3-submit-v3-0-883d11351963@khu.ac.kr>
 <20260920-codex-rtl-rx-v3-submit-v3-3-883d11351963@khu.ac.kr>
 <9b5c31541fc8430b9d4205dcdff9e76e@realtek.com>
 <CAH1Bc_yTizX4Cex+GRLeRUtaBdp8jEc2XEyawMzkQsZFpj1QGw@mail.gmail.com>
In-Reply-To: <CAH1Bc_yTizX4Cex+GRLeRUtaBdp8jEc2XEyawMzkQsZFpj1QGw@mail.gmail.com>
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

S2ltIFdvb3Nlb2sgPDVtZ2h5YnJpZEBraHUuYWMua3I+IHdyb3RlOg0KPiA+IE5vdCBwcmVmZXIg
dXNpbmcgYmFyZSBzeXN0ZW1fd3EuDQo+ID4gQ2FuIGJvdGggdXNlIHNjaGVkdWxlX2RlbGF5ZWRf
d29yaygpPw0KPiANCj4gSW4gdjMsIHRoZSBlcnJvciBwYXRoIHVzZXMgcXVldWVfZGVsYXllZF93
b3JrKHN5c3RlbV93cSwgLi4uLCBkZWxheSksDQo+IHdoaWxlIG5vcm1hbCBjb21wbGV0aW9ucyB1
c2UgbW9kX2RlbGF5ZWRfd29yayhzeXN0ZW1fd3EsIC4uLiwgMCkuDQo+IA0KPiBJIGNhbiByZXBs
YWNlIHRoZSBlcnJvci1wYXRoIGNhbGwgd2l0aCBzY2hlZHVsZV9kZWxheWVkX3dvcmsoKS4NCj4g
SG93ZXZlciwgdGhlIG5vcm1hbC1jb21wbGV0aW9uIHBhdGggaXMgaW50ZW5kZWQgdG8gYnJpbmcg
YW4gZXhpc3RpbmcNCj4gZGVsYXllZCByZXRyeSBmb3J3YXJkIHdoZW4gdGhlIHBlbmRpbmcgY291
bnQgZXhjZWVkcyB0aGUgYmF0Y2hpbmcNCj4gdGhyZXNob2xkLCB3aGljaCBzY2hlZHVsZV9kZWxh
eWVkX3dvcmsoLi4uLCAwKSBjYW5ub3QgZG8gYmVjYXVzZSBpdA0KPiBsZWF2ZXMgYW4gYWxyZWFk
eSBwZW5kaW5nIHRpbWVyIHVuY2hhbmdlZC4NCg0KSSBrbmV3IHRoaXMgcG9pbnQuIERvZXMgaXQg
bWF0dGVyIHRvIHNjaGVkdWxlIGEgbm9ybWFsIGNhc2UgaW1tZWRpYXRlbHkNCmFmdGVyIGFuIGVy
cm9yIGNhc2UgKGRlZmVyIHRvIHNjaGVkdWxlKSBoYXBwZW5lZCB3aXRoaW4gMTAwbXM/DQooSnVz
dCBhbiBvcGVuIHF1ZXN0aW9uKQ0KDQo+IA0KPiBXb3VsZCBpdCBiZSBPSyB0byByZXRhaW4gbW9k
X2RlbGF5ZWRfd29yaygpIGZvciBub3JtYWwgY29tcGxldGlvbnMsDQo+IGNoYW5naW5nIGl0cyBx
dWV1ZSBhcmd1bWVudCB0byBzeXN0ZW1fcGVyY3B1X3dxPw0KDQpPSyBpZiBhYm92ZSBxdWVzdGlv
biBpcyB5ZXMuIA0KDQpPciBib3RoIGNoYW5nZSB0byB1c2UgbW9kX2RlbGF5ZWRfd29yaygpPw0K
DQo+IA0KPiBXaXRoIHRoYXQgY2hhbmdlLCBzY2hlZHVsZV9kZWxheWVkX3dvcmsoKSB3b3VsZCBz
ZWxlY3Qgc3lzdGVtX3BlcmNwdV93cQ0KPiBpbnRlcm5hbGx5LCBhbmQgbW9kX2RlbGF5ZWRfd29y
aygpIHdvdWxkIHVzZSB0aGUgc2FtZSBxdWV1ZSBleHBsaWNpdGx5Lg0KPiANCg0K
