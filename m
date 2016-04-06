Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:16995 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbcDFOom (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 10:44:42 -0400
Subject: [PATCH 0/8] ath10k: refactor firmware components
To: <ath10k@lists.infradead.org>
From: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Date: Wed, 6 Apr 2016 17:44:31 +0300
Message-ID: <20160406144355.28399.23733.stgit@potku.adurom.net> (sfid-20160406_164445_906200_F62BCA32)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series refactors various ath10k firmware components into struct
ath10k_fw_components which contains everything firmware related (board
files, meta data and so on). This makes it possible to kill
ath10k_tm_fetch_utf_firmware_api_2() from testmode.c.

Also REALLY old FW API 1 (firmware.bin and otp.bin) support is
removed.

---

Kalle Valo (8):
      ath10k: remove deprecated firmware API 1 support
      ath10k: refactor firmware images to struct ath10k_fw_components
      ath10k: move fw_version inside struct ath10k_fw_file
      ath10k: move fw_features to struct ath10k_fw_file
      ath10k: move wmi_op_version to struct ath10k_fw_file
      ath10k: move htt_op_version to struct ath10k_fw_file
      ath10k: switch testmode to use ath10k_core_fetch_firmware_api_n()
      ath10k: remove enum ath10k_swap_code_seg_bin_type


 drivers/net/wireless/ath/ath10k/core.c     |  321 ++++++++++++----------------
 drivers/net/wireless/ath/ath10k/core.h     |   64 +++---
 drivers/net/wireless/ath/ath10k/debug.c    |   32 ++-
 drivers/net/wireless/ath/ath10k/htt.c      |    2 
 drivers/net/wireless/ath/ath10k/htt.h      |    1 
 drivers/net/wireless/ath/ath10k/htt_rx.c   |    2 
 drivers/net/wireless/ath/ath10k/htt_tx.c   |    9 +
 drivers/net/wireless/ath/ath10k/hw.h       |    2 
 drivers/net/wireless/ath/ath10k/mac.c      |   21 +-
 drivers/net/wireless/ath/ath10k/pci.c      |    1 
 drivers/net/wireless/ath/ath10k/swap.c     |   43 ++--
 drivers/net/wireless/ath/ath10k/swap.h     |    9 -
 drivers/net/wireless/ath/ath10k/testmode.c |  193 +++--------------
 drivers/net/wireless/ath/ath10k/wmi.c      |   13 -
 drivers/net/wireless/ath/ath10k/wow.c      |    7 -
 15 files changed, 276 insertions(+), 444 deletions(-)

