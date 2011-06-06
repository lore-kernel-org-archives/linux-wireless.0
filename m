Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46449 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755922Ab1FFJ7G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 05:59:06 -0400
Received: by wya21 with SMTP id 21so2648648wya.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jun 2011 02:59:05 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: add ieee80211_get_operstate() function
Date: Mon,  6 Jun 2011 12:59:29 +0300
Message-Id: <1307354369-32612-1-git-send-email-eliad@wizery.com> (sfid-20110606_115914_711991_F5C51AE0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add ieee80211_get_operstate() function to get the operstate
of the netdevice.

This is needed for drivers that need to know when the interface
is IF_OPER_UP (e.g. wl12xx), and block notifiers can't be used
(e.g. because the interface is already IF_OPER_UP, like after
resuming from suspend)

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 include/net/mac80211.h |   10 ++++++++++
 net/mac80211/mlme.c    |    7 +++++++
 2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 8c7189c..d19e325 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2915,6 +2915,16 @@ void ieee80211_cqm_rssi_notify(struct ieee80211_vif *vif,
 			       gfp_t gfp);
 
 /**
+ * ieee80211_get_operstate - get the operstate of the vif
+ *
+ * @vif: &struct ieee80211_vif pointer from the add_interface callback.
+ *
+ * The driver might need to know the operstate of the net_device
+ * (specifically, whether the link is IF_OPER_UP after resume)
+ */
+unsigned char ieee80211_get_operstate(struct ieee80211_vif *vif);
+
+/**
  * ieee80211_chswitch_done - Complete channel switch process
  * @vif: &struct ieee80211_vif pointer from the add_interface callback.
  * @success: make the channel switch successful or not
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 4f6b267..c81a99d 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2651,3 +2651,10 @@ void ieee80211_cqm_rssi_notify(struct ieee80211_vif *vif,
 	cfg80211_cqm_rssi_notify(sdata->dev, rssi_event, gfp);
 }
 EXPORT_SYMBOL(ieee80211_cqm_rssi_notify);
+
+unsigned char ieee80211_get_operstate(struct ieee80211_vif *vif)
+{
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+	return sdata->dev->operstate;
+}
+EXPORT_SYMBOL(ieee80211_get_operstate);
-- 
1.7.0.4

