Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E0DE3537FB
	for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 07:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787727817; cv=none; b=h82cYJTfOYOCabk4WM/DH6ixITWcyxW1QHzQaHJJf/JGv7N0IF/N0egNtgJAKjs6ejRc/PJNBxoQ6d5Hwxs2KX1hlxXFH563RuRu1WSA3+FMcJHeaII4AgDcJ3dqvNbHunq94HQO2OZTJTHk4B9dQRVUow6ZDjftLb4UKV4F7ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787727817; c=relaxed/simple;
	bh=MyX0yAops1+75R1pwZ0rLCW2gFTqz6P/8DNu8GTzgoY=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Tv10h4p7JIbWQ35ysZ2uLFOX85Oh6rlmevMGgn9k1vIs7kU+tGl3veMTozo9pPj1uzZ3iaSVWFgDMHL9A7W9kGf6WysemJvQ0dWEz8NgJfVLv46y2KAehf4F/OzeaDIlrbV0JcLDkXhiAEbOHfF+Fz8T/bmy64PLIVy1d5Q6P1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=TyGUuHzJ; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="TyGUuHzJ"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67Q73Uc84364056, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1787727810; bh=qachGVxptJC1JeMG91RSil+GHjUs9OCy4PiqoEptV8k=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=TyGUuHzJ1is5yeMI3qy26giC01W6NE9uAN2xBQuCRGihKTamDEkoDNioFiVUOJNr9
	 Bwwrco6seg72ffDariv3qxFQnMrZw+zokjGNVkn33cZZ21vK6jtM35TI5JzWHXyGgk
	 MFGu71aHFpxbFwL1EX+tQ2E8qdyvlPvfqOgs6xV7JYyCUdAM1S3aZuE5EWxrAlGiVG
	 yBI+xErSia9pUPpEa+3DeMByVaxqD57FnDL4FXIhX6yKfFtkXG7BA0pNBs6CvzXdna
	 I+qoLUVIq4X5Lj33qwXhEGq/HqFU4sD4+w+7bbqKtULa/UwC+d/F/cMgkZTNIjrg9H
	 XTioUTW5KFSww==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67Q73Uc84364056
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 26 Aug 2026 15:03:30 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 26 Aug 2026 15:03:31 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 26 Aug 2026 15:03:31 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Wed, 26 Aug 2026 15:03:31 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: andres parra <andres.parrab@gmail.com>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>
Subject: RE: [RFC PATCH 0/4] wifi: rtw89: add NL80211_IFTYPE_P2P_DEVICE
 support
Thread-Topic: [RFC PATCH 0/4] wifi: rtw89: add NL80211_IFTYPE_P2P_DEVICE
 support
Thread-Index: AQHdMl2v7tQ2zv4uLUO5Yj5iw+rPVLav6JQw
Date: Wed, 26 Aug 2026 07:03:31 +0000
Message-ID: <fe4778c07f644ed38a03c467ef1293d7@realtek.com>
References: <20260822174229.65643-1-andres.parrab@gmail.com>
In-Reply-To: <20260822174229.65643-1-andres.parrab@gmail.com>
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

andres parra <andres.parrab@gmail.com> wrote:
> Hi,
>=20
> I'm not a professional kernel developer -- this is my first
> substantive contribution to this subsystem, so please bear with me if
> anything here doesn't follow convention, and I'd appreciate direct
> correction on anything I've gotten wrong.

You should apply your patch to kernel tree, and generate patches.
Otherwise, the path is wrong:
   diff --git a/core.c b/core.c

For Realtek WiFi drivers, the tree should be rtw-next [1].

It seems like you repeatedly describe similar messages in every
patch. Not sure if this is because the 4 patches are small.=20

[1] https://github.com/pkshih/rtw.git rtw-next

>=20
> rtw89 does not currently declare NL80211_IFTYPE_P2P_DEVICE anywhere in
> interface_modes, which means wpa_supplicant/NetworkManager can never
> create a real P2P-Device wdev on this hardware, and Wi-Fi Direct
> casting (Miracast/WFD) to a smart TV never works: GO negotiation never
> even starts. Confirmed absent across every rtw89 chip variant, not
> just RTL8922AE. mt792x (mt7921/7922/7925) implements this correctly on
> comparable modern, MCU-firmware-based hardware, and was used as the
> reference model for this series.

We have developed this recently [2]. Please take patches 11/14 ~14/14
and test if it works in your side.

[2] https://lore.kernel.org/linux-wireless/20260826064101.58892-12-pkshih@r=
ealtek.com/T/#u

>=20
> 1. If the AP the STA link is associated to does an ordinary channel
>    switch (CTRL-EVENT-CHANNEL-SWITCH) onto a different channel than
>    the one an active P2P-Client group is using, the P2P link is
>    dropped outright (beacon loss, then a locally-generated disconnect)
>    and never re-established automatically. I don't know whether this
>    is a pre-existing limitation in the existing MCC entity-management
>    code (rtw89_entity_mgnt / chan.c) that would reproduce identically
>    with a stock, unmodified P2P_CLIENT/GO connection unrelated to this
>    series, or something specific to a P2P-Device wdev being present.
>    Have not yet had the chance to test against a stock driver to
>    isolate which.

Could you try the same test on the patches I mentioned above?
And, share the test flow step by step.

>=20
> 2. If the STA link and the P2P-Client link end up on genuinely
>    different *bands* (STA on 5GHz, P2P on 2.4GHz -- WFD is 2.4GHz-only)
>    rather than just different channels on the same band, the
>    connection stays up but has a real, repeatable performance cost --
>    confirmed clean at the RF link level (zero tx retries/failures on
>    the P2P link, good signal, decent PHY rate throughout) via
>    `station dump`, so it doesn't look like a radio-quality problem.
>    Grepped this driver for any equivalent to Intel iwlwifi's CDB
>    (Concurrent Dual-Band, IWL_UCODE_TLV_CAPA_CDB_SUPPORT, a distinct
>    LMAC per band) or MediaTek mt76's DBDC (Dual-Band Dual-Concurrent,
>    MCU_EXT_CMD_DBDC_CTRL) -- found nothing under either name. Is that
>    because RTL8922AE genuinely lacks equivalent hardware/firmware
>    capability (in which case this is a real ceiling, not something
>    software can fix), or does it exist under different terminology I
>    haven't found?

rtw89 doesn't support dual bands concurrency simultaneously, it uses
power saving mechanism to do TDMA timeslot sharing.=20


