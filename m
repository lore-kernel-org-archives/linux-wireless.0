Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.175]:51514 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848AbYJHXSt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2008 19:18:49 -0400
Received: by wf-out-1314.google.com with SMTP id 27so4300110wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 08 Oct 2008 16:18:47 -0700 (PDT)
To: linux-wireless@vger.kernel.org
From: Andrey Yurovsky <andrey@cozybit.com>
Subject: [PATCH] allow AP interfaces to handle BACK action frames
Date: Wed, 08 Oct 2008 16:18:46 -0700 (PDT)
Message-ID: <48ed3fd6.1e068e0a.7847.4d37@mx.google.com> (sfid-20081009_011853_725706_7A53CCE0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add AP mode to the allowed interface check in ieee80211_rx_h_action.  This
function handles BACK action frames such as ADDBA and AP interfaces need to
receive those.

Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 080b0ce..fe406f5 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1553,7 +1553,8 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 	 *	  of these frames in other modes as well!
 	 */
 	if (sdata->vif.type != NL80211_IFTYPE_STATION &&
-	    sdata->vif.type != NL80211_IFTYPE_ADHOC)
+	    sdata->vif.type != NL80211_IFTYPE_ADHOC &&
+	    sdata->vif.type != NL80211_IFTYPE_AP)
 		return RX_CONTINUE;
 
 	switch (mgmt->u.action.category) {


