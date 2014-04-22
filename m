Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:48689 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666AbaDVAK1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2014 20:10:27 -0400
Received: by mail-ee0-f45.google.com with SMTP id d17so4014402eek.4
        for <linux-wireless@vger.kernel.org>; Mon, 21 Apr 2014 17:10:26 -0700 (PDT)
From: Grazvydas Ignotas <notasas@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Pavel Machek <pavel@ucw.cz>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
	David Gnedt <david.gnedt@davizone.at>,
	Grazvydas Ignotas <notasas@gmail.com>
Subject: [PATCH 2/4] wl1251: fix null data for IBSS
Date: Tue, 22 Apr 2014 03:09:53 +0300
Message-Id: <1398125395-5579-3-git-send-email-notasas@gmail.com> (sfid-20140422_021033_643492_052F2CC3)
In-Reply-To: <1398125395-5579-1-git-send-email-notasas@gmail.com>
References: <1398125395-5579-1-git-send-email-notasas@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix the WARN below by not calling ieee80211_nullfunc_get() in IBSS mode,
but setting up empty template the same way wl12xx driver does.

WARNING: CPU: 0 PID: 914 at net/mac80211/tx.c:2750 ieee80211_nullfunc_get+0xc0/0xd0 [mac80211]()
Modules linked in: wl1251_sdio wl1251 mac80211 cfg80211
...
[<c00439c0>] (warn_slowpath_null)
[<bf0bdfdc>] (ieee80211_nullfunc_get [mac80211])
[<bf134774>] (wl1251_op_bss_info_changed [wl1251])
[<bf099e14>] (ieee80211_bss_info_change_notify [mac80211])
...

Also perform join command regardless of bss_type as that seems to be
required for proper operation.

Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
---
 drivers/net/wireless/ti/wl1251/main.c |   51 ++++++++++++++++++++++++---------
 1 file changed, 37 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ti/wl1251/main.c b/drivers/net/wireless/ti/wl1251/main.c
index c22e225..f557eb5 100644
--- a/drivers/net/wireless/ti/wl1251/main.c
+++ b/drivers/net/wireless/ti/wl1251/main.c
@@ -550,6 +550,34 @@ static void wl1251_op_remove_interface(struct ieee80211_hw *hw,
 	mutex_unlock(&wl->mutex);
 }
 
+static int wl1251_build_null_data(struct wl1251 *wl)
+{
+	struct sk_buff *skb = NULL;
+	int size;
+	void *ptr;
+	int ret = -ENOMEM;
+
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
+	ret = wl1251_cmd_template_set(wl, CMD_NULL_DATA, ptr, size);
+
+out:
+	dev_kfree_skb(skb);
+	if (ret)
+		wl1251_warning("cmd buld null data failed: %d", ret);
+
+	return ret;
+}
+
 static int wl1251_build_qos_null_data(struct wl1251 *wl)
 {
 	struct ieee80211_qos_hdr template;
@@ -1093,24 +1121,19 @@ static void wl1251_op_bss_info_changed(struct ieee80211_hw *hw,
 		wl->rssi_thold = bss_conf->cqm_rssi_thold;
 	}
 
-	if (changed & BSS_CHANGED_BSSID) {
+	if ((changed & BSS_CHANGED_BSSID) &&
+	    memcmp(wl->bssid, bss_conf->bssid, ETH_ALEN)) {
 		memcpy(wl->bssid, bss_conf->bssid, ETH_ALEN);
 
-		skb = ieee80211_nullfunc_get(wl->hw, wl->vif);
-		if (!skb)
-			goto out_sleep;
-
-		ret = wl1251_cmd_template_set(wl, CMD_NULL_DATA,
-					      skb->data, skb->len);
-		dev_kfree_skb(skb);
-		if (ret < 0)
-			goto out_sleep;
+		if (!is_zero_ether_addr(wl->bssid)) {
+			ret = wl1251_build_null_data(wl);
+			if (ret < 0)
+				goto out_sleep;
 
-		ret = wl1251_build_qos_null_data(wl);
-		if (ret < 0)
-			goto out;
+			ret = wl1251_build_qos_null_data(wl);
+			if (ret < 0)
+				goto out_sleep;
 
-		if (wl->bss_type != BSS_TYPE_IBSS) {
 			ret = wl1251_join(wl, wl->bss_type, wl->channel,
 					  wl->beacon_int, wl->dtim_period);
 			if (ret < 0)
-- 
1.7.9.5

