Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41579 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932303Ab1EMI5P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 04:57:15 -0400
Received: by mail-ww0-f44.google.com with SMTP id 36so2644123wwa.1
        for <linux-wireless@vger.kernel.org>; Fri, 13 May 2011 01:57:15 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 2/6] wl12xx: declare suspend/resume callbacks (for wowlan)
Date: Fri, 13 May 2011 11:57:09 +0300
Message-Id: <1305277033-6662-3-git-send-email-eliad@wizery.com> (sfid-20110513_105718_674098_50D6DE80)
In-Reply-To: <1305277033-6662-1-git-send-email-eliad@wizery.com>
References: <1305277033-6662-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Additionally, add wow_enabled field to wl, to indicate
whether wowlan was configured.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c   |   19 +++++++++++++++++++
 drivers/net/wireless/wl12xx/wl12xx.h |    6 ++++++
 2 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index f82e736..9ca71ce 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1332,6 +1332,23 @@ static struct notifier_block wl1271_dev_notifier = {
 	.notifier_call = wl1271_dev_notify,
 };
 
+static int wl1271_op_suspend(struct ieee80211_hw *hw,
+			    struct cfg80211_wowlan *wow)
+{
+	struct wl1271 *wl = hw->priv;
+	wl1271_debug(DEBUG_MAC80211, "mac80211 suspend wow=%d", !!wow);
+	wl->wow_enabled = !!wow;
+	return 0;
+}
+
+static int wl1271_op_resume(struct ieee80211_hw *hw)
+{
+	struct wl1271 *wl = hw->priv;
+	wl1271_debug(DEBUG_MAC80211, "mac80211 resume wow=%d",
+		     wl->wow_enabled);
+	return 0;
+}
+
 static int wl1271_op_start(struct ieee80211_hw *hw)
 {
 	wl1271_debug(DEBUG_MAC80211, "mac80211 start");
@@ -3426,6 +3443,8 @@ static const struct ieee80211_ops wl1271_ops = {
 	.stop = wl1271_op_stop,
 	.add_interface = wl1271_op_add_interface,
 	.remove_interface = wl1271_op_remove_interface,
+	.suspend = wl1271_op_suspend,
+	.resume = wl1271_op_resume,
 	.config = wl1271_op_config,
 	.prepare_multicast = wl1271_op_prepare_multicast,
 	.configure_filter = wl1271_op_configure_filter,
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index b760143..f9d0a14 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -564,6 +564,12 @@ struct wl1271 {
 	int tcxo_clock;
 
 	/*
+	 * wowlan trigger was configured during suspend.
+	 * (currently, only "ANY" trigger is supported)
+	 */
+	bool wow_enabled;
+
+	/*
 	 * AP-mode - links indexed by HLID. The global and broadcast links
 	 * are always active.
 	 */
-- 
1.7.0.4

