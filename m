Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0488B1C5D59
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 05:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786340217; cv=none; b=PUc45EsmmMusGAnxuDP7YhRh6t+wjmUQJEQ+GzG6dpwRN3ytU1T3put6zaTvTxYs9En4WCPP+dP79qQFliduh9fL547DZ4hcNn5mpkJxQ0GP2G0iw5s83y0Hf2CU5K+YNJ1dDcaWXT7ykiTpxUbMEoqOO7jQ/wXqu0e5bh7o6Ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786340217; c=relaxed/simple;
	bh=gC6kLXgT6R5lD1f1wosx8dgMWM8pPNKkFHnXkt8OYPA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FO0gSkeqI9PWHTL+r9s81rGojQbGWm81J516CmGBWv76mf3T9c8IxCwMdIxKInrHoL8Vn3OhfCPcp6mA+LcSGAqKyd+/60pi0NGW1UVbplGkqZFnMlDaBco5xk53OlAW105pmNGm0cL3MaFvd2Sx/Zy0x//QqLdegOAHVDDBGKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=hGjQMY8n; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="hGjQMY8n"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67A5aoE631476432, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1786340210; bh=gC6kLXgT6R5lD1f1wosx8dgMWM8pPNKkFHnXkt8OYPA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=hGjQMY8nYFAkShxF9DJ1lA1T3AH658MzB89f+epYPAgxve7L5cbUAn7gdpQuf2Npa
	 g7GFLbh3/Vrm1Qa8Ih70r6U95jMcPd9h+zLP7T46dR6c6rBP9xG1G8jRRLg1R4ey1z
	 P5LV+VNO0FHlSZV8UHss8+1TULS7fNYBIweG8+Q9To1zS5ePS4gVtbmpgO1SbFuOxY
	 nxKRwVZIhptvOsv277HHzrrp0zlsdk/ZIIsj1tOuZg8lzwuhJEaxc7uiWLkcE4Twlu
	 abilH9HJTTNx7c3rtwUFKop4qm+Hx5qlmC3me7pFrtLjj3cKeCtiWc3rJ8+ZpoHP/2
	 aotQiSLsipPSA==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67A5aoE631476432
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 10 Aug 2026 13:36:50 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 10 Aug 2026 13:36:50 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 10 Aug 2026 13:36:50 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Mon, 10 Aug 2026 13:36:50 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Adrodoc <adrodoc55@googlemail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: Error in rtw89 using Kernel 7.1.4
Thread-Topic: Error in rtw89 using Kernel 7.1.4
Thread-Index: AQHdHdZdU24pRS7N10KrgD20Ysr2qbaCFWPAgAAJV2CAAAS0AIAAjzyAgAD0dVCAAAXTgIAAAl0AgAn324CAAQ3XcP//9hYAgABhDACAB7IeQA==
Date: Mon, 10 Aug 2026 05:36:49 +0000
Message-ID: <0912165f66394229b4f2b4114ae28a50@realtek.com>
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
In-Reply-To: <CAOQMLZVMALBLeCZUB3Jdvk75znt0D7HxrXyPMhGPvcKLx3j-Yg@mail.gmail.com>
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

