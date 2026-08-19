Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D54A93D1707;
	Wed, 19 Aug 2026 06:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787122200; cv=none; b=Pcy+8WxEKaYTbck8vGa/3mRccHrBwlXXgKefk4T14ggDGpx0alpsG35Q1yV23FEweoZnyqG2vdfD+WKCrosOUZm5dazbokKSnzzAGe6ibQZx90aS1lymcy4S5Ls+yn9qkFqMXNwqX/23F85ZzzFlEqsdGuqfgG/qSPLbWh5kg/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787122200; c=relaxed/simple;
	bh=VoznOeMowKN4UD93DwDQ2MPUFlonQ9gtDU6kuixlM3k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TKwYzyHMxbZdqfllc6s83M4zzNLCYo6SFgjWa13PWOqX9Gcs4REfLcm6tFAS5f2ALjbJ17i/zUfIj6b5EqUa6Q/+oFMJh38IjM/LMZfJZ1zJlfLnQ94R9tQoDYJZkYW9jcayGe8M9VykkfNfpp1k32Bh9WpLcPlADkHuN5ezbkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=mSpd4ZyH; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="mSpd4ZyH"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67J6nrwfF2174240, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1787122194; bh=VoznOeMowKN4UD93DwDQ2MPUFlonQ9gtDU6kuixlM3k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=mSpd4ZyHRuVE46S6FT8nPl3341E4AtIcH4Rxvm8wrBGsbO/W8f1GAcqmc6B7O2n+e
	 sJhiLwBVHcN3IK46wV/L466h0buVSZW6SHpaLMqEoL6UaGoHj5RrpXENPzTj8oAlw8
	 lkJUe9/i130QCvKXIB/6nFOC5rPOrzg/AlpZNBy4zbpSgEBYZaRhUHWqOhUhU6qakb
	 XNb/eMM66nC1OZrtnf4rNXdYATzlgRxUS7XsIu4L2b6UdeeBPMo4KWJmRSyG9IIBS5
	 bKV6rwmoIpPdqZ8nSChwJRV2yNIjTfStp1sRAgwAkhUatuahl2t4uFv5fZwV7DcH44
	 mG5+HCQlWT8cA==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67J6nrwfF2174240
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 19 Aug 2026 14:49:54 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 19 Aug 2026 14:49:53 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 19 Aug 2026 14:49:53 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Wed, 19 Aug 2026 14:49:53 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: =?utf-8?B?UmFmYWVsIEFsZWphbmRybyBEw61heiBDcnV6?= <rafad900@gmail.com>
CC: "Jes.Sorensen@gmail.com" <Jes.Sorensen@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH rtw-next v5] wifi: rtl8xxxu: Use local 'dev' variable for
 dev_warn()
Thread-Topic: [PATCH rtw-next v5] wifi: rtl8xxxu: Use local 'dev' variable for
 dev_warn()
Thread-Index: AQHdL0mfYevXINN71kKpfmR/NZF2pbakgbQg///hAgCAAIpvwA==
Date: Wed, 19 Aug 2026 06:49:53 +0000
Message-ID: <704a15b7526d479f8b5a644acb8ff534@realtek.com>
References: <20260818193402.2109269-1-rafad900@gmail.com>
 <51b1f52648c948a5b960d3e3196fa845@realtek.com>
 <CALp66yG9PdUmrs1QS-shG3=gchxD2QOYX065tNVq4zrTCZLdwA@mail.gmail.com>
In-Reply-To: <CALp66yG9PdUmrs1QS-shG3=gchxD2QOYX065tNVq4zrTCZLdwA@mail.gmail.com>
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

UGxlYXNlIHBsYWluIHRleHQgb25seS4NCg0KUmFmYWVsIEFsZWphbmRybyBEw61heiBDcnV6IDxy
YWZhZDkwMEBnbWFpbC5jb20+IHdyb3RlOg0KPiBUaGVyZSBhcmUgbXVsdGlwbGUgcGxhY2VzIHdo
ZXJlIHRoZSBkZXYgdmFyaWFibGUgd291bGQgb25seSBiZSB1c2VkIG9uY2UuDQo+IEkgd2FzIGhv
cGluZyB0byBvbmx5IGFkanVzdCB0aGUgZnVuY3Rpb24gY2FsbHMgdGhhdCBoYWQgJnByaXYtPnVk
ZXYtPmRldg0KPiBtb3JlIHRoYW4gb25jZSB0byBhdm9pZCByZWR1bmRhbmN5Lg0KDQpJIGRpZG4n
dCBnZXQgdGhpcyBwb2ludC4gQXMgSSBjb21lIGJhY2sgdG8geW91ciBmaXJzdCB2ZXJzaW9uIFsx
XSwgeW91DQpkaWRuJ3QgbWVudGlvbiBhbmQgZG8gdGhpcy4NCg0KWzFdIGh0dHBzOi8vcGF0Y2h3
b3JrLmtlcm5lbC5vcmcvcHJvamVjdC9saW51eC13aXJlbGVzcy9wYXRjaC8yMDI2MDgxNjE4MDg1
Ny40MTIyMDkwLTEtcmFmYWQ5MDBAZ21haWwuY29tLw0KDQo+IEJ1dCBJJ20gYSBsaXR0bGUgY29u
ZnVzZWQgYmVjYXVzZSB5b3UgbWVudGlvbmVkIGluIGEgcHJldmlvdXMgcGF0Y2g6DQo+ICLCoElm
IGl0IGlzIHdvcnRoIHRvIGRvLCBwbGVhc2UgY29udmVydCBhbGwgb2YgdGhlbS4gIiBJIHdhcyBo
b3BpbmcgdG8NCj4gY2hhbmdlIGFsbCB0aGUgZGV2X3dhcm4oKSwgZGV2X2VycigpLCBkZXZfaW5m
bygpLCBkZXZfZGJnKCkgc2luY2UgdGhleQ0KPiBhbGwgdXNlIHRoZSBzYW1lwqAmcHJpdi0+dWRl
di0+ZGV2wqBidXQgSSB3YXMgZ29pbmfCoHRvIHN1Ym1pdCBkaWZmZXJlbnQNCj4gcGF0Y2hlcyBm
b3IgZWFjaCBvbmUuIFBlcmhhcHMgSSBzaG91bGQgdGFrZSBhbm90aGVyIGFwcHJvYWNoLg0KPiBJ
IGd1ZXNzIHRoaXMgY2hhbmdlIG1pZ2h0IG5vdCBhY3R1YWxseSBiZSB3b3J0aCB0aGUgdHJvdWJs
ZS7CoA0KDQpJIGRpZG4ndCBhY3R1YWxseSBrbm93IHlvdXIgZ29hbCwgc28gbm8gaWRlYSBpZiB0
aGlzIGlzIHdvcnRoIHRvIHN0aXINCnRoZSBjb2RlLg0KDQo+IFRoYW5rcyBmb3IgeW91ciBwYXRp
ZW5jZSBhbmQgaGVscCB3aXRoIHRoaXMgcGF0Y2guIEknbGwgcHV0IHRoaXMgb2ZmDQo+IHVudGls
IEkgZmluZCBzb21ldGhpbmfCoGVsc2UgdG8gY29udHJpYnV0ZSB3aXRoIGl0LsKgDQoNCkkgZHJv
cHBlZCB0aGlzIGZyb20gcGF0Y2h3b3JrIHRoZW4uDQoNCg0K
