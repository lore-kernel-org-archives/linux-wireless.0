Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793088474;
	b=jI95Zw6svrC4BPayNmD4H01sM7YJ/B3h+teYrCD8FGL0I+TtJSUTCWi7T+HcNUtlOBPT
	 H4bW+5EFEuvrzA3YdILSxx/9y0rysg6d6jSI1ZNnl3MADdAP6MI0DtwSDc8cQ21fyBvKF
	 o/O7c9Yosk8TybaIc4ec5BZOgISFA3q1TItjM2triQc6yumvn7SxzzgKLE6V2aRHZLWSw
	 Ypy9n0DOywNWuXQ9w0jwxv+ycYhwh0lJtIFvVdRlSyTM9tOAw8HANv+qngkpXWL14Yb5K
	 H9uUitQRJBTLWPbnunRTmBKPTF9JduoQ6SpytL2boYMBoD1Sytbcse0QeaDZpYZjaHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793088474;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Subject:Thread-Topic:Thread-Index:Date:
	 Message-ID:References:In-Reply-To:Accept-Language:Content-Language:
	 x-originating-ip:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=p2FUosd8jraWO4FJpdYfHKFAn6dWRAeu/2/Rl1+IZvY=;
	b=A6jy379Ld8lj7t+d7C8etapjYfNy75jgYq18Ad3LgaS4TpmfOegZl7PYN0R8MpQ2QEK3
	 +tlwG8fJAmF811NtZOxc2prgFLV/piSEUv4ZtTiYVkXpFbu3f4Y9HETTrahyFUPS/1eN3
	 KGwk16JgXR0TGXgjYjgr3gDCndBgVPnQVLJlj8tlUd83D6iO9AAFxiShWL7c+JrzVM7GR
	 Ys29ync2NQOMa/KxZb6vmopgByVSnUjMy2b7MfCrkmsmFztciZ5Ce4NJ/tJ0lVKNQfR9r
	 i0YE866RDR5qKffWLhRwXtwpFrUEbfBC0QC6Xe38Na9nxZqWf1fiPKKv1OaiPnukkiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=N7ooP2Ou;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E713606A31B
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 08:07:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4E713606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=N7ooP2Ou
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69R87gZV2781037, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1793088462; bh=p2FUosd8jraWO4FJpdYfHKFAn6dWRAeu/2/Rl1+IZvY=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=N7ooP2Ou7NeQFid4cMcztm4K2rotsSopMevnGiEsiKa8q/lBsy7t/cVCk56A/bfEv
	 b4/MzUE+0GFgYM+YZEaX0uw68BwnSc0D+ceBCoKqmKLMt1E1WuDCY2MTJ0ZBA6a8Rq
	 aU4lgS4YGzJJuGPXxYW3ZWt6kLypYFxreY2sKvUtHmTUCh9m+GEZiZ0Xyq6R+l81Ti
	 emLP/uu6RCOIPnAsisuRB2bGQsIL4JXzMMrlOiN+psu+/BtSIRUzfBg3SRDOjYKNOO
	 YGHmZXukeeTtltt3XYjyBiIcf2o0bz6PRJPIdu26Bt95ebTEKkA8eHCf93X2Iulgn6
	 oqYRYYFIRwVAg==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69R87gZV2781037
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 27 Oct 2026 16:07:42 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 27 Oct 2026 16:07:41 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 27 Oct 2026 16:07:41 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Tue, 27 Oct 2026 16:07:41 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Luka Gejak <luka.gejak@linux.dev>, Bitterblue Smith
	<rtl8821cerfe2@gmail.com>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>
Subject: RE: [PATCH rtw-next 0/5] wifi: rtw88: pci: Support an older design,
 like RTL8821AE/RTL8812AE
Thread-Topic: [PATCH rtw-next 0/5] wifi: rtw88: pci: Support an older design,
 like RTL8821AE/RTL8812AE
Thread-Index: AQHdY0HfQGIda1zW60KKJQiEj21Ec7cQnBmQ///f5gCAAIfO8A==
Date: Tue, 27 Oct 2026 08:07:41 +0000
Message-ID: <4d5c2cf2b45349f8a96f940dfd3dde36@realtek.com>
References: <2033f1b1-fb12-4a04-aef4-923590e64463@gmail.com>
 <4c0eae7568334475b3b9a57e50f5c912@realtek.com>
 <fc98b0719bad6282083133041e80136a7215359f@linux.dev>
In-Reply-To: <fc98b0719bad6282083133041e80136a7215359f@linux.dev>
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

DQpMdWthIEdlamFrIDxsdWthLmdlamFrQGxpbnV4LmRldj4gd3JvdGU6DQo+ID4gPg0KPiA+ID4g
UG93ZXJpbmcgb2ZmIGFuZCBvbiBhZ2Fpbiwgd2hpY2ggaGFwcGVucyBhIGxvdCB3aGVuIHRoZSB3
aWZpDQo+ID4gPiAgaW50ZXJmYWNlIGlzIGlkbGUsIGRvZXNuJ3QgaGVscC4NCj4gPiA+DQo+ID4g
PiAgVGhlIG9ubHkgdGhpbmcgdGhhdCBzZWVtcyB0byBoZWxwIGlzIHJlbG9hZGluZyB0aGUgZHJp
dmVyLCBidXQgZXZlbg0KPiA+ID4gIHRoYXQgbWF5IG5vdCBhbHdheXMgd29yay4NCj4gPiA+DQo+
ID4gSSB0aGluayByZWxvYWRpbmcgdGhlIGRyaXZlciBhbmQgaW50ZXJmYWNlIGlkbGUgYXJlIHZl
cnkgc2ltaWxhciAoYWxtb3N0DQo+ID4gdGhlIHNhbWUpLiBObyBpZGVhIHdoeSB0aGV5IGhhdmUg
ZGlmZmVyZW50IHJlc3VsdHMuDQo+IA0KPiBNYXliZSBmaXJtd2FyZSByZWxvYWQ/DQoNCldoZW4g
aW50ZXJmYWNlIHVwIGZyb20gaWRsZSwgaXQgd2lsbCByZWxvYWQgZmlybXdhcmUgYWdhaW4sIHNv
IEkgdGhpbmsgbm90DQp0aGUgY2FzZS4uLg0KDQpQaW5nLUtlDQoNCg==
