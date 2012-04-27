Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58787 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759603Ab2D0Dsj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2012 23:48:39 -0400
Received: by obbta14 with SMTP id ta14so494409obb.19
        for <linux-wireless@vger.kernel.org>; Thu, 26 Apr 2012 20:48:38 -0700 (PDT)
From: Ashok Nagarajan <ashok@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	javier@cozybit.com, devel@lists.open80211s.org,
	Ashok Nagarajan <ashok@cozybit.com>
Subject: [PATCH 1/4] mac80211: Advertise HT protection mode in IEs
Date: Thu, 26 Apr 2012 20:48:23 -0700
Message-Id: <1335498506-9600-1-git-send-email-ashok@cozybit.com> (sfid-20120427_054915_677315_2AE59E4F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
Reviewed-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/ibss.c        |    2 +-
 net/mac80211/ieee80211_i.h |    3 ++-
 net/mac80211/mesh.c        |    3 ++-
 net/mac80211/util.c        |    9 +++------
 4 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 61cd391..bb1a3e6 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -164,7 +164,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 		pos = ieee80211_ie_build_ht_cap(pos, &sband->ht_cap,
 						sband->ht_cap.cap);
 		pos = ieee80211_ie_build_ht_oper(pos, &sband->ht_cap,
-						 chan, channel_type);
+						 chan, channel_type, 0);
 	}
 
 	if (local->hw.queues >= IEEE80211_NUM_ACS) {
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 6cd89d4..ae046b5 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1497,7 +1497,8 @@ u8 *ieee80211_ie_build_ht_cap(u8 *pos, struct ieee80211_sta_ht_cap *ht_cap,
 			      u16 cap);
 u8 *ieee80211_ie_build_ht_oper(u8 *pos, struct ieee80211_sta_ht_cap *ht_cap,
 			       struct ieee80211_channel *channel,
-			       enum nl80211_channel_type channel_type);
+			       enum nl80211_channel_type channel_type,
+			       u16 prot_mode);
 
 /* internal work items */
 void ieee80211_work_init(struct ieee80211_local *local);
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 598a96a..8a952e0 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -396,7 +396,8 @@ int mesh_add_ht_oper_ie(struct sk_buff *skb,
 		return -ENOMEM;
 
 	pos = skb_put(skb, 2 + sizeof(struct ieee80211_ht_operation));
-	ieee80211_ie_build_ht_oper(pos, ht_cap, channel, channel_type);
+	ieee80211_ie_build_ht_oper(pos, ht_cap, channel, channel_type,
+				   sdata->vif.bss_conf.ht_operation_mode);
 
 	return 0;
 }
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index d9a747d..22f2216 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1663,7 +1663,8 @@ u8 *ieee80211_ie_build_ht_cap(u8 *pos, struct ieee80211_sta_ht_cap *ht_cap,
 
 u8 *ieee80211_ie_build_ht_oper(u8 *pos, struct ieee80211_sta_ht_cap *ht_cap,
 			       struct ieee80211_channel *channel,
-			       enum nl80211_channel_type channel_type)
+			       enum nl80211_channel_type channel_type,
+			       u16 prot_mode)
 {
 	struct ieee80211_ht_operation *ht_oper;
 	/* Build HT Information */
@@ -1689,11 +1690,7 @@ u8 *ieee80211_ie_build_ht_oper(u8 *pos, struct ieee80211_sta_ht_cap *ht_cap,
 	    channel_type != NL80211_CHAN_HT20)
 		ht_oper->ht_param |= IEEE80211_HT_PARAM_CHAN_WIDTH_ANY;
 
-	/*
-	 * Note: According to 802.11n-2009 9.13.3.1, HT Protection field and
-	 * RIFS Mode are reserved in IBSS mode, therefore keep them at 0
-	 */
-	ht_oper->operation_mode = 0x0000;
+	ht_oper->operation_mode = cpu_to_le16(prot_mode);
 	ht_oper->stbc_param = 0x0000;
 
 	/* It seems that Basic MCS set and Supported MCS set
-- 
1.7.5.4

