Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F68F423160
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 20:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784750666; cv=none; b=abLRRVnuT5KfylJsrximFcd40hEqwz54BvwvSyCnXWV0kjVQsoLjV2M5xpGVGPORdw5Sv2kbFLY/a9BFNcSS66+1ShODfF8D1YgWAbKDsd537cH6XIxaGQGA2/YcHF9KKSZu8b30CbI2hJV+PRByJzqmixtd45ql2Mp6cylE15M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784750666; c=relaxed/simple;
	bh=LmtRDewDK+huJ7Yi6PHLp5zMJ+e2kaWLDkUc5m09DgI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hLyCafj+8cgBMhXC5NupPzQwBBIfFtFqFe9EvN8mjiJs6RjbPqm1k8D3rGsig+JGqb7u2vqAx5hcLK+Vkv+qINr6bB7SYvlQdNGkYrYlW1HJY8DZ5oZgm0QoYfngqHTyDwyIfSp4FacE1gUolNVUFgnH4HYCfQnPR3H9BI/7LHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=c6Y1IBCS; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="c6Y1IBCS"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784750648;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=tZTJDmOIJbYBK8gTX8job0wGollFEhV3yHHnEIOSyjk=;
	b=c6Y1IBCSNeZVMUgsfyAdsKHrzz06U4JddBiTKwdm28PkEi7mihEM+q32Ok1egtVKQYp6Ov
	EIyneci32m8D18Y0iPxmOuKq2SzNelrNIDZWLPGojEv5jiY8CFO/fgkPbJpaw3JdOtKoE0
	wBygfKdC4HykJMC0khrxof0HUZqyLd0=
From: luka.gejak@linux.dev
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH v2 0/4] wifi: rtw88: add RTL8723B/RTL8723BS support
Date: Wed, 22 Jul 2026 22:03:27 +0200
Message-ID: <20260722200337.135150-1-luka.gejak@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Luka Gejak <luka.gejak@linux.dev>

This series adds support for the Realtek RTL8723B 802.11n chipset and
its RTL8723BS SDIO variant to rtw88. It is SDIO-only; the PCIe and USB
variants are untested and intentionally left for future work.

RTL8723BS predates rtw88 and uses the available Realtek vendor firmware
(version 41), whose H2C/C2H protocol and association behaviour differ
from the firmware used by the existing rtw88 8723-family devices.
Supporting it therefore needs both the common RTL8723B chip
implementation and a set of RTL8723BS-specific changes in the shared
code for firmware commands, coexistence, association and TX/RX handling.

The series is arranged as suggested during the RFC review: the shared
core handling first, then the chip body, then the build glue.

  - the core handling required by RTL8723BS: the vendor firmware H2C/C2H
    interface, WiFi/BT PTA antenna handling during scan and association,
    scan, calibration and rate-adaptation handling, the vendor
    association register sequence, and the RTL8723BS SDIO transfer
    contract including RX aggregation, FIFO/OQT/free-page accounting,
    management TX scheduling, bounded mac80211 queue back-pressure and a
    delayed retry on free-page starvation;
  - the RTL8723B chip body: chip operations, BB/RF/AGC parameter tables,
    power sequences and the RTL8723BS SDIO bind;
  - the Kconfig and Makefile entries; and
  - MAINTAINERS.

What the driver supports:

  - RTL8723B / RTL8723BS, SDIO only;
  - 2.4 GHz, 802.11n, HT20 and HT40, single spatial stream;
  - STA mode.

