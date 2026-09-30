Received: from mta1.migadu.com (out-10.mta1.migadu.com [95.215.58.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD1C343D9D
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 09:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790759774; cv=none; b=FW9SaQfVusdosRj9ROiTO81bRspEbkF7HWTZAnnye2Wj0f+DQct1FaUmIsPHKX9v6+aA36A3BJue0Lm1+vrbG7jdue4l81MXO/jfkXZFKNHF1FEIs7a4TJAyl9AnqWbM/vM/sgfRNLuNCkoLzUgMTevwyLCgz/MKr11bz1Xbv0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790759774; c=relaxed/simple;
	bh=qfU+kzKzkqn3+OB1AI9eBMO2O5dsMZjVlZWl96JoCsg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=s3QsbFhxud7HNWWpnx5PxxBOcARj2LgsiACWt4iM+QvH5irUGkxf86dvrpfd2G1FZaiJ2G7XtUi0ifYF+Oho0FHyVjL0PRotShyKkd/+SdQkOCmMcuThW8kB/T27w2Y9d23qyGle/rCh0m+UQ6IWxC1a/hzpzvtRmr7PoSoqb68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=eDnh7OZb; arc=none smtp.client-ip=95.215.58.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="eDnh7OZb"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=qfU+kzKzkqn3+OB1AI9eBMO2O5dsMZjVlZWl96JoCsg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790759769; v=1; x=1791364569;
 b=eDnh7OZb5+zuScpSVVQdJOPdCGrAVbLyfGNtEBIDCF4NxowNazAZ39AEPMR1nvAAQRlV6IBR
 qRUgfrQgoA3VqRdBYYRwf4hskHmxNzynA7csID6k9R+Lb83Sd2PpYLc94Cul+u3v2iITIitijSy
 8JAmZDuHsPc5CnFf7pM18WVk=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id aa33b1fa35e44a21;
	Wed, 30 Sep 2026 09:16:09 +0000
X-Mizu-Trace-ID: aa33b1fa35e44a21
X-Migadu-Flow: FLOW_OUT
From: Luka Gejak <luka.gejak@linux.dev>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH v5 rtw-next 0/7] wifi: rtw88: add RTL8723B/RTL8723BS support
Date: Wed, 30 Sep 2026 11:15:57 +0200
Message-ID: <20260930091604.52891-1-luka.gejak@linux.dev>
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
series has landed in rtw-next, so this series carries the chip register
definitions, the BB/RF/AGC tables, the chip driver, the SDIO bind and the
build glue.

The first two patches are new in this version and are the only shared-core
changes. Both were asked for in the v4 review. They move the adaptive
control, EDCA and CCK power detect helpers out of rtw88xxa.c into mac.c
and phy.c, so this chip needs nothing from rtw88_88xxa and gains the CCK
power detect setter v4 left unset, and they let rtw_core_init() take the
RCR from the chip instead of having the chip overwrite hal.rcr from its
own init path. The five chip patches apply on top of them and can be read
on their own.

The driver supports:

  - RTL8723B / RTL8723BS, SDIO only;
  - 2.4 GHz 802.11n, HT20 and HT40;
  - one spatial stream;
  - station mode.

Only station mode has been validated. The common rtw88 core advertises AP
and IBSS for all chips, so those modes are advertised for RTL8723BS as
well, but neither has been tested. An out-of-tree tester has reported AP
mode associating without DHCP completing. The five additional SDIO IDs are
included for parity with the existing staging driver, and only the 0xb723
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
firmware failure to leave LPS also remains, and instrumentation shows a
firmware stall rather than a polling timeout that a longer budget would
fix.

Testing
=======

The exact seven-commit branch builds with W=1 and links all rtw88 modules
with real modpost. Sparse and smatch were run over the rtw88 directory.
Smatch reports nothing in the 8723B files, and its only output is an
existing container_of static assertion from include/net/neighbour.h while
checking usb.c. checkpatch --strict is clean apart from the complex-macro
report on TRANS_SEQ_END, which is an initializer macro that rtw8703b.c
already defines in the same way, and the "does MAINTAINERS need updating"
reminder on the file-adding patches, which the existing REALTEK WIRELESS
DRIVER (rtw88) entry already answers with its F: line. git diff --check is
clean and all seven commits are GPG-signed.

Hardware validation was run at this branch: scan, authentication,
association, WPA2 key negotiation, DHCP, TCP and UDP traffic in both
directions, scans under load, link down/up cycles, reconnects and five
module reload cycles, with a clean dmesg, no warnings, no errors and no
TX-report, H2C or leave-LPS messages. An extended soak on the same build
added twenty reload and reassociate cycles, longer TCP runs and UDP floods
in both access categories, a 2000 packet ping run, ten scans while
connected and idle periods with power save: nothing was lost, no queue
stalled, and dmesg stayed clean. The last rebase only adds rtw88's TX
report timeout rework, which keeps this SDIO chip at the 2500 ms the
preparation series already gave it, so those results carry over. The test
machine provides only s2idle, so suspend and resume are not covered.

Changes in v5:
  - rebased onto the current rtw-next tip;
  - new patch 1: the adaptive control, EDCA and CCK power detect helpers
    move into the core as rtw_mac_init_adaptive_ctrl(),
    rtw_mac_init_edca() and rtw_phy_cck_pd_set(), replacing the copies in
    the chip driver and giving the chip the CCK power detect setter it did
    not have, so RTW88_8723B needs nothing from rtw88_88xxa;
  - new patch 2: rtw_core_init() assigns hal.rcr from a new
    rtw_chip_info::rcr field, and the chip sets that field instead of
    writing hal.rcr from its own init path;
  - dropped rtw8723b_reassert_rx_path() and the set_channel() block that
    called it. The stall it was added for was the firmware dropping
    unicast management frames, and four of the five registers it tested
    already held the value it was about to write;
  - dropped the antenna DPDT write from the power-on flow and its comment:
    rtw_mac_pre_system_cfg() returns before the PAD mux write for an 8051
    chip, so those bits are never set there, and the register reads
    0x00071000 at that point;
  - power tracking no longer reruns the IQK on a thermal drift, only the
    LC calibration, which is what the vendor does for this chip;
  - rtw8723b_lck() now surrounds the calibration with the RF 0xB0 pair
    (0xDFBE0 before and 0xDFFE0 after) that the vendor writes inside its
    own calibration. rtw8723x_lck() does not touch 0xB0, so every
    calibration after the first ran with the LDO off;
  - no MAINTAINERS patch: the existing REALTEK WIRELESS DRIVER (rtw88)
    entry already covers drivers/net/wireless/realtek/rtw88/;
  - commit message corrections in patches 1, 3, 4 and 6.

Luka Gejak (7):
  wifi: rtw88: move the shared 88xxa init helpers into the core
  wifi: rtw88: assign the RCR per chip in rtw_core_init
  wifi: rtw88: 8723b: add the RTL8723B register definitions
  wifi: rtw88: 8723b: add the RTL8723B BB, RF and AGC tables
  wifi: rtw88: 8723b: add the RTL8723B chip driver
  wifi: rtw88: 8723bs: add the RTL8723BS SDIO bind
  wifi: rtw88: 8723bs: enable building the RTL8723BS driver

 drivers/net/wireless/realtek/rtw88/Kconfig    |   18 +
 drivers/net/wireless/realtek/rtw88/Makefile   |    6 +
 drivers/net/wireless/realtek/rtw88/mac.c      |   22 +
 drivers/net/wireless/realtek/rtw88/mac.h      |    2 +
 drivers/net/wireless/realtek/rtw88/main.c     |   10 +-
 drivers/net/wireless/realtek/rtw88/main.h     |    1 +
 drivers/net/wireless/realtek/rtw88/phy.c      |   38 +
 drivers/net/wireless/realtek/rtw88/phy.h      |    1 +
 drivers/net/wireless/realtek/rtw88/reg.h      |   33 +
 drivers/net/wireless/realtek/rtw88/rtw8723b.c | 2585 +++++++++++++++++
 drivers/net/wireless/realtek/rtw88/rtw8723b.h |   14 +
 .../wireless/realtek/rtw88/rtw8723b_table.c   |  861 ++++++
 .../wireless/realtek/rtw88/rtw8723b_table.h   |   17 +
 .../net/wireless/realtek/rtw88/rtw8723bs.c    |   59 +
 drivers/net/wireless/realtek/rtw88/rtw8812a.c |    2 +-
 drivers/net/wireless/realtek/rtw88/rtw8821a.c |    2 +-
 drivers/net/wireless/realtek/rtw88/rtw88xxa.c |   65 +-
 drivers/net/wireless/realtek/rtw88/rtw88xxa.h |    1 -
 18 files changed, 3667 insertions(+), 70 deletions(-)
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723b.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723b.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723b_table.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723b_table.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723bs.c

-- 
2.55.0

