Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592C8395AD4;
	Mon,  7 Sep 2026 02:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788747306; cv=none; b=O/iLIQ03yU/btjCLkthYYxeHD427RyVje4iNu717KrSBsYUCKnLEbbZ8lBmE0OYJUQ3bkCFjxmFyZueKERJkpT8HinChrzmIGnsx/W2d/dYqHnpUdAfqvq2ACRoj5+MuCHuY17I8kWksLXuiKnHcjpaV3M8smitNsexlMJD8tIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788747306; c=relaxed/simple;
	bh=l7VZ88IfNlHnFu4GriBoSpTGd5POoW8m6mxErljAFmo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=K6ZoCuCj99N2I722MEAdQDXYpOTh/GBfIGwqnW8EhsxjTaDLap0GUvJFgIiCCl9Vk+TB92wVvXpVjGTwZZuBis1BXPGBx+ST8shqllFE4U4V85/Fb0whdg09EwP9oIEdodWjc1vuVLjseYyUBv+aWhNbURoqRRkqM/HxP0APkpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=aOnBpYO0; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="aOnBpYO0"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6872Es9I22400921, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788747295; bh=l7VZ88IfNlHnFu4GriBoSpTGd5POoW8m6mxErljAFmo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=aOnBpYO0hi5hLlm7I+tngygOK5R9VmoDwIhccIXbOMZNA55b4RB0EGTVvjkcNxCSy
	 S5oeo2+B3jUew+oMfZ2ArZH2yTjidAsTQ10dDawtL7V7eR8JAWIei1l5BV9mWvTW+f
	 C2jmNV+4aui5EHqa4VcHRDYjxgVFxZgMjPXAnSArgasLCot2ogwZn9Z69hCK/vHNDZ
	 ZoOGM0474apahh9juLxpjUMuMTcwHT0a3vtP6hzlgLWNZ1iKCjHi2todn8JYN6tawb
	 GCkfZDl2jRsrtVS41Xh+TCWhC5+t2EVF5nbUPc0RIbQ+9VIgMucb7+J6P1IsoWxmXn
	 LSJUj3CXeA+Ng==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6872Es9I22400921
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 7 Sep 2026 10:14:55 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 7 Sep 2026 10:14:55 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 7 Sep 2026 10:14:54 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Mon, 7 Sep 2026 10:14:54 +0800
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
Thread-Index: AQHdK66WOfaBclcfS0e15NhvFyIcILazZGiAgAXJeAD//9pbAIAH9LaQ///WroCAAaK/MIAADtlA
Date: Mon, 7 Sep 2026 02:14:54 +0000
Message-ID: <f7bb980260ed4225a31b8c2c980ccc49@realtek.com>
References: <070f9724ca4a42a0b64bbf63724d8cdc@realtek.com>
 <20260906082017.909554-1-mehmet.fide@gmail.com>
 <d91b4f77a662442fa796f0407fe08d54@realtek.com>
In-Reply-To: <d91b4f77a662442fa796f0407fe08d54@realtek.com>
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


Ping-Ke Shih <pkshih@realtek.com> wrote:
> > > As you saw it is for TDLS channel switching (timeslot sharing), I
> > > don't think it can work in AP mode...
> > > I will ask USB experts internally to see if there is an interrupt
> > > to notify driver about TBTT (or beacon early).
> >
> > Understood, and thank you for asking. If such a notification exists I w=
ould
> > be glad to prototype IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING on top of=
 it
> > as the long-term solution; the bound and filter series does not depend =
on it.
>=20
> I'm still checking this, and will give back to you if it exists.

I checked. The H2C and C2H can also be used to AP mode, not only TDLS chann=
el
switching. You can spin this as long-term solution.=20

Ping-Ke

