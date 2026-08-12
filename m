Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79805366045
	for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 02:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786500464; cv=none; b=FNkglKMHyBhkSdq7CbDmq/0ZNOWo4hJtQr889jU/qn7mHg51ggAF+PGpM/B1hQL1JOsdpXPcA76JSuwV9nx3DuTdY8289lYfgAJb6bWogQRWqDzKc++yUf/7d2L1b8YpwD3V5uQMIjsilMDgMWgI+ilSMiD7Z/I1TrjWdUZVdtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786500464; c=relaxed/simple;
	bh=1nras26gPGhN7LZoq8+eTzGutQ6KQ7LkC5QK+GX7FdM=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ObWSqvfRD9WgRYyxfmBlpfoZ7oe+DboxQxKs16ipUiMVY0192ewYflTe2V+3hTAbmIF1zZncf5mLryUANeIg0WfzpAMDhM87YQza7EtaC9uEaT3dn4bjdxRCVhf9ApatkSFOy+EOqvD936bp5I0u2UF8NiDORr62cVI2f3ys0GI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=ASMpkQva; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="ASMpkQva"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67C27UgL43200843, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1786500450; bh=1nras26gPGhN7LZoq8+eTzGutQ6KQ7LkC5QK+GX7FdM=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=ASMpkQvayi7zLnBqgR92zGf9u0okHA7BBte0WymvxO9CfLzka/82O8Kv5Gl24kMgs
	 X02keFIcPWSw7u8W1EPnpN4MOGOuXUkkhvt1YaXPOIzCcu9Nrn8gNjzUK8mw2VI9xj
	 Z9O2xAI+J7M7S1yNw4g/13gksM6DF3EGilaSl6BNAUTyucBI0+8bvQVUBfSXD4z8SS
	 aKYGjdGaBYOkFVRuFpb3oGGJyxYChzNuaPIRseOV0DPpFdmemayhmpggKYW7ZTreKQ
	 77udmkK263/B2HI/3rIDRoOQEioAT/YFeWWvn4r/JlJMMsH2rR8e6ylTIt/z3LTzh7
	 R5WbsbH/RcZ2g==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67C27UgL43200843
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 12 Aug 2026 10:07:30 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 12 Aug 2026 10:07:28 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Wed, 12 Aug 2026 10:07:28 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Gravias Panagiotis <graviaspanagiotis1@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [BUG] rtw89: RTL8852BE instant wake from suspend (Unknown wakeup
 reason 0)
Thread-Topic: [BUG] rtw89: RTL8852BE instant wake from suspend (Unknown wakeup
 reason 0)
Thread-Index: AQHdJymvgzGtGJXhz0SOKMAmmAvYHbaZrWbg
Date: Wed, 12 Aug 2026 02:07:28 +0000
Message-ID: <3be6c8f133bc43ffae0d73244fd2815d@realtek.com>
References: <59a87b27-a3e4-437c-b26b-de61d6d5f1ef@gmail.com>
In-Reply-To: <59a87b27-a3e4-437c-b26b-de61d6d5f1ef@gmail.com>
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

