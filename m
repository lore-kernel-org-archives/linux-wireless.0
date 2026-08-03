Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5071C2AD3C;
	Mon,  3 Aug 2026 03:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785726831; cv=none; b=dgOmIuIUFDXPdG3I03fIOUURD6aOfJfonIUdz5NdYJ1UOpKtQ8903Wp+MF/96449ZLJuDu7PwhQxfPTLQzHoHwlW2JpXb5QjJnM2kG3yAVK+xKMUmP/EQRRajhLvl5dEkokGDYmIbEFEMTFe8VwlIlap3DMeX5mX6p7ZAHpAmU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785726831; c=relaxed/simple;
	bh=uKjS0CSzVAQRt7yxgKKqzKSM9eH/K3A4LTlBAe2XX4o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LjeQ2tp5b+VaRyN3pB/+XW6z25IxnK4+8A0tRfIvijMq0D43ImzgLCW/PLNdX8Mqd9oTN1R4xGcHydjE1mruDcv8OumDSoj15/8wmqJddsK9jGWxSdvtGRhi16XKuVkqRJmrt++40S3YOtEiYgXDCIstYMoLp68v2Uxj9zBrOa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=lbCMVeov; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="lbCMVeov"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6733DcSlA3864767, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1785726819; bh=uKjS0CSzVAQRt7yxgKKqzKSM9eH/K3A4LTlBAe2XX4o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=lbCMVeovyfo2Ul77N+zDwMrc4jJiSB9xcfTdaRJFoOm3OwYyBJp787MkvAgsqNKX0
	 mQ2PLhcshqdYk7L/UUwWGvpuqLJOifF6MxbVKbJTCoF6G7bRO0iPtZmYOlYqIX9nj4
	 foB2DhqAXTdG2mGpQpAeiuRVVqoynf4aCM7GbegLDlY4M8qWpYkGZ1dpRyItbEoldD
	 PvcBCPu8VO1bdPWr6+6zpRgtZJG55v7y1CkG5s3hbU25WreKApIk6FTKZeB4OGQlqY
	 8Mb8pvN9mvmBvpvH00Gi83D+KJ+Ihl/dNfN2kWylK/gZx5CTWytiYqtQObtohO7jzC
	 uWvlCqW+FTORQ==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6733DcSlA3864767
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 3 Aug 2026 11:13:39 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 3 Aug 2026 11:13:38 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 3 Aug 2026 11:13:38 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::e6fd:5a3f:8946:92c4%10]) with mapi id
 15.02.2562.017; Mon, 3 Aug 2026 11:13:38 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Luka Gejak <luka.gejak@linux.dev>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: RE: [PATCH v2 11/11] wifi: rtw88: run the RTL8723BS association
 register sequence
Thread-Topic: [PATCH v2 11/11] wifi: rtw88: run the RTL8723BS association
 register sequence
Thread-Index: AQHdHEb/KrivPqpz/0SOkFGQL9rTRbaBHE5wgAQTsgCAAKQ5IIABDDUAgATRHiA=
Date: Mon, 3 Aug 2026 03:13:38 +0000
Message-ID: <cc9f04704a01407b93c883cb6112d6d4@realtek.com>
References: <611b495996b74b278bfd769a9c045582@realtek.com>
 <20260730074504.19725-10-luka.gejak@linux.dev>
 <c697b23e723f4cab875e2c01fe6defc0@realtek.com>
 <BE0CAC76-A3CD-413A-9276-E2A1A2138F10@linux.dev>
In-Reply-To: <BE0CAC76-A3CD-413A-9276-E2A1A2138F10@linux.dev>
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

