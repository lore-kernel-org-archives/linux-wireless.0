Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41859 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbaLQKUk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2014 05:20:40 -0500
Subject: [PATCH v2 0/8] ath10k: Add thermal mitigation support
To: <ath10k@lists.infradead.org>
From: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Date: Wed, 17 Dec 2014 12:20:35 +0200
Message-ID: <20141217101755.15964.2625.stgit@potku.adurom.net> (sfid-20141217_112044_251763_1D52B1D5)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following patches add thermal sensor and thermal cooling device
support in ath10k. For sensor, hwmon interface is used. For controlling
temperature cooling device interface is used. For thermal mitigation,
tx throttling is done using hw MAC quiet time setting.

v2:

* use ATH10K_FW_IE_WMI_OP_VERSION instead of a feature flag

* add separate wmi mappings for 10.2.4

* bump up FW API to 4

* new patch: ath10k: set max_num_vdevs based on wmi op version

* new patch: ath10k: use wmi op version to check which iface
  combination to use

* new patch: ath10k: print ath10k wmi op version

---

Kalle Valo (3):
      ath10k: set max_num_vdevs based on wmi op version
      ath10k: use wmi op version to check which iface combination to use
      ath10k: print ath10k wmi op version

Rajkumar Manoharan (5):
      ath10k: add 10.2.4 firmware support
      ath10k: add wmi support for pdev_set_quiet_mode
      ath10k: add thermal cooling device support
      ath10k: add wmi interface for pdev_get_temperature
      ath10k: add thermal sensor device support


 drivers/net/wireless/ath/ath10k/Makefile  |    1 
 drivers/net/wireless/ath/ath10k/core.c    |   30 ++
 drivers/net/wireless/ath/ath10k/core.h    |    4 
 drivers/net/wireless/ath/ath10k/debug.c   |    7 -
 drivers/net/wireless/ath/ath10k/hw.h      |    4 
 drivers/net/wireless/ath/ath10k/mac.c     |   22 +-
 drivers/net/wireless/ath/ath10k/thermal.c |  238 +++++++++++++++++++
 drivers/net/wireless/ath/ath10k/thermal.h |   58 +++++
 drivers/net/wireless/ath/ath10k/wmi-ops.h |   39 +++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |    3 
 drivers/net/wireless/ath/ath10k/wmi.c     |  355 +++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h     |   20 ++
 12 files changed, 764 insertions(+), 17 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath10k/thermal.c
 create mode 100644 drivers/net/wireless/ath/ath10k/thermal.h
