Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49036 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab1LSJ7F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 04:59:05 -0500
Received: by wgbdr13 with SMTP id dr13so10390055wgb.1
        for <linux-wireless@vger.kernel.org>; Mon, 19 Dec 2011 01:59:03 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 1/7] wl12xx: implement change_interface
Date: Mon, 19 Dec 2011 12:00:03 +0200
Message-Id: <1324288803-1666-1-git-send-email-eliad@wizery.com> (sfid-20111219_105909_006242_91293B81)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Implement the change_interface callback by simply removing the
current vif and adding a new one after updating the vif type.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
v2: update vif->p2p as well

 drivers/net/wireless/wl12xx/main.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index c305841..82fc318 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2269,6 +2269,17 @@ out:
 	cancel_work_sync(&wl->recovery_work);
 }
 
+static int wl12xx_op_change_interface(struct ieee80211_hw *hw,
+				      struct ieee80211_vif *vif,
+				      enum nl80211_iftype new_type, bool p2p)
+{
+	wl1271_op_remove_interface(hw, vif);
+
+	vif->type = ieee80211_iftype_p2p(new_type, p2p);
+	vif->p2p = p2p;
+	return wl1271_op_add_interface(hw, vif);
+}
+
 static int wl1271_join(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			  bool set_assoc)
 {
@@ -4629,6 +4640,7 @@ static const struct ieee80211_ops wl1271_ops = {
 	.stop = wl1271_op_stop,
 	.add_interface = wl1271_op_add_interface,
 	.remove_interface = wl1271_op_remove_interface,
+	.change_interface = wl12xx_op_change_interface,
 #ifdef CONFIG_PM
 	.suspend = wl1271_op_suspend,
 	.resume = wl1271_op_resume,
-- 
1.7.6.401.g6a319

