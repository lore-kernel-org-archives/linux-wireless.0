Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792554345;
	b=Zv5KXQ3o+WeXlmXImyiH2ZtjBH8KaAGW6aicYs0vzhUjbbwrxQuhtFvXhpFznS6FlR2B
	 srWho718O6m6cOHClJOVVSkYkbB2HIB5xQN9tBKgIA78dnpPaupgE1LdjgPDzPVUgGw2r
	 II2rz/R8VJgwSmtIk6bEz/8eKOYk1SmESTs+ApJfRS54X+X/4LjsqSIT+tG8YUSQZuL+q
	 eDoFEXnPWJfF7RK22OEZRt/jSpCTZ5Xfq8jxRupWKkBiAORjYXKtJeBWt9wvr5DSsghlN
	 3XWoktDLvEfoVYv7rdISi0oewg2SvADpcBMob5cPnvRHFfZQIUjmLoO26f86JSq7jOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792554345;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:Received:From:To:CC:Subject:Thread-Topic:Thread-Index:Date:
	 Message-ID:References:In-Reply-To:Accept-Language:Content-Language:
	 x-originating-ip:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=tIUtAfNwNbbYO4XAZ7ukFExTcu16gSqky0dHXxOwabA=;
	b=QFYCcTaq6Eu5NmqbwJSsfVIapHlMdcENG5+MG8sqn3VkE4Cp4BCAmixaQeZeHUFjrXHY
	 PMnI9IpuvEIJ/lmLbtNpjSFRYAQ2VV7Ia6Q0706xnSedDDPDZkeH0ZpgeEOblRawoewiG
	 FgBJzwtWv1hCROGsDLGAZrpdAHOioLTRpMpWSbxxSP58k+x6C+/7cDhux849z9zD9UIfp
	 LTM4XwiJc3ukQeOYC+XWhSZFrn6JtqYU+VFTIeroAeGFjV4RADCPQDW7Cn5u2D3XiwzCe
	 QeEO3np2/NSsuA1xP44vLKyNbYkhG+GeNopaDCNullvjvCphPtnnnFAIcDHmczGziog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=hBGXa8kF;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96612606A31A
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 03:45:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 96612606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=hBGXa8kF
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69L3jVXZ13669694, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1792554331; bh=tIUtAfNwNbbYO4XAZ7ukFExTcu16gSqky0dHXxOwabA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=hBGXa8kFw5j3BY+TTvr+vs/bWb5mvdnvjPx4SRnkigcCIdt89osW5DT+K0C2qfaz7
	 /EoCL1QL/tOAFvJQWwmUmneIfDm2bKwokQE2CBWGeL3QHtf2ya741j3d0kdec23JkK
	 ZMEYZ+gnkVO05TpXVpuBh9HRMfYlURUp7jBMuGzLb+3TurU0Ffi8FXDfmGydIBJm7D
	 /tcwiMyx6Sam70ruK38UjpYTNs0WLO9DHxi608mUxQUA3yjRluShUvjsvHX0d6mJmW
	 nwD8pYDDXhUkJo4UiKAertjVnzyY7/OqzeLq043NqoyF4ELIgXFHcW24yidDdB8oPO
	 3Et/v3l7Kv03g==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69L3jVXZ13669694
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 21 Oct 2026 11:45:31 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 21 Oct 2026 11:45:29 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 21 Oct 2026 11:45:29 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Wed, 21 Oct 2026 11:45:29 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Luka Gejak <luka.gejak@linux.dev>
Subject: RE: [PATCH rtw-next v2 3/3] wifi: rtw88: 8723b: Read the chip variant
 from efuse
Thread-Topic: [PATCH rtw-next v2 3/3] wifi: rtw88: 8723b: Read the chip
 variant from efuse
Thread-Index: AQHdYNUQYSMLB9Tx+UCXPiJM4dpZHbcHW3Wg
Date: Wed, 21 Oct 2026 03:45:29 +0000
Message-ID: <133799f1099f401882c7964932742444@realtek.com>
References: <8e47daa4-538d-4e0a-84f9-fd4e91613ff8@gmail.com>
 <a551ce83-278b-4844-98c5-95e0ada3596a@gmail.com>
In-Reply-To: <a551ce83-278b-4844-98c5-95e0ada3596a@gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Qml0dGVyYmx1ZSBTbWl0aCA8cnRsODgyMWNlcmZlMkBnbWFpbC5jb20+IHdyb3RlOg0KPiBUaGUg
UlRMODcwM0FTIGFwcGVhcnMgdG8gYmUgYSB2YXJpYW50IG9mIFJUTDg3MjNCUyB3aGljaCBkb2Vz
bid0IHN1cHBvcnQNCj4gNDAgTUh6IGNoYW5uZWwgd2lkdGgsIHNvIHJlYWQgdGhlIGNoaXAgdmFy
aWFudCBmcm9tIGVmdXNlIGFuZCBkaXNhYmxlDQo+IHN1cHBvcnQgZm9yIDQwIE1Iei4NCj4gDQo+
IFNpZ25lZC1vZmYtYnk6IEJpdHRlcmJsdWUgU21pdGggPHJ0bDg4MjFjZXJmZTJAZ21haWwuY29t
Pg0KDQpBY2tlZC1ieTogUGluZy1LZSBTaGloIDxwa3NoaWhAcmVhbHRlay5jb20+DQoNCg==
