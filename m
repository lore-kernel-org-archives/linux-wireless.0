Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:44932 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756902AbaC0Oyq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Mar 2014 10:54:46 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: j@w1.fi, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix software remain-on-channel implementation
Date: Thu, 27 Mar 2014 15:54:39 +0100
Message-Id: <1395932079-31862-1-git-send-email-johannes@sipsolutions.net> (sfid-20140327_155500_810525_555006FB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Jouni reported that when doing off-channel transmissions mixed
with on-channel transmissions, the on-channel ones ended up on
the off-channel in some cases.

The reason for that is that during the refactoring of the off-
channel code, I lost the part that stopped all activity and as
a consequence the on-channel frames (including data frames)
were no longer queued but would be transmitted on the temporary
channel.

Fix this by simply restoring the lost activity stop call.

Cc: stable@vger.kernel.org
Fixes: 2eb278e083549 ("mac80211: unify SW/offload remain-on-channel")
Reported-by: Jouni Malinen <j@w1.fi>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/offchannel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 0c2a29484c07..6fb38558a5e6 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -355,6 +355,7 @@ void ieee80211_sw_roc_work(struct work_struct *work)
 		struct ieee80211_roc_work *dep;
 
 		/* start this ROC */
+		ieee80211_offchannel_stop_vifs(local);
 
 		/* switch channel etc */
 		ieee80211_recalc_idle(local);
-- 
1.9.0

