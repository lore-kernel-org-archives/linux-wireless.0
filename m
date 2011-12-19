Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:27541 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383Ab1LSWnh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 17:43:37 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 5/6] iwlwifi: use bus_get_hw_id for IWL_TM_CMD_APP2DEV_GET_DEVICE_ID
Date: Mon, 19 Dec 2011 13:43:12 -0800
Message-Id: <1324330993-24476-6-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111219_234349_466454_CC0288F7)
In-Reply-To: <1324330993-24476-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1324330993-24476-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

instead of doing all the work in IWL_TM_CMD_APP2DEV_GET_DEVICE_ID, just use
the information from bus_get_hw_id()

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-testmode.c |   13 +++----------
 1 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.c b/drivers/net/wireless/iwlwifi/iwl-testmode.c
index 05d3016..4a5cddd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.c
@@ -422,8 +422,7 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 	struct sk_buff *skb;
 	unsigned char *rsp_data_ptr = NULL;
 	int status = 0, rsp_data_len = 0;
-	char buf[32], *ptr = NULL;
-	unsigned int num, devid;
+	u32 devid;
 
 	switch (nla_get_u32(tb[IWL_TM_ATTR_COMMAND])) {
 	case IWL_TM_CMD_APP2DEV_GET_DEVICENAME:
@@ -534,14 +533,8 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 		break;
 
 	case IWL_TM_CMD_APP2DEV_GET_DEVICE_ID:
-		bus_get_hw_id_string(bus(priv), buf, sizeof(buf));
-		ptr = buf;
-		strsep(&ptr, ":");
-		sscanf(strsep(&ptr, ":"), "%x", &num);
-		sscanf(strsep(&ptr, ":"), "%x", &devid);
-		IWL_INFO(priv, "Device ID = 0x%04x, SubDevice ID= 0x%04x\n",
-				num, devid);
-		devid |= (num << 16);
+		devid = bus_get_hw_id(bus(priv));
+		IWL_INFO(priv, "hw version: 0x%x\n", devid);
 
 		skb = cfg80211_testmode_alloc_reply_skb(hw->wiphy, 20);
 		if (!skb) {
-- 
1.7.0.4

