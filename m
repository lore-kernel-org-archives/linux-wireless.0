Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:55687 "EHLO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756160Ab2F0PgY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 11:36:24 -0400
Received: by lbbgk8 with SMTP id gk8so1804300lbb.26
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jun 2012 08:36:22 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com
Subject: [PATCH 4/8] wlcore: remove recover cmd from testmode
Date: Wed, 27 Jun 2012 18:35:58 +0300
Message-Id: <1340811362-30441-5-git-send-email-coelho@ti.com> (sfid-20120627_173628_308272_F354C3EF)
In-Reply-To: <1340811362-30441-1-git-send-email-coelho@ti.com>
References: <1340811362-30441-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

This command is buggy (doesn't take the mutex) and unused. Instead, the
"start_recovery" file is used for the same purpose. Remove the code but
keep the command constant to avoid breaking the testmode ABI.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/testmode.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/testmode.c b/drivers/net/wireless/ti/wlcore/testmode.c
index eeb339d..d6f57e2 100644
--- a/drivers/net/wireless/ti/wlcore/testmode.c
+++ b/drivers/net/wireless/ti/wlcore/testmode.c
@@ -40,7 +40,7 @@ enum wl1271_tm_commands {
 	WL1271_TM_CMD_CONFIGURE,
 	WL1271_TM_CMD_NVS_PUSH,		/* Not in use. Keep to not break ABI */
 	WL1271_TM_CMD_SET_PLT_MODE,
-	WL1271_TM_CMD_RECOVER,
+	WL1271_TM_CMD_RECOVER,		/* Not in use. Keep to not break ABI */
 	WL1271_TM_CMD_GET_MAC,
 
 	__WL1271_TM_CMD_AFTER_LAST
@@ -272,15 +272,6 @@ static int wl1271_tm_cmd_set_plt_mode(struct wl1271 *wl, struct nlattr *tb[])
 	return ret;
 }
 
-static int wl1271_tm_cmd_recover(struct wl1271 *wl, struct nlattr *tb[])
-{
-	wl1271_debug(DEBUG_TESTMODE, "testmode cmd recover");
-
-	wl12xx_queue_recovery_work(wl);
-
-	return 0;
-}
-
 static int wl12xx_tm_cmd_get_mac(struct wl1271 *wl, struct nlattr *tb[])
 {
 	struct sk_buff *skb;
@@ -350,8 +341,6 @@ int wl1271_tm_cmd(struct ieee80211_hw *hw, void *data, int len)
 		return wl1271_tm_cmd_configure(wl, tb);
 	case WL1271_TM_CMD_SET_PLT_MODE:
 		return wl1271_tm_cmd_set_plt_mode(wl, tb);
-	case WL1271_TM_CMD_RECOVER:
-		return wl1271_tm_cmd_recover(wl, tb);
 	case WL1271_TM_CMD_GET_MAC:
 		return wl12xx_tm_cmd_get_mac(wl, tb);
 	default:
-- 
1.7.10

