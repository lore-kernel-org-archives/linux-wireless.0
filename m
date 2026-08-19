Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47FC338E5FE;
	Wed, 19 Aug 2026 00:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787100181; cv=none; b=iDjpevF3xA+U9N5ARq1WLCs2OwiE8Hi9GcvkwLlwL6qvyiD6osImatuHHZsxJJEk9EhHmkCA2BXH8nVHTXkBfTbNEfcad1WRPY46ma1LCfi8JLNofuZXuwuteJn+xBrC0zyKeq70xTdX0OyxjPn6h1AgdUNC+Vog1J6E0ORsCco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787100181; c=relaxed/simple;
	bh=usL5BVmYHbLGOnnlKanIU/I6Jqtr177v5E2v12uSi7Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nJ5IbgprG8Qt8PMQCqos5Gtx85uwWvG5lDB4poq38xL2NQMRmWhZNLizQ+i28bNPq02alsqpmJ5VtlehCc+jpvSkZXif2Pz6hpq8/86mqwse5K35XDGQxH3GxNHO+//vqhdAXSchTEQmyR1nz6TgnSSDqNktHM5z/4kvEDUtYc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=RmvUKgpy; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="RmvUKgpy"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67J0fvBJ31917311, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1787100117; bh=usL5BVmYHbLGOnnlKanIU/I6Jqtr177v5E2v12uSi7Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=RmvUKgpyGcyfFaNACmC8Orb6qillo+b3SJ5Enm9j62GX3NtZy+qG8x1qY1GbdafR+
	 hBqG+QhRONwMd6GGzRXJGWzdx/RZJlRmDkf+KkKEnYGvhcIxRnVnapD2gaYrUJiGBV
	 CmUlzeCsN/N6gJDamsA7kbbSW3QX9z6HaeJ+wBo62v4rkX4TDbug3BCpfA9Wt7jDmu
	 OiqZ/UgEO+uPrSUr5sB94fKWm7SoKu/b0N3ttl7roWZmvLmdpJynj3mmfpSxz9Gsij
	 wR9lf+fAAyAuqO4XdWQ7utgQIFEWerIUxtEvoqqV8lloIrIk0dPoiGDRSdDTIZsBXc
	 1OGimOyUav8ww==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67J0fvBJ31917311
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 19 Aug 2026 08:41:57 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 19 Aug 2026 08:41:58 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 19 Aug 2026 08:41:57 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Wed, 19 Aug 2026 08:41:57 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: "luka.gejak@linux.dev" <luka.gejak@linux.dev>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Bitterblue Smith
	<rtl8821cerfe2@gmail.com>, Peter Robinson <pbrobinson@gmail.com>, "Hans de
 Goede" <johannes.goede@oss.qualcomm.com>
Subject: RE: [PATCH v5 2/6] wifi: rtw88: rx: mark zero length packets on
 RTL8723BS
Thread-Topic: [PATCH v5 2/6] wifi: rtw88: rx: mark zero length packets on
 RTL8723BS
Thread-Index: AQHdK9s6mS5GiSkAdE6uRxnciyIpubakjuOg
Date: Wed, 19 Aug 2026 00:41:57 +0000
Message-ID: <35a3339ffeb44e30bd93dfbfc179e131@realtek.com>
References: <20260814105327.6687-1-luka.gejak@linux.dev>
 <20260814105327.6687-3-luka.gejak@linux.dev>
In-Reply-To: <20260814105327.6687-3-luka.gejak@linux.dev>
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

luka.gejak@linux.dev <luka.gejak@linux.dev> wrote:
> From: Luka Gejak <luka.gejak@linux.dev>
>=20
> Like the RTL8703B, the RTL8723BS reports receive descriptors with a zero
> packet length, which the vendor driver drops outright. rtw88 already
> flags these as having no PSDU for the RTL8703B, so extend the same
> handling rather than passing an empty frame up.
>=20
> This is gated on the SDIO interface rather than the chip id, because it
> has only been observed there; the USB variant is not known to do it.
>=20
> Co-developed-by: Michael Straube <straube.linux@gmail.com>
> Signed-off-by: Michael Straube <straube.linux@gmail.com>
> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>

By the way, though you have added change log in cover letter. It'd be
better to make a copy here (after --- delimiter).=20


