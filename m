Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792643619;
	b=ewNyAxCunoVlri8qFsS1MYkM4FgeKXubMQqXNhmoOx0o9WJ7mzrzgQCM90Rm+MUBYek7
	 n+iHWa8WcXsCK6uCb6EjkOPeNm7SaHm2XNpWh0Wn8GXgwf43tcqPvVIqSj4ZjGzKQ1qmG
	 bfFlmbH0gvfbsjg9jwRWTBVBAv4lpGKwuGtiZuBU+8KBajGjsFdE7t0S044if+lMHbJlR
	 6Rva4sFzvw9yMwstSn/bEUB47ZuGiOFgQz3SxUgOtx0IhO3yGZYq0Bp3i5PgJdLZWMsjK
	 lIH1CI+wjuRXtjJ8wwFRZ6+h2dCQntwNuHCMvsYk5J1wbJCUdhTxakXpMJbbWEi4nUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792643619;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:From:To:CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:
	 References:In-Reply-To:Accept-Language:Content-Language:
	 x-originating-ip:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=pr1xAZsJ8fwF/UaheEujgpdzS8oZXHZNCfXWsLvgl/E=;
	b=wVpBgxV16G9DzRhMWDFr8O+hW2s8w+Atz+jkojRm2RujfVbXZX2307ufkypvScdTlSRy
	 DlSy1ftyO6I15Zx7OndtV5j7Yaz9fSSu8jOv1G4aTCHEDuWBxcrtd5LRRhBUMB1MvrlU1
	 +Qq03bbu4JQs3Seb0Z8cx2TRDepQUKyxp12ainqzdpeG9CYVulkvlw7QEPsWx0TzAH79r
	 QUxo1D7XzsQis5bY4go4SfvMrqho44c4bQRTiedA913HdvHXTo1xVd+zzlZQIkXEA2AiO
	 HMGv0kdhjCvRFeSbVqjU47SSNHAzzIxtUmeretMKMApWTaiubAGk//SgQJ34jV3/bPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=UojJbcVi;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA4B4606A319
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 04:33:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BA4B4606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=UojJbcVi
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69M4XUDo8590710, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1792643610; bh=pr1xAZsJ8fwF/UaheEujgpdzS8oZXHZNCfXWsLvgl/E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=UojJbcViPl1mrhymh4uIOBQEPXL6CzVgdBOMltmxLzvekl3Vaxz+TECQgBmTMI5d5
	 npY32cqxQeDcwUxv/2PtFHUybMIMDxN4gfIw2F/lQf2TUJji53Cl9lJXCo/Djx/Mlb
	 +ENWk2nP9FIVisjhShrrkTJy37Kiofp17xGupjkzOtpew/0Aqm4OXzUfDlgWOtm478
	 r8eP4KBAKE9kCboqmO5kU/6rOpayfEJWSC/8BkHOKrC/jhC8sa0V8INgQG0J865iOY
	 6yHCzdPs+a/tDJ9iCvu+FVUBtt4BEqNfJZK0cSp1c2TV4I1fuqJS3zkEOUTX+NBv39
	 cWB+MUOM2i+YQ==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69M4XUDo8590710
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 22 Oct 2026 12:33:30 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 22 Oct 2026 12:33:31 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Thu, 22 Oct 2026 12:33:31 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Luka Gejak <luka.gejak@linux.dev>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH rtw-next v2 2/2] wifi: rtw88: sdio: limit the high queue
 to DTIM delivery
Thread-Topic: [PATCH rtw-next v2 2/2] wifi: rtw88: sdio: limit the high queue
 to DTIM delivery
Thread-Index: AQHdYVnJG9JyRljXv0iDmLu7bg5MyrcI1STQ//+eOICAAIbOYA==
Date: Thu, 22 Oct 2026 04:33:30 +0000
Message-ID: <a9e585119cb84f079c5a0847b040d8e8@realtek.com>
References: <20261021124318.15993-1-luka.gejak@linux.dev>
 <20261021124318.15993-2-luka.gejak@linux.dev>
 <ea2137c603f146738f8db100e905060a@realtek.com>
 <ea8ee18b36d7416c11ae4f1b4046aed087f87f1c@linux.dev>
