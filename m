Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:52266 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab2I0Pwb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 11:52:31 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	Antonio Quartulli <ordex@autistici.org>
Subject: [RFC 2/2] ath9k_htc: Remove interface combination specific checks
Date: Thu, 27 Sep 2012 21:22:12 +0530
Message-ID: <1348761132-8344-2-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120927_175235_982777_09F05317)
In-Reply-To: <1348761132-8344-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1348761132-8344-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Once the driver advertizes interface combination logic
based on its firmware/hardware limitation, cfg80211
takes care of all the necessary logic such as maximum
beaconing vifs, standlone interface etc.

Signed-off-by: Antonio Quartulli <ordex@autistici.org>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   20 --------------------
 1 files changed, 0 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index ca78e33..66f6a74 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1036,26 +1036,6 @@ static int ath9k_htc_add_interface(struct ieee80211_hw *hw,
 
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

