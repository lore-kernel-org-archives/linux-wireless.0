Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:38209 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875Ab2KSQjf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 11:39:35 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so2051752eaa.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Nov 2012 08:39:34 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 02/15] wlcore: set ssid before starting station role
Date: Mon, 19 Nov 2012 18:39:17 +0200
Message-Id: <1353343170-26516-3-git-send-email-eliad@wizery.com> (sfid-20121119_173950_815589_8A5CDE7A)
In-Reply-To: <1353343170-26516-1-git-send-email-eliad@wizery.com>
References: <1353343170-26516-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

start_role(station) takes the ssid as parameter, so set
the correct ssid on BSS_CHANGED_BSSID (just before
calling start_role(sta))

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 41a8502..2cb978e 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -3390,6 +3390,23 @@ static int wl1271_ssid_set(struct ieee80211_vif *vif, struct sk_buff *skb,
 	return 0;
 }
 
+static int wlcore_set_ssid(struct wl1271 *wl, struct wl12xx_vif *wlvif)
+{
+	struct ieee80211_vif *vif = wl12xx_wlvif_to_vif(wlvif);
+	struct sk_buff *skb;
+	int ieoffset;
+
+	skb = ieee80211_ap_probereq_get(wl->hw, vif);
+	if (!skb)
+		return -EINVAL;
+
+	ieoffset = offsetof(struct ieee80211_mgmt,
+			    u.probe_req.variable);
+	wl1271_ssid_set(vif, skb, ieoffset);
+	dev_kfree_skb(skb);
+
+	return 0;
+}
 static void wl12xx_remove_ie(struct sk_buff *skb, u8 eid, int ieoffset)
 {
 	int len;
@@ -3875,6 +3892,8 @@ sta_not_found:
 			if (ret < 0)
 				goto out;
 
+			wlcore_set_ssid(wl, wlvif);
+
 			/* Need to update the BSSID (for filtering etc) */
 			set_bit(WLVIF_FLAG_IN_USE, &wlvif->flags);
 			do_join = true;
-- 
1.7.6.401.g6a319

