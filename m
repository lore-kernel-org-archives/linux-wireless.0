Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:57966 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932425Ab2COSks (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 14:40:48 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2] mac80211: Add iface name when calling WARN-ON
Date: Thu, 15 Mar 2012 11:40:38 -0700
Message-Id: <1331836838-30360-1-git-send-email-greearb@candelatech.com> (sfid-20120315_194052_312524_BA55ABF8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This lets the user know which interface has failed
the check_sdata_in_driver check.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 af4691f... 43e95f0... M	net/mac80211/driver-ops.h
 net/mac80211/driver-ops.h |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index af4691f..43e95f0 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -7,7 +7,11 @@
 
 static inline void check_sdata_in_driver(struct ieee80211_sub_if_data *sdata)
 {
-	WARN_ON(!(sdata->flags & IEEE80211_SDATA_IN_DRIVER));
+	if (unlikely(!(sdata->flags & IEEE80211_SDATA_IN_DRIVER))) {
+		printk(KERN_ERR "%s:  Failed check-sdata-in-driver check, flags: 0x%x\n",
+		       sdata->dev->name, sdata->flags);
+		WARN_ON(!(sdata->flags & IEEE80211_SDATA_IN_DRIVER));
+	}
 }
 
 static inline struct ieee80211_sub_if_data *
-- 
1.7.3.4

