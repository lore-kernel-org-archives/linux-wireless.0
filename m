Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:50661 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161037Ab2COXWM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 19:22:12 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH v3] mac80211:  Add iface name when calling WARN-ON.
Date: Thu, 15 Mar 2012 16:22:05 -0700
Message-Id: <1331853725-28483-1-git-send-email-greearb@candelatech.com> (sfid-20120316_002215_105360_53E7E84F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This lets the user know which interface has failed
the check_sdata_in_driver check.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 e8960ae... b6ef8e7... M	net/mac80211/driver-ops.h
 net/mac80211/driver-ops.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index e8960ae..b6ef8e7 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -7,7 +7,9 @@
 
 static inline void check_sdata_in_driver(struct ieee80211_sub_if_data *sdata)
 {
-	WARN_ON(!(sdata->flags & IEEE80211_SDATA_IN_DRIVER));
+	WARN(!(sdata->flags & IEEE80211_SDATA_IN_DRIVER),
+	     "%s:  Failed check-sdata-in-driver check, flags: 0x%x\n",
+	     sdata->dev->name, sdata->flags);
 }
 
 static inline struct ieee80211_sub_if_data *
-- 
1.7.3.4

