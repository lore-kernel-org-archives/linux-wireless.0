Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F6D234964
	for <linux-wireless@vger.kernel.org>; Thu, 21 May 2026 00:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779324193; cv=none; b=P1vSqhFv2Zyuzlxo7BzA3Gy5Tkdi9EwJqhA/Rlg2cdvUE29q+5QaTCJwVJfQRMDJ6zCpdQfR1x0G2tqPFydGWIaX4fn3i8v0idSKeun+qObQV9toyArmvRgmCJ97P+HZedf+I8S9nx6z1LRqiSjSir4JEd/aevE8DGM4lEl9NQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779324193; c=relaxed/simple;
	bh=YzG9OuK0hSP+jlFBlypfxyYIandUu0KUPjdEl1JUsq0=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=u+RJKA8Iyz0YPpT9Hgl9nebSPfUBvKmm0HVINnWzU5ZwNLgPok0YM0tOjgu8s011BQvEmfftyo+Iv3xYVL4ALFhP0cmz7skmFhJqXO5FBuDsHmPMOyH5Rg9SH0x/8HduFyHULbZ97q7KQ1jF+RkWfjwsTWOAQpl4qhMbxWvnDSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=QAqjQ6FK; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="QAqjQ6FK"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 64L0goHpB733957, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1779324170; bh=YzG9OuK0hSP+jlFBlypfxyYIandUu0KUPjdEl1JUsq0=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=QAqjQ6FK+wyQFUASiTEv0oFfR/BN8qewzET8bEUSAiIQDXYNC2br5hQkP11+GvrDf
	 qWRS+fRd9Foqj5THWpSLtipVUtqnPNOT2r6Vdl5zuK4ehckceoZqR4eAp0HowlIFdU
	 8Jh1GMhgMLObwc+A7xf/Oa4ToMI9PmIxP7ZeCl9kjJ2eOIRoHuCwSLWx4ii+1UxKuu
	 bbL3ZQvkJPhZGIvFVFyT+vKGfOMAhZ6KJlKrf84KT2AGr5yaG5QqQ4MTFghqP+DpXe
	 b1Sw66xNtY5OGmLIxzp1KhOgKpNbuzuOoHJRmTyodpPxnol0aUFtCsLonN8XDkJtWd
	 XhvJl0Ow5xokA==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.28/5.94) with ESMTPS id 64L0goHpB733957
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 May 2026 08:42:50 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 21 May 2026 08:42:50 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 21 May 2026 08:42:50 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::e6fd:5a3f:8946:92c4%10]) with mapi id
 15.02.2562.017; Thu, 21 May 2026 08:42:50 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        Masashi Honma
	<masashi.honma@gmail.com>,
        "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>
Subject: RE: [PATCH v6 1/6] wifi: mac80211: Use struct instead of macro for
 PREQ frame
Thread-Topic: [PATCH v6 1/6] wifi: mac80211: Use struct instead of macro for
 PREQ frame
Thread-Index: AQHc5MP/zOngxkWbM0ai666I8zXda7YWRAMAgAFlUeA=
Date: Thu, 21 May 2026 00:42:50 +0000
Message-ID: <d2c051127e384a918ff014da02e37e1e@realtek.com>
References: <20260515233839.86829-1-masashi.honma@gmail.com>
 <965eff7ec3b928f093f7891e4307ec4e4a080ac4.camel@sipsolutions.net>
In-Reply-To: <965eff7ec3b928f093f7891e4307ec4e4a080ac4.camel@sipsolutions.net>
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

