Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:48939 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752933Ab1CUR2V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2011 13:28:21 -0400
Received: by mail-ey0-f172.google.com with SMTP id 13so1529664eye.3
        for <linux-wireless@vger.kernel.org>; Mon, 21 Mar 2011 10:28:18 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] wl12xx: fix a couple of sparse warning about undeclared functions
Date: Mon, 21 Mar 2011 19:27:31 +0200
Message-Id: <1300728451-14491-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix the following sparse warnings:

drivers/net/wireless/wl12xx/main.c:1129:5: warning: symbol '__wl1271_plt_stop' was not declared. Should it be static?
drivers/net/wireless/wl12xx/main.c:2988:5: warning: symbol 'wl1271_op_ampdu_action' was not declared. Should it be static?

Both functions should be static.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/main.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 916ebd1..85cb4da 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1126,7 +1126,7 @@ out:
 	return ret;
 }
 
-int __wl1271_plt_stop(struct wl1271 *wl)
+static int __wl1271_plt_stop(struct wl1271 *wl)
 {
 	int ret = 0;
 
@@ -2985,10 +2985,11 @@ out:
 	return ret;
 }
 
-int wl1271_op_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-			   enum ieee80211_ampdu_mlme_action action,
-			   struct ieee80211_sta *sta, u16 tid, u16 *ssn,
-			   u8 buf_size)
+static int wl1271_op_ampdu_action(struct ieee80211_hw *hw,
+				  struct ieee80211_vif *vif,
+				  enum ieee80211_ampdu_mlme_action action,
+				  struct ieee80211_sta *sta, u16 tid, u16 *ssn,
+				  u8 buf_size)
 {
 	struct wl1271 *wl = hw->priv;
 	int ret;
-- 
1.7.1

