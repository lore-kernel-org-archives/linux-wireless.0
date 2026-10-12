Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2036547056
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 00:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791766402; cv=none; b=kZbJpgXaV1Y73eekEvVgy7RrceABo+byeBucAIOe1Bn+3rlMAJMCa4XfKVbX3iE+iiZbdq//KhpcN5yn8DxpGKbsWZN/VUnxkL5lI7BMK35q8pqZ2JVWFXm6v4lO+AhXHM6lJF1RDE6bVBEC6oyTUCw9Vbd6LjZYbpMMNWwFVsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791766402; c=relaxed/simple;
	bh=0CAQy2dWWmYRxCaCgg245w84Y5anEJIjtt0SQY5S8BM=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ENsvLw8iM0kXbvC9uHGeDUVJkIIimLRKWSwldz/CPd8eP8HEYuq9N1zRu+EKKbTJepOzY5wk6v8DoF8Ja4cglMLxIgnYHVvY/YNXEZYONLU/5jom63B3OIWjonHtKpSr/z7GFOfFP6nyeYeK03hw96k4po1fq1LWmL0pI/YVvW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=QMOUtozQ; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="QMOUtozQ"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69C0rGmE53402120, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791766396; bh=0CAQy2dWWmYRxCaCgg245w84Y5anEJIjtt0SQY5S8BM=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=QMOUtozQ6uHQTnwwqXtGeT9o78cwV3DnKRsQhY0NCQ8WZJvpNXmXMwfXCegSYXfOO
	 fT5xIdZc/f75Nas9Z2xAwv+8J0haNnJEHi0L9szuuPHYWXq3PnNRBzf+BZcTVXBpUg
	 QfpvAvBxHnikipYl4n3LikbpggyPW2n7vjuoe22mvrA6TuktNu7AirBYVJhFfI6dNS
	 V9IAKJLzyY5FWAbnQI3LkdB+cc/76IrblQpKz8tRBgKXbZzwJUc5VehelLlO32wpwv
	 QC5l7VjWAOkQukA8vAanRXs77GwN+JsXpsGNr/aj7nj6b7cyqXOasGHxL7VKLDkeoC
	 fwYWHS3tYviHw==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69C0rGmE53402120
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 12 Oct 2026 08:53:16 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 12 Oct 2026 08:53:23 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Mon, 12 Oct 2026 08:53:23 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Mauro <mauro.mossino91@gmail.com>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>
Subject: RE: [BUG] rtw89: 8852CE BT A2DP stuttering with WiFi traffic, "timed
 out to flush queues", bogus -110 dBm RSSI (ThinkPad E16 Gen 2 AMD)
Thread-Topic: [BUG] rtw89: 8852CE BT A2DP stuttering with WiFi traffic, "timed
 out to flush queues", bogus -110 dBm RSSI (ThinkPad E16 Gen 2 AMD)
Thread-Index: AQHdV3t6QAq9tpsuwkqfF4iRpV9Z7bb5F1Gw
Date: Mon, 12 Oct 2026 00:53:22 +0000
Message-ID: <3fa163d9708c42a1a6e5a5f2d89c0635@realtek.com>
References: <CAOZV7v+j-BvXDTQsiRwY6m_KH8ESabqk=xXDzd=TxJSmMZnczg@mail.gmail.com>
In-Reply-To: <CAOZV7v+j-BvXDTQsiRwY6m_KH8ESabqk=xXDzd=TxJSmMZnczg@mail.gmail.com>
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

