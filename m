Received: from mta1.migadu.com (out-101.mta1.migadu.com [95.215.58.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8738F3DDB03
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 21:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790199367; cv=none; b=BtL49Ogcmi2EC7wFqbvDBrSdqVDBj21ggiSMRoO5ZJ81bk6MH9ugx3yfvzT0RkroS8W0SEoQRtJFzIZAgJii/AcDzdDTPls3KxX6DbdnQ8LGjmWdlePTtiuK/rgkcjor2CdvnPdbKsJA4CZJNILmtypGwicLUTnAVXqXmN/iorg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790199367; c=relaxed/simple;
	bh=NxjU6FJY3mJdOvbma4FjYi/nASPrN1wq1SXwm6/ym68=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=E0jHXmaVphgwqxeUZ+UZmuMA44t1Gy2936JWRYVyWeawYxeN8pzDnknSChcWZ4XEYDCBFPfNOeTHjcO3CX3TGI1/o5mj04ICAZ13+ZTkAJikZZVq9kCApPk0bCitkpbBh1/Frkw3S2mu3WG9iKiMSnKQ7hLn+yUs6Sfx26Q7Wxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xYalu5jK; arc=none smtp.client-ip=95.215.58.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xYalu5jK"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=NxjU6FJY3mJdOvbma4FjYi/nASPrN1wq1SXwm6/ym68=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790199362; v=1; x=1790804162;
 b=xYalu5jKXCuds1BwOu6yv+c6D4KL+Lpn2enaXDYAcyRoOkJTv3407LgmqvmMKCXU9BTbjz5W
 wqhRk6L3Rje7dBoL6aPxPwXTFFKuVPj+OOg6XufL1Nv+tAy58NS4K1QJW+KU8RfsmxDZUfVE8O7
 JVzsV/F6DBR2hnoBX7Brv3zM=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 67839a3140c965e2;
	Wed, 23 Sep 2026 21:36:02 +0000
X-Mizu-Trace-ID: 67839a3140c965e2
X-Migadu-Flow: FLOW_OUT
From: Luka Gejak <luka.gejak@linux.dev>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH v4 0/6] wifi: rtw88: add RTL8723B/RTL8723BS support
Date: Wed, 23 Sep 2026 23:35:51 +0200
Message-ID: <20260923213557.186205-1-luka.gejak@linux.dev>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is the second of two series adding support for the Realtek RTL8723B
802.11n chipset and its RTL8723BS SDIO variant to rtw88. The preparation
series has now landed in rtw-next; this series contains only the chip
register definitions, the BB/RF/AGC tables, the chip driver, the SDIO
bind, the build glue and the MAINTAINERS entry.

The preparation series was posted separately as v11 with seven patches and
is not part of this series. The six patches here apply on the rtw-next
branch as it stands after those changes were merged, and they can be read
on their own: apart from the register definitions in reg.h, the chip code
adds nothing to the shared rtw88 core. The series is split by file and
dependency so that the register definitions, tables, chip implementation,
SDIO bind, build glue and MAINTAINERS changes can be reviewed
independently.

The driver supports:

  - RTL8723B / RTL8723BS, SDIO only;
  - 2.4 GHz 802.11n, HT20 and HT40;
  - one spatial stream;
  - station mode.

Only station mode has been validated. The common rtw88 core advertises AP
and IBSS for all chips, so those modes are advertised for RTL8723BS as
well, but neither has been tested. An out-of-tree tester has reported AP
mode associating without DHCP completing. The five additional SDIO IDs are
included for parity with the existing staging driver; only the 0xb723
device has been exercised.

The chip driver requests:

  rtw88/rtw8723b_fw.bin

This is the version 41 firmware extracted from the Realtek rtl8723bs
vendor driver. It was submitted separately to linux-firmware with its
extraction provenance and carries Ping-Ke Shih's Reviewed-by. There is no
known native rtw88 RTL8723B firmware.

The implementation is based on the initial RTL8723B work by Michael
Straube:

  https://github.com/mistraube/rtw88/tree/rtl8723bs

Michael's Co-developed-by and Signed-off-by tags are present on the three
chip-code patches containing code derived from that work.

The known limitations are unchanged. Bluetooth coexistence depends on the
BT firmware's status reports. During A2DP streaming those reports identify
a connected link but do not expose the active profile, so the WiFi
coexistence logic cannot make a correct traffic-aware decision. WiFi
throughput can fall sharply while audio remains smooth. This is documented
rather than guessed around in the WiFi driver. The intermittent RTL8723BS
firmware failure to leave LPS also remains a known limitation;
instrumentation shows a firmware stall rather than a polling timeout that
can be fixed by extending the budget.

Testing
=======

The exact six-commit branch builds with W=1 and links all rtw88 modules
with real modpost. Sparse and smatch were run over the rtw88 directory.
Smatch has no finding in the 8723B files; the run reports an existing
container-of static assertion from include/net/neighbour.h while checking
usb.c. checkpatch --strict is clean apart from the complex-macro report on
TRANS_SEQ_END, which is an initializer macro that rtw8703b.c already
defines in exactly the same way, and the "does MAINTAINERS need updating"
reminder on the file-adding patches, which the last patch answers. git
diff --check is clean and all six commits are GPG-signed.

Hardware validation was run at this exact branch, on top of the applied
preparation series: scan, authentication, association, WPA2 key
negotiation, DHCP, TCP and UDP traffic in both directions, scans under
load, link down/up cycles, reconnects and five module reload cycles, with
a clean dmesg: no warnings, no errors, and no TX-report, H2C or leave-LPS
messages. An extended soak on the same build added twenty reload and
reassociate cycles, longer TCP runs and UDP floods in both access
categories, a 2000 packet ping run, ten scans while connected and idle
periods with power save: nothing was lost, no queue stalled, and dmesg
stayed clean. The test machine provides only s2idle, so suspend and resume
are not covered.

Changes in v4:
  - rebased onto the current rtw-next tip;
  - patch 1 and patch 3 commit messages updated as requested;
  - patch 4: dropped the comment above the five extra SDIO IDs;
  - patch 6: the existing REALTEK WIRELESS DRIVER (rtw88) entry also gains
    an R: line;
  - register hex literals normalized to upper case (0x01e7 -> 0x01E7,
    0x082c -> 0x082C);
  - the Realtek copyright notices in rtw8723b.c, rtw8723b.h,
    rtw8723b_table.c and rtw8723b_table.h are corrected as requested, and
    the rtw8723b.h block is now multi-line like the one in rtw8723b.c;
  - removed comments that the code or the macro name already states,
    including the c2h_ra_report_size explanation, the "See commit
    c7706b1173c7" reference and the Tx Power Tracking section header;
    comment lines in the driver go from 237 to 232;
  - every multi-line comment now starts with an empty line, as coding
    style section 8 asks; eleven comments in the driver are affected,
    each one having had its text moved off the opening line;
  - removed the blank lines left inside six of the seven power-sequence
    tables, so all seven are dense;
  - the RCR comment now says why the value is assigned to hal.rcr rather
    than only written, because rtw_core_start() writes REG_RCR from it
    after power_on;
  - dropped rtw8723b_init_network_type() with MASK_NETTYPE, _NETTYPE() and
    NT_LINK_AP, because the core programs the same field with the same
    value;
  - dropped a duplicate rtw8723b_init_wmac_setting() call from
    rtw8723b_mac_init(), which the init sequence already calls;
  - dropped the file-local SDIO predicate in favour of the shared
    rtw_is_8723bs(), which rx.c, tx.c and sdio.c already use; seven call
    sites;
  - dropped the now-redundant single-statement braces in reassert_rx_path,
    and a duplicate REG_FWHW_TXQ_CTRL BIT(12) write that mac_init already
    does;
  - added a WLAN_ANT_SEL macro for the value the REG_LEDCFG2 write uses,
    BIT(7) | BIT(1), which was a literal before;
  - named the remaining magic values: the efuse grant path in reg.h
    (REG_BT_EFUSE_CTRL_8723B, BIT_BT_PWR_CUT, BIT_BT_OUT_ISO, the vendor's
    own wording), 0xffc00000 as OFDM_SWING_MASK with __ffs() for the
    shift, 0x3 as BIT_DIS_SECOND_CCA, and the two remaining REG_RF_CTRL
    literals as WLAN_RF_CTRL_ENABLE;
  - both usleep_range(1000, 1100) calls are now fsleep(1000);
  - the GNU elvis ?: is now max_t(u8, rtwdev->hal.rf_path_num, 1), which
    is what rtw88 uses elsewhere;
  - reverse x'mas declaration order fixed in eight functions;
  - rtw8723b_hw_spec regrouped to the rtw8822c_hw_spec layout, with
    rx_ldpc and tx_stbc moved out of the early flag block;
  - two debug messages were missing their trailing newline.

Changes in v3:
  - moved the chip series onto the rtw-next tip containing the applied
    preparation series, so no shared-core change is part of this series
    any more: fw, coex, mac80211, main, rx, sdio, tx and sec are untouched
    here and come from the preparation series, which also drops the unused
    rtw_coex_8723bs_ensure_pta_path() helper;
  - split the previous chip commits into six file-oriented patches,
    following the series shape from the v2 review: the chip-only register
    definitions are separated from the chip body, and the body is split
    further into the tables, the chip driver and the SDIO bind;
  - added Michael Straube's Co-developed-by and Signed-off-by to the three
    chip-code patches. v2 credited him in the commit message and in the
    copyright headers, but carried no tag;
  - fixed the chip RCR to retain RX FCS handling: WLAN_RCR_CFG now sets
    BIT_APP_FCS, and every other bit of the value is unchanged. v2 instead
    carried a shared-core exception that stopped advertising
    RX_INCLUDES_FCS for this chip and special-cased the RX path. The chip
    driver sets the bit itself now, so the core keeps its unconditional
    contract;
  - added rtw8723b_read_efuse(), which reuses the 8723x efuse reader and
    fills the chip-specific hardware capability. This chip has no firmware
    hardware feature report, so without it the usable stream count,
    antenna count and supported bandwidths stay zero;
  - efuse access reuses rtw8723x_efuse_grant() instead of open-coding the
    switch, and only the chip's BT power-cut/output-isolation bit is
    written on top of it;
  - power tracking now keeps the TXAGC remnant per path and programs the
    IQK matrix for the path being tracked, rather than always for path A;
  - removed the available-page-threshold and reserved-page helpers, which
    programmed thresholds that were already skipped on SDIO in v2;
  - set_channel_rf() programs both RF paths from a single path A read
    instead of read-modify-writing both paths and re-reading them
    afterwards;
  - path B's RF switch control is addressed through
    REG_FPGA0_XA_RF_SW_CTRL, the upper half of the word the shifted mask
    already selects; 0x0872 would be a 32-bit access on a 2-byte boundary;
  - IQK delays are sleepable, the IQK failure path logs with rtw_warn()
    instead of WARN(1, ...), and the RFK debug print uses REG_IQK_RDY
    instead of the literal 0xe90;
  - coexistence: raw addresses are replaced by the named registers they
    were already equal to (REG_BCN_CTRL, REG_BT_TDMA_TIME,
    REG_BT_STAT_CTRL, REG_GPIO_MUXCFG), the duplicated PTA pin, GNT_BT and
    enhanced-interrupt writes inside coex_set_rfe_type() are gone, and the
    antenna-switch registers use the mainline RFE naming;
  - dropped register definitions that no longer have a user
    (REG_BT_COEX_CTRL_8723B, REG_FPGA0_XB_RF_SW_CTRL, BIT_DIS_ATIM) and
    the two rtw8723b.h copies of registers rtw8703b.h already defines;
  - renamed the CCK swing tables from rtw8732b_* to rtw8723b_* and
    recorded why row 20 deliberately differs from the v5.2.17 vendor
    transcription; the values themselves are unchanged from v2;
  - added the five additional SDIO ids for parity with the staging driver,
    together with a comment that only 0xb723 has been verified;
  - the remaining comment, naming and typo cleanups in the chip files. The
    build glue, MAINTAINERS entry, table contents and copyright headers
    are unchanged from v2.

Luka Gejak (6):
  wifi: rtw88: 8723b: add the RTL8723B register definitions
  wifi: rtw88: 8723b: add the RTL8723B BB, RF and AGC tables
  wifi: rtw88: 8723b: add the RTL8723B chip driver
  wifi: rtw88: 8723bs: add the RTL8723BS SDIO bind
  wifi: rtw88: 8723bs: enable building the RTL8723BS driver
  MAINTAINERS: add entry for the RTL8723B rtw88 driver

 MAINTAINERS                                   |    8 +
 drivers/net/wireless/realtek/rtw88/Kconfig    |   18 +
 drivers/net/wireless/realtek/rtw88/Makefile   |    6 +
 drivers/net/wireless/realtek/rtw88/reg.h      |   35 +
 drivers/net/wireless/realtek/rtw88/rtw8723b.c | 2831 +++++++++++++++++
 drivers/net/wireless/realtek/rtw88/rtw8723b.h |   13 +
 .../wireless/realtek/rtw88/rtw8723b_table.c   |  862 +++++
 .../wireless/realtek/rtw88/rtw8723b_table.h   |   18 +
 .../net/wireless/realtek/rtw88/rtw8723bs.c    |   60 +
 9 files changed, 3851 insertions(+)
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723b.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723b.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723b_table.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723b_table.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723bs.c

-- 
2.55.0

