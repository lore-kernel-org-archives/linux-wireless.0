Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E4033CEA5;
	Thu, 16 Jul 2026 09:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784193788; cv=none; b=W6qoZ+PH5CuZOp9ue9eWiRf5b4xTtf3zN+pAJDiq9JHHTrykIr1xFynirtHROSHeU363E8bQ1oFVU42lmktprG0xuixG6/udqK2EdV2GXVgljkQXMZsdPShdMwOqz4a2BGFHPZaGakBiavPCGbiRYgNajC6jywpac7dPl26P03c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784193788; c=relaxed/simple;
	bh=oWR/+zaRnb0CksvjCoRnlIkdqqWHcmWebf50cRymkmw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kxi5E830ZLZvtDVtoG6bEvSCondYNE4/1UriEDnpx53bNi8GuErJGYaqW1fF5sUymiMEss0qtMEM+/tNsE7rMKmKUSUh6zkX8SnXLLtk/gKmbvVk8x1qjo0xTZhDrcR0UblToWHbuwp3XkO2VawSrwVteYWQsv4KItPqIG6W2Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=RxHhN5Lu; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="RxHhN5Lu"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66G9MIdvC3536744, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784193738; bh=oWR/+zaRnb0CksvjCoRnlIkdqqWHcmWebf50cRymkmw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=RxHhN5Lu3I1LU0f6JBkimisE+FmdRFhb3cXIRcmmU7r4yYjhjJb8Vv9+PtuZrZxde
	 PinFV0xHX+Bxp3dgiIdr6xpI0YuPOUc5zgoQGLgXp8kZns6CYOQVRkiVDXtCiNQ/zf
	 UckzKBl/7rjpthevb9o/Gdc5rUmcA+kntCA1JbvaOin0Zhp5MyA9030V8wpX0XqUC3
	 OOquG0hZ4AZ+X6df7pyWtsuL3m+k7rEQA4VBFwGPZFBZ3NVjro4qt8O5A8ElhnXS8f
	 UKYAnWrQoz1R/HNYRow48MX3Z9+2HGS4S/75VdkPG+ly0CQCWj1JDiA/JKh5gv/awT
	 AbXTyzenX9F1g==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66G9MIdvC3536744
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 16 Jul 2026 17:22:18 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 16 Jul 2026 17:22:17 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::e6fd:5a3f:8946:92c4%10]) with mapi id
 15.02.2562.017; Thu, 16 Jul 2026 17:22:17 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>, Bjorn Helgaas
	<bhelgaas@google.com>, Yixun Lan <dlan@kernel.org>, Lorenzo Pieralisi
	<lpieralisi@kernel.org>, =?utf-8?B?S3J6eXN6dG9mIFdpbGN6ecWEc2tp?=
	<kwilczynski@kernel.org>, Manivannan Sadhasivam <mani@kernel.org>, "Rob
 Herring" <robh@kernel.org>, Inochi Amaoto <inochiama@gmail.com>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
	"spacemit@lists.linux.dev" <spacemit@lists.linux.dev>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH 2/2] wifi: rtw89: pci: enable 36-bit DMA on spacemit K3
Thread-Topic: [PATCH 2/2] wifi: rtw89: pci: enable 36-bit DMA on spacemit K3
Thread-Index: AQHdFNJRP59ehs1nXEC4sFhzEXMQ0LZv3oqg
Date: Thu, 16 Jul 2026 09:22:17 +0000
Message-ID: <e7a43955e41c4dbdb864e89edc3d9fe6@realtek.com>
References: <20260715-rtw89-spacemit-k3-v1-0-e577bc63706b@oss.tenstorrent.com>
 <20260715-rtw89-spacemit-k3-v1-2-e577bc63706b@oss.tenstorrent.com>
In-Reply-To: <20260715-rtw89-spacemit-k3-v1-2-e577bc63706b@oss.tenstorrent.com>
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

QW5pcnVkaCBTcmluaXZhc2FuIDxhc3Jpbml2YXNhbkBvc3MudGVuc3RvcnJlbnQuY29tPiB3cm90
ZToNCj4gVGhlIFNwYWNlbWl0IEszIFBpY28gSVRYIEJvYXJkIGhhcyBhIFJUTDg4NTJCRSBwY2ll
IGNhcmQgYmVoaW5kIGEgUENJZQ0KPiByb290IHBvcnQsIGJ1dCB0aGUgU29DIGRvZXNuJ3QgaGF2
ZSBhbnkgMzIgRE1BIGFkZHJlc2VzZXMgd2hpY2ggdGhlDQo+IHJ0dzg5IHNlZW1zIHRvIHVzZSBi
eSBkZWZhdWx0LiBFbmFibGUgMzYgYml0IERNQSBhYmlsaXR5IHRoYXQgdGhlIGRyaXZlcg0KPiBo
YXMgd2hlbiB0aGlzIHBhcnRpY3VsYXIgcm9vdCBwb3J0IGlzIGRldGVjdGVkIHNvIHRoYXQgdGhl
IGRyaXZlciBjYW4NCj4gcHJvYmUgb24gdGhpcyBTb0MuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBB
bmlydWRoIFNyaW5pdmFzYW4gPGFzcmluaXZhc2FuQG9zcy50ZW5zdG9ycmVudC5jb20+DQoNClRo
aXMgcGF0Y2ggbG9va3MgZ29vZCB0byBtZToNCg0KQWNrZWQtYnk6IFBpbmctS2UgU2hpaCA8cGtz
aGloQHJlYWx0ZWsuY29tPg0KDQpCdXQgSSB3b25kZXIgaG93IHRoaXMgcGF0Y2hzZXQgZ29lcyB2
aWEgd2hpY2ggdHJlZS4gSSdtIGhhcHB5IHRvIG1lcmdlDQp0aGVtIGludG8gcnR3IHRyZWUgYW5k
IHRoZW4gd2lyZWxlc3MtbmV4dCB0cmVlIGlmIHBlb3BsZSBjYW4gYWNrDQpwYXRjaCAxLzIuDQoN
Cg0K
