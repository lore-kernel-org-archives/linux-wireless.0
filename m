Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B5B40D57C
	for <linux-wireless@vger.kernel.org>; Wed, 24 Jun 2026 05:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782278639; cv=none; b=Hmim6znLe2+/RK9lhK44naWDIyI2rSbUS6hqAJjEcreDE+pDzGlo05SEoTz9JuQp1FW95LqZarKhaOjHezsB1DbZvQLrifRgIfG/g1CUgP+ZGTjQpglcLKen+3uovIjHPS8cYNSaBg+3p1uOu0sZwqD5Gyx12gogbuQZMb1ndkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782278639; c=relaxed/simple;
	bh=+xe+xXPrpMlx9twtyQTnizQCXpdi+3oonETlXfJJU8I=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ji/9wuUvb3pp16TPHW30FhITmxGJR/QEjSFqGFk+riVluQJ6Z2radHJb99p32il3J1/JJsJdHhBS/b/co04sz61rjSrvynXdtDx9FhOMdID4ebBmCCTpZIWkqn0szyB9ho8+qVynMdQJ46cJSZlmPXTgZOI1+P5pBZNpRjMzSms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=tWr684pm; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="tWr684pm"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 65O5NpaA63924238, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1782278631; bh=+xe+xXPrpMlx9twtyQTnizQCXpdi+3oonETlXfJJU8I=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=tWr684pmj8hQTnl2B5Lp7JF/Ilvgv0dl86ZXkszUzbXShFloK3jMxbgmDcblMrAJ7
	 SnAEhH3/7JogPftYWPbgojVaXNrtUZY0vjvCQWpoYV+ZYo17FHP3sgRHkXe2edv3LE
	 TE0xISLJQxIYJ8hDryu6vsPB7qK7GSr2VVGTBFoHZaIbxLMyDcZSEomVzJ2P2bjGFC
	 LGTUtdzNmoBkcaR0se7GzLT5CQh8OItppmEN5/x8olL8aVnFUpGRtdibXh0hgp2Az5
	 mgrbH0Vi1SpdaBci4YyjRTSLbuIJqYsS69uj5WqD7VG3FU2uNUIVpqFecdMe7DNx1w
	 0ruqsMjr5FwKw==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 65O5NpaA63924238
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 24 Jun 2026 13:23:51 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 24 Jun 2026 13:23:52 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 24 Jun 2026 13:23:51 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::e6fd:5a3f:8946:92c4%10]) with mapi id
 15.02.2562.017; Wed, 24 Jun 2026 13:23:51 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Gmail <helder.bertoldo@gmail.com>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>
Subject: RE: [REGRESSION] rtw89: RTL8922AE Wi-Fi broken in Kernel 7.0 (and
 6.18+) due to mac80211 API changes
Thread-Topic: [REGRESSION] rtw89: RTL8922AE Wi-Fi broken in Kernel 7.0 (and
 6.18+) due to mac80211 API changes
Thread-Index: AQHdA4lroyskbLpM7kuOlrst4tUuCbZNIIiQ
Date: Wed, 24 Jun 2026 05:23:51 +0000
Message-ID: <e42e0d250c964ecb9740caff5b8a4ce9@realtek.com>
References: <c26fda96-aa91-4372-8d24-35d3fa44fc09@gmail.com>
In-Reply-To: <c26fda96-aa91-4372-8d24-35d3fa44fc09@gmail.com>
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

