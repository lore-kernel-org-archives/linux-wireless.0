Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A6AE443C13;
	Wed, 23 Sep 2026 06:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790144171; cv=none; b=VOBUf/x9xh2tCwGUADYykWJ6QunIkDH0Ql3A053Tob7i3P+BVRG4RJdHF7Al2+EwAwXZaKi0Titn44/vrdGCvi0WB1x8Wft+3exS3W1ZyC3UHJOFJ/DGlQ9vDDS20dJeRwEI0Kzki9yp9YRkp1iTQoQRfP4D6tIitISJ4ytBNyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790144171; c=relaxed/simple;
	bh=0L7i4elP+1XTP5sqQ7F3+9HPjC1g9ODra5dcOxC/oHY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=S9WvYRCKqn7SvIeuceEX0uHn76KSbcZPSBpP0gdCspL4DUcv1qg7GMucSxqo15c8m5WyxLe2unRB9B/xYVZsb7ATYLoW7d+jIJrNQ1RZyLUB+y8jeHbQb59gw0+5mPU00PUpSrrwaI9a85f77sTG5XaAYglHy6yVb9/Ypt7Uz2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=mAzsf6t8; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="mAzsf6t8"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68N6FuRnA109578, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790144156; bh=0L7i4elP+1XTP5sqQ7F3+9HPjC1g9ODra5dcOxC/oHY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=mAzsf6t8n07+SWLNU9knu6fBKnbtRVEEMQ7VZ8bgIIadJNjiyBrQcuGQH+Mq9ahD7
	 6ay57J3E1D3BVsPyIaFgam1Bk/YHoRvCvCiPpH3K7/431Bn93f9q5Jvz3LLa0Kc5cI
	 cu4xr6tEpmAJI4g9VFL4hp6d+XFbjkox2TDoHJZ0vbCO8Xh3M3whwyUM8JgqIT98hR
	 3n3qLgXzFmD5Np9MX2z8wSJ4nM0bWOHQvf8NhVk2BKnTBtt28o887t60ZPkJmm+Lic
	 ZlIPBC4bwUC73S4MFaZaLrSoGDoWxml8VS0mROQIaE7CyRsitP08CsjcsmksHI4Bo/
	 gh3iYQ5O1DJxw==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68N6FuRnA109578
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 23 Sep 2026 14:15:56 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 23 Sep 2026 14:15:54 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Wed, 23 Sep 2026 14:15:54 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Paolo Lazzaroni <eexto@aol.com>, "rtl8821cerfe2@gmail.com"
	<rtl8821cerfe2@gmail.com>, "kvalo@kernel.org" <kvalo@kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "ohavrylov.oss@gmail.com" <ohavrylov.oss@gmail.com>,
	"gabriel_v_maia@estudante.sesisenai.org.br"
	<gabriel_v_maia@estudante.sesisenai.org.br>, "learn.rahul.rai@gmail.com"
	<learn.rahul.rai@gmail.com>, "mihaildimoski@gmail.com"
	<mihaildimoski@gmail.com>, "atailhan2006@gmail.com" <atailhan2006@gmail.com>
Subject: RE: [PATCH rtw-next] wifi: rtw88: 8821c: disable deep LPS on PCIe
 devices
Thread-Topic: [PATCH rtw-next] wifi: rtw88: 8821c: disable deep LPS on PCIe
 devices
Thread-Index: AQHdR8VgRb0AFz8J/02a5VCtUHNfvLbVpdyAgAEXFXCAAGgNAIAEjrvQ
Date: Wed, 23 Sep 2026 06:15:54 +0000
Message-ID: <1ae7510f10b94d27b7157aa3a2c13db8@realtek.com>
References: <20260918232801.119348-1-eexto@aol.com>
 <2f2f2366-bf64-45d1-911d-6a769be9d7aa@gmail.com>
 <6ef40cf436a54a319ab228c19a137cc4@realtek.com>
 <20260920163018.279705-1-eexto@aol.com>
In-Reply-To: <20260920163018.279705-1-eexto@aol.com>
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

Paolo Lazzaroni <eexto@aol.com> wrote:
> Bitterblue Smith <rtl8821cerfe2@gmail.com> wrote:
> > Disabling LPS_PG doesn't mean disabling LCLK, I think.
>=20
> Ping-Ke Shih <pkshih@realtek.com> wrote:
> > Indeed. bLPS_PG_En should be LPS_DEEP_MODE_PG which 8821c's
> > .lps_deep_mode_supported doesn't declare this.
>=20
> Ah, got it. Sorry, my mistake.
>=20
> > First line of block comment should be empty.
>=20
> Will fix this style in the next revision.
>=20
> > I'll consult internally to see if we disable deep PS entirely
> > for this chip.
> >
> > My question is that are you 100% sure this can resolve the problem
> > you encountered?
>=20
> To be transparent: on my HP 15-da0xxx (subsystem 103c:831a), I was origin=
ally
> using module parameters (disable_lps_deep=3Dy and disable_aspm=3Dy) while=
 debugging
> the antenna issue.
>=20
> After your question, I tested my laptop with upstream default settings
> (disable_lps_deep=3Dn, disable_aspm=3Dn, power_save=3Don). Using ftrace o=
n
> rtw_power_mode_change over a 1-hour test, the card entered and left 32kHz
> LCLK deep sleep hundreds of times without any freeze or firmware error. S=
o
> on my specific HP laptop, deep LPS actually works fine.

That is the case in our side. I don't see the error. But laptop is differen=
t
from yours though.=20

>=20
> I proposed this patch and added the reporters in Cc (Gabriel, Rahul, Miha=
il,
> Ata) because multiple platforms (HP, ASUS TUF, Lenovo, Dell) keep hitting
> hard freezes with 8821CE PCIe, and adding DMI quirks one by one is hard
> to maintain.

I knew DMI quirks is little hard to maintain, so an alternative way is
to use module parameters (disable_lps_deep=3Dy and disable_aspm=3Dy).

By our measurement, the power consumption without deep PS increases about
16mA (3.3V) for RTL8821CE. The value is not very large, but if platforms
can enter the mode, it is still good.

>=20
> So I can't be 100% sure for their hardware without their confirmation.
> We hope someone in Cc can join the discussion and test this patch to see
> if it definitively fixes their freeze, which would also help anyone who m=
ight
> encounter this problem in the future.
>=20
> Thank you for consulting internally at Realtek. I will hold off on v2
> until your internal feedback.

The affected power consumption is listed above.=20

Ping-Ke

