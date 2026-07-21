Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B868D3BB13D
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 08:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784624269; cv=none; b=GdHn7KEpi1BGwrBGsESAZSOxGwCkfr9lu3wC0hNvaS2NCe7IE+q5EAYGEazmBA6eRgsThj4e7a6uwQhzmgVeubEKx8lisK1QogauEV/TSe5HPfEs1HXkOQMs6wip9MbpjYHQJW75zkYG/IDbeL3eROQz0VbCyqiK9B2XbkidQRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784624269; c=relaxed/simple;
	bh=XQBJx9UX4TDoZua5bWeKvoacojPp5FVG/7BxzkeenlU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VAJe2KWBDrR0mNH5O4D5/yVv9rvs/+t9nOubY+8YZU5gk3AEgwMcPp2EpSPUGEtNomhpqnXltiDIzHa79++e7b3lSPllIvK2NjaOhzO/Rv2ZzZOeIqupBt0cu39Bd2T/kaMkDoOIv2IiaW3nJVeyu4xvUUhhS1/5ubFVZXmPpIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=suadKkSJ; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="suadKkSJ"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66L8vR8j93076935, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784624248; bh=XQBJx9UX4TDoZua5bWeKvoacojPp5FVG/7BxzkeenlU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=suadKkSJG4BfXbHub33K5yesw/kZ4l7YyV99m6yXbrMMIy0hE0RB9/YQ1kp1DjSb4
	 297tL0oyPo2R9NM5E1+GnJasvYtetWADGqt9nzU4FltA+DGd8SAwm3oDkT/nEmDV/a
	 u2WAQ5/DSf9NOcuA9Jqtxzi8QPdeExpfcH+vedSA1HbCIg4KTq2uz1DG1/J1k1VPEL
	 ENVeRB3qDkp7opdkMmv1m07OTzKk+gYGxCVSwopaxBj9TDlRudcdDMiJMN6SrPOt30
	 9kBrV6ZcRSxNmfGPbs3xCKzhJgOuKr/F4Cjwrm6TXSszP9I+HYgXDX/8o7iXHU2fe/
	 ipr0khC0XdltQ==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66L8vR8j93076935
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 21 Jul 2026 16:57:27 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 21 Jul 2026 16:57:26 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::e6fd:5a3f:8946:92c4%10]) with mapi id
 15.02.2562.017; Tue, 21 Jul 2026 16:57:26 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Luka Gejak <luka.gejak@linux.dev>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>
CC: "straube.linux@gmail.com" <straube.linux@gmail.com>,
	"pbrobinson@gmail.com" <pbrobinson@gmail.com>
Subject: RE: [RFC PATCH v1 0/9] wifi: rtw88: add RTL8723B/RTL8723BS support
Thread-Topic: [RFC PATCH v1 0/9] wifi: rtw88: add RTL8723B/RTL8723BS support
Thread-Index: AQHdE7mArI84ceIbn0yTVbdL8mTXELZ1qU/ggAF1/4CAAJEswA==
Date: Tue, 21 Jul 2026 08:57:26 +0000
Message-ID: <cbaa891f94ce41c7a6a1d576db50b75c@realtek.com>
References: <cover.1784047561.git.luka.gejak@linux.dev>
 <1800080a275f4421b16bd3a028131e8a@realtek.com>
 <3EA0A653-D15F-4DD4-8DA6-C9CFFFF38205@linux.dev>
In-Reply-To: <3EA0A653-D15F-4DD4-8DA6-C9CFFFF38205@linux.dev>
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

