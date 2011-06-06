Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35507 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab1FFKCt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 06:02:49 -0400
Received: by wwa36 with SMTP id 36so3616452wwa.1
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jun 2011 03:02:48 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl12xx: check the vif's operstate after join
Date: Mon,  6 Jun 2011 13:03:12 +0300
Message-Id: <1307354592-32685-1-git-send-email-eliad@wizery.com> (sfid-20110606_120252_585244_138CAD2C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When resuming while connected (without wowlan), the interface
is already IF_OPER_UP, so we won't get the notifier callback,
and hence never complete the association (from wl12xx perspective)

This situation, among other potential problems, prevents the
station from entering psm.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
(this patch depends on the "mac80211: add ieee80211_get_operstate() function"
patch)

 drivers/net/wireless/wl12xx/main.c |   23 ++++++++++++++++++-----
 1 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index fb0f764..546bcc2 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -393,6 +393,22 @@ static struct platform_device wl1271_device = {
 static DEFINE_MUTEX(wl_list_mutex);
 static LIST_HEAD(wl_list);
 
+static int wl1271_check_operstate(struct wl1271 *wl, unsigned char operstate)
+{
+	int ret;
+	if (operstate != IF_OPER_UP)
+		return 0;
+
+	if (test_and_set_bit(WL1271_FLAG_STA_STATE_SENT, &wl->flags))
+		return 0;
+
+	ret = wl1271_cmd_set_sta_state(wl);
+	if (ret < 0)
+		return ret;
+
+	wl1271_info("Association completed.");
+	return 0;
+}
 static int wl1271_dev_notify(struct notifier_block *me, unsigned long what,
 			     void *arg)
 {
@@ -442,11 +458,7 @@ static int wl1271_dev_notify(struct notifier_block *me, unsigned long what,
 	if (ret < 0)
 		goto out;
 
-	if ((dev->operstate == IF_OPER_UP) &&
-	    !test_and_set_bit(WL1271_FLAG_STA_STATE_SENT, &wl->flags)) {
-		wl1271_cmd_set_sta_state(wl);
-		wl1271_info("Association completed.");
-	}
+	wl1271_check_operstate(wl, dev->operstate);
 
 	wl1271_ps_elp_sleep(wl);
 
@@ -3178,6 +3190,7 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 			wl1271_warning("cmd join failed %d", ret);
 			goto out;
 		}
+		wl1271_check_operstate(wl, ieee80211_get_operstate(vif));
 	}
 
 out:
-- 
1.7.0.4

