Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63195 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab1KVRd3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Nov 2011 12:33:29 -0500
Received: by fagn18 with SMTP id n18so673538fag.19
        for <linux-wireless@vger.kernel.org>; Tue, 22 Nov 2011 09:33:28 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH] mac80211: don't indicate probe resp change in IBSS mode
Date: Tue, 22 Nov 2011 19:33:18 +0200
Message-Id: <1321983198-20877-1-git-send-email-arik@wizery.com> (sfid-20111122_183332_813781_7AB9FFA0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Due the a fall-through in the switch statement, the IBSS mode got a
report for AP_RPOBE_RESPONSE change on reconfig. Change this to an AP
only notification.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 net/mac80211/util.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 3b9b492..2c56920 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1244,8 +1244,11 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 			changed |= BSS_CHANGED_IBSS;
 			/* fall through */
 		case NL80211_IFTYPE_AP:
-			changed |= BSS_CHANGED_SSID |
-				   BSS_CHANGED_AP_PROBE_RESP;
+			changed |= BSS_CHANGED_SSID;
+
+			if (sdata->vif.type == NL80211_IFTYPE_AP)
+				changed |= BSS_CHANGED_AP_PROBE_RESP;
+
 			/* fall through */
 		case NL80211_IFTYPE_MESH_POINT:
 			changed |= BSS_CHANGED_BEACON |
-- 
1.7.5.4

