Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57FD3DDB13;
	Tue, 25 Aug 2026 08:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787646195; cv=none; b=POnLKLYPgiwy1sjtEroQgsBXkj9rzb8CQUoBJVpfmrZmBTaydMQzAsyn/YFbIXMomtHSFjQ0UHqQkfPWmeF0TOQM7weT8a55CLodLUfopwRbL5UzIaqmM6FtGYgP+QmQtYH50n/3pswg8iwoCvnLwMqpPrvPQgjRyIL0IbcyJCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787646195; c=relaxed/simple;
	bh=5Q9WISjF9umUK7mgHMFNP0pZQhATgd3PvYpDryTRguo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RAcPNKSSS8XN4A6GSEF5VrGBkKeIp3lKIWw62uTEJpP+rVpxATsvj0VagC1hPweJNLIHv64ojq5nTNGvzklLWM6K+Idmtw7zf9bhKImwg4SfKsYRAeG0/laHkyllM/w32RXcqTvsf28heI+mOVJdmQd+G7RffvKlyUY04Id8rgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=Olwtrs6T; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="Olwtrs6T"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67P8MsokE3635413, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1787646175; bh=5Q9WISjF9umUK7mgHMFNP0pZQhATgd3PvYpDryTRguo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=Olwtrs6T10gJ2LCghIyX5+AmfJ2KqnD5WaJPbhlOFtCD8BlSIVw8CFOyqUCn1N5qK
	 /qdd7xzN9heU9Fr64w8oMZygvbwgZARtLbthDcggdbOMY3NJDSuLkpRpfOD402BQ5O
	 Dt77uRwSvTd0YTBv8hrWNUQrUZQVk8IZBnNRThHPyrXJDzjeYhQj+17IeO+2VTLXc2
	 I5ncHUS/MVCSpQCnXMPCjv+mVsyukHrSsNMuYwSnK4p+gcy2lnujWjWOInKR0rte/C
	 Y13dPhCwtgy1U1i4QLsU8gR84Y63mTGxew84u1W2yfEs4/xwM4fLvRmgOHlz/lhfYw
	 vjSJEHIjCIlBg==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67P8MsokE3635413
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 25 Aug 2026 16:22:54 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 25 Aug 2026 16:22:53 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Tue, 25 Aug 2026 16:22:53 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Luka Gejak <luka.gejak@linux.dev>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Bitterblue Smith
	<rtl8821cerfe2@gmail.com>, Peter Robinson <pbrobinson@gmail.com>, "Hans de
 Goede" <johannes.goede@oss.qualcomm.com>
Subject: RE: [PATCH v7 4/6] wifi: rtw88: sdio: track free TX pages and OQT
 credits for RTL8723BS
Thread-Topic: [PATCH v7 4/6] wifi: rtw88: sdio: track free TX pages and OQT
 credits for RTL8723BS
Thread-Index: AQHdMIL3twfMpykyCEyz233XfbbmBLauSXrw//+T44CAAIcCsP//fHmAgACKsPD//38FgAAQ/dzw
Date: Tue, 25 Aug 2026 08:22:53 +0000
Message-ID: <5c6d6a1826334966a4f0893ad306fba4@realtek.com>
References: <20260820090412.19574-1-luka.gejak@linux.dev>
 <20260820090412.19574-5-luka.gejak@linux.dev>
 <17c3c1f641fe41c4bfacb989af4b75a6@realtek.com>
 <AD323744-AE68-4C77-92A9-CD215B8A7E43@linux.dev>
 <f3f44d1bf5c248ef8ccdc092c2354ac0@realtek.com>
 <E2ACBF1F-1C98-4091-A851-E2D8AF006911@linux.dev>
 <68a844f5ea2b4eea827da95080a9dbcb@realtek.com>
 <E037DFDC-7C17-4537-810A-2D5DBFF4EECC@linux.dev>
In-Reply-To: <E037DFDC-7C17-4537-810A-2D5DBFF4EECC@linux.dev>
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

