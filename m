Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B5B38D686
	for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2026 02:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786674104; cv=none; b=FXv1eKUvaHQez1lQUoJKROxUgrQPptEdNyxe+EMKx2+caXp3mVZAG5M/2LwQK0+P4+1W2JBqMZ83fLZtd4lTWmvnCuuXwb4Dys4sxOfVS6ErrhWyQu6HVxLSD8JR84b+NvZlzayuMJiFQL1FbCeuqHFhwWxqAyjUI1MOfidi5yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786674104; c=relaxed/simple;
	bh=d6C/Y2tJByveH7nkerV5A+Y2SLl/ucErV5pJYJbnIQs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IJwQ9xbjnq//HHpnGdeOcANn2DLjd2f0YG0m1xTAmQK5ILlcRzaktB+x7+W55xc1CKYE4tDjr+ORwtD2yyF5Xp1KiwFxYiOcIBwi8hxcx0JV6t+aWBxpyEVGhXQPXK62sUtX6JqRS7CzLSSTGHmFSA3djlFdtncLEpTvBvQKRds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=ZVQQ+re7; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="ZVQQ+re7"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67E2Ld4qA879013, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1786674099; bh=d6C/Y2tJByveH7nkerV5A+Y2SLl/ucErV5pJYJbnIQs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=ZVQQ+re7M3Rli32eZ6j2a9yVJp7gbdT5shEjkazj8IKC5TtTj6lehXWW6qRzKpxCc
	 SsiAu/d9ULZOV15rzmxALyRBMoecFK0DScrBAxp/8AMnlQkOcJEBcUjDmQ1bdIGRgo
	 KOPi9hJlxW/X6MgaoExuTPo2W5i3Nkb5KtZzWftJZnyr+30bUN+Dlot0+4jlzGToSq
	 2tPhfz6MAAV83ABtKaky3nUdIHFQYC7ULcxgCHmjbCRsry5hqIeVgToFt6A3GpKguk
	 9uIYl3+VvXgYA2oZL1IAOB6+Ok4pZyUHPUg39aaHbt5jh8GAUpqNq0ttZcyq+QZZFM
	 hbeAU9+b+o/Xg==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67E2Ld4qA879013
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 14 Aug 2026 10:21:39 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 14 Aug 2026 10:21:39 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 14 Aug 2026 10:21:30 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Fri, 14 Aug 2026 10:21:30 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Adrodoc <adrodoc55@googlemail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: Error in rtw89 using Kernel 7.1.4
Thread-Topic: Error in rtw89 using Kernel 7.1.4
Thread-Index: AQHdHdZdU24pRS7N10KrgD20Ysr2qbaCFWPAgAAJV2CAAAS0AIAAjzyAgAD0dVCAAAXTgIAAAl0AgAn324CAAQ3XcP//9hYAgABhDACAB7IeQP//21yAgAGLWLCAA85ogIAA9vzw
Date: Fri, 14 Aug 2026 02:21:30 +0000
Message-ID: <ed3fe21f453744a3ac45484839c1c9f1@realtek.com>
References: <CAOQMLZVB3_wedJ89yNoCKTXOsuXWNq+T785bVQBSr3Yh-TPqeA@mail.gmail.com>
 <ea2f5ee46c064fb9b3a45e9d705e2f59@realtek.com>
 <1f8a2a023b064bca87a8f1e6712bca3d@realtek.com>
 <CAOQMLZWhvwxTk9PNa0E=73pBOoah8X-2C+xN5-VY_gCSVtBkVg@mail.gmail.com>
 <CAOQMLZWpPDbm5yiBg89GjzXnCwuQn+t5V=AP617MoH6q8Zu2zw@mail.gmail.com>
 <fe2f2e2a52ed4565b5c2927d872d82cc@realtek.com>
 <CAOQMLZU31dc6ZvNi_veM6uU1fSXYNBdnWLkOwH5xXR45uOFx1w@mail.gmail.com>
 <CAOQMLZWPMq=CCFpdg5wwsJ_QnrUKx_0YouTxdaSePO_0YPqcLA@mail.gmail.com>
 <CAOQMLZUn30NJwU4pR0hL=nz38Mbp=73wgqd+CoQE2qSO3cf4_w@mail.gmail.com>
 <013f7d3cf223417c94df41a2a45fa540@realtek.com>
 <CAOQMLZXiOBsjn=UEO6UryngzkfCzKdo+Xa1RmE_vTtZoFKN0Ew@mail.gmail.com>
 <CAOQMLZVMALBLeCZUB3Jdvk75znt0D7HxrXyPMhGPvcKLx3j-Yg@mail.gmail.com>
 <0912165f66394229b4f2b4114ae28a50@realtek.com>
 <CAOQMLZUbZhNhOQyxGXW7YSOU-z6w-4jWqfqVkaeMhdx2kLDrmg@mail.gmail.com>
 <c52840cf65464f659635eec6fcd6de12@realtek.com>
 <CAOQMLZU9fzaFNh+vbFR=ZpvkyG=T9UDwaeBVXpRj3fvYZt2D-g@mail.gmail.com>
