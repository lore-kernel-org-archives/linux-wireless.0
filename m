Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E1C31A6809
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 02:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791167427; cv=none; b=llxSR5Gj7khqy0pc9wND85sPXqRiHVU9m1SFLIpZzha8vmoj5POec1xXpgCn5DlAvX2yuvnWakV26EdvIymtRKl9cWv24AU3Q0KRSXbnZlQUhbDS+oAoZT+qieeUp/x4VDLV7k5G1equzywKFZwZ/nnoxImtmmXVfZPTSfN5lUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791167427; c=relaxed/simple;
	bh=D/2KgnYW/k4f/2sUgpjTAiegcRgDyhAtBhoag2fUQ2w=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dhGkFuIH6pjeLjyLLU+EqbN/J5s09w9Pi1Wym1dV3NoVS37/KPXDA+q/KvvQvMr1kgHMCUBiwLMGDdrCXHLUQ/5hq/3ZVd0krlg2jSruoNwO4sDx/qZcl5M7T5PmHmfc1//BgmQVMgxIh3+OGud5tR+dx9uoGJV40tdN869lkP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=oisAOYH0; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="oisAOYH0"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6952U8h341566859, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791167408; bh=D/2KgnYW/k4f/2sUgpjTAiegcRgDyhAtBhoag2fUQ2w=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=oisAOYH0CTMxKHRej0RLWV6h+NP73yPx7/QA0BAjzt3pJl19SKest9N2hSPwS4VRS
	 5MYINBE3FYXfQsoGaPciKoV3GTR81u4Pp2pNtQbftcwnCwE8KnTaDdHicCQBx/EHYj
	 wWBn7AhjFc2l4XsL9VTutsxfTD5F2TmLAqyF9OyfwtcWMaK8RhrnxgQcNQkUJmrUnU
	 n8QQTWWjrRbtuxtbn1PgKM1I1QcoCyY3L0VqGNZ2ehVHnhlDTxVTgP3dmYFCmFbNmv
	 OWsGeBGRa/l6Lw5pUCQzDIbiGtAB6itBw1bBrOBPD6EFlenZN/Pa1nnG+eNG5AzluD
	 C3R/03LA+/Okg==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6952U8h341566859
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 5 Oct 2026 10:30:08 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 5 Oct 2026 10:30:08 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Mon, 5 Oct 2026 10:30:08 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Bitterblue Smith <rtl8821cerfe2@gmail.com>, PierluigiFrullani
	<pierluigi.frullani@frumar.it>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>
Subject: RE: Problems with rtw89 on 5Ghz wlans.
Thread-Topic: Problems with rtw89 on 5Ghz wlans.
Thread-Index: AQHdUbIXZzaQd5SyqECo2+yEOIu5GLbpk9HQgABiM4CABEbZQA==
Date: Mon, 5 Oct 2026 02:30:08 +0000
Message-ID: <2f8b1f510df840e1a73a3321e77bbc1b@realtek.com>
References: <10543730.tdPhlSkOF2@topolinux>
 <fab16229-8e70-41a8-83f3-5d04c6035a43@gmail.com>
 <980970f8b4934572aafbd6f5f6020436@realtek.com>
 <dc900baa-a3c7-4962-a11e-9a949af92340@gmail.com>
In-Reply-To: <dc900baa-a3c7-4962-a11e-9a949af92340@gmail.com>
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

