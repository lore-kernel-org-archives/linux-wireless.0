Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6252E2ED84A;
	Wed, 12 Aug 2026 00:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786495123; cv=none; b=b16CnTPFkoehTcBWuSsLokVn7Nklqr+3fupKD6FrmO6EluzMkMsTD5zDTM25BQrigU5SDiE/ifJfTgmlTaS7rRtiEzpKj008Pb7aKAL9B8GD/GZ/7NEddA/gW18ZgcrAnxHI4vWZqJ4HgbVsnvTgZAGza4t8xrVQORX6VobNYgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786495123; c=relaxed/simple;
	bh=czfj11ozBZzkuvBWWwOEwI0zLl6a80VresJhn8IrRhI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sihuAPGNH2uMbvyC/mAcZGZyJWimRi8qkmGH05bzWnEHFSfBRlPJaKCcd3LQXhnSBDVvmGKOGNF9fegEzbC6E+ZXJmtRRIhg9WcXNnH9GNKJZyjMFCZxnt0skttnp0wMUi+UrziuunaVZFSPhJ1MpmtYfW0yFYEeez14fziXu5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=Zuu3yeJG; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="Zuu3yeJG"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67C0cNMo93140474, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1786495103; bh=czfj11ozBZzkuvBWWwOEwI0zLl6a80VresJhn8IrRhI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=Zuu3yeJGsBvYoFl2gKTPPDHaiebUGzKsBBCiTh4g21ShfUq9TKAxWmn0FQn+gpako
	 HU5EVpay5cEUwHoeySAM1swaibsddGC46LAhNMoW7CU7Cao5BwOCq/vt06GOLMtxdv
	 hFUFK2GVE2dcNx8WBA20Am4MEuFFWO/p3UC3rslT9nZ+ubB7wXhU3GvPqvhVEREuOO
	 PATGMznbY+ZAv5rSxsbEonAOQHayuV6V4XTIw5aKpr/tp0p+SkQMhW1/aI8WCk7iIs
	 gXNIkGBUhG7McJKhs0OStdoCiOAP/u830Qwx1k4hmEkkal3X1WjH6rAw14dKveyx8t
	 VZkw3LykGmoQQ==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67C0cNMo93140474
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 12 Aug 2026 08:38:23 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 12 Aug 2026 08:38:23 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 12 Aug 2026 08:38:23 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Wed, 12 Aug 2026 08:38:23 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Luka Gejak <luka.gejak@linux.dev>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Bitterblue Smith
	<rtl8821cerfe2@gmail.com>, Peter Robinson <pbrobinson@gmail.com>, "Hans de
 Goede" <johannes.goede@oss.qualcomm.com>
Subject: RE: [PATCH v3 0/5] wifi: rtw88: preparations for RTL8723B/RTL8723BS
Thread-Topic: [PATCH v3 0/5] wifi: rtw88: preparations for RTL8723B/RTL8723BS
Thread-Index: AQHdI945XDSU7+vG1ESxd/4CTf5KwraYGlYAgAGBNWA=
Date: Wed, 12 Aug 2026 00:38:23 +0000
Message-ID: <9f96f4a479f64ef384c76c3b1f71b2a4@realtek.com>
References: <20260804065425.17364-1-luka.gejak@linux.dev>
 <A850D677-5DD9-4626-9DAB-1C62F20E292F@linux.dev>
In-Reply-To: <A850D677-5DD9-4626-9DAB-1C62F20E292F@linux.dev>
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

