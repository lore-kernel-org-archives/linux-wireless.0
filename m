Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:47314 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933748Ab2DLNJ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 09:09:59 -0400
Received: by lahl5 with SMTP id l5so1614146lah.29
        for <linux-wireless@vger.kernel.org>; Thu, 12 Apr 2012 06:09:57 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: [PATCH] mac80211: check IEEE80211_HW_QUEUE_CONTROL in ieee80211_check_queues()
Date: Thu, 12 Apr 2012 16:09:49 +0300
Message-Id: <1334236189-27025-1-git-send-email-coelho@ti.com> (sfid-20120412_151004_081204_1E9CBEE2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit 3a25a8c8 (mac80211: add improved HW queue control) introduced a
bug when running in AP mode without the IEEE80211_HW_QUEUE_CONTROL
flag set.  The ieee80211_check_queues() function always returns
-EINVAL, preventing AP mode from starting.  To fix this, check whether
this flag is set before checking if cab_queue is set properly.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 net/mac80211/iface.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 6e85fae..23d1da3 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -163,7 +163,8 @@ static int ieee80211_check_queues(struct ieee80211_sub_if_data *sdata)
 			return -EINVAL;
 	}
 
-	if (sdata->vif.type != NL80211_IFTYPE_AP) {
+	if ((sdata->vif.type != NL80211_IFTYPE_AP) ||
+	    !(sdata->local->hw.flags & IEEE80211_HW_QUEUE_CONTROL)) {
 		sdata->vif.cab_queue = IEEE80211_INVAL_HW_QUEUE;
 		return 0;
 	}
-- 
1.7.5.4

