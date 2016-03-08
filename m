Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:27937 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753483AbcCHHg0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2016 02:36:26 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	<wnhuang@google.com>, Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH] mwifiex: Empty Tx queue during suspend
Date: Mon, 7 Mar 2016 23:31:31 -0800
Message-ID: <1457422291-12962-1-git-send-email-akarwar@marvell.com> (sfid-20160308_083629_145273_33999A1E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In cfg80211 suspend handler, stop the netif queue and
wait until all the Tx queues become empty. Start the
queues in resume handler.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 29b7f6e..21a40b8 100644
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
@@ -3269,6 +3270,19 @@ static int mwifiex_cfg80211_suspend(struct wiphy *wiphy,
 
 	mwifiex_cancel_all_pending_cmd(adapter);
 
+	for (i = 0; i < adapter->priv_num; i++) {
+		priv = adapter->priv[i];
+		if (priv && priv->netdev)
+			mwifiex_stop_net_dev_queue(priv->netdev, adapter);
+	}
+
+	for (i = 0; i < retry_num; i++) {
+		if (!mwifiex_wmm_lists_empty(adapter))
+			usleep_range(10000, 15000);
+		else
+			break;
+	}
+
 	if (!wowlan) {
 		mwifiex_dbg(adapter, ERROR,
 			    "None of the WOWLAN triggers enabled\n");
@@ -3327,6 +3341,13 @@ static int mwifiex_cfg80211_resume(struct wiphy *wiphy)
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

