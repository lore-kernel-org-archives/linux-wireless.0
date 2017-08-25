Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-cys01nam02on0041.outbound.protection.outlook.com ([104.47.37.41]:61440
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754482AbdHYCbA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Aug 2017 22:31:00 -0400
From: igor.mitsyanko.os@quantenna.com
To: linux-wireless@vger.kernel.org
Cc: sergey.matyukevich.os@quantenna.com, avinashp@quantenna.com,
        johannes@sipsolutions.net,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: [PATCH 15/27] qtnfmac: remove unused mac::status field
Date: Thu, 24 Aug 2017 19:30:12 -0700
Message-Id: <20170825023024.10565-16-igor.mitsyanko.os@quantenna.com> (sfid-20170825_043152_248084_3A97B014)
In-Reply-To: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com>
References: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

It is no longer used.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 1 -
 drivers/net/wireless/quantenna/qtnfmac/core.h     | 5 -----
 drivers/net/wireless/quantenna/qtnfmac/event.c    | 2 --
 3 files changed, 8 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index 7a616f9..e1f77e4 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -2347,7 +2347,6 @@ int qtnf_cmd_send_chan_switch(struct qtnf_vif *vif,
 
 	switch (res_code) {
 	case QLINK_CMD_RESULT_OK:
-		mac->status |= QTNF_MAC_CSA_ACTIVE;
 		ret = 0;
 		break;
 	case QLINK_CMD_RESULT_ENOTFOUND:
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.h b/drivers/net/wireless/quantenna/qtnfmac/core.h
index 5997915..5234a9e 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.h
@@ -73,10 +73,6 @@ enum qtnf_sta_state {
 	QTNF_STA_CONNECTED
 };
 
-enum qtnf_mac_status {
-	QTNF_MAC_CSA_ACTIVE	= BIT(0)
-};
-
 struct qtnf_vif {
 	struct wireless_dev wdev;
 	u8 bssid[ETH_ALEN];
@@ -126,7 +122,6 @@ struct qtnf_wmac {
 	u8 macid;
 	u8 wiphy_registered;
 	u8 macaddr[ETH_ALEN];
-	u32 status;
 	struct qtnf_bus *bus;
 	struct qtnf_mac_info macinfo;
 	struct qtnf_vif iflist[QTNF_MAX_INTF];
diff --git a/drivers/net/wireless/quantenna/qtnfmac/event.c b/drivers/net/wireless/quantenna/qtnfmac/event.c
index b9ceeed..db7e475 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/event.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/event.c
@@ -368,8 +368,6 @@ qtnf_event_handle_freq_change(struct qtnf_wmac *mac,
 		 mac->macid, chdef.chan->hw_value, chdef.center_freq1,
 		 chdef.center_freq2, chdef.width);
 
-	mac->status &= ~QTNF_MAC_CSA_ACTIVE;
-
 	memcpy(&mac->chandef, &chdef, sizeof(mac->chandef));
 
 	for (i = 0; i < QTNF_MAX_INTF; i++) {
-- 
2.9.5
