Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B4043C7A8
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 15:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785512953; cv=none; b=c/9UDusSsfjeOFG1+4gSiZonRk6E2B27o5DHPAcUE3KhOCT6Zoxn/OhM7xNu59XQPjzGAnZC9da8aOwOfqUAHtbdiU+JPIIDNUIg+p/+6kk4qFb2g+MRqd72X/bqF9nQ38ADT6VZQnJa8yM3LZ211EWtbzg8klEJkigX4hMGt8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785512953; c=relaxed/simple;
	bh=PERNb1guRI8ZCQ12dy0SrLJzSrN4b5PB+j5i+IenUQk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WIKtow4OuD8hVSYpx2UsemQhQg2z6xqH3eMhWFqtBoe/OKfq9Ox51xAjVmD8RCZaLG9RDBiadrrtKjTgzFXPDTtSL+QWhYuLcbJQ+7sSyQ6l1swNo6e3xqBS75MdfiE44I74H1qxLoOTCCX740kwavYL+gJVFZXrfSUVhGr8U2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Nt9+nF5Z; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nt9+nF5Z"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2ccdce28edeso1165945ad.0
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 08:49:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785512951; x=1786117751; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=CZlO6ryQTGpm3SzZQm5FnSP1XcX7Y/GaBhxwcLiVUTU=;
        b=Nt9+nF5ZpQssJv6+Dxrl95sTRnDzRY1k+PmgCiZjM37kFsuhRIIgNfHwKJ0CLlBuJi
         IunTU0Xyy6dIMtELgkMeJay2xWsbMna4Ps+6Y/G5tDjggseIlz2CnDrKR9I2PSGjTk1W
         spPeU6c6hyYOBfxI2tnP8vV06RujANDF0PPCqghbpEZwysmX61F+5UaxiYVK5zppzxAf
         tpfNEK++8iW3ekWixNP1PlaQvJ9Ls/sXnF3hMitwsCXxGtbDwKTkhqRFHot9DIJkI4Cb
         DT36Y4bi2EfH7Y3wcKxx2yBM7yHqWVNl2raX7DYpQT1e5VwWxpuIPl3gEoJhJAYy9QjX
         mWYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785512951; x=1786117751;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CZlO6ryQTGpm3SzZQm5FnSP1XcX7Y/GaBhxwcLiVUTU=;
        b=a6Hw1s3ciPIHhLkfmpvjuOd9+d9CzKBh5rHx11J1u5yRYrErLh4Rxa3kCehUcbqJMH
         o7b9C7xqQMHlUha+yoQgDmdv67bSa3ryrfwp4oiZ6LjFWTU7rHGM3rmQji+e11IvHM0Z
         4/T+JfwvxC6SN2cQDGclkTk9KXt9oAmxgckwRAGYvy9AK++nRtmLhRHMB5oRI3Sl9/Q9
         pMDSq6XNWsZspWHDB+HB2Soswecc8Bj4godFYy6WSmMU0/i3j0+t6NmbIqLJmkLA47+7
         fAdBP/qMAspQ9LF4Qh7yY+umhzumu6rHsX3UbD5OPTwWlfK/+RJ0A/Gfntq6hMnpMcxO
         xC8A==
X-Gm-Message-State: AOJu0Yygk6MQcgIS2D0id6TdkPiec0NiFix9s7OnCLPa5IWDp7kgAGfQ
	KBq6Y8MDXYX8+dQiNiSb23z3lbCsY+gfYmgPKurcNL42t5CpJ1lbwYub
X-Gm-Gg: AR+sD13YNDv56GlHrHW4Xe9L3EcM8L2eAwaj94zLP3nFlmwtuoA6ULE8Udeg7w2wKeg
	2MVpy2nc3KYH+l1Hy+HSCWdqg4y4KUoT4lq//EJ3+j7TaxrZ0Sh/Hmmt4veL76MwquteqVvI+eF
	XXcpFd7XX1WPO+nPmhj93KAf4emZhAb0SAhOeFV9lnQFihAKxSY7NuMeDnkLF5SrCZShtxaK2z8
	oY9x7sDqWTzYWl8wlLNQSbEQOS0BgSWFM+scWQpJJcbMD58q9aJMJrgw02v+9UDpKmedhQ3rNEH
	CWfTgLWDHPPwRy4QkH+Nim6AZ69ZMHKR5JZc10T63usupU0r9t+bpKI8zYd218Vs19mBvT+Gtd5
	qrqBqN/EyTh6x7YGaC+4UZLuLtqCvSBlYBxb7I/X4wIRXrxhwJrGTywj62j1iC/VLzzXFt9SSSp
	xhmSfu3wODpWsibnUP9Mqr5yejXHWx/rWbi1Ke1FM62jrzTXwbYN3GZQC6/6YlQAtOdPVM/uygw
	t4=
