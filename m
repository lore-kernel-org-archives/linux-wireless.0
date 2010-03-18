Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:23805 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab0CRK11 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Mar 2010 06:27:27 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 19/21] wl1271: Don't generate null func template for ad-hoc
Date: Thu, 18 Mar 2010 12:26:44 +0200
Message-Id: <1268908006-16992-20-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1268908006-16992-1-git-send-email-luciano.coelho@nokia.com>
References: <1268908006-16992-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

The null func template is not needed for ad-hoc, and it's generation is not
supported for ad-hoc (mac80211 will WARN about it.)

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_cmd.c  |   26 +++++++++++++++++++-------
 drivers/net/wireless/wl12xx/wl1271_main.c |    6 ++----
 2 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index 035ddc0..d005729 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -709,18 +709,30 @@ out:
 
 int wl1271_cmd_build_null_data(struct wl1271 *wl)
 {
-	struct sk_buff *skb;
-	int ret = 0;
+	struct sk_buff *skb = NULL;
+	int size;
+	void *ptr;
+	int ret = -ENOMEM;
 
-	skb = ieee80211_nullfunc_get(wl->hw, wl->vif);
-	if (!skb)
-		goto out;
 
-	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_NULL_DATA, skb->data,
-				      skb->len);
+	if (wl->bss_type == BSS_TYPE_IBSS) {
+		size = sizeof(struct wl12xx_null_data_template);
+		ptr = NULL;
+	} else {
+		skb = ieee80211_nullfunc_get(wl->hw, wl->vif);
+		if (!skb)
+			goto out;
+		size = skb->len;
+		ptr = skb->data;
+	}
+
+	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_NULL_DATA, ptr, size);
 
 out:
 	dev_kfree_skb(skb);
+	if (ret)
+		wl1271_warning("cmd buld null data failed %d", ret);
+
 	return ret;
 
 }
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index befc2e9..6f6d366 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1619,12 +1619,10 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 	     */
 	    memcmp(wl->bssid, bss_conf->bssid, ETH_ALEN)) {
 			memcpy(wl->bssid, bss_conf->bssid, ETH_ALEN);
+
 			ret = wl1271_cmd_build_null_data(wl);
-			if (ret < 0) {
-				wl1271_warning("cmd buld null data failed %d",
-					       ret);
+			if (ret < 0)
 				goto out_sleep;
-			}
 
 			/* filter out all packets not from this BSSID */
 			wl1271_configure_filters(wl, 0);
-- 
1.6.3.3