Limitations, stated plainly:

  - Only STA mode has been validated. rtw88 core advertises AP and IBSS
    for every chip so this driver inherits them, but neither has been
    tested, and an out-of-tree tester has reported AP mode associating
    without DHCP completing.
  - WiFi/BT coexistence is limited by the BT firmware rather than by
    this driver. With A2DP streaming, BT info arrives regularly (19
    reports in 30 s, with changing values) but the profile byte stays
    0x01, CONNECTION only: ACL_BUSY and the profile bits are never set,
    so coex correctly derives CON_IDLE from what it is given while BT is
    demonstrably moving traffic. WiFi throughput drops from 42.0 to
    0.21 Mbit/s with A2DP active, although the audio itself is smooth.
    Swapping the WiFi firmware (rtl8723befw.bin, rtl8723befw_36.bin,
    rtl8723bs_nic.bin) does not change it: the reported BT coex version
    stays 0x69 on all of them, which fits, since it comes from the BT
    side and is only relayed through. This is documented rather than
    worked around, because inferring BT state in the WiFi driver would
    only be guessing at something it cannot observe.

This series is based on the rtw-next branch from pkshih/rtw.

The implementation is based on the initial RTL8723B work by Michael
Straube <straube.linux@gmail.com>:

  https://github.com/mistraube/rtw88/tree/rtl8723bs

The SDIO integration and subsequent hardware bring-up were developed and
tested on an RTL8723BS system.

Hardware validation covered repeated scan, authentication, association,
WPA2 key negotiation, DHCP, bidirectional traffic, reconnects, link
cycles and module reloads. This revision has been tested on RTL8723BS
hardware by three people, and further testing on other hardware is
planned. The throughput and coexistence figures quoted above were
measured on one AP at strong signal (-32 dBm), 2.4 GHz HT40, so the
timing-sensitive paths have not yet been exercised on a marginal link.

Every commit builds with W=1 with no warnings, and sparse and smatch are
clean. checkpatch --strict reports two things on patch 2, both expected:
a "complex values should be enclosed in parentheses" error for
TRANS_SEQ_END, which is byte for byte the same macro checkpatch already
flags in rtw8703b.c, and a "does MAINTAINERS need updating?" warning,
which patch 4 answers. RTL8703B, RTL8723CS/DS and the other rtw88 bus
modules continue to build.

The driver requests this firmware file:

  rtw88/rtw8723b_fw.bin

It has been submitted to linux-firmware separately, with the extraction
provenance documented, and carries Ping-Ke Shih's Reviewed-by.

Changes in v2:
  - Restructured into the four patches suggested during review: core
    handling, chip body, Kconfig and Makefile, MAINTAINERS. The
    restructure itself changes no code.
  - Dropped five things that turned out to be unnecessary once tested on
    hardware: the firmware-reported TX rate, the management TX
    descriptor contract, the first-segment and retry-limit descriptor
    bits, the management and EAPOL TX rate selection, and the soft IPS
    path. Each was reverted to the generic rtw88 behaviour and measured;
    association, the WPA2 handshake and throughput were unchanged in
    every case.
  - HT40 is now actually enabled. v1 carried the HT40 BB code but never
    advertised the capability, so it ran at 20 MHz.
  - v1 modified the shared rtw_init_ht_cap() for every chip. That is
    reverted; the 8723BS-specific part is scoped through hw_cap instead,
    so the other chips are untouched.
  - New: retry SDIO TX after free-page starvation. Measured uplink is
    20.1 Mbit/s with it against 11.9 Mbit/s without, and 2 TCP
    retransmits against 204.
  - rtw_tx_report_handle_8723b() removed. The 8723BS C2H reports now go
    through the existing rtw_tx_report_handle(), since only the decode
    differed.
  - The TX report purge timeout is extended to cover 8723BS SDIO,
    reusing the 8723D USB case already in tree. This fixes the "failed
    to get tx report" warning reported on slower SDIO hosts.
  - Coex chip config corrected: scbd_support is false (the vendor driver
    has no scoreboard implementation for 8723b) and bt_desired_ver is
    0x6d (0x6f was the driver's own coex version, not the desired BT
    version).
  - rtw_is_8723bs_sdio() renamed rtw_is_8723bs().
  - Kconfig and Makefile moved out of the chip patch, so the driver only
    becomes buildable once the supporting code is in.
  - Vendor-reference comments removed from the chip driver, including
    the last few that still carried vendor engineer names and dates.
    The shared core files keep a small number of cross-references to
    drivers/staging/rtl8723bs, where the register sequence being
    mirrored is not otherwise derivable from the code; those name only
    functions that are in tree and greppable.
  - Copyright headers now include Realtek. The year range on the files
    carrying derived Realtek code is the one stated in the vendor
    sources they come from; rtw8723b.h keeps the header it already had.
  - Local register defines moved to reg.h, and the ones that duplicated
    a register rtw88 already names were dropped in favour of the
    existing name, so REG_BCNQ_BDNY, REG_MGQ_BDNY, REG_WMAC_LBK_BF_HD,
    REG_DWBCN0_CTRL, REG_GNT_BT, REG_BT_COEX_ENH_INTR_CTRL,
    REG_PAD_CTRL1 and REG_RFE_CTRL_E are now used directly. Three
    vendor names are kept deliberately: REG_FPGA0_XA_RF_INT_OE and
    REG_FPGA0_XB_HSSI_PARM2 keep the per-path RF table symmetric (the
    other four registers in it have no rtw88 name), and REG_B_RXIQI is
    written with RX IQ calibration results, which the address's other
    name, REG_TXSCALE_A, would misdescribe.
  - RF_RCK_OS / RF_TXPA_G1 / RF_TXPA_G2 replaced with the existing
    RF_MODE_TABLE_* definitions.
  - Includes reordered; comment style updated; forward declarations
    removed; reverse christmas tree and alignment fixed; mdelay(200)
    replaced with fsleep(200 * 1000).
  - Struct fields, flags and function declarations moved into the patch
    that first uses them.

