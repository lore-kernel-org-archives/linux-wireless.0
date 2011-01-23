Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65238 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204Ab1AWVDU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Jan 2011 16:03:20 -0500
Received: by mail-fx0-f46.google.com with SMTP id 20so3406578fxm.19
        for <linux-wireless@vger.kernel.org>; Sun, 23 Jan 2011 13:03:20 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v2 6/6] wl12xx: configure probe-resp template according to notification
Date: Sun, 23 Jan 2011 23:02:59 +0200
Message-Id: <1295816579-28925-7-git-send-email-arik@wizery.com>
In-Reply-To: <1295816579-28925-1-git-send-email-arik@wizery.com>
References: <1295816579-28925-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When operating in AP-mode, replace probe-response template when a
notification is recieved from mac80211. We preserve the "legacy" way of
configuring a probe-response according to beacon for IBSS mode and for
versions of hostapd that do not support this feature.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |   32 +++++++++++++++++++++++++++++++-
 1 files changed, 31 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 9076555..49d6160 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2041,6 +2041,25 @@ static int wl1271_ssid_set(struct wl1271 *wl, struct sk_buff *skb,
 	return -ENOENT;
 }
 
+static int wl1271_ap_set_probe_resp_tmpl(struct wl1271 *wl, u32 rates)
+{
+	struct sk_buff *skb;
+	int ret;
+
+	skb = ieee80211_proberesp_get(wl->hw, wl->vif);
+	if (!skb)
+		return -EINVAL;
+
+	ret = wl1271_cmd_template_set(wl,
+				      CMD_TEMPL_AP_PROBE_RESPONSE,
+				      skb->data,
+				      skb->len, 0,
+				      rates);
+
+	dev_kfree_skb(skb);
+	return ret;
+}
+
 static int wl1271_bss_erp_info_changed(struct wl1271 *wl,
 				       struct ieee80211_bss_conf *bss_conf,
 				       u32 changed)
@@ -2102,8 +2121,10 @@ static int wl1271_bss_beacon_info_changed(struct wl1271 *wl,
 		struct sk_buff *beacon = ieee80211_beacon_get(wl->hw, vif);
 		u16 tmpl_id;
 
-		if (!beacon)
+		if (!beacon) {
+			ret = -EINVAL;
 			goto out;
+		}
 
 		wl1271_debug(DEBUG_MASTER, "beacon updated");
 
@@ -2139,7 +2160,16 @@ static int wl1271_bss_beacon_info_changed(struct wl1271 *wl,
 			goto out;
 	}
 
+	if ((changed & BSS_CHANGED_AP_PROBE_RESP) && is_ap) {
+		ret = wl1271_ap_set_probe_resp_tmpl(wl,
+						wl1271_tx_min_rate_get(wl));
+		if (ret < 0)
+			goto out;
+	}
+
 out:
+	if (ret != 0)
+		wl1271_error("beacon info change failed: %d", ret);
 	return ret;
 }
 
-- 
1.7.1

