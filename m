Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55487 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418Ab1EKPxc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2011 11:53:32 -0400
Received: by wya21 with SMTP id 21so490314wya.19
        for <linux-wireless@vger.kernel.org>; Wed, 11 May 2011 08:53:31 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/7] wl12xx: declare suspend/resume callbacks (for wowlan)
Date: Wed, 11 May 2011 11:54:23 +0300
Message-Id: <1305104068-32240-3-git-send-email-eliad@wizery.com> (sfid-20110511_175339_989914_CDE1E90B)
In-Reply-To: <1305104068-32240-1-git-send-email-eliad@wizery.com>
References: <1305104068-32240-1-git-send-email-eliad@wizery.com>
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

