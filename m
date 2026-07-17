Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD709F507
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 00:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784247832; cv=none; b=jEoxeUe5RHWKNljgDJ3i6/6IpkLSxhYlUb6RC1PdzLxWBbl7Y9IUb594Pl8mLOLIWkcAdvbnbizAPYrSKUlYL8xqsrVQ1oYKv2DE8g/WF/coEDlempBgTe3/n8yZOC3DtZdvwYBonVd6cLAZI++7+5GDwWIfoLHNV4d/ZBUwmQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784247832; c=relaxed/simple;
	bh=mscBu/SZLieFUCkGV5z73y7uBEDgwiUUUHE/HDKEqA0=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gezWbegcW6XqPulxvE4HMZHgqRBpJWDjME+gjAAnyJPScKML88QFsrKaYqfwFoB93Nqqw1GmGeKvwgTu4oRDvm7JbVRc4W+/K9nh05/1mm0haXx7IBQfgQD63KuxWZZq1mTpotoJpS/nNpZw2sD5wU203qtwE7cdES6dJO3ZyJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=hgEispOz; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="hgEispOz"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66H0Nd9tA4016968, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784247819; bh=mscBu/SZLieFUCkGV5z73y7uBEDgwiUUUHE/HDKEqA0=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=hgEispOz9MJ8IwNsY0kJu9caAsmrY7L3jGxCSn/xOW0LXfNNn5/8cIgQtDD0WrNwY
	 sSGiaQfmfj77ASKz6p4MjIyK69mRautpK5+Z+tHOLHxivDRoaQJlRbfUgkWI4BI9Ij
	 eebqqGJH1EZ0BpPUNAz/hXv2t8DBGWoZ0fGcJcJfqeP+ai9Rpu2FDJ02l+NyOtoozt
	 bVbwuDindxW+OLmQ04uUjYt+ng4ja5nmrs+cHe5JS4oPVEjbiDT7t7eTMzx5x04k0S
	 U7Z/N2IB05LNGrRlqWdNRK1qWONpOWeMblNmP86LJU46cUR7L6UXq30dMI72I4Udum
	 tA+hTjk1aKBNg==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66H0Nd9tA4016968
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 17 Jul 2026 08:23:39 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 17 Jul 2026 08:23:40 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 17 Jul 2026 08:23:38 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::e6fd:5a3f:8946:92c4%10]) with mapi id
 15.02.2562.017; Fri, 17 Jul 2026 08:23:38 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Pochimilco <pochimilco@ik.me>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>
Subject: RE: Bugreport - rtw89: RTL8852AE dead-link stall | linux-zen 7.1.3
Thread-Topic: Bugreport - rtw89: RTL8852AE dead-link stall | linux-zen 7.1.3
Thread-Index: AQHdFTa2usSePJqztkeIJ0T5NJzLK7Zw2XIQ
Date: Fri, 17 Jul 2026 00:23:38 +0000
Message-ID: <f92e1bb526164e18a93399807dd779ac@realtek.com>
References: <3a31da03-039c-4ac5-bcc4-f2715a718fb7@ik.me>
In-Reply-To: <3a31da03-039c-4ac5-bcc4-f2715a718fb7@ik.me>
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

UG9jaGltaWxjbyA8cG9jaGltaWxjb0Bpay5tZT4gd3JvdGU6DQo+IEJ1Z3JlcG9ydCAgKGluZm9y
bWF0aW9uIGNvbGxlY3RlZCB3aXRoIHRoZSBoZWxwIG9mIEFJIC0gaSdtIG5vdCBhbg0KPiBleHBl
cnQgYnV0IGEgbW9yZSBsZXNzIGV4cGVyaWVuY2VkIGxpbnV4IHVzZXIgOykgKQ0KPiANCj4gSSBo
b3BlIGl0IGhlbHBzLi4uICB0aGFua3MsIFBvY2hpbWlsY28NCj4gLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gDQo+IFRp
dGxlOiBydHc4OTogUlRMODg1MkFFIGRlYWQtbGluayBzdGFsbCAoImNvbm5lY3RlZCBidXQgbm8g
dHJhZmZpYyIpDQo+IHVuZGVyIGxpbnV4LXplbiA3LjEuMywgYWJzZW50IHVuZGVyIGxpbnV4LWx0
cyA2LjE4DQo+IFByb2R1Y3Q6IE5ldHdvcmtpbmcNCj4gQ29tcG9uZW50OiBXaXJlbGVzcw0KPiBL
ZXJuZWw6IDcuMS4zLXplbjEtMy16ZW4gKEFyY2gvR2FydWRhKQ0KPiBEcml2ZXI6IHJ0dzg5IChp
bi1rZXJuZWwpLCBtb2R1bGUgcnR3ODlfODg1MmFlDQo+IEhhcmR3YXJlOiBUaGlua1BhZCBMMTMg
R2VuIDJhICgyMUFCMDAwUENLKSwgUmVhbHRlayBSVEw4ODUyQUUNCj4gU2V2ZXJpdHk6IGhpZ2gg
KGludGVybWl0dGVudCBjb25uZWN0aXZpdHkgbG9zcywgfjItMTAgbWluLCBzZWxmLXJlY292ZXJp
bmcpDQoNCkEgcGF0Y2ggWzFdIGlzIGdvaW5nIHRvIGJlIG1lcmdlZCBpbnRvIDcuMS40IChJIHN1
cHBvc2UpLiBJIHRoaW5rIHlvdSBjYW4NCnRyeSBpdCBhZ2FpbiBuZXh0IHdlZWsuDQoNClsxXSBo
dHRwczovL2xvcmUua2VybmVsLm9yZy9zdGFibGUvMjAyNjA3MTYxMzMwNDguNDM3MzMwMTA2QGxp
bnV4Zm91bmRhdGlvbi5vcmcvDQoNCg==
