Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB1444C6D
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 04:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786334505; cv=none; b=GGJDpGjSnI4K8s26uJb4foBceUdaxGv+fWuZXT2NHwLT93O9FVRTHSX6FcbziTZsObg78dqnDGmtMfMnDXJlq53aSXNcLC44riJvYOuQxqznvwmQ0rPdROfRnKSuBEgHzZ3qZg8sBL2ZEZ3MNPyXVnX7EugLiK/t4G0yveFxnuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786334505; c=relaxed/simple;
	bh=tqDJTsn8PCO6tlFPoamscB2EQ1ebZ4gu0YeWfQ3cLwA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=niiGdQZ/yQ70gQnizTX3pKjdGkDU6fkPaVyynF1WVb5LF/1pKMAGRCQTqQdgi2C+sNCdEzdthZ5uC9cXB34G8dn4ksCK8WBKfgpADaw84gnrmHPVfaUn8Mjmf8zVpjxn1PvtvcFALh23aTleAUS8NDLZLCsa4nKnoHKBfvYwjl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=sOUv63hh; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="sOUv63hh"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67A41cfN61442475, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1786334498; bh=tqDJTsn8PCO6tlFPoamscB2EQ1ebZ4gu0YeWfQ3cLwA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=sOUv63hhmPG4N5erkUQG+5DmlYxUwXA5qCbm6TJ9pCMVmACwuY9kcTeYkXJjHZZAx
	 /8j/VHdWhZFbrqS8BRbcXRkWQnhhEbpn7iw5LYuKaByHiZjck4Ug8t8Ynnk/vJnNIR
	 ZVb8qIbP6/TQu375qtKv0PvW89Rs+ahPazfyYKvQGArWNKvA9D8XJ+dVDUyJcFPM//
	 fQBAZX0LqacFsslWmHLxyTVld9FiuhbF8V8wlfvAU3kG+KBaTExEYdq0LtKV9bxCYS
	 a6Jy9rq8DqLbatZt/mqXkaIyrUIqVDD7/edkdnKKPA+0CcvAtpWv6YjmXMcLH2hSva
	 snMuxqWEuRsXQ==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67A41cfN61442475
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 10 Aug 2026 12:01:38 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 10 Aug 2026 12:01:39 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 10 Aug 2026 12:01:37 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Mon, 10 Aug 2026 12:01:37 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Adrodoc <adrodoc55@googlemail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: Error in rtw89 using Kernel 7.1.4
Thread-Topic: Error in rtw89 using Kernel 7.1.4
Thread-Index: AQHdHdZdU24pRS7N10KrgD20Ysr2qbaCFWPAgAAJV2CAAAS0AIAAjzyAgAD0dVCAAAXTgIAAAl0AgAn324CAAQ3XcP//9hYAgAgQ4HA=
Date: Mon, 10 Aug 2026 04:01:36 +0000
Message-ID: <c6fa2c5e0b6740d7bfae3060573e6b33@realtek.com>
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
In-Reply-To: <CAOQMLZXiOBsjn=UEO6UryngzkfCzKdo+Xa1RmE_vTtZoFKN0Ew@mail.gmail.com>
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

