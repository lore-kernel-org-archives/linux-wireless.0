Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:47865 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752052Ab1LLMKP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Dec 2011 07:10:15 -0500
Received: by lagp5 with SMTP id p5so1880040lag.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Dec 2011 04:10:14 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: configure BSS_CHANGED_ARP_FILTER on reconfiguration
Date: Mon, 12 Dec 2011 14:10:49 +0200
Message-Id: <1323691849-20815-1-git-send-email-eliad@wizery.com> (sfid-20111212_131020_009538_B7873590)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Configure arp filtering on sta reconfiguration.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/mac80211/util.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index cddc266..491ccda 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1077,7 +1077,8 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 
 		switch (sdata->vif.type) {
 		case NL80211_IFTYPE_STATION:
-			changed |= BSS_CHANGED_ASSOC;
+			changed |= BSS_CHANGED_ASSOC |
+				   BSS_CHANGED_ARP_FILTER;
 			mutex_lock(&sdata->u.mgd.mtx);
 			ieee80211_bss_info_change_notify(sdata, changed);
 			mutex_unlock(&sdata->u.mgd.mtx);
-- 
1.7.6.401.g6a319

