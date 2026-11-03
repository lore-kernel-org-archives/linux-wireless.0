Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793668740;
	b=eJP1yDkAFtSbHqbxpAmbVTxHF1uCKv4zavGQnnVbdi+Sxj5ePyd5XwfRUPxiFLtYxgiS
	 2sFC+1Qcb5ku/HIKlKYScmMyr33cc65E+gI/iz+w9Oq/sf5Y3QhjE5IMAvpCuQrB5rdVK
	 7F89ObHejuvbp3ll+sq87qrh/E3OMcx8MipHWi8Pu+6OCeFMmXwtsMxZc58jI4EWlNn/d
	 0oer1FPE8hlz6LJjky2i0Ek6SHX8nKcxisBS6DiG1RoDQUjixiOYyjwVdQdyq5RDV3smm
	 mPtvYGGHdhZiyrYp+deluZ2DN53m8BzWl+VIQCefqrUcpZHSiFodpUAuoxmt5IpiUcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793668740;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:Received:From:To:CC:Subject:Thread-Topic:Thread-Index:Date:
	 Message-ID:References:In-Reply-To:Accept-Language:Content-Language:
	 x-originating-ip:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=GxHzo0Ztwnan7B9qRAwMxcJzF+tj0VofLd/JgOerVqA=;
	b=fUxOOkrIzwpiVHNBdfv2hcBn04IT23qSFUrN4LR1/T/v/WIEdUPB65cmxn+mPvEtiDlY
	 WSijLTFgFr/iIVL7H2cTowV4LnABHBLtMl9TUNh5vRgHy9twZJ87mTBADYbelmrONGtuZ
	 l/ukk+ciyI/PIGbo4em7iEPWw8ff9P8ymeljAMS89f0gtmJpUI74t9nkcFXOS3UKzCDva
	 nQcXNtApQnfdfanedLNu0KRivd/IN9zC9lT9DuAWEuloqu5uJj+pKwUhr80vrrI3o3uzT
	 a3fLUf9yk0AolOTMAf9xn8dNZm7xwtdP3zJpdWXsNhGV3g3zUFB0Z8TidxzaDQ7MCBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b="aER/82sD";
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A56606A326
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 01:18:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E6A56606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=aER/82sD
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6A31ItucE2617796, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1793668735; bh=GxHzo0Ztwnan7B9qRAwMxcJzF+tj0VofLd/JgOerVqA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=aER/82sDOrESx7DX022y0xExCDKqCq0TfLU/3nmJhFM49LljHFSc3ESp8n22iwrhz
	 bQceKbZa12deLR/PgLefKfC5T9tmSfO10Qxxyc59kNg0pmr14nZL2+WhokDXvot/d6
	 K2iuTyoY0CrlbTvlUfY6ZnfnQRZdPvzKSodi72nIIfQ1dipZOL7bDcyXlLMIx9us6d
	 etHUOOEDB1APu/DGo3g4qB9pndbZY1lH2LuDGryoAV2N6ErhQOUY1XY3Z05Q8cxk3O
	 oJa5u/dxDqe8JrfOVeYBNKPdBJLDrpX3D1NcsOkl/Gw2MF0nLDu75djsE/PYfpK/ER
	 TH45l5cgcBiMA==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6A31ItucE2617796
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 3 Nov 2026 09:18:55 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 09:18:55 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 09:18:55 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([fe80::eeeb:c765:ca73:5eef]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::eeeb:c765:ca73:5eef%10]) with mapi id
 15.02.2562.056; Tue, 3 Nov 2026 09:18:55 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Chris Vitalos <cvitalos@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: rtw89_8852bte (RTL8852BE-VT): recurring SER
 0x1000/0x4000/0x1001/0x1002 on fw 0.29.122.1/.2; question on
 rtw8852bt_fw-1.bin
Thread-Topic: rtw89_8852bte (RTL8852BE-VT): recurring SER
 0x1000/0x4000/0x1001/0x1002 on fw 0.29.122.1/.2; question on
 rtw8852bt_fw-1.bin
Thread-Index: AQHdaZogezorIXmrF0q/5jdQlxC1rrcZ84FwgAEK04CAAI/UsA==
Date: Tue, 3 Nov 2026 01:18:55 +0000
Message-ID: <b29d9df2098344bea71d8c006d60f25b@realtek.com>
References: <CADp4rm+GmTjCoFXvT8WpiLNohnREqfR9z78PfH1m2rxs00jMUQ@mail.gmail.com>
 <703ebc52e1d544e590874df041b4d979@realtek.com>
 <CADp4rmKfnQCyu5RiEkjLWpb9w2bXKBbQdr+40bjVjsWmzyqCNg@mail.gmail.com>
