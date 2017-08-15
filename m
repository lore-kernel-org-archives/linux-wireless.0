Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:20044 "EHLO
        alexa-out-lv-02.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751467AbdHOIWq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Aug 2017 04:22:46 -0400
Subject: [PATCH 0/6] ath10k: firmware ramdump support
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Date: Tue, 15 Aug 2017 11:22:36 +0300
Message-ID: <150278532045.22482.14490702801292107536.stgit@potku.adurom.net> (sfid-20170815_102251_269096_56E2FE26)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

here are patches adding firmware ramdump support to make it easier to
debug firmware crashes. This also removes the depracated fw_crash_dump
debugfs file.

Kalle

---

Alan Liu (1):
      ath10k: add memory dump support for QCA6174/QCA9377

Kalle Valo (5):
      ath10k: remove deprecated fw_crash_dump debugfs file
      ath10k: refactor firmware crashdump code to coredump.c
      ath10k: detach coredump.c from debug.c
      ath10k: add coredump_mask module parameter
      ath10k: add memory dump support QCA988X


 drivers/net/wireless/ath/ath10k/Makefile   |    1 
 drivers/net/wireless/ath/ath10k/core.c     |   31 +
 drivers/net/wireless/ath/ath10k/core.h     |   17 
 drivers/net/wireless/ath/ath10k/coredump.c |  993 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/coredump.h |  225 ++++++
 drivers/net/wireless/ath/ath10k/debug.c    |  275 --------
 drivers/net/wireless/ath/ath10k/debug.h    |   16 
 drivers/net/wireless/ath/ath10k/hw.h       |    1 
 drivers/net/wireless/ath/ath10k/pci.c      |  220 ++++++
 9 files changed, 1480 insertions(+), 299 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath10k/coredump.c
 create mode 100644 drivers/net/wireless/ath/ath10k/coredump.h
