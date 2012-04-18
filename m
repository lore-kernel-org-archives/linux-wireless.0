Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:48207 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990Ab2DRBXW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2012 21:23:22 -0400
From: Ming Jiang <mjiang@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <rmani@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Ming Jiang <mjiang@qca.qualcomm.com>
Subject: [PATCH v2] ath6kl clear the MMC_PM_KEEP_POWER for cutpower case
Date: Wed, 18 Apr 2012 09:25:04 +0800
Message-ID: <1334712304-12666-1-git-send-email-mjiang@qca.qualcomm.com> (sfid-20120418_032326_578749_54223081)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath6kl: If wow deepsleep pno suspend failure driver will choose cutpower.
in this scenario MMC_PM_KEEP_POWER should be cleared so that mmc will power
off the ar6000

Signed-off-by: Ming Jiang <mjiang@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/sdio.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 44ea7a7..f6ac4f7 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -915,6 +915,9 @@ static int ath6kl_sdio_suspend(struct ath6kl *ar, struct cfg80211_wowlan *wow)
 	}
 
 cut_pwr:
+	if (func->card && func->card->host)
+		func->card->host->pm_flags &= ~(MMC_PM_KEEP_POWER);
+
 	return ath6kl_cfg80211_suspend(ar, ATH6KL_CFG_SUSPEND_CUTPOWER, NULL);
 }
 
-- 
1.7.1