SGkgTHVrYSwNCg0KTHVrYSBHZWphayA8bHVrYS5nZWpha0BsaW51eC5kZXY+IHdyb3RlOg0KPiBI
aSBQaW5nLUtlLA0KPiANCj4gVGhhbmtzIGZvciB0aGUgcmV2aWV3LCBhbmQgZm9yIHRha2luZyB0
aGUgdGltZSBvbiBhIHNlcmllcyB0aGlzIHNpemUuDQo+IA0KPiBCZWZvcmUgSSBzZW5kIHYyIEkg
d2FudCB0byByZXBvcnQgd2hhdCBjaGFuZ2VkLCBiZWNhdXNlIHRoZSByZXN1bHQgb2YNCj4geW91
ciBjb21tZW50cyBpcyB0aGF0IHRoZSBzZXJpZXMgZ2V0cyBub3RpY2VhYmx5IHNtYWxsZXIuIEkg
d291bGQNCj4gcmF0aGVyIHRlbGwgeW91IG5vdyB0aGFuIGhhdmUgeW91IHNwZW5kIHJldmlldyB0
aW1lIG9uIHBhdGNoZXMgSSBhbQ0KPiBhYm91dCB0byBkZWxldGUuDQoNCkkgdGhpbmsgeW91IGNh
biBzZW5kIHYyIGFzIHNtYWxsZXIgcGF0Y2hzZXQgbm93IGlmIHlvdSBoYXZlIGRvbmUgaXQuDQoN
CkluIHNob3J0LCBJIHByZWZlciBmaXJzdCBwYXRjaHNldCBpcyB0byBhZGQgUlRMODcyM0JTIHdp
dGggZmV3ZXIgc3BlY2lhbA0KY2FzZXMgYXMgcG9zc2libGUsIGFuZCBwYXRjaGVzIGxvb2tzIGxp
a2UNCiAtIGFkZCBoYXJkIHJlcXVpcmVkIGhhbmRsaW5nIGZvciBSVEw4NzIzQlMNCiAtIGFkZCBS
VEw4OTIzQiBtYWluIGJvZHkNCiAtIGFkZCBLY29uZmlnICYgTWFrZWZpbGUNCiAtIGFkZCBNQUlO
VEFJTkVSUw0KDQpJZiBzcGVjaWFsIGNhc2VzIGFyZSBzdGlsbCBuZWVkZWQsIHlvdSBjYW4gc3Vi
bWl0IHRoZW0gYWZ0ZXIgZmlyc3QNCnZlcnNpb24gZ2V0cyBtZXJnZWQuIA0KDQo+IA0KPiBBbnN3
ZXJzIHRvIHlvdXIgcXVlc3Rpb25zIGZyb20gdGhlIGNvdmVyIGxldHRlciBmaXJzdC4NCj4gDQo+
IDEuIFRoZSBsaW5rLiBNaWNoYWVsIFN0cmF1YmUncyBvcmlnaW5hbCB3b3JrIGlzIG5vdyByZWZl
cmVuY2VkIGluIHRoZQ0KPiAgICBjaGlwIHBhdGNoOg0KPiANCj4gICAgICBodHRwczovL2dpdGh1
Yi5jb20vbWlzdHJhdWJlL3J0dzg4L3RyZWUvcnRsODcyM2JzDQoNCkFkZGluZyB0aGlzIHRvIGNv
dmVyIGxldHRlciBmb3IgcmVmZXJlbmNlIHdpbGwgYmUgZ29vZCBmb3IgcmV2aWV3ZXJzLiANCg0K
PiANCj4gICAgVGhlIGN1cnJlbnQgc3RhdGUgb2YgbXkgc2VyaWVzIGlzIGhlcmUsIGlmIGl0IGlz
IGVhc2llciB0byByZWFkIHRoYW4NCj4gICAgbWFpbDoNCj4gDQo+ICAgICAgaHR0cHM6Ly9naXRo
dWIuY29tL01vY0xHL3J0dy90cmVlLzg3MjNicy11cHN0cmVhbQ0KDQpJIGhhdmUgbm90IHNlZW4g
dGhlIGRldGFpbCwgYnV0IGdvb2QgdG8gaGF2ZSBpdC4NCg0KPiANCj4gMi4gc3BhcnNlIGFuZCBz
bWF0Y2guIEJvdGggcmUtcnVuIG9uIHRoZSBuZXcgc2VyaWVzLCBjbGVhbiwgbm8gZmluZGluZ3MN
Cj4gICAgaW4gdGhlIDg3MjNiLzg3MjNicyBmaWxlcy4NCg0KUGxlYXNlIGtlZXAgcnVubmluZyB0
aGUgY2hlY2tzIGFmdGVyd2FyZC4gQXMgd2VsbCBhcyBjaGVja3BhdGNoLnBsIEkgZm9yZ290DQp0
byBtZW50aW9uLiANCg0KPiANCj4gMy4gQmx1ZXRvb3RoIGNvZXhpc3RlbmNlLiBUZXN0ZWQgYXMg
eW91IGFza2VkOiBXaUZpIGRvd25sb2FkIHdoaWxlIGFuDQo+ICAgIEEyRFAgc2luayBwbGF5cyBt
dXNpYywgc2hhcmVkIGFudGVubmEsIDIuNCBHSHogSFQ0MC4NCj4gDQoNClsuLi5dDQoNCj4gDQo+
ICAgIFRoZSByZXBvcnRlZCBCVCBjb2V4IHZlcnNpb24gaXMgMHg2OSwgYmVsb3cgdGhlIDB4NmQg
dGhlIDFhbnQNCj4gICAgcGFyYW1ldGVycyBleHBlY3QuIElzIHRoZSBydGw4NzIzYnMgQlQgZmly
bXdhcmUgY3VycmVudGx5IHNoaXBwZWQgaW4NCj4gICAgbGludXgtZmlybXdhcmUgb2xkZXIgdGhh
biB0aGUgY29leCBwcm90b2NvbCB0aGVzZSBwYXJhbWV0ZXJzIHdlcmUNCj4gICAgd3JpdHRlbiBm
b3IsIGFuZCBzaG91bGQgSSBiZSB1c2luZyBhIGRpZmZlcmVudCBibG9iPyANCg0KU29ycnkuIEkn
bSBub3Qgc3VyZS4gUGVyaGFwcywgeW91IGNhbiB0cnkgcnRsd2lmaS9ydGw4NzIzYmVmdy5iaW4g
b3INCnJ0bHdpZmkvcnRsODcyM2JlZndfMzYuYmluIChXaUZpIGZpcm13YXJlKSB0byBzZWUgaWYg
aXQgaXMgYmV0dGVyLiANCg0KKFRvIHByZXZlbnQgbGludXgtZmlybXdhcmUgbWFpbnRhaW5lciBt
ZXJnZSB5b3VyIHN1Ym1pc3Npb24gcmlnaHQgbm93LCANCiB5b3UgbWlnaHQgbmVlZCB0byBkcm9w
IHlvdXIgc3VibWlzc2lvbiBvZiBydHc4OC9ydHc4NzIzYl9mdy5iaW4gdGVtcG9yYXJpbHk/KQ0K
DQo+IA0KPiBOb3cgdGhlIGxhcmdlciBjaGFuZ2UuDQoNClRoYW5rcyBmb3IgeW91ciBmb2xsb3dz
Lg0KIA0KPiBUd28gY2F2ZWF0cyBJIHdhbnQgdG8gc3RhdGUgcGxhaW5seSByYXRoZXIgdGhhbiBo
YXZlIHlvdSBmaW5kIHRoZW0uDQoNCkFzIEkgbWVudGlvbmVkIGF0IGJlZ2lubmluZywgd2UgY2Fu
IGFkZCBzcGVjaWFsIGNhc2VzIGFmdGVyIGZpcnN0IHZlcnNpb24NCmdldCBtZXJnZWQuIEF0IHRo
YXQgdGltZSwgd2UgY2FuIGRpc2N1c3MgZWFjaCBwcm9ibGVtIGluIGRldGFpbCBieSBwYXRjaC4N
Cg0KPiBJIHdpbGwgaG9sZCB2MiB1bnRpbCB5b3UgaGF2ZSBoYWQgYSBjaGFuY2UgdG8gcmVhY3Qg
dG8gdGhlIHJlbW92YWxzLCBpbg0KPiBjYXNlIGFueSBvZiB0aGVtIHNob3VsZCBzdGF5LCBhbmQg
dG8gcGljayB1cCB3aGF0ZXZlciBlbHNlIHlvdSBmaW5kIGluDQo+IHRoZSBwYXRjaGVzIHRoYXQg
cmVtYWluLg0KDQpJIHdpbGwgc3RvcCByZXZpZXdpbmcgdjEgdG8gYXZvaWQgcmVkdW5kYW50IHdv
cmtzLiBZb3UgY2FuIHNlbmQgdjIgbm93LCBidXQNCnBsZWFzZSBnaXZlIG1lIHNvbWUgdGltZS4g
DQoNClBpbmctS2UNCg0K
