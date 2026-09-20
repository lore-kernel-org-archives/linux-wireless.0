Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC092175A9C;
	Sun, 20 Sep 2026 02:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789872297; cv=none; b=LsPHGi98N6c0L/KxCsnKtC0UUnacOaAIP5+8k01MNZgOMEYJGBJOfszZ7KE6a960gHBJ8bNL/qx7PMVs2vOPFtbA6W49I+TbdlF1Bf2pm0IVG+OvAZc4fM0W99dRyWdLvyGjsc6DPAJnN8OTTkvUDAt/VZVDaZ29zr16R8Aumfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789872297; c=relaxed/simple;
	bh=4n/bFs6ic7VIZfauhBfOmqEG3hLBs1veAP5O8CJW94Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iQy6KrNB4ekUM8Gjn2OSwG171kAmsPMbVEnt4FVkr58F+YaqfYmrm8XspRHYqDlpEDkMSnissdElyxNS9+Z68b8J6FwHKFPCcVutVzhLGZ5M9bJWSrYyy74yUmWEgvRB1NfLwdb0hI0tnNX2B2re+eecCIdS7zqzf/UrLJ5SmI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=S+gP+O0o; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="S+gP+O0o"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68K2ikmL71372315, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789872286; bh=4n/bFs6ic7VIZfauhBfOmqEG3hLBs1veAP5O8CJW94Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=S+gP+O0o2EK943h9+PRBhmId5CwrzN4jzDwYqMmnD7SUASI1fo9eyt2BAuEqCJlbN
	 VRwDPLe6wBbo56zGNVHXwZh0SUP/eibeV+UeowW71Tpc8OIqtifzjgD0NMRo/gYJs/
	 rV5hg/n8g1rsW9UZFiVUFqxjY8MTuxt6l22YgKXJDBbSoL6B/0Q1VKt6uz5Ca4epza
	 a06zw0KAHD7FpF6tpOPmZ0PumwUCpfvXJLx6ZngGwEryYAAUKW4jSG8w0ILLFMFf9S
	 ppXldGvLwWSvVdwEtkxWLNqfU6rXRvSvIilhmCne/7FjWmR5L/WryPEJvfFmdHy/ZR
	 wiweOwOuCxlkw==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68K2ikmL71372315
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sun, 20 Sep 2026 10:44:46 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 20 Sep 2026 10:44:46 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 20 Sep 2026 10:44:46 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Sun, 20 Sep 2026 10:44:46 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Kim Wooseok <5mghybrid@khu.ac.kr>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>, "Jes
 Sorensen" <Jes.Sorensen@gmail.com>, Kalle Valo <kvalo@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH rtw-next v2 0/4] wifi: rtl8xxxu: keep RX requests
 available across transient errors
Thread-Topic: [PATCH rtw-next v2 0/4] wifi: rtl8xxxu: keep RX requests
 available across transient errors
Thread-Index: AQHdQ1I2mDA7fbdcWkGpZktVmj75ArbT+qhQgAHn4ICAAOliUA==
Date: Sun, 20 Sep 2026 02:44:46 +0000
Message-ID: <6afa402449db46468c3cf7af410c5acd@realtek.com>
References: <20260913-codex-rtw-rx-v2-v2-0-f09c964e0b96@khu.ac.kr>
 <ca51eb88df7b4e83993af73c2f1e26bb@realtek.com>
 <CAH1Bc_wo3PqWiqFcWZX9xB_+99=zHOdCD1VUg0R287Z2B4ESrw@mail.gmail.com>
In-Reply-To: <CAH1Bc_wo3PqWiqFcWZX9xB_+99=zHOdCD1VUg0R287Z2B4ESrw@mail.gmail.com>
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

DQpLaW0gV29vc2VvayA8NW1naHlicmlkQGtodS5hYy5rcj4gd3JvdGU6DQo+IEhpIFBpbmctS2Us
DQo+IA0KPiBIZXJlIGFyZSB0aGUgdGVzdCBjb25kaXRpb25zIGFuZCByZXN1bHRzIHRvIGhlbHAg
d2l0aCB0aGUgdjMgcmV2aWV3LiBJDQo+IGhhdmUgbGlzdGVkIHRoZSAxMyB0ZXN0cyByZXBvcnRl
ZCBwcmV2aW91c2x5IGZpcnN0LCBmb2xsb3dlZCBieSB0aGUgdjMNCj4gcmVzdWx0cy4NCj4gDQo+
IFRoZSB0ZXN0cyB1c2VkIGFuIFJUTDgxOTJFVSBVU0IgYWRhcHRlciBvbiBhIFJhc3BiZXJyeSBQ
aS4gSSBhZGFwdGVkIHRoZQ0KPiBSWCBjaGFuZ2VzIHRvIHRoZSBQaSdzIGV4aXN0aW5nIExpbnV4
IDYuMTguNDYgUlQga2VybmVsIHNvIHRoZXkgY291bGQgYmUNCj4gdGVzdGVkIG9uIHRoZSBkZXZp
Y2UuDQo+IA0KPiBGb3IgdGhlIHJlY292ZXJ5IHRlc3RzIGJlbG93LCBJIGNoZWNrZWQgdGhhdCBh
bGwgMzIgVVJCcyB3ZXJlIHJldGFpbmVkLA0KPiByZWNlcHRpb24gcmVzdW1lZCB3aXRob3V0IHJl
c3RhcnRpbmcgdGhlIGludGVyZmFjZSwgYW5kIHN0b3AgZnJlZWQgdGhlDQo+IFVSQnMuIFRoZSBS
WCBjb21wbGV0aW9uIGNvdW50cyBhcmUgZnJvbSBhZnRlciB0aGUgaW5qZWN0ZWQgZXJyb3JzIGVu
ZGVkLg0KPiANCj4gMS4gY2xlYW4tZml4ZWQtcmVncmVzc2lvbg0KDQpBcmUgdGhlc2UgdGVzdCBp
dGVtcyBnZW5lcmF0ZWQgYnkgTExNPyBhbmQgaG93IGRpZCB5b3UgbWFrZSBwbGFuIHRvIHRlc3QN
CnRoZXNlPyAgKEp1c3QgY3VyaW91cy4pDQoNCj4gDQo+IFYzIHBhc3NlZCA1MiB0ZXN0czogNDIg
ZnJvbSB0aGUgbWFpbiB0ZXN0IHBsYW4sIG9uZSBtYXRjaGVkLWlucHV0DQo+IGNvbXBhcmlzb24s
IGFuZCBuaW5lIGZpcnN0LXN0YXJ0IGZhaWx1cmUgdGVzdHMgYWZ0ZXIgYSBmcmVzaCBtb2R1bGUN
Cj4gbG9hZC4gVHdvIGludGVycnVwdC1VUkIgdGVzdHMgd2VyZSBub3QgcnVuIGJlY2F1c2UgdGhl
IFJUTDgxOTJFVSBkb2VzDQo+IG5vdCB1c2UgdGhhdCBwYXRoLg0KDQpUaGUgbmV3IDUyIG9yIDQy
IHRlc3RzIEkgaGF2ZSBsYWNrIGluZm9ybWF0aW9uIGZvciB0aGVtLCBidXQgSSBkb24ndA0KYWN0
dWFsbHkgbmVlZCB0aGVtLiBJIHRoaW5rIHlvdSB3YW50IHRvIHNheSAidGhpcyBwYXRjaHNldCBp
cyBmdWxseQ0KdGVzdGVkIiwgcmlnaHQ/DQoNClBpbmctS2UNCg0K
