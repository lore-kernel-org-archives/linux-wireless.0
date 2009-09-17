Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:62030 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757955AbZIQRn5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2009 13:43:57 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 12/13 v2.6.32 and w-t] iwlwifi: do not send sync command while holding spinlock
Date: Thu, 17 Sep 2009 10:43:55 -0700
Message-Id: <1253209436-2309-13-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1253209436-2309-1-git-send-email-reinette.chatre@intel.com>
References: <1253209436-2309-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit 10c994ca70e8e94bbc85a5bf13de5911ee8de4d2 "iwlwifi: fix remove key
error" fixed an error reported by mac80211 during interface down. The fix
involved changing an async command to synchronous. Unfortunately this was
inside a spinlock section in which we cannot sleep.

Modify the sending of the command back to async. This causes the mac80211
error "mac80211-phy0: failed to remove key (0, ff:ff:ff:ff:ff:ff) from
hardware (-16)." to return. This error is not serious since this occurs
during interface down and the keys will be cleared anyway when ucode is
unloaded. Having this error message is thus less serious than a potential
deadlock introduced when sleeping while holding a spinlock. We will have to
find another fix for that error.

This is a revert of the abovementioned commit.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-sta.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index a2b9ec8..c6633fe 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -520,7 +520,7 @@ int iwl_send_static_wepkey_cmd(struct iwl_priv *priv, u8 send_if_empty)
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_WEPKEY,
 		.data = wep_cmd,
-		.flags = CMD_SYNC,
+		.flags = CMD_ASYNC,
 	};
 
 	memset(wep_cmd, 0, cmd_size +
-- 
1.5.6.3

