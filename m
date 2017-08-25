Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-cys01nam02on0041.outbound.protection.outlook.com ([104.47.37.41]:61440
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754480AbdHYCa7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Aug 2017 22:30:59 -0400
From: igor.mitsyanko.os@quantenna.com
To: linux-wireless@vger.kernel.org
Cc: sergey.matyukevich.os@quantenna.com, avinashp@quantenna.com,
        johannes@sipsolutions.net,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: [PATCH 14/27] qtnfmac: do not cache CSA chandef info
Date: Thu, 24 Aug 2017 19:30:11 -0700
Message-Id: <20170825023024.10565-15-igor.mitsyanko.os@quantenna.com> (sfid-20170825_043107_012331_11318708)
In-Reply-To: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com>
References: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

It is never used for anything useful, and all logic is handled by
either WiFi card or higher layers.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 12 ------------
 drivers/net/wireless/quantenna/qtnfmac/commands.c |  2 --
 drivers/net/wireless/quantenna/qtnfmac/core.h     |  1 -
 drivers/net/wireless/quantenna/qtnfmac/event.c    |  8 +-------
 4 files changed, 1 insertion(+), 22 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index b33c4fc..8542c16 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -736,7 +736,6 @@ qtnf_get_channel(struct wiphy *wiphy, struct wireless_dev *wdev,
 static int qtnf_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 			       struct cfg80211_csa_settings *params)
 {
-	struct qtnf_wmac *mac = wiphy_priv(wiphy);
 	struct qtnf_vif *vif = qtnf_netdev_get_priv(dev);
 	int ret;
 
@@ -744,17 +743,6 @@ static int qtnf_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 		 params->chandef.chan->hw_value, params->count,
 		 params->radar_required, params->block_tx);
 
-	if (vif->vifid != 0) {
-		if (!(mac->status & QTNF_MAC_CSA_ACTIVE))
-			return -EOPNOTSUPP;
-
-		if (!cfg80211_chandef_identical(&params->chandef,
-						&mac->csa_chandef))
-			return -EINVAL;
-
-		return 0;
-	}
-
 	if (!cfg80211_chandef_valid(&params->chandef)) {
 		pr_err("%s: invalid channel\n", dev->name);
 		return -EINVAL;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index cfbb636..7a616f9 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -2347,8 +2347,6 @@ int qtnf_cmd_send_chan_switch(struct qtnf_vif *vif,
 
 	switch (res_code) {
 	case QLINK_CMD_RESULT_OK:
-		memcpy(&mac->csa_chandef, &params->chandef,
-		       sizeof(mac->csa_chandef));
 		mac->status |= QTNF_MAC_CSA_ACTIVE;
 		ret = 0;
 		break;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.h b/drivers/net/wireless/quantenna/qtnfmac/core.h
index aa1a92f..5997915 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.h
@@ -132,7 +132,6 @@ struct qtnf_wmac {
 	struct qtnf_vif iflist[QTNF_MAX_INTF];
 	struct cfg80211_scan_request *scan_req;
 	struct cfg80211_chan_def chandef;
-	struct cfg80211_chan_def csa_chandef;
 	struct mutex mac_lock;	/* lock during wmac speicific ops */
 	struct timer_list scan_timeout;
 };
diff --git a/drivers/net/wireless/quantenna/qtnfmac/event.c b/drivers/net/wireless/quantenna/qtnfmac/event.c
index 7435986..b9ceeed 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/event.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/event.c
@@ -368,13 +368,7 @@ qtnf_event_handle_freq_change(struct qtnf_wmac *mac,
 		 mac->macid, chdef.chan->hw_value, chdef.center_freq1,
 		 chdef.center_freq2, chdef.width);
 
-	if (mac->status & QTNF_MAC_CSA_ACTIVE) {
-		mac->status &= ~QTNF_MAC_CSA_ACTIVE;
-		if (chdef.chan->hw_value != mac->csa_chandef.chan->hw_value)
-			pr_warn("unexpected switch to %u during CSA to %u\n",
-				chdef.chan->hw_value,
-				mac->csa_chandef.chan->hw_value);
-	}
+	mac->status &= ~QTNF_MAC_CSA_ACTIVE;
 
 	memcpy(&mac->chandef, &chdef, sizeof(mac->chandef));
 
-- 
2.9.5
