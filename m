Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:52404 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756071Ab2KWUTK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2012 15:19:10 -0500
From: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
To: johannes@sipsolutions.net, javier@cozybit.com, thomas@cozybit.com
Cc: linux-wireless@vger.kernel.org,
	Marco Porsch <marco.porsch@etit.tu-chemnitz.de>,
	Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>,
	Mike Krinkin <krinkin.m.u@gmail.com>
Subject: [RFCv2 02/13] {cfg,nl}80211: mesh power mode config parameters
Date: Fri, 23 Nov 2012 12:18:43 -0800
Message-Id: <1353701934-12752-3-git-send-email-marco.porsch@etit.tu-chemnitz.de> (sfid-20121123_211917_115518_5862AEE1)
In-Reply-To: <1353701934-12752-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <1353701934-12752-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add the nl80211_mesh_power_mode enumeration which holds possible values for
the mesh power mode. These modes are unknown, active, light sleep and
deep sleep.

Add power_mode entry to the mesh config structure to hold the user-configured
default mesh power mode. This value will be used for new peer links. Make the
default mesh power mode accessible to userspace as part of the mesh config.

Signed-off-by: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Signed-off-by: Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
Signed-off-by: Mike Krinkin <krinkin.m.u@gmail.com>
---
 include/net/cfg80211.h       |    3 +++
 include/uapi/linux/nl80211.h |   32 ++++++++++++++++++++++++++++++++
 net/wireless/mesh.c          |    1 +
 net/wireless/nl80211.c       |    8 +++++++-
 4 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 91ce6234..cc61b4b 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -878,6 +878,8 @@ struct bss_parameters {
  * @dot11MeshHWMPconfirmationInterval: The minimum interval of time (in TUs)
  *	during which a mesh STA can send only one Action frame containing
  *	a PREQ element for root path confirmation.
+ * @power_mode: The default mesh power save mode which will be the initial
+ *	setting for new peer links.
  */
 struct mesh_config {
 	u16 dot11MeshRetryTimeout;
@@ -905,6 +907,7 @@ struct mesh_config {
 	u32 dot11MeshHWMPactivePathToRootTimeout;
 	u16 dot11MeshHWMProotInterval;
 	u16 dot11MeshHWMPconfirmationInterval;
+	enum nl80211_mesh_power_mode power_mode;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 617d0fb..d0efa1e 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2203,6 +2203,34 @@ enum nl80211_mntr_flags {
 };
 
 /**
+ * enum nl80211_mesh_power_mode - mesh power save modes
+ *
+ * @NL80211_MESH_POWER_UNKNOWN: The mesh power mode of the mesh STA is
+ *	not known or has not been set yet.
+ * @NL80211_MESH_POWER_ACTIVE: Active mesh power mode. The mesh STA is
+ *	in Awake state all the time.
+ * @NL80211_MESH_POWER_LIGHT_SLEEP: Light sleep mode. The mesh STA will
+ *	alternate between Active and Doze states, but will wake up for
+ *	neighbor's beacons.
+ * @NL80211_MESH_POWER_DEEP_SLEEP: Deep sleep mode. The mesh STA will
+ *	alternate between Active and Doze states, but may not wake up
+ *	for neighbor's beacons.
+ *
+ * @__NL80211_MESH_POWER_AFTER_LAST - internal use
+ * @NL80211_MESH_POWER_MAX - highest possible power save level
+ */
+
+enum nl80211_mesh_power_mode {
+	NL80211_MESH_POWER_UNKNOWN,
+	NL80211_MESH_POWER_ACTIVE,
+	NL80211_MESH_POWER_LIGHT_SLEEP,
+	NL80211_MESH_POWER_DEEP_SLEEP,
+
+	__NL80211_MESH_POWER_AFTER_LAST,
+	NL80211_MESH_POWER_MAX = __NL80211_MESH_POWER_AFTER_LAST - 1
+};
+
+/**
  * enum nl80211_meshconf_params - mesh configuration parameters
  *
  * Mesh configuration parameters. These can be changed while the mesh is
@@ -2296,6 +2324,9 @@ enum nl80211_mntr_flags {
  *	(in TUs) during which a mesh STA can send only one Action frame
  *	containing a PREQ element for root path confirmation.
  *
+ * @NL80211_MESHCONF_POWER_MODE: Default mesh power mode for new peer links.
+ *	type &enum nl80211_mesh_power_mode (u8)
+ *
  * @__NL80211_MESHCONF_ATTR_AFTER_LAST: internal use
  */
 enum nl80211_meshconf_params {
@@ -2325,6 +2356,7 @@ enum nl80211_meshconf_params {
 	NL80211_MESHCONF_HWMP_PATH_TO_ROOT_TIMEOUT,
 	NL80211_MESHCONF_HWMP_ROOT_INTERVAL,
 	NL80211_MESHCONF_HWMP_CONFIRMATION_INTERVAL,
+	NL80211_MESHCONF_POWER_MODE,
 
 	/* keep last */
 	__NL80211_MESHCONF_ATTR_AFTER_LAST,
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index c2060d4..21f668b 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -72,6 +72,7 @@ const struct mesh_config default_mesh_config = {
 	.dot11MeshHWMPactivePathToRootTimeout = MESH_PATH_TO_ROOT_TIMEOUT,
 	.dot11MeshHWMProotInterval = MESH_ROOT_INTERVAL,
 	.dot11MeshHWMPconfirmationInterval = MESH_ROOT_CONFIRMATION_INTERVAL,
+	.power_mode = NL80211_MESH_POWER_ACTIVE,
 };
 
 const struct mesh_setup default_mesh_setup = {
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index e99a8ce..3e2aa63 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3770,7 +3770,9 @@ static int nl80211_get_mesh_config(struct sk_buff *skb,
 	    nla_put_u16(msg, NL80211_MESHCONF_HWMP_ROOT_INTERVAL,
 			cur_params.dot11MeshHWMProotInterval) ||
 	    nla_put_u16(msg, NL80211_MESHCONF_HWMP_CONFIRMATION_INTERVAL,
-			cur_params.dot11MeshHWMPconfirmationInterval))
+			cur_params.dot11MeshHWMPconfirmationInterval) ||
+	    nla_put_u8(msg, NL80211_MESHCONF_POWER_MODE,
+		       cur_params.power_mode))
 		goto nla_put_failure;
 	nla_nest_end(msg, pinfoattr);
 	genlmsg_end(msg, hdr);
@@ -3809,6 +3811,7 @@ static const struct nla_policy nl80211_meshconf_params_policy[NL80211_MESHCONF_A
 	[NL80211_MESHCONF_HWMP_PATH_TO_ROOT_TIMEOUT] = { .type = NLA_U32 },
 	[NL80211_MESHCONF_HWMP_ROOT_INTERVAL] = { .type = NLA_U16 },
 	[NL80211_MESHCONF_HWMP_CONFIRMATION_INTERVAL] = { .type = NLA_U16 },
+	[NL80211_MESHCONF_POWER_MODE] = { .type = NLA_U8 },
 };
 
 static const struct nla_policy
@@ -3927,6 +3930,9 @@ do {\
 				  dot11MeshHWMPconfirmationInterval, mask,
 				  NL80211_MESHCONF_HWMP_CONFIRMATION_INTERVAL,
 				  nla_get_u16);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, power_mode,
+				  mask, NL80211_MESHCONF_POWER_MODE,
+				  nla_get_u8);
 	if (mask_out)
 		*mask_out = mask;
 
-- 
1.7.9.5

