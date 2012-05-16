Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57038 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756772Ab2EPQJn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 12:09:43 -0400
Received: by bkcji2 with SMTP id ji2so777861bkc.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 May 2012 09:09:42 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: remove ieee80211_get_operstate()
Date: Wed, 16 May 2012 19:09:48 +0300
Message-Id: <1337184588-28488-1-git-send-email-eliad@wizery.com> (sfid-20120516_180947_548689_53DC31E9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_get_operstate() was used by drivers in order to
know whether the sta link is up, but it's no longer needed
(nor used) as mac80211 notifies the drivers about
authorization changes (via the sta_state callback)

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 include/net/mac80211.h |   10 ----------
 net/mac80211/mlme.c    |    7 -------
 2 files changed, 0 insertions(+), 17 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 45d1ca5..5398415 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3555,16 +3555,6 @@ void ieee80211_cqm_rssi_notify(struct ieee80211_vif *vif,
 			       gfp_t gfp);
 
 /**
- * ieee80211_get_operstate - get the operstate of the vif
- *
- * @vif: &struct ieee80211_vif pointer from the add_interface callback.
- *
- * The driver might need to know the operstate of the net_device
- * (specifically, whether the link is IF_OPER_UP after resume)
- */
-unsigned char ieee80211_get_operstate(struct ieee80211_vif *vif);
-
-/**
  * ieee80211_chswitch_done - Complete channel switch process
  * @vif: &struct ieee80211_vif pointer from the add_interface callback.
  * @success: make the channel switch successful or not
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index dbd4bd9..5ebac0d 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3547,10 +3547,3 @@ void ieee80211_cqm_rssi_notify(struct ieee80211_vif *vif,
 	cfg80211_cqm_rssi_notify(sdata->dev, rssi_event, gfp);
 }
 EXPORT_SYMBOL(ieee80211_cqm_rssi_notify);
-
-unsigned char ieee80211_get_operstate(struct ieee80211_vif *vif)
-{
-	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
-	return sdata->dev->operstate;
-}
-EXPORT_SYMBOL(ieee80211_get_operstate);
-- 
1.7.6.401.g6a319

