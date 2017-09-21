Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bn3nam01on0045.outbound.protection.outlook.com ([104.47.33.45]:56553
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751846AbdIUVfC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Sep 2017 17:35:02 -0400
From: igor.mitsyanko.os@quantenna.com
To: linux-wireless@vger.kernel.org
Cc: sergey.matyukevich.os@quantenna.com, avinashp@quantenna.com,
        johannes@sipsolutions.net
Subject: [PATCH V3 4/9] qtnfmac: do not cache channel info from "connect" command
Date: Thu, 21 Sep 2017 14:34:32 -0700
Message-Id: <20170921213437.27457-5-igor.mitsyanko.os@quantenna.com> (sfid-20170921_233515_286786_B236C57E)
In-Reply-To: <20170921213437.27457-1-igor.mitsyanko.os@quantenna.com>
References: <20170921213437.27457-1-igor.mitsyanko.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

This makes no sense because real operational channel is choosen based
on AP operation, not on what STA is configured to.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 15 +--------------
 drivers/net/wireless/quantenna/qtnfmac/commands.c |  6 ++++--
 2 files changed, 5 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index 0ef1285..17b323e 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -613,8 +613,6 @@ qtnf_connect(struct wiphy *wiphy, struct net_device *dev,
 	     struct cfg80211_connect_params *sme)
 {
 	struct qtnf_vif *vif = qtnf_netdev_get_priv(dev);
-	struct qtnf_wmac *mac = wiphy_priv(wiphy);
-	struct cfg80211_chan_def chandef;
 	struct qtnf_bss_config *bss_cfg;
 	int ret;
 
@@ -627,18 +625,6 @@ qtnf_connect(struct wiphy *wiphy, struct net_device *dev,
 	bss_cfg = &vif->bss_cfg;
 	memset(bss_cfg, 0, sizeof(*bss_cfg));
 
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
 	bss_cfg->ssid_len = sme->ssid_len;
 	memcpy(&bss_cfg->ssid, sme->ssid, bss_cfg->ssid_len);
 	bss_cfg->auth_type = sme->auth_type;
@@ -663,6 +649,7 @@ qtnf_connect(struct wiphy *wiphy, struct net_device *dev,
 		bss_cfg->connect_flags |= QLINK_STA_CONNECT_USE_RRM;
 
 	memcpy(&bss_cfg->crypto, &sme->crypto, sizeof(bss_cfg->crypto));
+
 	if (sme->bssid)
 		ether_addr_copy(bss_cfg->bssid, sme->bssid);
 	else
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index 806b88b..c55bae1 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -2055,8 +2055,10 @@ int qtnf_cmd_send_connect(struct qtnf_vif *vif,
 
 	ether_addr_copy(cmd->bssid, bss_cfg->bssid);
 
-	if (vif->mac->chandef.chan)
-		cmd->channel = cpu_to_le16(vif->mac->chandef.chan->hw_value);
+	if (sme->channel)
+		cmd->channel = cpu_to_le16(sme->channel->hw_value);
+	else
+		cmd->channel = 0;
 
 	cmd->bg_scan_period = cpu_to_le16(bss_cfg->bg_scan_period);
 
-- 
2.9.5
