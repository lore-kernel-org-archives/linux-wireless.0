Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.3
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792747076;
	b=q0SL4McMSz7PR8tFhQTLbN7FYE6e/TPXT53Nx2vyy2E5VRoCvf8t9BsUIk215LPnN1NZ
	 oetTQsay6XOC/a89yS95tCEWIG43PJRg1KvdgwapAAOMpWfjQPE/m5+xweq+Yk9Z/E9Sh
	 xHqRYiTqkYdS3yNvonOYpchSRy0WAweQKW6cl9u5VehY9ldoYi90DL1NsyfqvTeiZxdJV
	 NviOExDyNYeNRRxzxzSuc7pFezul7wl94Jra230UHvfkbyUtUtU/TAfOj9ki6v9d+6W7j
	 E5VZQCawfF8mRHyO3yErAA71TDpgCdE9R7xiAqh1qFv5fniAo77FSefZpK7kqJL581w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792747076;
	h=DMARC-Filter:DKIM-Signature:Date:From:To:Cc:Subject:X-Priority:
	 X-Mailer:In-Reply-To:References:X-NTES-SC:Content-Transfer-Encoding:
	 Content-Type:MIME-Version:Message-ID:X-Coremail-Locale:X-CM-TRANSID:
	 X-CM-SenderInfo:X-Coremail-Antispam;
	bh=XGfLENNooPzAeNtm0T33ShCUIPvqc0XdxS3hZepn6W4=;
	b=YZXVvAS6zRqNELpLuqoZ6H96SvkWew8fvplO0FO47tUae/7xomsNKpqdytKnudwtZ50g
	 ObrqBj/kqjVMDBcT6n//1eNU4Yk1kal5XwYFboPUdfqXFDBr0FUD7kJwFNJk5cIxhflYy
	 mKGedIRcQUxxOkmf7hcP5qX0nr5NxrQ+1YhoJBjFIMEJ7hu4TNhvaPwDPghhyiWKvv4Tb
	 1QoGWtQMhxPUxy5bldX1OUT2Tlysgmn1/E4PXaLck4SXFRDXIT0Z393oa3q1HSNMIqgwG
	 YHkNgtGY4jPdgcxsjiCvbq6flUaXYQMcSbV/PxtBdUL+DouVeG8eVYS1RxrXz2ab0gQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=G3cyFj0t;
	arc=none smtp.remote-ip=117.135.210.3
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDEE7606A31F;
	Fri, 23 Oct 2026 09:17:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EDEE7606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=G3cyFj0t
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Subject:Content-Type:MIME-Version:
	Message-ID; bh=XGfLENNooPzAeNtm0T33ShCUIPvqc0XdxS3hZepn6W4=; b=G
	3cyFj0tPc+iMbXGv6JK6l0/UoTCLmSmKsejmKIzPhr5dHdtWngfLbaZTOY2Tv5J+
	Q2jQyvaXxhL3qVwsgmuxUaGdz2O5P2yRxwzC3C/dVNqaq5EagcacZpwk96UsLvYz
	bgImFHXXrlT08Y20IkB5Ak64gve5Bn7n6ElDnlxKRo=
Date: Fri, 23 Oct 2026 17:17:12 +0800 (CST)
From: "jiale yao" <19888972804@163.com>
To: "Felix Fietkau" <nbd@nbd.name>
Cc: "Lorenzo Bianconi" <lorenzo@kernel.org>,
	"Ryder Lee" <ryder.lee@mediatek.com>,
	"Shayne Chen" <shayne.chen@mediatek.com>,
	"Sean Wang" <sean.wang@mediatek.com>,
	"Matthias Brugger" <matthias.bgg@gmail.com>,
	"AngeloGioacchino Del Regno" <angelogioacchino.delregno@collabora.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re:Re: [PATCH] wifi: mt76: mt7996: stop radios after add failure
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.4-cmXT build
 20260511(2e539873) Copyright (c) 2002-2026 www.mailtech.cn 163com
In-Reply-To: <7aeeaf3b-7a06-4e06-b5d1-94b97fd081ae@nbd.name>
References: <20261019013146.1488644-1-yaojiale02@163.com>
 <7aeeaf3b-7a06-4e06-b5d1-94b97fd081ae@nbd.name>
X-NTES-SC: AL_Qu2SAPufuEgo5CORZekcn08ShO49XMOyvfoi2YFTc8wEpyXixB0NU1p7LEDowtydLAKTmQelYAN08clCeqVbv4yZX5T9ZHrotfu9GHoqlQ==
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-ID: <12f79a9f.8251.1a1680ccf4d.Coremail.19888972804@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:figvCgD3_2cYJttqJmpfAA--.6100W
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC8BghW2rbJhgJ1AAA3A
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==

SGkgRmVsaXgsCgpBdCAyMDI2LTEwLTIwIDE3OjU4OjA4LCAiRmVsaXggRmlldGthdSIgPG5iZEBu
YmQubmFtZT4gd3JvdGU6Cj5PbiAxOS4xMC4yNiAwMzozMSwgSmlhbGUgWWFvIHdyb3RlOgo+PiBB
IG11bHRpLXJhZGlvIGludGVyZmFjZSBjYW4gc3RhcnQgb25lIHJhZGlvIGJlZm9yZSBzdGFydGlu
ZyBhIGxhdGVyCj4+IHJhZGlvIGZhaWxzLiBhZGRfaW50ZXJmYWNlIHJldHVybnMgd2l0aG91dCBz
dG9wcGluZyB0aGUgcmFkaW9zIHN0YXJ0ZWQKPj4gYnkgdGhhdCBmYWlsZWQgcmVxdWVzdC4gbXQ3
OTk2X3J1biBjYW4gYWxzbyBsZWF2ZSBmaXJtd2FyZSByYWRpbyBzdGF0ZQo+PiBlbmFibGVkIHdo
ZW4gc2V0dXAgZmFpbHMgYWZ0ZXIgcmFkaW8gZW5hYmxlbWVudC4KPj4gCj4+IERpc2FibGUgYSBy
YWRpbyB3aGVuIG10Nzk5Nl9ydW4gZmFpbHMgYW5kIHRyYWNrIHJhZGlvcyBuZXdseSBzdGFydGVk
IGJ5Cj4+IGFkZF9pbnRlcmZhY2Ugc28gdGhleSBhbmQgdGhlaXIgbW9uaXRvciBzdGF0ZSBhcmUg
cm9sbGVkIGJhY2sgb24gYSBsYXRlcgo+PiBmYWlsdXJlLgo+PiAKPj4gRml4ZXM6IDY5ZDU0Y2U3
NDkxZCAoIndpZmk6IG10NzY6IG10Nzk5Njogc3dpdGNoIHRvIHNpbmdsZSBtdWx0aS1yYWRpbyB3
aXBoeSIpCj4+IFNpZ25lZC1vZmYtYnk6IEppYWxlIFlhbyA8eWFvamlhbGUwMkAxNjMuY29tPgo+
VGhpcyBkb2VzIG5vdCBhcHBseSBwcm9wZXJseS4gUGxlYXNlIHJlYmFzZSBhbmQgcmVzZW5kLgoK
SG93IGFib3V0IHRoaXMgb25lLCBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvMjAyNjEwMjMw
OTE0MTAuNjI3MTc1LTEteWFvamlhbGUwMkAxNjMuY29tLwoKPgo+VGhhbmtzLAo+Cj4tIEZlbGl4
CgoKSmlhbGU=
