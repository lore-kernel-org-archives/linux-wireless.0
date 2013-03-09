Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:34412 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756292Ab3CIKBc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Mar 2013 05:01:32 -0500
Subject: [PATCH v2 0/3] ath6kl: fix usb warm reboot and cleanups
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org
Date: Sat, 09 Mar 2013 12:01:26 +0200
Message-ID: <20130309100031.432.94974.stgit@localhost6.localdomain6> (sfid-20130309_110136_300559_3E2C36C4)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While looking at the usb warm reboot I had to some cleanup, especially with error
handling.

v2:

o don't remove reset from ath6kl_stop_txrx()
o line wrap commit logs

---

Kalle Valo (3):
      ath6kl: cleanup ath6kl_reset_device()
      ath6kl: fix usb related error handling and warnings
      ath6kl: cold reset target after host warm boot


 drivers/net/wireless/ath/ath6kl/core.h     |    2 --
 drivers/net/wireless/ath/ath6kl/htc_pipe.c |   12 +++++-----
 drivers/net/wireless/ath/ath6kl/init.c     |   33 +++++++++++++++++++++------
 drivers/net/wireless/ath/ath6kl/main.c     |   33 ---------------------------
 drivers/net/wireless/ath/ath6kl/target.h   |    2 +-
 drivers/net/wireless/ath/ath6kl/usb.c      |   34 ++++++++++++++++++----------
 6 files changed, 55 insertions(+), 61 deletions(-)

