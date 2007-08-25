Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hoboe1bl1.telenet-ops.be ([195.130.137.72]:40263 "EHLO
	hoboe1bl1.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbXHYMPE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Aug 2007 08:15:04 -0400
Message-ID: <46D01D57.6060806@telenet.be>
Date: Sat, 25 Aug 2007 14:15:19 +0200
From: ian <ischram@telenet.be>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
Cc: wireless <linux-wireless@vger.kernel.org>
Subject: Re: letting drivers choose their preferred rate scale
References: <46CF95F9.6090802@telenet.be> <1188028962.9529.13.camel@johannes.berg>
In-Reply-To: <1188028962.9529.13.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Johannes Berg wrote:
> 
> There were a few specific remarks about the patch

I reread the discussion carefully and can't find any specific
comments on the patch which for clarity I will reproduce below.


>, e.g. that the default
> shouldn't change as soon as a driver loads another rate control
> algorithm etc. 

The "default" rate scaling algorithm, is currently just the "first registered",
and as long as there is already an algorithm loaded, the driver can
"load" as many as it wants and wont change this. The patch doesn't touch
that logic.

> Once those are addressed I see no problems with merging
> such a patch.
> 
> johannes

ian

The patch in question:

Signed-off-by: James Ketrenos <jketreno@linux.intel.com>
---
include/net/mac80211.h   |    4 ++++
net/mac80211/ieee80211.c |   10 +++++++---
2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index ef9b613..f9ad839 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -533,6 +533,10 @@ struct ieee80211_hw {
    /* Number of available hardware TX queues for data packets.
     * WMM requires at least four queues. */
    int queues;
+
+    /* Preferred rate control algorithm. Leave as NULL for stack
+     * to select algorithm */
+    char *preferred_rate_control;
};

static inline void SET_IEEE80211_DEV(struct ieee80211_hw *hw, struct device *dev)
diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 873ccb0..6dcc002 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -4875,10 +4875,14 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)

    ieee80211_debugfs_add_netdev(IEEE80211_DEV_TO_SUB_IF(local->mdev));

-    result = ieee80211_init_rate_ctrl_alg(local, NULL);
+    result = ieee80211_init_rate_ctrl_alg(local,
+                          hw->preferred_rate_control);
+
    if (result < 0) {
-        printk(KERN_DEBUG "%s: Failed to initialize rate control "
-		"algorithm\n", local->mdev->name);
+	printk(KERN_DEBUG "%s: Failed to initialize %s rate control "
+               "algorithm\n", local->mdev->name,
+		hw->preferred_rate_control ?
+ 		hw->preferred_rate_control : "default");
        goto fail_rate;
    }
