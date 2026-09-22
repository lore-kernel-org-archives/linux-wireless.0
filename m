Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1A283403E8;
	Tue, 22 Sep 2026 02:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790045698; cv=none; b=iQFCR181cevfZ83/rtR5mPd0itCDCGAvdiC48kGQbHLgli9ECmN0e7GY3otjHhnmdY+CalwS8QkFDP2CwX4LO4aRLkXUU8iAy7N0vhMfGTl7q9w8hYlWU2G9ks75oJ7HrxhSDkUodglhrfBzM6/H1qZtEFL5hpeEhUCKaJgNLBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790045698; c=relaxed/simple;
	bh=joyC7vA/x3Qfj9CpZWtrx0oMIDMgoJWmkeky2xTjkO8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KAhxdQlPSsYjYM+7THMxSp0xcJH0SArN04yjiZPtHC8wYjqK56/EyVjrmlZkjj5Mhgt2oidZxplzp0knVDJfWSFOWOjvtyioR0sHs4G7hvEdgIUdAOMEijvY7yaORVpT0FDskmFMfS5LulLMr4BMZu04i9du3a3j6DOH1Aeisro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=t/iE1Vvo; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="t/iE1Vvo"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68M2sb7wB3200092, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790045678; bh=joyC7vA/x3Qfj9CpZWtrx0oMIDMgoJWmkeky2xTjkO8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=t/iE1Vvoy5e/LIqm9S9AmX1fy33xGvOSo2300mjxIbXEWXSEpJoluot75a9t+Jj9u
	 3itH7vP0Fq2obhRvZMH0+C9M9Rw+CRW5yEV0JFfHpqZ2dT5FZrhC1/oWgFZ/McJtzL
	 iLj4dIvk43azWry8hvhHMZvzjZtxhjShbCOQi7e/c87QDsbQ5Qmxilkj4rNjJI+I76
	 dtwSON2KYCeu1zwVaWc92+F0xlwaXTSXFniPHjCVbF75hjOGMZZu1r2aZHYgYMESjX
	 Sp26tUrP//qtmQhZkO91eYk71RG5//OsD9KDkekVF/L424KsbLvMr7d+FYqvmyu+KG
	 XyJM9FUkp8kdA==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68M2sb7wB3200092
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 22 Sep 2026 10:54:38 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 22 Sep 2026 10:54:37 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 22 Sep 2026 10:54:37 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Tue, 22 Sep 2026 10:54:37 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: "5mghybrid@khu.ac.kr" <5mghybrid@khu.ac.kr>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Jes Sorensen <Jes.Sorensen@gmail.com>, Kalle Valo <kvalo@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH rtw-next v4 3/3] wifi: rtl8xxxu: preserve RX requests
 across recoverable transfer errors
Thread-Topic: [PATCH rtw-next v4 3/3] wifi: rtl8xxxu: preserve RX requests
 across recoverable transfer errors
Thread-Index: AQHdSZ88DeoL8nGTG0ag1MBs5R7vdrbZ6AXQ
Date: Tue, 22 Sep 2026 02:54:36 +0000
Message-ID: <774ea22c4a7d4509990197d1fe795b08@realtek.com>
References: <20260921-codex-rtl-rx-v3-submit-v4-0-eeb09fe8f791@khu.ac.kr>
 <20260921-codex-rtl-rx-v3-submit-v4-3-eeb09fe8f791@khu.ac.kr>
In-Reply-To: <20260921-codex-rtl-rx-v3-submit-v4-3-eeb09fe8f791@khu.ac.kr>
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

