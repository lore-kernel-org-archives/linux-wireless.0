Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793247635;
	b=VnLe+5N3vEwcjvzZDTZnoDcumTG2qAdUjaj4FtKfxFnSsxwkeIpyoaOYOf3Bh7YIobwf
	 BeIat9271IWgXbfMrIOAim6GXa/5u6Gkg+ZLI09/zB0p2D2fbk8GSy9TrLW83Jt+gAqP0
	 BWirVI7jybFG4Ge0rP+11fsn3/4BBx9kXQMxUNCkxRHpFUIVDIVil+hbWaR1OyeBzLovg
	 U540n846Jmof9S1gdfG+gr0czCsEpr4qsjpWT/PLMrhMlNQLcaurE3Zh2uf1Vmr2dOzkg
	 lTt18kW+hGlaNSszAlTIh6YZaL/pFK2Oh9L9Oby78Nw5QyKUXGNBetF4mtI4WlxmO6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793247635;
	h=DMARC-Filter:DKIM-Signature:Received:X-Originating-IP:Date:From:To:
	 Cc:Subject:X-Priority:X-Mailer:In-Reply-To:References:X-NTES-SC:
	 Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:
	 X-Coremail-Locale:X-CM-TRANSID:X-CM-SenderInfo:X-Coremail-Antispam;
	bh=dszobB3X2DrniL8erhzzfrWDq5pb/IBtHAO2jhrc3yU=;
	b=ye42PfVuAv3omW+6el2vpCDknCUIZhwvgXwO3cYlTumrb04ZHjRaWH/FP+AFJKmN28DK
	 hsAUNm8b1aI9W3rzIlWw/05dRHXGMZUoybqrizE8tD/BKUnUpUFO3ECaaJzEpOPmPtZRl
	 L7+q/sF/FgkEFeMDOWx5d5bmGZbSFkc2/GOpipPZdd4gy4c5ffUNnqnvj7pWAYwLCbjRw
	 igyPPDXHXAFwGmGTKmF0LpCW5tcW/3g/qCfbAEZMnfiGl1aw5LIGqFQP4zRLS9EoU7wjY
	 /Z7CXwAdsHMoE/srQIyVWJVUWFaBfEobWKMNVZAtMZLvNOBmV8X19Skr4+psZOQwzUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=HFAL8oBg;
	arc=none smtp.remote-ip=117.135.210.5
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25112606A31A
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 04:20:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 25112606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=HFAL8oBg
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Subject:Content-Type:MIME-Version:
	Message-ID; bh=dszobB3X2DrniL8erhzzfrWDq5pb/IBtHAO2jhrc3yU=; b=H
	FAL8oBgmwoNdNsmUEIoIzFvYhUo22vwkN2AWtBjPP8+YvnWdF5fwutQoRRVV0VZT
	4Kgu3d8dr9EVDzis9MM/9KJYyqXtYLPyUCgRscChJCPmWCNyeyIeeQh9h2que45o
	luOmz5WUHISLQ0t+G8/zcFQyPbzxacfnpA6XMyPt54=
Received: from 19888972804$163.com ( [2610:150:c001:15:81:7818:302a:b455] )
 by ajax-webmail-wmsvr-40-102 (Coremail) ; Thu, 29 Oct 2026 12:20:13 +0800
 (CST)
Date: Thu, 29 Oct 2026 12:20:13 +0800 (CST)
From: "jiale yao" <19888972804@163.com>
To: "Jeff Johnson" <jeff.johnson@oss.qualcomm.com>
Cc: "Jeff Johnson" <jjohnson@kernel.org>, linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org, ath12k@lists.infradead.org
Subject: Re:Re: [PATCH 0/5] wifi: ath11k/ath12k: validate capability TLV
 lengths
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.4-cmXT build
 20260511(2e539873) Copyright (c) 2002-2026 www.mailtech.cn 163com
In-Reply-To: <35ec209a-a62c-4fd9-aaba-edeed86dedf5@oss.qualcomm.com>
References: <20261028051254.147628-1-yaojiale02@163.com>
 <35ec209a-a62c-4fd9-aaba-edeed86dedf5@oss.qualcomm.com>
