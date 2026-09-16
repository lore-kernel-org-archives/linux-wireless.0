Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C7FF3EB0E6;
	Wed, 16 Sep 2026 08:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789545708; cv=none; b=S22MWj9qNU6Ud0DQWeqs72a7+pubcP2S8vAoMgJ+/5pICsKvKCY2n45TLsxA1ZdaxGpc4QPyNrv41j0JSrhT7KiXaR+Vg2lRQsGA6S6dHt50JeNMwx9MqqpTrScZDPMXCOOmkkY8RwYHnBmnoVdMllfZd47+iD+PCujUiHBXZjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789545708; c=relaxed/simple;
	bh=6rI8hUsnpNorKsclnhB4MfAndqPFSeeM4F5XwN/G1zQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=epjfU8WI3JAIp+TIyEJw58OsAiwrn456FOFr+55snBY9TDkmt+85j6eq96m6WegxKxx1O+KF8+EMegW56hu3vvM09oiyyB0umDruopOPRNdqhebLZmTxyo2ZJWtSuFX6BBncuDEDG56w9FQ+R303xrLvoYoLbSKIU7YNrI/HvGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=iQpnd388; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="iQpnd388"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68G815nP42182700, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789545666; bh=6rI8hUsnpNorKsclnhB4MfAndqPFSeeM4F5XwN/G1zQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=iQpnd388x6HqN5lM8l6LR7EDo+zFb/0neHCkPZQ9Rv5fS/LMgx3+D5nrf+S6Yomjk
	 c6GV43aBqZ109kvPFTiB3AouirztcJl5n9bD9tyTMMZOUbHOP3dMUrf+5LUqMc3x6B
	 ++rHHGwnplurPM/pJkO2j0TaqWpX7c3EekoSxFhSWvSn4ZJl9N+gmZN4Gdspw0/l7Z
	 4ErfRQMKqO+mHi9eYquidT1C1gOHxWOXKNlbKc4fvYlcyqs8sXG49kSDwtFe6+JcMg
	 wJ5AAtm5X/nkxlMfGzHtv3Kz3XelqqKpxlbMx8u+KgwrwLULSI6uD7XIUhYoXrX7aR
	 OARf4WxNDsQDg==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68G815nP42182700
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 16 Sep 2026 16:01:06 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 16 Sep 2026 16:01:04 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Wed, 16 Sep 2026 16:01:04 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Peter Robinson <pbrobinson@gmail.com>
CC: "luka.gejak@linux.dev" <luka.gejak@linux.dev>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Bitterblue Smith
	<rtl8821cerfe2@gmail.com>
Subject: RE: [PATCH v11 1/7] wifi: rtw88: add the RTL8723B chip type and SDIO
 helper
Thread-Topic: [PATCH v11 1/7] wifi: rtw88: add the RTL8723B chip type and SDIO
 helper
Thread-Index: AQHdQC9Pa9h99Hy9KkK3Vh9b1IpI3rbQGdwAgABAwICAAIfM0A==
Date: Wed, 16 Sep 2026 08:01:04 +0000
Message-ID: <595af2640e4f4d34af9d3db6791bd468@realtek.com>
References: <20260909074556.55709-1-luka.gejak@linux.dev>
 <20260909074556.55709-2-luka.gejak@linux.dev>
 <15af360d-5098-440d-a0a9-3d20ec43dc7f@RTKEXHMBS04.realtek.com.tw>
 <CALeDE9MeWQGagFPy3TMA5WNRtw6-tRT5VS_uK8Kq5ZtKNd0xeQ@mail.gmail.com>
In-Reply-To: <CALeDE9MeWQGagFPy3TMA5WNRtw6-tRT5VS_uK8Kq5ZtKNd0xeQ@mail.gmail.com>
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

UGV0ZXIgUm9iaW5zb24gPHBicm9iaW5zb25AZ21haWwuY29tPiB3cm90ZToNCj4gT24gV2VkLCAx
NiBTZXB0IDIwMjYgYXQgMDU6MDIsIFBpbmctS2UgU2hpaCA8cGtzaGloQHJlYWx0ZWsuY29tPiB3
cm90ZToNCj4gPg0KPiA+IGx1a2EuZ2VqYWtAbGludXguZGV2IHdyb3RlOg0KPiA+DQo+ID4gPiBG
cm9tOiBMdWthIEdlamFrIDxsdWthLmdlamFrQGxpbnV4LmRldj4NCj4gPiA+DQo+ID4gPiBUaGUg
UlRMODcyM0IgaXMgYSA4MDIuMTFuIGNvbWJvIGNoaXAgd2hvc2UgU0RJTyB2YXJpYW50LCBSVEw4
NzIzQlMsIHJ1bnMNCj4gPiA+IGEgUmVhbHRlayB2ZW5kb3IgZmlybXdhcmUgdGhhdCBkaWZmZXJz
IGZyb20gdGhlIGZpcm13YXJlIHVzZWQgYnkgdGhlDQo+ID4gPiBvdGhlciBydHc4OCA4NzIzIGZh
bWlseSBkZXZpY2VzLiBTdXBwb3J0aW5nIGl0IG5lZWRzIGEgbnVtYmVyIG9mIHNtYWxsDQo+ID4g
PiBhZGp1c3RtZW50cyBzcHJlYWQgYWNyb3NzIHRoZSBzaGFyZWQgY29yZSwgYWxsIG9mIHdoaWNo
IGhhdmUgdG8gYmUNCj4gPiA+IHJlc3RyaWN0ZWQgdG8gdGhpcyBvbmUgY2hpcCBhbmQgYnVzIGNv
bWJpbmF0aW9uLg0KPiA+ID4NCj4gPiA+IEFkZCB0aGUgY2hpcCB0eXBlIGFuZCBhIGhlbHBlciB0
aGF0IHRlc3RzIGZvciBpdCwgc28gdGhlIGNoYW5nZXMgdGhhdA0KPiA+ID4gZm9sbG93IGNhbiBi
ZSBnYXRlZCB3aXRob3V0IHJlcGVhdGluZyB0aGUgY2hpcCBhbmQgYnVzIGNvbXBhcmlzb24uDQo+
ID4gPg0KPiA+ID4gU2lnbmVkLW9mZi1ieTogTHVrYSBHZWphayA8bHVrYS5nZWpha0BsaW51eC5k
ZXY+DQo+ID4gPiBBY2tlZC1ieTogUGluZy1LZSBTaGloIDxwa3NoaWhAcmVhbHRlay5jb20+DQo+
IA0KPiBBcG9sb2dpZXMgZm9yIHRoZSBsYXRlIHJlcGx5IGJ1dCBpZiBpdCdzIHVzZWZ1bDoNCj4g
VGVzdGVkLWJ5OiBQZXRlciBSb2JpbnNvbiA8cGJyb2JpbnNvbkBnbWFpbC5jb20+ICMgUGluZTY0
KyBhbmQgUGluZTY0LUxUUw0KDQpUaG91Z2ggSSBkb24ndCB3YW50IHRvIHRvdWNoIGdpdCByZXBv
c2l0b3J5LCBpdCBpcyB3b3J0aCB0byBoYXZlIHRoaXMNCmZvciB0aGUgcmVjb3JkLiA6KQ0KDQoN
Cg==
