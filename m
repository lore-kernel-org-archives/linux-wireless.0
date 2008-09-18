Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:31929 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738AbYIRKRt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 06:17:49 -0400
Received: by wf-out-1314.google.com with SMTP id 27so3475745wfd.4
        for <linux-wireless@vger.kernel.org>; Thu, 18 Sep 2008 03:17:48 -0700 (PDT)
Message-ID: <1197ff4c0809180309p7cd5c2b4y30db3799d91bdc6b@mail.gmail.com> (sfid-20080918_121754_340967_31B87781)
Date: Thu, 18 Sep 2008 18:09:49 +0800
From: YanBo <dreamfly281@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: Enable mesh point handle action packet
Cc: LiYanbo <dreamfly281@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch enable vif in mesh_point mode can handle the action packet.

Signed-off-by: Li YanBo <dreamfly281@gmail.com>
---
net/mac80211/rx.c |    3 ++-
1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 92d898b..763c7ea 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1537,7 +1537,8 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 	 *	  of these frames in other modes as well!
 	 */
 	if (sdata->vif.type != NL80211_IFTYPE_STATION &&
-	    sdata->vif.type != NL80211_IFTYPE_ADHOC)
+	    sdata->vif.type != NL80211_IFTYPE_ADHOC &&
+ 	    sdata->vif.type != NL80211_IFTYPE_MESH_POINT)
 		return RX_DROP_MONITOR;

 	switch (mgmt->u.action.category) {
