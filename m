Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:39271 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbaC1HcR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2014 03:32:17 -0400
Subject: [PATCH v2 0/8] ath10k: small cleanups to pci.c
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 28 Mar 2014 09:32:14 +0200
Message-ID: <20140328073040.30438.17966.stgit@potku.adurom.net> (sfid-20140328_083221_210237_086365DF)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While looking at the cold reset problem I did some cleanup
to pci.c.

v2: In patch 1 fix how to check FW_IND_INITIALIZED and also check for 0xffffffff.

---

Kalle Valo (8):
      ath10k: cleanup ath10k_pci_wait_for_target_init()
      ath10k: add module parameter to disable cold reset
      ath10k: fix name of target_ps module parameter
      ath10k: advertise only firmware API 2 files
      ath10k: delete ar_pci->fw_indicator_address
      ath10k: improve pci debug messages
      ath10k: add module parameter values to the pci info print
      ath10k: print chip id during boot


 drivers/net/wireless/ath/ath10k/core.c |    9 +-
 drivers/net/wireless/ath/ath10k/hw.h   |    1 
 drivers/net/wireless/ath/ath10k/pci.c  |  131 ++++++++++++++++++++++----------
 drivers/net/wireless/ath/ath10k/pci.h  |    3 -
 4 files changed, 98 insertions(+), 46 deletions(-)

