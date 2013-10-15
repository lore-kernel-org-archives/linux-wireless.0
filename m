Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:39746 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759586Ab3JOSql (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Oct 2013 14:46:41 -0400
Subject: [PATCH 0/7] ath10k: fix WMI atomic usage
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 15 Oct 2013 21:46:37 +0300
Message-ID: <20131015184548.14123.56949.stgit@localhost6.localdomain6> (sfid-20131015_204644_766595_761D2804)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some WMI calls were made in atomic contex, these patches fix
those. Please review.

---

Kalle Valo (2):
      ath10k: fix ath10k_bss_assoc() to not sleep in atomic context
      ath10k: add might_sleep() to ath10k_wmi_cmd_send()

Michal Kazior (5):
      ath10k: use workqueue to set WEP TX key
      ath10k: fix add_interface failure handling
      ath10k: track vif list internally
      ath10k: fix scheduling while atomic config bug
      ath10k: remove unnecessary checks


 drivers/net/wireless/ath/ath10k/core.c |    2 
 drivers/net/wireless/ath/ath10k/core.h |    7 +
 drivers/net/wireless/ath/ath10k/mac.c  |  312 +++++++++++++++++---------------
 drivers/net/wireless/ath/ath10k/wmi.c  |    2 
 4 files changed, 178 insertions(+), 145 deletions(-)

