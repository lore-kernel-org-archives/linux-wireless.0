Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793236975;
	b=dSWwFRkwKLEDF/usYaYdNsP5bAy54Fk8yPJvhk6jqpte8h+7vfjYAGA964nx4I0G6Dl1
	 mOriyfY3p1pxra5lbMQTctqyMfuQnuJ6p8Ph2Pa1dECdF+sdEKE3NOwhE6xx+qUArKf+8
	 zBomJWcF63Tw4PSsWLnxp7DaBAhLOAe3KPSUx+EsEHdPsox4Zb0D8toi747KR96uVSmTS
	 gBfLc4RxDZuLJkPT1l693sEa6RRl7uv32O8a7qq66mqZvEYLnuDEFDbD6NP+k3cGBqEDJ
	 bbwkyGHgeryFHExlLZ5IJk1z7TGa+J5zgx4HmDBqNWk67RdMW9v5sVZcp7nMbDOA4eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793236975;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:From:To:CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:
	 References:In-Reply-To:Accept-Language:Content-Language:
	 x-originating-ip:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=hiNiSWDKVgEXNKW9leadRJp3AnUn3mjtErz/XHDUGVQ=;
	b=esedVxlIlOFdvmiEKLR/Auu6sGpLVNATc5Ty0WcnRtlzjnhSBsPG4A3l60qX8dXuQcpT
	 lym5dAPAKPiiBaUccRLOCzgdjC67yVUzwTIgZHoc5iKiouuK1LIVLXt1O628LvZ6BydhO
	 u+Opj+my6RD/nEaiXWKeSr2Bh5RlEprJvsI8SFXYhJRVxHO7Umr+zCMKw7KlHcra0eU4D
	 wTOyftdGaqhC/efQOXN6DvuQwBqXKe+kY1VeRV2xzXIm5ao+MSnG/bTE0kMNOj6Da/QQ1
	 FtrU2ymrbFcRvYV8cUGCj2kCK5/KjdBF/9mf3iaWrqTZRJNcjSYFFLAN3Gv2y8dJ9+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=ARBoLenk;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C63606A31A;
	Thu, 29 Oct 2026 01:22:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 32C63606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=ARBoLenk
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69T1McQgA2399462, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1793236959; bh=hiNiSWDKVgEXNKW9leadRJp3AnUn3mjtErz/XHDUGVQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=ARBoLenkL4C09lTN2oFMnKPSyrxWioWu7x+Oa1huShx9DUptn/RTJ/8lWLUUhEbaZ
	 Pxuu1Ol7z8gKMvdS5yXthrXoS4L95MKdBDEs8fGaM68YmulD8NeC1cpOjaT3tqo7oY
	 HomuRukXKPr0h5fCyhrF/P1CI56P5a4UuRuve6+NQn9hABGqQODkXLYqSKxWnGlu5t
	 IK312+kMxnhO7X+zccDP6Mg92+ztcEF4HvfiUuav+bfwNm3z4+l0uRXCYMnuvj3sPP
	 9VTm3vps7n0UbXGdvm7H2uIgaemuaWNdAbVHggeM5RJ8+BiIh/EA7q96D8TaqLD3ta
	 P+5tWWKVqIllQ==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69T1McQgA2399462
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 29 Oct 2026 09:22:38 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 29 Oct 2026 09:22:37 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([fe80::eeeb:c765:ca73:5eef]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::eeeb:c765:ca73:5eef%10]) with mapi id
 15.02.2562.056; Thu, 29 Oct 2026 09:22:37 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Imtiyaz Parvez <reza1234khan1234@gmail.com>, Hungyu Lin
	<dennylin0707@gmail.com>
CC: Luka Gejak <luka.gejak@linux.dev>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] wifi: rtw88: allow key removal when the CAM table is full
Thread-Topic: [PATCH] wifi: rtw88: allow key removal when the CAM table is
 full
