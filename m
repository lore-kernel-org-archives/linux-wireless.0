Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1787223ED5B
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 00:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785285364; cv=none; b=eT7aXUyGRa4Qvqs3pmLlebyHoB3v7vsrOYuT19EoVpZ6fwHC0qwBPbXKaj2L6E0dvrrN4TAFP33lwY9chW5UUYuyN9r27SR+pG9l7AQQVEL39tXonjZcjLhfofUGJQKAbvaUhl5kIRY5u6+G0ChDdZIISFZ9fOL5eBMzsXlY7oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785285364; c=relaxed/simple;
	bh=JBCaPd3YeUJ9F/p9NaETR/0E2fC7rN0oBV74i0XvBXQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=E0QuErRfBwmeeIt7S6ymI9jj4iSt19VwnyDC+1dwJKwycYuR0yKz1tL3ZjptSakkJMWn2/FKFb2OS+27J7lSGyA6t/lcGw3Mmnu21hUx1nwRxfhdZPrKAIjLNQ5VoU0Lufm9WegTkelSlD4kfPMnL9vtWrxyZmZCUeWoOkOiN6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=mT+SQw1C; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="mT+SQw1C"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66T0Zv5H2073882, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1785285357; bh=JBCaPd3YeUJ9F/p9NaETR/0E2fC7rN0oBV74i0XvBXQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=mT+SQw1CNe08CZA44w9fvgUitV99RTYniUNrzRUOoNbsDOQVEl0UW8h4XFCix3E+q
	 RRHCAxVEAudQLj+daWjdsVE7T404NUKrrSXq6p8NaRv9H7wFjuduEdCdGgHm+QCw9n
	 LY2smd9RG6f5xAoAXFBb/7IPUGKi9ZYTw+B7U0eg84TyEyJU4lLO024V9Ykh1dR6D8
	 VKwEXlj05Ii/SeARXYC+WL9TBvU34lfEDrHdjXppMzHcIukc8FmU+8xSsUcaqUzU9J
	 vXsLtw5EVBiilu7fRAAorZTxZRal0cfwVBlpKugwtFWivItYFL3nweUJ4qrzBvHFzY
	 taMOFfXhzcxGw==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66T0Zv5H2073882
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 29 Jul 2026 08:35:57 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 29 Jul 2026 08:35:57 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::e6fd:5a3f:8946:92c4%10]) with mapi id
 15.02.2562.017; Wed, 29 Jul 2026 08:35:57 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Adrodoc <adrodoc55@googlemail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: Error in rtw89 using Kernel 7.1.4
Thread-Topic: Error in rtw89 using Kernel 7.1.4
Thread-Index: AQHdHdZdU24pRS7N10KrgD20Ysr2qbaCFWPAgAAJV2CAAAS0AIAAjzyAgAD0dVA=
Date: Wed, 29 Jul 2026 00:35:57 +0000
Message-ID: <fe2f2e2a52ed4565b5c2927d872d82cc@realtek.com>
References: <CAOQMLZVB3_wedJ89yNoCKTXOsuXWNq+T785bVQBSr3Yh-TPqeA@mail.gmail.com>
 <ea2f5ee46c064fb9b3a45e9d705e2f59@realtek.com>
 <1f8a2a023b064bca87a8f1e6712bca3d@realtek.com>
 <CAOQMLZWhvwxTk9PNa0E=73pBOoah8X-2C+xN5-VY_gCSVtBkVg@mail.gmail.com>
 <CAOQMLZWpPDbm5yiBg89GjzXnCwuQn+t5V=AP617MoH6q8Zu2zw@mail.gmail.com>
In-Reply-To: <CAOQMLZWpPDbm5yiBg89GjzXnCwuQn+t5V=AP617MoH6q8Zu2zw@mail.gmail.com>
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

