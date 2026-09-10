Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5439535C69C;
	Thu, 10 Sep 2026 02:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789008054; cv=none; b=VsuOWYimh4RceU4yZFNxAyTrpEbCOyf6dfpciIeQD/0RERMxCKXklMaNs4oVXsPLPItgRPnF60nwdJVD/RFkSs4kl+PGHvTsO3/tisebob0c6t8g1Vikr2ApmK/zdDTOJWj+A3kr54J//rpsE00cULmxSPtnmv5AYDayn2EnGAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789008054; c=relaxed/simple;
	bh=qFO0jTQBXXaL45Ge3elu9TFhAI69oOsEtteNa/WXtI0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eM4rS2B3bbOASN/+gC+d1ksPCA5wM3swVUzReN15eTjZnK3aj+lbn8R/+uG7x5aZ/1qwTe2Tv2KkT/KPtjgYBSlOQ4NpyzR81ay3qPGkq5t1/hkQGhHKuvPf/fAYNN9OyQ08EIOqW/TOndAJD8AGQOBOb/AoEMD5g6p8OK7RGOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=kU1lrjN1; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="kU1lrjN1"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68A2edk771120726, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789008040; bh=qFO0jTQBXXaL45Ge3elu9TFhAI69oOsEtteNa/WXtI0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=kU1lrjN1n360TdCM2PL9ElRKy9vYf0KHFmo8gapxnki7dXs+C+VyW5nHRNrzOvcEr
	 OOYdgR4Sv2EgKHcyft6wpS5UrMhNG2bAkcG0FoR/t3XKNALKfOjeORoaRrRuMozBvY
	 HLOGWjAgTkfsYXLEF/GaYGoj6fRpxnKz+YRwxcUfJNsNgHORZ4W5wcwYybrOFCRJqK
	 YeTtgApB57LEYoK/AieJkYxT1mrTj226cSLWpvsjYUYhEZI2e/s3CXDiQBx6vD6azp
	 eTxvEsMnkmkLVIFHq7aennmuXrr5E6XmHxRmiZbUuTt7C4odpVgEDaLjwWuaKOWzFr
	 jAL3EkqEd33vw==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68A2edk771120726
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 10 Sep 2026 10:40:39 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Thu, 10 Sep 2026 10:40:39 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Thu, 10 Sep 2026 10:40:39 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Thu, 10 Sep 2026 10:40:39 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: "luka.gejak@linux.dev" <luka.gejak@linux.dev>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: RE: [PATCH v11 5/7] wifi: rtw88: sdio: track free TX pages and OQT
 credits for RTL8723BS
Thread-Topic: [PATCH v11 5/7] wifi: rtw88: sdio: track free TX pages and OQT
 credits for RTL8723BS
Thread-Index: AQHdQC9YAxgQ7t6BwEqCwzl3Ie3kvbbHGw6g
Date: Thu, 10 Sep 2026 02:40:39 +0000
Message-ID: <351ffe7fa4d94b34ae6ce9984bb8b5b9@realtek.com>
References: <20260909074556.55709-1-luka.gejak@linux.dev>
 <20260909074556.55709-6-luka.gejak@linux.dev>
In-Reply-To: <20260909074556.55709-6-luka.gejak@linux.dev>
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
> The RTL8723BS reports free TX page counts that the generic 8051 path
> reads back from the chip on every transfer, which is both slow over SDIO
> and unreliable on this part: the register frequently reads back zero
> while pages are in fact available. It also gates transmission on a free
> count in the SDIO output queue, REG_SDIO_OQT_FREE_PG, which rtw88 does
> not track at all. The vendor driver calls this the OQT free space and
> never expands the acronym; the register holds the number of further
> transfers the SDIO output queue can accept, and the chip discards
> writes that arrive when it has run out.
>=20
> Mirror the vendor driver and keep the per-queue and public page counts
> in software, seeded at start and resynchronised from the chip only when
> the cached counts say there is not enough room. Wait for a free output
> queue entry before writing, and account for the pages consumed after a
> successful transfer.
>=20
> rtw_sdio_write_port() becomes a dispatcher. It works out the transfer
> address and the aligned transfer size, which both paths need, and hands
> them to rtw_sdio_write_port_8723bs() or rtw_sdio_write_port_generic().
> The transfer itself moves into rtw_sdio_write_to_port(), which both
> call, so the generic path is step for step what it was. The padding
> added by the previous patch stays in rtw_sdio_write_port(), so it still
> runs once for both paths and stays outside the credit mutex.
>=20
> The RTL8723BS path keeps a separate length for the accounting. The chip
> charges pages by the frame length rather than by the padded transfer, as
> the vendor driver does, and the two differ just above a block boundary:
> a 1025 byte frame is nine pages by length and twelve by the padded size.
>=20
> The check, the output queue wait and the accounting are serialised by
> a mutex. The TX worker and the H2C path reach this function
> concurrently, and two writers that both pass the checks can otherwise
> claim the same pages and output queue entry, after which the chip
> silently discards whichever transfer arrives second. The vendor driver
> avoids the same race by funnelling all transmission through one thread.
>=20
> Measured on RTL8723BS hardware against an iperf3 server one hop behind
> the AP, with the wlan0 byte counters as ground truth. On the generic
> path the association completes but no data passes at all: TCP and UDP
> both measure 0 bit/s in either direction. With this patch TCP is
> 25.3 Mbit/s up and 37.3 Mbit/s down, and UDP is 25.0 Mbit/s up at 0%
> loss.
>=20
> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>


