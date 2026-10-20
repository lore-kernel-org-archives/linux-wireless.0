Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792463025;
	b=F616Ik3orBNzhm4UYjEnlJsqjzUfpIUoyeoD63Omfqt5JxZg8LvKXWTOiT+bz7jbSoQA
	 N0+PvEwf1qoFVjZPajVVwi2bXoFFWrhf6WsIMZ8IPRU7ouNNRat/MvxwF0iHPFn7c5LLh
	 NbL1Oa21QQri717Eq7LeKgDdPHNFcRLAKuDw0cj3idyPw+RDQDstKB6fxen/l2Qy9ejQV
	 TSwnh1SMxohXzlR4olzpnkpJpZW+9DqFmhY6Bqvou+ZN95+Ut6sAA2Rv/05X4LfueVJq+
	 GRPe5QEJPt5+pyAypekOfsutxNGXa/nSQ6JGTrbhujimqNhF1p7G+Qm+perk96PAYzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792463025;
	h=DMARC-Filter:DKIM-Signature:Date:From:To:Cc:Subject:X-Priority:
	 X-Mailer:In-Reply-To:References:X-NTES-SC:Content-Transfer-Encoding:
	 Content-Type:MIME-Version:Message-ID:X-Coremail-Locale:X-CM-TRANSID:
	 X-CM-SenderInfo:X-Coremail-Antispam;
	bh=3YSXATQnuiR/2Cds4ydGp0NOJ5A0pcMSXUyguAbgaEs=;
	b=mykOuoyMBEZVBDhEw7FMz+e/UwOWQevezpu5aeOIoAo44vZN0vLBHbRpXTcqEgOHjoEU
	 /gKaXVdrAgw3+CIq4VDUtjshubMQYVASOFJq66WEgU+dp+Z3TUmCxanshlmbs7V2hi6qm
	 n0vFNRVNEYXUITBvcagdYZSUQZq7LhmBRip/1JPik9GqExpKhsjhwrtkkGTk1nuXfDJk8
	 9iQwocI19oTBwnTrt2QQXSduPPOFwKMWkTh1vojEhOlDnUyzOVP6QC2COC0udoBiTdmfI
	 a4Qmj46OXCISr56YNEdBbZY3TBMr4q1oRHxVesG/iLkfd+eeNf/VPeNegmKsZDqb2AA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=qDgLWYLT;
	arc=none smtp.remote-ip=220.197.31.5
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C3E1606A319;
	Tue, 20 Oct 2026 02:23:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8C3E1606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=qDgLWYLT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Subject:Content-Type:MIME-Version:
	Message-ID; bh=3YSXATQnuiR/2Cds4ydGp0NOJ5A0pcMSXUyguAbgaEs=; b=q
	DgLWYLT8BeTxcAl5CN7IulgbTCBlFcWAWJaakMNbdy50Hyiq0LMlmmW2l14GqN1m
	7sBI8oq66ZFHWMP2a691JUS3NAJ7MgMevUD/depCGkM1fCIMDFxv8eLx+dlR0rAd
	rJxI4LD65J757iCpoq7N4Ury6ylx2RWO61wVOHlEDU=
Date: Tue, 20 Oct 2026 10:23:07 +0800 (CST)
From: "Jiale Yao" <yaojiale02@163.com>
To: "Felix Fietkau" <nbd@nbd.name>, "Lorenzo Bianconi" <lorenzo@kernel.org>,
	"Ryder Lee" <ryder.lee@mediatek.com>,
	"Shayne Chen" <shayne.chen@mediatek.com>,
	"Sean Wang" <sean.wang@mediatek.com>,
	"Matthias Brugger" <matthias.bgg@gmail.com>,
	"AngeloGioacchino Del Regno" <angelogioacchino.delregno@collabora.com>,
	"Peter Chiu" <chui-hao.chiu@mediatek.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Cc: "Jiale Yao" <yaojiale02@163.com>
Subject: [PATCH 10/10] wifi: mt76: mt7915: validate RF register response
 length
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.4-cmXT build
 20260511(2e539873) Copyright (c) 2002-2026 www.mailtech.cn 163com
