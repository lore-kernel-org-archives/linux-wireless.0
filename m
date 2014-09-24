Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:49627 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969AbaIXQrV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Sep 2014 12:47:21 -0400
From: Vinod Koul <vinod.koul@intel.com>
To: linux-kernel@vger.kernel.org
Cc: subhransu.s.prusty@intel.com, vinod.koul@intel.com,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	linux-wireless@vger.kernel.org, linux-nfc@lists.01.org
Subject: [PATCH 19/27] NFC: trf7970a: use pm_runtime_last_busy_and_autosuspend helper
Date: Wed, 24 Sep 2014 21:45:09 +0530
Message-Id: <1411575342-31048-20-git-send-email-vinod.koul@intel.com> (sfid-20140924_185219_814386_1FC55703)
In-Reply-To: <1411575342-31048-1-git-send-email-vinod.koul@intel.com>
References: <1411575342-31048-1-git-send-email-vinod.koul@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the new pm_runtime_last_busy_and_autosuspend helper instead of open
coding the same code

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
---
 drivers/nfc/trf7970a.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/trf7970a.c b/drivers/nfc/trf7970a.c
index 3b78b03..d22ca2f 100644
--- a/drivers/nfc/trf7970a.c
+++ b/drivers/nfc/trf7970a.c
@@ -801,8 +801,7 @@ static void trf7970a_switch_rf_off(struct trf7970a *trf)
 	trf->aborting = false;
 	trf->state = TRF7970A_ST_OFF;
 
-	pm_runtime_mark_last_busy(trf->dev);
-	pm_runtime_put_autosuspend(trf->dev);
+	pm_runtime_last_busy_and_autosuspend(trf->dev);
 }
 
 static void trf7970a_switch_rf_on(struct trf7970a *trf)
-- 
1.7.0.4

