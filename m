Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:22278 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576Ab2KPMyp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2012 07:54:45 -0500
To: <ath6kl-devel@qca.qualcomm.com>
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
CC: Kalle Valo <kvalo@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH 8/8] ath6kl: minor optimization using if, else if
Date: Fri, 16 Nov 2012 18:24:37 +0530
Message-ID: <1353070477-6183-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20121116_135449_060267_B1AFCEB5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index dc059e2..7f6439b 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -640,13 +640,13 @@ static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 					vif->req_bssid, vif->ch_hint,
 					ar->connect_ctrl_flags, nw_subtype);
 
-	/* disable background scan if period is 0 */
-	if (sme->bg_scan_period == 0)
+	if (sme->bg_scan_period == 0) {
+		/* disable background scan if period is 0 */
 		sme->bg_scan_period = 0xffff;
-
-	/* configure default value if not specified */
-	if (sme->bg_scan_period == -1)
+	} else if (sme->bg_scan_period == -1) {
+		/* configure default value if not specified */
 		sme->bg_scan_period = DEFAULT_BG_SCAN_PERIOD;
+	}
 
 	ath6kl_wmi_scanparams_cmd(ar->wmi, vif->fw_vif_idx, 0, 0,
 				  sme->bg_scan_period, 0, 0, 0, 3, 0, 0, 0);
-- 
1.7.0.4