In-Reply-To: <20261019101506.1926943-1-yaojiale02@163.com>
References: <20261019101506.1926943-1-yaojiale02@163.com>
X-NTES-SC: AL_Qu2SAPidvUEj4SeeYOkcn08ShO49XMOyvfoi2YFTc98FtwD2/gAgcWZ6I2D88/+uBy+FqSWSfhhg4+5wV5Ny/D1I43rTvc52AeP9fY9F2Q==
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
Message-ID: <192ec1cd.2297.1a1571ea203.Coremail.yaojiale02@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:hygvCgDXV7GM0NZqxzklAA--.655W
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbCzQyn4WrW0IzXqgAA3a
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==

VGhlIFJGIHJlZ2lzdGVyIHF1ZXJ5IHJlYWRzIGEgMzItYml0IHZhbHVlIGFmdGVyIGFuIGVpZ2h0
LWJ5dGUgcmVzcG9uc2UKcHJlZml4IHdpdGhvdXQgY2hlY2tpbmcgdGhlIHNrYiBsZW5ndGguIEEg
dHJ1bmNhdGVkIGZpcm13YXJlIHJlc3BvbnNlCmNhbiBjYXVzZSBhbiBvdXQtb2YtYm91bmRzIHJl
YWQuCgpSZXF1aXJlIHRoZSBwcmVmaXggYW5kIHJlZ2lzdGVyIHZhbHVlIGJlZm9yZSBhY2Nlc3Np
bmcgdGhlIHJlc3BvbnNlLgoKRml4ZXM6IDBhMTczMjlhZTljMSAoIm10NzY6IG10NzkxNTogYWRk
IGRlYnVnZnMga25vYiBmb3IgUkYgcmVnaXN0ZXJzIHJlYWQvd3JpdGUiKQpTaWduZWQtb2ZmLWJ5
OiBKaWFsZSBZYW8gPHlhb2ppYWxlXzIwMjZAcXEuY29tPgotLS0KIGRyaXZlcnMvbmV0L3dpcmVs
ZXNzL21lZGlhdGVrL210NzYvbXQ3OTE1L21jdS5jIHwgNCArKysrCiAxIGZpbGUgY2hhbmdlZCwg
NCBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWVkaWF0
ZWsvbXQ3Ni9tdDc5MTUvbWN1LmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9tZWRpYXRlay9tdDc2
L210NzkxNS9tY3UuYwppbmRleCA0YTExYTRhMGRiZGUuLjY1MGVlOTEzNGRkZiAxMDA2NDQKLS0t
IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWVkaWF0ZWsvbXQ3Ni9tdDc5MTUvbWN1LmMKKysrIGIv
ZHJpdmVycy9uZXQvd2lyZWxlc3MvbWVkaWF0ZWsvbXQ3Ni9tdDc5MTUvbWN1LmMKQEAgLTQyNTYs
NiArNDI1NiwxMCBAQCBpbnQgbXQ3OTE1X21jdV9yZl9yZWd2YWwoc3RydWN0IG10NzkxNV9kZXYg
KmRldiwgdTMyIHJlZ2lkeCwgdTMyICp2YWwsIGJvb2wgc2V0KQogCQkJCQkmcmVxLCBzaXplb2Yo
cmVxKSwgdHJ1ZSwgJnNrYik7CiAJaWYgKHJldCkKIAkJcmV0dXJuIHJldDsKKwlpZiAoc2tiLT5s
ZW4gPCA4ICsgc2l6ZW9mKF9fbGUzMikpIHsKKwkJZGV2X2tmcmVlX3NrYihza2IpOworCQlyZXR1
cm4gLUVJTlZBTDsKKwl9CiAKIAkqdmFsID0gbGUzMl90b19jcHUoKihfX2xlMzIgKikoc2tiLT5k
YXRhICsgOCkpOwogCWRldl9rZnJlZV9za2Ioc2tiKTsKLS0gCjIuMzQuMQ==
