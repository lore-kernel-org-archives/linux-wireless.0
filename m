Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-cys01nam02on0071.outbound.protection.outlook.com ([104.47.37.71]:39472
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751801AbdIUVfF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Sep 2017 17:35:05 -0400
From: igor.mitsyanko.os@quantenna.com
To: linux-wireless@vger.kernel.org
Cc: sergey.matyukevich.os@quantenna.com, avinashp@quantenna.com,
        johannes@sipsolutions.net
Subject: [PATCH V3 6/9] qtnfmac: pass VIF info to SendChannel command
Date: Thu, 21 Sep 2017 14:34:34 -0700
Message-Id: <20170921213437.27457-7-igor.mitsyanko.os@quantenna.com> (sfid-20170921_233510_636235_DA7F509F)
In-Reply-To: <20170921213437.27457-1-igor.mitsyanko.os@quantenna.com>
References: <20170921213437.27457-1-igor.mitsyanko.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

Do not assume whether wireless device can or can not handle switching
several interfaces on a single radio to different channels. Device will
handle it itself and will return appropriate error code.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 2 +-
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 5 +++--
 drivers/net/wireless/quantenna/qtnfmac/commands.h | 2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index 4590f30..30f8be5 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -846,7 +846,7 @@ static int qtnf_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 		return -EINVAL;
 	}
 
-	ret = qtnf_cmd_send_chan_switch(mac, params);
+	ret = qtnf_cmd_send_chan_switch(vif, params);
 	if (ret)
 		pr_warn("%s: failed to switch to channel (%u)\n",
 			dev->name, params->chandef.chan->hw_value);
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index c55bae1..0138dad 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -2306,15 +2306,16 @@ int qtnf_cmd_get_chan_stats(struct qtnf_wmac *mac, u16 channel,
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
index e1bcb83..8a5a82c 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.h
@@ -73,7 +73,7 @@ int qtnf_cmd_send_updown_intf(struct qtnf_vif *vif,
 int qtnf_cmd_reg_notify(struct qtnf_bus *bus, struct regulatory_request *req);
 int qtnf_cmd_get_chan_stats(struct qtnf_wmac *mac, u16 channel,
 			    struct qtnf_chan_stats *stats);
-int qtnf_cmd_send_chan_switch(struct qtnf_wmac *mac,
+int qtnf_cmd_send_chan_switch(struct qtnf_vif *vif,
 			      struct cfg80211_csa_settings *params);
 int qtnf_cmd_get_channel(struct qtnf_vif *vif, struct cfg80211_chan_def *chdef);
 
-- 
2.9.5
