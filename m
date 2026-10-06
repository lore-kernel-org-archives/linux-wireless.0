Received: from mta0.migadu.com (out-123.mta0.migadu.com [91.218.175.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF6F145D5C2
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 13:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791292042; cv=none; b=oW8xhk5O/d5OKd+2zKUoUJBFEHoKbOpQ5UUdLXh2FDSuCxp9kBq8rL2+n7eZAf2ja4dG33E4w5oHHcImrxOXYn+HjJQCjPXF2Ke3YeDfMa/gzPncQvsR4dVxm8Ts2LXbbZhYfkxN4Jiaimh+9z3nxcW0FLVDFnJ7G3YaJ/3PFTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791292042; c=relaxed/simple;
	bh=7Y/+QLl7tirWKLiNc+HxZHMViLq32FyDcLhKzBg9vj8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Hf53xyiT2Zt2opdlBA28+OvKWituv0us47IBGX6u/BIGjVO2KIgbDpYX3Hw85LAdp/HAQ+MhtIK7/tSc/LPpxi+wgVYyczohDglGahexjVzJ60xv00LvTwnxfb2mSp68iRGgs4X+cIjUwQnL7CATzDjtx5624nximyYU1uoof1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Zmrk00vO; arc=none smtp.client-ip=91.218.175.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Zmrk00vO"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=7Y/+QLl7tirWKLiNc+HxZHMViLq32FyDcLhKzBg9vj8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791292038; v=1; x=1791896838;
 b=Zmrk00vOwMgrYcRcgi30V5EO1bb+TekrP/G3cONZXDCDFggYSj29UrtiG0QVkpvIFQejkWlO
 lKvp+PlKh7+oMtmJj3PogPbKgMonwbu1S66S0PLHPwJsKt5as7+17ZIYLDalDXqMixKi8VHuUP7
 add3YcGulSxKGgfGA1vAHlCg=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 8bc8c4593f0d8f00;
	Tue, 06 Oct 2026 13:07:08 +0000
X-Mizu-Trace-ID: 8bc8c4593f0d8f00
X-Migadu-Flow: FLOW_OUT
From: Luka Gejak <luka.gejak@linux.dev>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH rtw-next v8 0/7] wifi: rtw88: add RTL8723B/RTL8723BS support
Date: Tue,  6 Oct 2026 15:06:54 +0200
Message-ID: <20261006130701.120460-1-luka.gejak@linux.dev>
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

The first and fourth patches are the shared-core changes. The first moves
the CCK power detect setter out of rtw88xxa.c into phy.c as
rtw_phy_cck_pd_set(), so this chip can use it without pulling in
rtw88_88xxa. The fourth moves the definitions RTL8723B shares with RTL8703B
into rtw8723x.h. The five chip patches apply on top and can be read on
their own.

The driver supports:

  - RTL8723B / RTL8723BS, SDIO only
  - 2.4 GHz 802.11n, HT20 and HT40
  - one spatial stream
  - station mode

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

The exact seven-commit branch builds with W=1, with no new warnings, and
links all rtw88 modules with real modpost. Sparse and smatch were run over
the rtw88 directory. Sparse is clean. Smatch reports nothing in the 8723B
files, and its only output is an existing container_of static assertion
from include/net/neighbour.h while checking usb.c. checkpatch --strict is
clean apart from the complex-macro report on TRANS_SEQ_END, which is an
initializer macro that rtw8703b.c already defines in the same way, and the
"does MAINTAINERS need updating" reminder on the file-adding patches, which
the existing REALTEK WIRELESS DRIVER (rtw88) entry already answers with its
F: line. git diff --check is clean and all seven commits are GPG-signed.

Hardware validation covered module identity, boot, scan,
authentication, association, WPA2 key negotiation and DHCP, TCP and UDP
traffic in both directions, ten scans while connected, and twenty module
reload and reassociate cycles. dmesg is clean, with no warnings, no errors
and no TX-report, H2C or leave-LPS messages. The extended soak added six 30
second TCP runs, UDP saturation in both access categories with no loss, a
2000 packet ping run with no loss, and three idle power save periods with a
clean wake. The test machine provides only s2idle, so suspend and resume
are not covered.

Changes in v8:
  - a new patch moves the receive PHY status layout, the SDIO aggregation
    burst fields and four baseband registers out of rtw8703b.h into
    rtw8723x.h, and renames struct phy_status_8703b to struct
    phy_status_8723x. The chip driver no longer includes the header of a
    sibling chip. It is a pure move, rtw8703b.c only follows the new struct
    name;
  - the vendor driver's name for that layout, phy_status_rpt_8192cd, is in
    the commit message rather than in the source;
  - dropped the long comment above the CCK swing table;
  - the two receive PHY status helpers take void *phy_raw and read the CCK
    LNA and VGA fields with u8_get_bits().

Luka Gejak (7):
  wifi: rtw88: move the 88xxa CCK power detect setter to phy.c
  wifi: rtw88: 8723b: add the RTL8723B register definitions
  wifi: rtw88: 8723b: add the RTL8723B BB, RF and AGC tables
  wifi: rtw88: move the shared 8723x definitions to rtw8723x.h
  wifi: rtw88: 8723b: add the RTL8723B chip driver
  wifi: rtw88: 8723bs: add the RTL8723BS SDIO bind
  wifi: rtw88: 8723bs: enable building the RTL8723BS driver

 drivers/net/wireless/realtek/rtw88/Kconfig    |   18 +
 drivers/net/wireless/realtek/rtw88/Makefile   |    6 +
 drivers/net/wireless/realtek/rtw88/phy.c      |   39 +
 drivers/net/wireless/realtek/rtw88/phy.h      |    1 +
 drivers/net/wireless/realtek/rtw88/reg.h      |   34 +
 drivers/net/wireless/realtek/rtw88/rtw8703b.c |    4 +-
 drivers/net/wireless/realtek/rtw88/rtw8703b.h |   63 -
 drivers/net/wireless/realtek/rtw88/rtw8723b.c | 2534 +++++++++++++++++
 drivers/net/wireless/realtek/rtw88/rtw8723b.h |   14 +
 .../wireless/realtek/rtw88/rtw8723b_table.c   |  861 ++++++
 .../wireless/realtek/rtw88/rtw8723b_table.h   |   17 +
 .../net/wireless/realtek/rtw88/rtw8723bs.c    |   59 +
 drivers/net/wireless/realtek/rtw88/rtw8723x.h |   60 +
 drivers/net/wireless/realtek/rtw88/rtw8812a.c |    2 +-
 drivers/net/wireless/realtek/rtw88/rtw8821a.c |    2 +-
 drivers/net/wireless/realtek/rtw88/rtw88xxa.c |   38 -
 drivers/net/wireless/realtek/rtw88/rtw88xxa.h |    1 -
 17 files changed, 3647 insertions(+), 106 deletions(-)
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723b.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723b.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723b_table.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723b_table.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723bs.c

-- 
2.55.0

