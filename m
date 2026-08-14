Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4693CB570;
	Fri, 14 Aug 2026 08:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786694642; cv=none; b=TuXYwOxZflkYKr8lvrpUl/46GuVhe3ONfIOv9HKagcpOPrqKcWtZa1Qu81T7jBFgaY6YD6ie/FsQ6gCPBDqR49zrXYhE5T2IHOYri2GLCbXULFg/2bHqcA/GlCSqFSb3QCXWhz6Zq3tr9EyU0wDR0rNXc0B2GV/r3WMg2V/uXrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786694642; c=relaxed/simple;
	bh=GcDjk6Sbeo/NqHcq5lbZO/Oi6bbGH1a6XKZe7+SJWCI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=u9Bks1DGc044cDTsIjctPRThdyjase4sN4yMiqRmS4cM5zW9XzTG1f6nINSju2I0dyAZIgaHrC4VaYDAZPl2UYuzGogOThbNmYrh0ml+LgL6otA7298W9PQOX2n1FFwZBpuXlFMMVVfUEs2lCBYLCt/bGooXigoGDvtNrThRl0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=dID0rCDu; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="dID0rCDu"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67E83uIfA1078895, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1786694636; bh=etosF4QaJhDkaDs0d9TPteBo3Li8oEAxqc8hsmc7JxY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=dID0rCDuTVEr0rBXR37CCMiOyAtCZYi/5aAo4Q3OqzvnDwxWZuQQGYkpp2teo2S0s
	 SuqhgWb6R3uCB2Oyf7KVR8CS0a7RGUzeFXa3zgu122wf6HqbD4+XWC1IHbvIi+2l9p
	 q4oGGitbn2e79rlG/OH4pCWVeXl4ULm9n8s2dPOplBpq8xqY8Og2pHlQJU6Uq3cG71
	 Fg6clmfK8XkXz3xLicc7Gn3LGVj7KuSgKR5aNi88Bt91IpflElerBQa3lGPA5IdHZB
	 lcRIKlGxEgVF2pOKSU11c2ECgmfPvsuzOoRHG+x8j4ZKoNNXtPDpgSnlUu+QiYoP0T
	 rlwC28xZu4iVw==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67E83uIfA1078895
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 14 Aug 2026 16:03:56 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 14 Aug 2026 16:03:56 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Fri, 14 Aug 2026 16:03:56 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Arsenii Pashchenko <ulijg308@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/4] wifi: rtw88: rtw8822c: use sign_extend32 for DAC IQ
 validation
Thread-Topic: [PATCH 2/4] wifi: rtw88: rtw8822c: use sign_extend32 for DAC IQ
 validation
Thread-Index: AQHdKmlUAXzXV8VvpUCXWdcBWAD1ILadLBAggAAFQ8A=
Date: Fri, 14 Aug 2026 08:03:55 +0000
Message-ID: <c469acfcbf29407ebf04ad921339aeea@realtek.com>
References: <cover.1786545572.git.ulijg308@gmail.com>
 <a016d09710dce6f27a60e8fb3c16cdc28ef24a08.1786545572.git.ulijg308@gmail.com>
 <9be26fe7c6814b17baf2bb08fbfff6eb@realtek.com>
In-Reply-To: <9be26fe7c6814b17baf2bb08fbfff6eb@realtek.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

> >                         temp =3D rtw_read32_mask(rtwdev, 0x2dbc, 0x3fff=
ff);
> > -                       iv[DACK_SN_8822C - 1] =3D (s32)((temp & 0x3ff00=
0) >> 12);
> > -                       qv[DACK_SN_8822C - 1] =3D (s32)(temp & 0x3ff);
> > +                       iv[DACK_SN_8822C - 1] =3D sign_extend32((temp &=
 0x3ff000) >> 12, 9);
> > +                       qv[DACK_SN_8822C - 1] =3D sign_extend32(temp & =
0x3ff, 9);
>=20
> FIELD_GET_SIGNED()
>=20
> Please use real hardware to verify the values.
>=20

Consider the change of sign_extend32() again. The value is not the same
as before. So, if people run this intermediate patch, the result will be
wrong. Please think how to rearrange your changes.


