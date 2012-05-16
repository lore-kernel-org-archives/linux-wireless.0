Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38794 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755925Ab2EPUty (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 16:49:54 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Subject: [PATCH 2/3] iwlwifi: do not send lq cmd when station add fails
Date: Wed, 16 May 2012 22:49:48 +0200
Message-Id: <1337201389-21553-3-git-send-email-johannes@sipsolutions.net> (sfid-20120516_224958_474684_4B4DE0BF)
In-Reply-To: <1337201389-21553-1-git-send-email-johannes@sipsolutions.net>
References: <1337201389-21553-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>

When adding a station fails in
iwl_restore_stations, the driver treats it
like a successful station add and sends a
link quality command, when it it shouldn't.

This patch fixes one of the potential
sources for kernel warnings like this one:

WARNING: at drivers/net/wireless/iwlwifi/iwl-agn-sta.c:905 iwl_send_lq_cmd+0x130/0x217 [iwlwifi]()
Hardware name: 3323A2G
Modules linked in: ...
Pid: 17359, comm: kworker/u:2 Tainted: G           O 3.3.0-wl+ #1
Call Trace:
 [<ffffffff81039620>] warn_slowpath_common+0x7e/0x96
 [<ffffffff8103964d>] warn_slowpath_null+0x15/0x17
 [<ffffffffa02a9f0b>] iwl_send_lq_cmd+0x130/0x217 [iwlwifi]
 [<ffffffffa02aa1fb>] iwl_restore_stations+0x209/0x289 [iwlwifi]
 [<ffffffffa02b07c2>] iwlagn_commit_rxon+0x602/0x7bd [iwlwifi]
 [<ffffffffa02b111f>] iwlagn_bss_info_changed+0x247/0x31a [iwlwifi]
 [<ffffffffa0861437>] ieee80211_bss_info_change_notify+0x1a5/0x1ba [mac80211]
 [<ffffffffa088afad>] ieee80211_destroy_auth_data+0x4b/0x70 [mac80211]
 [<ffffffffa088df26>] ieee80211_sta_work+0xb5/0x954 [mac80211]

Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Reviewed-by: Wey-Yi W Guy <wey-yi.w.guy@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
index 76c1f72..ca9ac20 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -773,7 +773,7 @@ void iwl_restore_stations(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 						~IWL_STA_DRIVER_ACTIVE;
 				priv->stations[i].used &=
 						~IWL_STA_UCODE_INPROGRESS;
-				spin_unlock_bh(&priv->sta_lock);
+				continue;
 			}
 			/*
 			 * Rate scaling has already been initialized, send
-- 
1.7.10

