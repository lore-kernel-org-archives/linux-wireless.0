Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.226
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792643446;
	b=27Hqr4LmP584RrsQfNf6uoXk+NodpONOPNTXKj3KAn2nxcgeyTpw1fkizeWNYn0514yk
	 NeB9B9XNN74lZfW+7Wy0GQvdbugq4WAxhNXOW3YJZqAzZP9/+EAkhrCPYwpEsOJDMUlxm
	 mCkfuDnxImMweLJQZ35jMZe/bWt6wQrLkNS5GmqTgGsUhw8WXQ2lLatj1Q5mFxKu6Pu8o
	 iBmTqupSCw9ZkZN/FgP09IiLh9BSGhSZoRAEJJ9vAtGJRZQENXn+apfdoTk8ZvA9jEwes
	 y4NCHIehsBA5a8kJ6QbkHZZX7uaq/UWk5a/bbiqZ5qXXDXD1erN60g77S1FAqTi2Ohw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792643446;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:MIME-Version:Date:Content-Type:
	 Content-Transfer-Encoding:From:Message-ID:TLS-Required:Subject:To:Cc:
	 In-Reply-To:References;
	bh=S6I5aLF/kMHQsxm2JxtT1bSC3MaGwPmE2nZ05/LY/aI=;
	b=fQpr2I2FHrZ0fVyeIGuhuLJ1egr2yh4QBuNkAiv8ZGXY/PuxEhsjT+b9Dzk5eR5H2aSb
	 8m+1EUsbQU+wdqQtE18uftNnDIFsijY1EQbhDGfX1qTcQBBPJXybAE6LnpOpJOe0M09yt
	 hNGBRT3AQcvZcCNib/SnXGBltrtNqTSkS9DcfLQ4f1K15Yl1k8GY60UHEgg1SwV9E+GbA
	 KF0xTv9g/LEQ+FsTlULik7iemUICB9JVDKfShTg9HW9d2Xj5e3CQXM/NJiBrpq3PgT8Da
	 OM13gJrMh0ScUFfbFQuAExKNNbGMBovJ4BN92m6uJP8h5aisV3r1WQrQ2MnQ98fCFKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=qyt5N3Sm;
	arc=none smtp.remote-ip=95.215.58.226
Received: from mta1.migadu.com (out-226.mta1.migadu.com [95.215.58.226])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F218606A322
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 04:30:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9F218606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=qyt5N3Sm
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=w30GA5GV1AUqILbk56V0iFaCTvNcyVpADWQmPWWx8iI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792643442; v=1; x=1793248242;
 b=qyt5N3SmO44KsFBXUs/+6jkXlCW9dowy9xqu2QhIdG5eOti6OQYdtXdXBJf7tAwVNay00inZ
 nqvWMWlzdFxJVlRZKVKu0RZQ7wMTHpwM6llQftBs6glZIz7MAkX/5lSp9RJOuQ7ertvcvuV5l6m
 heWZDANd00Gp1S9JOeqL8id8=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 4362ee009ec7c095;
	Thu, 22 Oct 2026 04:30:37 +0000
X-Mizu-Trace-ID: 4362ee009ec7c095
X-Migadu-Flow: FLOW_OUT
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Thu, 22 Oct 2026 04:30:37 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <ea8ee18b36d7416c11ae4f1b4046aed087f87f1c@linux.dev>
TLS-Required: No
Subject: Re: [PATCH rtw-next v2 2/2] wifi: rtw88: sdio: limit the high queue
 to DTIM delivery
To: "Ping-Ke Shih" <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <ea2137c603f146738f8db100e905060a@realtek.com>
References: <20261021124318.15993-1-luka.gejak@linux.dev>
 <20261021124318.15993-2-luka.gejak@linux.dev>
 <ea2137c603f146738f8db100e905060a@realtek.com>

October 22, 2026 at 4:24 AM, "Ping-Ke Shih" <pkshih@realtek.com> wrote:


>=20
>=20Luka Gejak <luka.gejak@linux.dev> wrote:
>=20
>=20>=20
>=20> In AP mode every broadcast and multicast (bmc) frame is sent throug=
h the
> >  high queue, which the hardware only drains after a DTIM beacon. Only=
 a
> >  few frames leave per DTIM, so steady multicast traffic builds a back=
log
> >  that holds the TX pages the other queues need. Unicast traffic then
> >  stalls for seconds and clients can no longer renew their DHCP lease.
> >=20=20
>=20>  USB had the same problem and was fixed by commit c710c7c2e038 ("wi=
fi:
> >  rtw88: usb: route bmc frames via the high queue only for DTIM delive=
ry")
> >  and the two commits that followed it. Use the same rule for SDIO. A =
bmc
> >  frame goes to the high queue only when mac80211 asks for DTIM delive=
ry
> >  because a station is dozing, the frame is ARP, EAPOL or DHCP, and th=
e
> >  budget allows it. All other bmc frames go out on their access catego=
ry
> >  queue.
> >=20
>=20I'd remove second paragraph since it just describes the patch 1/2 doe=
s.=20
>=20

Would you be willing to drop it your when applying?

Best regards,
Luka Gejak
