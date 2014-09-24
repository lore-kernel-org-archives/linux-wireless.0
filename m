Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:52816 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbaIXLQn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Sep 2014 07:16:43 -0400
Subject: [PATCH v3 0/3] ath10k: export calibration data to user space
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 24 Sep 2014 14:16:39 +0300
Message-ID: <20140924111416.6539.95299.stgit@potku.adurom.net> (sfid-20140924_131654_364821_B46B38B5)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's a small patchset exporting firmware calibration data to user space. This
makes it easier to debug various calibration data related problems.

Please comment.

v3:

* patch 1: fix comment style (Michal)

* patch 3: use ath10k_debug_ prefix (Michal)

v2:

* never unmask the diagnostic window copy engine pipe in
  ath10k_ce_enable_interrupts()

* add locking for diag_read_mem()/diag_write_mem()

---

Kalle Valo (3):
      ath10k: don't enable interrupts for the diagnostic window
      ath10k: add diag_read() to hif ops
      ath10k: add cal_data debugfs file


 drivers/net/wireless/ath/ath10k/ce.c    |   27 ++++++----
 drivers/net/wireless/ath/ath10k/ce.h    |   13 +++++
 drivers/net/wireless/ath/ath10k/debug.c |   82 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/hif.h   |   10 ++++
 drivers/net/wireless/ath/ath10k/hw.h    |    2 +
 drivers/net/wireless/ath/ath10k/pci.c   |   51 ++++++++++++-------
 6 files changed, 155 insertions(+), 30 deletions(-)

