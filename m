Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:37729 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751692AbcDUPKA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2016 11:10:00 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Wei-Ning Huang <wnhuang@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 2/3] mwifiex: report wowlan wakeup reasons correctly
Date: Thu, 21 Apr 2016 08:07:55 -0700
Message-ID: <1461251276-14891-2-git-send-email-akarwar@marvell.com> (sfid-20160421_171009_447901_CB6758D1)
In-Reply-To: <1461251276-14891-1-git-send-email-akarwar@marvell.com>
References: <1461251276-14891-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's been observed that wakeup on GTK rekey failure wasn't reported
to cfg80211. This patch corrects the check so that all valid wakeup
reasons are reported.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 369ea06..734cf67 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -3344,6 +3344,7 @@ static int mwifiex_cfg80211_resume(struct wiphy *wiphy)
 	struct mwifiex_ds_wakeup_reason wakeup_reason;
 	struct cfg80211_wowlan_wakeup wakeup_report;
 	int i;
+	bool report_wakeup_reason = true;
 
 	for (i = 0; i < adapter->priv_num; i++) {
 		priv = adapter->priv[i];
@@ -3386,20 +3387,16 @@ static int mwifiex_cfg80211_resume(struct wiphy *wiphy)
 		if (wiphy->wowlan_config->n_patterns)
 			wakeup_report.pattern_idx = 1;
 		break;
-	case CONTROL_FRAME_MATCHED:
-		break;
-	case MANAGEMENT_FRAME_MATCHED:
-		break;
 	case GTK_REKEY_FAILURE:
 		if (wiphy->wowlan_config->gtk_rekey_failure)
 			wakeup_report.gtk_rekey_failure = true;
 		break;
 	default:
+		report_wakeup_reason = false;
 		break;
 	}
 
-	if ((wakeup_reason.hs_wakeup_reason > 0) &&
-	    (wakeup_reason.hs_wakeup_reason <= 7))
+	if (report_wakeup_reason)
 		cfg80211_report_wowlan_wakeup(&priv->wdev, &wakeup_report,
 					      GFP_KERNEL);
 
-- 
1.8.1.4

