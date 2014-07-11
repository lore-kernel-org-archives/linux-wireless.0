Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:64351 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbaGKAB5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2014 20:01:57 -0400
Received: by mail-we0-f178.google.com with SMTP id x48so285386wes.9
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jul 2014 17:01:54 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 02/14] wlcore: user smaller sqn padding for GEM
Date: Fri, 11 Jul 2014 03:01:27 +0300
Message-Id: <1405036899-27396-3-git-send-email-eliad@wizery.com> (sfid-20140711_020201_667205_4CC9FE2A)
In-Reply-To: <1405036899-27396-1-git-send-email-eliad@wizery.com>
References: <1405036899-27396-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On recovery, we increase the current seq num by
WL1271_TX_SQN_POST_RECOVERY_PADDING in order to
compensate for packets we might have missed during
recovery.

It seems that some GEM APs have issues when the
gap is too big, so use a smaller padding in this case.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/cmd.c      | 7 +++++--
 drivers/net/wireless/ti/wlcore/main.c     | 7 +++++--
 drivers/net/wireless/ti/wlcore/wlcore_i.h | 3 +++
 3 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index d298ead..05604ee 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -374,6 +374,7 @@ void wl12xx_free_link(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 *hlid)
 
 	if (wlvif->bss_type == BSS_TYPE_AP_BSS &&
 	    *hlid == wlvif->ap.bcast_hlid) {
+		u32 sqn_padding = WL1271_TX_SQN_POST_RECOVERY_PADDING;
 		/*
 		 * save the total freed packets in the wlvif, in case this is
 		 * recovery or suspend
@@ -384,9 +385,11 @@ void wl12xx_free_link(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 *hlid)
 		 * increment the initial seq number on recovery to account for
 		 * transmitted packets that we haven't yet got in the FW status
 		 */
+		if (wlvif->encryption_type == KEY_GEM)
+			sqn_padding = WL1271_TX_SQN_POST_RECOVERY_PADDING_GEM;
+
 		if (test_bit(WL1271_FLAG_RECOVERY_IN_PROGRESS, &wl->flags))
-			wlvif->total_freed_pkts +=
-					WL1271_TX_SQN_POST_RECOVERY_PADDING;
+			wlvif->total_freed_pkts += sqn_padding;
 	}
 
 	wl->links[*hlid].total_freed_pkts = 0;
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 2996cef..1ab6dbd 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -902,6 +902,7 @@ static void wlcore_save_freed_pkts(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 				   u8 hlid, struct ieee80211_sta *sta)
 {
 	struct wl1271_station *wl_sta;
+	u32 sqn_recovery_padding = WL1271_TX_SQN_POST_RECOVERY_PADDING;
 
 	wl_sta = (void *)sta->drv_priv;
 	wl_sta->total_freed_pkts = wl->links[hlid].total_freed_pkts;
@@ -910,9 +911,11 @@ static void wlcore_save_freed_pkts(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	 * increment the initial seq number on recovery to account for
 	 * transmitted packets that we haven't yet got in the FW status
 	 */
+	if (wlvif->encryption_type == KEY_GEM)
+		sqn_recovery_padding = WL1271_TX_SQN_POST_RECOVERY_PADDING_GEM;
+
 	if (test_bit(WL1271_FLAG_RECOVERY_IN_PROGRESS, &wl->flags))
-		wl_sta->total_freed_pkts +=
-				WL1271_TX_SQN_POST_RECOVERY_PADDING;
+		wl_sta->total_freed_pkts += sqn_recovery_padding;
 }
 
 static void wlcore_save_freed_pkts_addr(struct wl1271 *wl,
diff --git a/drivers/net/wireless/ti/wlcore/wlcore_i.h b/drivers/net/wireless/ti/wlcore/wlcore_i.h
index 986da43..0e52556 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore_i.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore_i.h
@@ -45,6 +45,9 @@
 #define WL1271_TX_SECURITY_LO16(s) ((u16)((s) & 0xffff))
 #define WL1271_TX_SECURITY_HI32(s) ((u32)(((s) >> 16) & 0xffffffff))
 #define WL1271_TX_SQN_POST_RECOVERY_PADDING 0xff
+/* Use smaller padding for GEM, as some  APs have issues when it's too big */
+#define WL1271_TX_SQN_POST_RECOVERY_PADDING_GEM 0x20
+
 
 #define WL1271_CIPHER_SUITE_GEM 0x00147201
 
-- 
1.8.5.1.109.g3d252a9

