Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:20825 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754353AbcBVKUR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2016 05:20:17 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>,
	Chris Park <chris.park@atmel.com>
Subject: [PATCH V4 19/24] staging: wilc1000: wilc_wfi_cfgoperations.c: removes unnecessary log messages
Date: Mon, 22 Feb 2016 19:14:26 +0900
Message-ID: <1456136071-10502-20-git-send-email-leo.kim@atmel.com> (sfid-20160222_112100_936231_ACBAF04A)
In-Reply-To: <1456136071-10502-1-git-send-email-leo.kim@atmel.com>
References: <1456136071-10502-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chris Park <chris.park@atmel.com>

This patch removes unnecessary log messages.

Signed-off-by: Chris Park <chris.park@atmel.com>
Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index a8107f1..0fd3a1e 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2315,7 +2315,6 @@ int wilc_init_host_int(struct net_device *net)
 
 	struct wilc_priv *priv;
 
-	PRINT_D(INIT_DBG, "Host[%p][%p]\n", net, net->ieee80211_ptr);
 	priv = wdev_priv(net->ieee80211_ptr);
 	if (op_ifcs == 0) {
 		setup_timer(&hAgingTimer, remove_network_from_shadow, 0);
@@ -2364,24 +2363,17 @@ int wilc_deinit_host_int(struct net_device *net)
 
 void wilc_free_wiphy(struct net_device *net)
 {
-	if (!net) {
-		PRINT_D(INIT_DBG, "net_device is NULL\n");
+	if (!net)
 		return;
-	}
 
-	if (!net->ieee80211_ptr) {
-		PRINT_D(INIT_DBG, "ieee80211_ptr is NULL\n");
+	if (!net->ieee80211_ptr)
 		return;
-	}
 
-	if (!net->ieee80211_ptr->wiphy) {
-		PRINT_D(INIT_DBG, "wiphy is NULL\n");
+	if (!net->ieee80211_ptr->wiphy)
 		return;
-	}
 
 	wiphy_unregister(net->ieee80211_ptr->wiphy);
 
-	PRINT_D(INIT_DBG, "Freeing wiphy\n");
 	wiphy_free(net->ieee80211_ptr->wiphy);
 	kfree(net->ieee80211_ptr);
 }
-- 
1.9.1