In-Reply-To: <CADp4rmKfnQCyu5RiEkjLWpb9w2bXKBbQdr+40bjVjsWmzyqCNg@mail.gmail.com>
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

Q2hyaXMgVml0YWxvcyA8Y3ZpdGFsb3NAZ21haWwuY29tPiB3cm90ZToNCj4gDQo+IEkgd2lsbCBh
cHBseSB0aGUgZGVidWcgcGF0Y2ggYW5kIGNvbGxlY3QgdGhyZWUgbG9ncyB3aXRoIGEgcmVib290
DQo+IGJldHdlZW4gZWFjaCwgdGhlbiB0ZXN0IHdpdGggcG93ZXIgc2F2ZSBvZmYgYW5kIHdpdGgg
YSBkaWZmZXJlbnQgQVAsDQo+IGFuZCByZXBvcnQgYmFjay4NCj4gDQo+IEkgaGF2ZSBiZWVuIGNv
bGxlY3RpbmcgcG9zdC1idXJzdCBjb25uZWN0aXZpdHkgc25hcHNob3RzIChyb3V0ZSwNCj4gbmVp
Z2hib3Igc3RhdGUsIHBpbmcsIEROUykNCj4gYW5kIGNhbiBwcm92aWRlIHRoZW0gaWYgeW91IHNl
ZSB2YWx1ZS4NCg0KVGhlIGRlYnVnIHBhdGNoIGNhbiBjb2xsZWN0IGxvZ3Mgb3VyIGV4cGVydHMg
bmVlZCB0byBkaWcgdGhlIGNhdXNlcyBvZg0KU0VSLCBzbyBwbGVhc2UgaGVscC4gSG93ZXZlciwg
dGhlIHVwcGVyIGxheWVyIGNvbm5lY3Rpdml0eSBzeW1wdG9tIG1pZ2h0DQpub3QgaGVscCwgc28g
SSdkIG5vdCByZXF1ZXN0IHRoaXMgcGFydC4NCg0KPiANCj4gPiA+DQo+ID4gPiBTeW1wdG9tcw0K
PiA+ID4gRXZlcnkgYnVyc3QgaGFzIHRoZSBzYW1lIG9yZGVyOiBTRVIgY2F0Y2hlcyBlcnJvciAw
eDEwMDAsICJmaXJtd2FyZQ0KPiA+ID4gZmFpbGVkIHRvIGFjayBmb3IgbGVhdmluZyBwcyBtb2Rl
IiwgMHg0MDAwLCAweDEwMDEsIDB4MTAwMiwgd2l0aCBtYW55DQo+ID4gPiAiW0VSUl1mdyBQQyA9
IDB4Yjg5OC4uLiIgYW5kICIweGI4OTIuLi4iIGxpbmVzIGluIGJldHdlZW4uIE9uIHRoZQ0KPiA+
ID4gNy4wLjAtNDIgYm9vdCwgZGlzYWJsZV9wc19tb2RlIGlzIE4gYW5kIGl3IHJlcG9ydHMgcG93
ZXIgc2F2ZSBvbg0KPiA+ID4gKGRlZmF1bHRzKS4NCj4gPg0KPiA+IFBsZWFzZSB0dXJuIG9mZiBw
b3dlciBzYXZlIGVudGlyZWx5IGJ5IE5ldHdvcmtNYW5hZ2VyIG9yIGl3IGNvbW1hbmQNCj4gPiAg
ICBpdyB3bGFuMCBzZXQgcG93ZXJfc2F2ZSBvZmYNCj4gPg0KPiA+ID4gSSBoYXZlIG5vdCB5ZXQg
dGVzdGVkIHRoZSBydHc4OV9wY2kNCj4gPiA+IGRpc2FibGVfY2xrcmVxL2Rpc2FibGVfYXNwbV9s
MS9kaXNhYmxlX2FzcG1fbDFzcyBvcHRpb25zIG9yDQo+ID4gPiBkaXNhYmxlX3BzX21vZGUgb24g
dGhpcyB1bml0OyBJIHVuZGVyc3RhbmQgdGhlIEp1bHkgcmVwb3J0ZXIgc2F3DQo+ID4gPiBjcmFz
aGVzIHdpdGggdGhlbSBzZXQuDQo+ID4NCj4gPiBJdCBpcyB3b3J0aCB0byBnaXZlIGl0IGEgdHJ5
Lg0KDQpBbHNvLCBwbGVhc2UgdHJ5ICdpdyBwb3dlcl9zYXZlIG9mZicgYW5kIGRpc2FibGUgdGhl
c2Ugb3B0aW9ucyB0byBkaXNhYmxlDQpwb3dlciBzYXZlLg0KDQoNCg==