DQpMdWthIEdlamFrIDxsdWthLmdlamFrQGxpbnV4LmRldj4gd3JvZXQ6DQo+IE9uIEF1Z3VzdCA0
LCAyMDI2IDg6NTQ6MjAgQU0gR01UKzAyOjAwLCBsdWthLmdlamFrQGxpbnV4LmRldiB3cm90ZToN
Cj4gPkZyb206IEx1a2EgR2VqYWsgPGx1a2EuZ2VqYWtAbGludXguZGV2Pg0KPiA+DQo+ID5UaGlz
IGlzIHRoZSBmaXJzdCBvZiB0d28gc2VyaWVzIGFkZGluZyBzdXBwb3J0IGZvciB0aGUgUmVhbHRl
ayBSVEw4NzIzQg0KPiA+ODAyLjExbiBjaGlwc2V0IGFuZCBpdHMgUlRMODcyM0JTIFNESU8gdmFy
aWFudCB0byBydHc4OC4gSXQgY29udGFpbnMNCj4gPm9ubHkgdGhlIGNoYW5nZXMgdG8gdGhlIHNo
YXJlZCBydHc4OCBjb3JlIHRoYXQgdGhlIGNoaXAgZHJpdmVyIGRlcGVuZHMNCj4gPm9uLiBUaGUg
Y2hpcCBpdHNlbGYsIHRoZSBidWlsZCBnbHVlIGFuZCB0aGUgTUFJTlRBSU5FUlMgZW50cnkgYXJl
IGENCj4gPnNlY29uZCBzZXJpZXMuDQo+ID4NCj4gPnYxIGhhZCAxOSBwYXRjaGVzLCB2MiBoYWQg
MTEsIHRoaXMgaGFzIDUuDQo+ID4NCj4gDQo+IC4uLg0KPiANCj4gSGkgUGluZy1LZSwNCj4gDQo+
IEkgaGF2ZSBzZW50IGEgdjQgdGhhdCBzdXBlcnNlZGVzIHRoaXMgc2VyaWVzLCBiZWZvcmUgeW91
IHJldmlldyB2Mywgc28NCj4geW91IGRvIG5vdCBzcGVuZCB0aW1lIG9uIHRoaXMgb25lLiBBcyB5
b3Ugc3VnZ2VzdGVkLCBJIGFtIG5vdGluZyBpdCBoZXJlDQo+IG9uIHRoZSB2MyBjb3Zlci4NCg0K
VGhhbmtzIGZvciB0aGUgbm90aWZpY2F0aW9uLCBhbmQgc29ycnkgZm9yIHRoZSBsYXRlLiBJIGhv
cGUgSSBjYW4gcmV2aWV3DQp2NCB0aGlzIEZyaWRheSBpZiBubyB1cmdlbnQgdGFza3MgaW50ZXJy
dXB0IG1lLg0KDQo+IA0KPiB2NCByZS1hZGRzIHR3byBwYXRjaGVzIHRoYXQgd2VyZSBkcm9wcGVk
IGluIHYyLCBib3RoIG9uIHRoZSBUWCByZXBvcnQgYW5kDQo+IGxlYXZlLUxQUyBwYXRocy4gVGVz
dGluZyBvbiBzbG93ZXIgQVJNIFNESU8gaG9zdHMsIFBldGVyIFJvYmluc29uIG9uIHRoZQ0KPiBS
RkMgYW5kIGFub3RoZXIgdGVzdGVyIG9uIGEgUm9ja2NoaXAgUkszMjg4IGJvYXJkLCByZXByb2R1
Y2VkICJmYWlsZWQgdG8NCj4gZ2V0IHR4IHJlcG9ydCBmcm9tIGZpcm13YXJlIg0KDQpUaGlzIG1h
a2VzIHNlbnNlIGZvciBzbG93ZXIgcGxhdGZvcm0uDQoNCj4gYW5kICJmaXJtd2FyZSBmYWlsZWQg
dG8gbGVhdmUgbHBzIHN0YXRlIiwNCg0KRG9lcyB0aGlzIG9ubHkgb2NjdXIgb24gInNsb3ciIHBs
YXRmb3JtPyBVbmxlc3MgYSBDMkggZXZlbnQgd2FzIGhhbmRsZWQNCnNsb3dseT8gSSdsbCByZXZp
ZXcgdGhlIHBhdGNoIGFuZCBhZGQgY29tbWVudCB0aGVyZS4NCg0KUGluZy1LZQ0KDQo=
