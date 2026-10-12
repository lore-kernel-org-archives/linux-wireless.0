Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD002AD2E;
	Mon, 12 Oct 2026 01:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791767956; cv=none; b=j7OrnTTH8bHUMmRZscxNMlavLaOdWByFfUpTfT1aAH2JHMfrv6l2IW+4A/vZrb01xZsFHvxnBIwrTOJ8gcNfQTf2dd7lnmBdc4W/z6KpuAUxbeTZhPkejJ9Mex4HDUrt6t8wEqoaej9avb7jeGtjekx4Q55yBcywx+HGcXzj6AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791767956; c=relaxed/simple;
	bh=HJ0Qa2NAMSICrHhgodX7NirLyfIhHyVx1m1Gc/niJj4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qJ/dnFXioGwBb86HGWBaFMPantl4jJLWY77KZjJ48bdrdOdKhTFPl3AHdT0+xN1l7st0qTd1+yDM3e0AQ1QhLjDyc+zAeZkaTCAXecD32sE9MabHJYpdbzQ1kQJVlHLDhUcSvXmVfF1fAuOc1B8FdYDlSD/qqmJ/ZmQGyk0dqyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=SsJsU38n; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="SsJsU38n"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69C1IAM103415666, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791767891; bh=HJ0Qa2NAMSICrHhgodX7NirLyfIhHyVx1m1Gc/niJj4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=SsJsU38n1p1SyaKDqw+rb9qNfWRDVAM0A8M7HuQnNxL8CXaNf7zMlu6ggc2GkpANw
	 lbL4mNJppVlOM6f9dpQiDcY6zkdyHAV466vikZmLkLZ2tByCVnmrLxvh47Y2a2Modg
	 u6HpvewJ46yWscZoFOwsOReWtDWglxCp/vyaakLQXqKMvFdGbWFH8yMlb42CS+fd/1
	 2aboiRVhODZwKBSuEBwoIvspGz8yh3KokSHpCdK9N+MppaLYHbuv7oKbDEdgVDvQzz
	 7gkgVw1X5NbIIqmZjRjq6K9WvP96NQixVhNbSXb0+fpo3BEFB8hJ6M6ekOVRWiX22Q
	 tBOTS3T1LSJkQ==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69C1IAM103415666
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 12 Oct 2026 09:18:11 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 12 Oct 2026 09:18:18 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 12 Oct 2026 09:18:17 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Mon, 12 Oct 2026 09:18:17 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Luka Gejak <luka.gejak@linux.dev>, Hungyu Lin <dennylin0707@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"pchelkin@ispras.ru" <pchelkin@ispras.ru>, "mihaildimoski@gmail.com"
	<mihaildimoski@gmail.com>, "tristan@talencesecurity.com"
	<tristan@talencesecurity.com>, "rtl8821cerfe2@gmail.com"
	<rtl8821cerfe2@gmail.com>, "dawei.feng@seu.edu.cn" <dawei.feng@seu.edu.cn>,
	"learn.rahul.rai@gmail.com" <learn.rahul.rai@gmail.com>,
	"branislav.klocok@orava.sk" <branislav.klocok@orava.sk>, Timlee
	<timlee@realtek.com>, "kvalo@kernel.org" <kvalo@kernel.org>,
	"briannorris@chromium.org" <briannorris@chromium.org>, "yhchuang@realtek.com"
	<yhchuang@realtek.com>, "sgruszka@redhat.com" <sgruszka@redhat.com>
Subject: RE: [PATCH] wifi: rtw88: pci: preserve the RX ring DMA address on
 cleanup
Thread-Topic: [PATCH] wifi: rtw88: pci: preserve the RX ring DMA address on
 cleanup
Thread-Index: AQHdV52lr+WJ3Rjb30yJr3VeBPaew7b0k3MAgASMElA=
Date: Mon, 12 Oct 2026 01:18:17 +0000
Message-ID: <b7f24ac9f6714f91a40aa7c4952558a0@realtek.com>
References: <20261009032339.31786-1-dennylin0707@gmail.com>
 <DM0AA2YBXFI2.HD7B6PLDQ8FU@linux.dev>
In-Reply-To: <DM0AA2YBXFI2.HD7B6PLDQ8FU@linux.dev>
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

