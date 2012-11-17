Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:48639 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab2KQGsg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Nov 2012 01:48:36 -0500
From: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
To: johannes@sipsolutions.net, javier@cozybit.com
Cc: linux-wireless@vger.kernel.org,
	Marco Porsch <marco.porsch@etit.tu-chemnitz.de>,
	Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>,
	Mike Krinkin <krinkin.m.u@gmail.com>
Subject: [RFC 02/14] {cfg,nl}80211: mesh power mode config parameters
Date: Fri, 16 Nov 2012 22:47:54 -0800
Message-Id: <1353134886-13256-3-git-send-email-marco.porsch@etit.tu-chemnitz.de> (sfid-20121117_074840_874640_5B62D122)
In-Reply-To: <1353134886-13256-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <1353134886-13256-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Possible values for the mesh power mode are presented in the
nl80211_mesh_power_mode enumeration. These modes are active,
light sleep and deep sleep.

power_mode has been added to the mesh config structure to hold the
user-configured default mesh power mode which will be used for new
peer links.

Signed-off-by: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Signed-off-by: Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
Signed-off-by: Mike Krinkin <krinkin.m.u@gmail.com>
---
 include/net/cfg80211.h       |    3 +++
 include/uapi/linux/nl80211.h |   29 +++++++++++++++++++++++++++++
 net/wireless/mesh.c          |    1 +
 3 files changed, 33 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 4c6668f..9488782 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -880,6 +880,8 @@ struct bss_parameters {
  *	a PREQ element for root path confirmation.
  * @beacon_interval: beacon interval to use
  * @dtim_period: DTIM period to use
+ * @power_mode: The default mesh power save mode which will be the initial
+ *	setting for new peer links.
  */
 struct mesh_config {
 	u16 dot11MeshRetryTimeout;
@@ -909,6 +911,7 @@ struct mesh_config {
 	u16 dot11MeshHWMPconfirmationInterval;
 	u16 beacon_interval;
 	u8 dtim_period;
+	enum nl80211_mesh_power_mode power_mode;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 3306e79..ee80ffc 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2203,6 +2203,35 @@ enum nl80211_mntr_flags {
 };
 
 /**
+ * enum nl80211_mesh_power_mode - mesh power save modes
+ *
+ * @__NL80211_MESH_POWER_INVALID: internal use
+ *
+ * @NL80211_MESH_POWER_ACTIVE: Active mesh power mode. The mesh STA is
+ *                            in Awake state all the time.
+ * @NL80211_MESH_POWER_LIGHT_SLEEP: Light sleep mode. The mesh STA will
+ *                            alternate between Active and Doze states,
+ *                            but will wake up for neighbor's beacons.
+ * @NL80211_MESH_POWER_DEEP_SLEEP: Deep sleep mode. The mesh STA will
+ *                            alternate between Active and Doze states,
+ *                            but may not wake up for neighbor's beacons.
+ *
+ * @__NL80211_MESH_POWER_AFTER_LAST - internal use
+ * @NL80211_MESH_POWER_MAX - highest possible power save level
+ */
+
+enum nl80211_mesh_power_mode {
+	__NL80211_MESH_POWER_INVALID,
+
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
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index e461502..1c7fab6 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -74,6 +74,7 @@ const struct mesh_config default_mesh_config = {
 	.dot11MeshHWMPconfirmationInterval = MESH_ROOT_CONFIRMATION_INTERVAL,
 	.beacon_interval = MESH_DEFAULT_BEACON_INTERVAL,
 	.dtim_period = MESH_DEFAULT_DTIM_PERIOD,
+	.power_mode = NL80211_MESH_POWER_ACTIVE,
 };
 
 const struct mesh_setup default_mesh_setup = {
-- 
1.7.9.5