Luka Gejak (4):
  wifi: rtw88: 8723bs: add the core handling required by RTL8723BS
  wifi: rtw88: 8723b: add RTL8723B chip support
  wifi: rtw88: 8723bs: enable building the RTL8723BS driver
  MAINTAINERS: add entry for the RTL8723B rtw88 driver

 MAINTAINERS                                   |    7 +
 drivers/net/wireless/realtek/rtw88/Kconfig    |   18 +
 drivers/net/wireless/realtek/rtw88/Makefile   |    6 +
 drivers/net/wireless/realtek/rtw88/coex.c     |  237 ++
 drivers/net/wireless/realtek/rtw88/coex.h     |    4 +
 drivers/net/wireless/realtek/rtw88/fw.c       |  166 +-
 drivers/net/wireless/realtek/rtw88/fw.h       |   17 +
 drivers/net/wireless/realtek/rtw88/mac80211.c |  542 ++-
 drivers/net/wireless/realtek/rtw88/main.c     |  186 +-
 drivers/net/wireless/realtek/rtw88/main.h     |   35 +
 drivers/net/wireless/realtek/rtw88/reg.h      |   31 +
 drivers/net/wireless/realtek/rtw88/rtw8723b.c | 3094 +++++++++++++++++
 drivers/net/wireless/realtek/rtw88/rtw8723b.h |   16 +
 .../wireless/realtek/rtw88/rtw8723b_table.c   |  862 +++++
 .../wireless/realtek/rtw88/rtw8723b_table.h   |   18 +
 .../net/wireless/realtek/rtw88/rtw8723bs.c    |   39 +
 drivers/net/wireless/realtek/rtw88/rx.c       |    8 +-
 drivers/net/wireless/realtek/rtw88/sdio.c     |  462 ++-
 drivers/net/wireless/realtek/rtw88/sdio.h     |   20 +-
 drivers/net/wireless/realtek/rtw88/sec.h      |    1 +
 drivers/net/wireless/realtek/rtw88/tx.c       |    5 +-
 21 files changed, 5697 insertions(+), 77 deletions(-)
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723b.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723b.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723b_table.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723b_table.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723bs.c

-- 
2.55.0

