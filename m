Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:30526 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017AbYHIVyi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Aug 2008 17:54:38 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 1/1] mac80211: update new sta's rx timestamp
Date: Sun, 10 Aug 2008 00:54:34 +0300
Message-Id: <1218318874-15168-1-git-send-email-tomas.winkler@intel.com> (sfid-20080809_235442_879855_C59B8E93)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch fixes needless probe request caused by zero value in
sta->last_rx inside ieee80211_associated flow

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 net/mac80211/mlme.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 541a40a..00e9a2d 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2137,6 +2137,8 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 			rcu_read_unlock();
 			return;
 		}
+		/* update new sta with its last rx activity */
+		sta->last_rx = jiffies;
 	}
 
 	/*
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

