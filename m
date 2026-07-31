Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B5C41A6800;
	Fri, 31 Jul 2026 00:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785458940; cv=none; b=uoaRvfivqPrEGK+cJpuFiKH0ftznaCR5yavBh3rgwmAGRGESDCnkrmibRkbxO/Ch9GqAd+5GdOluxseNpuyQh/kRgbijRdG7ZLwc+mSTvYBZMKjwdChohtKng17XfiZnysmb+qBaJg8f32PyDeJqDFD89CgYdVURxvE52xnq3tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785458940; c=relaxed/simple;
	bh=gbAr6Y3/AOldxJR71un1sFf7yPWxiiGjFm3zkEqE70A=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AiQ4ZwS1eSXQXBHIplyf6Hh4PltmVJldlaCGrT2NfXt+T3HhO7lpmXGz06rv8kf/ZPgD5vq/xKurGjdd6KQmfOxbt15uo4MNTgJa/rpO28q8Y0Ey8WBBGjEl19/fA73+3rF1n1m81pK+gHSb2umn0trOtmXU3y8yxVKYkqeoYiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=KMtFNmmC; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="KMtFNmmC"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66V0mjvyF1543465, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1785458925; bh=+cGwDi9TmCnUewqIVnD56JxQEJpXt5qrvc5E4M64uy4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=KMtFNmmCO2oCACNIFc/tOC6L5ELt/OMCgN0syqYy/N4qQWkXg86uJ/UrDRgh1SIxm
	 7Cn3MH8yb87i97egZkh5amCNxqPFLcOpyp1/VTjSiR/ttUUSJDeNlACWVbh8D87hbD
	 5GpCCmJX2JnedFxNBOCEiTebx5eF3xULXapg9dl6W3p6bx3m3gDOQMpH4TYW6Skcnd
	 qrbd6AopGDhg1I64AnwyTlzeaGDJR3qmI2LywZCLGP/rvUJqqKxQlZPf5a+9TPrhY0
	 ZhNoBBJr7O4+NR5VlIsZ3A0wQt505A2ajKwmdaHVCaLdjSBEOYMhoqqwLG3l9SsQrt
	 a5byq0KJstqxQ==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66V0mjvyF1543465
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 31 Jul 2026 08:48:45 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 31 Jul 2026 08:48:46 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 31 Jul 2026 08:48:45 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::e6fd:5a3f:8946:92c4%10]) with mapi id
 15.02.2562.017; Fri, 31 Jul 2026 08:48:45 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: "luka.gejak@linux.dev" <luka.gejak@linux.dev>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: RE: [PATCH v2 11/11] wifi: rtw88: run the RTL8723BS association
 register sequence
Thread-Topic: [PATCH v2 11/11] wifi: rtw88: run the RTL8723BS association
 register sequence
Thread-Index: AQHdHEb/KrivPqpz/0SOkFGQL9rTRbaBHE5wgAQTsgCAAKQ5IA==
Date: Fri, 31 Jul 2026 00:48:45 +0000
Message-ID: <c697b23e723f4cab875e2c01fe6defc0@realtek.com>
References: <611b495996b74b278bfd769a9c045582@realtek.com>
 <20260730074504.19725-10-luka.gejak@linux.dev>
In-Reply-To: <20260730074504.19725-10-luka.gejak@linux.dev>
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


luka.gejak@linux.dev <luka.gejak@linux.dev> wrote;
> On 27/07/2026 09:33, Ping-Ke Shih wrote:
> >> +       if (rtw_is_8723bs(rtwdev)) {
> [...]
> > I'm surprising that RTL8723BS needs so many special handing. Can you re=
duce
> > them? At least, use rtw_chip_prepare_tx() to implement its specific
> > functions.
>=20
> Done. v3 adds a chip_ops::prepare_tx callback, and
> rtw_ops_mgd_prepare_tx() is back to a single common path:
>=20
>         mutex_lock(&rtwdev->mutex);
>         rtw_leave_lps_deep(rtwdev);
>         rtw_coex_connect_notify(rtwdev, COEX_ASSOCIATE_START);
>         rtw_chip_prepare_tx(rtwdev, vif, info);
>         mutex_unlock(&rtwdev->mutex);
>=20
> rtw_chip_prepare_tx() calls the chip callback when one is set and
> otherwise keeps the existing deferred RF calibration, so no other chip
> changes behaviour. The RTL8723BS callback does the IPS wake and the
> join sequence, and the chip driver in the follow-up series points
> .prepare_tx at it. That also removes the chip test from the helper
> below it, per your comments on patch 05.
>=20
> On reducing the rest: this patch is smaller in v3, but not as much as
> I would like, and I want to be straight about why. Two things went:
>=20
>  - the beacon wait, once you made me measure it (see my reply on
>    patch 10), which took struct rtw_auth_sync with it

I see the result is positive, so this part can be removed, right?

>  - two dead bool arguments, rtw8723bs_auth_rx_filter(accept_all) and
>    rtw_coex_8723bs_restore_pad_ctrl(keep_pta_owner), both of which had
>    a single value at every call site
>=20
> What is left is the vendor start_clnt_join() register programming
> itself: the BSSID-scoped receive filter, the response and basic rate
> set from the BSS rate elements, preamble and slot time, TSF update, the
> retry limit and the security config. I have removed these individually
> on hardware and association fails or the AP drops us shortly after,
> which is why they are still here rather than because I have not tried.

I think you can implement these by chip->ops->mac_init(rtwdev);

>=20
> If the concern is that it sits in mac80211.c rather than a chip file, I
> agree, and I would rather move the whole rtw8723bs_* block into
> rtw8723b.c in the driver series than leave it in the common file. It is
> in mac80211.c today only because this series lands before the chip
> file exists. Tell me which you prefer and I will do it that way.

So the order of patches might be
1. add specific handlings for RTL8723BS for common flow
2. add RTL8723BS (but not enable right now)
3. add *very* specific handlings for RTL8723BS for common flow
   Here *very* means a lot of difference like you mentioned.
   But if without this part, the RTL8723BS still can work (not perfect),
   the step 4 can go ahead with step 2. Need your experiments to
   confirm.
4. enable RTL8723BS by Kconfig/Makefile

Ping-Ke


