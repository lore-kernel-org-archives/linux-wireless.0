Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:9226 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932652AbZHUUe3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 16:34:29 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 11/14] iwlwifi: fix remove key error
Date: Fri, 21 Aug 2009 13:34:24 -0700
Message-Id: <1250886867-4112-12-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1250886867-4112-1-git-send-email-reinette.chatre@intel.com>
References: <1250886867-4112-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

Fix following error by sending synchronous command and waiting for the command
to complete.

mac80211-phy0: failed to remove key (0, ff:ff:ff:ff:ff:ff) from hardware (-16).

-16 is EBUSY error. The asynchronous command tests for STATUS_EXIT_PENDING
while interface is getting down and it returns -EBUSY error if set.
Changing the host command from asynchronous call to synchronous call
enables command to be run while interface is going down.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-sta.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index c6633fe..a2b9ec8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -520,7 +520,7 @@ int iwl_send_static_wepkey_cmd(struct iwl_priv *priv, u8 send_if_empty)
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_WEPKEY,
 		.data = wep_cmd,
-		.flags = CMD_ASYNC,
+		.flags = CMD_SYNC,
 	};
 
 	memset(wep_cmd, 0, cmd_size +
-- 
1.5.6.3