DQo+ID4gKyAgICAgICAgICAgICBvcmlnX2FkZHIgPSBwcmVxX2VsZW1fdG9wLT5vcmlnX2FkZHI7
DQo+ID4gKyAgICAgICAgICAgICBvcmlnX3NuID0gZ2V0X3VuYWxpZ25lZF9sZTMyKCZwcmVxX2Vs
ZW1fdG9wLT5vcmlnX3NuKTsNCj4gPiArICAgICAgICAgICAgIG9yaWdfbGlmZXRpbWUgPSBnZXRf
dW5hbGlnbmVkX2xlMzIoJnByZXFfZWxlbV9ib3R0b20tPmxpZmV0aW1lKTsNCj4gPiArICAgICAg
ICAgICAgIG9yaWdfbWV0cmljID0gZ2V0X3VuYWxpZ25lZF9sZTMyKCZwcmVxX2VsZW1fYm90dG9t
LT5tZXRyaWMpOw0KPiANCj4gT2ssIG9vcHMsIEkganVzdCByZWFsaXplZCBteSBvdGhlciB0aG91
Z2h0IG9uIHRoaXMgd2FzIHdyb25nIC0gdGhlDQo+IHByZXZpb3VzIFBSRVFfSUVfTElGRVRJTUUo
KSB3YXMgdTMyX2ZpZWxkX2dldCgpIHdoaWNoIGxvYWRlZCBhbiBlbnRpcmVseQ0KPiB1MzIgZnJv
bSB0aGVyZSB1c2luZyBnZXRfdW5hbGlnbmVkX2xlMzIoKS4NCj4gDQo+IEhvd2V2ZXIsIGFub3Ro
ZXIgY29tbWVudDogWW91IGRvbid0IG5lZWQgZ2V0X3VuYWxpZ25lZF9sZTMyKCkgaGVyZSBzaW5j
ZQ0KPiB0aGUgc3RydWN0IGlzIF9fcGFja2VkLCBzbyB5b3UgY2FuIHNpbXBsaWZ5IGFsbCBvZiB0
aGVzZSB0byBqdXN0DQo+IA0KPiAgICAgICAgIG9yaWdfc24gPSBsZTMyX3RvX2NwdShwcmVxX2Vs
ZW1fdG9wLT5vcmlnX3NuKTsNCj4gDQoNCkkgdGhpbmsgdGhlIF9fcGFja2VkIGNhbiBjYXVzZSB1
bmFsaWduZWQuIENvbnNpZGVyIHRoZSBvZmZzZXQgYmVsb3cgSSBhZGRlZC4gDQoNCnN0cnVjdCBp
ZWVlODAyMTFfbWVzaF9od21wX3ByZXFfdG9wIHsNCiAgICAgICB1OCBmbGFnczsJCQkJCS8vIG9m
ZnNldCA9IDANCiAgICAgICB1OCBob3Bjb3VudDsJCQkJCS8vIG9mZnNldCA9IDENCiAgICAgICB1
OCB0dGw7CQkJCQkJLy8gb2Zmc2V0ID0gMg0KICAgICAgIF9fbGUzMiBwcmVxX2lkOwkJCQkvLyBv
ZmZzZXQgPSAzICh1bmFsaWduZWQpDQogICAgICAgdTggb3JpZ19hZGRyW0VUSF9BTEVOXTsJCS8v
IG9mZnNldCA9IDcNCiAgICAgICBfX2xlMzIgb3JpZ19zbjsJCQkJLy8gb2Zmc2V0ID0gMTMgKHVu
YWxpZ25lZCkNCg0KICAgICAgIC8qIG9wdGlvbmFsIEFFLCBsaWZldGltZSwgbWV0cmljLCB0YXJn
ZXQgKi8NCiAgICAgICB1OCB2YXJpYWJsZVtdOw0KfSBfX3BhY2tlZDsNCg0KTm90IHN1cmUgaWYg
dGhlIHBvaW50ZXIgcHJlcV9lbGVtX3RvcCBjYW4gYWRqdXN0IG9mZnNldCBiYWNrIHRvIGJlIGFs
aWduZWQ/DQooQnV0IEkgdGhpbmsgd2UgZG9uJ3QgbWFrZSB0aGlzIGFzc3VtcHRpb24uKQ0KDQpQ
aW5nLUtlDQoNCg==
