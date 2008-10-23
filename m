Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.233]:4494 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbYJWUK7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2008 16:10:59 -0400
Received: by wx-out-0506.google.com with SMTP id h27so243441wxd.4
        for <linux-wireless@vger.kernel.org>; Thu, 23 Oct 2008 13:10:54 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
From: Andrey Yurovsky <andrey@cozybit.com>
Subject: [PATCH] mac80211: allow all interfaces types to handle RX action frames
Date: Thu, 23 Oct 2008 13:10:53 -0700 (PDT)
Message-ID: <4900da4d.0d87460a.2d4b.1120@mx.google.com> (sfid-20081023_221116_287816_85F93AC3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Eliminate the vif.type check in ieee80211_rx_h_action.  This check is
unnecessary (these action frames can be handled by all interface types) and 
currently prevents, for example, AP interfaces from handling BACK action frames
such as ADDBA and DELBA requests.

Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index a0db162..59bcbb6 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1552,14 +1552,6 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 	if (len < IEEE80211_MIN_ACTION_SIZE + 1)
 		return RX_DROP_MONITOR;
 
-	/*
-	 * FIXME: revisit this, I'm sure we should handle most
-	 *	  of these frames in other modes as well!
-	 */
-	if (sdata->vif.type != NL80211_IFTYPE_STATION &&
-	    sdata->vif.type != NL80211_IFTYPE_ADHOC)
-		return RX_CONTINUE;
-
 	switch (mgmt->u.action.category) {
 	case WLAN_CATEGORY_BACK:
 		switch (mgmt->u.action.u.addba_req.action_code) {