R21haWwgPGhlbGRlci5iZXJ0b2xkb0BnbWFpbC5jb20+IHdyb3RlOg0KPiBJIGFtIHJlcG9ydGlu
ZyBhIHJlZ3Jlc3Npb24gcmVnYXJkaW5nIHRoZSBSZWFsdGVrIFJUTDg5MjJBRSBXaS1GaQ0KPiBh
ZGFwdGVyIChydHc4OSkgb24gYSBHaWdhYnl0ZSBYODcwTSBBb3J1cyBFbGl0ZSBXaWZpNyBtb3Ro
ZXJib2FyZC4NCj4gDQo+IFRoZSBhZGFwdGVyIHdvcmtzIHBlcmZlY3RseSBvbiBLZXJuZWwgNi4x
Ny43LCBidXQgaXQgZmFpbHMgdG8gaW5pdGlhbGl6ZQ0KPiBvciBpcyBub3QgcmVjb2duaXplZCBp
biBuZXdlciBrZXJuZWxzLCBzcGVjaWZpY2FsbHkgNi4xOCwgNi4xOSwgYW5kIHRoZQ0KPiBjdXJy
ZW50IDcuMC54IHNlcmllcyB1c2VkIGluIHRoZSBCYXp6aXRlIChGZWRvcmEtYmFzZWQpIHRlc3Rp
bmcgYnJhbmNoLg0KDQpQbGVhc2Ugc2hhcmUga2VybmVsIGxvZyBvZiA2LjE3LjcgKHdvcmsgd2Vs
bCkgYW5kIDYuMTggKGZhaWxlZCB0byBpbml0aWFsaXplKS4NCg0KSSBjaGVja2VkIHRoZSBjaGFu
Z2Ugb2YgdGhlIHJ0dzg5IGRyaXZlciBmcm9tIDYuMTcgdG8gNi4xOCwgYnV0IEkgY2FuJ3QNCmZp
bmQgdGhlIG9idmlvdXMgY2hhbmdlIGZvciBSVEw4OTIyQUUgdGhvdWdoLg0KDQo+IA0KPiBUZWNo
bmljYWwgZGV0YWlsczoNCj4gVGhlIGlzc3VlIHNlZW1zIHJlbGF0ZWQgdG8gcmVjZW50IGFyY2hp
dGVjdHVyYWwgY2hhbmdlcyBpbiB0aGUgbWFjODAyMTENCj4gc3Vic3lzdGVtOg0KPiANCj4gMS4g
U2lnbmF0dXJlIGNoYW5nZXMgaW4gJ3N0cnVjdCBpZWVlODAyMTFfb3BzJzogU2V2ZXJhbCBjYWxs
YmFja3MNCj4gKGluY2x1ZGluZyAuY29uZmlnLCAuc3RvcCwgYW5kIC5zZXRfcnRzX3RocmVzaG9s
ZCkgbm93IHJlcXVpcmUgdGhlDQo+ICdyYWRpb19pZHgnIHBhcmFtZXRlciB0byBzdXBwb3J0IG11
bHRpLXJhZGlvIHdpcGh5L01MTy4gSXQgYXBwZWFycyB0aGUNCj4gcnR3ODkgZHJpdmVyIGluIHRo
ZXNlIGtlcm5lbCBidWlsZHMgbWlnaHQgbm90IGhhdmUgYmVlbiBmdWxseSB1cGRhdGVkIHRvDQo+
IG1hdGNoIHRoZXNlIG5ldyBzaWduYXR1cmVzLCBsZWFkaW5nIHRvIGluY29tcGF0aWJsZSBwb2lu
dGVyIHR5cGUgZXJyb3JzDQo+IG9yIGluaXRpYWxpemF0aW9uIGZhaWx1cmVzLg0KDQpBcmUgeW91
IHN1cmU/IFRoZSBjaGFuZ2VzIG9mIEFQSSB3aWxsIGJlIGNvbXBhdGlibGUgd2l0aCBleGlzdGlu
Zw0KZnVuY3Rpb25hbGl0aWVzLg0KDQo+IA0KPiAyLiBSZW1vdmFsIG9mIGluaXRfZHVtbXlfbmV0
ZGV2OiBUaGUgZHJpdmVyIGNvZGUgc2VlbXMgdG8gc3RpbGwNCj4gcmVmZXJlbmNlIGluaXRfZHVt
bXlfbmV0ZGV2LCB3aGljaCB3YXMgcmVwbGFjZWQgYnkgYWxsb2NfbmV0ZGV2X2R1bW15KCkNCj4g
aW4gdGhlIHdpcmVsZXNzLW5leHQvbmV0LW5leHQgdHJlZXMuDQoNCkl0IGhhcyBiZWVuIGFsbG9j
X25ldGRldl9kdW1teSgpIGFscmVhZHkuDQoNCklmIHlvdSBhcmUgdXNpbmcgb3V0LW9mLXRyZWUg
ZHJpdmVyLCBwbGVhc2UganVzdCB1c2UgaW4tdHJlZSBkcml2ZXIuIA0KDQo+IA0KPiBIYXJkd2Fy
ZSBJbmZvOg0KPiAtIENoaXBzZXQ6IFJlYWx0ZWsgUlRMODkyMkFFDQo+IC0gUENJIElEOiBbMTBl
Yzo4OTIyXSAoUGxlYXNlIHZlcmlmeSB0aGlzIElEIG9uIHlvdXIgc3lzdGVtIHVzaW5nICdsc3Bj
aQ0KPiAtbm4nKQ0KPiAtIFdvcmtpbmcgS2VybmVsOiA2LjE3LjcNCj4gLSBCcm9rZW4gS2VybmVs
czogNi4xOC54LCA2LjE5LngsIDcuMC54DQo+IA0KPiBJIGFtIHVzaW5nIHRoZSBPR0MgS2VybmVs
IGZyb20gdGhlIEJhenppdGUgcHJvamVjdCwgYnV0IHRoZSBpc3N1ZQ0KPiBhcHBlYXJzIHRvIHN0
ZW0gZnJvbSB0aGUgdXBzdHJlYW0gZHJpdmVyIHN5bmNocm9uaXphdGlvbiB3aXRoIHRoZSBuZXcN
Cj4gbWFjODAyMTEgQVBJLg0KDQpDYW4geW91IHVzZSA2LjE3LjcgYW5kIHRoZW4gYXBwbHkgcGF0
Y2hlcyBvZiB0aGUgcnR3ODkgZHJpdmVyIG9uZSBieSBvbmUNCmZyb20gNi4xOC54PyBUaGF0IGNh
biBmaW5kIHRoZSBjYXVzZS4gDQoNCj4gDQo+IEFyZSB0aGVyZSBhbnkgcGVuZGluZyBwYXRjaGVz
IGluIHRoZSBydHctbmV4dCB0cmVlIHRoYXQgYWRkcmVzcyB0aGVzZQ0KPiBzcGVjaWZpYyBpZWVl
ODAyMTFfb3BzIHNpZ25hdHVyZSBjaGFuZ2VzIGZvciB0aGUgODkyMkFFPw0KDQpUaGUgbnVtYmVy
IG9mIHJ0dzg5IHBhdGNoZXMgYmV0d2VlbiA2LjE3IGFuZCA2LjE4IGlzIGFib3V0IDQwLg0KVHJ5
aW5nIGFib3ZlIHN1Z2dlc3Rpb24gd2lsbCBiZSBlYXNpZXIgdG8gYWRkcmVzcyBwcm9ibGVtLiAN
Cg0KDQo=
