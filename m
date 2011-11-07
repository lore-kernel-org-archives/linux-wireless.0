Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:61443 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab1KGF1a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Nov 2011 00:27:30 -0500
From: Raja Mani <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH v2 06/11] ath6kl: Move ath6kl_cfg80211_stop() call specific to deep sleep and cut pwr
Date: Mon, 7 Nov 2011 10:55:42 +0530
Message-ID: <1320643547-3578-7-git-send-email-rmani@qca.qualcomm.com> (sfid-20111107_062733_158373_FDDD9263)
In-Reply-To: <1320643547-3578-1-git-send-email-rmani@qca.qualcomm.com>
References: <1320643547-3578-1-git-send-email-rmani@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath6kl_cfg80211_stop() call is not applicable for WOW mode. Hence moving
this call to deep sleep and cut pwr specific cases.

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 1dc7374..2cd43c8 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1759,10 +1759,11 @@ int ath6kl_cfg80211_suspend(struct ath6kl *ar,
 {
 	int ret;
 
-	ath6kl_cfg80211_stop(ar);
-
 	switch (mode) {
 	case ATH6KL_CFG_SUSPEND_DEEPSLEEP:
+
+		ath6kl_cfg80211_stop(ar);
+
 		/* save the current power mode before enabling power save */
 		ar->wmi->saved_pwr_mode = ar->wmi->pwr_mode;
 
@@ -1777,6 +1778,9 @@ int ath6kl_cfg80211_suspend(struct ath6kl *ar,
 		break;
 
 	case ATH6KL_CFG_SUSPEND_CUTPOWER:
+
+		ath6kl_cfg80211_stop(ar);
+
 		if (ar->state == ATH6KL_STATE_OFF) {
 			ath6kl_dbg(ATH6KL_DBG_SUSPEND,
 				   "suspend hw off, no action for cutpower\n");
-- 
1.7.1

