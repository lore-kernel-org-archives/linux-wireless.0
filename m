Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC9D261B70
	for <linux-wireless@vger.kernel.org>; Wed,  5 Aug 2026 01:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785893718; cv=none; b=KxRVmaM8L/vMY5e2cxRCcmGjD1WV0+LpQoqSEQJ09z9QBHouK1MExHzqYKtfB5tvvMXuEg1eHRBF440J6wk9PQJ9y7wVN54Mizj/BYAS/8EqXjCf0unqqMue/oTRHIWOO1Qj3KA1UUvp2iOda9kP9QhnqfjeLhH34SkfC4H/j6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785893718; c=relaxed/simple;
	bh=k+4qPxR1V1d3KYaNinDmjYZOyA4sduV276WlAx8eRiY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=k2wEfdw3G8LR/aDnKX31BlC+miMQLjZrFAt7F70q3UcQSOhY//ExShTFiMIV56/ITDrDc0aLbzqfWV3RuUreRfgJYHK1xCjr032Jsw/UmSzVoq5N6JxtudL2f3eAYqo79y47ND+Qlj+aNP3jPBPb0nT34Y7e0FoLIGpeJWTjDNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=MumxKRGY; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="MumxKRGY"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6751ZAzuC1478315, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1785893710; bh=k+4qPxR1V1d3KYaNinDmjYZOyA4sduV276WlAx8eRiY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=MumxKRGYndJXNg3MFfUAFIiTWOiiOU7Sbpu80Q13ZAP3fcBs8sVX9lb9lI3P7b0y7
	 +Ny3xgUZh5NDbkF4YdUxTV0qvItmGTZrtPZsRuaNxPn3cLA/wTckql5c3Q3Pz4ZlAi
	 JrKMkEJ7RyED4ObMPJNEnKpciOzhCShJ+apSxvk7vauqY/gtvIojkTOIHqp0prViOo
	 nl8ZxUY7+0eyDALBnGDggUGDkBOmT5oD9e7IG88IxJVnI0PUORZN5hrjA8737ux6dK
	 Ck9NpghKDzAlXdLYPAARS5TO5k6FFESSHSneqLUXmmrxMsiOaO/7bJ7yOL117X5DXe
	 /a2vB79mXITvQ==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6751ZAzuC1478315
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 5 Aug 2026 09:35:10 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 5 Aug 2026 09:35:11 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 5 Aug 2026 09:35:11 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::e6fd:5a3f:8946:92c4%10]) with mapi id
 15.02.2562.017; Wed, 5 Aug 2026 09:35:11 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Adrodoc <adrodoc55@googlemail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: Error in rtw89 using Kernel 7.1.4
Thread-Topic: Error in rtw89 using Kernel 7.1.4
Thread-Index: AQHdHdZdU24pRS7N10KrgD20Ysr2qbaCFWPAgAAJV2CAAAS0AIAAjzyAgAD0dVCAAAXTgIAAAl0AgAn324CAAQ3XcA==
Date: Wed, 5 Aug 2026 01:35:11 +0000
Message-ID: <013f7d3cf223417c94df41a2a45fa540@realtek.com>
References: <CAOQMLZVB3_wedJ89yNoCKTXOsuXWNq+T785bVQBSr3Yh-TPqeA@mail.gmail.com>
 <ea2f5ee46c064fb9b3a45e9d705e2f59@realtek.com>
 <1f8a2a023b064bca87a8f1e6712bca3d@realtek.com>
 <CAOQMLZWhvwxTk9PNa0E=73pBOoah8X-2C+xN5-VY_gCSVtBkVg@mail.gmail.com>
 <CAOQMLZWpPDbm5yiBg89GjzXnCwuQn+t5V=AP617MoH6q8Zu2zw@mail.gmail.com>
 <fe2f2e2a52ed4565b5c2927d872d82cc@realtek.com>
 <CAOQMLZU31dc6ZvNi_veM6uU1fSXYNBdnWLkOwH5xXR45uOFx1w@mail.gmail.com>
 <CAOQMLZWPMq=CCFpdg5wwsJ_QnrUKx_0YouTxdaSePO_0YPqcLA@mail.gmail.com>
 <CAOQMLZUn30NJwU4pR0hL=nz38Mbp=73wgqd+CoQE2qSO3cf4_w@mail.gmail.com>
In-Reply-To: <CAOQMLZUn30NJwU4pR0hL=nz38Mbp=73wgqd+CoQE2qSO3cf4_w@mail.gmail.com>
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