X-Received: by 2002:a17:903:18d:b0:2cc:e7f3:d39e with SMTP id d9443c01a7336-2d052298ccemr6519365ad.2.1785512950890;
        Fri, 31 Jul 2026 08:49:10 -0700 (PDT)
Received: from Potato.tail66a299.ts.net ([171.76.83.76])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153e045016sm11852510eec.19.2026.07.31.08.49.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 08:49:10 -0700 (PDT)
From: Shivesh <chanelshivesh@gmail.com>
X-Google-Original-From: Shivesh <shivesh@example.com>
To: arend.vanspriel@broadcom.com
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	Shivesh <chanelshivesh@gmail.com>
Subject: [PATCH v3 0/8] wifi: brcm80211: performance and stability improvements
Date: Fri, 31 Jul 2026 15:48:32 +0000
Message-ID: <20260731154901.1822-1-shivesh@example.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shivesh <chanelshivesh@gmail.com>

This series addresses several performance bottlenecks and correctness
issues in both brcmfmac (PCIe/SDIO) and brcmsmac drivers.

Changes since v2:
- core.c: Add skb_cow_head() check before skb_push() to prevent a
  kernel panic when the skb arrives with zero headroom in monitor mode
  receive path.
- cfg80211.c: Fix a silent PMKID list corruption bug in brcmf_pmksa_v2_op.
  The shadow entry counter (npmk) was stored in list->length, which was
  then overwritten with the wire-format byte-length at the send: label.
  On subsequent calls, le16_to_cpu(list->length) would decode the byte-
  length as an entry count, silently corrupting the PMKID cache.

Changes since v1:
- Sent with correct author/Signed-off-by address (chanelshivesh@gmail.com).

Patch overview:
  1. flowring: Replace O(N) blocked-ring scan with an atomic per-interface
     counter, fixing a teardown counter leak that permanently stopped netif.
  2. sdio: Coalesce N+1 separate sdio_claim_host/release pairs in the
     rxglom path into a single pair covering all hdparse calls.
  3. core: Populate the radiotap header with RSSI from wlc_d11rxhdr in
     monitor mode, fixing missing signal strength in packet captures.
     Add skb_cow_head() to prevent panic on zero-headroom skbs.
  4. cfg80211: Implement the PMKID_V2 set/del/flush paths for FILS
     fast-roaming support on firmware revision 12 devices. Fix the V2
     shadow counter overwrite bug. Replace mdelay() busy-wait in
     brcmf_delay() with usleep_range().
  5. msgbuf: Increase NR_TX_PKTIDS (2048->4096) and TX flush thresholds
     (32/96->64/128). Fix silent TX stall under high load by using
     test_and_set_bit to guarantee worker scheduling.
  6. pcie: Replace fixed msleep(10) mailbox polling with usleep_range
     exponential backoff. Replace msleep(50) IRQ teardown polling with
     usleep_range for faster teardown.
  7. fwsignal: Document that a duplicate MAC handle ADD is a safe no-op.
  8. brcmsmac/ampdu: Clarify IEEE 802.11n TID compliance comment.

Shivesh (8):
  wifi: brcmfmac: flowring: replace O(N) loop with atomic counter
  wifi: brcmfmac: sdio: coalesce host locks in rx path
  wifi: brcmfmac: core: populate radiotap header with RSSI
  wifi: brcmfmac: cfg80211: implement PMKID_V2 and fix delay busy-wait
  wifi: brcmfmac: msgbuf: tune thresholds and optimize sleep latency
  wifi: brcmfmac: pcie: optimize latency and irq teardown
  wifi: brcmfmac: fwsignal: safe no-op on duplicate MAC add
  wifi: brcmsmac: ampdu: clarify standard compliance on QoS change

 .../broadcom/brcm80211/brcmfmac/cfg80211.c    | 123 ++++++++++++++++--
 .../broadcom/brcm80211/brcmfmac/cfg80211.h    |   4 +-
 .../broadcom/brcm80211/brcmfmac/core.c        |  44 ++++---
 .../broadcom/brcm80211/brcmfmac/flowring.c    |  65 ++++++---
 .../broadcom/brcm80211/brcmfmac/flowring.h    |  18 +++
 .../broadcom/brcm80211/brcmfmac/fwsignal.c    |   4 +-
 .../broadcom/brcm80211/brcmfmac/msgbuf.c      |  69 ++++++++--
 .../broadcom/brcm80211/brcmfmac/pcie.c        |  66 ++++++++--
 .../broadcom/brcm80211/brcmfmac/sdio.c        |  62 +++++----
 .../broadcom/brcm80211/brcmsmac/ampdu.c       |  11 +-
 10 files changed, 375 insertions(+), 91 deletions(-)


base-commit: 5e0bcb4920bcb9e0ef6c03a91730fe45f643f3a4
-- 
2.53.0

