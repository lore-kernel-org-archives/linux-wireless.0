Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.20
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792427448;
	b=RKx6R2CCaBkGBBGf7S0cav+h1D93IeZ/gQVsw9K0Ny4mvQyUKCFZnK+pNX1r8ZFkpNjB
	 fjtzTNd/9vnLWEDvbbqQRSN7+ZwyTuONmVbv+fCUQvCGRUvwPS3LyoImg/ye9G08d7jqK
	 I+VTWpB16DIqL7/87admjTiRWydAanEXINOgAR3/keibbDrK3OHTwS7C1PKEe22evRJMn
	 AsCsuCU7QX2YBaq1WKMkSRYXmI8yYktczwdXQLIvNFyoFcJUmv8ElYellxxIq1JevkFJF
	 y/FJFSOpYSRg1RNiumDcD6lZWjcmSJYAm3r9sT1BeaVY98Eo+qsfh1ctO8ILKZ4EfFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792427448;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Mime-Version:Content-Transfer-Encoding:
	 Content-Type:Date:Message-Id:Cc:Subject:From:To:X-Mailer:References:
	 In-Reply-To;
	bh=kL2rOp/FeUe8DM6g8QddsPE+Y9Jl6Wg6RVg4JpcMwzY=;
	b=l6Ivp2Ws/u/Q7QIUoGykEdBUfCjkpTX6wfzOXgN3p/WXGpB8alx201ajEfGy2nH3aVTR
	 pe9EwgH53k524QdLudTzPDzctSzwzj7Ax6KJlLYHthTPlsEg0wxcadQglYr7zyoG8y8f9
	 aPzZoSsQ3axKByvAbaVCQCq0BYHVgyZxNGXZu3n8b80gNjpyl9iYrQ/EE3b91UIcXHHCC
	 +7n57dz9yWw/kqKowpN2eS0huTU00JzDVvP8+JUUTQwgwlgFF46w3cTLItBbJ5V87s+JH
	 5RocKs4B7e+g39GZc3TgbOOnI3LIdV3swefAiPY9sEa6AT+62IfGUmBdzr/VEwRnxdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=D5vcdmfP;
	arc=none smtp.remote-ip=95.215.58.20
Received: from mta1.migadu.com (out-20.mta1.migadu.com [95.215.58.20])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83062606A331
	for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2026 16:30:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 83062606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=D5vcdmfP
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=kL2rOp/FeUe8DM6g8QddsPE+Y9Jl6Wg6RVg4JpcMwzY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792427445; v=1; x=1793032245;
 b=D5vcdmfPi5GA8KYoOcHdMz6lZTvIdDjXF/R22kplAs9qvUPXFD2v/81YDge5WMtkWnuTzk2u
 FJK3e1nG5vxZ+ZcjuOU8u+P1pDEOmyGWE6LVQ/TCIWLj+h4izl3M11Zn3vxLlxHVYlfHF65ZiMh
 f4J1h7FHXwKoV/VgPx7SF1Qk=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 287b06d509870c9e;
	Mon, 19 Oct 2026 16:30:45 +0000
X-Mizu-Trace-ID: 287b06d509870c9e
X-Migadu-Flow: FLOW_OUT
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 19 Oct 2026 16:30:44 +0000
Message-Id: <DM8YI0GAO2B6.235M23CNMOOA2@linux.dev>
Cc: "Bob Beckett" <bob.beckett@collabora.com>, "Ping-Ke Shih"
 <pkshih@realtek.com>, <linux-wireless@vger.kernel.org>,
 <kernel@collabora.com>
Subject: Re: rtw88: 8822CE passes corrupted A-MSDUs as hw-decrypted,
 poisoning CCMP replay counter
From: "Luka Gejak" <luka.gejak@linux.dev>
To: "Matthew Leach" <matthew.leach@collabora.com>, "Luka Gejak"
 <luka.gejak@linux.dev>
X-Mailer: aerc 0.22.0
References: <20261016191100.1781056-1-bob.beckett@collabora.com>
 <3839685695b77706f39cfdef192e1d137e9d46bc@linux.dev>
 <87wlrdc13e.fsf@collabora.com>
In-Reply-To: <87wlrdc13e.fsf@collabora.com>

Hi Matthew,

On Mon Oct 19, 2026 at 12:43 PM UTC, Matthew Leach wrote:
> The fresh header followed by unexpected contents is consistent with an
> incomplete write, although I don't think we can distinguish that from
> consuming the buffer before all payload writes are visible. Could we
> compare the RX buffer contents when completion is first observed and
> again before returning the buffer to the hardware? If the contents
> change while the buffer is still host-owned, that would support
> premature completion signalling.

Good idea, but Bob's report says the RX buffers go through SWIOTLB, so
skb->data only gets updated when we call dma_sync_single_for_cpu(). A
late write would stay in the bounce slot and you would never see it
change. The second read needs another dma_sync_single_for_cpu() before
comparing, so doing it only for frames that fail the CCMP header check
keeps it cheap. A run with the IOMMU on would be worth trying too.

The old descriptor in drv_info could also be leftover data from the
device's RX FIFO, which would fit Bob's idea as well.

> However, all four captured bad frames have ICV_ERR clear, so
> checking that bit alone would not catch these examples.

Right, the ICV part doesn't help here, it's only there to match rtw89.
I'll make that clear in v2.

> However, jump 3 has valid reserved/ExtIV bytes (44 50 00 20) and
> corruption in the remaining PN bytes, so this patch would retain
> RX_FLAG_DECRYPTED and still poison the replay counter.

Agreed, it only narrows it. Checking for the LLC/SNAP header after the
first A-MSDU subframe header would catch frame 3 too, but that's a
guess about the payload. I'd rather see what the test shows first,
since that tells us if the fix belongs in the driver or in the device.

Best regards,
Luka Gejak
