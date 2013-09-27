Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:53291 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423Ab3I0NUt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Sep 2013 09:20:49 -0400
Subject: [PATCH v2 0/3] ath10k: implement FW IE support
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 27 Sep 2013 16:20:43 +0300
Message-ID: <20130927131812.20789.9941.stgit@localhost6.localdomain6> (sfid-20130927_152052_512307_0BFBC03F)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

FW IE format is needed for ath10k automatically detect what features the
firmware image supports. This is important especially with 10.x firmwares which
has a different interface.

Please review.

v2:

* added accidentally dropped board file loading (michal)

* check that ATH10K_FW_IE_FW_IMAGE is available, fail otherwise

---

Kalle Valo (3):
      ath10k: rename board_data in struct ath10k
      ath10k: store separate pointers for firmware data
      ath10k: implement firmware IE container support


 drivers/net/wireless/ath/ath10k/core.c |  210 +++++++++++++++++++++++++++++---
 drivers/net/wireless/ath/ath10k/core.h |   12 ++
 drivers/net/wireless/ath/ath10k/hw.h   |   19 +++
 drivers/net/wireless/ath/ath10k/wmi.c  |    3 
 4 files changed, 220 insertions(+), 24 deletions(-)

