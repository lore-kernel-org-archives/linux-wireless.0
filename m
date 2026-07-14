Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE4282EEE92
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jul 2026 17:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784051531; cv=none; b=KiqwM+XblW/fi9ESYoJjyGg8U0Cg9Ub+9LoRW4kE1R9VDnsdJgLP59O03pm0285D5j2rM+jnXv/Mq6c/83CLIH7Vk/lb0RukV9szCZuAGVjwQ79Y+9Nt8A43SPU0UG/YO7fJOlhQGY4awku7NYkZ6MX2ueG1QTBH+2fN78149i4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784051531; c=relaxed/simple;
	bh=NVMCowhCbdeNYjSHuUsYvNBGDkxqTIZpF/yK+D4huxA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=h9cTVh5HNzjaoEaw3XkZLaXD8CmnlgPhwhxJ6I6LGTdLp+iPHZWnO+FbZ3Cwz581IhItAkaEfJQr5PpKBqawi+aY8lWAcOX8q1Miy6DEAiCU91pwbeoC/77eGMoxJ8YlNDiTbetJPXmDqxcajAErW8HA6CitMYqO7c/skeiAoOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Sitzl96j; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Sitzl96j"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784051524;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=z4RknWvMaIDcU/hbkk3+dVUuldTE+TwncJ3Y/5OoE/k=;
	b=Sitzl96j3Q3CMIDA/eJT0ZNY97u5jxZYV/V9DEKj2APqjpWmjoyz2B1HU0/CJZhy+JcqTH
	YQBXITVzEeJQFuFoS1/0FJLwgsAosMlzgx6TMSO36S0m2gwo0rnofrFZrlpmDoz2ywjveI
	+iX2UX8J3+7Gv4k89ov3h36Nw4wwOrQ=
From: luka.gejak@linux.dev
To: linux-wireless@vger.kernel.org
Cc: pkshih@realtek.com,
	straube.linux@gmail.com,
	luka.gejak@linux.dev
Subject: [RFC PATCH v1 0/9] wifi: rtw88: add RTL8723B/RTL8723BS support
Date: Tue, 14 Jul 2026 19:50:58 +0200
Message-ID: <cover.1784047561.git.luka.gejak@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Luka Gejak <luka.gejak@linux.dev>

This RFC adds support for the Realtek RTL8723B 802.11n chipset and its
RTL8723BS SDIO variant to rtw88. The series is SDIO-only; untested PCIe
and USB variants are intentionally left for future work.

RTL8723BS predates rtw88 and uses the available Realtek vendor firmware
(version 41), whose H2C/C2H and association behavior differs from the
firmware used by the existing rtw88 8723-family devices. Supporting it
therefore needs both the common RTL8723B chip implementation and an
8723BS-specific SDIO path for firmware commands, coexistence, power,
association, and TX/RX handling.

The series includes:

  - RTL8723B BB/RF/AGC tables, power sequences and chip operations;
  - the RTL8723BS SDIO binding;
  - the vendor-firmware H2C/C2H interface;
  - management/EAPOL descriptor handling and rate adaptation;
  - WiFi/BT PTA antenna handling during scan and association;
  - soft IPS across the scan-to-connect boundary;
  - the vendor association register sequence; and
  - the RTL8723BS SDIO transfer contract, including RX aggregation,
    FIFO/OQT/free-page accounting, management TX scheduling and bounded
    mac80211 queue back-pressure.

This series is based on the rtw-next branch from pkshih/rtw.

The implementation is based on the initial RTL8723B work by Michael
Straube <straube.linux@gmail.com>. The SDIO integration and subsequent
hardware bring-up were developed and tested on an RTL8723BS system.

Hardware validation covered repeated scan, authentication, association,
WPA2 key negotiation, DHCP, bidirectional traffic, reconnects, link
cycles, module reloads, scans under traffic and a sustained stability
run. The final series also builds cleanly with W=1 at every intermediate
commit. RTL8703B, RTL8723CS/DS and the other rtw88 bus modules continue to
build.

The driver requests this firmware file:

  rtw88/rtw8723b_fw.bin

It is not included in this kernel series. I would appreciate guidance
from Realtek and the linux-firmware maintainers on whether the existing
LICENCE.rtlwifi_firmware.txt redistribution terms cover this version 41
blob, or whether Realtek should submit the firmware directly.

Feedback on the series structure, the placement of the association and
coexistence logic, and the firmware submission path would be appreciated.

Luka Gejak (9):
  wifi: rtw88: add RTL8723B chip support
  wifi: rtw88: 8723bs: handle SDIO management and data TX
  wifi: rtw88: 8723bs: add the firmware host-to-chip interface
  wifi: rtw88: 8723bs: add WiFi/BT coexistence antenna handling
  wifi: rtw88: 8723bs: keep the chip powered between scan and connect
  wifi: rtw88: 8723bs: add scan, calibration and rate-adaptation
    handling
  wifi: rtw88: 8723bs: implement the SDIO association sequence
  wifi: rtw88: 8723bs: implement the SDIO transfer contract
  MAINTAINERS: add entry for the RTL8723B rtw88 driver

 MAINTAINERS                                   |    8 +
 drivers/net/wireless/realtek/rtw88/Kconfig    |   18 +
 drivers/net/wireless/realtek/rtw88/Makefile   |    6 +
 drivers/net/wireless/realtek/rtw88/coex.c     |  237 ++
 drivers/net/wireless/realtek/rtw88/coex.h     |    4 +
 drivers/net/wireless/realtek/rtw88/fw.c       |  171 +-
 drivers/net/wireless/realtek/rtw88/fw.h       |   17 +
 drivers/net/wireless/realtek/rtw88/mac80211.c |  538 ++-
 drivers/net/wireless/realtek/rtw88/main.c     |  191 +-
 drivers/net/wireless/realtek/rtw88/main.h     |   35 +
 drivers/net/wireless/realtek/rtw88/ps.c       |   50 +-
 drivers/net/wireless/realtek/rtw88/reg.h      |    6 +
 drivers/net/wireless/realtek/rtw88/rtw8723b.c | 3382 +++++++++++++++++
 drivers/net/wireless/realtek/rtw88/rtw8723b.h |   16 +
 .../wireless/realtek/rtw88/rtw8723b_table.c   |  858 +++++
 .../wireless/realtek/rtw88/rtw8723b_table.h   |   15 +
 .../net/wireless/realtek/rtw88/rtw8723bs.c    |   36 +
 drivers/net/wireless/realtek/rtw88/rx.c       |    8 +-
 drivers/net/wireless/realtek/rtw88/sdio.c     |  443 ++-
 drivers/net/wireless/realtek/rtw88/sdio.h     |   18 +
 drivers/net/wireless/realtek/rtw88/sec.h      |    1 +
 drivers/net/wireless/realtek/rtw88/tx.c       |  225 +-
 drivers/net/wireless/realtek/rtw88/tx.h       |    5 +
 23 files changed, 6205 insertions(+), 83 deletions(-)
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723b.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723b.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723b_table.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723b_table.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723bs.c


base-commit: 6c080026ecc17eecb103f8927c64ea73a74bb818
-- 
2.55.0