THVrYSBHZWphayA8bHVrYS5nZWpha0BsaW51eC5kZXY+IHdyb3RlOg0KDQoodGhhbmtzIGZvciB5
b3VyIGFib3ZlIGV4cGVyaW1lbnRzKQ0KDQo+IA0KPiBUaGF0IGxlYXZlcyBwcmVwIGF0IHNpeCBw
YXRjaGVzOg0KPiANCj4gICAxIGFkZCB0aGUgUlRMODcyM0IgY2hpcCB0eXBlIGFuZCBTRElPIGhl
bHBlcg0KPiAgIDIgcng6IG1hcmsgemVybyBsZW5ndGggcGFja2V0cyBvbiBSVEw4NzIzQlMNCj4g
ICAzIGZ3OiBmaXggdGhlIHJlc2VydmVkIHBhZ2UgdXBsb2FkIG9uIFJUTDg3MjNCUw0KPiAgIDQg
c2RpbzogdHJhY2sgZnJlZSBUWCBwYWdlcyBhbmQgT1FUIGNyZWRpdHMgZm9yIFJUTDg3MjNCUw0K
PiAgIDUgc2Rpbzogc2V0IHVwIFJYIGFnZ3JlZ2F0aW9uIGFuZCBpbnRlcnJ1cHRzIGZvciBSVEw4
NzIzQlMNCj4gICA2IHNkaW86IGFkZCBUWCBiYWNrLXByZXNzdXJlIGFuZCByZXRyeSBvbiBwYWdl
IHN0YXJ2YXRpb24NCg0KQW5zd2VyIHlvdXIgcXVlc3Rpb24gYmVsb3csIHNtYWxsZXIgcGF0Y2hz
ZXQgaXMgYWx3YXlzIGJldHRlciB0byBtZS4gOikNClVubGVzcyBpdCBpcyB0b28gc21hbGwgdG8g
dW5kZXJzdGFuZCB3aG9sZSBwaWN0dXJlLg0KDQo+IA0KPiBhbmQgbm8gY2hpcCB0ZXN0cyBsZWZ0
IGluIG1hYzgwMjExLmMgb3IgY29leC5jLiBXaGF0IHJlbWFpbnMgaXMgb25lIGluDQo+IHJ4LmMs
IG9uZSBpbiBmdy5jIGFuZCBlbGV2ZW4gaW4gc2Rpby5jLCBhbGwgb2Ygd2hpY2ggeW91IGhhdmUg
YWxyZWFkeQ0KPiBzYWlkIGFyZSBmaW5lIGlubGluZS4NCj4gDQo+IFdpdGggc3RlcCAzIGdvbmUg
eW91ciBvcmRlcmluZyBjb2xsYXBzZXMgdG8gcHJlcCwgdGhlbiB0aGUgY2hpcCBkcml2ZXIsDQo+
IHRoZW4gS2NvbmZpZy9NYWtlZmlsZSwgdGhlbiBNQUlOVEFJTkVSUy4gV291bGQgeW91IHJhdGhl
ciBoYXZlIHRoYXQgYXMNCj4gb25lIHNlcmllcyBvZiBuaW5lIHBhdGNoZXMsIG9yIGtlZXAgdGhl
IGN1cnJlbnQgc3BsaXQgd2l0aCBwcmVwIHNlbnQNCj4gZmlyc3Q/IEkgYW0gaGFwcHkgZWl0aGVy
IHdheTsgb25lIHNlcmllcyByZW1vdmVzIHRoZSAid2FpdCBmb3IgcHJlcCB0bw0KPiBsYW5kIiBj
b29yZGluYXRpb24uDQoNCk9uZSB0aGluZyBJIGZvcmdvdCB0byBzYXkgaXMgdGhhdCB0aGUgc3Rl
cCAyIChhZGQgUlRMODcyM0JTKSBjYW4gYmUgc3BsaXQNCmludG8gcGF0Y2hlcyBwZXIgZmlsZS4g
UmV2aWV3aW5nIGNhbiBiZSBlYXNpZXIuIA0KDQo+IA0KPiBPbmUgZGV0YWlsIGZvciB0aGUgb3Jk
ZXJpbmc6IGEgZmV3IHJlZ2lzdGVyIGRlZmluZXMgY3VycmVudGx5IHNpdCBpbg0KPiB0aGUgcGF0
Y2hlcyBiZWluZyBkcm9wcGVkIGJ1dCBhcmUgdXNlZCBieSBydHc4NzIzYi5jLCBzbyB0aGV5IG1v
dmUgaW50bw0KPiB0aGUgY2hpcCBzdXBwb3J0IHBhdGNoLiANCg0KWWVzLiBUaGF0IGlzIGdvb2Qg
dG8gbWUuDQoNClBpbmctS2UNCg0K
