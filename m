Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:6010 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210AbbC3I3U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 04:29:20 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4/5] wil6210: stop_ap to leave interface closed
Date: Mon, 30 Mar 2015 11:28:53 +0300
Message-Id: <1427704134-30699-5-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150330_102927_412153_35AF5F44)
In-Reply-To: <1427704134-30699-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1427704134-30699-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

cfg80211_ops.stop_ap supposed to have interface closed
as post condition. Fulfill this requirement.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index ec46a94..b51ac10 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -822,13 +822,9 @@ static int wil_cfg80211_stop_ap(struct wiphy *wiphy,
 	wmi_pcp_stop(wil);
 
 	__wil_down(wil);
-	__wil_up(wil);
 
 	mutex_unlock(&wil->mutex);
 
-	/* some functions above might fail (e.g. __wil_up). Nevertheless, we
-	 * return success because AP has stopped
-	 */
 	return 0;
 }
 
-- 
2.1.0

