Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792895944;
	b=KvLd7nnRxOpnTmo4j4PW2dmtGL2VRbW7ed1Z5lRDcgXakUXhXCfPJhJ073wE7Uztht3i
	 txCMfiPn/Cw+j6y356s0VJ3GI1W5dO19HUwC5T2llxLpGT5LYUgV6hYQG7gjTn4G2qQCK
	 244rP8KJ+4tux6PjLaz6EJ8WRfy00pc7CK1Qdqmuhs5gUOI/HCShkIy6RniFJ0glhYKiS
	 a1JyLJFilgNxsRqiAJTKMKF845irj0kj321lgRb6iCjM/RcGjXgPZ75eEzLxUBuJu58GR
	 YXmaIWvqxP3XmcH+XRG2ZSab+Rc1IusgnSc5JX6UOOK+Hvr4uI88znmQm40opARoLJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792895944;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Subject:Thread-Topic:Thread-Index:Date:
	 Message-ID:References:In-Reply-To:Accept-Language:Content-Language:
	 x-originating-ip:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=5+rcXnkncmR9+nniaBameWEiznbJoGRs8K09Cg60KjE=;
	b=vZ08HkJmUO7ENUwEQkcxcAByVfNaNWCa63iFhj5B1B5thvT41D2o72XraVhPRmQAXnns
	 cHA06zWKcQ9I7vxScOcCMTW/tsyDqDW4ce94DiH56i73nwbYz/nhq9GLOkGXfQAG4i5WZ
	 xMH0lYkI6FwJqEaia3aZydrlgLEn/rBGHIUDwrBTKUughKp7NP+kPsKlI1BucnrsPw/TV
	 GfsB1xOz80PPkMmx+15XFzQt81Cj7qSLf4KGzJE2w3v+kxRyPwQ9mIdT6JPT3vRBMa+Px
	 qZbh9Q2scu+qNhJOnvF0kvIdNzTAjFnuxo1jdI64RRypMuCezM9xx9Iicq7/gv1x9gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=LLEzIOWa;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA47606A31A
	for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 02:39:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6AA47606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=LLEzIOWa
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69P2cwryF3142223, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1792895938; bh=5+rcXnkncmR9+nniaBameWEiznbJoGRs8K09Cg60KjE=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=LLEzIOWafZYjov9sxOotW3MOG0BRmwck0jEgKHPx3Qohml6yChtiWQ67Sc5F5h3qj
	 DXJ2e/Dr4ByLcA7DUbsiFMJ/0GEJS9WTSGSHnI4VJjr49E37yIC96S1roPoaLSGuO+
	 5Gm9bC0UVAl7m74x3cbhiWlGBGMm4hWaTcmXZXT151fBfgURYgBtLCdQ7OpfA33ENU
	 e6aAetKNYZWd9kntcUOIpR0bUIoY6G3RHvR/CaYnSWEcgMhqRUY39VArEahbfjxn9O
	 xv8ow66TluubPDHG7HYPfBBjg3WNanvIJ459zkxrL1nq46p7VG8eEBSU9L+ClVheoe
	 +jVqCI9Z1vfpA==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69P2cwryF3142223
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sun, 25 Oct 2026 10:38:58 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 25 Oct 2026 10:38:59 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 25 Oct 2026 10:38:58 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Sun, 25 Oct 2026 10:38:58 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Carl Quist <equalizerjr@gmail.com>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>
Subject: RE: [PATCH rtw-next] wifi: rtw88: 8723d: add iface combination
Thread-Topic: [PATCH rtw-next] wifi: rtw88: 8723d: add iface combination
Thread-Index: AQHdXbduQ6aiRpZMH0mQK6ZTehenWbcBBocAgAAhaACAAvMr4IAG+mIAgAKBbKA=
Date: Sun, 25 Oct 2026 02:38:58 +0000
Message-ID: <836925ba243944dbbc74a713d63d74c7@realtek.com>
References: <b35b82f1331141faa3603574fa3697ac@realtek.com>
 <20261023201724.68885-1-equalizerjr@gmail.com>
In-Reply-To: <20261023201724.68885-1-equalizerjr@gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Carl Quist <equalizerjr@gmail.com> wrote:
> Would you be fine with sending v2 as it is, with the commit message
> stating exactly what was and was not tested? Or would you rather wait
> until someone with a sniffer can run your checks?=20

With your tests from user point of view, I think it is okay. That'd be
good if someone can capture a sniffer and analyze it, but that isn't
a blocking item to merge this patch. Please follow Luka's suggestions
to spin v2.=20

> If there is a way to
> check any of those points with a single adapter, I am happy to try it.

I think no. Driver isn't aware that packets sent by firmware/hardware.

Ping-Ke