QWRyb2RvYyA8YWRyb2RvYzU1QGdvb2dsZW1haWwuY29tPiB3cm90ZToNCj4gQ29udGludWluZyB0
byB1c2UgNi42LjktYXJjaDEtMSB3YXMgYSBnb29kIGlkZWEuIEkgZGlkIGdldCBhbiBlcnJvcg0K
PiB0b2RheTogaHR0cHM6Ly9naXRodWIuY29tL3VzZXItYXR0YWNobWVudHMvZmlsZXMvMzA3NDc4
NjIvMjAyNi0wOC0wNS4xNS41MS4xMi42LjYuOS1hcmNoMS0xLmxvZw0KDQpUaGlzIGlzIGFsc28g
YSBTRVIgTDEgIiBTRVIgY2F0Y2hlcyBlcnJvcjogMHgxMDAwIi4NCg0KPiBVbmxpa2UgZXJyb3Jz
IG9uIG90aGVyIGtlcm5lbCB2ZXJzaW9uIEkgZGlkbid0IG5vdGljZSB0aGUgZGlzY29ubmVjdA0K
PiBoZXJlLiBJIGp1c3Qgc2F3IHRoaXMgZXJyb3IgaW4gdGhlIGxvZyBieSBhY2NpZGVudCBhZnRl
cndhcmRzLiBJIHdhcw0KPiBpbiBhIHpvb20gY2FsbCBkdXJpbmcgdGhlIGVycm9yLCBzbyBJIHdv
dWxkIGhhdmUgZXhwZWN0ZWQgdG8gbm90aWNlDQo+IGFueSBkaXNjb25uZWN0cy4gTWF5YmUgdGhl
IHJlY292ZXJ5IGlzIG11Y2ggZmFzdGVyIGluIHRoaXMga2VybmVsDQo+IHZlcnNpb24/DQoNCkV2
ZW4gaXQgZG9lcyByZWNvdmVyeSB2ZXJ5IGZhc3QuIEkgZXhwZWN0IHlvdSBzdGlsbCBjYW4gc2Vl
IHRoZSBsb2cNCmlmIGNvbm5lY3Rpb24gaGFwcGVuZWQuIA0KDQo+IA0KPiBUaGUgb3V0cHV0IGxv
b2tzIHZlcnkgc2ltaWxhciwgc28gSSBiZWxpZXZlIHRoaXMgaXMgdGhlIHNhbWUgZXJyb3IsDQo+
IGJ1dCBJIGFtIG5vdCAxMDAlIHN1cmUuIEZvciBleGFtcGxlIHRoZSBtZXNzYWdlICJmaXJtd2Fy
ZSBmYWlsZWQgdG8NCj4gYWNrIGZvciBsZWF2aW5nIHBzIG1vZGUiIGlzIG5vdCBwcmVzZW50IGhl
cmUsIGJ1dCBtYXliZSB0aGF0IG1lc3NhZ2UNCj4gd2FzIGFkZGVkIHRvIHRoZSBkcml2ZXIgY29k
ZSBsYXRlci4NCj4gDQo+IEFsc28gaW50ZXJlc3Rpbmc6IHRoZXJlIHdhcyBubyBtZXNzYWdlIGxp
a2UgIndsYW4wOiBkaXNhc3NvY2lhdGVkIiBvcg0KPiAid2xhbjA6IGF1dGhlbnRpY2F0ZSIgYWZ0
ZXIgdGhlIGVycm9yLiBNYXliZSB0aGVyZSB3YXMganVzdCBubw0KPiBkaXNjb25uZWN0IGRlc3Bp
dGUgdGhlIGVycm9yLCB3aGljaCB3b3VsZCBleHBsYWluIHdoeSBJIGRpZCBub3Qgbm90aWNlDQo+
IGEgcHJvYmxlbSB1bnRpbCBJIHJhbmRvbWx5IGxvb2tlZCBhdCB0aGUgbG9nLg0KDQpJJ2Qgc3Vt
bWFyaXplIHRoZSBjYXNlcyB5b3UgbWV0Og0KDQoxLiBTRVIgTDENCiAgIEl0IGlzIGp1c3QgYSBu
b3RpZmljYXRpb24gZnJvbSBmaXJtd2FyZSB0byBkcml2ZXIsIHNvIHdlJ2QgaWdub3JlIHRoaXMu
DQoNCjIuICJmaXJtd2FyZSBmYWlsZWQgdG8gYWNrIGZvciBsZWF2aW5nIHBzIG1vZGUiDQogICBQ
bGVhc2UgdHJ5IHRvIGRpc2FibGUgcG93ZXIgc2F2ZSBwYXJhbWV0ZXJzIG1lbnRpb25lZCBieSBw
cmV2aW91cyBtYWlsLg0KDQozLiBkaXNjb25uZWN0aW9uDQogICBJIHRoaW5rIHRoaXMgaXMgbWFq
b3IgcHJvYmxlbSB5b3Ugd2FudCB0byBmaXguIElmIHNvLCBiaXNlY3Qga2VybmVsDQogICB0byBh
ZGRyZXNzIHRoaXMuDQoNCiAgIEJ5IHRoZSB3YXksIHRoZSBmaXJzdCBsb2cgeW91IHNoYXJlZCBz
aG93cyB0aGF0IGRpc2Nvbm5lY3Rpb24gaGFwcGVuZWQNCiAgIGFmdGVyIFNFUiBMMSBhYm91dCA1
MCBzZWNvbmRzLiBTRVIgTDEgc2VlbXMgbm90IGEgcmVsYXRlZCBldmVudC4NCiAgIE1vcmUsIHRo
ZSBkaXNjb25uZWN0aW9uIG1pZ2h0IGRlcGVuZCBvbiBBUCB5b3UgYXJlIGNvbm5lY3RpbmcsIHNv
IA0KICAga2VlcCB0aGUgZXhwZXJpbWVudHMgaW4gdGhlIHNhbWUgZW52aXJvbm1lbnRzIGlmIHBv
c3NpYmxlLg0KDQpQaW5nLUtlDQoNCg==
