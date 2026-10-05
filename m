Received: from www.nmnhosting.com (watt.d-silva.org [119.15.109.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA42831F99C;
	Mon,  5 Oct 2026 08:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.15.109.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791190139; cv=none; b=AwIlNTPlavG/PLeaC7IXJbI+5RNztZlstNWu3eL2T4elPFSsov+Riu3zP2IBnE+H0M4dyZZb35alcHUkRHZLlOGBLe12awMRVhYZTYOj3on9vKQXOSCWqzSO28xKVlH5ydlYnMBbj/G4FyrXs1dGUJVKEvNuJ5qazcbCF92CU2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791190139; c=relaxed/simple;
	bh=oPWkjWg41TNUE04xhDpSpS7bYgwU2kmq3kHdMmzAhzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=U+OlEnyQp8mpKoDWT1uQ2OuMTwBpS3eI49uqZhqKwlI2h6d8bbo7KRVT7Wdv5nDmKjn0GUazo107pHx4talsyYeMVT9ldqbDpw6euVcb4e38/AgU6GJhNGFs3cp1+MM6h+yiNcSebm0mN+pqKuk/PxXALdZMCoX5hVfEkYm4+G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=d-silva.org; spf=pass smtp.mailfrom=d-silva.org; dkim=pass (2048-bit key) header.d=d-silva.org header.i=@d-silva.org header.b=kdoeIwoR; arc=none smtp.client-ip=119.15.109.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=d-silva.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=d-silva.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=d-silva.org header.i=@d-silva.org header.b="kdoeIwoR"
Received: from Hawking.lan (hawking.lan [10.0.1.4])
	by www.nmnhosting.com (Postfix) with ESMTP id 2C15C405F6;
	Mon,  5 Oct 2026 19:48:49 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=d-silva.org; s=2025a;
	t=1791190129;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=zVk+ZEyRiebUcVpWneJ9O6QSQ3pNCVDyiFPoQJxOOXo=;
	b=kdoeIwoR1RHPan41nS9o+cbWAqr7CDipe10ilce3QTd8Klm6PP/E16z3J9CYmp5HXj9DXr
	o1l7xSP/JDlDwWuZAgqZiFLDod61FjNW29WSU2Yb23JdUZmZaly26dHvCwfUGx36ulFhVN
	1YoK55r4pjMRdLYVvVTdZ2OFV1W8t23m3CzADnvJOAN9WGXEMRf+yrxycgz/cLaAJ1ZAUq
	N92ZA/ns/3jufy33jamf9k9fnBAhmmDH/ve1OYLEn79QmxYB1T7YcVcgQ1Urdpgoe9P4D+
	Mf6WGeRCEyVefeONNW9cwjQlrBYENVF7qV/xICudepXeBFb4D9y5nNkuHZlHkw==
X-GPT-Reason: legitimate; This email is a technical software patch
	submission for a Linux kernel driver (rtw88), which perfectly aligns
	with the personal/technical nature of the alastair@d-silva.org
	mailbox; the From domain matches the recipient's domain, and the
	content is highly specific, professional, and devoid of any marketing,
	urgency, or phishing indicators; the presence of specific hardware
	validation details (Allwinner H618 board) and commit message logs
	further confirms its authenticity as a developer communication.
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
Subject: [PATCH rtw-next v4 0/4] wifi: rtw88: sdio: Fix unhandled RX request interrupt storm
Date: Mon,  5 Oct 2026 19:48:45 +1100
Message-ID: <20261005084849.3109337-1-alastair@d-silva.org>
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
related SDIO lifecycle and error handling issues:

- Patch 1 returns error codes from rtw_sdio_rxfifo_recv() on allocation
  or read failures so the caller stops immediately instead of burning
  through the loop budget.
- Patch 2 tracks operational state via rtwsdio->running and cancels
  the TX worker synchronously on stop, preventing work items from
  accessing powered-down hardware.
- Patch 3 fixes the interrupt storm by splitting
  rtw_sdio_handle_interrupt() into 8051 and 3081 paths. On 3081,
  interrupts are masked via HIMR, acknowledged via W1C writeback,
  serviced, and re-enabled.
- Patch 4 refactors rtw_sdio_rx_isr() into separate 8051 and 3081 variants
  to clarify the differences in register width and HISR handling without
  any logic changes.

Hardware Validation:
Validated on an Allwinner H618 board (Mellow Fly-C5) with RTL8821CS SDIO:
- Bidirectional TCP throughput: 36.5 Mbps RX / 36.4 Mbps TX (over wlan0).
- Repeated interface down/up cycles verified clean with zero storms or
  hangs.

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

 drivers/net/wireless/realtek/rtw88/sdio.c | 128 +++++++++++++++-------
 drivers/net/wireless/realtek/rtw88/sdio.h |   1 +
 2 files changed, 91 insertions(+), 38 deletions(-)

-- 
2.53.0

