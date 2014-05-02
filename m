Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:39206 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751505AbaEBNlQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 May 2014 09:41:16 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Cc: michal.kazior@tieto.com
Date: Fri,  2 May 2014 16:40:31 +0300
Message-Id: <1399038031-23206-4-git-send-email-luca@coelho.fi> (sfid-20140502_154120_292582_14CDCE1F)
In-Reply-To: <1399038031-23206-1-git-send-email-luca@coelho.fi>
References: <1399038031-23206-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 4/4] cfg80211/nl80211: allow any interface to send channel switch notifications
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

For multi-vif channel switches, we want to send
NL80211_CMD_CH_SWITCH_NOTIFY to the userspace to let it decide whether
other interfaces need to be moved as well.  This is needed when we run
out of available channels or when we want a P2P GO interface to follow
the channel of a station, for example.

Modify the code so that all interfaces can send CSA notifications.
Additionally, send notifications for STA CSA as well.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 include/uapi/linux/nl80211.h | 4 +++-
 net/mac80211/mlme.c          | 1 +
 net/wireless/nl80211.c       | 6 ------
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index d7c5b61..635267d 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -636,7 +636,9 @@
  * @NL80211_CMD_CH_SWITCH_NOTIFY: An AP or GO may decide to switch channels
  *	independently of the userspace SME, send this event indicating
  *	%NL80211_ATTR_IFINDEX is now on %NL80211_ATTR_WIPHY_FREQ and the
- *	attributes determining channel width.
+ *	attributes determining channel width.  This indication may also be
+ *	sent when a remotely-initiated switch (eg. when a STA receives a CSA
+ *	from the remote AP) is completed;
  *
  * @NL80211_CMD_CH_SWITCH_STARTED_NOTIFY: Notify that a channel switch
  *	has been started on an interface, regardless of the initiator
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index beff8c8..59c59da 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -984,6 +984,7 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 
 	ieee80211_bss_info_change_notify(sdata, changed);
 
+	cfg80211_ch_switch_notify(sdata->dev, &sdata->reserved_chandef);
  out:
 	sdata->vif.csa_active = false;
 	ifmgd->flags &= ~IEEE80211_STA_CSA_RECEIVED;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 804c3c9..aea60bb 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -11252,12 +11252,6 @@ void cfg80211_ch_switch_notify(struct net_device *dev,
 
 	trace_cfg80211_ch_switch_notify(dev, chandef);
 
-	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_AP &&
-		    wdev->iftype != NL80211_IFTYPE_P2P_GO &&
-		    wdev->iftype != NL80211_IFTYPE_ADHOC &&
-		    wdev->iftype != NL80211_IFTYPE_MESH_POINT))
-		return;
-
 	wdev->chandef = *chandef;
 	wdev->preset_chandef = *chandef;
 	nl80211_ch_switch_notify(rdev, dev, chandef, GFP_KERNEL,
-- 
1.9.2

