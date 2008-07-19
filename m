Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:49154 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750695AbYGSBE1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2008 21:04:27 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org, "Denis V. Lunev" <den@openvz.org>
Subject: [PATCH 1/1] iwlwifi: RS small compile warnings without CONFIG_IWLWIFI_DEBUG
Date: Sat, 19 Jul 2008 04:04:18 +0300
Message-Id: <1216429458-5978-1-git-send-email-tomas.winkler@intel.com> (sfid-20080719_030430_737060_F9779AC6)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Denis V. Lunev <den@openvz.org>

iwl-agn-rs.c: In function 'rs_clear':
iwl-agn-rs.c:2405: warning: unused variable 'priv

Signed-off-by: Denis V. Lunev <den@openvz.org>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index a8bf5a9..754fef5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -2393,6 +2393,7 @@ static void rs_free(void *priv_rate)
 
 static void rs_clear(void *priv_rate)
 {
+#ifdef CONFIG_IWLWIFI_DEBUG
 	struct iwl_priv *priv = (struct iwl_priv *) priv_rate;
 
 	IWL_DEBUG_RATE("enter\n");
@@ -2400,6 +2401,7 @@ static void rs_clear(void *priv_rate)
 	/* TODO - add rate scale state reset */
 
 	IWL_DEBUG_RATE("leave\n");
+#endif /* CONFIG_IWLWIFI_DEBUG */
 }
 
 static void rs_free_sta(void *priv_rate, void *priv_sta)
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

