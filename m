Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:33997 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756126Ab0J0MJy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Oct 2010 08:09:54 -0400
Received: by wwi18 with SMTP id 18so1468737wwi.1
        for <linux-wireless@vger.kernel.org>; Wed, 27 Oct 2010 05:09:52 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>
Subject: [PATCH 2/2] wl1271: add recover testmode command
Date: Wed, 27 Oct 2010 14:09:58 +0200
Message-Id: <1288181398-2358-2-git-send-email-eliad@wizery.com>
In-Reply-To: <1288181398-2358-1-git-send-email-eliad@wizery.com>
References: <1288181398-2358-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

add RECOVER testmode command.
this command triggers a recovery sequence (by enqueueing a recovery_work).

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/wl1271_testmode.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_testmode.c b/drivers/net/wireless/wl12xx/wl1271_testmode.c
index a3aa843..55ec442 100644
--- a/drivers/net/wireless/wl12xx/wl1271_testmode.c
+++ b/drivers/net/wireless/wl12xx/wl1271_testmode.c
@@ -37,6 +37,7 @@ enum wl1271_tm_commands {
 	WL1271_TM_CMD_CONFIGURE,
 	WL1271_TM_CMD_NVS_PUSH,
 	WL1271_TM_CMD_SET_PLT_MODE,
+	WL1271_TM_CMD_RECOVER,
 
 	__WL1271_TM_CMD_AFTER_LAST
 };
@@ -248,6 +249,15 @@ static int wl1271_tm_cmd_set_plt_mode(struct wl1271 *wl, struct nlattr *tb[])
 	return ret;
 }
 
+static int wl1271_tm_cmd_recover(struct wl1271 *wl, struct nlattr *tb[])
+{
+	wl1271_debug(DEBUG_TESTMODE, "testmode cmd recover");
+
+	ieee80211_queue_work(wl->hw, &wl->recovery_work);
+
+	return 0;
+}
+
 int wl1271_tm_cmd(struct ieee80211_hw *hw, void *data, int len)
 {
 	struct wl1271 *wl = hw->priv;
@@ -272,6 +282,8 @@ int wl1271_tm_cmd(struct ieee80211_hw *hw, void *data, int len)
 		return wl1271_tm_cmd_nvs_push(wl, tb);
 	case WL1271_TM_CMD_SET_PLT_MODE:
 		return wl1271_tm_cmd_set_plt_mode(wl, tb);
+	case WL1271_TM_CMD_RECOVER:
+		return wl1271_tm_cmd_recover(wl, tb);
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
1.7.0.4

