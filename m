Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39057 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146Ab2FUNw5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 09:52:57 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/3] iwlwifi: increase scan timeout
Date: Thu, 21 Jun 2012 15:52:52 +0200
Message-Id: <1340286773-2381-3-git-send-email-johannes@sipsolutions.net> (sfid-20120621_155306_513378_004EA42C)
In-Reply-To: <1340286773-2381-1-git-send-email-johannes@sipsolutions.net>
References: <1340286773-2381-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When the first interface is active, then scanning
on it or the second interface can take a little
longer than 7s (I observed around 8s.) Bump the
timeout to 15s to avoid aborting a scan that is
still running, just taking more time.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/agn.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/agn.h b/drivers/net/wireless/iwlwifi/dvm/agn.h
index 6d10241..9bb16bd 100644
--- a/drivers/net/wireless/iwlwifi/dvm/agn.h
+++ b/drivers/net/wireless/iwlwifi/dvm/agn.h
@@ -269,7 +269,7 @@ void iwl_scan_offchannel_skb_status(struct iwl_priv *priv);
 #define IWL_ACTIVE_QUIET_TIME       cpu_to_le16(10)  /* msec */
 #define IWL_PLCP_QUIET_THRESH       cpu_to_le16(1)  /* packets */
 
-#define IWL_SCAN_CHECK_WATCHDOG		(HZ * 7)
+#define IWL_SCAN_CHECK_WATCHDOG		(HZ * 15)
 
 
 /* bt coex */
-- 
1.7.10

