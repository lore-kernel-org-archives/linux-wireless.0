Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793598490;
	b=pDjUVE9joZ9rGUJ8sZSe7bpP78L3qP4GoO0Gx8A/PL+3DUVdf682FpvGvmMF0vXzfZo+
	 XnKzpBFXyL8ZDgTbftOh+BtPgDUd7GS6gQP4/IB2ABbaowwvt7I4yXlShfTIzd1KcgJxG
	 z/OJHZNgD3Huo1S6kLOQC/cJolNWGmaaQZ4Ft4JPw1zvAunyhkcFideET3EXO00U1Kgr8
	 mpm4V1Pc5IUKcgeYAmQneDTCiBBbtl9usD0Nn9uD7MlTUs7w26z11YsNVeHL8NtjJQyGf
	 3gomCioTbcSeM0/d0uqSwb3iN6jpLWhX4v+sOHX8TuC08pb99MOhEqSclvnrrgZgkyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793598490;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:From:To:CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:
	 References:In-Reply-To:Accept-Language:Content-Language:
	 x-originating-ip:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=HzdjXJks4t+WEAvIaOuXDWU/oDpYkHMbu91orBOCcUA=;
	b=Z4vRPY0+PujR/GNu/dzPwG74iTdBwg8jnK3lUZTiwNGBfIcWKwOnwQHLRqF7xHT3/6Ki
	 HZsSksRI8NRdAj3UauBYzQZE4+3kSEq7PR5nLlKPDVEND0eE/T9npF5aJ//eMcIElrmlg
	 k/zxCG2MZdrjppq462Hl6J6F2S+mu53GccRl28L4qt9/5TumpwLRxSAkPW1vDlDZaO70Q
	 EGWHyv77XjaBMCOCmcCSvIJUZ0q5cVxMsqG700a1WhEIJFQhpi3L4ykMFbmAYgQ8+WmT9
	 4ls8hOJ2uAMZBGULx3GnM9r5c/K7diGyrqB9vMNiMRKKfeGvjsS5NTfvB1rjkxnM9SQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=hgSJd0ak;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 725A1606A324;
	Mon,  2 Nov 2026 05:48:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 725A1606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=hgSJd0ak
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6A25lnHcB1912254, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1793598470; bh=HzdjXJks4t+WEAvIaOuXDWU/oDpYkHMbu91orBOCcUA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=hgSJd0akqH/1AcHuZ8Y/22kVOHu0C9d1+Du3H3cXwc1MxsHkdfkRGBuI3+/ncY00P
	 roBoC3qyKujVsCRhC/vPd0S+4OdSDFjJJ6au65KppApwNaYGxe87DwBHVHAl1WA6EF
	 2xFcfKctaTayMrr/zRf7d+ORNKBW3jgSrhqAlKfcGoAlXR2yX4aWoEnl9ukG36a5aL
	 SVOnWaIB96KjWK3IY/tQKTGqyr8adZha2edXZIcmB1p7e7Q9kwVdufBi+0RyXwgCwE
	 BLhgbGh857kdfgWowRymSyubc0SkTCxUXG+aYP45WNk0D3qTT/Pb0DCxE9EikhZAGh
	 BO6+KENQxgK3A==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6A25lnHcB1912254
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 2 Nov 2026 13:47:49 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 2 Nov 2026 13:47:49 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([fe80::eeeb:c765:ca73:5eef]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::eeeb:c765:ca73:5eef%10]) with mapi id
 15.02.2562.056; Mon, 2 Nov 2026 13:47:49 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Kalpesh Solanki <skalpesh942@gmail.com>, "kvalo@kernel.org"
	<kvalo@kernel.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2] wifi: rtw88: pci: Add DMI quirk for HP Laptop
 15s-fr5xxx
Thread-Topic: [PATCH 1/2] wifi: rtw88: pci: Add DMI quirk for HP Laptop
 15s-fr5xxx
Thread-Index: AQHdaeZYnVfONR5AmkWUqAjDvYGLcrcaR4Fw
Date: Mon, 2 Nov 2026 05:47:49 +0000
Message-ID: <204a594ebadc4609b16a9dba49dee903@realtek.com>
References: <20261101094905.1299638-1-skalpesh942@gmail.com>
In-Reply-To: <20261101094905.1299638-1-skalpesh942@gmail.com>
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

Kalpesh Solanki <skalpesh942@gmail.com> wrote:
> On the HP Laptop 15s-fr5xxx with RTL8822CE, PCIe ASPM L1/L1.2 and deep LP=
S
> cause the card's firmware to fail to resume from low-power states,
> resulting in repeated 'firmware failed to leave lps state' and
> 'failed to send h2c command' errors and stalled network traffic.
>=20
> Add a DMI quirk entry for 'HP Laptop 15s-fr5xxx' to disable PCIe ASPM
> and deep LPS, ensuring reliable Wi-Fi operation.
>=20
> Signed-off-by: Kalpesh Solanki <skalpesh942@gmail.com>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>