QWRyb2RvYyA8YWRyb2RvYzU1QGdvb2dsZW1haWwuY29tPiB3cm90ZToNCj4gQSBsaXR0bGUgdXBk
YXRlOiBJIG1hbmFnZWQgdG8gZG93bmdyYWRlIG15IGxpbnV4IGtlcm5lbCwgYnV0IEkgY2FuJ3QN
Cj4gaW5zdGFsbCB2ZXJzaW9ucyBvbGRlciB0aGFuIDYuNi45LWFyY2gxLTEsIGJlY2F1c2Ugd2hl
biB0cnlpbmcgdG8NCj4gaW5zdGFsbCB0aGVtIEkgZ2V0IGFuIGVycm9yOiBpbnZhbGlkIG9yIGNv
cnJ1cHRlZCBwYWNrYWdlIChQR1ANCj4gc2lnbmF0dXJlKS4NCj4gDQo+IFNvIEkgcmFuIDYuNi45
LWFyY2gxLTEgZm9yIDYgYW5kIGEgaGFsZiBob3VycyB0b2RheSB3aXRob3V0DQo+IGVuY291bnRl
cmluZyB0aGUgaXNzdWUuIFllc3RlcmRheSBJIHdhcyBydW5uaW5nIDcuMS41LTEtY2FjaHlvcyBh
bmQNCj4gaGFkIHRoZSBpc3N1ZSAzIHRpbWVzIHdoaWxlIHVzaW5nIG15IFBDIGZvciBqdXN0IG92
ZXIgNyBob3Vycy4gU28gdGhlDQo+IGlzc3VlIGlzIGxpa2VseSBub3QgcHJlc2VudCBpbiA2LjYu
OS1hcmNoMS4xLg0KDQpJIHN1Z2dlc3QgeW91IGNhbiB0cnkgNi42LjktYXJjaDEtMSBsb25nZXIu
IEFzIEkgY2hlY2tlZCBpbnRlcm5hbCBleHBlcnRzDQp3aG8gc2FpZCB0aGUgU0VSIHN5bXB0b20g
Y2FuIG9jY3VyIG9uIHNvbWUgcGxhdGZvcm1zIGluZnJlcXVlbnRseSBiZWNhdXNlDQpvZiBoYXJk
d2FyZSBmbGF3cy4gVGhlcmVmb3JlLCBpZiB0aGUgaW5mcmVxdWVudCBTRVIgZG9lc24ndCBib3Ro
ZXIgeW91cg0KZGFpbHkgd29yaywgdGhleSBzdWdnZXN0IHRvIGp1c3Qga2VlcCBpdCBhcyB3YXMu
IA0KDQpJZiB3ZSB3YW50IHRvIGRlYnVnIGZ1cnRoZXIsIG15IHBsYW4gaXMgdG8gYmlzZWN0IGRy
aXZlcnMgKG9yIGZpcm13YXJlKSB0bw0Kc2VlIHdoZXRoZXIgYSBjZXJ0YWluIHZlcnNpb24gY2Fu
IHdvcmsgd2VsbCBvbiB5b3VyIHBsYXRmb3JtLCBhbmQgd2UgY2FuDQpiaXNlY3QgdGhlIGNvbW1p
dHMgaW4gZGV0YWlsLiBBdCB0aGF0IHRpbWUsIEkgbmVlZCB5b3VyIGhlbHAgdG8gYnVpbGQNCmFu
ZCB0ZXN0IGRyaXZlciBrby4NCg0KVGhlIHNlY29uZCB3YXkgaXMgdG8gZGVidWcgb24gdGhlIGxh
dGVzdCBrZXJuZWwgYW5kIGFwcGx5IGRlYnVnIHBhdGNoIHRvDQpkdW1wIG1vcmUgZGV0YWlsIG5l
ZWRlZCBieSBpbnRlcm5hbCBleHBlcnRzLiBCdXQgaXQgc2VlbXMgbGlrZSB0aGlzIGlzDQpzdGls
bCB1bmNlcnRhaW4gYmVjYXVzZSBvZiBoYXJkd2FyZSBmbGF3IHRoZXkgbWVudGlvbmVkLg0KDQo+
IA0KPiBJJ2xsIHRyeSA2LjEyLjEwLmFyY2gxLTEgdG9tb3Jyb3cuDQoNClN1Z2dlc3QgdG8gdGVz
dCA2LjYuOS1hcmNoMS0xIGxvbmdlciBhcyBtZW50aW9uZWQgYWJvdmUuDQoNCg0K
