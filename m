Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA2F913C908;
	Thu, 17 Sep 2026 01:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789607903; cv=none; b=jf7Z8ubUaUDmHY0CeP2rp3zXkj9an47QeCCL3knJULn2W7NlzQnzGu/XkR8VU23bNlgCTwffiSsEwQYDodXKEq/DdfAsBZ+ozLs3DwuXOlJJFKPocgaWo5vOAe6BBu/eJ/jXKtlJiyscuC+RWbUx6REf82ifYDG38q1542jOrFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789607903; c=relaxed/simple;
	bh=EATQlpzzMnaDmW6yLWFAEafoD3+5QC45zmGxfrSmTME=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LXCFcjvY0pZHbtTSjoOkxIHR9mwJBmPq7wll+42PqeCCsKL/0EGJKdnPM2x0TSJ5OVmwttPfyE784U5/sIqFF6DfATykR+kYWk1K9DZcPHCxP8alnObR3N7sWoHHZKoGs8+SPvcD0SA5ieurH4XBH8ee+RrhsmPQvY1tqlbhakU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=Zdn0Wzrd; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="Zdn0Wzrd"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68H1IAlmC2880613, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789607890; bh=EATQlpzzMnaDmW6yLWFAEafoD3+5QC45zmGxfrSmTME=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=Zdn0Wzrd64k/H6pD/JlO/Y1qa8Oyb4ME3tBUh60IBElqHrLS6VVc7tuxORc8QUI0J
	 MlYLNAALwoxgydrIQvmrC4ArFXe5NheUsgvSyPqL0nSNE5w5I6eHKTtRF6xDwzxban
	 eVfGotz8P0qfbEmM972Xjqso7cwsKQBzrxt3rBGvYPhbaWeTUU1W0NlpO1BBT/XmN+
	 iJogq4Xin2Jow+OrxAauTVx0td34DQVS+UGM+rEHR2t453S0L1gNqdqXYNuCOZHCbR
	 L9A4TE9dRdXP25gx9qjmSdoLpuB8VlOri3OjyUa4TUc14qfzoZdUBXqjimUpP4E4FL
	 jAQa/l+ib78Eg==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68H1IAlmC2880613
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 17 Sep 2026 09:18:10 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 17 Sep 2026 09:18:10 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Thu, 17 Sep 2026 09:18:10 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: "5mghybrid@khu.ac.kr" <5mghybrid@khu.ac.kr>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Jes Sorensen <Jes.Sorensen@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH rtw-next v2 1/4] wifi: rtl8xxxu: free RX skb when URB
 submission fails
Thread-Topic: [PATCH rtw-next v2 1/4] wifi: rtl8xxxu: free RX skb when URB
 submission fails
Thread-Index: AQHdQ1IxiIqtfPPoo0eEiuaP6H+hobbR/gMg
Date: Thu, 17 Sep 2026 01:18:10 +0000
Message-ID: <de086af71cc346d9ac8ca4e7bf8787e0@realtek.com>
References: <20260913-codex-rtw-rx-v2-v2-0-f09c964e0b96@khu.ac.kr>
 <20260913-codex-rtw-rx-v2-v2-1-f09c964e0b96@khu.ac.kr>
In-Reply-To: <20260913-codex-rtw-rx-v2-v2-1-f09c964e0b96@khu.ac.kr>
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

