Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:24111 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932642AbcCHLaJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2016 06:30:09 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <wnhuang@google.com>, Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH v2] mwifiex: Empty Tx queue during suspend
Date: Tue, 8 Mar 2016 03:25:17 -0800
Message-ID: <1457436317-15477-1-git-send-email-akarwar@marvell.com> (sfid-20160308_123026_170292_B43B4B0D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In cfg80211 suspend handler, stop the netif queue and
wait until all the Tx queues become empty. Start the
queues in resume handler.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 28 ++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 29b7f6e..bb7235e 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -20,6 +20,7 @@
 #include "cfg80211.h"
 #include "main.h"
 #include "11n.h"
+#include "wmm.h"
 
 static char *reg_alpha2;
 module_param(reg_alpha2, charp, 0);
@@ -3259,7 +3260,7 @@ static int mwifiex_cfg80211_suspend(struct wiphy *wiphy,
 {
 	struct mwifiex_adapter *adapter = mwifiex_cfg80211_get_adapter(wiphy);
 	struct mwifiex_ds_hs_cfg hs_cfg;
-	int i, ret = 0;
+	int i, ret = 0, retry_num = 10;
 	struct mwifiex_private *priv;
 
 	for (i = 0; i < adapter->priv_num; i++) {
@@ -3269,6 +3270,21 @@ static int mwifiex_cfg80211_suspend(struct wiphy *wiphy,
 
 	mwifiex_cancel_all_pending_cmd(adapter);
 
+	for (i = 0; i < adapter->priv_num; i++) {
+		priv = adapter->priv[i];
+		if (priv && priv->netdev)
+			mwifiex_stop_net_dev_queue(priv->netdev, adapter);
+	}
+
+	for (i = 0; i < retry_num; i++) {
+		if (!mwifiex_wmm_lists_empty(adapter) ||
+		    !mwifiex_bypass_txlist_empty(adapter) ||
+		    !skb_queue_empty(&adapter->tx_data_q))
+			usleep_range(10000, 15000);
+		else
+			break;
+	}
+
 	if (!wowlan) {
 		mwifiex_dbg(adapter, ERROR,
 			    "None of the WOWLAN triggers enabled\n");
@@ -3321,12 +3337,18 @@ static int mwifiex_cfg80211_suspend(struct wiphy *wiphy,
 static int mwifiex_cfg80211_resume(struct wiphy *wiphy)
 {
 	struct mwifiex_adapter *adapter = mwifiex_cfg80211_get_adapter(wiphy);
-	struct mwifiex_private *priv =
-		mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA);
+	struct mwifiex_private *priv;
 	struct mwifiex_ds_wakeup_reason wakeup_reason;
 	struct cfg80211_wowlan_wakeup wakeup_report;
 	int i;
 
+	for (i = 0; i < adapter->priv_num; i++) {
+		priv = adapter->priv[i];
+		if (priv && priv->netdev)
+			mwifiex_wake_up_net_dev_queue(priv->netdev, adapter);
+	}
+
+	priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA);
 	mwifiex_get_wakeup_reason(priv, HostCmd_ACT_GEN_GET, MWIFIEX_SYNC_CMD,
 				  &wakeup_reason);
 	memset(&wakeup_report, 0, sizeof(struct cfg80211_wowlan_wakeup));
-- 
1.8.1.4

