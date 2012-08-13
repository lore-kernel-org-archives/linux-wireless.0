Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:21397 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab2HMPXZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2012 11:23:25 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [RFC 3/3] ath9k_htc: Remove interface combination specific checks
Date: Mon, 13 Aug 2012 20:53:12 +0530
Message-ID: <1344871392-6642-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120813_172338_088155_54724171)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Once the driver advertizes interface combination logic
based on its firmware/hardware limitation, cfg80211
takes care of all the necessary logic such as maximum
beaconing vifs, standlone interface etc.

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   20 --------------------
 1 files changed, 0 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index c785129..a37ae41 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1038,26 +1038,6 @@ static int ath9k_htc_add_interface(struct ieee80211_hw *hw,
 
 	mutex_lock(&priv->mutex);
 
-	if (priv->nvifs >= ATH9K_HTC_MAX_VIF) {
-		mutex_unlock(&priv->mutex);
-		return -ENOBUFS;
-	}
-
-	if (priv->num_ibss_vif ||
-	    (priv->nvifs && vif->type == NL80211_IFTYPE_ADHOC)) {
-		ath_err(common, "IBSS coexistence with other modes is not allowed\n");
-		mutex_unlock(&priv->mutex);
-		return -ENOBUFS;
-	}
-
-	if (((vif->type == NL80211_IFTYPE_AP) ||
-	     (vif->type == NL80211_IFTYPE_ADHOC)) &&
-	    ((priv->num_ap_vif + priv->num_ibss_vif) >= ATH9K_HTC_MAX_BCN_VIF)) {
-		ath_err(common, "Max. number of beaconing interfaces reached\n");
-		mutex_unlock(&priv->mutex);
-		return -ENOBUFS;
-	}
-
 	ath9k_htc_ps_wakeup(priv);
 	memset(&hvif, 0, sizeof(struct ath9k_htc_target_vif));
 	memcpy(&hvif.myaddr, vif->addr, ETH_ALEN);
-- 
1.7.0.4

