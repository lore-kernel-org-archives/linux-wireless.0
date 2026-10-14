Received: from www.nmnhosting.com (watt.d-silva.org [119.15.109.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002834A5EDA;
	Wed, 14 Oct 2026 07:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.15.109.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791963890; cv=none; b=goKYbkZsUt7I+KMS4vG2gmseIBk5Q9h6BQWNYjnBVb7LsYM26uNRUVIzugczM306dHv3t+ANG7ipZ27CNQf1PTpZN5MfVmgiuGvNzAQ/BVp+alBC0K6Lf9sycjz3aWVMiKpdSL7cF4u7PhlERn4qlCQSrT4SJoThffAJ28Jl+Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791963890; c=relaxed/simple;
	bh=uRqUgt7E83/NUsduqvwqJnXDm5FXo3ayGNbwRPKqO1s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=K53wNnvgrKDguKwpsn6yAp3k7jP6HfSfFW0VC+/UBO9XBgjCYGYTg2E3GVk8kAin+RbajiaUz0RmN+4q89uGYo6O8a7TvaigzvNZh5jtAHZoH6q8sMKgL9a3HajdTMLN+s/azIwakR0Ecf4IHMRUb7viJRPnThVJ790LyRC6i2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=d-silva.org; spf=pass smtp.mailfrom=d-silva.org; dkim=pass (2048-bit key) header.d=d-silva.org header.i=@d-silva.org header.b=FpgXsYh+; arc=none smtp.client-ip=119.15.109.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=d-silva.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=d-silva.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=d-silva.org header.i=@d-silva.org header.b="FpgXsYh+"
Received: from Hawking.lan (hawking.lan [10.0.1.4])
	by www.nmnhosting.com (Postfix) with ESMTP id AA35D401AA;
	Wed, 14 Oct 2026 18:44:26 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=d-silva.org; s=2025a;
	t=1791963866;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=WlEGU4nasntLLplgtLLrYJZ0Bdn3gBtG98JaC624eKA=;
	b=FpgXsYh+471kT8VK9ReIV0w+KGwzwo7DnCrfDsczcI+RK03TAohJgz1RWykbw+N+/m9TDU
	niE+cBc29x/E6VdEp/315d3Ctgt85F5pHzB6u3mlSQKS2CJVbIlTlKQsEisY5cXCIGIOk7
	9i7+8KGXhH+7glAYMUs7Y5FsGtHXWuQCWJoPyCsqKgsk+aSRg2CyvdHA8/q9BW/YhR4rp9
	GGxZq3zu677TnD/ZWi3oXnSwJd4AzA5FZ53jsTcxI4hJiXKKTVF3KuL3YOzMfXA9f+q9Pq
	suZsrzoJaNS7KKoZtcdJIczTEOKh/1Ct0bl0k1c+6/uWzKVGq9kHHDSw5XCV9Q==
X-GPT-Reason: legitimate; the message is a technical Linux kernel
	patch description (wifi: rtw88: sdio) sent from a known personal
	domain (alastair@d-silva.org) to a matching mailbox; the content
	is highly specific to hardware engineering (SDIO chips, interrupt
	storms, register bits) and includes technical performance data
	(iperf3 results) rather than marketing or phishing; there are no
	URLs, no urgency/scare tactics, and the sender identity aligns with
	a professional/technical contribution context.
From: Alastair D'Silva <alastair@d-silva.org>
To: linux-wireless@vger.kernel.org,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>
Cc: Luka Gejak <luka.gejak@linux.dev>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>,
	linux-kernel@vger.kernel.org,
	Alastair D'Silva <alastair@d-silva.org>
Subject: [PATCH rtw-next v6 0/4] wifi: rtw88: sdio: Fix unhandled RX request interrupt storm
Date: Wed, 14 Oct 2026 18:44:22 +1100
Message-ID: <20261014074426.2183095-1-alastair@d-silva.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On 3081-based SDIO chips (observed on RTL8821CS; RTL8822CS is inferred to
be affected as it shares the 3081 architecture), hardware does not
automatically clear the REG_SDIO_HISR_RX_REQUEST status bit when the RX
FIFO becomes empty. Masking this bit out in software before writing back
to HISR prevented it from ever being acknowledged in hardware, trapping
the CPU core in an infinite interrupt storm that locked up the system upon
receiving network traffic.

This series fixes the interrupt storm on 3081 chips and addresses
related SDIO lifecycle, locking, and error handling issues:

- Patch 1 returns error codes from rtw_sdio_rxfifo_recv() on allocation
  or read failures so the caller stops immediately instead of burning
  through the loop budget.
- Patch 2 tracks operational state via rtwsdio->running protected by an
  irq_lock mutex (using a mutex as SDIO bus operations sleep), serializes
  start/stop state transitions under sdio_claim_host() and irq_lock, and
  cancels the TX worker synchronously on stop.
- Patch 3 fixes the interrupt storm by splitting
  rtw_sdio_handle_interrupt() into 8051 and 3081 paths. On 3081,
  interrupts are masked via HIMR, acknowledged via W1C writeback,
  serviced, and re-enabled under irq_lock if still running.
- Patch 4 refactors rtw_sdio_rx_isr() into separate 8051 and 3081 variants
  to clarify the differences in register width and HISR handling without
  any logic changes.

Hardware Validation:
Validated on an Allwinner H618 board (Mellow Fly-C5) with RTL8821CS SDIO
on the sunxi-mmc host controller (which dispatches SDIO interrupts via the
ksdioirqd thread rather than MMC_CAP2_SDIO_IRQ_NOTHREAD / sdio_irq_work)
running Linux 7.2.10, with policy routing configured and verified via
interface byte counters so all test traffic traversed wlan0 exclusively:
- RX test (10s iperf3 to board): 41.2 MB sent (34.6 Mbits/sec),
  40.4 MB received (33.8 Mbits/sec), with zero stalls, zero lockups, and
  no interrupt storm.
- TX test (10s iperf3 -R from board): 45.6 MB sent (38.2 Mbits/sec),
  44.4 MB received (37.2 Mbits/sec).
- Bidirectional test (10s iperf3 --bidir simultaneous TX and RX):
  RX 25.4 MB sent (21.3 Mbits/sec) / 24.2 MB received (20.2 Mbits/sec)
  concurrently with TX 10.2 MB sent (8.53 Mbits/sec) / 9.62 MB received
  (8.05 Mbits/sec).
- ksdioirqd/mmc1 CPU utilization remained at ~3.5% under load, and dmesg
  verified clean with zero warnings, traces, or hangs.

Differences in v6:
- Cover letter: Clarified that RTL8821CS was observed and tested while
  RTL8822CS is inferred from sharing the 3081 architecture, and noted that
  testing was performed on sunxi-mmc (ksdioirqd) per Luka Gejak. Added
  details below the cut line on how REG_SDIO_HISR_RX_REQUEST level
  sensitivity was verified on hardware.
- Patch 1: Added Reviewed-by from Luka Gejak.
- Patch 2: Dropped the rtw_sdio_deinit() helper and probe error path label
  rename per Luka Gejak, and refined the irq_lock comment in sdio.h.
- Patch 3: Replaced goto out with if (hisr) block to avoid mixing goto
  with cleanup.h helpers in rtw_sdio_handle_interrupt(), and documented
  why the full HISR word is written back on 3081 (matching all non-8723BS
  SDIO chips) and that REG_SDIO_HISR_RX_REQUEST is level-sensitive to RX
  FIFO occupancy (verified on hardware), addressing Luka Gejak's feedback.
- Patch 4: Added Reviewed-by from Luka Gejak.

Differences in v5:
- Patch 1: Added Acked-by from Ping-Ke Shih.
- Patch 2: Updated Fixes: tag to commit 28eaf7971a20 ("wifi: rtw88: sdio:
  add TX back-pressure and retry on page starvation") per discussion
  between Ping-Ke Shih and Luka Gejak.
- Patch 2: Replaced lockless running checks with an irq_lock mutex in
  struct rtw_sdio. Since SDIO I/O sleeps, a mutex is used instead of a
  spinlock. Enforced lock ordering (sdio_claim_host() -> irq_lock) in
  start and stop paths to avoid lock inversion with the MMC IRQ handler.
- Patch 2: Retained running checks in rtw_sdio_tx_handler() and
  rtw_sdio_handle_interrupt() to avoid races during stop.
- Patch 3: Protected the 3081 interrupt re-enable check under irq_lock
  (scoped_guard) per feedback from Ping-Ke Shih.
- Patch 4: Fixed comment formatting style in rtw_sdio_rx_isr_8051() per
  coding style rules.
- Patch 4: Added Acked-by from Ping-Ke Shih.

Differences in v4:
- Split pre-existing lifecycle and error handling issues into separate
  patches (Patches 1 and 2) prior to the storm fix (per Luka Gejak).
- Guard HIMR re-enabling with rtwsdio->running in the 3081 handler.
- Significantly reduced and streamlined commit messages across the series
  (per Ping-Ke Shih).
- Clarified in Patch 4 that it is a refactoring without logic changes,
  highlighting register width and HISR behavior (per Ping-Ke Shih).
- Tagged with rtw-next in subject prefix for NIPA testing.

---
Verifying REG_SDIO_HISR_RX_REQUEST level-sensitivity on RTL8821CS (3081):

To verify Luka's question on whether acknowledging REG_SDIO_HISR before
draining the RX FIFO can strand unread packets if rtw_sdio_rx_isr_3081()
exits early (upon hitting the 64 KB loop budget or an allocation/read
error), we instrumented rtw_sdio_handle_interrupt_3081() and
rtw_sdio_rx_isr_3081() on the RTL8821CS test board with a 4-point register
probe and a forced early-exit stress parameter (test_early_exit=1, which
forces rtw_sdio_rx_isr_3081() to break after reading a single RX DMA batch
so unread packets remain in the hardware FIFO):

1. Normal single-packet drain (FIFO emptied during ISR):
   - Entry: hisr=0x00800031 (BIT_RX_REQUEST=1), rx0_init=334
   - After W1C writeback (before FIFO read): post_ack_hisr=0x00800031,
     rx0_len=334. Even though software wrote 1 to clear BIT_RX_REQUEST,
     the hardware immediately kept BIT_RX_REQUEST asserted (1) because 334
     bytes of unread packet data were still sitting in the RX FIFO.
   - After rtw_sdio_rxfifo_recv() drained the 334 bytes: rx0_rem=0,
     post_drain_hisr=0x00800030 (BIT_RX_REQUEST=0). Only once the FIFO was
     empty AND the W1C acknowledge had occurred did BIT_RX_REQUEST drop to
     0.

2. Forced early exit with unread data remaining in the FIFO:
   - Under an iperf3 UDP flood with test_early_exit=1, the ISR exited
     after one read while unread packets remained in the FIFO (e.g.
     rx0_init=1538 -> post_ack_hisr=0x00800031 -> rx0_rem=3096).
   - Both post_drain_hisr and post_unmask_hisr read 0x00800031
     (BIT_RX_REQUEST=1), and the hardware immediately re-asserted the SDIO
     interrupt line upon unmasking HIMR. Over 1,920 forced early exits in
     a single burst, 100% re-asserted BIT_RX_REQUEST and re-triggered the
     interrupt without a single stalled packet.

Alastair D'Silva (4):
  wifi: rtw88: sdio: Handle allocation and read errors in
    rtw_sdio_rxfifo_recv
  wifi: rtw88: sdio: Track running state and cancel TX worker on stop
  wifi: rtw88: sdio: Fix unhandled RX request interrupt storm
  wifi: rtw88: sdio: Split rtw_sdio_rx_isr into 8051 and 3081 variants

 drivers/net/wireless/realtek/rtw88/sdio.c | 164 ++++++++++++++++------
 drivers/net/wireless/realtek/rtw88/sdio.h |   3 +
 2 files changed, 127 insertions(+), 40 deletions(-)

-- 
2.53.0

