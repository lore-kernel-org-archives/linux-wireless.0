Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:36262 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbZHTWIX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2009 18:08:23 -0400
Received: by fxm17 with SMTP id 17so179486fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2009 15:08:24 -0700 (PDT)
Message-ID: <4A8DC955.9060100@gmail.com>
Date: Fri, 21 Aug 2009 00:08:21 +0200
From: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
CC: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Rafael Laufer <rlaufer@cs.ucla.edu>,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] iwlwifi: Make injection of non-broadcast frames work again
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit 1ccb84d87d04df3c76cd4352fe69786d8c7cf016 by Wey-Yi Guy
("iwlwifi: clean up unused NL80211_IFTYPE_MONITOR for Monitor mode")
broke injection of non-broadcast frames to unassociated stations
(causing a SYSASSERT for all such injected frames), due to injected
frames no longer automatically getting a broadcast station ID assigned,
and instead ending up with invalid station IDs.
This patch restores the old behavior, fixing the aforementioned
regression.

Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
---
This fixes a regression introduced between 2.6.30 and 2.6.31-rc1.
Please apply to 2.6.31.

 drivers/net/wireless/iwlwifi/iwl-sta.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index c6633fe..81a656f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -1054,7 +1054,8 @@ int iwl_get_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr)
 	__le16 fc = hdr->frame_control;
 
 	/* If this frame is broadcast or management, use broadcast station id */
-	if (!ieee80211_is_data(fc) ||  is_multicast_ether_addr(hdr->addr1))
+	if (!ieee80211_is_data(fc) || is_multicast_ether_addr(hdr->addr1) ||
+	    iwl_is_monitor_mode(priv)) /* Injected frames need broadcast too */
 		return priv->hw_params.bcast_sta_id;
 
 	switch (priv->iw_mode) {
-- 
1.6.2.4