Qml0dGVyYmx1ZSBTbWl0aCA8cnRsODgyMWNlcmZlMkBnbWFpbC5jb20+IHdyb3RlOg0KPiA+Pj4g
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODkvcnR3ODg1MmIu
Yw0KPiA+PiBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODkvcnR3ODg1MmIuYw0K
PiA+Pj4gaW5kZXggMzU2NjIzMzQxZjY1Li5jOWVlM2M3NmNmYzkgMTAwNjQ0DQo+ID4+PiAtLS0g
YS9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg5L3J0dzg4NTJiLmMNCj4gPj4+ICsr
KyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODkvcnR3ODg1MmIuYw0KPiA+Pj4g
QEAgLTc3MSw2ICs3NzEsMTUgQEAgc3RhdGljIHZvaWQgcnR3ODg1MmJfYnRjX3NldF9yZmUoc3Ry
dWN0IHJ0dzg5X2RldiAqcnR3ZGV2KQ0KPiA+Pj4gICAgICB9IGVsc2Ugew0KPiA+Pj4gICAgICAg
ICAgbWQtPmFudC50eXBlID0gQlRDX0FOVF9TSEFSRUQ7DQo+ID4+PiAgICAgICAgICBtZC0+YnQw
X3BvcyA9IEJUQ19CVF9CVEc7DQo+ID4+PiArDQo+ID4+PiArICAgICAgICBpZiAobWQtPnJmZV90
eXBlID09IDQxKSB7DQo+ID4NCj4gPiBVc2UgdGhlIHNhbWUgcXVpcmsgYnkgdGhlIHdheS4NCj4g
Pg0KPiANCj4gVGhpcyB3YXMgdGhlIGluaXRpYWwgdmVyc2lvbiBvZiB0aGUgcGF0Y2guIFNpbmNl
IHRoZW4gSSBjaGFuZ2VkDQo+IGl0IHRvIGNoZWNrIGhhbC0+dHhfbnNzIGFuZCBoYWwtPnJ4X25z
cywgdG8gbWlycm9yIHdoYXQgdGhlDQo+IHZlbmRvciBkcml2ZXIgZG9lcy4gSXMgdGhhdCBva2F5
Pw0KDQpJIGNoZWNrZWQgdmVuZG9yIGRyaXZlci4gSXQgbG9va3MgbGlrZSB0aGlzOg0KDQogICAg
ICAgIGlmIChwaHlfaHdbMF0udHhfbnVtID09IDEgJiYgcGh5X2h3WzBdLnR4X3BhdGhfbnVtID09
IDIgJiYNCiAgICAgICAgICAgICAgICBwaHlfaHdbMF0ucnhfbnVtID09IDEgJiYgcGh5X2h3WzBd
LnJ4X3BhdGhfbnVtID09IDIpIHsNCg0KICAgICAgICAgICAgICAgIGlmIChyZmVfdHlwZSA9PSA0
MSkgew0KICAgICAgICAgICAgICAgICAgICAgICAgUkZfREJHKHJmLCBEQkdfUkZfSU5JVCwgIiVz
OiByZmVfdHlwZTogJWQgc2V0IHRvIDFUMVJcbiIsIF9fZnVuY19fLCByZmVfdHlwZSk7DQogICAg
ICAgICAgICAgICAgICAgICAgICBwaHlfaHdbMF0udHhfcGF0aF9udW0gPSAxOw0KICAgICAgICAg
ICAgICAgICAgICAgICAgcGh5X2h3WzBdLnJ4X3BhdGhfbnVtID0gMTsNCiAgICAgICAgICAgICAg
ICB9IGVsc2UgaWYgKHJmZV90eXBlID09IDQzKSB7DQogICAgICAgICAgICAgICAgICAgICAgICBS
Rl9EQkcocmYsIERCR19SRl9JTklULCAiJXM6IHJmZV90eXBlOiAlZCBzZXQgdG8gMVQyUlxuIiwg
X19mdW5jX18sIHJmZV90eXBlKTsNCiAgICAgICAgICAgICAgICAgICAgICAgIHBoeV9od1swXS50
eF9wYXRoX251bSA9IDI7DQogICAgICAgICAgICAgICAgICAgICAgICBwaHlfaHdbMF0ucnhfcGF0
aF9udW0gPSAyOw0KICAgICAgICAgICAgICAgIH0NCiAgICAgICAgfQ0KDQpJJ20gbm90IHN1cmUg
dGhlICJtaXJyb3IiIHlvdSBtZW5hdC4gDQpJIGZlZWwgaXQgaXMgb2theSB0byBjaGVjayB0eF9u
dW0vdHhfcGF0Y2hfbnVtIGJlZm9yZSBkb2luZyBvdmVycmlkZSB0aGUgdmFsdWVzDQphdCBmaXJz
dCBnbGFuY2UuIEJ1dCB0aGluayBhIGJpdCBtb3JlLCBpdCBsb29rcyBsaWtlIG5vIGNoZWNraW5n
IHdpbGwgYmUgYWxzbw0Kb2theSwgYmVjYXVzZSBJIGRvbid0IHRoaW5rIHJmZV90eXBlIDQxIGNh
biBiZSBhbm90aGVyIGNvbmZpZ3VyYXRpb24uDQoNCkJ5IHRoZSB3YXksIG15IHRoaW5raW5nIG9m
IHRoaXMgcGF0Y2ggaXMgDQoNCjEuIGFmdGVyIHJlYWRpbmcgZWZ1c2UuIElmIHJmZV90eXBlIDQx
IC0tPiBzZXQgYSBxdWlyaw0KMi4gYnkgcXVpcmssIHNldCBCVEMNCjMuIGJ5IHF1aXJrLCBzZXQg
dHhfbnNzL3R4X2FudA0KDQpXaXRoIHRoZSBxdWlyaywgaXQgd2lsbCBiZSBlYXNpZXIgdG8gdW5k
ZXJzdGFuZCAyIGFuZCAzIHJlbGF0ZWQgdGhpbmdzLiANCg0KDQo=
