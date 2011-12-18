Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:65208 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935Ab1LRSYv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Dec 2011 13:24:51 -0500
Received: by mail-wi0-f174.google.com with SMTP id hm6so675676wib.19
        for <linux-wireless@vger.kernel.org>; Sun, 18 Dec 2011 10:24:50 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/7] wl12xx: implement change_interface
Date: Sun, 18 Dec 2011 20:25:39 +0200
Message-Id: <1324232745-22928-2-git-send-email-eliad@wizery.com> (sfid-20111218_192454_499384_FE3E4082)
In-Reply-To: <1324232745-22928-1-git-send-email-eliad@wizery.com>
References: <1324232745-22928-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Implement the change_interface callback by simply removing the
current vif and adding a new one after updating the vif type.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index c305841..86a7ee3 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2269,6 +2269,16 @@ out:
 	cancel_work_sync(&wl->recovery_work);
 }
 
+static int wl12xx_op_change_interface(struct ieee80211_hw *hw,
+				      struct ieee80211_vif *vif,
+				      enum nl80211_iftype new_type, bool p2p)
+{
+	wl1271_op_remove_interface(hw, vif);
+
+	vif->type = ieee80211_iftype_p2p(new_type, p2p);
+	return wl1271_op_add_interface(hw, vif);
+}
+
 static int wl1271_join(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			  bool set_assoc)
 {
@@ -4629,6 +4639,7 @@ static const struct ieee80211_ops wl1271_ops = {
 	.stop = wl1271_op_stop,
 	.add_interface = wl1271_op_add_interface,
 	.remove_interface = wl1271_op_remove_interface,
+	.change_interface = wl12xx_op_change_interface,
 #ifdef CONFIG_PM
 	.suspend = wl1271_op_suspend,
 	.resume = wl1271_op_resume,
-- 
1.7.6.401.g6a319

