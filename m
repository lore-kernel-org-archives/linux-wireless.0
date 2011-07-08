Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:2126 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752225Ab1GHQUl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2011 12:20:41 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 17/21] iwlagn: add CMD_ON_DEMAND flag for host command from testmode
Date: Fri,  8 Jul 2011 08:46:25 -0700
Message-Id: <1310139989-27661-18-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110708_182052_788355_9A255742)
In-Reply-To: <1310139989-27661-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1310139989-27661-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For all the hist command request from testmode, set the CMD_ON_DEMAND flag.
this flag will be used later to control the uCode behavior

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-dev.h     |    1 +
 drivers/net/wireless/iwlwifi/iwl-sv-open.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 29eb41d..b7e9fd1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -261,6 +261,7 @@ enum {
 	CMD_SYNC = 0,
 	CMD_ASYNC = BIT(0),
 	CMD_WANT_SKB = BIT(1),
+	CMD_ON_DEMAND = BIT(2),
 };
 
 #define DEF_CMD_PAYLOAD_SIZE 320
diff --git a/drivers/net/wireless/iwlwifi/iwl-sv-open.c b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
index 81108be..653b787 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sv-open.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
@@ -232,6 +232,7 @@ static int iwl_testmode_ucode(struct ieee80211_hw *hw, struct nlattr **tb)
 		return -ENOMSG;
 	}
 
+	cmd.flags = CMD_ON_DEMAND;
 	cmd.id = nla_get_u8(tb[IWL_TM_ATTR_UCODE_CMD_ID]);
 	cmd.data[0] = nla_data(tb[IWL_TM_ATTR_UCODE_CMD_DATA]);
 	cmd.len[0] = nla_len(tb[IWL_TM_ATTR_UCODE_CMD_DATA]);
-- 
1.7.0.4

