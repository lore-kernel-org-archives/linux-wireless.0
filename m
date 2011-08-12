Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f170.google.com ([209.85.210.170]:50219 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886Ab1HLCyY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 22:54:24 -0400
Received: by mail-iy0-f170.google.com with SMTP id 16so634961iye.1
        for <linux-wireless@vger.kernel.org>; Thu, 11 Aug 2011 19:54:24 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Javier Cardona <javier@cozybit.com>, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: [PATCH v2 6/8] {nl,mac}80211: add missing root mode debugfs entries
Date: Thu, 11 Aug 2011 19:53:59 -0700
Message-Id: <1313117641-27351-6-git-send-email-thomas@cozybit.com> (sfid-20110812_045431_573153_2BEC6C1E)
In-Reply-To: <1313117641-27351-1-git-send-email-thomas@cozybit.com>
References: <1312933511-9486-1-git-send-email-thomas@cozybit.com>
 <1313117641-27351-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/debugfs_netdev.c |    2 +-
 net/wireless/nl80211.c        |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 9ea7c0d..75ece3d 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -485,7 +485,7 @@ static void add_mesh_config(struct ieee80211_sub_if_data *sdata)
 	MESHPARAMS_ADD(dot11MeshHWMPmaxPREQretries);
 	MESHPARAMS_ADD(path_refresh_time);
 	MESHPARAMS_ADD(min_discovery_timeout);
-
+	MESHPARAMS_ADD(dot11MeshHWMPRootMode);
 #undef MESHPARAMS_ADD
 }
 #endif
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ca76977..cd5994f 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2985,6 +2985,7 @@ static const struct nla_policy nl80211_meshconf_params_policy[NL80211_MESHCONF_A
 	[NL80211_MESHCONF_HWMP_ACTIVE_PATH_TIMEOUT] = { .type = NLA_U32 },
 	[NL80211_MESHCONF_HWMP_PREQ_MIN_INTERVAL] = { .type = NLA_U16 },
 	[NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME] = { .type = NLA_U16 },
+	[NL80211_MESHCONF_HWMP_ROOTMODE] = { .type = NLA_U8 },
 };
 
 static const struct nla_policy
-- 
1.7.4.
