Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:41674 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756268Ab2I0Kin (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 06:38:43 -0400
From: Luciano Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, Eliad Peller <eliad@wizery.com>
Subject: [PATCH 17/31] wlcore: lazy-enable device roles
Date: Thu, 27 Sep 2012 13:37:55 +0300
Message-Id: <1348742289-6587-18-git-send-email-luca@coelho.fi> (sfid-20120927_123939_324561_380E4163)
In-Reply-To: <1348742289-6587-1-git-send-email-luca@coelho.fi>
References: <1348742289-6587-1-git-send-email-luca@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Enable device roles just before starting it.
This way, a single device role should be enough
for all vifs, as we can't use concurrent device
roles (which require ROC) anyway.

Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Luciano Coelho <luca@coelho.fi>
---
 drivers/net/wireless/ti/wlcore/cmd.c  |   16 +++++++++++++++-
 drivers/net/wireless/ti/wlcore/main.c |   19 -------------------
 2 files changed, 15 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index b63995d..4c07a5b 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -1788,10 +1788,17 @@ int wl12xx_start_dev(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 		      wlvif->bss_type == BSS_TYPE_IBSS)))
 		return -EINVAL;
 
-	ret = wl12xx_cmd_role_start_dev(wl, wlvif);
+	ret = wl12xx_cmd_role_enable(wl,
+				     wl12xx_wlvif_to_vif(wlvif)->addr,
+				     WL1271_ROLE_DEVICE,
+				     &wlvif->dev_role_id);
 	if (ret < 0)
 		goto out;
 
+	ret = wl12xx_cmd_role_start_dev(wl, wlvif);
+	if (ret < 0)
+		goto out_disable;
+
 	ret = wl12xx_roc(wl, wlvif, wlvif->dev_role_id);
 	if (ret < 0)
 		goto out_stop;
@@ -1800,6 +1807,8 @@ int wl12xx_start_dev(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 
 out_stop:
 	wl12xx_cmd_role_stop_dev(wl, wlvif);
+out_disable:
+	wl12xx_cmd_role_disable(wl, &wlvif->dev_role_id);
 out:
 	return ret;
 }
@@ -1827,6 +1836,11 @@ int wl12xx_stop_dev(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	ret = wl12xx_cmd_role_stop_dev(wl, wlvif);
 	if (ret < 0)
 		goto out;
+
+	ret = wl12xx_cmd_role_disable(wl, &wlvif->dev_role_id);
+	if (ret < 0)
+		goto out;
+
 out:
 	return ret;
 }
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index dd0cbd9..09f0e44 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -2273,21 +2273,6 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 		}
 	}
 
-	if (wlvif->bss_type == BSS_TYPE_STA_BSS ||
-	    wlvif->bss_type == BSS_TYPE_IBSS) {
-		/*
-		 * The device role is a special role used for
-		 * rx and tx frames prior to association (as
-		 * the STA role can get packets only from
-		 * its associated bssid)
-		 */
-		ret = wl12xx_cmd_role_enable(wl, vif->addr,
-						 WL1271_ROLE_DEVICE,
-						 &wlvif->dev_role_id);
-		if (ret < 0)
-			goto out;
-	}
-
 	ret = wl12xx_cmd_role_enable(wl, vif->addr,
 				     role_type, &wlvif->role_id);
 	if (ret < 0)
@@ -2356,10 +2341,6 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl,
 		    wlvif->bss_type == BSS_TYPE_IBSS) {
 			if (wl12xx_dev_role_started(wlvif))
 				wl12xx_stop_dev(wl, wlvif);
-
-			ret = wl12xx_cmd_role_disable(wl, &wlvif->dev_role_id);
-			if (ret < 0)
-				goto deinit;
 		}
 
 		ret = wl12xx_cmd_role_disable(wl, &wlvif->role_id);
-- 
1.7.10.4

