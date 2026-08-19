Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7713B27F3;
	Wed, 19 Aug 2026 00:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787100782; cv=none; b=e2CRthQsLL/erHbY0EllSgRNdzll8iAjbQJXsutdvTHOV7d5i+8BesC/eELM68uC8UJxCxeP2MDGCbfd0LdKDzyGrbB4G11a95lja/lKWOlzwRrHbt1tX9gCGc+MgUX5OB6Xw+vcOWu3/HfATddjnm8jQFiHMLRitO75/67AXFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787100782; c=relaxed/simple;
	bh=qa7tXu5ZrwBdf2KAuckdCPCp2E5qD6MYrBpY67Ehak8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=s/J29XgOZDD+KxjoUcq9SBuqtYQwEU9aRlVA4uFzg4Yjd1M/lu3WbqP95njD6PIkuA2gGoFMt2uVMYxcMt6w1BxyjiY9F+AK18eu3Arjd5eDyU5fZEo47Ouda52OGq6wCY4rgWDDloGEtWRfmNV96JI9Ke8A4GUWleuUdilxNCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=CGQQrlhu; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="CGQQrlhu"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67J0qD1R11921871, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1787100733; bh=qa7tXu5ZrwBdf2KAuckdCPCp2E5qD6MYrBpY67Ehak8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=CGQQrlhukzvpuxDaOBXaY320AjL/qm2EmO/k8E/BFqUnIO+QTYOEFMfNYg6BxA62s
	 u9NkcHP+U16UolftmPN4pywPsldIc/AFYOaGT8a9iP5agEBHy64CKwgLVpRGYywhp9
	 IfqVsPlFM5pqdbTeSyNtQltgLCSNSYP9qz4bTIW6z+zhhEDbouYjT0vgW/cDvPPOG6
	 qegUuXLo7qzP0067XLGn9MdK/xN2zCHijdNrE0vhU/8qSjCJtM9kKIB4yFoBKLLNlf
	 P7a9/MkFE2XiE43vGZmMbCuDIbn4l0jYxM2BDfwbQk1Qs2ioKnon0AfAB0Bb6EQSIr
	 Rz5uffGb2gJ9Q==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67J0qD1R11921871
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 19 Aug 2026 08:52:13 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 19 Aug 2026 08:52:13 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Wed, 19 Aug 2026 08:52:13 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: "luka.gejak@linux.dev" <luka.gejak@linux.dev>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Bitterblue Smith
	<rtl8821cerfe2@gmail.com>, Peter Robinson <pbrobinson@gmail.com>, "Hans de
 Goede" <johannes.goede@oss.qualcomm.com>
Subject: RE: [PATCH v5 4/6] wifi: rtw88: sdio: track free TX pages and OQT
 credits for RTL8723BS
Thread-Topic: [PATCH v5 4/6] wifi: rtw88: sdio: track free TX pages and OQT
 credits for RTL8723BS
Thread-Index: AQHdK9tCqyxnhyUGWE+jlBV+8Tu4fbakkh6g
Date: Wed, 19 Aug 2026 00:52:13 +0000
Message-ID: <c4844a1ac6784c9ebb2f8113ab340268@realtek.com>
References: <20260814105327.6687-1-luka.gejak@linux.dev>
 <20260814105327.6687-5-luka.gejak@linux.dev>
In-Reply-To: <20260814105327.6687-5-luka.gejak@linux.dev>
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
> Transfers also have to be padded up to the SDIO block size for this
> chip rather than using the generic alignment, so size the write
> separately from the frame and trim the skb back afterwards.
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