a2ltd29vc2VvayB2aWEgQjQgUmVsYXkgPGRldm51bGwrNW1naHlicmlkLmtodS5hYy5rckBrZXJu
ZWwub3JnPiB3cm90ZToNCj4gRnJvbToga2ltd29vc2VvayA8NW1naHlicmlkQGtodS5hYy5rcj4N
Cj4gDQo+IEEgZmFpbGVkIFJYIFVSQiBzdWJtaXNzaW9uIGNhbiBsZWFrIHRoZSBza2IgYWxsb2Nh
dGVkIGZvciB0aGF0IGF0dGVtcHQuDQo+IHJ0bDh4eHh1X3N1Ym1pdF9yeF91cmIoKSBhbGxvY2F0
ZXMgdGhlIGJ1ZmZlciBhbmQgc3RvcmVzIGl0IGluIHVyYi5jb250ZXh0LA0KPiBidXQgaWYgdXNi
X3N1Ym1pdF91cmIoKSBmYWlscywgaXQgb25seSB1bmFuY2hvcnMgdGhlIFVSQi4gVGhlIFJYIHdv
cmtlcg0KPiBxdWV1ZXMgRU5PTUVNL0VBR0FJTiBmYWlsdXJlcyBmb3IgcmV0cnkgd2l0aCB0aGF0
IGJ1ZmZlciBzdGlsbCBhdHRhY2hlZC4NCj4gDQo+IE9uIHRoZSBuZXh0IGF0dGVtcHQsIHJ0bDh4
eHh1X3N1Ym1pdF9yeF91cmIoKSBhbGxvY2F0ZXMgYW5vdGhlciBza2IgYW5kDQo+IG92ZXJ3cml0
ZXMgdXJiLmNvbnRleHQsIGxvc2luZyB0aGUgcmVmZXJlbmNlIHRvIHRoZSBwcmV2aW91cyBidWZm
ZXIuDQo+IFN0b3BwaW5nIGJlZm9yZSB0aGUgcmV0cnkgYWxzbyBsZWFrcyB0aGUgYnVmZmVyIGJl
Y2F1c2UgcGVuZGluZy1yZXF1ZXN0DQo+IGNsZWFudXAgZnJlZXMgb25seSB0aGUgVVJCLg0KPiAN
Cj4gRml4IHRoZSBsZWFrIGF0IHRoZSBzdWJtaXNzaW9uIGZhaWx1cmUgYnkgbWFraW5nIHJ0bDh4
eHh1X3N1Ym1pdF9yeF91cmIoKQ0KPiByZXNwb25zaWJsZSBmb3IgYm90aCBhbGxvY2F0aW5nIHRo
ZSBza2IgYW5kIHJlbGVhc2luZyBpdCB3aGVuIHN1Ym1pc3Npb24NCj4gZmFpbHMuIEZyZWUgdGhl
IG5ld2x5IGFsbG9jYXRlZCBza2IgYW5kIGNsZWFyIHVyYi5jb250ZXh0IGJlZm9yZSByZXR1cm5p
bmcNCj4gdGhlIGVycm9yLCBzbyBuZWl0aGVyIHJldHJ5IG5vciBzdG9wIHJlY2VpdmVzIGEgcGVu
ZGluZyBVUkIgdGhhdCBzdGlsbA0KPiBvd25zIGEgYnVmZmVyLiBSZW1vdmUgdGhlIGNhbGxlci1z
aWRlIHNrYiBjbGVhbnVwIGZyb20gc3RhcnQgYW5kIHRoZSBSWA0KPiB3b3JrZXI7IHRob3NlIGNh
bGxlcnMgbm93IGhhbmRsZSBvbmx5IHdoZXRoZXIgdG8gcmV0cnkgb3IgcmVsZWFzZSB0aGUgVVJC
Lg0KPiANCj4gRml4ZXM6IDI2ZjFmYWQyOWFkOSAoIk5ldyBkcml2ZXI6IHJ0bDh4eHh1IChtYWM4
MDIxMSkiKQ0KPiBBc3Npc3RlZC1ieTogR1BULTYgQXN0cmENCj4gU2lnbmVkLW9mZi1ieToga2lt
d29vc2VvayA8NW1naHlicmlkQGtodS5hYy5rcj4NCg0KQ2FuIHlvdSBnaXZlIHlvdXIgcy1vLWIg
bW9yZSBmb3JtYWw/IExpa2UsIEtpbSBXb28tU2Vvaz8NCg0KUmV2aWV3ZWQtYnk6IFBpbmctS2Ug
U2hpaCA8cGtzaGloQHJlYWx0ZWsuY29tPg0KDQoNCg==