S2ltIFdvb3Nlb2sgdmlhIEI0IFJlbGF5IDxkZXZudWxsKzVtZ2h5YnJpZC5raHUuYWMua3JAa2Vy
bmVsLm9yZz4gd3JvdGU6DQo+IEZyb206IEtpbSBXb29zZW9rIDw1bWdoeWJyaWRAa2h1LmFjLmty
Pg0KPiANCj4gcnRsOHh4eHUgcmVzdWJtaXRzIGNvbXBsZXRlZCBSWCByZXF1ZXN0cyB3aGVuIG1v
cmUgdGhhbiBlaWdodCBVUkJzIGFyZQ0KPiB3YWl0aW5nIG9uIHRoZSBwZW5kaW5nIGxpc3QuIEl0
IHN0YXJ0cyB3aXRoIDMyIFVSQnMsIGJ1dCBmcmVlcyB0aGVtIG9uDQo+IGNvbXBsZXRpb24gZXJy
b3JzLiBBZnRlciBlbm91Z2ggZXJyb3JzLCB0aGUgcmVtYWluaW5nIHBvb2wgY2FuIG5vIGxvbmdl
cg0KPiByZWFjaCB0aGUgc3VibWlzc2lvbiB0aHJlc2hvbGQuIFJlY2VwdGlvbiB0aGVuIHN0YXlz
IHN0b3BwZWQgZXZlbiBhZnRlcg0KPiB0aGUgZXJyb3JzIGVuZC4gVGVtcG9yYXJ5IHN1Ym1pc3Np
b24gZmFpbHVyZXMgY2FuIGxlYXZlIGEgc21hbGwgYmF0Y2gNCj4gd2FpdGluZyB3aXRoIG5vIGZ1
cnRoZXIgd29yayBzY2hlZHVsZWQsIHRvby4NCj4gDQo+IEtlZXAgdGhlIFVSQiB3aGVuIGEgY29t
cGxldGlvbiByZXBvcnRzIEVQUk9UTywgRUlMU0VRLCBFVElNRSwgRU9WRVJGTE9XLA0KPiBFQ09N
TSBvciBFTk9TUi4gRnJlZSBpdHMgcmVjZWl2ZSBidWZmZXIgYW5kIHJldHVybiB0aGUgcmVxdWVz
dCB0byB0aGUNCj4gc2FtZSBwZW5kaW5nIGxpc3QgdXNlZCBieSBub3JtYWwgY29tcGxldGlvbnMu
IEVOT01FTS9FQUdBSU4gZnJvbSBzdGFydHVwDQo+IG9yIHdvcmtlciBzdWJtaXNzaW9uIHVzZXMg
dGhpcyBwYXRoIGFzIHdlbGwsIHNvIGEgc3VibWlzc2lvbiBmYWlsdXJlDQo+IGNhbm5vdCBzdHJh
bmQgYSByZXF1ZXN0IGR1cmluZyByZWNvdmVyeS4NCj4gDQo+IFVzZSBvbmUgZGVsYXllZCB3b3Jr
IGl0ZW0gdG8gc3VibWl0IHRoZSBwZW5kaW5nIHJlcXVlc3RzLiBBbiBlcnJvcg0KPiBxdWV1ZXMg
YSByZXRyeSBhZnRlciAxMDAgbXMgd2l0aG91dCBtb3ZpbmcgYW4gZXhpc3RpbmcgcmVzZXJ2YXRp
b24gYmFjay4NCj4gSWYgYSBub3JtYWwgY29tcGxldGlvbiB0YWtlcyB0aGUgcGVuZGluZyBjb3Vu
dCBhYm92ZSBlaWdodCwNCj4gbW9kX2RlbGF5ZWRfd29yayguLi4sIDApIGJyaW5ncyB0aGUgd29y
ayBmb3J3YXJkLiBUaGlzIGxpbWl0cyByZXBlYXRlZA0KPiByZXRyaWVzIHdoZW4gcmVjZXB0aW9u
IGlzIG5vdCBwcm9ncmVzc2luZywgd2hpbGUgYWxsb3dpbmcgbm9ybWFsIHRyYWZmaWMNCj4gdG8g
cmVwbGVuaXNoIHRoZSBwb29sIHByb21wdGx5LiBUaGUgMTAwIG1zIGRlbGF5IGlzIHRoZXJlZm9y
ZSBub3QgYQ0KPiBtaW5pbXVtIHdhaXQgZm9yIGVhY2ggZmFpbGVkIFVSQi4NCj4gDQo+IEtlZXAg
dGhlIHNodXRkb3duIGNoZWNrLCBxdWV1ZSBpbnNlcnRpb24gYW5kIHNjaGVkdWxpbmcgdW5kZXIg
dGhlIFJYDQo+IGxvY2suIFN0b3Agc2V0cyBzaHV0ZG93biB1bmRlciB0aGF0IGxvY2ssIGNhbmNl
bHMgdGhlIGRlbGF5ZWQgd29yaw0KPiBzeW5jaHJvbm91c2x5LCB0aGVuIGRyYWlucyBhY3RpdmUg
YW5kIHBlbmRpbmcgcmVxdWVzdHMuIENhbmNlbGxhdGlvbiBhbmQNCj4gZGV2aWNlIHJlbW92YWwg
Y29udGludWUgdG8gZnJlZSB0aGVpciBVUkJzLg0KPiANCj4gRml4ZXM6IDI2ZjFmYWQyOWFkOSAo
Ik5ldyBkcml2ZXI6IHJ0bDh4eHh1IChtYWM4MDIxMSkiKQ0KPiBBc3Npc3RlZC1ieTogR1BULTYg
QXN0cmENCj4gU2lnbmVkLW9mZi1ieTogS2ltIFdvb3Nlb2sgPDVtZ2h5YnJpZEBraHUuYWMua3I+
DQoNClJldmlld2VkLWJ5OiBQaW5nLUtlIFNoaWggPHBrc2hpaEByZWFsdGVrLmNvbT4NCg0KDQo=
