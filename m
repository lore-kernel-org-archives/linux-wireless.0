Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=119.15.109.137
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793417744;
	b=5Dv1AuSYbroXG1vx4Tyoa9SfNTI5CU4HPKTDVoKX/g1wPZTvDujRqLRUW7V0KtynGo8G
	 SHPnIEpEDXNGFg+GLaY1jA0z3JOGsGYEbIXq8PyTqAeIZ1WOYdft/XwvqHydz0p4BFaGi
	 GjG/SNcj8XL6PWcipxpsrYdheDbnP5VXfkErqQgnYI/6bAYzKgkbvVz2muZSF5seQok9j
	 UBFu2KUZmWLYhGyLhoBvbs5cdVASRMRxm+Rofa+FouCJfzu+uIHp5q30j+yQ2vfUdtX4d
	 9zEHdBMp0FqL7AL5THq/7fCxgOvuZzTJfNTY9+jpj23Jb18eLJrD7H9MWC4UL65KvhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793417744;
	h=DMARC-Filter:Received:DKIM-Signature:X-GPT-Reason:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=AFR6A1Mjmi/ROwyxnb6Mls89RZrCdMTplgGUo6Kj7/8=;
	b=ZdZW8J9Oj5Wenh6hMCVHDOCb3cvZByNZmkg2hUZ6kz4mvqRcJ8m6pa8jwgcmTMnLY5VK
	 cp92bEi2G6EIoUQZw+YdRZh9fVfZiB/YtHpTSNnbKGuhmGUoI9CIpAjJKFBuWpbvraMXK
	 OdC9BFNn2entFAt5d84E72ylC3wRAnUTbT9nFaBbw14tN7J3cs0DVUsyFaKLGBXQFWMMo
	 FJmMZY59Uu/6vP4kx2/fr9jiTYMaTEIgUjwuDP+zFRHN73Vrg/R3B76NmgQPDdUbUg3rN
	 sLOGaOfm8ZvIoqFc5eoeVqotqnrN86vV+6keskE4SjgBTpNXfY0E89ILUpnJWA9h3Kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=d-silva.org;
	spf=pass smtp.mailfrom=d-silva.org;
	dkim=pass header.d=d-silva.org header.i=@d-silva.org header.a=rsa-sha256 header.s=2025a header.b="RjNZ0/Qa";
	arc=none smtp.remote-ip=119.15.109.137
Received: from www.nmnhosting.com (watt.d-silva.org [119.15.109.137])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A783606A31A;
	Sat, 31 Oct 2026 03:35:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2A783606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=d-silva.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=d-silva.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=d-silva.org header.i=@d-silva.org header.a=rsa-sha256 header.s=2025a header.b=RjNZ0/Qa
Received: from Hawking.lan (hawking.lan [10.0.1.4])
	by www.nmnhosting.com (Postfix) with ESMTP id 33468401D6;
	Sat, 31 Oct 2026 14:35:26 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=d-silva.org; s=2025a;
	t=1793417726;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=AFR6A1Mjmi/ROwyxnb6Mls89RZrCdMTplgGUo6Kj7/8=;
	b=RjNZ0/QaCc88JdNazuuh5ky9SVYat93MkuNygBIjDGaydtcjDxnrEFKyyTi0waHLOvRrY9
	gxnE1mBnJ0i86BFs6IsEVms8z4DHYAk7WPUpp0fr/XY08GO98MW67mrceXQmDKiC175s+v
	RGtW7zkxmyUgGvurcjyYqirCbodQD/FrEWWPRrObO0JjECaTPpZ2NTrPP+n1RwRzQNueGt
	/Z2HzuVEVfCDPQnrPDFhB4vnhyZdIjLyMDDXgASbGpI9s1sKB0ZnNAkXjiYLVx+HEdzmiU
	YuM4Kr62bChLzx3sSdW9sZYo7RhdjmY6A4w3Ko/DpA4jXtjcbQnY4anRDDRATQ==
X-GPT-Reason: legitimate_transactional_technical_notice_The email
	is a highly technical Linux kernel patch submission regarding
	a wifi driver (rtw88) which matches the personal/business nature
	of the alastair@d-silva.org mailbox. The content is purely technical,
	describing interrupt storms, register handling (REG_SDIO_HISR_RX_REQUEST),
	and hardware validation results on an Allwinner H618 board. There
	are no phishing indicators, no marketing claims, no urgency, and
	no suspicious links; the sender domain matches the personal identity
	of the author.
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
Subject: [PATCH rtw-next v7 0/4] wifi: rtw88: sdio: Fix unhandled RX request interrupt storm
Date: Sat, 31 Oct 2026 14:35:22 +1100
Message-ID: <20261031033526.474710-1-alastair@d-silva.org>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On 3081-based SDIO chips (observed on RTL8821CS; RTL8822BS and RTL8822CS
are inferred to be affected as they share the 3081 architecture), clearing
REG_SDIO_HISR_RX_REQUEST requires both a software W1C acknowledge and an
empty RX FIFO. Masking this bit out before writing back to HISR prevents
the software acknowledge from happening, leaving the bit asserted even
after the FIFO is drained and trapping the CPU core in an infinite
interrupt storm that locks up the system upon receiving network traffic.

This series fixes the interrupt storm on 3081 chips and addresses
related SDIO lifecycle, locking, and error handling issues:

- Patch 1 returns error codes from rtw_sdio_rxfifo_recv() on allocation
  or read failures so the caller stops immediately instead of burning
  through the loop budget.
- Patch 2 tracks operational state via rtwsdio->running protected by an
  irq_lock mutex (using a mutex as SDIO bus operations sleep), serializes
  start/stop state transitions under sdio_claim_host() and irq_lock,
  cancels the TX worker synchronously on stop, and re-arms it on start to
  drain any parked frames and wake stopped queues.
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
- RX test (10s iperf3 to board): 36.5 MB sent (30.6 Mbits/sec),
  34.2 MB received (28.7 Mbits/sec), with zero stalls, zero lockups, and
  no interrupt storm.
- TX test (10s iperf3 -R from board): 40.5 MB sent (34.0 Mbits/sec),
  40.0 MB received (33.6 Mbits/sec).
- Bidirectional test (10s iperf3 --bidir simultaneous TX and RX):
  RX 27.0 MB sent (22.6 Mbits/sec) / 26.4 MB received (22.0 Mbits/sec)
  concurrently with TX 11.5 MB sent (9.68 Mbits/sec) / 11.1 MB received
  (9.28 Mbits/sec).
- Interface stop/start cycling (ip link set wlan0 down/up) and dmesg
  verified clean with zero warnings, traces, or hangs.

Differences in v7:
- Rebased onto latest rtw-next.
- Cover letter and Patch 3: Included RTL8822BS alongside RTL8822CS as
  inferred from sharing the 3081 architecture, and reworded the opening
  explanation to state that clearing REG_SDIO_HISR_RX_REQUEST requires
  both a software W1C acknowledge and an empty RX FIFO (per Luka Gejak).
- Patch 2: Re-arm the TX worker at the end of rtw_sdio_start() so any
  frames left parked in rtwsdio->tx_queue[] across a stop are drained and
  stopped mac80211 queues are woken (per Luka Gejak).

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

 drivers/net/wireless/realtek/rtw88/sdio.c | 165 ++++++++++++++++------
 drivers/net/wireless/realtek/rtw88/sdio.h |   3 +
 2 files changed, 128 insertions(+), 40 deletions(-)

-- 
2.53.0
