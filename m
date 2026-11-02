Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793590594;
	b=EbTuIBqT4c2A0wnaZz/cT5As7/wQl26fBi4+TWXzhCBL/RMFe8+hGvavJvLde5qLpMV2
	 54oCBmH0X0M9xkbxohut+tDV/kRfMKxOFSJbBLJti7lmb5eaSr0JoVbKXnLdPUY2jY/x8
	 BeXtcS2O5foAr7d8iwH/fwpcdzxbv/Ei1wkBd4bZ76UNAkGLEdAsUowEcoj98YZIh29lU
	 5yu/tLUawWM0MJinLtp5F95MghSOJJqZh+GT9WlYhr+eZBvDkR6MbQj8rnuKyp0XZw2W6
	 Kr6Hky/MKvmPPOx3pbDGP37JbtnCrNow1YUhOHmAoIVYXBWAkA50jKCOSbpZyuV+haw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793590594;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:From:To:CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:
	 References:In-Reply-To:Accept-Language:Content-Language:
	 x-originating-ip:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=NkYadLpCf0jAi+yX5dNanaMa6UyF01581EeKVRM6XQE=;
	b=uKH8oDX1Zc47DjP1nyMG+eO2gR3/gDrbPFUTHZLDW7O5adfDJJyH4nMJc/CDCbpRh7eD
	 8Dp6HmGFD0iwgIBbzHh28rNtbfG4WxUoI0DJiuJe7pUUYWGA/oUrrEAOm6q5Wuc84rsPe
	 XPXRI0KvaMCLBpsiTr7G3f5o1Y4E8ympzWdls70GzRNzMlVI1k/qos3Td7PAfcozSG4LY
	 0uu5zf2q0Fh4MhKbMEZSz9Praj3CC4nXarX1zVKBj5iun4xSnlSIvyy4dSGhSD2QstYca
	 64fIO6X1JPtLlnaBTj5fgDTbILDJqT7fwfC5UJYmZgOL9BRix68b4yLDJbZ4RugOSTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=RS14g0ou;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86202606A324;
	Mon,  2 Nov 2026 03:36:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 86202606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=RS14g0ou
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6A23a1PP11823631, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1793590562; bh=NkYadLpCf0jAi+yX5dNanaMa6UyF01581EeKVRM6XQE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=RS14g0ou2aDk/rlBlXdPsHz9Y4eYeIx/n/smIuCdnViA4gLleqy2kKPGQpSeaJF69
	 eMQwQte7ypDfTcNQU3BaijgP/DcCsEZeYumur/6SKIuuEAmocGHiXSp5ZQ59dGg7Nc
	 7WBVXw0oXsIHrJzgAAoXmMXHoQo7NE8c8M4e6TL40pgu/evJPmd/qtNHezX1N50dVM
	 jX+oaDFFpSgohO5h9Gpegu0xZJkAcH2ZyI64SLnq/CYTMy3SrcdxhCY0anIYtrBztZ
	 /1BadKm4kTgV4IRM4YxoD00JR2Cis/+Sfj1tA4nCJTSpPu8VzB4FktdAu0U2qYTFti
	 17TmlDT05mRVg==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6A23a1PP11823631
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 2 Nov 2026 11:36:01 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 2 Nov 2026 11:36:02 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([fe80::eeeb:c765:ca73:5eef]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::eeeb:c765:ca73:5eef%10]) with mapi id
 15.02.2562.056; Mon, 2 Nov 2026 11:36:02 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Ho Jie Feng <hjf3108@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>, "Luka
 Gejak" <luka.gejak@linux.dev>, Sascha Hauer <s.hauer@pengutronix.de>, "Hans
 Ulli Kroll" <linux@ulli-kroll.de>, Kalle Valo <kvalo@kernel.org>, neo_jou
	<neo_jou@realtek.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH rtw-next v4] wifi: rtw88: usb: don't report the
 aggregation buffer as a frame
Thread-Topic: [PATCH rtw-next v4] wifi: rtw88: usb: don't report the
 aggregation buffer as a frame
Thread-Index: AQHdanrb3hYC3dqgrE6Qc7DM4PY/v7caIUmA
Date: Mon, 2 Nov 2026 03:36:02 +0000
Message-ID: <7065bd99615f46c59171e0fe1672f3a1@realtek.com>
References: <20261102033244.9330-1-hjf3108@gmail.com>
In-Reply-To: <20261102033244.9330-1-hjf3108@gmail.com>
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

Ho Jie Feng <hjf3108@gmail.com> wrote:
> When rtw_usb_tx_agg_skb() has more than one frame queued, it copies them
> into a new buffer. That buffer was also handed to mac80211, as one
> additional TX completion.
>=20
> Report TX status only for the original frames, and free the aggregate
> buffer without passing it to mac80211.
>=20
> In the case the ieee80211_purge_tx_queue is called, the frame is
> passed to ieee80211_report_used_skb. Since it fulfills none of the
> conditions within the function, the frame is freed as normal without
> a TX status in that case too

Miss a period. I'll add it while getting merged.=20

>=20
> Fixes: a82dfd33d123 ("wifi: rtw88: Add common USB chip support")
> Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
> Reviewed-by: Luka Gejak <luka.gejak@linux.dev>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>


