Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48110372B27;
	Wed,  7 Oct 2026 02:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791340722; cv=none; b=CYghu+xShNas6TlTTGDbmCccd7G/9/n6Z1cn07nuWGkJ4Xt291ewj5O5eTS2aSLJKlq19aBB8voFl4MfXANrzi6ABOlCWUh0pQDedlUGAak2SUPbcC5q2nqgqqoT9iKYV7bvmSNolANfgJp2hUig+qrqie/G5GDy5gG4pikfWAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791340722; c=relaxed/simple;
	bh=pY0D9PZc1wydT4nIKHFpgrQLiNhPGa/AgpCl4L9vi98=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Gay7ahXEdPjWE4L99i73VPfjv45clg4ZLol1t6esvIxK2qhXu+5vxdntj48myaOiZX1s1YG0QM1+zu1er8w4VRxMzvSvhq6dqp6Wm2/8SWMJl7Ofsp/xiFSdMuYH0YS0SBed8GiEGx8frZK30TkNevYdgA/C2vE4zdIG5Ir17hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=vn2jTXjK; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="vn2jTXjK"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6972cTzuD3469241, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791340710; bh=pY0D9PZc1wydT4nIKHFpgrQLiNhPGa/AgpCl4L9vi98=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=vn2jTXjKZpiyDAPUGpzElO5i0ue4waJnspjAk5GILFT2YDYIvucUNc+PdOQcd4LN+
	 5zoGprvL0qs8VDUIHcLyAfjsCzKIGqbphNzPS+vzlSbqXF/DbHEjBO+5wMFXwljJLr
	 8wK4WEZxuhyblFZ6PkoyBCj6h8ZZbPC4nXVH0gaUtrqJEYIUObIA62He9KdthIN1dm
	 Q+50TtoRX2Or4xT6Tytwx+bZhAl8hMJmmr+ZEfL+KnlD4tnu8f0Kac4/0pwkUy5j/p
	 p7US8RFFrYfcvDVeLsp92GrxPZxiEQsKXSdICfnt+sgom2dIqS6buPMBFJi5cMj6Yf
	 5XZmYHpCYc9WA==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6972cTzuD3469241
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 7 Oct 2026 10:38:29 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 7 Oct 2026 10:38:30 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 7 Oct 2026 10:38:29 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Wed, 7 Oct 2026 10:38:29 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Luka Gejak <luka.gejak@linux.dev>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: RE: [PATCH rtw-next v8 4/7] wifi: rtw88: move the shared 8723x
 definitions to rtw8723x.h
Thread-Topic: [PATCH rtw-next v8 4/7] wifi: rtw88: move the shared 8723x
 definitions to rtw8723x.h
Thread-Index: AQHdVZOiyhDtsV7kmk2LB78/adC2r7bxXpdA
Date: Wed, 7 Oct 2026 02:38:29 +0000
Message-ID: <cee0667e22ae48b7a707000615825e37@realtek.com>
References: <20261006130701.120460-1-luka.gejak@linux.dev>
 <20261006130701.120460-5-luka.gejak@linux.dev>
In-Reply-To: <20261006130701.120460-5-luka.gejak@linux.dev>
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

Luka Gejak <luka.gejak@linux.dev> wrote:
> The RTL8723B driver needs the receive PHY status layout, the SDIO
> aggregation burst fields and four baseband registers, which currently
> live in rtw8703b.h. Move them to rtw8723x.h, the header for the
> definitions shared within the family, and rename struct phy_status_8703b
> to struct phy_status_8723x. The layout is called phy_status_rpt_8192cd in
> the vendor driver. This is not a logical change.
>=20
> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>


