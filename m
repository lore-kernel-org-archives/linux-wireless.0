Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:51502 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752755Ab0BSGDM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2010 01:03:12 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/6] iwlwifi: enable iwl_send_static_wepkey_cmd to sleep
Date: Thu, 18 Feb 2010 22:03:03 -0800
Message-Id: <1266559387-19637-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1266559387-19637-1-git-send-email-reinette.chatre@intel.com>
References: <1266559387-19637-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

iwl_send_static_wepkey_cmd is only called from places that are able to
sleep. Modify it so that it itself is able to sleep.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-sta.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 4a6686f..62aae15 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -549,7 +549,7 @@ int iwl_send_static_wepkey_cmd(struct iwl_priv *priv, u8 send_if_empty)
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_WEPKEY,
 		.data = wep_cmd,
-		.flags = CMD_ASYNC,
+		.flags = CMD_SYNC,
 	};
 
 	memset(wep_cmd, 0, cmd_size +
-- 
1.6.3.3