R3JhdmlhcyBQYW5hZ2lvdGlzIDxncmF2aWFzcGFuYWdpb3RpczFAZ21haWwuY29tPiB3cm90ZToN
Cj4gSGVsbG8sDQo+IA0KPiBJIGFtIGV4cGVyaWVuY2luZyBhbiBpc3N1ZSB3aGVyZSBteSBsYXB0
b3AgaW5zdGFudGx5IHdha2VzIGZyb20gc3VzcGVuZA0KPiAoczJpZGxlKSBkdWUgdG8gYSBzcHVy
aW91cyBpbnRlcnJ1cHQgZnJvbSB0aGUgUlRMODg1MkJFIHdpcmVsZXNzIGNhcmQuDQo+IFRoZSBz
eXN0ZW0gcmVmdXNlcyB0byBzdGF5IGFzbGVlcCB1bmxlc3MgSSB1c2UgYSB3b3JrYXJvdW5kLg0K
PiANCj4gSGFyZHdhcmU6IFJlYWx0ZWsgUlRMODg1MkJFIFdpcmVsZXNzIExBTiA4MDIuMTFheCBQ
Q0ktRXhwcmVzcyBBZGFwdGVyDQo+IERyaXZlcjogcnR3ODlfODg1MmJlDQo+IEtlcm5lbCB2ZXJz
aW9uOiBbSW5zZXJ0IHlvdXIgb3V0cHV0IGZyb20gYHVuYW1lIC1yYF0NCj4gRGlzdHJpYnV0aW9u
OiBBcmNoIExpbnV4DQo+IA0KPiBTdGVwcyB0byByZXByb2R1Y2U6DQo+IDEuIEhhdmUgUlRMODg1
MkJFIGNhcmQgYWN0aXZlIGFuZCBjb25uZWN0ZWQgdG8gV2ktRmkuDQo+IDIuIFRyaWdnZXIgc3lz
dGVtIHN1c3BlbmQgdmlhIGBzeXN0ZW1jdGwgc3VzcGVuZGAuDQo+IDMuIFRoZSBzeXN0ZW0gYmVn
aW5zIHRoZSBzbGVlcCBwcm9jZXNzIGJ1dCBpbW1lZGlhdGVseSBhYm9ydHMgYW5kIHdha2VzDQo+
IGJhY2sgdXAgdG8gdGhlIGxvY2sgc2NyZWVuLg0KPiANCj4gUmVsZXZhbnQgam91cm5hbGN0bCBs
b2dzOg0KPiBrZXJuZWw6IHJ0dzg5Xzg4NTJiZSAwMDAwOjAzOjAwLjA6IFVua25vd24gd2FrZXVw
IHJlYXNvbiAwDQo+IGJsdWV0b290aGRbNzg1XTogQ29udHJvbGxlciByZXN1bWUgd2l0aCB3YWtl
IGV2ZW50IDB4MA0KPiBrZXJuZWw6IFBNOiBzdXNwZW5kIGV4aXQNCj4gDQo+IEl0IGFwcGVhcnMg
dGhlIFdvV0xBTiBpbXBsZW1lbnRhdGlvbiBvbiB0aGlzIHNwZWNpZmljIGNoaXAgaXMgZmlyaW5n
IGENCj4gZ2VuZXJpYyAwIGludGVycnVwdCB1cG9uIGVudGVyaW5nIEQzL3MyaWRsZSBzdGF0ZS4N
Cj4gDQo+IEl0IGlzIGEgcGVyc29uYWwgcHJvYmxlbSBzbyBpIHdvdWxkIGxvdmUgdG8gY29udHJp
YnV0ZSBpbiBmaXhpbmcgdGhpcw0KPiBwcm9ibGVtLiBQbGVhc2UgbGV0IG1lIGtub3cgaWYgdGhl
cmUgYXJlIGFueSBkcml2ZXIgcGFyYW1ldGVycyBvcg0KPiBwYXRjaGVzIHlvdSB3b3VsZCBsaWtl
IG1lIHRvIHRlc3QgdG8gaGVscCBkZWJ1ZyB0aGlzLg0KDQpQbGVhc2Ugc2hhcmUgdGhlIGtlcm5l
bCBsb2cuIChub3RlOiBhZGQgJ25vX2NvbnNvbGVfc3VzcGVuZCcgdG8ga2VybmVsIGNtZGxpbmUp
DQoNCklmIHlvdSBkb24ndCBlbmFibGUgV29XTEFOLCB3aWxsIHRoZSBwbGF0Zm9ybSBpbnN0YW50
IHdha2UgZnJvbSBzdXNwZW5kPw0KSWYgcG9zc2libGUsIHVucGx1ZyB0aGUgV2lGaSBjYXJkIGZy
b20gbW90aGVyYm9hcmQgdG8gc2VlIGlmIGl0IGFsc28gdGhlDQpzYW1lIHN5bXB0b20/DQoNClBp
bmctS2UNCg0K