In-Reply-To: <CAOQMLZU9fzaFNh+vbFR=ZpvkyG=T9UDwaeBVXpRj3fvYZt2D-g@mail.gmail.com>
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

DQpBZHJvZG9jIDxhZHJvZG9jNTVAZ29vZ2xlbWFpbC5jb20+IHdyb3RlOg0KPiBJIGhhdmUgYmVl
biBydW5uaW5nIGtlcm5lbCA3LjEuNS0xLWNhY2h5b3Mgd2l0aCAic3VkbyBpdyBkZXYgd2xhbjAg
c2V0DQo+IHBvd2VyX3NhdmUgb2ZmIiBmb3IgdGhlIGxhc3QgMyBkYXlzIChtb25kYXkgdG8gd2Vk
bmVzZGF5KS4NCj4gT24gbW9uZGF5IEkgaGFkIGEgdmVyeSBiYWQgZGlzY29ubmVjdCwgYnV0IHRo
ZXJlIHdhcyBhYnNvbHV0ZWx5DQo+IG5vdGhpbmcgdG8gYmUgc2VlbiBpbiBkbWVzZyBvciBqb3Vy
bmFsY3RsLCBzbyB0aGF0IHdhcyBwcm9iYWJseSBzb21lDQo+IHJvdXRlciBvciBwcm92aWRlciBp
c3N1ZS4NCj4gT3RoZXIgdGhhbiB0aGF0IEkgaGFkIG5vIGRpc2Nvbm5lY3QgaXNzdWVzIGR1cmlu
ZyB0aGF0IHRpbWUgYWxzbyB0aGUNCj4gU0VSIEwxIGRpZCBub3Qgb2NjdXIgYSBzaW5nbGUgdGlt
ZSBpbiB0aG9zZSAzIGRheXMuDQo+IFNvIG5vdyBJIGFtIHByZXR0eSBzdXJlIHRoYXQgdGhlIGRp
c2Nvbm5lY3RzIGFuZCBTRVIgTDEgd2VyZSBkdWUgdG8gcG93ZXJfc2F2ZS4NCj4gVGhpcyBtYWtl
cyBzZW5zZSB0byBtZSBnaXZlbiB0aGUgbWVzc2FnZSAiZmlybXdhcmUgZmFpbGVkIHRvIGFjayBm
b3INCj4gbGVhdmluZyBwcyBtb2RlIi4NCj4gVGhpcyBpcyB0aGUgc2FtZSBrZXJuZWwgd2hlcmUg
SSBwcmV2aW91c2x5IGhhZCBtdWx0aXBsZSBkaXNjb25uZWN0cyBwZXIgZGF5Lg0KPiANCj4gU28g
SSBndWVzcyB0aGUgbmV4dCBzdGVwIHdvdWxkIGJlIHRvIGlnbm9yZSBBU1BNIGFuZCBiaXNlY3Qg
a2VybmVscw0KPiBmb3IgImZpcm13YXJlIGZhaWxlZCB0byBhY2sgZm9yIGxlYXZpbmcgcHMgbW9k
ZSIsIHJpZ2h0Pw0KDQpJIHRoaW5rIHNvLg0KDQo+IElzIHRoZXJlIGFueXRoaW5nIEkgc2hvdWxk
IGtub3cgYWJvdXQgcG93ZXJfc2F2ZSBnb2luZyBmb3J3YXJkPw0KDQpSZS1lbmFibGUgcG93ZXIg
c2F2ZSAod2l0aG91dCBkb2luZyAic3VkbyBpdyBkZXYgd2xhbjAgc2V0IHBvd2VyX3NhdmUgb2Zm
IikNClRoZW4sIG9ubHkgc2V0IGRyaXZlciBkaXNhYmxlX3BzX21vZGU9eSBhbmQgY29sZCByZWJv
b3QuIA0KDQpJJ20gbm90IHN1cmUgaWYgeW91IGhhdmUgdHJpZWQgdGhpcywgaWYgeW91IGhhdmUg
ZG9uZSB0aGF0LCBJJ2Qgc2F5IHNvcnJ5DQppbiBhZHZhbmNlLiBSZWNlbnRseSBJIHJlY2VpdmVk
IHRvbyBtYW55IHJlcG9ydHMuLi4NCk1heWJlLCB5b3UgY2FuIHN1bW1hcml6ZSB0aGUgZXhwZXJp
bWVudHMgeW91IGhhdmUgZG9uZS4NCg0KDQo=
