Received: from www.nmnhosting.com (watt.d-silva.org [119.15.109.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1AF1C2324;
	Thu,  1 Oct 2026 00:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.15.109.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790812997; cv=none; b=UCUIHzs0rgAhqd3B5wiUqBqRAjsmgVUkdHPZcia5cSqL+CwMjKUKtUuaVQfykpKo7hgEvJPgv1Lb9qs6//GYhoW1GQFkuV8DTq3jbFWU1Uul382NimD7Jh4EOR3HZgR1J5HAwdGPnfW6H5Uqs9/gENM0SupK6rah4WTWBq0S+nQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790812997; c=relaxed/simple;
	bh=GViyUVmqTg2P9U2OJWjmURssrjdim0K3kGrCSH6dgkU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Nu1OTqoPfHIzkhRhNLJ6k6krIIq/LSdtAr5OjU3/tsnOqe41yWsEpxNBvtJgOHRt5OAeUyE96LVFVTzb2ohbFdzcAjUUwtP5zr79EQ6zJjU137oMrZJPu4tuehDzH6xXwwM0ap8qNp+qzF4v8/V/3jhGJNjkyE8S1CbLozJGoig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=d-silva.org; spf=pass smtp.mailfrom=d-silva.org; dkim=pass (2048-bit key) header.d=d-silva.org header.i=@d-silva.org header.b=0I+9rrds; arc=none smtp.client-ip=119.15.109.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=d-silva.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=d-silva.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=d-silva.org header.i=@d-silva.org header.b="0I+9rrds"
Received: from Hawking.lan (hawking.lan [10.0.1.4])
	by www.nmnhosting.com (Postfix) with ESMTP id C3CD640350;
	Thu,  1 Oct 2026 10:03:03 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=d-silva.org; s=2025a;
	t=1790812983;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=E9uJa58LaWUi598Wh3ssv8KpfFrwJeJEEQqQAdTYEy0=;
	b=0I+9rrdsn8IJZnb7SCiprknWce96DtUfcDBshfWbArGKC7xZ6GhkgHerG3Cxq+/f4ui0uJ
	y2KOBcJdDZlcomsHBvIFrkEGjtt+geLHZd2Qgia0bteocVPmObtU9IjppdtfQmvcb+gcYg
	3v6RNdMvDRsrNhuJqhoy2zury7aRLeHsfABDwZseorlKMY9RZh903hP0yC2+vTO2/d1OWf
	0o/glrQTAWC3Ltzb0dX3JcZU7rt1iheuRZy01FTEaPoQlviIyS5DISPJsNuTmAXzv2CFiZ
	aGdGElQ7FZ64Itq81keG38CbZPYbnraNIua6BqOBUXwa4vst+GDsF0zRxuDYqQ==
X-GPT-Reason: legitimate; this is a technical, non-promotional email
	regarding a Linux kernel software patch (wifi: rtw88: sdio) which
	perfectly matches the mailbox purpose of a developer; the sender's
	domain (d-silva.org) and the content (kernel.org technical data)
	are consistent with professional software engineering and mailing
	list activity; there are no phishing indicators, urgency, or marketing
	elements present.
From: Alastair D'Silva <alastair@d-silva.org>
To: Ping-Ke Shih <pkshih@realtek.com>,
	linux-wireless@vger.kernel.org
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Ulf Hansson <ulfh@kernel.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Kalle Valo <kvalo@kernel.org>,
	Luka Gejak <luka.gejak@linux.dev>,
	linux-kernel@vger.kernel.org,
	Alastair D'Silva <alastair@d-silva.org>
Subject: [PATCH v3 0/2] wifi: rtw88: sdio: Fix interrupt storm on 3081 chips and split RX handling
Date: Thu,  1 Oct 2026 10:03:01 +1000
Message-ID: <20261001000303.3505264-1-alastair@d-silva.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series resolves an unhandled RX request interrupt storm on 3081-based
SDIO chips (RTL8821CS, RTL8822CS) and cleans up the RX interrupt handling
path.

On 3081 SDIO chips, REG_SDIO_HISR_RX_REQUEST is not cleared automatically
by hardware when the RX FIFO is empty. Masking this bit out in software
before writing back to HISR prevented it from ever being acknowledged in
hardware, trapping the CPU core in an infinite interrupt storm loop.

In v2, HIMR masking and early writeback were introduced. As Luka Gejak
pointed out, this broke the drain loop on 8051 chips (RTL8723BS, RTL8723CS,
RTL8723DS) because 8051 hardware automatically clears the bit when empty
and re-reads HISR across iterations. Clearing it early causes 8051 to abort
draining after a single packet. In addition, RTL8723BS in rtw-next requires
RTW_SDIO_HISR_CLEAR_MASK to prevent undefined bits from causing resume
storms.

As the number of architecture-specific special cases has grown (16-bit vs
32-bit register widths, differing HISR writeback timing, synthetic loop
flags, and RTL8723BS resume masking), attempting to accommodate both
architectures within a single monolithic handler has become fragile and
prone to cross-architecture regressions.

To cleanly address both architectures without compromises:
- Patch 1 makes rtw_sdio_handle_interrupt() a dispatcher with separate
  8051 and 3081 handlers. 8051 retains its original unmasked writeback
  and RTW_SDIO_HISR_CLEAR_MASK, while 3081 adopts the HIMR masking and
  W1C acknowledgment pattern. Spurious IRQ check (hisr == 0) and early exit
  are moved into the dispatcher.
- Patch 2 splits rtw_sdio_rx_isr() into separate 8051 and 3081 variants,
  eliminating per-packet branches in the RX hot path and removing the
  artificial hisr assignment on 3081.

Hardware Verification & Empirical Testing (Fly-C5 / RTL8821CS / Linux 7.2):
===========================================================================
Testing was performed on an Allwinner H618 (Mellow Fly-C5) with an onboard
RTL8821CS SDIO Wi-Fi module running Linux 7.2.8 over wlan0.
Instrumentation was added to measure ISR durations, HIMR toggle overhead,
and packet arrivals occurring while interrupts were masked.

1. Baseline Performance (0 us delay, wlan0):
   - TCP Saturation (iperf3 -P4): 35.1 Mbps, 15,988 RX IRQs, 0 RCU stalls.
   - UDP Saturation (iperf3 -u -b 40M): 36.7 Mbps, 32,271 datagrams
     received, 0 lost (0.0% packet loss), 1,342 masked arrivals (7.5%).
   - HIMR toggle overhead (disable + enable): 34.2 us (10.3% of ISR time).

2. Injected Critical Section Delays (Race-Window & Masking Verification):
   To verify that packet arrivals during interrupt servicing are reliably
   latched and re-asserted upon unmasking, delays were injected between W1C
   acknowledgment and unmasking:

   Delay (us) | Traffic | Total IRQs | Masked Arrv | % IRQs | Loss
   -----------+---------+------------+-------------+--------+------
   0 us       | UDP 40M | 17,786     | 1,342       | 7.5%   | 0.0%
   500 us     | UDP 40M | 9,036      | 1,364       | 15.1%  | 0.0%
   2,000 us   | UDP 40M | 3,892      | 458         | 11.8%  | 0.0%
   10,000 us  | UDP 40M | 1,317      | 217         | 16.5%  | 0.0%
   10,000 us  | TCP sat | 1,048      | 171         | 16.5%  | 24 retr

   Explanation of Masked Arrival Dynamics:
   A counterintuitive observation is that the raw count of masked arrivals
   decreases at longer delays (1,342 -> 217 at 10 ms). This occurs because:
   a) The metric counts *interrupt invocations* where at least one packet
      arrived while masked, not individual packets.
   b) With a 10 ms delay per ISR, the system can only execute ~1,300
      total interrupts during a 10-second test (down from ~17,800).
      The proportion of interrupts with masked arrivals more than
      doubled (7.5% -> 16.5%).
   c) RTL8821CS has a 16 KB RX FIFO. At 40 Mbps, the FIFO fills in ~3.2 ms.
      Once full, 802.11 block ACKs pause and over-the-air transmission
      stops until the host drains the FIFO. Each interrupt then drains
      the accumulated data in a single burst (RX drain time grew from
      234 us to 912 us).
   d) Zero packet loss (0.0%) was maintained across all delay
      configurations.

