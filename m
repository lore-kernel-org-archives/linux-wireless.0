Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793066599;
	b=QBH5yM+W6XzWojaP+Np09lBIqQ3WUgjEySjR7XLaKV2LU5Sh47hA/dZPdWadC6oscLA+
	 VBLBRaHE4wPDeKFMxQaZLBCxxrPyvrgsTXM9lQQ3xo1FRs7OlJyYSdUyYrRT1lGi2/yXU
	 HZUx0CkBuBxwJ20ouasZe5On28/fkSAjP8H5CWVZNWPE5UtQTzWBNyWFtmQN0PbAL3pl1
	 nJE+Vtq2DKxmHNoph2QA2v51UC5/bn11t8XNua6KL4YOR/6D1smmfEJYfKxrIXqdELDAL
	 qfo5u4uac8le6RA2MG4tz6+ZYEHt6ectfxV59S7HruCI3ublat5BFlQOYzLbOloS/nQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793066599;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:From:To:CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:
	 References:In-Reply-To:Accept-Language:Content-Language:
	 x-originating-ip:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=Q8ub5QcUtHQqnIrSpXhYzlY/XJKpFnfzN2GQ5R6qafc=;
	b=RpNgTQAGWdZ72w8yGrTwa109zQCqjywKWMKsYVGkJZF9c/tBsnp/5kJ2IvSyU74mMayn
	 xqKqZz8KFc0zYCdTlkZEP7j94DCvlbzLrptqdLo7SYi8H1rzzvNvgEduh++/UaWlhfq5n
	 8sWerlospwcm/SM9K3smBliHrjiYRtB7LaY+Vw3MZJDD9I3Yj7M+TvsMxHEDti6xk7VF5
	 iQJk7UtLr2tIcVJykbiHbtsUiPe9MYMwreP8GTzywAGKmd4nJmqs9YPv53DWPaZlrqUae
	 cxSD/jWM803KEEbaRKc79y8APUPNe4HrihmvpayWYycawkL2GJ2gfozFz2j5q+Kx2eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=bPeQKBOi;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 809FC606A31A;
	Tue, 27 Oct 2026 02:03:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 809FC606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=bPeQKBOi
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69R22xJaA549957, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1793066579; bh=Q8ub5QcUtHQqnIrSpXhYzlY/XJKpFnfzN2GQ5R6qafc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=bPeQKBOi/RTZ5pl14L5q/8vqh7HaVGNHRYcNL1MLng6sE/MYgfb1mUzNWQtk+ueIn
	 03VN9q8uA3o2MVNaUpW7AOotYRhruJLJv9OWtdzJJmhMVwMZvXtZfOZsOloafBFAnT
	 DYGeuvGYwsbR2DEF32ycoFnxwymFhfbhIU5S9+7K1i/vpe5FcGezWHdS7yEmFQpgDm
	 DdALOaU60PPtXBFl0bqxeDEYR3pSdP2/Ea1Igbl66CizUy2i0V5FF+BhOP55jglI7c
	 MtCvwVz9Budy0sDvgWS9oPFcVgZefrTxMX5hpwiviIpfaaKAWZ6a1fpd2iYcqbp2aS
	 QWOmlvSak0Nzg==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69R22xJaA549957
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 27 Oct 2026 10:02:59 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 27 Oct 2026 10:02:32 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Tue, 27 Oct 2026 10:02:32 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Mehmet Fide <mehmet.fide@gmail.com>, Luka Gejak <luka.gejak@linux.dev>
CC: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mehmet.fide@screeningeagle.com" <mehmet.fide@screeningeagle.com>
Subject: RE: [PATCH rtw-next v8 2/3] wifi: rtw88: support channel switch in AP
 mode
Thread-Topic: [PATCH rtw-next v8 2/3] wifi: rtw88: support channel switch in
 AP mode
Thread-Index: AQHdYVG43GUzyp7a8U+d1TEXFu+Me7cNv5wAgABaToCAApC2sA==
Date: Tue, 27 Oct 2026 02:02:32 +0000
Message-ID: <64d3a24e0afd460db4a182bfa2214aa0@realtek.com>
References: <796598480d47c5bf474d11828769e864b8209558@linux.dev>
 <20261025184749.1045907-1-mehmet.fide@gmail.com>
In-Reply-To: <20261025184749.1045907-1-mehmet.fide@gmail.com>
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

Mehmet Fide <mehmet.fide@gmail.com> wrote:
> Hi Luka,
>=20
> Thanks for the review.
>=20
> > Would clearing csa_active in ieee80211_ibss_disconnect(), same way
> > ieee80211_stop_ap() does, be the right fix?
>=20
> Yes. I reproduced it on an RTL8822CU. mac80211 refuses the next switch
> itself as well, so I will send the fix to mac80211 separately.
>=20
> > Maybe rtw_ops_resume() could restart the countdown when the AP still ha=
s
> > csa_active set?
>=20
> Agreed, v9 does that. It is not run here, I have no 8822CE.

During the WoW suspend, I think AP stays on original channel and sends=20
beacon without countdown. How does associated STA do? Will it switch to
target channel and disconnect result from no beacon?


