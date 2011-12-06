Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:63073 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933074Ab1LFKO4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Dec 2011 05:14:56 -0500
Received: by lagp5 with SMTP id p5so1487299lag.19
        for <linux-wireless@vger.kernel.org>; Tue, 06 Dec 2011 02:14:54 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/3] wl12xx: fix testmode test/interrogate commands
Date: Tue,  6 Dec 2011 12:15:05 +0200
Message-Id: <1323166507-32470-1-git-send-email-eliad@wizery.com> (sfid-20111206_111459_642697_0E646A4D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

fix several issues in testmode test/interrogate commands:
1. check the driver state is not OFF.
2. wakeup the chip from elp (if needed)
3. fix memory leak in wl1271_tm_cmd_interrogate()

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/testmode.c |   72 +++++++++++++++++++++++--------
 1 files changed, 53 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/testmode.c b/drivers/net/wireless/wl12xx/testmode.c
index 5b3f781..8d970d0 100644
--- a/drivers/net/wireless/wl12xx/testmode.c
+++ b/drivers/net/wireless/wl12xx/testmode.c
@@ -29,6 +29,7 @@
 #include "debug.h"
 #include "acx.h"
 #include "reg.h"
+#include "ps.h"
 
 #define WL1271_TM_MAX_DATA_LENGTH 1024
 
@@ -89,31 +90,47 @@ static int wl1271_tm_cmd_test(struct wl1271 *wl, struct nlattr *tb[])
 		return -EMSGSIZE;
 
 	mutex_lock(&wl->mutex);
-	ret = wl1271_cmd_test(wl, buf, buf_len, answer);
-	mutex_unlock(&wl->mutex);
 
+	if (wl->state == WL1271_STATE_OFF) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = wl1271_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out;
+
+	ret = wl1271_cmd_test(wl, buf, buf_len, answer);
 	if (ret < 0) {
 		wl1271_warning("testmode cmd test failed: %d", ret);
-		return ret;
+		goto out_sleep;
 	}
 
 	if (answer) {
 		len = nla_total_size(buf_len);
 		skb = cfg80211_testmode_alloc_reply_skb(wl->hw->wiphy, len);
-		if (!skb)
-			return -ENOMEM;
+		if (!skb) {
+			ret = -ENOMEM;
+			goto out_sleep;
+		}
 
 		NLA_PUT(skb, WL1271_TM_ATTR_DATA, buf_len, buf);
 		ret = cfg80211_testmode_reply(skb);
 		if (ret < 0)
-			return ret;
+			goto out_sleep;
 	}
 
-	return 0;
+out_sleep:
+	wl1271_ps_elp_sleep(wl);
+out:
+	mutex_unlock(&wl->mutex);
+
+	return ret;
 
 nla_put_failure:
 	kfree_skb(skb);
-	return -EMSGSIZE;
+	ret = -EMSGSIZE;
+	goto out_sleep;
 }
 
 static int wl1271_tm_cmd_interrogate(struct wl1271 *wl, struct nlattr *tb[])
@@ -130,33 +147,50 @@ static int wl1271_tm_cmd_interrogate(struct wl1271 *wl, struct nlattr *tb[])
 
 	ie_id = nla_get_u8(tb[WL1271_TM_ATTR_IE_ID]);
 
+	mutex_lock(&wl->mutex);
+
+	if (wl->state == WL1271_STATE_OFF) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = wl1271_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out;
+
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
-	if (!cmd)
-		return -ENOMEM;
+	if (!cmd) {
+		ret = -ENOMEM;
+		goto out_sleep;
+	}
 
-	mutex_lock(&wl->mutex);
 	ret = wl1271_cmd_interrogate(wl, ie_id, cmd, sizeof(*cmd));
-	mutex_unlock(&wl->mutex);
-
 	if (ret < 0) {
 		wl1271_warning("testmode cmd interrogate failed: %d", ret);
-		kfree(cmd);
-		return ret;
+		goto out_free;
 	}
 
 	skb = cfg80211_testmode_alloc_reply_skb(wl->hw->wiphy, sizeof(*cmd));
 	if (!skb) {
-		kfree(cmd);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto out_free;
 	}
 
 	NLA_PUT(skb, WL1271_TM_ATTR_DATA, sizeof(*cmd), cmd);
 
-	return 0;
+out_free:
+	kfree(cmd);
+out_sleep:
+	wl1271_ps_elp_sleep(wl);
+out:
+	mutex_unlock(&wl->mutex);
+
+	return ret;
 
 nla_put_failure:
 	kfree_skb(skb);
-	return -EMSGSIZE;
+	ret = -EMSGSIZE;
+	goto out_free;
 }
 
 static int wl1271_tm_cmd_configure(struct wl1271 *wl, struct nlattr *tb[])
-- 
1.7.6.401.g6a319

