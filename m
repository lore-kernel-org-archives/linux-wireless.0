Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF3AA231A23;
	Mon,  7 Sep 2026 01:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788745341; cv=none; b=CohPE8JL4uB4Par+RUZ6XhtldVg0tS4noTy1g1LGOHgCuwrqHye0WbLvjK3Wq4JsdqTP3uTIvziktA2BpUL7JxWsqKd3jGtghjE2hQcNWuq7pvLI+pCaNufUq5+hftGnxcfDWlMlTthR+J+UbF3CeqpmxMWAEqFsP5yyBoaWWUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788745341; c=relaxed/simple;
	bh=BYYxv4WBNVAj9hQvEn3hA5I/gf8lvQXgIemii6JmEDU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lOESJLMP/y9DVGyWoUgVPxEHfiYA5PneGRUDzy0o5Jwain+UWy8RG49jb3/fgewLiZzkXW3NAWZEift4gYrBARoT7BmV9iih+xY8kLtbjJOCOLfD1y9xxXIYlu2ZLfCKKnJiFdY0gOHkG+WhL8UzQOGE+0dig4Rb33Lk/fG0hQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=K2sW23dx; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="K2sW23dx"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6871g9MU12377520, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788745329; bh=BYYxv4WBNVAj9hQvEn3hA5I/gf8lvQXgIemii6JmEDU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=K2sW23dxdLxoBfi1dQ8eUWPobi2qeJcuwwzbHs1jYyVtCIKB+UTVYg2WZS0uvb6KD
	 IKftB0OHUBaWNFEZfHx/P9wvQrMotUir9uApp/TuYSg84/lz4za74elbemVARas1v9
	 kRmErPgZn1tlECSpxS1UPJf9PYiCn+3HQDOeOpCH2BPHNhpWUIp0dO/Re+qVflIcvE
	 8tVEX2k98I/zCixrVOAXhg2Qk3C/BBPOXbjp4vKbUgnwn0oy7qW8IxxCsfqLS54xpv
	 Zbcho/j9H21wydDzUD3+F/HWB3osPDH2ioiCtyHAlJB6lucN9JvHy2zx5GLL4gnKUR
	 B0BOxD33+4pGg==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6871g9MU12377520
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 7 Sep 2026 09:42:09 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 7 Sep 2026 09:42:09 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Mon, 7 Sep 2026 09:42:09 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Mehmet Fide <mehmet.fide@gmail.com>
CC: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Mehmet Fide
	<mehmet.fide@screeningeagle.com>
Subject: RE: [PATCH rtw-next v3] wifi: rtw88: usb: route bmc frames via the
 high queue only for DTIM delivery
Thread-Topic: [PATCH rtw-next v3] wifi: rtw88: usb: route bmc frames via the
 high queue only for DTIM delivery
Thread-Index: AQHdK66WOfaBclcfS0e15NhvFyIcILazZGiAgAXJeAD//9pbAIAH9LaQ///WroCAAaK/MA==
Date: Mon, 7 Sep 2026 01:42:09 +0000
Message-ID: <d91b4f77a662442fa796f0407fe08d54@realtek.com>
References: <070f9724ca4a42a0b64bbf63724d8cdc@realtek.com>
 <20260906082017.909554-1-mehmet.fide@gmail.com>
In-Reply-To: <20260906082017.909554-1-mehmet.fide@gmail.com>
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

Mehmet Fide <mehmet.fide@gmail.com> wrote:
> Hi Ping-Ke,
>=20
> > FYI. I checked vendor driver. Normally REG_ATIMWND sets 0xa or 0xc in A=
P mode
> > for chips.
>=20
> Thanks, that matches what I measured: 0x04 already drained the storm, so
> 0xa leaves comfortable headroom. If you agree I will add a small third pa=
tch
> to the series that programs REG_ATIMWND to 0xa when the interface goes in=
to
> AP mode, as a complement to the bound and the filter (each covers a
> different failure mode: the window adds drain capacity, the bound protect=
s
> the pool if the window is not enough, the filter keeps the ordinary chatt=
er
> off the beacon-paced path altogether).

Agree. Please do it.=20

As many chips don't initialize REG_ATIMWND (0x55a) at all, you might set th=
e
value back to 0x2 when stopping AP.

>=20
> > As you saw it is for TDLS channel switching (timeslot sharing), I
> > don't think it can work in AP mode...
> > I will ask USB experts internally to see if there is an interrupt
> > to notify driver about TBTT (or beacon early).
>=20
> Understood, and thank you for asking. If such a notification exists I wou=
ld
> be glad to prototype IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING on top of i=
t
> as the long-term solution; the bound and filter series does not depend on=
 it.

I'm still checking this, and will give back to you if it exists.

By the way, comments you left in patches 1/2 and 2/2 look good to me.

Ping-Ke

