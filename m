Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f44.google.com ([209.85.214.44]:52540 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab3AGPFH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jan 2013 10:05:07 -0500
Received: by mail-bk0-f44.google.com with SMTP id w11so8424760bku.3
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jan 2013 07:05:05 -0800 (PST)
From: Marco Porsch <marco@cozybit.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Marco Porsch <marco@cozybit.com>
Subject: [PATCHv2 4/6] {cfg,nl,mac}80211: set beacon interval and DTIM period on mesh join
Date: Mon,  7 Jan 2013 16:04:51 +0100
Message-Id: <1357571093-12868-5-git-send-email-marco@cozybit.com> (sfid-20130107_160524_058843_8C78F1A6)
In-Reply-To: <1357571093-12868-1-git-send-email-marco@cozybit.com>
References: <1357571093-12868-1-git-send-email-marco@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move the default mesh beacon interval and DTIM period to cfg80211 and
make it accessible to nl80211. This enables setting both values when joining
an MBSS.
Previously the DTIM parameter was not set by mac80211 so the driver's default
value was used.

Signed-off-by: Marco Porsch <marco@cozybit.com>
---
 include/net/cfg80211.h |    4 ++++
 net/mac80211/cfg.c     |    3 +++
 net/mac80211/mesh.c    |    1 -
 net/mac80211/mesh.h    |    2 --
 net/wireless/mesh.c    |    5 +++++
 net/wireless/nl80211.c |   15 +++++++++++++++
 6 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 8e6a6b7..4e4b1b0 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1034,6 +1034,8 @@ struct mesh_config {
  * @ie_len: length of vendor information elements
  * @is_authenticated: this mesh requires authentication
  * @is_secure: this mesh uses security
+ * @dtim_period: DTIM period to use
+ * @beacon_interval: beacon interval to use
  * @mcast_rate: multicat rate for Mesh Node [6Mbps is the default for 802.11a]
  *
  * These parameters are fixed when the mesh is created.
@@ -1049,6 +1051,8 @@ struct mesh_setup {
 	u8 ie_len;
 	bool is_authenticated;
 	bool is_secure;
+	u8 dtim_period;
+	u16 beacon_interval;
 	int mcast_rate[IEEE80211_NUM_BANDS];
 };
 
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index def81d6..abfd5d3 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1631,6 +1631,9 @@ static int copy_mesh_setup(struct ieee80211_if_mesh *ifmsh,
 	memcpy(sdata->vif.bss_conf.mcast_rate, setup->mcast_rate,
 						sizeof(setup->mcast_rate));
 
+	sdata->vif.bss_conf.beacon_int = setup->beacon_interval;
+	sdata->vif.bss_conf.dtim_period = setup->dtim_period;
+
 	return 0;
 }
 
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 649ad51..35013fa 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -624,7 +624,6 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 	ieee80211_queue_work(&local->hw, &sdata->work);
 	sdata->vif.bss_conf.ht_operation_mode =
 				ifmsh->mshcfg.ht_opmode;
-	sdata->vif.bss_conf.beacon_int = MESH_DEFAULT_BEACON_INTERVAL;
 	sdata->vif.bss_conf.basic_rates =
 		ieee80211_mandatory_rates(sdata->local,
 					  ieee80211_get_sdata_band(sdata));
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index c07f6fc..aff3015 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -191,8 +191,6 @@ struct mesh_rmc {
 #define IEEE80211_MESH_PEER_INACTIVITY_LIMIT (1800 * HZ)
 #define IEEE80211_MESH_HOUSEKEEPING_INTERVAL (60 * HZ)
 
-#define MESH_DEFAULT_BEACON_INTERVAL		1000 	/* in 1024 us units */
-
 #define MESH_PATH_EXPIRE (600 * HZ)
 
 /* Default maximum number of plinks per interface */
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index f9d6ce5..0fe8ceb 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -44,6 +44,9 @@
 
 #define MESH_SYNC_NEIGHBOR_OFFSET_MAX 50
 
+#define MESH_DEFAULT_BEACON_INTERVAL	1000	/* in 1024 us units (=TUs) */
+#define MESH_DEFAULT_DTIM_PERIOD	2
+
 const struct mesh_config default_mesh_config = {
 	.dot11MeshRetryTimeout = MESH_RET_T,
 	.dot11MeshConfirmTimeout = MESH_CONF_T,
@@ -79,6 +82,8 @@ const struct mesh_setup default_mesh_setup = {
 	.ie = NULL,
 	.ie_len = 0,
 	.is_secure = false,
+	.beacon_interval = MESH_DEFAULT_BEACON_INTERVAL,
+	.dtim_period = MESH_DEFAULT_DTIM_PERIOD,
 };
 
 int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 63bf956..a32c7767 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6661,6 +6661,21 @@ static int nl80211_join_mesh(struct sk_buff *skb, struct genl_info *info)
 			    nla_get_u32(info->attrs[NL80211_ATTR_MCAST_RATE])))
 			return -EINVAL;
 
+	if (info->attrs[NL80211_ATTR_BEACON_INTERVAL]) {
+		setup.beacon_interval =
+			nla_get_u32(info->attrs[NL80211_ATTR_BEACON_INTERVAL]);
+		if (setup.beacon_interval < 10 ||
+		    setup.beacon_interval > 10000)
+			return -EINVAL;
+	}
+
+	if (info->attrs[NL80211_ATTR_DTIM_PERIOD]) {
+		setup.dtim_period =
+			nla_get_u32(info->attrs[NL80211_ATTR_DTIM_PERIOD]);
+		if (setup.dtim_period < 1 || setup.dtim_period > 100)
+			return -EINVAL;
+	}
+
 	if (info->attrs[NL80211_ATTR_MESH_SETUP]) {
 		/* parse additional setup parameters if given */
 		err = nl80211_parse_mesh_setup(info, &setup);
-- 
1.7.9.5