v3:
- Rebased on rtw-next.
- Preserved 8051 interrupt handling behavior and RTW_SDIO_HISR_CLEAR_MASK
  by splitting rtw_sdio_handle_interrupt() into separate 8051 and 3081
  dispatch routines (thanks Luka Gejak for the review and analysis).
- Moved hisr reading and early exit on spurious IRQ into the dispatcher.
- Split rtw_sdio_rx_isr() into 8051 and 3081 implementations (patch 2).
- Added hardware benchmark metrics and delay-injected test results under
  the cut line.
- Added Assisted-by tag per Documentation/process/coding-assistants.rst.

v2:
- Reworked interrupt acknowledgment to use HIMR masking
  (rtw_sdio_disable_interrupt / rtw_sdio_enable_interrupt) to avoid races
  between reading RX0_REQ_LEN and clearing HISR.

v1:
- https://lore.kernel.org/linux-wireless/20260921085502.123456-1-alastair@d-silva.org/

Alastair D'Silva (2):
  wifi: rtw88: sdio: Fix unhandled RX request interrupt storm
  wifi: rtw88: sdio: Split rtw_sdio_rx_isr into 8051 and 3081 variants

 drivers/net/wireless/realtek/rtw88/sdio.c | 95 +++++++++++++++--------
 1 file changed, 62 insertions(+), 33 deletions(-)

-- 
2.53.0

