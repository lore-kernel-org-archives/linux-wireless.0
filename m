Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-cys01nam02on0041.outbound.protection.outlook.com ([104.47.37.41]:61440
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754471AbdHYCa4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Aug 2017 22:30:56 -0400
From: igor.mitsyanko.os@quantenna.com
To: linux-wireless@vger.kernel.org
Cc: sergey.matyukevich.os@quantenna.com, avinashp@quantenna.com,
        johannes@sipsolutions.net,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: [PATCH 10/27] qtnfmac: do not cache channel info from "connect" command
Date: Thu, 24 Aug 2017 19:30:07 -0700
Message-Id: <20170825023024.10565-11-igor.mitsyanko.os@quantenna.com> (sfid-20170825_043107_693058_ACF16A97)
In-Reply-To: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com>
References: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

This makes no sense because real operational channel is choosen based
on AP operation, not on what STA is configured to.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 14 --------------
 drivers/net/wireless/quantenna/qtnfmac/commands.c |  6 ++++--
 2 files changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index 9eb0c08..501ece3 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -570,8 +570,6 @@ qtnf_connect(struct wiphy *wiphy, struct net_device *dev,
 	     struct cfg80211_connect_params *sme)
 {
 	struct qtnf_vif *vif = qtnf_netdev_get_priv(dev);
-	struct qtnf_wmac *mac = wiphy_priv(wiphy);
-	struct cfg80211_chan_def chandef;
 	int ret;
 
 	if (vif->wdev.iftype != NL80211_IFTYPE_STATION)
@@ -580,18 +578,6 @@ qtnf_connect(struct wiphy *wiphy, struct net_device *dev,
 	if (vif->sta_state != QTNF_STA_DISCONNECTED)
 		return -EBUSY;
 
-	if (sme->channel) {
-		/* FIXME: need to set proper nl80211_channel_type value */
-		cfg80211_chandef_create(&chandef, sme->channel,
-					NL80211_CHAN_HT20);
-		/* fall-back to minimal safe chandef description */
-		if (!cfg80211_chandef_valid(&chandef))
-			cfg80211_chandef_create(&chandef, sme->channel,
-						NL80211_CHAN_HT20);
-
-		memcpy(&mac->chandef, &chandef, sizeof(mac->chandef));
-	}
-
 	if (sme->bssid)
 		ether_addr_copy(vif->bssid, sme->bssid);
 	else
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index 7dbee42..65eee2b 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -2054,8 +2054,10 @@ int qtnf_cmd_send_connect(struct qtnf_vif *vif,
 
 	ether_addr_copy(cmd->bssid, vif->bssid);
 
-	if (vif->mac->chandef.chan)
-		cmd->channel = cpu_to_le16(vif->mac->chandef.chan->hw_value);
+	if (sme->channel)
+		cmd->channel = cpu_to_le16(sme->channel->hw_value);
+	else
+		cmd->channel = 0;
 
 	if ((sme->bg_scan_period > 0) &&
 	    (sme->bg_scan_period <= QTNF_MAX_BG_SCAN_PERIOD))
-- 
2.9.5
