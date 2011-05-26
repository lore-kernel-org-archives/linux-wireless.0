Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48622 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757446Ab1EZNxM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 May 2011 09:53:12 -0400
Received: by wwa36 with SMTP id 36so795403wwa.1
        for <linux-wireless@vger.kernel.org>; Thu, 26 May 2011 06:53:11 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [RFC 1/2] mac80211: add ieee80211_get_operstate() function
Date: Thu, 26 May 2011 16:53:26 +0300
Message-Id: <1306418007-27573-1-git-send-email-eliad@wizery.com> (sfid-20110526_155336_172142_4D838857)
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
i didn't find a better way to get this information, but i might
have missed something.

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

