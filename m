Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40730 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S933235AbcH2NkK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Aug 2016 09:40:10 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Date: Mon, 29 Aug 2016 16:39:54 +0300
Message-Id: <1472477998-25972-1-git-send-email-luca@coelho.fi> (sfid-20160829_154018_170109_2325E51F)
Subject: [PATCH 1/5] cfg80211: clarify the requirements of .disconnect()
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

cfg80211 expects the .disconnect() handler to call
cfg80211_disconnect() when done. Make this requirement
more explicit.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/net/cfg80211.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 9c23f4d3..d5e7f69 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2423,7 +2423,8 @@ struct cfg80211_qos_map {
  *	cases, the result of roaming is indicated with a call to
  *	cfg80211_roamed() or cfg80211_roamed_bss().
  *	(invoked with the wireless_dev mutex held)
- * @disconnect: Disconnect from the BSS/ESS.
+ * @disconnect: Disconnect from the BSS/ESS. Once done, call
+ *	cfg80211_disconnected().
  *	(invoked with the wireless_dev mutex held)
  *
  * @join_ibss: Join the specified IBSS (or create if necessary). Once done, call
-- 
2.8.1
