Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:58997 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab1JLHmX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 03:42:23 -0400
Received: from saunalahti-vams (vs3-12.mail.saunalahti.fi [62.142.5.96])
	by emh06-2.mail.saunalahti.fi (Postfix) with SMTP id 5A6DCC8095
	for <linux-wireless@vger.kernel.org>; Wed, 12 Oct 2011 10:42:19 +0300 (EEST)
Received: from localhost6.localdomain6 (a88-115-188-95.elisa-laajakaista.fi [88.115.188.95])
	by emh05.mail.saunalahti.fi (Postfix) with ESMTP id 447FA27D89
	for <linux-wireless@vger.kernel.org>; Wed, 12 Oct 2011 10:42:16 +0300 (EEST)
Subject: [PATCH] ath6kl: unbreak suspend
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Date: Wed, 12 Oct 2011 10:42:16 +0300
Message-ID: <20111012074216.26442.87419.stgit@localhost6.localdomain6> (sfid-20111012_094227_724001_A7B1207C)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sam Leffler <sleffler@chromium.org>

Add missing {}'s that caused ath6kl_sdio_suspend to always return -EINVAL
causing suspend to be aborted.

kvalo: I broke this in commit f7325b85e ("ath6kl: add sdio debug messages")

Signed-off-by: Sam Leffler <sleffler@chromium.org>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/sdio.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 2394c17..58e31f6 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -724,12 +724,13 @@ static int ath6kl_sdio_suspend(struct ath6kl *ar)
 
 	flags = sdio_get_host_pm_caps(func);
 
-	if (!(flags & MMC_PM_KEEP_POWER))
+	if (!(flags & MMC_PM_KEEP_POWER)) {
 		/* as host doesn't support keep power we need to bail out */
 		ath6kl_dbg(ATH6KL_DBG_SDIO,
 			   "func %d doesn't support MMC_PM_KEEP_POWER\n",
 			   func->num);
 		return -EINVAL;
+	}
 
 	ret = sdio_set_host_pm_flags(func, MMC_PM_KEEP_POWER);
 	if (ret) {

