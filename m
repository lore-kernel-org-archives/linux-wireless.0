Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:34168 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950Ab3I0Qyv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Sep 2013 12:54:51 -0400
Subject: [PATCH v3 0/3] ath10k: implement FW IE support
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 27 Sep 2013 19:54:48 +0300
Message-ID: <20130927164636.2570.24076.stgit@localhost6.localdomain6> (sfid-20130927_185454_776564_D176118D)
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

v3:

* resend with changes really listed in v2

---

Kalle Valo (3):
      ath10k: rename board_data in struct ath10k
      ath10k: store separate pointers for firmware data
      ath10k: implement firmware IE container support


 drivers/net/wireless/ath/ath10k/core.c |  241 +++++++++++++++++++++++++++++---
 drivers/net/wireless/ath/ath10k/core.h |   12 +-
 drivers/net/wireless/ath/ath10k/hw.h   |   19 +++
 drivers/net/wireless/ath/ath10k/wmi.c  |    3 
 4 files changed, 251 insertions(+), 24 deletions(-)

