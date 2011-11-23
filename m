Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43838 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797Ab1KWUcl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Nov 2011 15:32:41 -0500
Received: by mail-iy0-f174.google.com with SMTP id e36so2078525iag.19
        for <linux-wireless@vger.kernel.org>; Wed, 23 Nov 2011 12:32:41 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: devel@lists.open80211s.org,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	johannes@sipsolutions.net, linville@tuxdriver.com
Subject: [PATCH 1/7] {nl,cfg,mac}80211: Allow Setting Multicast Rate in Mesh
Date: Wed, 23 Nov 2011 12:32:20 -0800
Message-Id: <1322080347-7644-2-git-send-email-thomas@cozybit.com> (sfid-20111123_213244_933775_635D1B17)
In-Reply-To: <1322080347-7644-1-git-send-email-thomas@cozybit.com>
References: <1322080347-7644-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 include/net/cfg80211.h |    2 ++
 net/mac80211/cfg.c     |    6 ++++++
 net/mac80211/tx.c      |    1 +
 net/wireless/nl80211.c |    5 +++++
 4 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index d5e1891..edf1a4b 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -802,6 +802,7 @@ struct mesh_config {
  * @ie_len: length of vendor information elements
  * @is_authenticated: this mesh requires authentication
  * @is_secure: this mesh uses security
+ * @mcast_rate: multicat rate for Mesh Node [6Mbps is the default for 802.11a]
  *
  * These parameters are fixed when the mesh is created.
  */
@@ -814,6 +815,7 @@ struct mesh_setup {
 	u8 ie_len;
 	bool is_authenticated;
 	bool is_secure;
+	int mcast_rate[IEEE80211_NUM_BANDS];
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 2577c45..8fa85db 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1185,6 +1185,8 @@ static int copy_mesh_setup(struct ieee80211_if_mesh *ifmsh,
 {
 	u8 *new_ie;
 	const u8 *old_ie;
+	struct ieee80211_sub_if_data *sdata = container_of(ifmsh,
+					struct ieee80211_sub_if_data, u.mesh);
 
 	/* allocate information elements */
 	new_ie = NULL;
@@ -1211,6 +1213,10 @@ static int copy_mesh_setup(struct ieee80211_if_mesh *ifmsh,
 	if (setup->is_secure)
 		ifmsh->security |= IEEE80211_MESH_SEC_SECURED;
 
+	/* mcast rate setting in Mesh Node */
+	memcpy(sdata->vif.bss_conf.mcast_rate, setup->mcast_rate,
+						sizeof(setup->mcast_rate));
+
 	return 0;
 }
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 8d31933..6ec3194 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -636,6 +636,7 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 	else
 		txrc.max_rate_idx = fls(txrc.rate_idx_mask) - 1;
 	txrc.bss = (tx->sdata->vif.type == NL80211_IFTYPE_AP ||
+		    tx->sdata->vif.type == NL80211_IFTYPE_MESH_POINT ||
 		    tx->sdata->vif.type == NL80211_IFTYPE_ADHOC);
 
 	/* set up RTS protection if desired */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index a1cabde..9b8f9d9 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5648,6 +5648,11 @@ static int nl80211_join_mesh(struct sk_buff *skb, struct genl_info *info)
 	setup.mesh_id = nla_data(info->attrs[NL80211_ATTR_MESH_ID]);
 	setup.mesh_id_len = nla_len(info->attrs[NL80211_ATTR_MESH_ID]);
 
+	if (info->attrs[NL80211_ATTR_MCAST_RATE] &&
+		!nl80211_parse_mcast_rate(rdev, setup.mcast_rate,
+		nla_get_u32(info->attrs[NL80211_ATTR_MCAST_RATE])))
+			return -EINVAL;
+
 	if (info->attrs[NL80211_ATTR_MESH_SETUP]) {
 		/* parse additional setup parameters if given */
 		err = nl80211_parse_mesh_setup(info, &setup);
-- 
1.7.5.4

