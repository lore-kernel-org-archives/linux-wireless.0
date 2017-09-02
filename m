Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-co1nam03on0052.outbound.protection.outlook.com ([104.47.40.52]:13344
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750907AbdIBBpG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Sep 2017 21:45:06 -0400
From: igor.mitsyanko.os@quantenna.com
To: linux-wireless@vger.kernel.org
Cc: sergey.matyukevich.os@quantenna.com, avinashp@quantenna.com,
        johannes@sipsolutions.net
Subject: [PATCH V2 7/9] qtnfmac: do not cache CSA chandef info
Date: Fri,  1 Sep 2017 18:44:49 -0700
Message-Id: <20170902014451.17766-8-igor.mitsyanko.os@quantenna.com> (sfid-20170902_034511_033810_04040ED7)
In-Reply-To: <20170902014451.17766-1-igor.mitsyanko.os@quantenna.com>
References: <20170902014451.17766-1-igor.mitsyanko.os@quantenna.com>
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
index 30f8be5..262e8cf 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -809,7 +809,6 @@ qtnf_get_channel(struct wiphy *wiphy, struct wireless_dev *wdev,
 static int qtnf_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 			       struct cfg80211_csa_settings *params)
 {
-	struct qtnf_wmac *mac = wiphy_priv(wiphy);
 	struct qtnf_vif *vif = qtnf_netdev_get_priv(dev);
 	int ret;
 
@@ -830,17 +829,6 @@ static int qtnf_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 		return -EOPNOTSUPP;
 	}
 
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
index 0138dad..42f7e1d 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -2337,8 +2337,6 @@ int qtnf_cmd_send_chan_switch(struct qtnf_vif *vif,
 
 	switch (res_code) {
 	case QLINK_CMD_RESULT_OK:
-		memcpy(&mac->csa_chandef, &params->chandef,
-		       sizeof(mac->csa_chandef));
 		mac->status |= QTNF_MAC_CSA_ACTIVE;
 		ret = 0;
 		break;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.h b/drivers/net/wireless/quantenna/qtnfmac/core.h
index 066fcd1..521ce09 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.h
@@ -147,7 +147,6 @@ struct qtnf_wmac {
 	struct qtnf_vif iflist[QTNF_MAX_INTF];
 	struct cfg80211_scan_request *scan_req;
 	struct cfg80211_chan_def chandef;
-	struct cfg80211_chan_def csa_chandef;
 	struct mutex mac_lock;	/* lock during wmac speicific ops */
 	struct timer_list scan_timeout;
 };
diff --git a/drivers/net/wireless/quantenna/qtnfmac/event.c b/drivers/net/wireless/quantenna/qtnfmac/event.c
index df58e83..77563b0 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/event.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/event.c
@@ -381,13 +381,7 @@ qtnf_event_handle_freq_change(struct qtnf_wmac *mac,
 		 mac->macid, chandef.chan->hw_value, chandef.center_freq1,
 		 chandef.center_freq2, chandef.width);
 
-	if (mac->status & QTNF_MAC_CSA_ACTIVE) {
-		mac->status &= ~QTNF_MAC_CSA_ACTIVE;
-		if (chandef.chan->hw_value != mac->csa_chandef.chan->hw_value)
-			pr_warn("unexpected switch to %u during CSA to %u\n",
-				chandef.chan->hw_value,
-				mac->csa_chandef.chan->hw_value);
-	}
+	mac->status &= ~QTNF_MAC_CSA_ACTIVE;
 
 	memcpy(&mac->chandef, &chandef, sizeof(mac->chandef));
 
-- 
2.9.5
