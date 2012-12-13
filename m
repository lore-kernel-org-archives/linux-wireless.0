Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:48610 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756358Ab2LMSwJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 13:52:09 -0500
Received: by mail-pa0-f46.google.com with SMTP id bh2so1795431pad.19
        for <linux-wireless@vger.kernel.org>; Thu, 13 Dec 2012 10:52:08 -0800 (PST)
From: Marco Porsch <marco@cozybit.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Marco Porsch <marco@cozybit.com>
Subject: [PATCH 1/6] nl80211: add range checks to mesh parameters
Date: Thu, 13 Dec 2012 10:51:53 -0800
Message-Id: <1355424718-2982-2-git-send-email-marco@cozybit.com> (sfid-20121213_195215_248537_B2959015)
In-Reply-To: <1355424718-2982-1-git-send-email-marco@cozybit.com>
References: <1355424718-2982-1-git-send-email-marco@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ranges are taken from IEEE 802.11-2012, common sense or current implementation
requirements.

Signed-off-by: Marco Porsch <marco@cozybit.com>
---
 net/wireless/nl80211.c |   75 +++++++++++++++++++++++++++---------------------
 1 file changed, 42 insertions(+), 33 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index f45706a..fa58012 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3967,11 +3967,13 @@ static int nl80211_parse_mesh_config(struct genl_info *info,
 	struct nlattr *tb[NL80211_MESHCONF_ATTR_MAX + 1];
 	u32 mask = 0;
 
-#define FILL_IN_MESH_PARAM_IF_SET(table, cfg, param, mask, attr_num, nla_fn) \
-do {\
-	if (table[attr_num]) {\
-		cfg->param = nla_fn(table[attr_num]); \
-		mask |= (1 << (attr_num - 1)); \
+#define FILL_IN_MESH_PARAM_IF_SET(tb, cfg, param, min, max, mask, attr, fn) \
+do { \
+	if (tb[attr]) { \
+		if (fn(tb[attr]) < min || fn(tb[attr]) > max) \
+			return -EINVAL; \
+		cfg->param = fn(tb[attr]); \
+		mask |= (1 << (attr - 1)); \
 	} \
 } while (0);\
 
@@ -3988,81 +3990,88 @@ do {\
 	BUILD_BUG_ON(NL80211_MESHCONF_ATTR_MAX > 32);
 
 	/* Fill in the params struct */
-	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshRetryTimeout,
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshRetryTimeout, 1, 255,
 				  mask, NL80211_MESHCONF_RETRY_TIMEOUT,
 				  nla_get_u16);
-	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshConfirmTimeout,
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshConfirmTimeout, 1, 255,
 				  mask, NL80211_MESHCONF_CONFIRM_TIMEOUT,
 				  nla_get_u16);
-	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHoldingTimeout,
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHoldingTimeout, 1, 255,
 				  mask, NL80211_MESHCONF_HOLDING_TIMEOUT,
 				  nla_get_u16);
-	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshMaxPeerLinks,
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshMaxPeerLinks, 0, 255,
 				  mask, NL80211_MESHCONF_MAX_PEER_LINKS,
 				  nla_get_u16);
-	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshMaxRetries,
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshMaxRetries, 0, 16,
 				  mask, NL80211_MESHCONF_MAX_RETRIES,
 				  nla_get_u8);
-	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshTTL,
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshTTL, 1, 255,
 				  mask, NL80211_MESHCONF_TTL, nla_get_u8);
-	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, element_ttl,
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, element_ttl, 1, 255,
 				  mask, NL80211_MESHCONF_ELEMENT_TTL,
 				  nla_get_u8);
-	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, auto_open_plinks,
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, auto_open_plinks, 0, 1,
 				  mask, NL80211_MESHCONF_AUTO_OPEN_PLINKS,
 				  nla_get_u8);
-	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshNbrOffsetMaxNeighbor, mask,
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshNbrOffsetMaxNeighbor,
+				  1, 255, mask,
 				  NL80211_MESHCONF_SYNC_OFFSET_MAX_NEIGHBOR,
 				  nla_get_u32);
