Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:61189 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754919Ab1F1MvZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jun 2011 08:51:25 -0400
Received: from mail.atheros.com ([10.234.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 28 Jun 2011 05:50:47 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	<stable@kernel.org>
Subject: [PATCH] ath9k: Fix suspend/resume when no interface is UP
Date: Tue, 28 Jun 2011 18:21:19 +0530
Message-ID: <1309265479-3206-1-git-send-email-rmanoharan@atheros.com> (sfid-20110628_150522_091553_C2E9B4A1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>

When no interface has been brought up, the chip's power
state continued as AWAKE. So during resume, the chip never
been powered up.

Cc: stable@kernel.org
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/pci.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index b8cbfc7..3bad0b2 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -278,6 +278,12 @@ static int ath_pci_suspend(struct device *device)
 
 	ath9k_hw_set_gpio(sc->sc_ah, sc->sc_ah->led_pin, 1);
 
+	/* The device has to be moved to FULLSLEEP forcibly.
+	 * Otherwise the chip never moved to full sleep,
+	 * when no interface is up.
+	 */
+	ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_FULL_SLEEP);
+
 	return 0;
 }
 
-- 
1.7.5.2

