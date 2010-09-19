Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35519 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941Ab0ISQzD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Sep 2010 12:55:03 -0400
Received: by fxm3 with SMTP id 3so295976fxm.19
        for <linux-wireless@vger.kernel.org>; Sun, 19 Sep 2010 09:55:02 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>
Subject: [PATCH 2/2] wl1271: bugfix: use bitwise-AND instead of logical-AND
Date: Sun, 19 Sep 2010 18:55:09 +0200
Message-Id: <1284915309-999-2-git-send-email-eliad@wizery.com>
In-Reply-To: <1284915309-999-1-git-send-email-eliad@wizery.com>
References: <1284915309-999-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

typo - while looking for specific bits we should do a bitwise-AND instead of logical-AND.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index e6e0852..d2b8486 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1635,7 +1635,7 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 	if (ret < 0)
 		goto out;
 
-	if ((changed && BSS_CHANGED_BEACON_INT) &&
+	if ((changed & BSS_CHANGED_BEACON_INT) &&
 	    (wl->bss_type == BSS_TYPE_IBSS)) {
 		wl1271_debug(DEBUG_ADHOC, "ad-hoc beacon interval updated: %d",
 			bss_conf->beacon_int);
@@ -1644,7 +1644,7 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 		do_join = true;
 	}
 
-	if ((changed && BSS_CHANGED_BEACON) &&
+	if ((changed & BSS_CHANGED_BEACON) &&
 	    (wl->bss_type == BSS_TYPE_IBSS)) {
 		struct sk_buff *beacon = ieee80211_beacon_get(hw, vif);
 
-- 
1.7.0.4

