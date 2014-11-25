Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:53081 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbaKYKY2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2014 05:24:28 -0500
Subject: [PATCH v3 0/2] ath10k: firmware memory debugfs interface
To: <ath10k@lists.infradead.org>
From: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Date: Tue, 25 Nov 2014 12:24:23 +0200
Message-ID: <20141125102302.3951.10641.stgit@potku.adurom.net> (sfid-20141125_112431_880717_B9497874)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

this is v3 of Yanbo's firmware memory debugfs interface.

Changelog:

v3:

* check ath10k state and return an error if firmware is not running

* switch to use conf_mutex because using ar->state

* fix copy_from_user() error handling

v2:

* split patches into two

* simplify the commit logs

* remove extra #include "hif.h" from debug.c

---

Yanbo Li (2):
      ath10k: add register access debugfs interface
      ath10k: add memory dump debugfs interface


 drivers/net/wireless/ath/ath10k/core.h  |    1 
 drivers/net/wireless/ath/ath10k/debug.c |  239 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/hif.h   |   37 +++++
 drivers/net/wireless/ath/ath10k/pci.c   |    3 
 4 files changed, 280 insertions(+)

