Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35975 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934316Ab1JEJ43 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 05:56:29 -0400
Received: by mail-ey0-f174.google.com with SMTP id 28so1405752eya.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Oct 2011 02:56:28 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 13/29] wl12xx: move aid into wlvif
Date: Wed,  5 Oct 2011 11:55:50 +0200
Message-Id: <1317808566-18857-14-git-send-email-eliad@wizery.com> (sfid-20111005_115641_018184_14A782B2)
In-Reply-To: <1317808566-18857-1-git-send-email-eliad@wizery.com>
References: <1317808566-18857-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

move aid into the per-interface data, rather than
being global.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c   |    8 ++++----
 drivers/net/wireless/wl12xx/wl12xx.h |    6 +++---
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 3686109..4a35523 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2217,7 +2217,7 @@ static int wl1271_join(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	if (ret < 0)
 		goto out;
 
-	ret = wl1271_acx_aid(wl, wl->aid);
+	ret = wl1271_acx_aid(wl, wlvif->aid);
 	if (ret < 0)
 		goto out;
 
@@ -3482,7 +3482,7 @@ sta_not_found:
 		if (bss_conf->assoc) {
 			u32 rates;
 			int ieoffset;
-			wl->aid = bss_conf->aid;
+			wlvif->aid = bss_conf->aid;
 			set_assoc = true;
 
 			wl->ps_poll_failures = 0;
@@ -3513,7 +3513,7 @@ sta_not_found:
 			 * updates it by itself when the first beacon is
 			 * received after a join.
 			 */
-			ret = wl1271_cmd_build_ps_poll(wl, wlvif, wl->aid);
+			ret = wl1271_cmd_build_ps_poll(wl, wlvif, wlvif->aid);
 			if (ret < 0)
 				goto out;
 
@@ -3539,7 +3539,7 @@ sta_not_found:
 			bool was_ifup =
 			    !!test_and_clear_bit(WL1271_FLAG_STA_STATE_SENT,
 						 &wl->flags);
-			wl->aid = 0;
+			wlvif->aid = 0;
 
 			/* free probe-request template */
 			dev_kfree_skb(wlvif->probereq);
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 81d3839..4ca483f 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -506,9 +506,6 @@ struct wl1271 {
 
 	bool sched_scanning;
 
-	/* Our association ID */
-	u16 aid;
-
 	u32 bitrate_masks[IEEE80211_NUM_BANDS];
 
 	/* The current band */
@@ -640,6 +637,9 @@ struct wl12xx_vif {
 
 	/* probe-req template for the current AP */
 	struct sk_buff *probereq;
+
+	/* Our association ID */
+	u16 aid;
 };
 
 static inline struct wl12xx_vif *wl12xx_vif_to_data(struct ieee80211_vif *vif)
-- 
1.7.6.401.g6a319