DQpBZHJvZG9jIDxhZHJvZG9jNTVAZ29vZ2xlbWFpbC5jb20+IHdyb3RlOg0KPiBPaywgSSdsbCB0
cnkgNi42LjktYXJjaDEtMSBmb3IgbG9uZ2VyIHRvIHNlZSBpZiBJIGVuY291bnRlciB0aGUgU0VS
IGVycm9yLg0KPiANCj4gSSBkb24ndCBxdWl0ZSB1bmRlcnN0YW5kIHdoYXQgeW91IG1lYW4gd2l0
aDoNCj4gPiBUaGVyZWZvcmUsIGlmIHRoZSBpbmZyZXF1ZW50IFNFUiBkb2Vzbid0IGJvdGhlciB5
b3VyIGRhaWx5IHdvcmssIHRoZXkgc3VnZ2VzdCB0byBqdXN0IGtlZXAgaXQgYXMgd2FzLg0KPiAN
Cj4gRG8geW91IG1lYW4gSSBzaG91bGQga2VlcCB1c2luZyB0aGUgbmV3IGtlcm5lbHMgYW5kIGln
bm9yZSB0aGUgZXJyb3I/DQoNClllcywgYmVjYXVzZSBTRVIgTDEgKCJTRVIgY2F0Y2hlcyBlcnJv
cjogMHgxMDAwIikgbWVhbnMgZmlybXdhcmUgZGV0ZWN0DQphbmQgZml4IGFuIGVycm9yIGFscmVh
ZHksIGFuZCBub3RpZnkgZHJpdmVyIGl0IGRvZXMgKGRyaXZlciBubyBuZWVkIHRvDQpkbyBhbnl0
aGluZykuIFRoZXJlZm9yZSwgSSdkIHN1Z2dlc3QgdG8gaWdub3JlIHRoaXMgbWVzc2FnZSBpZiBp
dCBkb2Vzbid0DQpib3RoZXIgeW91ciBkYWlseSB1c2UuIA0KDQo+IFRoZSBkaXNjb25uZWN0cyBh
cmVuJ3QgdGhlIGVuZCBvZiB0aGUgd29ybGQsIGJ1dCB0aGV5IGFyZSBhbm5veWluZyBhbmQNCj4g
SSB3YXMgaG9waW5nIEkgY291bGQgaGVscCB5b3UgaW1wcm92ZSB0aGUgZHJpdmVyIHRvIGZpeCB0
aGUgcHJvYmxlbS4NCj4gU28gSSB3b3VsZCBsaWtlIHRvIGNvbnRpbnVlLCBub3QganVzdCBmb3Ig
bXlzZWxmLCBidXQgdG8gaGVscCBpbXByb3ZlDQo+IHRoaXMgZm9yIG90aGVycyB0b28uIEkgaGF2
ZSBhbiBvZmYgdGhlIHNoZWxmIHByZWJ1aWx0IFBDDQo+IChodHRwczovL3BzcmVmLmxlbm92by5j
b20vRGV0YWlsL0xlZ2lvbi9MZW5vdm9fTGVnaW9uX1Q1XzI2QU1SNT9NPTkwUkMwMFVVR0UpLA0K
PiBJIG9ubHkgYWRkZWQgYSBzZWNvbmQgU1NELCBzbyBJIGFtIHN1cmUgSSBhbSBub3QgdGhlIG9u
bHkgb25lIHdpdGgNCj4gdGhpcyBpc3N1ZS4NCg0KQnV0IGlmIHRoZSBkaXNjb25uZWN0aW9uIGlz
IGFubm95aW5nIHRvIHlvdSwgd2Ugc2hvdWxkIGNvbnRpbnVlIHRvIGRpZw0KdGhlIHByb2JsZW0u
DQoNCj4gDQo+ID4gd2UgY2FuIGJpc2VjdCB0aGUgY29tbWl0cyBpbiBkZXRhaWwuDQo+ID4gSSBu
ZWVkIHlvdXIgaGVscCB0byBidWlsZCBhbmQgdGVzdCBkcml2ZXIga28uDQo+ID4gVGhlIHNlY29u
ZCB3YXkgaXMgdG8gZGVidWcgb24gdGhlIGxhdGVzdCBrZXJuZWwgYW5kIGFwcGx5IGRlYnVnIHBh
dGNoIHRvIGR1bXAgbW9yZSBkZXRhaWwgbmVlZGVkIGJ5DQo+IGludGVybmFsIGV4cGVydHMuDQo+
IA0KPiBJIGhhdmUgbmV2ZXIgYnVpbHQgZHJpdmVycyBiZWZvcmUsIGFuZCBJIGRvbid0IGhhdmUg
YSBsb3Qgb2YNCj4gZXhwZXJpZW5jZSB3aXRoIEMsIGJ1dCBJIGFtIGEgZGV2ZWxvcGVyLCBzbyB3
ZSBjYW4gdHJ5IHRoYXQuIEkgYW0NCj4gcmVhZHkgdG8gdHJ5IGJvdGggb3B0aW9ucy4NCj4gDQo+
IFNvbWV0aGluZyBlbHNlIEkgd2FzIHdvbmRlcmluZzogSW4gdGhlIGVycm9yIGxvZ3MgSSBzZWUg
dGhpcyBtZXNzYWdlOg0KPiA+IGZpcm13YXJlIGZhaWxlZCB0byBhY2sgZm9yIGxlYXZpbmcgcHMg
bW9kZQ0KDQpUaGlzIGlzIGFub3RoZXIgcHJvYmxlbS4gSSdtIG5vdCBzdXJlIGlmIGl0IGlzIHJl
bGF0ZWQgdG8gU0VSIEwxIG1lbnRpb25lZA0KYWJvdmUuIA0KDQo+IA0KPiBJIGFtIGd1ZXNzaW5n
IHBzIG1vZGUgaXMgcG93ZXIgc2F2aW5nIG1vZGUsIHdoaWNoIGlzIHdlaXJkLCBiZWNhdXNlDQo+
IHRoZSBlcnJvciBoYXBwZW5zIGR1cmluZyB6b29tIGNhbGxzIGFuZCByZW1vdGUgZGVza3RvcCBz
ZXNzaW9ucywgd2hpY2gNCj4gdXNlIHRoZSBjb25uZWN0aW9uIGNvbnN0YW50bHkuIFNvIEkgd291
bGQgbm90IGV4cGVjdCB0aGUgV2lmaS1DYXJkIHRvDQo+IGdvIGludG8gcG93ZXIgc2F2ZSBtb2Rl
IGhlcmUuDQo+IEkgcmVhZCBvbiBodHRwczovL3dpa2kuYXJjaGxpbnV4Lm9yZy90aXRsZS9OZXR3
b3JrX2NvbmZpZ3VyYXRpb24vV2lyZWxlc3MNCj4gdGhhdCBpbiBxdWl0ZSBhIGZldyBjYXNlcyB0
aGV5IHN1Z2dlc3QgZGlzYWJsaW5nIHBvd2VyIHNhdmUuDQo+IEkgY2hlY2tlZCBhbmQgcG93ZXIg
c2F2ZSBzZWVtcyB0byBiZSBlbmFibGVkIG9uIG15IHN5c3RlbToNCj4gJCBpdyBkZXYgd2xhbjAg
Z2V0IHBvd2VyX3NhdmUNCj4gUG93ZXIgc2F2ZTogb24NCj4gDQo+IFNob3VsZCBJIHRyeSB0byBk
aXNhYmxlIGl0PyBXb3VsZCB0aGF0IGdpdmUgeW91IGFueSBuZXcgaW5mb3JtYXRpb24/DQoNClll
cywgaXQgaXMgd29ydGggdG8gdHJ5IGJ5IHNldHRpbmcNCml3IGRldiB3bGFuMCBzZXQgcG93ZXJf
c2F2ZSBvZmYNCg0KPiANCj4gVGhlIGFyY2ggd2lraSBhbHNvIGNvbnRhaW5zIGEgY2hhcHRlciBz
cGVjaWZpYyB0byBydHc4OToNCj4gaHR0cHM6Ly93aWtpLmFyY2hsaW51eC5vcmcvdGl0bGUvTmV0
d29ya19jb25maWd1cmF0aW9uL1dpcmVsZXNzI1JUVzg5DQo+IFRoZXkgc3VnZ2VzdCBkaXNhYmxp
bmcgQVNQTS1yZWxhdGVkIGZlYXR1cmVzIHVzaW5nIHRoZSBjb25maWcgYmVsb3cuDQo+IC9ldGMv
bW9kcHJvYmUuZC83MC1ydHc4OS5jb25mDQo+ICAgb3B0aW9ucyBydHc4OV9wY2kgZGlzYWJsZV9h
c3BtX2wxPXkgZGlzYWJsZV9hc3BtX2wxc3M9eQ0KPiAgIG9wdGlvbnMgcnR3ODlfY29yZSBkaXNh
YmxlX3BzX21vZGU9eQ0KDQpUaGVzZSBhcmUgYWxzbyB3b3J0aCB0byB0cnksIGJlY2F1c2UgdGhl
cmUgbWlnaHQgYmUgaW50ZXJvcGVyYWJpbGl0eSBpc3N1ZQ0Kb24gUENJIEFTUE0uIEFmdGVyIHNl
dHRpbmcgdGhpcywgZG8gY29sZCByZWJvb3QgdG8gdGFrZSBlZmZlY3QuIA0KDQo+IA0KPiBTZWUg
YWxzbzoNCj4gaHR0cHM6Ly9naXRodWIuY29tL2x3ZmluZ2VyL3J0dzg5I29wdGlvbi1jb25maWd1
cmF0aW9uDQo+IGh0dHBzOi8vZ2l0aHViLmNvbS9sd2Zpbmdlci9ydHc4OS9pc3N1ZXMvMjc1I2lz
c3VlY29tbWVudC0xNzg0MTU1NDQ5DQo+IA0KPiBIb3dldmVyIHRoaXMgc291bmRzIGxpa2UgaXQg
YWZmZWN0cyBub3RlYm9va3MsIHdoZXJlYXMgSSBoYXZlIGEgZGVza3RvcCBQQy4NCj4gDQo+IFNo
b3VsZCBJIHRyeSB0aGlzPyBXb3VsZCB0aGF0IGdpdmUgeW91IGFueSBuZXcgaW5mb3JtYXRpb24/
DQoNClRyeWluZyBwb3dlciBzYXZpbmcgcGFyYW1ldGVycyB3aWxsIGhlbHAgdG8gdGhlIG1lc3Nh
Z2UNCidmaXJtd2FyZSBmYWlsZWQgdG8gYWNrIGZvciBsZWF2aW5nIHBzIG1vZGUnIGF0IGxlYXN0
Lg0KDQpQaW5nLUtlDQoNCg0K
