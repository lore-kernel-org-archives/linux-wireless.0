Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0AD288D0
	for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 01:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785200839; cv=none; b=qqrvkf1lIN7rmokXBUCD6tFxuePU29/7AzIjzPBzz+G+e9rbztPF3oZyz1hddcNy3YHYJWkeD3DVVfRce23eafKV5+YndXxKzCvvMo7ZajKzidXjFTZqZsfyPk4xE1NHyLLnn1tR/+HBr1xzbEM30PaXOw6U88fpt6eWyZ4ic0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785200839; c=relaxed/simple;
	bh=0u2GrtWYTM5MNBYQP09fSTIYGeXdS7GAViHTyVdnrLM=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PPBjGem1AIM8IWdwnOYxTtmMd24aIR0MCacKUDlyudZTje2cFxo7mqTugaG/aJrXxKxNo5fmBydXrIRtETdo6sUgUs6wUNIY9nf9C4xNX/pTG4QvwemIBDveEmx8RziCsrIaOFSIq2oi7+8DM7+AVcknCBgQhuOodpT36bYpk9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=AeVuralk; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="AeVuralk"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66S177rmC3490139, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1785200827; bh=0u2GrtWYTM5MNBYQP09fSTIYGeXdS7GAViHTyVdnrLM=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=AeVuralktIsE4E3aWz1Z0WHhlDLcQIEnDL9gy+F4qfSOf8F7epdrvA+cCOvL0O31b
	 aLcJybS3WiRvhZUcra2cvbj6SSk/7d8TQP794j65wV51I9lorN4b5mOqhnVrKoPt+8
	 kwNF7l2Jsgyh7mFJr1+3m/Hq8haSxF41s8udHTn5TF/wErSIzUJTFUHZ8c6Y0QKOYd
	 3fG97xz1IsEbUXZSsFXYiBbcX4X3tabbtVY6mD9vglxWujhER0kHPNKsOkaNRY56jO
	 FQBhx38y96SDOIiQzOtbYy+htk3bhWEwKFc/kTJPpki0vxcxNZISeMHLRq0tE/czd0
	 IXPa5/Q9OOj/A==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66S177rmC3490139
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 28 Jul 2026 09:07:07 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 28 Jul 2026 09:07:08 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 28 Jul 2026 09:07:07 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::e6fd:5a3f:8946:92c4%10]) with mapi id
 15.02.2562.017; Tue, 28 Jul 2026 09:07:07 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Adrodoc <adrodoc55@googlemail.com>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>
Subject: RE: Error in rtw89 using Kernel 7.1.4
Thread-Topic: Error in rtw89 using Kernel 7.1.4
Thread-Index: AQHdHdZdU24pRS7N10KrgD20Ysr2qbaCFWPAgAAJV2A=
Date: Tue, 28 Jul 2026 01:07:07 +0000
Message-ID: <1f8a2a023b064bca87a8f1e6712bca3d@realtek.com>
References: <CAOQMLZVB3_wedJ89yNoCKTXOsuXWNq+T785bVQBSr3Yh-TPqeA@mail.gmail.com>
 <ea2f5ee46c064fb9b3a45e9d705e2f59@realtek.com>
In-Reply-To: <ea2f5ee46c064fb9b3a45e9d705e2f59@realtek.com>
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

DQpQaW5nLUtlIFNoaWggPHBrc2hpaEByZWFsdGVrLmNvbT4gd3JvdGU6DQo+IA0KPiBBZHJvZG9j
IDxhZHJvZG9jNTVAZ29vZ2xlbWFpbC5jb20+IHdyb3RlOg0KPiA+IEkgd2FzIGFza2VkIGJ5IGR1
YmhhdGVyIGluDQo+ID4gaHR0cHM6Ly9naXRodWIuY29tL21vcnJvd25yL3J0dzg5L2lzc3Vlcy8x
MTYgdG8gcmVwb3J0IHRoaXMgdG8NCj4gPiBsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmcu
IEhlIHNhaWQgeW91IHdvdWxkIGtub3cgd2hhdCB0byBkbyB3aXRoDQo+ID4gUl9BWF9ETUFDX0VS
Ul9JU1I9MHgwMDAwMDA0MA0KPiANCj4gSSB3aWxsIHJlcG9ydCB0aGUgcGVyc3BlY3RpdmUgdG8g
aW50ZXJuYWwgZXhwZXJ0cy4NCj4gDQo+ID4NCj4gPiBJIGdldCByYW5kb20gd2lmaSBkaXNjb25u
ZWN0cyBvbiA3LjEuNC0xLWNhY2h5b3MgdXNpbmcgcnR3ODksIHRoYXQNCj4gPiBoZWFsIGFmdGVy
IGEgbWludXRlIG9yIHNvLiBJZiBJIG1hbnVhbGx5IGRpc2Nvbm5lY3QgZnJvbSBhbmQgcmVjb25u
ZWN0DQo+ID4gdG8gdGhlIG5ldHdvcmsgaXQgaGVhbHMgaW1tZWRpYXRlbHkuDQo+IA0KPiBEaWQg
eW91IGVuY291bnRlciB0aGlzIHByb2JsZW0gaW4gb2xkZXIga2VybmVsIHZlcnNpb24/DQo+IElm
IG9sZGVyIGtlcm5lbCB3b3JrcyB3ZWxsLCBjb3VsZCB5b3Ugc2hhcmUgdGhlIHZlcnNpb24gYW5k
IGhlbHAgdG8NCj4gYmlzZWN0IHRoZSBjYXVzZT8NCg0KU2luY2UgdGhlIGZpcm13YXJlIHZlcnNp
b24gaXMgaGlkZGVuIChUaGUgaXB2NC1yZWRhY3RlZCBwYXJ0IGlzIGEgbnVtYmVyIG9yaWdpbmFs
bHkpLg0KUGxlYXNlIGNoZWNrIGtlcm5lbCBsb2cgYW5kIHNoYXJlIHRoZSB2ZXJzaW9uLg0KDQpb
ICAgIDguMjgyMTQ5XSBydHc4OV84ODUyYWUgMDAwMDowNTowMC4wOiBGaXJtd2FyZSB2ZXJzaW9u
IDxpcHY0LXJlZGFjdGVkPiAoNTJhY2M4MDcpLCBjbWQgdmVyc2lvbiAwLCB0eXBlIDENClsgICAg
OC4yODIxNTNdIHJ0dzg5Xzg4NTJhZSAwMDAwOjA1OjAwLjA6IEZpcm13YXJlIHZlcnNpb24gPGlw
djQtcmVkYWN0ZWQ+ICg1MmFjYzgwNyksIGNtZCB2ZXJzaW9uIDAsIHR5cGUgMw0KDQpQaW5nLUtl
DQoNCg0K