X-NTES-SC: AL_Qu2SAf6fuE4q5SSbY+kcn08ShO49XMOyvfoi2YFTc+0EoDzV3BInXF1gPGDxz8mkDT2vlyCFSTp15+JbY6xAC4wuYCmzPzzZjti2WuOfog==
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-ID: <551c02b7.3ba4.1a185e31205.Coremail.19888972804@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:ZigvCgD3P75+yeJq8SNjAA--.1075W
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC7x7kH2riyX73gQAA3D
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==

QXQgMjAyNi0xMC0yOSAwODoyODoxMCwgIkplZmYgSm9obnNvbiIgPGplZmYuam9obnNvbkBvc3Mu
cXVhbGNvbW0uY29tPiB3cm90ZToKPk9uIDEwLzI3LzIwMjYgMTA6MTIgUE0sIEppYWxlIFlhbyB3
cm90ZToKPj4gU2V2ZXJhbCBhdGgxMWsgYW5kIGF0aDEyayBXTUkgcGFyc2VycyBjb3VudCBmaXJt
d2FyZSBUTFZzIGFuZCBsYXRlcgo+PiBjb25zdW1lIHRoZW0gYXMgYXJyYXlzIG9mIGNvbXBsZXRl
IGNhcGFiaWxpdHkgc3RydWN0dXJlcy4gIFRoZSBnZW5lcmljCj4+IGl0ZXJhdG9yIHZhbGlkYXRl
cyB0aGF0IGEgVExWIGZpdHMgaW4gaXRzIGVuY2xvc2luZyBtZXNzYWdlLCBidXQgdGhlc2UKPj4g
dGFncyBoYXZlIG5vIG1pbmltdW0tbGVuZ3RoIHBvbGljaWVzLCBzbyBhIHNob3J0IGVsZW1lbnQg
Y2FuIHN0aWxsIGNhdXNlCj4+IGFuIG91dC1vZi1ib3VuZHMgc3RydWN0dXJlIHJlYWQuCj4+IAo+
PiBBZGQgcG9saWNpZXMgZm9yIHRoZSBETUEgYnVmZmVyIHJlbGVhc2UsIGhhcmR3YXJlIG1vZGUs
IERNQSByaW5nLCBhbmQKPj4gZXh0ZW5kZWQgTUFDL1BIWSBjYXBhYmlsaXR5IFRMVnMgdXNlZCBi
eSB0aGVzZSBwYXRocy4KPj4gCj4+IEppYWxlIFlhbyAoNSk6Cj4+ICAgd2lmaTogYXRoMTFrOiB2
YWxpZGF0ZSBETUEgYnVmZmVyIHJlbGVhc2UgVExWIGxlbmd0aHMKPj4gICB3aWZpOiBhdGgxMWs6
IHZhbGlkYXRlIGhhcmR3YXJlIG1vZGUgY2FwYWJpbGl0eSBUTFZzCj4+ICAgd2lmaTogYXRoMTFr
OiB2YWxpZGF0ZSBETUEgcmluZyBjYXBhYmlsaXR5IFRMVnMKPj4gICB3aWZpOiBhdGgxMms6IHZh
bGlkYXRlIERNQSBidWZmZXIgcmVsZWFzZSBmaXhlZCBUTFYgbGVuZ3RoCj4+ICAgd2lmaTogYXRo
MTJrOiB2YWxpZGF0ZSBzZXJ2aWNlLXJlYWR5IGNhcGFiaWxpdHkgVExWIGxlbmd0aHMKPj4gCj4+
ICBkcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoMTFrL3dtaS5jIHwgOCArKysrKysrKwo+PiAg
ZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDEyay93bWkuYyB8IDggKysrKysrKysKPj4gIDIg
ZmlsZXMgY2hhbmdlZCwgMTYgaW5zZXJ0aW9ucygrKQo+PiAKPgo+SSB3YXMgc3VycHJpc2VkIGJ5
IHRoZSBhc3ltbWV0cnkgYmV0d2VlbiBwYXRjaCAxICh3aGljaCBqdXN0IGFkZGVkIHZhbGlkYXRp
b24KPnRvIHRoZSBhcnJheSBlbnRyeSBUTFZzKSBhbmQgcGF0Y2ggNCAod2hpY2gganVzdCBhZGRl
ZCB2YWxpZGF0aW9uIHRvIHRoZSBmaXhlZAo+cGFyYW1zIFRMVikuIEFmdGVyIGEgc2Vzc2lvbiB3
aXRoIGFuIExMTSB3ZSBjYW1lIHRvIHRoZSBjb25jbHVzaW9uIHRoYXQgYm90aAo+YXJlIGluY29t
cGxldGU6Cj4KPlRoZSBETUEtYnVmLXJlbGVhc2UgZXZlbnQgaGFzIHR3byBpbmRlcGVuZGVudCBP
T0Igc2lua3MgaW4gZWFjaCBkcml2ZXIg4oCUIGEKPmZpeGVkLWhlYWRlciBjb3B5IGFuZCBhIGZp
eGVkLXN0cmlkZSBhcnJheSB3YWxrLiBCb3RoIGRyaXZlcnMgYXJlIGFmZmVjdGVkIGJ5Cj5ib3Ro
LiBUaGUgc2VyaWVzIGZpeGVzIG9ubHkgb25lIHNpbmsgcGVyIGRyaXZlciwgYW5kIGluIGEgY29t
cGxlbWVudGFyeQo+cGF0dGVybiB0aGF0IG1ha2VzIGVhY2ggZHJpdmVyIGxvb2sgImRvbmUiIGF0
IGEgZ2xhbmNlIGJ1dCBsZWF2ZXMgZWFjaCBvbmUKPmhhbGYtY292ZXJlZDoKPgo+LSBhdGgxMWs6
IHBhdGNoIDEgZ3VhcmRzIHRoZSBhcnJheSBlbGVtZW50cyAoX0VOVFJZLCBfTUVUQV9EQVRBKSDi
nIUgYnV0IHRoZQo+Zml4ZWQtaGVhZGVyIG1lbWNweSBhdCB3bWkuYzo0NjY5ICgxNiBieXRlcywg
dW5jb25kaXRpb25hbCwgZnJvbSBmaXJtd2FyZQo+cGF5bG9hZCkgaXMgc3RpbGwgdW5ndWFyZGVk
LiBOZWVkcyB0aGUgW1dNSV9UQUdfRE1BX0JVRl9SRUxFQVNFXSBwb2xpY3kuCj4tIGF0aDEyazog
cGF0Y2ggNCBndWFyZHMgdGhlIGZpeGVkIGhlYWRlciDinIUgYnV0IHRoZSBhcnJheSBzdHJpZGUg
cmVhZHMKPmV2LT5idWZfZW50cnlbaV0gLyBldi0+bWV0YV9kYXRhW2ldIGluIGRicmluZy5jIGFy
ZSBzdGlsbCB1bmd1YXJkZWQuIE5lZWRzIHRoZQo+W1dNSV9UQUdfRE1BX0JVRl9SRUxFQVNFX0VO
VFJZXSBhbmQgWy4uLl9TUEVDVFJBTF9NRVRBX0RBVEFdIHBvbGljaWVzLgo+Cj5BbmQgc2luY2Ug
eW91IGFyZSBwbGF5aW5nIGluIHRoaXMgYXJlYSwgbXkgTExNIHRoaW5rcyB0aGF0Cj5XTUlfVEFH
X0hBTF9SRUdfQ0FQQUJJTElUSUVTX0VYVCBoYXMgdGhpcyBpc3N1ZSBpbiBib3RoIGRyaXZlcnMs
IGFuZCB0aGlua3MKPnRoYXQgV01JX1RBR19SU1NJX1NUQVRTIG1heSBoYXZlIHRoaXMgaXNzdWUu
IEkgaGF2ZW4ndCB2ZXJpZmllZCB0aGF0IGFuYWx5c2lzLgoKQWdyZWUsIHRoZSB1cGRhdGVkIG9u
ZSBpcyBoZXJlLCBodHRwczovL2xvcmUua2VybmVsLm9yZy9sa21sLzIwMjYxMDI5MDQxODExLjIz
Nzk4NzgtMS15YW9qaWFsZTAyQDE2My5jb20vCj4KPi9qZWZmCg==
