Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B0E36DA0D
	for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 01:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786499804; cv=none; b=tYb0db1o5E95/2kFyIm6m4znLjVG00Sn8voOYaflu5CfGGZLGfYC7Pq9LbqGcWcJtlg/faNz8z/VFQ9tSKbQB8liyWcVnB8fyKBHX/TJRS+Nuyu9Xr1F7pjXPQDN6tpg/9s8vp1Y5/Oc4cI+rsLhTcDyRFuCN2ulOCjBC7T5FUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786499804; c=relaxed/simple;
	bh=qBYzjjJugSeBoCbyvaO3j/2e/C7Byro3jeUk3Xx+45s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=q33zp8nhYxA6UP3zFRgORYdWaroMHTl7/wDBwefcIxc6HUzYIoPgqeWs+RWWjPzVtceP5Q09ydIh7VjA04HdzXDbivfESMckhBVyCx15IjH3G7/a+cYUlx1hJeVxtwOPFmt404oNRk3kIbiOQAjI4urXQGTWENHtQWo5NE1NvVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=LTK2p2ch; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="LTK2p2ch"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67C1uUBd93192612, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1786499790; bh=qBYzjjJugSeBoCbyvaO3j/2e/C7Byro3jeUk3Xx+45s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=LTK2p2chd1ZbqiVIUrBXfoFJOCzW3kolDPu/RlcHaR+6nETTbLW40k849iLE7IRMw
	 +GkzHbefdeccyGgG3BRO7qmxASHhgvHOKXa9zCjrER9mNGGmh4LUsRJrxvB+jDIfVO
	 jKS7u3nLCGvNmwuai9lVEwSF6UxgEMkg5Pq3mY37vEfMbtjJxpkRjwyXbLdEGUMwuT
	 gtcBKc6FHh6g9poF9OyrrD8dYv3Z2U2jmn3C1C1oco/h19khRKV9Qls0cutWTdguRT
	 triGwh21bBH4EmWsT8ptlwM5YyOjjxxHlzyl/YfhSJ+UtrH+3MXlsKdYTXxyR9jC0z
	 xaeuhleXC7pyQ==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67C1uUBd93192612
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 12 Aug 2026 09:56:30 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 12 Aug 2026 09:56:30 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 12 Aug 2026 09:56:29 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Wed, 12 Aug 2026 09:56:29 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Rohit Mahesh <rm4336@columbia.edu>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [BUG] wifi: rtw89: RTL8852BE firmware fails to leave LPS and
 recovery times out
Thread-Topic: [BUG] wifi: rtw89: RTL8852BE firmware fails to leave LPS and
 recovery times out
Thread-Index: AQHdIQR1qVVsOjTKCkerRIzw06kG9LaLltJAgA1dpwCAAL/KAA==
Date: Wed, 12 Aug 2026 01:56:28 +0000
Message-ID: <9fdbbbf57a1548e99a9955407c1cd082@realtek.com>
References: <CADTd5_O89StWx0O=PkxpQN3z+hUTHb2KkUd=AGOiyXZa=cdR=w@mail.gmail.com>
 <6a2bc2412ed74af7ae1f41154542a281@realtek.com>
 <CADTd5_M4=Pm+YChNAzTQr70XGVHs3zhSkpDyHxtgXL8R-xdbkA@mail.gmail.com>
In-Reply-To: <CADTd5_M4=Pm+YChNAzTQr70XGVHs3zhSkpDyHxtgXL8R-xdbkA@mail.gmail.com>
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

