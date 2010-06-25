Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:29064 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756849Ab0FYWnW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jun 2010 18:43:22 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/2] iwlwifi: fix multicast
Date: Fri, 25 Jun 2010 15:43:18 -0700
Message-Id: <1277505799-25306-2-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1277505799-25306-1-git-send-email-reinette.chatre@intel.com>
References: <1277505799-25306-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

commit 3474ad635db371b0d8d0ee40086f15d223d5b6a4
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Thu Apr 29 04:43:05 2010 -0700

    iwlwifi: apply filter flags directly

broke multicast. The reason, it turns out, is that
the code previously checked if ALLMULTI _changed_,
which the new code no longer did, and normally it
_never_ changes. Had somebody changed it manually,
the code prior to my patch there would have been
broken already.

The reason is that we always, unconditionally, ask
the device to pass up all multicast frames, but the
new code made it depend on ALLMULTI which broke it
since now we'd pass up multicast frames depending
on the default filter in the device, which isn't
necessarily what we want (since we don't program it
right now).

Fix this by simply not checking allmulti as we have
allmulti behaviour enabled already anyway.

Reported-by: Maxim Levitsky <maximlevitsky@gmail.com>
Tested-by: Maxim Levitsky <maximlevitsky@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 426e955..5bbc529 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1314,7 +1314,6 @@ void iwl_configure_filter(struct ieee80211_hw *hw,
 			changed_flags, *total_flags);
 
 	CHK(FIF_OTHER_BSS | FIF_PROMISC_IN_BSS, RXON_FILTER_PROMISC_MSK);
-	CHK(FIF_ALLMULTI, RXON_FILTER_ACCEPT_GRP_MSK);
 	CHK(FIF_CONTROL, RXON_FILTER_CTL2HOST_MSK);
 	CHK(FIF_BCN_PRBRESP_PROMISC, RXON_FILTER_BCON_AWARE_MSK);
 
@@ -1329,6 +1328,12 @@ void iwl_configure_filter(struct ieee80211_hw *hw,
 
 	mutex_unlock(&priv->mutex);
 
+	/*
+	 * Receiving all multicast frames is always enabled by the
+	 * default flags setup in iwl_connection_init_rx_config()
+	 * since we currently do not support programming multicast
+	 * filters into the device.
+	 */
 	*total_flags &= FIF_OTHER_BSS | FIF_ALLMULTI | FIF_PROMISC_IN_BSS |
 			FIF_BCN_PRBRESP_PROMISC | FIF_CONTROL;
 }
-- 
1.7.0.4

