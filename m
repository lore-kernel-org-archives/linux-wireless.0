Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:33739 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754645Ab0AVWWp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 17:22:45 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/1] iwlwifi: fix pointer signedness warning
Date: Fri, 22 Jan 2010 14:22:34 -0800
Message-Id: <1264198954-5884-2-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1264198954-5884-1-git-send-email-reinette.chatre@intel.com>
References: <1264198954-5884-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

There are a few station addresses that are
char *, instead of the normal u8 *; gcc
gives pointer signedness warnings for some
of those, so use u8 * consistently.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-sta.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index cde09a8..90fbdb2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -297,7 +297,7 @@ u8 iwl_add_station(struct iwl_priv *priv, const u8 *addr, bool is_ap, u8 flags,
 }
 EXPORT_SYMBOL(iwl_add_station);
 
-static void iwl_sta_ucode_deactivate(struct iwl_priv *priv, const char *addr)
+static void iwl_sta_ucode_deactivate(struct iwl_priv *priv, const u8 *addr)
 {
 	unsigned long flags;
 	u8 sta_id = iwl_find_station(priv, addr);
@@ -324,7 +324,7 @@ static void iwl_remove_sta_callback(struct iwl_priv *priv,
 {
 	struct iwl_rem_sta_cmd *rm_sta =
 			(struct iwl_rem_sta_cmd *)cmd->cmd.payload;
-	const char *addr = rm_sta->addr;
+	const u8 *addr = rm_sta->addr;
 
 	if (pkt->hdr.flags & IWL_CMD_FAILED_MSK) {
 		IWL_ERR(priv, "Bad return from REPLY_REMOVE_STA (0x%08X)\n",
-- 
1.6.3.3

