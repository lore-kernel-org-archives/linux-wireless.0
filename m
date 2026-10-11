Received: from www.nmnhosting.com (watt.d-silva.org [119.15.109.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE0812EEE60;
	Sun, 11 Oct 2026 22:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.15.109.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791756493; cv=none; b=ajmt2Mk05a9JX2WGzbNle5/EOT1p6F3IXldGzAURqAM32ONCBhhH48w8pIi3ycDrG0tA13iqvBt9RJgwzpY0sM47bgejvtXqFN6x0roO6FJNTDqH1I7ekSxffNwc3fSYQcIFulvcHOXcxfburS/zHKi36PnOQsPB04IhYtiYrss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791756493; c=relaxed/simple;
	bh=X+TiGBBvgg4lTnx6akfoGMRuOIo3RkbUaewzmx+uWVo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SzfGFtMofkSffDdiFbJpBjbB0SVaNl9NVPCHmtWbnw4BJjwf9XMpOliV7bZBQxdThrgxcyk00AwdR/aFc2IRh2iiZ8u0TJVsmXpzKcvSyJBGwyKiQsYcCnumQjly608sjMnsgs1znd3kDOCLchqx31uF8o9aLDhYHS+bE08g1ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=d-silva.org; spf=pass smtp.mailfrom=d-silva.org; dkim=pass (2048-bit key) header.d=d-silva.org header.i=@d-silva.org header.b=JviUl0ol; arc=none smtp.client-ip=119.15.109.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=d-silva.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=d-silva.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=d-silva.org header.i=@d-silva.org header.b="JviUl0ol"
Received: from Hawking.lan (hawking.lan [10.0.1.4])
	by www.nmnhosting.com (Postfix) with ESMTP id EBE7C4021A;
	Mon, 12 Oct 2026 09:07:55 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=d-silva.org; s=2025a;
	t=1791756476;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=SRYZN9X570ZTPADly2F5lg+GqHeDvOGVG3Nz0gUA2GI=;
	b=JviUl0ol/54L1x1wzd8t1SHt7D7GHGej/ynJmfQnuErglHNEjhH7Dvc2sSWlbOKPYK2vr/
	TuyX+9mu5vGZrDFccxg4YFXeRQTFuA09Zrl4jrgUrWDO75Tf4DDORU5rUAOOHV/qsEJtxm
	GHpiX85SxYYBuHbz2FFyUPZ5457POApmvFaUEKOPRD/3XxCIywE4OEK/TYoGTYchUf8nW7
	NTeAt25GF17wztWN5NGy5qCpwh1jWqUmrqqENJu5TnWj2/KPNu4Feo8+cnb2UhRUJt3gtk
	6dXZO4u6qEYGnFh3Pf1n3vlVOJQS2PzlXBuiTKkQQEVc5UVnCq9NtjLK+n2PCw==
X-GPT-Reason: legitimate_transactional_technical_communication;
	the email is a technical Linux kernel patch submission which aligns
	perfectly with the recipient's persona (alastair@d-silva.org);
	the From domain (d-silva.org) matches the recipient's domain; the
	content is highly specific technical documentation regarding WiFi
	drivers (rtw88) and hardware validation (Allwinner H618 board),
	which is consistent with professional software development; there
	are no phishing indicators, urgency tactics, or suspicious links.
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
Subject: [PATCH rtw-next v5 0/4] wifi: rtw88: sdio: Fix unhandled RX request interrupt storm
Date: Mon, 12 Oct 2026 09:07:51 +1100
Message-ID: <20261011220755.1673367-1-alastair@d-silva.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On 3081-based SDIO chips (e.g. RTL8821CS, RTL8822CS), hardware does not
automatically clear the REG_SDIO_HISR_RX_REQUEST status bit when the RX
FIFO is empty. Masking this bit out in software before writing back to
HISR prevented it from ever being acknowledged in hardware, trapping the
CPU core in an infinite interrupt storm that locked up the system upon
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
running Linux 7.2.10, with the Ethernet interface administratively brought
down to ensure all traffic traversed the WiFi link exclusively:
- TX test (iperf3 client upload): 45.7 MB in 10s at 38.3 Mbits/sec
  (0 errors).
- RX test (iperf3 reverse mode flood): 65.1 MB in 15s at 36.4 Mbits/sec
  with zero stalls, zero lockups, and no interrupt storm.
- Bidirectional test (iperf3 --bidir simultaneous TX and RX):
  20.9 MB TX (11.7 Mbits/sec) + 43.6 MB RX (24.4 Mbits/sec),
  aggregate ~36.1 Mbits/sec.
- dmesg verified clean with zero warnings, traces, or hangs.

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

Alastair D'Silva (4):
  wifi: rtw88: sdio: Handle allocation and read errors in
    rtw_sdio_rxfifo_recv
  wifi: rtw88: sdio: Track running state and cancel TX worker on stop
  wifi: rtw88: sdio: Fix unhandled RX request interrupt storm
  wifi: rtw88: sdio: Split rtw_sdio_rx_isr into 8051 and 3081 variants

 drivers/net/wireless/realtek/rtw88/sdio.c | 165 ++++++++++++++++------
 drivers/net/wireless/realtek/rtw88/sdio.h |   3 +
 2 files changed, 126 insertions(+), 42 deletions(-)

-- 
2.53.0