QWRyb2RvYyA8YWRyb2RvYzU1QGdvb2dsZW1haWwuY29tPiB3cm90ZToNCj4gSSB1c2VkIG15IFBD
IHJ1bm5pbmcga2VybmVsIDYuMTguMzgtMi1jYWNoeW9zLWx0cyBmb3IgYWxtb3N0IDkgaG91cnMN
Cj4gdG9kYXkgYW5kIGp1c3Qgd2hlbiBJIHRob3VnaHQgdGhlIGlzc3VlIHdvdWxkIG5vdCBvY2N1
ciBvbiB0aGlzDQo+IHZlcnNpb24gaXQgZGlkLg0KPiBEbyB5b3Ugd2FudCBtZSB0byBydW4gYW5v
dGhlciBrZXJuZWwgZm9yIGEgZGF5PyBJZiBzbywgd2hpY2ggb25lPw0KDQpUaGUgUlRMODg1MkFF
IGlzIHN1cHBvcnRlZCBzaW5jZSBrZXJuZWwgNS4xNi4gSXQgd2lsbCBoZWxwIGlmIHlvdSBjYW4g
aGVscCB0bw0KYmlzZWN0IHRoZSB2ZXJzaW9uLiANCg0KPiANCj4gRnVsbCBsb2cgYW5kIHN5c3Rl
bSBpbmZvOiBodHRwczovL3Bhc3RlLmNhY2h5b3Mub3JnL3AvZDQ4MWRlYy5sb2cNCj4gRmlybXdh
cmUgdmVyc2lvbiBpcyBzdGlsbCAwLjEzLjM2LjIgKDUyYWNjODA3KS4NCg0KSSBoYXZlIHBhc3Nl
ZCB0aGUgaW5mb3JtYXRpb24gdG8gaW50ZXJuYWwgZXhwZXJ0cyB0byBhbmFseXplLiANCg0KPiBb
MjQ3NDcuNjAwNjMzXSB3bGFuMDogZGlzYXNzb2NpYXRlZCBmcm9tIDxtYWMtYWRkcmVzcy1yZWRh
Y3RlZD4NCj4gKFJlYXNvbjogMj1QUkVWX0FVVEhfTk9UX1ZBTElEKQ0KDQpIb3cgc3VyZSB3aHkg
dGhlIGRpc2Fzc29jaWF0aW9uIGRvZXNuJ3QgcHJlc2VudCBpbiA3LjEuNCBsb2cuDQoNCj4gWzI0
NzQ4LjAzOTgzN10gcnR3ODlfODg1MmFlIDAwMDA6MDU6MDAuMDogdGltZWQgb3V0IHRvIGZsdXNo
IHF1ZXVlcw0KPiBbMjQ3NDguMjQ5OTI0XSBydHc4OV84ODUyYWUgMDAwMDowNTowMC4wOiB0aW1l
ZCBvdXQgdG8gZmx1c2ggcXVldWVzDQo+IFsyNDc1MS4zNzcxMzddIHdsYW4wOiBhdXRoZW50aWNh
dGUgd2l0aCA8bWFjLWFkZHJlc3MtcmVkYWN0ZWQ+IChsb2NhbA0KPiBhZGRyZXNzPTxtYWMtYWRk
cmVzcy1yZWRhY3RlZD4pDQo+IFsyNDc1MS4zNzcxNDFdIHdsYW4wOiBzZW5kIGF1dGggdG8gPG1h
Yy1hZGRyZXNzLXJlZGFjdGVkPiAodHJ5IDEvMykNCj4gWzI0NzUxLjM4OTU3Nl0gd2xhbjA6IGF1
dGhlbnRpY2F0ZWQNCj4gWzI0NzUxLjM5MDQ0NV0gd2xhbjA6IGFzc29jaWF0ZSB3aXRoIDxtYWMt
YWRkcmVzcy1yZWRhY3RlZD4gKHRyeSAxLzMpDQo+IFsyNDc1MS4zOTgzMTRdIHdsYW4wOiBSWCBB
c3NvY1Jlc3AgZnJvbSA8bWFjLWFkZHJlc3MtcmVkYWN0ZWQ+DQo+IChjYXBhYj0weDE0MzEgc3Rh
dHVzPTAgYWlkPTEpDQo+IFsyNDc1MS41MDk3ODJdIHdsYW4wOiBhc3NvY2lhdGVkDQoNClBpbmct
S2UNCg0KDQo=
