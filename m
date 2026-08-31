Received: from enxio.de (enxio.de [91.210.227.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F263AAF5A
	for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2026 05:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.210.227.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788155274; cv=none; b=ultdqqmYc/kB0zOnm5HZamaF3Z2AKt3GkXW0in94fkG0knEjnF08JqRCR0avmU2HdJZgoyT3ENHzBq1J0xL2xJEPUIoxZOnLBISbB9BUrd77kJ1FVVynN+erFgU+1B2s186Pw0K7BHBn3aC2+SzJqFCkT6UxpIoBltrPt1Hmqac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788155274; c=relaxed/simple;
	bh=5FOmbZPUQirDZUBgCl7rmOhHZq2VfX6H6uJunNL1HeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KSns+o7BxDkxfkRG5SaEklGBkKA0vp9r7hukuQ+D7jBSwuZ0BMDvfjpuGK9x38Kp0iNnSM0CJvIiwI6thX5smR5weE8Q/S2GAuiBk3GfVObBvrFkm2QYglPtwzdUrPCsJX9QcbtWukKBscDZOwIbV9k0YPWWfuzdOjtz8gaTFok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=enxio.de; spf=pass smtp.mailfrom=enxio.de; arc=none smtp.client-ip=91.210.227.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=enxio.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=enxio.de
Received: from [95.157.48.181] (helo=roja.toh.cx)
	by enxio.de with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <thomas.hilber@enxio.de>)
	id 1x0us1-00000008J08-3dMs;
	Mon, 31 Aug 2026 07:47:49 +0200
Received: from localhost ([127.0.0.1])
	by roja.toh.cx with esmtp (Exim 4.94.2)
	(envelope-from <thomas.hilber@enxio.de>)
	id 1x0us1-006TfZ-2v; Mon, 31 Aug 2026 07:47:49 +0200
From: Thomas Hilber <thomas.hilber@enxio.de>
To: Devin Wittmayer <lucid_duck@justthetip.ca>
Cc: linux-wireless@vger.kernel.org,
	ath9k-devel@qca.qualcomm.com,
	linux-mediatek@lists.infradead.org
Subject: Re: AP drops STA data frames for ~130-170ms after 4-way handshake
 completes (ath9k_htc, mt76; not brcmfmac)
Date: Mon, 31 Aug 2026 07:47:40 +0200
Message-ID: <20260831054740.1543875@enxio.de>
In-Reply-To: <20260830190028.20209-1-lucid_duck@justthetip.ca>
References: <20260827074442.826644@enxio.de>
	<20260829232532.29622-1-lucid_duck@justthetip.ca>
	<20260830104236.521389@enxio.de>
	<20260830190028.20209-1-lucid_duck@justthetip.ca>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Sun, 2026-08-30 at 12:00 -0700, Devin Wittmayer wrote:
> Worth a look in your own captures: the starting sequence number in the
> request against the sequence number of the first frame after it.

Done, and it does not hold here. The window is filled correctly and my
stall happens anyway.

First, in case it is useful to anyone: I have only the one radio, and it
is the access point under test. It turns out ath9k_htc will give you a
monitor interface on the same phy while hostapd is running on it:

  iw dev wlan1 interface add mon0 type monitor

No second radio needed. (Use "iw dev <dev>", not "iw phy phyN" - rmmod
plus modprobe renumbers the phy, which cost me a run.)

Air capture and the AP's netdev, captured together, so the sequence
numbers and the stall are measured on the same associations:

                        station side          TID 0     SSN      seq==SSN
                                            sessions  declared   arrived
  nohwcrypt=0    5.36 attempts, 134.9 ms       259     0 in all   256/259
  nohwcrypt=1    1.01 attempts,   3.8 ms       348     0 in all   345/348

n=249 and n=342 cycles respectively. Of the 256 arrivals under hardware
crypto, 237 were fresh transmissions rather than retries.

So on this hardware the reorder window opens on zero, zero arrives, and
the 134.9 ms is still there. Whatever holds my frames, it is not a slot
that can never be filled.

One thing that did reproduce your signature, and then disqualified
itself. My station opens three sessions per association, TIDs 0, 5 and 7.
TID 0 carries the traffic. TID 7 declares SSN=2, the first frame to
arrive under it is seq 0, and the declared SSN never arrives in about 97%
of sessions - exactly what you describe. But it is 251/259 under hardware
crypto and 340/348 under software crypto: the same mismatch, at the same
rate, in the arm that has no stall at all. So the pattern is real here
and simply does not track the symptom.

I would not lean on my TID 7 numbers anyway. It carries 538 frames
against 3116 on TID 0, and if my station keeps one sequence counter
across TIDs rather than one per TID, a per-TID comparison there is
meaningless. TID 0 is the measurement I trust.

I also timed the first frame of each cycle from the air to the AP's
netdev: 22.2 ms median with hardware crypto against 2.4 ms with
software. The right direction, but an order of magnitude short of the
135 ms, so the frames are not simply being held for the whole window
either.

Which leaves the two of us with different mechanisms producing timings
that look alike. Mine responds to one module parameter and does not
involve a reorder hole; yours involves a reorder hole on a part that has
no such parameter to test. It may be that a missing first frame is
sufficient but not necessary, and that hardware key install can also
stall delivery some other way.

If your MT7922 will hand you a monitor interface on its own phy the way
ath9k_htc does, the cheap check on your side is whether your slow cycles
survive a session where the declared SSN *does* arrive. If they do, we
are looking at one mechanism with two symptoms; if they never do, we
have two.

Captures available if anyone wants them.

Thomas
