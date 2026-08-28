Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6273B3914E0;
	Fri, 28 Aug 2026 09:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787909388; cv=none; b=V8e7UZhaflt4PB+2gf8jcnpZCY0eDDbwGrmzOyLka/aKudIgMIZ3+mNzk/+cRwQziHh9E1Xz2GA6CTYOh1UUOeMPiNEhYD+G2fLBXXmqFGqLEG2eWdTwJwrr0DU8knjE0suJZtEFKsM24qdEfbm52iCCKMGWtPW4qKHw9lbjlHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787909388; c=relaxed/simple;
	bh=T7LTFPQNUrpMCRHUrvV/hIU1yfZl3MIgfMInpcIB3ZQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BDpdvog17a7WJzNyoNbDTDP9hSEkFBbB1kznUaMg4W8o8FYejhh/h3b+I0w8rFXgc41GjFmRXkLK7Yj8DFD7BS7zwf64qN8uglJ2wkU87+xdVF6NG2UFSRVUPyjbErtyN47sznM6qgeZyzJyNxKUgXgDKWXNAv8ul1x4mPCq0x0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=N4lhGmkS; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="N4lhGmkS"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67S9TU4302324824, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1787909371; bh=T7LTFPQNUrpMCRHUrvV/hIU1yfZl3MIgfMInpcIB3ZQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=N4lhGmkSn1DWJPuPgQYlILMPWNF+KEVwDHqzbCFAkxXYWDAMdheWMrNA5SEfX9H/m
	 cQ1YBnyMsi5TW1Twa8bxmfBKnoQyeolD7nMAAqZA97uXdo9gXwSm6xcLZBQhOZT2lu
	 hx1bleP64rxGVyFpfz4KmKd+2ZQUFuCFA4wBTRbh180bQJOZwNPzegICspV0ahNe9+
	 vfMbRXugJFxLimJC0XFCl+IvCIGfRXMeScOEW8YhcR1/tZ558VcEJfFDso9LFKZWYk
	 XLBa8P9NbVPVyoQ4rFKJchTsArKnw8QRCW2gqPTDRf3CpuU0Hl+ALMzRbRNu/VSkLP
	 LA234AJWEbTDA==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67S9TU4302324824
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 28 Aug 2026 17:29:30 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 28 Aug 2026 17:29:30 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 28 Aug 2026 17:29:30 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Fri, 28 Aug 2026 17:29:30 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: "luka.gejak@linux.dev" <luka.gejak@linux.dev>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Bitterblue Smith
	<rtl8821cerfe2@gmail.com>, Peter Robinson <pbrobinson@gmail.com>, "Hans de
 Goede" <johannes.goede@oss.qualcomm.com>
Subject: RE: [PATCH v8 6/6] wifi: rtw88: sdio: add TX back-pressure and retry
 on page starvation
Thread-Topic: [PATCH v8 6/6] wifi: rtw88: sdio: add TX back-pressure and retry
 on page starvation
Thread-Index: AQHdNK+IjpEKOkCBYUSn8WCDtzqU1bazNQUQ
Date: Fri, 28 Aug 2026 09:29:29 +0000
Message-ID: <abbadda4537640eab1bce5620ade5f47@realtek.com>
References: <20260825163314.1590-1-luka.gejak@linux.dev>
 <20260825163314.1590-7-luka.gejak@linux.dev>
In-Reply-To: <20260825163314.1590-7-luka.gejak@linux.dev>
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
> Two problems show up on RTL8723BS uplink. The per-AC software FIFO is
> unbounded, so mac80211 keeps handing frames down until latency collapses
> under load. And when a transfer cannot be completed the queue is simply
> abandoned for that pass, which stalls the AC until something else kicks
> the worker.
>=20
> Stop the mac80211 queue once a data AC fills past a high watermark and
> wake it from the drain path when it falls back to a low one. Both sides
> take the TX queue lock across the length check and the flag update, the
> way rtw_pci_tx_write() and rtw_pci_tx_isr() use irq_lock. Without it the
> producer could stop a queue on a length the drain path had already
> emptied, having seen the flag still clear and so skipped the wake, and
> the AC would have stayed stopped with nothing left to wake it.
>=20
> Convert the TX work item to a delayed work and re-arm it when a transfer
> fails for a reason that can clear on its own, so it is retried rather
> than the AC abandoned, and cancel the work on teardown.
>=20
> Retrying matters once the queue can be stopped. A stopped queue is
> handed no further frames, so nothing else would kick the worker, and the
> AC would stay stopped for good with the link still up and receive
> unaffected. The two retried cases, a transmit page or output queue
> shortage and a failed skb expansion, are also the two that fail
> silently; the rest are logged where they happen, so they are visible
> rather than an unexplained hang, and they keep the existing behaviour
> rather than being retried indefinitely.
>=20
> Measured on RTL8723BS hardware, uplink goes from 11.9 Mbit/s with 204
> TCP retransmits to 20.1 Mbit/s with 2.
>=20
> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>

The v8 is almost done. Only one small nit.=20

Since I don't test the RTL8723BS at all, please test it by yourself
carefully. At the last review (I think v9), I will focus on the changes
of this patchset doesn't affect existing chips.=20


