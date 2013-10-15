Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f54.google.com ([209.85.219.54]:38363 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933519Ab3JOVQZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Oct 2013 17:16:25 -0400
Received: by mail-oa0-f54.google.com with SMTP id n5so6414725oag.27
        for <linux-wireless@vger.kernel.org>; Tue, 15 Oct 2013 14:16:25 -0700 (PDT)
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Remove check for offchannel state when waking netdev queues
Date: Tue, 15 Oct 2013 16:16:21 -0500
Message-Id: <1381871781-29128-1-git-send-email-seth.forshee@canonical.com> (sfid-20131015_231628_686304_FA902B91)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

6c17b77b67587b9f9e3070fb89fe98cef3187131 ensures that a device's
mac80211 queues will remain stopped while offchannel. Since the
vif can no longer be offchannel when the queues wake it's not
necessary to check for this before waking its netdev queues.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 net/mac80211/util.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index e1b34a1..561af30 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -300,9 +300,6 @@ void ieee80211_propagate_queue_wake(struct ieee80211_local *local, int queue)
 		if (!sdata->dev)
 			continue;
 
-		if (test_bit(SDATA_STATE_OFFCHANNEL, &sdata->state))
-			continue;
-
 		if (sdata->vif.cab_queue != IEEE80211_INVAL_HW_QUEUE &&
 		    local->queue_stop_reasons[sdata->vif.cab_queue] != 0)
 			continue;
-- 
1.8.3.2