-	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHWMPmaxPREQretries,
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHWMPmaxPREQretries, 0, 255,
 				  mask, NL80211_MESHCONF_HWMP_MAX_PREQ_RETRIES,
 				  nla_get_u8);
-	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, path_refresh_time,
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, path_refresh_time, 1, 65535,
 				  mask, NL80211_MESHCONF_PATH_REFRESH_TIME,
 				  nla_get_u32);
-	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, min_discovery_timeout,
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, min_discovery_timeout, 1, 65535,
 				  mask, NL80211_MESHCONF_MIN_DISCOVERY_TIMEOUT,
 				  nla_get_u16);
-	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHWMPactivePathTimeout, mask,
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHWMPactivePathTimeout,
+				  1, 65535, mask,
 				  NL80211_MESHCONF_HWMP_ACTIVE_PATH_TIMEOUT,
 				  nla_get_u32);
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHWMPpreqMinInterval,
-				  mask, NL80211_MESHCONF_HWMP_PREQ_MIN_INTERVAL,
+				  1, 65535, mask,
+				  NL80211_MESHCONF_HWMP_PREQ_MIN_INTERVAL,
 				  nla_get_u16);
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHWMPperrMinInterval,
-				  mask, NL80211_MESHCONF_HWMP_PERR_MIN_INTERVAL,
+				  1, 65535, mask,
+				  NL80211_MESHCONF_HWMP_PERR_MIN_INTERVAL,
 				  nla_get_u16);
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg,
-				  dot11MeshHWMPnetDiameterTraversalTime, mask,
+				  dot11MeshHWMPnetDiameterTraversalTime,
+				  1, 65535, mask,
 				  NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME,
 				  nla_get_u16);
-	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHWMPRootMode, mask,
-				  NL80211_MESHCONF_HWMP_ROOTMODE, nla_get_u8);
-	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHWMPRannInterval, mask,
-				  NL80211_MESHCONF_HWMP_RANN_INTERVAL,
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHWMPRootMode, 0, 4,
+				  mask, NL80211_MESHCONF_HWMP_ROOTMODE,
+				  nla_get_u8);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHWMPRannInterval, 1, 65535,
+				  mask, NL80211_MESHCONF_HWMP_RANN_INTERVAL,
 				  nla_get_u16);
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg,
-				  dot11MeshGateAnnouncementProtocol, mask,
-				  NL80211_MESHCONF_GATE_ANNOUNCEMENTS,
+				  dot11MeshGateAnnouncementProtocol, 0, 1,
+				  mask, NL80211_MESHCONF_GATE_ANNOUNCEMENTS,
 				  nla_get_u8);
-	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshForwarding,
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshForwarding, 0, 1,
 				  mask, NL80211_MESHCONF_FORWARDING,
 				  nla_get_u8);
-	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, rssi_threshold,
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, rssi_threshold, 1, 255,
 				  mask, NL80211_MESHCONF_RSSI_THRESHOLD,
 				  nla_get_u32);
-	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, ht_opmode,
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, ht_opmode, 0, 16,
 				  mask, NL80211_MESHCONF_HT_OPMODE,
 				  nla_get_u16);
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHWMPactivePathToRootTimeout,
-				  mask,
+				  1, 65535, mask,
 				  NL80211_MESHCONF_HWMP_PATH_TO_ROOT_TIMEOUT,
 				  nla_get_u32);
-	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHWMProotInterval,
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHWMProotInterval, 1, 65535,
 				  mask, NL80211_MESHCONF_HWMP_ROOT_INTERVAL,
 				  nla_get_u16);
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg,
-				  dot11MeshHWMPconfirmationInterval, mask,
+				  dot11MeshHWMPconfirmationInterval,
+				  1, 65535, mask,
 				  NL80211_MESHCONF_HWMP_CONFIRMATION_INTERVAL,
 				  nla_get_u16);
 	if (mask_out)
-- 
1.7.9.5

