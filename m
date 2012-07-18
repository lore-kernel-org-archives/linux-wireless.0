Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:54640 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753344Ab2GRMOA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2012 08:14:00 -0400
Received: by lbbgj10 with SMTP id gj10so2550267lbb.23
        for <linux-wireless@vger.kernel.org>; Wed, 18 Jul 2012 05:13:57 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com
Subject: [PATCH 11/14] wlcore: make usage of nla_put clearer
Date: Wed, 18 Jul 2012 15:13:30 +0300
Message-Id: <1342613613-917-12-git-send-email-coelho@ti.com> (sfid-20120718_141414_329092_C951D6F1)
In-Reply-To: <1342613613-917-1-git-send-email-coelho@ti.com>
References: <1342613613-917-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yair Shapira <yair.shapira@ti.com>

handle errors of nla_put() inside the if(nla_put...) {}

This makes the code simpler and clearer because:
we take advantage from the fact that we have only one nla_put
in our routines (so no real need for goto label).
this avoids ugly goto forward followed by goto backward.

Signed-off-by: Yair Shapira <yair.shapira@ti.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/testmode.c |   39 +++++++++++++----------------
 1 file changed, 18 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/testmode.c b/drivers/net/wireless/ti/wlcore/testmode.c
index 081f175..49e5ee1 100644
--- a/drivers/net/wireless/ti/wlcore/testmode.c
+++ b/drivers/net/wireless/ti/wlcore/testmode.c
@@ -129,8 +129,12 @@ static int wl1271_tm_cmd_test(struct wl1271 *wl, struct nlattr *tb[])
 			goto out_sleep;
 		}
 
-		if (nla_put(skb, WL1271_TM_ATTR_DATA, buf_len, buf))
-			goto nla_put_failure;
+		if (nla_put(skb, WL1271_TM_ATTR_DATA, buf_len, buf)) {
+			kfree_skb(skb);
+			ret = -EMSGSIZE;
+			goto out_sleep;
+		}
+
 		ret = cfg80211_testmode_reply(skb);
 		if (ret < 0)
 			goto out_sleep;
@@ -142,11 +146,6 @@ out:
 	mutex_unlock(&wl->mutex);
 
 	return ret;
-
-nla_put_failure:
-	kfree_skb(skb);
-	ret = -EMSGSIZE;
-	goto out_sleep;
 }
 
 static int wl1271_tm_cmd_interrogate(struct wl1271 *wl, struct nlattr *tb[])
@@ -192,8 +191,12 @@ static int wl1271_tm_cmd_interrogate(struct wl1271 *wl, struct nlattr *tb[])
 		goto out_free;
 	}
 
-	if (nla_put(skb, WL1271_TM_ATTR_DATA, sizeof(*cmd), cmd))
-		goto nla_put_failure;
+	if (nla_put(skb, WL1271_TM_ATTR_DATA, sizeof(*cmd), cmd)) {
+		kfree_skb(skb);
+		ret = -EMSGSIZE;
+		goto out_free;
+	}
+
 	ret = cfg80211_testmode_reply(skb);
 	if (ret < 0)
 		goto out_free;
@@ -206,11 +209,6 @@ out:
 	mutex_unlock(&wl->mutex);
 
 	return ret;
-
-nla_put_failure:
-	kfree_skb(skb);
-	ret = -EMSGSIZE;
-	goto out_free;
 }
 
 static int wl1271_tm_cmd_configure(struct wl1271 *wl, struct nlattr *tb[])
@@ -343,8 +341,12 @@ static int wl12xx_tm_cmd_get_mac(struct wl1271 *wl, struct nlattr *tb[])
 		goto out;
 	}
 
-	if (nla_put(skb, WL1271_TM_ATTR_DATA, ETH_ALEN, mac_addr))
-		goto nla_put_failure;
+	if (nla_put(skb, WL1271_TM_ATTR_DATA, ETH_ALEN, mac_addr)) {
+		kfree_skb(skb);
+		ret = -EMSGSIZE;
+		goto out;
+	}
+
 	ret = cfg80211_testmode_reply(skb);
 	if (ret < 0)
 		goto out;
@@ -352,11 +354,6 @@ static int wl12xx_tm_cmd_get_mac(struct wl1271 *wl, struct nlattr *tb[])
 out:
 	mutex_unlock(&wl->mutex);
 	return ret;
-
-nla_put_failure:
-	kfree_skb(skb);
-	ret = -EMSGSIZE;
-	goto out;
 }
 
 int wl1271_tm_cmd(struct ieee80211_hw *hw, void *data, int len)
-- 
1.7.10.4

