Received: from enxio.de (enxio.de [91.210.227.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322F125A321
	for <linux-wireless@vger.kernel.org>; Sun, 30 Aug 2026 10:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.210.227.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788086589; cv=none; b=cCpOtC8OX17HEjSMbRv0SDldj2ZFVR5RvVYMVnTxcSVpTM+23bH+IpXxTmsolCmfsRxWtlB9hzFN73SeimOF8E3BInnmVkeiLf3dwLSvsobBRYSj6oDe/FSpVXWhr5AzYGKphRoEFZuC4lwF8XSgSVZ9AfAmnMLMp4tDcRiC960=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788086589; c=relaxed/simple;
	bh=cQk0OPgvZsbNcuW0kyCvd4bbvbaJ+/nG6CHx2Y8fOJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zlvlr544Q0WFj1uQZbIkwgWHGkzdBMs0yJinxzXXgF5EGBoAz2jz6P/Py5lVqRzm3L0xFH2yPKZXXTeY5gsy6cwo84luVQo/rlJc5Yuj0QT3q6OfkuVxTJ9Vlw8hXe4pXuRgccU1HWDhDqI7RIVnwm0vorcAbW81XMEfEZCycY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=enxio.de; spf=pass smtp.mailfrom=enxio.de; arc=none smtp.client-ip=91.210.227.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=enxio.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=enxio.de
Received: from [95.157.48.181] (helo=roja.toh.cx)
	by enxio.de with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <anthrop@enxio.de>)
	id 1x0d06-0000000854c-18iz;
	Sun, 30 Aug 2026 12:42:58 +0200
Received: from localhost ([127.0.0.1])
	by roja.toh.cx with esmtp (Exim 4.94.2)
	(envelope-from <anthrop@enxio.de>)
	id 1x0d05-002BfQ-M0; Sun, 30 Aug 2026 12:42:57 +0200
From: Thomas Hilber <anthrop@enxio.de>
To: Devin Wittmayer <lucid_duck@justthetip.ca>
Cc: linux-wireless@vger.kernel.org,
	ath9k-devel@qca.qualcomm.com,
	linux-mediatek@lists.infradead.org
Subject: Re: AP drops STA data frames for ~130-170ms after 4-way handshake
 completes (ath9k_htc, mt76; not brcmfmac)
Date: Sun, 30 Aug 2026 12:42:36 +0200
Message-ID: <20260830104236.521389@enxio.de>
In-Reply-To: <20260829232532.29622-1-lucid_duck@justthetip.ca>
References: <20260827074442.826644@enxio.de>
	<20260829232532.29622-1-lucid_duck@justthetip.ca>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Sat, 2026-08-29 at 16:25 -0700, Devin Wittmayer wrote:
> Your Atheros access point will skip hardware encryption if you ask it
> to, with the nohwcrypt parameter.
>
> If the gap goes with it, that is your answer for the price of a reload.

It goes with it, and it takes the whole effect with it.

AP4 from my table (AR9271, ath9k_htc, kernel 6.18.39). Same station, same
hostapd, same channel, same bridge, no other station associated; the two
arms were alternated and differ only in the module parameter:

  ath9k_htc         n     connect attempts   >1 attempt   TCP connect
  --------------   ---    ----------------   ----------   -----------
  nohwcrypt=0      216          5.20            97%         134.9 ms
  nohwcrypt=1      302          1.06             3%           4.1 ms

For reference, the AP4 row of my original mail was 105 cycles at 5.04
attempts and 134 ms, taken 11 days earlier. The hardware-crypto arm above
reproduces it to within noise, which is the best evidence I have that
nothing else about the bench moved in between.

Attempt distribution, since the shape matters more than the mean:

  nohwcrypt=0    1:6   2:27  3:24  4:17  5:71  6:29  7:13  8:7  ... 16:1
  nohwcrypt=1    1:292 2:6   3:1   4:2   5:1

Under software crypto 292 of 302 associations placed their first frame
successfully. Under hardware crypto 6 of 216 did.

Two caveats, both of which cut against the result rather than for it.
Cycles where the station never got a reply at all are excluded above: 33 of
249 hardware-crypto cycles and 22 of 324 software-crypto cycles. Dropping
the hardware side's worst cycles understates the gap. And a late arm in the
session degraded for unrelated local reasons and was discarded whole rather
than pooled.

One corroboration measured at the AP, which does not depend on the station's
TCP target at all - completed four-way handshakes in fixed 120s windows,
with the station associating and deep-sleeping in a loop throughout:

  nohwcrypt=0     64, 65 associations per 120s
  nohwcrypt=1     87, 86 associations per 120s

About a third more cycles in the same wall time, which is what you would
expect if every cycle stops losing ~130ms to the dead window.

So the split in my table is not SoftMAC vs FullMAC. It is where the key
lives, exactly as you said - the same driver, on the same silicon, in the
same box, lands in either column depending on one module parameter.
Espressif and brcmfmac looked clean because the key is already in the device
by the time the port opens; ath9k_htc and mt76 look bad because the port
opens first and the key is still on its way to the chip.

That also fits your reorder-buffer point: with hardware crypto the frames
are ACKed, so they have been through the reorder window before they are
discarded, and no hole ever opens.

I have not instrumented the key-install path itself, so I still cannot say
whether the right fix is to defer authorization until the key is confirmed
installed, or to buffer rather than drop in that window. Happy to test
patches, or to run whatever tracing would distinguish those.

Thanks - that was a good call, and a cheap one.

Thomas
