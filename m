Received: from mta0.migadu.com (out-73.mta0.migadu.com [91.218.175.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50424EB864
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 09:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790846325; cv=none; b=GliI8Xbm8tQRhH930tMRgljtmtt97kqI5R6Gvi8FakLzB9UH3BWRjQbD135nWezG0uQtpYSHcm0epKhuNqLPSDO2BI6xteZ7KnU5kvEasxgM1fyTDv93/sL7Kjaw/BSTgfMCh3KNDhAmT5Dz1PCeIOl6K1A49bAsbiViLrCu1eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790846325; c=relaxed/simple;
	bh=EbMqWJCS2xGgGnvPEqXPpoQSb9q8iQA3GjRYK26q9NY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rH352bcREh+tk4UX6T8Ma2n+BKJGwuwU+MIOzrSezS0z4SBFFeOQnE5DE0S0v4k20OpVNfot1fp17RK3QKhv7FJ/qwjea+GRVHevzDWQJje56/y6jw8fQoFdHFJiho5VbXd14ku5M8iVD8sKHwp5pXg2WP4Qpv9bYJfD4hwbD78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tJBzFl/A; arc=none smtp.client-ip=91.218.175.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tJBzFl/A"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=EbMqWJCS2xGgGnvPEqXPpoQSb9q8iQA3GjRYK26q9NY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790846320; v=1; x=1791451120;
 b=tJBzFl/A3aI0mBFpsn7qYHHS6h5jtmnsxJq7Im88083wLOqFHnaZ/ua7ffvsMUq86p55Q264
 0nXLspBbtC6TyjrfChAr5VVwug9PACnkWjzTJIbRFTkIM1PWScJk5DNWHFAHqGr5cYalUDLClAj
 rdKls2tS7GXrkl7gChlPra5c=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 89bc88340c188995;
	Thu, 01 Oct 2026 09:18:40 +0000
X-Mizu-Trace-ID: 89bc88340c188995
X-Migadu-Flow: FLOW_OUT
From: Luka Gejak <luka.gejak@linux.dev>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH rtw-next v6 0/6] wifi: rtw88: add RTL8723B/RTL8723BS support
Date: Thu,  1 Oct 2026 11:18:29 +0200
Message-ID: <20261001091835.67909-1-luka.gejak@linux.dev>
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

The first patch is the only shared-core change. It moves the CCK power
detect setter out of rtw88xxa.c into phy.c as rtw_phy_cck_pd_set(), so this
chip can use it without pulling in rtw88_88xxa. The six chip patches apply
on top of it and can be read on their own.

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

The exact six-commit branch builds with W=1, with no new warnings, and
links all rtw88 modules with real modpost. Sparse and smatch were run over
the rtw88 directory. Sparse is clean. Smatch reports nothing in the 8723B
files, and its only output is an existing container_of static assertion
from include/net/neighbour.h while checking usb.c. checkpatch --strict is
clean apart from the complex-macro report on TRANS_SEQ_END, which is an
initializer macro that rtw8703b.c already defines in the same way, and the
"does MAINTAINERS need updating" reminder on the file-adding patches, which
the existing REALTEK WIRELESS DRIVER (rtw88) entry already answers with its
F: line. git diff --check is clean and all six commits are GPG-signed.

Hardware validation covered module identity, boot, scan,
authentication, association, WPA2 key negotiation and DHCP, TCP and UDP
traffic in both directions, ten scans while connected, and twenty module
reload and reassociate cycles. dmesg is clean, with no warnings, no errors
and no TX-report, H2C or leave-LPS messages. The extended soak added six 30
second TCP runs, UDP saturation in both access categories with no loss, a
2000 packet ping run with no loss, and three idle power save periods with a
clean wake. The test machine provides only s2idle, so suspend and resume
are not covered.

Changes in v6:
  - the CCK power detect setter is the only helper that moves. The adaptive
    control and EDCA helpers go back to rtw88xxa.c unchanged, so mac.c and
    mac.h are not touched by this series at all;
  - dropped the per-chip RCR patch. Every vendor chip lets rtw_core_start()
    overwrite the value its init path wrote, so the RTL8723B does the same;
  - the chip driver writes the adaptive control and EDCA registers itself
    again, as it did in v4;
  - REG_CCK_SWING moved to reg.h, the SDIO Tx control write is now guarded
    by an HCI type check, and two IQK debug statements are aligned;
  - the IQK matrix locals use lowercase names;
  - subject tags are now [PATCH rtw-next vN n/n], matching the list.

Luka Gejak (6):
  wifi: rtw88: move the 88xxa CCK power detect setter to phy.c
  wifi: rtw88: 8723b: add the RTL8723B register definitions
  wifi: rtw88: 8723b: add the RTL8723B BB, RF and AGC tables
  wifi: rtw88: 8723b: add the RTL8723B chip driver
  wifi: rtw88: 8723bs: add the RTL8723BS SDIO bind
  wifi: rtw88: 8723bs: enable building the RTL8723BS driver

 drivers/net/wireless/realtek/rtw88/Kconfig    |   18 +
 drivers/net/wireless/realtek/rtw88/Makefile   |    6 +
 drivers/net/wireless/realtek/rtw88/phy.c      |   39 +
 drivers/net/wireless/realtek/rtw88/phy.h      |    1 +
 drivers/net/wireless/realtek/rtw88/reg.h      |   34 +
 drivers/net/wireless/realtek/rtw88/rtw8723b.c | 2588 +++++++++++++++++
 drivers/net/wireless/realtek/rtw88/rtw8723b.h |   14 +
 .../wireless/realtek/rtw88/rtw8723b_table.c   |  861 ++++++
 .../wireless/realtek/rtw88/rtw8723b_table.h   |   17 +
 .../net/wireless/realtek/rtw88/rtw8723bs.c    |   59 +
 drivers/net/wireless/realtek/rtw88/rtw8812a.c |    2 +-
 drivers/net/wireless/realtek/rtw88/rtw8821a.c |    2 +-
 drivers/net/wireless/realtek/rtw88/rtw88xxa.c |   38 -
 drivers/net/wireless/realtek/rtw88/rtw88xxa.h |    1 -
 14 files changed, 3639 insertions(+), 41 deletions(-)
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723b.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723b.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723b_table.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723b_table.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723bs.c

-- 
2.55.0

