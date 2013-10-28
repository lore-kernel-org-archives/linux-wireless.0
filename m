Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:46122 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756788Ab3J1S1Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Oct 2013 14:27:24 -0400
Received: by mail-ee0-f43.google.com with SMTP id b47so2166861eek.16
        for <linux-wireless@vger.kernel.org>; Mon, 28 Oct 2013 11:27:23 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Marek Puzyniak <marek.puzyniak@tieto.com>
Subject: [PATCH 5/5] cfg80211: fix dfs channel state after stopping AP
Date: Mon, 28 Oct 2013 19:27:04 +0100
Message-Id: <1382984824-3729-5-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131028_192729_907667_8CF156CB)
In-Reply-To: <1382984824-3729-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1382984824-3729-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Marek Puzyniak <marek.puzyniak@tieto.com>

This can be called when a mode of operation that can supports
initiating radiation on a DFS channel leaves that channel to
ensure that if the mode of operation is started again on it
that it will require a new channel availability check.

Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>
Reviewed-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 include/net/cfg80211.h |   10 ++++++++++
 net/mac80211/cfg.c     |    6 ++++++
 net/wireless/mlme.c    |    7 +++++++
 3 files changed, 23 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 8b52fcb..cc1ba48 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4135,6 +4135,16 @@ void cfg80211_cac_event(struct net_device *netdev,
 			struct cfg80211_chan_def *chandef,
 			enum nl80211_radar_event event, gfp_t gfp);
 
+/**
+ * cfg80211_leave_dfs_channel - Leaving dfs channel
+ * @wiphy: the wiphy
+ * @chandef: chandef for the current channel
+ *
+ * This function is called when dfs channel is being not used for diffrent
+ * reasons. Make channel DFS USABLE again.
+ */
+void cfg80211_leave_dfs_channel(struct wiphy *wiphy,
+				struct cfg80211_chan_def *chandef);
 
 /**
  * cfg80211_cqm_pktloss_notify - notify userspace about packetloss to peer
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 5690d21..10778ae 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1096,6 +1096,12 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 		cfg80211_cac_event(sdata->dev, &chandef,
 				   NL80211_RADAR_CAC_ABORTED,
 				   GFP_KERNEL);
+	} else if (sdata->radar_required) {
+		/*
+		 * AP stopped on DFS channel so change that channel state
+		 * to NL80211_DFS_USABLE again.
+		 */
+		cfg80211_leave_dfs_channel(wiphy, &sdata->vif.bss_conf.chandef);
 	}
 
 	drv_stop_ap(sdata->local, sdata);
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index a50c27b..c75b1d3 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -797,3 +797,10 @@ void cfg80211_cac_event(struct net_device *netdev,
 	nl80211_radar_notify(rdev, chandef, event, netdev, gfp);
 }
 EXPORT_SYMBOL(cfg80211_cac_event);
+
+void cfg80211_leave_dfs_channel(struct wiphy *wiphy,
+				struct cfg80211_chan_def *chandef)
+{
+	cfg80211_set_dfs_state(wiphy, chandef, NL80211_DFS_USABLE);
+}
+EXPORT_SYMBOL(cfg80211_leave_dfs_channel);
-- 
1.7.9.5

