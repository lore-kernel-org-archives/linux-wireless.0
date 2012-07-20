Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:43955 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560Ab2GTMhW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jul 2012 08:37:22 -0400
Received: by ghrr11 with SMTP id r11so3893891ghr.19
        for <linux-wireless@vger.kernel.org>; Fri, 20 Jul 2012 05:37:22 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, devel@lists.open80211s.org,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] mac80211: add extra checking for RC init upon receiving mesh beacon
Date: Fri, 20 Jul 2012 20:36:04 +0800
Message-Id: <1342787764-26858-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20120720_143726_774447_7EECDF54)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rate control statistic is flushed whenever the mesh beacon
is received. This may not optimizes the performance of rate
control algorithm. This patch ensures that <rate_control_
rate_init> is called only if the peer's channel type is
changed.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 net/mac80211/mesh_plink.c |   10 +++++++++-
 net/mac80211/sta_info.h   |    4 ++++
 2 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 4256859..a3fce28 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -357,6 +357,7 @@ static struct sta_info *mesh_peer_init(struct ieee80211_sub_if_data *sdata,
 		if (!sta)
 			return NULL;
 		insert = true;
+		sta->mesh_rate_init = false;
 	}
 
 	spin_lock_bh(&sta->lock);
@@ -377,9 +378,16 @@ static struct sta_info *mesh_peer_init(struct ieee80211_sub_if_data *sdata,
 					    ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
 		sta->ch_type =
 			ieee80211_ht_oper_to_channel_type(elems->ht_operation);
+	} else {
+		sta->ch_type = NL80211_CHAN_NO_HT;
+	}
+
+	if (!sta->mesh_rate_init || sta->pre_ch_type != sta->ch_type) {
+		rate_control_rate_init(sta);
+		sta->mesh_rate_init = true;
+		sta->pre_ch_type = sta->ch_type;
 	}
 
-	rate_control_rate_init(sta);
 	spin_unlock_bh(&sta->lock);
 
 	if (insert && sta_info_insert(sta))
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index a470e11..ed10ee7 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -274,6 +274,8 @@ struct sta_ampdu_mlme {
  * @t_offset_setpoint: reference timing offset of this sta to be used when
  * 	calculating clockdrift
  * @ch_type: peer's channel type
+ * @pre_ch_type: previous peer's channel type
+ * @mesh_rate_init: rate control initilization flag
  * @debugfs: debug filesystem info
  * @dead: set to true when sta is unlinked
  * @uploaded: set to true when sta is uploaded to the driver
@@ -368,6 +370,8 @@ struct sta_info {
 	s64 t_offset;
 	s64 t_offset_setpoint;
 	enum nl80211_channel_type ch_type;
+	enum nl80211_channel_type pre_ch_type;
+	bool mesh_rate_init;
 #endif
 
 #ifdef CONFIG_MAC80211_DEBUGFS
-- 
1.7.0.4