Thread-Index: AQHdX+uKpKj5AeqD60mYtFtK4iFuvbcFrrNw//+mgICAAJDAYP//rimAgACSRQCAAD/UgIALkuMAgAD+KYCAAM/+wA==
Date: Thu, 29 Oct 2026 01:22:37 +0000
Message-ID: <4f88bc4989c444cd885a4784a49a7f95@realtek.com>
References: <20261019165103.5990-1-dennylin0707@gmail.com>
 <9bde49a2e7794e4fb6bc3ae104eef87e@realtek.com>
 <334c6e785a5d242c6f168d57d042d63b777a242a@linux.dev>
 <4f48c50cab1145fd9dbd6df6d424c877@realtek.com>
 <CAGEkeHevidTtTNj-qfy6kE_O0wRvqT=F=sG+Hy83BOkRjCUqeA@mail.gmail.com>
 <CANQ=N_C3+gpQ3O=SXYpRCGTh_MC1y4TEfnxF90SWgUVF_wYPUA@mail.gmail.com>
 <CAGEkeHdT1-WwJnF1wTkrrRQRzrEYESOoDeAYE+fiV0gROG+6sw@mail.gmail.com>
 <CAGEkeHf0CLjxhGySt2axf8gXMrCcn=cEHbe1aXRW4FgcbxjyZQ@mail.gmail.com>
 <DMGRRA9L08L3.1IM2GZHXGLZQ1@gmail.com>
In-Reply-To: <DMGRRA9L08L3.1IM2GZHXGLZQ1@gmail.com>
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

SW10aXlheiBQYXJ2ZXogPHJlemExMjM0a2hhbjEyMzRAZ21haWwuY29tPiB3cm90ZToNCj4gSGkg
SHVuZ3l1LA0KPiANCj4gPiBIYXZlIHlvdSBoYWQgYSBjaGFuY2UgdG8gdGVzdCB0aGlzIHBhdGNo
Pw0KPiANCj4gWWVzLCBzb3JyeSBmb3IgdGhlIGRlbGF5LiBJIHRlc3RlZCBpdCBvbiBteSBsYXB0
b3AuDQo+IA0KPiBIYXJkd2FyZTogUlRMODgyMkNFIDgwMi4xMWFjIHwga2VybmVsIHZlcnNpb246
IDcuMi4xMS1hcmNoMS0xDQo+IA0KPiBJIGJ1aWx0IG9ubHkgdGhlIHJ0dzg4IG1vZHVsZXMgZnJv
bSB0aGUgdjcuMi4xMSBzb3VyY2UNCj4gdHJlZSB3aXRoIHRoaXMgcGF0Y2ggYXBwbGllZCwgYW5k
IGxvYWRlZCB0aGVtLg0KPiANCj4gSSB1c2VkIGl0IGZvciBhcm91bmQgMiBob3VycyB3aXRoIG5v
cm1hbCBicm93c2luZywgc3VzcGVuZC9yZXN1bWUgYW5kDQo+IHJlY29ubmVjdGluZy4gTm8gbmV3
IHdhcm5pbmdzIG9yIGVycm9ycyBpbiBkbWVzZy4NCg0KVG8gaGl0IHRoZSBwcm9ibGVtIHRoaXMg
cGF0Y2ggZml4ZXMsIHdlIG5lZWQgMjggcGFpcndpc2UgZW50cmllcyBhcyANCkx1a2EncyBtZW50
aW9uIFsxXS4gSSB0aGluayBpdCBpcyBub3QgZWFzeSB0byBwcmVwYXJlIHNvIG1hbnkgc3RhdGlv
bnMNCmRldmljZXMuIA0KDQpBbnl3YXkuIEFzIHlvdXIgcmVzdWx0LCBpdCBwcm92ZXMgdGhhdCB0
aGlzIHBhdGNoIGlzIG9rYXkgZm9yIG5vcm1hbCB1c2UuIA0KDQpbMV0gaHR0cHM6Ly9sb3JlLmtl
cm5lbC5vcmcvbGludXgtd2lyZWxlc3MvMzM0YzZlNzg1YTVkMjQyYzZmMTY4ZDU3ZDA0MmQ2M2I3
NzdhMjQyYUBsaW51eC5kZXYvDQoNCg0K
