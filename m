Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:50210 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647AbaKDIvC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2014 03:51:02 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: Increase uapsd max SP frames number
Date: Tue,  4 Nov 2014 10:40:36 +0200
Message-Id: <1415090436-12588-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20141104_095109_365394_483B6F11)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

Deliver up to 128 frames during SP instead of 8 if unlimited max SP
is specified during association.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/sta_info.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index de494df..3352741 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1531,7 +1531,7 @@ void ieee80211_sta_ps_deliver_uapsd(struct sta_info *sta)
 		break;
 	case 0:
 		/* XXX: what is a good value? */
-		n_frames = 8;
+		n_frames = 128;
 		break;
 	}
 
-- 
1.9.1