In-Reply-To: <ea8ee18b36d7416c11ae4f1b4046aed087f87f1c@linux.dev>
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

THVrYSBHZWphayA8bHVrYS5nZWpha0BsaW51eC5kZXY+IHdyb3RlOg0KPiBPY3RvYmVyIDIyLCAy
MDI2IGF0IDQ6MjQgQU0sICJQaW5nLUtlIFNoaWgiIDxwa3NoaWhAcmVhbHRlay5jb20+IHdyb3Rl
Og0KPiANCj4gDQo+ID4NCj4gPiBMdWthIEdlamFrIDxsdWthLmdlamFrQGxpbnV4LmRldj4gd3Jv
dGU6DQo+ID4NCj4gPiA+DQo+ID4gPiBJbiBBUCBtb2RlIGV2ZXJ5IGJyb2FkY2FzdCBhbmQgbXVs
dGljYXN0IChibWMpIGZyYW1lIGlzIHNlbnQgdGhyb3VnaCB0aGUNCj4gPiA+ICBoaWdoIHF1ZXVl
LCB3aGljaCB0aGUgaGFyZHdhcmUgb25seSBkcmFpbnMgYWZ0ZXIgYSBEVElNIGJlYWNvbi4gT25s
eSBhDQo+ID4gPiAgZmV3IGZyYW1lcyBsZWF2ZSBwZXIgRFRJTSwgc28gc3RlYWR5IG11bHRpY2Fz
dCB0cmFmZmljIGJ1aWxkcyBhIGJhY2tsb2cNCj4gPiA+ICB0aGF0IGhvbGRzIHRoZSBUWCBwYWdl
cyB0aGUgb3RoZXIgcXVldWVzIG5lZWQuIFVuaWNhc3QgdHJhZmZpYyB0aGVuDQo+ID4gPiAgc3Rh
bGxzIGZvciBzZWNvbmRzIGFuZCBjbGllbnRzIGNhbiBubyBsb25nZXIgcmVuZXcgdGhlaXIgREhD
UCBsZWFzZS4NCj4gPiA+DQo+ID4gPiAgVVNCIGhhZCB0aGUgc2FtZSBwcm9ibGVtIGFuZCB3YXMg
Zml4ZWQgYnkgY29tbWl0IGM3MTBjN2MyZTAzOCAoIndpZmk6DQo+ID4gPiAgcnR3ODg6IHVzYjog
cm91dGUgYm1jIGZyYW1lcyB2aWEgdGhlIGhpZ2ggcXVldWUgb25seSBmb3IgRFRJTSBkZWxpdmVy
eSIpDQo+ID4gPiAgYW5kIHRoZSB0d28gY29tbWl0cyB0aGF0IGZvbGxvd2VkIGl0LiBVc2UgdGhl
IHNhbWUgcnVsZSBmb3IgU0RJTy4gQSBibWMNCj4gPiA+ICBmcmFtZSBnb2VzIHRvIHRoZSBoaWdo
IHF1ZXVlIG9ubHkgd2hlbiBtYWM4MDIxMSBhc2tzIGZvciBEVElNIGRlbGl2ZXJ5DQo+ID4gPiAg
YmVjYXVzZSBhIHN0YXRpb24gaXMgZG96aW5nLCB0aGUgZnJhbWUgaXMgQVJQLCBFQVBPTCBvciBE
SENQLCBhbmQgdGhlDQo+ID4gPiAgYnVkZ2V0IGFsbG93cyBpdC4gQWxsIG90aGVyIGJtYyBmcmFt
ZXMgZ28gb3V0IG9uIHRoZWlyIGFjY2VzcyBjYXRlZ29yeQ0KPiA+ID4gIHF1ZXVlLg0KPiA+ID4N
Cj4gPiBJJ2QgcmVtb3ZlIHNlY29uZCBwYXJhZ3JhcGggc2luY2UgaXQganVzdCBkZXNjcmliZXMg
dGhlIHBhdGNoIDEvMiBkb2VzLg0KPiA+DQo+IA0KPiBXb3VsZCB5b3UgYmUgd2lsbGluZyB0byBk
cm9wIGl0IHlvdXIgd2hlbiBhcHBseWluZz8NCg0KU3VyZS4gSSdsbCBkbyBpdC4NCg0K