THVrYSBHZWphayA8bHVrYS5nZWpha0BsaW51eC5kZXY+IHdyb3RlOg0KPiBPbiBGcmkgT2N0IDks
IDIwMjYgYXQgNToyMyBBTSBDRVNULCBIdW5neXUgTGluIHdyb3RlOg0KPiA+IHJ0d19wY2lfaW5p
dF9yeF9yaW5nKCkgc3RvcmVzIHRoZSBjb2hlcmVudCByaW5nIERNQSBhZGRyZXNzIGluIGRtYSwg
YnV0DQo+ID4gcmV1c2VzIGl0IGZvciBSWCBidWZmZXIgRE1BIGFkZHJlc3NlcyBkdXJpbmcgZXJy
b3IgY2xlYW51cC4gSWYNCj4gPiBpbml0aWFsaXphdGlvbiBmYWlscyBhZnRlciBhdCBsZWFzdCBv
bmUgYnVmZmVyIGhhcyBiZWVuIG1hcHBlZCwNCj4gPiBkbWFfZnJlZV9jb2hlcmVudCgpIHJlY2Vp
dmVzIHRoZSBsYXN0IGJ1ZmZlcidzIERNQSBhZGRyZXNzIGluc3RlYWQgb2YNCj4gPiB0aGUgcmlu
ZydzLg0KPiA+DQo+ID4gVXNlIGEgc2VwYXJhdGUgdmFyaWFibGUgZm9yIHRoZSBidWZmZXIgRE1B
IGFkZHJlc3NlcyBzbyB0aGUgcmluZyBpcw0KPiA+IGZyZWVkIHdpdGggdGhlIGFkZHJlc3MgcmV0
dXJuZWQgYnkgZG1hX2FsbG9jX2NvaGVyZW50KCkuDQo+ID4NCj4gPiBGaXhlczogZTMwMzc0ODVj
NjhlICgicnR3ODg6IG5ldyBSZWFsdGVrIDgwMi4xMWFjIGRyaXZlciIpDQoNCkNjOiBzdGFibGVA
dmdlci5rZXJuZWwub3JnDQoNCj4gPiBTaWduZWQtb2ZmLWJ5OiBIdW5neXUgTGluIDxkZW5ueWxp
bjA3MDdAZ21haWwuY29tPg0KDQpBY2tlZC1ieTogUGluZy1LZSBTaGloIDxwa3NoaWhAcmVhbHRl
ay5jb20+DQoNCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4
OC9wY2kuYyB8IDYgKysrKy0tDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyks
IDIgZGVsZXRpb25zKC0pDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxl
c3MvcmVhbHRlay9ydHc4OC9wY2kuYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3
ODgvcGNpLmMNCj4gPiBpbmRleCA2NmQyZTVmNTE0NDQuLjEwMTQ3Mzc1ZjNiMiAxMDA2NDQNCj4g
PiAtLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg4L3BjaS5jDQo+ID4gKysr
IGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OC9wY2kuYw0KPiA+IEBAIC0yOTgs
MTEgKzI5OCwxMyBAQCBzdGF0aWMgaW50IHJ0d19wY2lfaW5pdF9yeF9yaW5nKHN0cnVjdCBydHdf
ZGV2ICpydHdkZXYsDQo+ID4NCj4gPiAgZXJyX291dDoNCj4gPiAgICAgICBmb3IgKGkgPSAwOyBp
IDwgYWxsb2NhdGVkOyBpKyspIHsNCj4gPiArICAgICAgICAgICAgIGRtYV9hZGRyX3QgYnVmX2Rt
YTsNCj4gPiArDQo+ID4gICAgICAgICAgICAgICBza2IgPSByeF9yaW5nLT5idWZbaV07DQo+ID4g
ICAgICAgICAgICAgICBpZiAoIXNrYikNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgY29udGlu
dWU7DQo+ID4gLSAgICAgICAgICAgICBkbWEgPSAqKChkbWFfYWRkcl90ICopc2tiLT5jYik7DQo+
ID4gLSAgICAgICAgICAgICBkbWFfdW5tYXBfc2luZ2xlKCZwZGV2LT5kZXYsIGRtYSwgYnVmX3N6
LCBETUFfRlJPTV9ERVZJQ0UpOw0KPiA+ICsgICAgICAgICAgICAgYnVmX2RtYSA9ICooKGRtYV9h
ZGRyX3QgKilza2ItPmNiKTsNCj4gPiArICAgICAgICAgICAgIGRtYV91bm1hcF9zaW5nbGUoJnBk
ZXYtPmRldiwgYnVmX2RtYSwgYnVmX3N6LCBETUFfRlJPTV9ERVZJQ0UpOw0KPiA+ICAgICAgICAg
ICAgICAgZGV2X2tmcmVlX3NrYl9hbnkoc2tiKTsNCj4gPiAgICAgICAgICAgICAgIHJ4X3Jpbmct
PmJ1ZltpXSA9IE5VTEw7DQo+ID4gICAgICAgfQ0KPiANCj4gVGhpcyBwYXRjaCBzaG91bGQgY2Mg
c3RhYmxlIHNvIGl0IGdldHMgYmFja3BvcnRlZC4gQmVzaWRlcyB0aGF0IGl0DQo+IGxvb2tzIGdv
b2QgdG8gbWUuIFBpbmctS2UgbWF5YmUgeW91IGNhbiBhZGQgQ2M6IHN0YWJsZUB2Z2VyLmtlcm5l
bC5vcmcNCj4gd2hlbiBhcHBseWluZyB0byB5b3VyIHRyZWU/DQoNClN1cmUuDQoNClBpbmctS2UN
Cg0K
