Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792635645;
	b=GuXssoovBvyKA3F18AC5E3VLNQeBiFtgbmJ3g1ghbV9LAy6cbqBsgM2GawTQR2LnLoSh
	 aHM23q9VTVFrL84Ra/sCYYhM7I5swhFQjzuHwDVs80UEp9uvRKYZDbZsnXFP/kR8PyMKA
	 99K85IHV8/0oUf059XwFvn0zazE/qWxy178zNcFCWkx75h7VzondIkNTQshGBYOe7Ll6f
	 flYAwfcfY8C/WGQRUNWu31KjAdArSY2Tw1rYlcCGGqkFz+pOjzds6kdmneyRoyXc1skO4
	 azZxCvsRZChtA0vG0qghwPCI/xfdpTUb/ZFsiwMgizTfZDu+36w6VD2gVeR+GvrBKrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792635645;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:Received:From:To:CC:Subject:Thread-Topic:Thread-Index:Date:
	 Message-ID:References:In-Reply-To:Accept-Language:Content-Language:
	 x-originating-ip:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=FYzIl78CO08JrCWpsHadaBrFaOyKpu16bRSVj3pJs/s=;
	b=ZyvVuEclcDoI6OFpqX84ZVo+i2ReQr708GYuYNCAMVuSYl2SS/EL+lTV/6TyC2Dnzgq4
	 drxFyCosY3nu+GnFbvi5rYddpNKdlx/SUV/yK4ip1uo6dKZwhsTQ8GR/lLZMcQkjqaLSd
	 2a8+K7h+cWK8gIG1gEsZ6qwTQ7iNp1pciLu2Yu+9Ak/Y6LhP0K44KSIJ5i6LRdHy/f2iz
	 uqEXJwn6F5d15pJfUexyYQ5F647iXanFqnB80Fd30cBaPFKws9MMU9lvcDCQ9CSoQkorS
	 L+qSe7Ns2dF4v4XbvHyDBEQkBxwpxMLCwcfXLo+jGlNyx1quKG4eeMtm7UYOxXV6Srg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=iGN5azgh;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8559A606A324
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 02:20:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8559A606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=iGN5azgh
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69M2KXHM0474884, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1792635633; bh=FYzIl78CO08JrCWpsHadaBrFaOyKpu16bRSVj3pJs/s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=iGN5azgh4KAKUsUToLaHl48XxY9l08Z3rJ1kr+un4R08APPSoIzTHLRFMwwuz7SK4
	 QctmtaaPuuqk/Uy04PlIsOTxkKVtPILFcpHoZYilahwqzxendDrH4Vyx7jHYVG+8Fw
	 0U8u2dvDEyOO5vicH4GDP1j6G+neAwMh16SNGpcSVGZpSfZ1yhdsS+5ayp2BOTKpCS
	 4tCC3AmrCqlfy2k7ZGtwbjEnobNk6RzkiVb7IcsV1XeUoqNym2RzhQ7Vtf9Ip8mtdP
	 C3+UaEXuFwySaSOuuj+37Z1VxuwfUzJZpnE1fNjTyd5W8MrcDes2vfBe7iPCLDyGOU
	 0RQPuguuVldOg==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69M2KXHM0474884
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 22 Oct 2026 10:20:33 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 22 Oct 2026 10:20:33 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 22 Oct 2026 10:20:33 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Thu, 22 Oct 2026 10:20:33 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Luka Gejak <luka.gejak@linux.dev>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH rtw-next v2 1/2] wifi: rtw88: move the bmc high queue
 decision to tx.c
Thread-Topic: [PATCH rtw-next v2 1/2] wifi: rtw88: move the bmc high queue
 decision to tx.c
Thread-Index: AQHdYVnJ0q7282zST0eZU32CdZ8tpbcI07VQ
Date: Thu, 22 Oct 2026 02:20:33 +0000
Message-ID: <ac6d8824bdeb45148ffd6b5dee7da313@realtek.com>
References: <20261021124318.15993-1-luka.gejak@linux.dev>
In-Reply-To: <20261021124318.15993-1-luka.gejak@linux.dev>
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


Luka Gejak <luka.gejak@linux.dev> wrote:
> USB decides in usb.c which broadcast and multicast (bmc) frames may use
> the high queue. SDIO needs the same decision, so move the helpers to
> tx.c behind a single exported rtw_tx_bmc_use_hiq() and keep the budget
> state in struct rtw_dev.
>=20
> No functional change.

By my review, I think it doesn't change logic at all, but I hope if
someone can help to test USB devices to confirm it still works well.

>=20
> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>


