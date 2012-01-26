Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:40425 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879Ab2AZLc5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jan 2012 06:32:57 -0500
Received: by wics10 with SMTP id s10so291746wic.19
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jan 2012 03:32:56 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: send null packet on active (psm) reconfiguration
Date: Thu, 26 Jan 2012 13:36:05 +0200
Message-Id: <1327577765-25815-1-git-send-email-eliad@wizery.com> (sfid-20120126_123301_093867_94FA3FF7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The sta might be in psm against the ap (e.g. because
this was the before a hw restart), so we explicitly
send a null packet in order to make sure it'll
sync against the ap (and get out of psm).

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/mac80211/util.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 9919892..17de0dd 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1272,6 +1272,21 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	ieee80211_recalc_ps(local, -1);
 
 	/*
+	 * The sta might be in psm against the ap (e.g. because
+	 * this was the state before a hw restart), so we
+	 * explicitly send a null packet in order to make sure
+	 * it'll sync against the ap (and get out of psm).
+	 */
+	if (!(local->hw.conf.flags & IEEE80211_CONF_PS)) {
+		list_for_each_entry(sdata, &local->interfaces, list) {
+			if (sdata->vif.type != NL80211_IFTYPE_STATION)
+				continue;
+
+			ieee80211_send_nullfunc(local, sdata, 0);
+		}
+	}
+
+	/*
 	 * Clear the WLAN_STA_BLOCK_BA flag so new aggregation
 	 * sessions can be established after a resume.
 	 *
-- 
1.7.6.401.g6a319

