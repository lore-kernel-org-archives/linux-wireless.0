Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-cys01nam02on0041.outbound.protection.outlook.com ([104.47.37.41]:61440
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754463AbdHYCa6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Aug 2017 22:30:58 -0400
From: igor.mitsyanko.os@quantenna.com
To: linux-wireless@vger.kernel.org
Cc: sergey.matyukevich.os@quantenna.com, avinashp@quantenna.com,
        johannes@sipsolutions.net,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: [PATCH 13/27] qtnfmac: pass VIF info to SendChannel command
Date: Thu, 24 Aug 2017 19:30:10 -0700
Message-Id: <20170825023024.10565-14-igor.mitsyanko.os@quantenna.com> (sfid-20170825_044309_058347_64607BE2)
In-Reply-To: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com>
References: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 2 +-
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 5 +++--
 drivers/net/wireless/quantenna/qtnfmac/commands.h | 2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index 062189b..b33c4fc 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -760,7 +760,7 @@ static int qtnf_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 		return -EINVAL;
 	}
 
-	ret = qtnf_cmd_send_chan_switch(mac, params);
+	ret = qtnf_cmd_send_chan_switch(vif, params);
 	if (ret)
 		pr_warn("%s: failed to switch to channel (%u)\n",
 			dev->name, params->chandef.chan->hw_value);
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index 195b777..cfbb636 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -2316,15 +2316,16 @@ int qtnf_cmd_get_chan_stats(struct qtnf_wmac *mac, u16 channel,
 	return ret;
 }
 
-int qtnf_cmd_send_chan_switch(struct qtnf_wmac *mac,
+int qtnf_cmd_send_chan_switch(struct qtnf_vif *vif,
 			      struct cfg80211_csa_settings *params)
 {
+	struct qtnf_wmac *mac = vif->mac;
 	struct qlink_cmd_chan_switch *cmd;
 	struct sk_buff *cmd_skb;
 	u16 res_code = QLINK_CMD_RESULT_OK;
 	int ret;
 
-	cmd_skb = qtnf_cmd_alloc_new_cmdskb(mac->macid, 0x0,
+	cmd_skb = qtnf_cmd_alloc_new_cmdskb(mac->macid, vif->vifid,
 					    QLINK_CMD_CHAN_SWITCH,
 					    sizeof(*cmd));
 
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.h b/drivers/net/wireless/quantenna/qtnfmac/commands.h
index 634b057..e87c4a4 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.h
@@ -74,7 +74,7 @@ int qtnf_cmd_send_updown_intf(struct qtnf_vif *vif,
 int qtnf_cmd_reg_notify(struct qtnf_bus *bus, struct regulatory_request *req);
 int qtnf_cmd_get_chan_stats(struct qtnf_wmac *mac, u16 channel,
 			    struct qtnf_chan_stats *stats);
-int qtnf_cmd_send_chan_switch(struct qtnf_wmac *mac,
+int qtnf_cmd_send_chan_switch(struct qtnf_vif *vif,
 			      struct cfg80211_csa_settings *params);
 int qtnf_cmd_get_channel(struct qtnf_vif *vif, struct cfg80211_chan_def *chdef);
 
-- 
2.9.5