Um9oaXQgTWFoZXNoIDxybTQzMzZAY29sdW1iaWEuZWR1PiB3cm90ZToNCj4gT24gU3VuLCBBdWcg
MiwgMjAyNiwgUGluZy1LZSBTaGloIHdyb3RlOg0KPiA+IFRyeSB0byBzZXQgdGhlc2UgdG8gWSB0
byBzZWUgaWYgaGVscC4NCj4gDQo+IEhpIFBpbmctS2UsDQo+IA0KPiBBcG9sb2dpZXMgZm9yIHRo
ZSBkZWxheWVkIGZvbGxvdy11cC4gVGhpcyBpcyB0aGUgbGFwdG9wIEkgdXNlIGV2ZXJ5IGRheSwg
c28NCj4gSSB3YW50ZWQgdG8gbGVhdmUgdGhlIHdvcmthcm91bmQgaW4gcGxhY2UgbG9uZyBlbm91
Z2ggdG8gc2VlIHdoZXRoZXIgaXQNCj4gd2FzIGFjdHVhbGx5IHN0YWJsZS4NCj4gDQo+IEkgZmly
c3QgdHJpZWQ6DQo+IA0KPiAgIHJ0dzg5X2NvcmUuZGlzYWJsZV9wc19tb2RlPVkNCj4gDQo+IGJ1
dCB0aGUgV2ktRmkgZmFpbHVyZSByZWN1cnJlZC4gSXQgYWxzbyBjb250aW51ZWQgYWZ0ZXIgSSB3
ZW50IGJhY2sgdG8NCj4ga2VybmVsIDcuMC4zLWFydGl4MS0yLiBPbiBBdWd1c3QgMiwgaXQgaGFw
cGVuZWQgc2l4IHRpbWVzIGluIHJvdWdobHkgdHdvDQo+IGhvdXJzLCBzbyBJIGRvIG5vdCBjdXJy
ZW50bHkgaGF2ZSBhIGtub3duLWdvb2Qga2VybmVsIHZlcnNpb24gdG8gdXNlIGFzDQo+IGEgYmlz
ZWN0IGVuZHBvaW50Lg0KDQpJdCBsb29rcyBsaWtlIHJ0dzg5X2NvcmUuZGlzYWJsZV9wc19tb2Rl
PVkgaXNuJ3QgdGhlIGNhdXNlLg0KDQo+IA0KPiBEdXJpbmcgb25lIG9mIHRoZSBBdWd1c3QgMiBm
YWlsdXJlcywgSSBtb25pdG9yZWQgdGhlIExpbmsgU3RhdHVzIG9mIHRoZQ0KPiB1cHN0cmVhbSBB
TUQgUENJZSBicmlkZ2UgYXQgYXBwcm94aW1hdGVseSAyMCBtcyBpbnRlcnZhbHMuIEluIHRoYXQN
Cj4gY2FwdHVyZSwgdGhlIERhdGEgTGluayBMYXllciBMaW5rIEFjdGl2ZSBiaXQgY2hhbmdlZCBm
cm9tIDEgdG8gMC4gVGhlDQo+IHN1YnNlcXVlbnQgcnR3ODkgbWVzc2FnZXMgYmVnaW4gd2l0aDoN
Cj4gDQo+ICAgcnR3ODlfODg1MmJlIDAwMDA6MDI6MDAuMDogZmFpbGVkIHRvIHByZS1yZWxlYXNl
IGZ3Y21kDQo+ICAgcnR3ODlfODg1MmJlIDAwMDA6MDI6MDAuMDogcmVhZCByZiBidXN5IHN3c2kN
Cg0KSSdtIGd1ZXNzaW5nIHRoZSBQQ0kgYmVjb21lcyBpbmFjY2Vzc2libGUgYXQgdGhpcyBtb21l
bnQuDQpVc2UgJ3N1ZG8gbHNwY2kgLXMgMDAwMDowMjowMC4wIC14eHgnIHRvIHNlZSBpZiBhbGwg
dGhpbmdzIGFyZSAweEZGIG9yIDB4MDAuDQoNCj4gDQo+IEltbWVkaWF0ZWx5IGFmdGVyd2FyZCwg
bHNwY2kgcmVwb3J0ZWQgIlVua25vd24gaGVhZGVyIHR5cGUgN2YiIGZvciB0aGUNCj4gUlRMODg1
MkJFLCBhbmQgdGhlIHVwc3RyZWFtIHBvcnQgcmVwb3J0ZWQgRExBY3RpdmUtLiBJIGF0dGFjaGVk
IHRoYXQNCj4gY2FwdHVyZSBhcyBydHc4OS0yMDI2LTA4LTAyLXBjaWUtbGluay1sb3NzLnR4dC4N
Cj4gDQo+IEkgdGhlbiByZWJvb3RlZCB3aXRoIHRoZSBmb2xsb3dpbmcgUENJZS1yZWxhdGVkIHNl
dHRpbmdzOg0KPiANCj4gICBydHc4OV9wY2kuZGlzYWJsZV9hc3BtX2wxPVkNCj4gICBydHc4OV9w
Y2kuZGlzYWJsZV9hc3BtX2wxc3M9WQ0KPiAgIHJ0dzg5X3BjaS5kaXNhYmxlX2Nsa3JlcT1ZDQo+
ICAgcGNpZV9hc3BtPWZvcmNlDQoNCkknbSB0aGlua2luZyBpZiAncGNpZV9hc3BtPW9mZicgY2Fu
IGJlIG1vcmUgY29uc2VydmF0aXZlIChzdGFibGUpID8NCkJ1dCB5b3VyIGV4cGVyaW1lbnRzIGFy
ZSBwb3NpdGl2ZSwgc28gbm8gbmVlZCB0aGlzIGV4dHJhIGV4cGVyaW1lbnQuIA0KDQo+ICAgcGNp
ZV9hc3BtLnBvbGljeT1wZXJmb3JtYW5jZQ0KPiANCj4gcnR3ODlfY29yZS5kaXNhYmxlX3BzX21v
ZGUgcmVtYWluZWQgc2V0IHRvIFkuIEkgYWxzbyBkaXNhYmxlZCBydW50aW1lDQo+IHBvd2VyIG1h
bmFnZW1lbnQgYW5kIEQzY29sZCBmb3IgdGhlIFdpLUZpIGRldmljZSBhbmQgaXRzIEFNRCByb290
IHBvcnQuDQo+IA0KPiBXaXRoIHRoYXQgY29uZmlndXJhdGlvbiwgSSBoYXZlIG5vdyBnb25lIG5p
bmUgZGF5cyB3aXRob3V0IGFub3RoZXINCj4gb2NjdXJyZW5jZS4gQmVmb3JlIHRoZXNlIGNoYW5n
ZXMsIHRoZSBmYWlsdXJlIHNvbWV0aW1lcyBvY2N1cnJlZA0KPiBzZXZlcmFsIHRpbWVzIHdpdGhp
biBhbiBob3VyLg0KDQpHb29kIHRvIGhlYXIgdGhhdC4gDQoNCldpdGhvdXQgb3NjaWxsb3Njb3Bl
IG9yIENBVC1DLCB3ZSBjYW4ndCBkaWcgUENJIGJ1cyBMMS9MMVNTL0NMS1JFUQ0KaW50ZXJvcGVy
YWJpbGl0eSBpc3N1ZSBmdXJ0aGVyLiBUaGVyZWZvcmUsIEkgc3VnZ2VzdCB5b3UgYXBwbHkgdGhl
c2UNCnNldHRpbmdzLg0KDQo+IA0KPiBHaXZlbiB0aGUgQXVndXN0IDIgY2FwdHVyZSwgSSBzdXNw
ZWN0IHRoZSBMUFMgYW5kIFNFUiBmYWlsdXJlcyBtYXkgYmUgYQ0KPiBjb25zZXF1ZW5jZSBvZiB0
aGUgUENJZSBsaW5rIGJlY29taW5nIHVuYXZhaWxhYmxlIHJhdGhlciB0aGFuIHRoZQ0KPiBpbml0
aWFsIGZhaWx1cmUgaXRzZWxmLiBTaW5jZSBJIGNoYW5nZWQgc2V2ZXJhbCBQQ0llIHBvd2VyLW1h
bmFnZW1lbnQNCj4gc2V0dGluZ3MgdG9nZXRoZXIsIGhvd2V2ZXIsIEkgY2Fubm90IHNheSB3aGV0
aGVyIEwxLCBMMVNTLCBDTEtSRVEsIG9yDQo+IGFub3RoZXIgcGFydCBvZiB0aGUgY29uZmlndXJh
dGlvbiBpcyByZXNwb25zaWJsZS4NCj4gDQo+IEkgZGlkIG5vdCB0ZXN0IGVhY2ggc2V0dGluZyBp
bmRpdmlkdWFsbHkgYmVjYXVzZSBldmVyeSBvY2N1cnJlbmNlDQo+IGxlYXZlcyB0aGUgV2ktRmkg
dW51c2FibGUgdW50aWwgSSByZWJvb3QsIGFuZCB0aGlzIGlzIG15IGRhaWx5LXVzZQ0KPiBtYWNo
aW5lLg0KPiANCj4gPiBEaWQgaXQgb2NjdXIgcmlnaHQgYWZ0ZXIgc3lzdGVtIHJlc3VtZT8gQ2Fu
IHlvdSBzaGFyZSB0aGUgZnVsbCBsb2c/DQo+IA0KPiBOby4gVGhlIHR3byBvcmlnaW5hbCBmYWls
dXJlcyBvY2N1cnJlZCBkdXJpbmcgbm9ybWFsIHVzZSwgbm90DQo+IGltbWVkaWF0ZWx5IGFmdGVy
IHN5c3RlbSByZXN1bWUuDQoNCkF0IHN5c3RlbSByZXN1bWUsIGhvc3Qvd2lmaSBjYXJkIHJlc3Rh
cnQgUENJIHBvd2VyLW9uIHNlcXVlbmNlLCBhbmQNCnJldHJhaW4gUENJLiBNb3N0bHksIHByb2Js
ZW1zIGhhcHBlbiBhdCB0aGlzIG1vbWVudCwgc28gSSBhc2tlZCB5b3UNCnRoaXMgcXVlc3Rpb24u
IEZvcnR1bmF0ZWx5LCB5b3UgZGlkbid0IGVuY291bnRlciB0aGlzLiA6KQ0KDQo+IA0KPiBJIGF0
dGFjaGVkIHRoZSBwbGFpbi10ZXh0IGxvZ3MgZm9yIHRoZSBKdWx5IDMwIGFuZCBKdWx5IDMxDQo+
IGluY2lkZW50cywgYXMgd2VsbCBhcyB0aGUgQXVndXN0IDIgUENJZSBsaW5rLWxvc3MgY2FwdHVy
ZS4NCg0KVGhhbmtzIGZvciBhbGwgY2FwdHVyZXMsIHdoaWNoIGxvb2tzIGxpa2UgUENJIGJ1cyBn
ZXRzIGluYWNjZXNzaWJsZS4gDQpJZiB5b3Ugd2FudCB0byBnZXQgYmV0dGVyIHBvd2VyIGNvbnN1
bXB0aW9uLCBmaXJzdCBvbmUgeW91IGNhbiB0cnkgaXMNCnRvIHJlbW92ZQ0KDQogICBydHc4OV9j
b3JlLmRpc2FibGVfcHNfbW9kZT1ZDQoNClRoZSBvdGhlciBBUFNNIHNldHRpbmdzIGRvbid0IGFm
ZmVjdCB0b28gbXVjaCAoaW4gYXNwZWN0IG9mIFdpRmkgY2FyZCksDQpzbyB5b3UgY2FuIHRyeSB0
aGVtIGFmdGVyd2FyZC4gDQoNClBpbmctS2UNCg0K
