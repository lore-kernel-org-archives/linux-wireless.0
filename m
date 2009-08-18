Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xi.wantstofly.org ([80.101.37.227]:40167 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbZHRDvB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 23:51:01 -0400
Date: Tue, 18 Aug 2009 05:51:02 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 03/29] mwl8k: sort firmware command list by opcode, and trim unused commands
Message-ID: <20090818035102.GH18639@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   42 +++++++++++++++++++-----------------------
 1 files changed, 19 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 55abf27..9fab145 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -307,25 +307,23 @@ static const struct ieee80211_rate mwl8k_rates[] = {
 #define MWL8K_CMD_GET_HW_SPEC		0x0003
 #define MWL8K_CMD_MAC_MULTICAST_ADR	0x0010
 #define MWL8K_CMD_GET_STAT		0x0014
-#define MWL8K_CMD_RADIO_CONTROL		0x001C
-#define MWL8K_CMD_RF_TX_POWER		0x001E
+#define MWL8K_CMD_RADIO_CONTROL		0x001c
+#define MWL8K_CMD_RF_TX_POWER		0x001e
 #define MWL8K_CMD_SET_PRE_SCAN		0x0107
 #define MWL8K_CMD_SET_POST_SCAN		0x0108
-#define MWL8K_CMD_SET_RF_CHANNEL	0x010A
+#define MWL8K_CMD_SET_RF_CHANNEL	0x010a
+#define MWL8K_CMD_SET_AID		0x010d
+#define MWL8K_CMD_SET_RATE		0x0110
+#define MWL8K_CMD_SET_FINALIZE_JOIN	0x0111
+#define MWL8K_CMD_RTS_THRESHOLD		0x0113
 #define MWL8K_CMD_SET_SLOT		0x0114
+#define MWL8K_CMD_SET_EDCA_PARAMS	0x0115
+#define MWL8K_CMD_SET_WMM_MODE		0x0123
 #define MWL8K_CMD_MIMO_CONFIG		0x0125
+#define MWL8K_CMD_USE_FIXED_RATE	0x0126
 #define MWL8K_CMD_ENABLE_SNIFFER	0x0150
-#define MWL8K_CMD_SET_WMM_MODE		0x0123
-#define MWL8K_CMD_SET_EDCA_PARAMS	0x0115
-#define MWL8K_CMD_SET_FINALIZE_JOIN	0x0111
-#define MWL8K_CMD_UPDATE_STADB		0x1123
 #define MWL8K_CMD_SET_RATEADAPT_MODE	0x0203
-#define MWL8K_CMD_SET_LINKADAPT_MODE	0x0129
-#define MWL8K_CMD_SET_AID		0x010d
-#define MWL8K_CMD_SET_RATE		0x0110
-#define MWL8K_CMD_USE_FIXED_RATE	0x0126
-#define MWL8K_CMD_RTS_THRESHOLD		0x0113
-#define MWL8K_CMD_ENCRYPTION		0x1122
+#define MWL8K_CMD_UPDATE_STADB		0x1123
 
 static const char *mwl8k_cmd_name(u16 cmd, char *buf, int bufsize)
 {
@@ -343,20 +341,18 @@ static const char *mwl8k_cmd_name(u16 cmd, char *buf, int bufsize)
 		MWL8K_CMDNAME(SET_PRE_SCAN);
 		MWL8K_CMDNAME(SET_POST_SCAN);
 		MWL8K_CMDNAME(SET_RF_CHANNEL);
+		MWL8K_CMDNAME(SET_AID);
+		MWL8K_CMDNAME(SET_RATE);
+		MWL8K_CMDNAME(SET_FINALIZE_JOIN);
+		MWL8K_CMDNAME(RTS_THRESHOLD);
 		MWL8K_CMDNAME(SET_SLOT);
+		MWL8K_CMDNAME(SET_EDCA_PARAMS);
+		MWL8K_CMDNAME(SET_WMM_MODE);
 		MWL8K_CMDNAME(MIMO_CONFIG);
+		MWL8K_CMDNAME(USE_FIXED_RATE);
 		MWL8K_CMDNAME(ENABLE_SNIFFER);
-		MWL8K_CMDNAME(SET_WMM_MODE);
-		MWL8K_CMDNAME(SET_EDCA_PARAMS);
-		MWL8K_CMDNAME(SET_FINALIZE_JOIN);
-		MWL8K_CMDNAME(UPDATE_STADB);
 		MWL8K_CMDNAME(SET_RATEADAPT_MODE);
-		MWL8K_CMDNAME(SET_LINKADAPT_MODE);
-		MWL8K_CMDNAME(SET_AID);
-		MWL8K_CMDNAME(SET_RATE);
-		MWL8K_CMDNAME(USE_FIXED_RATE);
-		MWL8K_CMDNAME(RTS_THRESHOLD);
-		MWL8K_CMDNAME(ENCRYPTION);
+		MWL8K_CMDNAME(UPDATE_STADB);
 	default:
 		snprintf(buf, bufsize, "0x%x", cmd);
 	}
-- 
1.5.6.4
