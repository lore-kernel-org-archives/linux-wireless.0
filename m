Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 277FF3264DD;
	Tue, 25 Aug 2026 07:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787641699; cv=none; b=HNwTgE64MNIQ3H+JIBJkZDsYMqLmizJNlzL0qxS9M6y3QL4yPCYpz6YBLwd5im+LJdxwcP3bkQRJNEV/uNUr/LXXjo1KUDuwEUKM+5ZyDohzsMbOYvX+WKaNou+yI/VjDOvKmDnZ/g7jgjtst0OP2mX+yLcZNSjMU8dSa50jFEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787641699; c=relaxed/simple;
	bh=gif2ySCW30wv8A/bDJEbuZ+FzWsbfBT93ZjBnQ7ia/w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QrELtap5QysUbm2Udd7NOqhLJSzr/rp85acnM41HU7eiTDAKa404VQ0GJtWcumVbDmcE9uds+FTuCmkBKwnTHwpWO92ERIPcNjhcUD3PnPQhdcerpGwdyiIlXoOuL03xkxAO2whXy4S8YM3gJmXsLsgEB26sXLTe4NiSzMyua3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=qV/GqQTg; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="qV/GqQTg"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67P783pcC3575963, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1787641684; bh=gif2ySCW30wv8A/bDJEbuZ+FzWsbfBT93ZjBnQ7ia/w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=qV/GqQTg5mMoRGrQl5HysQFoRNT23OqHpWes+BSw6dkoc20IkOgHgjcaIUb/7DqHS
	 pPGKc5Mqg7E5/Aj7gQM9VyPYWFjKsswjR4JIhF/1Kv6yMV/dZ1r6QeIAR90hU06Iso
	 3gKshYruCLbmypIsAUPz17fjcrQBhcQvP9Al2kIcs5GUBK5jcnhAkxaWNlcqksJBvg
	 3S1p+Eao0q2eYNCQ0/UKx5PIFElshPQVj7ReQ503Sz68VFUgPrZDMza1O6/z00N7SO
	 vrh4cymtUiVUNNzz6l65QBxGCuQ0hBaWhEpz7CZMfnrpUuzRAlUaCrDPB6WMQDnWEz
	 n7Z8C+lqPKYqg==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67P783pcC3575963
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 25 Aug 2026 15:08:04 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 25 Aug 2026 15:08:03 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 25 Aug 2026 15:08:02 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Tue, 25 Aug 2026 15:08:02 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Luka Gejak <luka.gejak@linux.dev>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Bitterblue Smith
	<rtl8821cerfe2@gmail.com>, Peter Robinson <pbrobinson@gmail.com>, "Hans de
 Goede" <johannes.goede@oss.qualcomm.com>
Subject: RE: [PATCH v7 0/6] wifi: rtw88: preparations for RTL8723B/RTL8723BS
Thread-Topic: [PATCH v7 0/6] wifi: rtw88: preparations for RTL8723B/RTL8723BS
Thread-Index: AQHdMILsUfq7l0gUJkugUgMMloIoWLapxfaAgADcNoCAA7hroA==
Date: Tue, 25 Aug 2026 07:08:02 +0000
Message-ID: <803413aa2b1f44bbaa96b440b0693a58@realtek.com>
References: <20260820090412.19574-1-luka.gejak@linux.dev>
 <44120736-F50E-4AD0-A380-3CEBB6A2F7F4@linux.dev>
 <C16E411D-37A6-484C-80ED-593AA5596A1B@linux.dev>
In-Reply-To: <C16E411D-37A6-484C-80ED-593AA5596A1B@linux.dev>
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

THVrYSBHZWphayA8bHVrYS5nZWpha0BsaW51eC5kZXY+IHdyb3RlOg0KPiBPbiBBdWd1c3QgMjIs
IDIwMjYgNjo1MTo1OSBQTSBHTVQrMDI6MDAsIEx1a2EgR2VqYWsgPGx1a2EuZ2VqYWtAbGludXgu
ZGV2PiB3cm90ZToNCj4gPk9uIEF1Z3VzdCAyMCwgMjAyNiAxMTowNDowNiBBTSBHTVQrMDI6MDAs
IGx1a2EuZ2VqYWtAbGludXguZGV2IHdyb3RlOg0KPiA+PkZyb206IEx1a2EgR2VqYWsgPGx1a2Eu
Z2VqYWtAbGludXguZGV2Pg0KPiA+Pg0KPiA+PlRoaXMgaXMgdGhlIGZpcnN0IG9mIHR3byBzZXJp
ZXMgYWRkaW5nIHN1cHBvcnQgZm9yIHRoZSBSZWFsdGVrIFJUTDg3MjNCDQo+IA0KPiAuLi4NCj4g
DQo+ID5Ob3RoaW5nIGluIHRoaXMgc2VyaWVzIGNoYW5nZXMuIFRoZSByYXRlIGlzIGFib3V0IG9u
ZSBpbiA5MjAwIHdha2VzLg0KPiA+DQo+ID5CZXN0IHJlZ2FyZHMsDQo+ID5MdWthIEdlamFrDQo+
IA0KPiBGb2xsb3cgdXAgdG8gdGhlIHByZXZpb3VzIGVtYWlsOg0KPiANCj4gVGhlIHNvYWsgaGFz
IHJ1biBvbiBzaW5jZSB0aGF0IG1haWwuIE92ZXIgMTEwNTU3IHdha2VzIHRoZXJlIGlzIG5vdyBv
bmUNCj4gcG9sbCAzLCBzdGlsbCBubyBwb2xsIDQsIGFuZCBmb3VyIGZhaWx1cmVzOg0KPiANCj4g
ICAgICAgICBwb2xsMD0xNTggcG9sbDE9MTEwNTU3IHBvbGwyPTM1IHBvbGwzPTEgcG9sbDQ9MCBm
YWlscz00DQoNCklzIHRoaXMgZGlzdHJpYnV0aW9uIG9mIHBvbGxpbmcgdGltZXM/DQpEb2VzIGl0
IG1lYW4gNCBpbnN0YW5jZXMgb3ZlciA0IHRpbWVzIG9mIHBvbGxpbmc/DQoNCk9uZSByZWFzb24g
dGhlIGZpcm13YXJlIGNhbid0IGxlYXZlIExQUyBwcm9wZXJseSBpcyB0aGF0IHNvbWUgcGFja2V0
cw0KYXJlIHN0aWxsIGluIGhhcmR3YXJlIHF1ZXVlLCBzbyB0aGlzIG1pZ2h0IGJlIGhpZ2hseSBy
ZWxhdGVkIHRvDQplbnZpcm9ubWVudC4NCg0KTW9yZSwgaXQgaXMgd29ydGggdG8gdHJ5IGRpc2Fi
bGVfbHBzX2RlZXA9eS4NCg0KPiANCj4gU28gZmFpbHVyZXMgb3V0bnVtYmVyIHBvbGwgMyBzdWNj
ZXNzZXMsIHdoaWNoIG1ha2VzIHRoZSBwb2ludCBzdHJvbmdlciwNCj4gbm90IHdlYWtlci4gVGhl
IHJhdGUgaXMgYWJvdXQgMSBpbiAyNzYwMCB3YWtlcyByYXRoZXIgdGhhbiB0aGUgMSBpbg0KPiA5
MjAwLCB3aGljaCBJIHF1b3RlZCBmcm9tIHRoZSBzbWFsbGVyIHNhbXBsZS4NCg0KDQoNCg0KDQoN
Cg==
