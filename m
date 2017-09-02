Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-co1nam03on0052.outbound.protection.outlook.com ([104.47.40.52]:13344
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751387AbdIBBpH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Sep 2017 21:45:07 -0400
From: igor.mitsyanko.os@quantenna.com
To: linux-wireless@vger.kernel.org
Cc: sergey.matyukevich.os@quantenna.com, avinashp@quantenna.com,
        johannes@sipsolutions.net
Subject: [PATCH V2 8/9] qtnfmac: remove unused mac::status field
Date: Fri,  1 Sep 2017 18:44:50 -0700
Message-Id: <20170902014451.17766-9-igor.mitsyanko.os@quantenna.com> (sfid-20170902_034516_551343_E6CB42A8)
In-Reply-To: <20170902014451.17766-1-igor.mitsyanko.os@quantenna.com>
References: <20170902014451.17766-1-igor.mitsyanko.os@quantenna.com>
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
index 42f7e1d..8f95f98 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -2337,7 +2337,6 @@ int qtnf_cmd_send_chan_switch(struct qtnf_vif *vif,
 
 	switch (res_code) {
 	case QLINK_CMD_RESULT_OK:
-		mac->status |= QTNF_MAC_CSA_ACTIVE;
 		ret = 0;
 		break;
 	case QLINK_CMD_RESULT_ENOTFOUND:
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.h b/drivers/net/wireless/quantenna/qtnfmac/core.h
index 521ce09..2cd0150 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.h
@@ -89,10 +89,6 @@ enum qtnf_sta_state {
 	QTNF_STA_CONNECTED
 };
 
-enum qtnf_mac_status {
-	QTNF_MAC_CSA_ACTIVE	= BIT(0)
-};
-
 struct qtnf_vif {
 	struct wireless_dev wdev;
 	u8 vifid;
@@ -141,7 +137,6 @@ struct qtnf_wmac {
 	u8 macid;
 	u8 wiphy_registered;
 	u8 macaddr[ETH_ALEN];
-	u32 status;
 	struct qtnf_bus *bus;
 	struct qtnf_mac_info macinfo;
 	struct qtnf_vif iflist[QTNF_MAX_INTF];
diff --git a/drivers/net/wireless/quantenna/qtnfmac/event.c b/drivers/net/wireless/quantenna/qtnfmac/event.c
index 77563b0..b1acc24 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/event.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/event.c
@@ -381,8 +381,6 @@ qtnf_event_handle_freq_change(struct qtnf_wmac *mac,
 		 mac->macid, chandef.chan->hw_value, chandef.center_freq1,
 		 chandef.center_freq2, chandef.width);
 
-	mac->status &= ~QTNF_MAC_CSA_ACTIVE;
-
 	memcpy(&mac->chandef, &chandef, sizeof(mac->chandef));
 
 	for (i = 0; i < QTNF_MAX_INTF; i++) {
-- 
2.9.5