TWF1cm8gPG1hdXJvLm1vc3Npbm85MUBnbWFpbC5jb20+IHdyb3RlOg0KPiBIZWxsbywNCj4gDQo+
IG9uIGEgVGhpbmtQYWQgRTE2IEdlbiAyIEFNRCB3aXRoIFJUTDg4NTJDRSwgQmx1ZXRvb3RoIEEy
RFAgYXVkaW8gc3R1dHRlcnMNCj4gd2hlbmV2ZXIgV2lGaSBjYXJyaWVzIHRyYWZmaWMsIGV2ZW4g
b24gNSBHSHogYW5kIHdpdGggYWxsIHBvd2VyIHNhdmluZw0KPiBkaXNhYmxlZC4NCj4gDQo+IFN5
c3RlbQ0KPiAgIE1hY2hpbmU6ICAgVGhpbmtQYWQgRTE2IEdlbiAyIEFNRCAoMjFNNUNUTzFXVyks
IFJ5emVuIDcgNzczNUhTDQo+ICAgQklPUzogICAgICBSMktFVDM3VyAoMS4yNikNCj4gICBLZXJu
ZWw6ICAgIDcuMi45LTIwMC5mYzQ0Lng4Nl82NCAoRmVkb3JhIDQ0KQ0KPiAgIGxpbnV4LWZ3OiAg
MjAyNjA5MTYNCj4gICBQaXBlV2lyZSAxLjYuOSwgV2lyZVBsdW1iZXIgMC41LjE4LCBCbHVlWiA1
Ljg3DQo+IA0KPiBXaUZpDQo+ICAgMTBlYzpjODUyLCBzdWJzeXN0ZW0gMTdhYTo1ODUyLCBkcml2
ZXIgcnR3ODlfODg1MmNlDQo+ICAgRmlybXdhcmUgMC4yNy4xMjkuNCAoM2YxYTUzMDIpLCBydHc4
OS9ydHc4ODUyY19mdy0yLmJpbg0KPiAgIGNoaXAgaW5mbyBDSUQ6IDAsIENWOiAxLCBBSUQ6IDAs
IEFDVjogMCwgUkZFOiAxDQo+ICAgTGluazogNTIwMCBNSHosIDgwIE1IeiwgLTQ1IGRCbSwgVkhU
LU1DUyA5IE5TUyAyDQo+IA0KPiBCbHVldG9vdGgNCj4gICBVU0IgMGJkYTo1ODUyLCBydGxfYnQv
cnRsODg1MmN1X2Z3X3YyLmJpbiArIHJ0bDg4NTJjdV9jb25maWcuYmluDQo+ICAgZncgdmVyc2lv
biAweDA0MGQ3MjI1LCBsbXBfc3VidmVyIDB4ODg1Mg0KPiAgIENvZGVjIGluIHVzZTogPFNCQy9B
QUM+DQo+IA0KPiBTZXR0aW5ncyB0cmllZCAobm8gaW1wcm92ZW1lbnQpOg0KPiAgIG9wdGlvbnMg
cnR3ODlfY29yZSBkaXNhYmxlX3BzX21vZGU9eQ0KPiAgIG9wdGlvbnMgcnR3ODlfcGNpIGRpc2Fi
bGVfYXNwbV9sMT15IGRpc2FibGVfYXNwbV9sMXNzPXkgZGlzYWJsZV9jbGtyZXE9eQ0KPiAgIG9w
dGlvbnMgYnR1c2IgZW5hYmxlX2F1dG9zdXNwZW5kPW4NCj4gICBvcHRpb25zIHVzYmNvcmUgYXV0
b3N1c3BlbmQ9LTENCj4gICBOZXR3b3JrTWFuYWdlciB3aWZpLnBvd2Vyc2F2ZT0yIChpdzogUG93
ZXIgc2F2ZTogb2ZmKQ0KDQpUaGFua3MuIFNvIHRoZSBwcm9ibGVtIGlzbid0IGJlY2F1c2Ugb2Yg
cG93ZXIgc2F2ZS4NCg0KPiANCj4gTm90ZTogQVNQTSBpcyBmaXJtd2FyZS1jb250cm9sbGVkIG9u
IHRoaXMgbWFjaGluZSAoIk9TIGRvZXNuJ3QgaGF2ZSBBU1BNDQo+IGNvbnRyb2wiKSwgc28gdGhl
IHJ0dzg5X3BjaSBBU1BNIG9wdGlvbnMgbWF5IGhhdmUgbm8gZWZmZWN0Lg0KPiANCj4gT2JzZXJ2
YXRpb25zDQo+IDEpIER1cmluZyB0cmFmZmljIHRoZSBkcml2ZXIgbG9nczoNCj4gICAgICBydHc4
OV84ODUyY2UgMDAwMDowMzowMC4wOiB0aW1lZCBvdXQgdG8gZmx1c2ggcXVldWVzDQoNCkNhbiB5
b3UgZGVzY3JpYmUgaG93IHRoZSB0cmFmZmljIGlzPw0KDQpOb3JtYWxseSBkcml2ZXIgbmVlZHMg
dG8gZmx1c2ggcXVldWVzIGZvciBzY2FubmluZyBvciByZWtleWluZy4gDQpOb3Qgc3VyZSB3aHkg
aXQgZGVwZW5kcyBvbiB0cmFmZmljLiANCg0KPiAyKSBPbiBhIHByZXZpb3VzIGJvb3QgdGhlIGxv
ZyB3YXMgZmxvb2RlZCB3aXRoOg0KPiAgICAgIHdscDNzMCAocGh5ICMwKTogQ1FNIGV2ZW50OiBS
U1NJICgtMTEwIGRCbSkgd2VudCBhYm92ZSB0aHJlc2hvbGQNCj4gICAgLTExMCBkQm0gbG9va3Mg
bGlrZSBhIHBsYWNlaG9sZGVyIHZhbHVlLCBub3QgYSByZWFsIG1lYXN1cmVtZW50DQo+ICAgIChy
ZWFsIHNpZ25hbCAtNDUuLi02MiBkQm0pLg0KDQpJIGRvbid0IHNlZSB0aGUgZXZlbnQgaW4gYXR0
YWNobWVudC4gV2hlcmUgZGlkIHlvdSBmaW5kIGl0Pw0KDQpObyBjbGVhciBpZGVhIHdoeSBzb21l
aG93IGhhcmR3YXJlIHJlcG9ydGVkIGFibm9ybWFsIFJTU0kuDQoNCg0KPiAzKSBydHc4OSBJUlEg
cmF0ZTogfjQ2MC9zIHVuZGVyIG5vcm1hbCB1c2UsIG5vIGludGVycnVwdCBzdG9ybS4NCj4gDQo+
IFBvc3NpYmx5IHJlbGV2YW50OiB0aGUgVFNDIGlzIG1hcmtlZCB1bnN0YWJsZSBhdCBib290IG9u
IHRoaXMgbWFjaGluZQ0KPiAoZmlybXdhcmUgaXNzdWUsIHJlcG9ydGVkIHRvIHBsYXRmb3JtLWRy
aXZlci14ODYpIGFuZCB0aGUgY2xvY2tzb3VyY2UgaXMNCj4gSFBFVCwgd2hpY2ggbWF5IG1ha2Ug
dGhlIHRpbWluZy1zZW5zaXRpdmUgY29leCBwYXRoIHdvcnNlLg0KPiANCj4gU2ltaWxhciByZXBv
cnQ6IGh0dHBzOi8vZGlzY3Vzc2lvbi5mZWRvcmFwcm9qZWN0Lm9yZy90LzE0MjE2NQ0KDQpJdCBs
b29rcyBsaWtlIHRoZXJlIGFyZSBtYW55IHRlc3RzIGluIHRoZSB0aHJlYWQuIENhbiB5b3UgYmlz
ZWN0IHRoZQ0KY2F1c2UgaW4geW91ciBzaWRlIGxpa2UgdGhlIHRocmVhZCBkaWQ/IA0KDQpQaW5n
LUtlDQoNCg==