THVrYSBHZWphayA8bHVrYS5nZWpha0BsaW51eC5kZXY+IHdyb3RlOg0KPiBEbyB5b3UgbWluZCBh
bnN3ZXJpbmcgdGhpcyBxdWVzdGlvbiwgaXQgc2VlbXMgbGlrZSB5b3UgbWlzc2VkIGl0Og0KPiAN
Cj4gVGhlIHVuYWxpZ25lZCBTS0Igd2FybmluZyBub3cgc2l0cyBpbiBib3RoIGNhbGxlcnMgcmF0
aGVyIHRoYW4gb25jZSBpbnNpZGUNCj4gcnR3X3NkaW9fd3JpdGVfdG9fcG9ydCgpLCBiZWNhdXNl
IF9fZnVuY19fIHdvdWxkIG90aGVyd2lzZSByZXBvcnQNCj4gcnR3X3NkaW9fd3JpdGVfdG9fcG9y
dCBmb3IgZXZlcnkgb3RoZXIgU0RJTyBjaGlwIHdoZXJlIGl0IHJlcG9ydHMNCj4gcnR3X3NkaW9f
d3JpdGVfcG9ydCB0b2RheS4gS2VlcGluZyB0aGF0IG1lc3NhZ2UgaWRlbnRpY2FsIGNvc3RzIHRo
cmVlDQo+IGR1cGxpY2F0ZWQgbGluZXMuIFB1dHRpbmcgaXQgb25jZSBpbiBydHdfc2Rpb193cml0
ZV90b19wb3J0KCkgaXMgdGhlDQo+IHRpZGllciBjb2RlIGFuZCBhcmd1YWJseSB0aGUgbW9yZSBh
Y2N1cmF0ZSBtZXNzYWdlLCBhdCB0aGUgcHJpY2Ugb2YNCj4gY2hhbmdpbmcgYSBsb2cgbGluZSBv
biBjaGlwcyB0aGlzIHNlcmllcyBpcyBub3QgYWJvdXQuIEkgd2VudCB3aXRoIHRoZQ0KPiBkdXBs
aWNhdGUgdG8gbGVhdmUgdGhlIG90aGVyIHBhcnRzIGFsb25lLCBidXQgSSBoYXZlIG5vIHN0cm9u
ZyBmZWVsaW5nDQo+IGVpdGhlciB3YXksIHNvIHNheSB3aGljaCB5b3UgcHJlZmVyLg0KDQpEbyB5
b3UgbWVhbiB0aGlzPw0KDQoJaWYgKCFJU19BTElHTkVEKCh1bnNpZ25lZCBsb25nKXNrYi0+ZGF0
YSwgUlRXX1NESU9fREFUQV9QVFJfQUxJR04pKQ0KCQlydHdfd2FybihydHdkZXYsICJHb3QgdW5h
bGlnbmVkIFNLQiBpbiAlcygpIGZvciBxdWV1ZSAldVxuIiwNCgkJCSBfX2Z1bmNfXywgcXVldWUp
Ow0KDQpCdXQgSSBkb24ndCBmaW5kIHJ0d19zZGlvX3dyaXRlX3RvX3BvcnQoKT8NCg0KSXMgdGhp
cyBhIG5vcm1hbCBjYXNlPyBDYW4gY3VycmVudCBzZGlvLmMgaGFuZGxlIHRoaXMgcHJvcGVybHk/
DQpJZiBzbywgSSdkIGNoYW5nZSB0byBkZWJ1ZyBsZXZlbC4gDQoNCklmIHlvdXIgcXVlc3Rpb24g
aXMgd2hldGhlciBkdXBsaWNhdGUgb2YgdGhpcyBtZXNzYWdlLCBwbGVhc2UgcG9pbnQNCnRoZSBj
b2RlcyBmb3IgbWUuIChTb3JyeSwgSSBjYW4ndCBmaW5kIHRoZSBjb2RlIHlvdSBtZW50aW9uZWQg
YnkgdjcpLg0KDQpQaW5nLUtlDQoNCg0K
