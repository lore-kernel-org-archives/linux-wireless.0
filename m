Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47201 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab1KUNOr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 08:14:47 -0500
Received: by ywt32 with SMTP id 32so4648804ywt.19
        for <linux-wireless@vger.kernel.org>; Mon, 21 Nov 2011 05:14:47 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 21 Nov 2011 17:14:47 +0400
Message-ID: <CAG5dHkSsj7kysheYx=4bccj8TKCmvVVg2gfHrrYauhbHvCd1cw@mail.gmail.com> (sfid-20111121_141450_113230_D061A6B5)
Subject: [RFC v2 1/8] cfg80211 and nl80211: mesh power mode config parameter
From: Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to IEEE80211s standard a mesh STA maintains a mesh power
modefor non-peer mesh STAs. Non-peer mesh power mode is a mesh
configurationparameter so it should be presented in mesh_config
structure. Possiblevalues for mesh power mode are presented in
nl80211_mesh_power_modeenumeration. These modes are active, light
sleep and deep sleep.
Signed-off-by: Ivan Bezyazychnyy
<ivan.bezyazychnyy@gmail.com>Signed-off-by: Mike Krinkin
<krinkin.m.u@gmail.com>--- include/linux/nl80211.h |   29
+++++++++++++++++++++++++++++ include/net/cfg80211.h  |    2 ++
net/wireless/mesh.c     |    1 + 3 files changed, 32 insertions(+), 0
deletions(-)
diff --git a/include/linux/nl80211.h b/include/linux/nl80211.hindex
8049bf7..001e9e3 100644--- a/include/linux/nl80211.h+++
b/include/linux/nl80211.h@@ -1915,6 +1915,35 @@ enum
nl80211_mntr_flags { };  /**+ * enum nl80211_mesh_power_mode - mesh
power save modes+ *+ * @__NL80211_MESH_POWER_INVALID - internal use+
*+ * @NL80211_MESH_POWER_ACTIVE - active mesh power mode, mesh STA+ *
                          in Awake state all the time+ *
@NL80211_MESH_POWER_LIGHT_SLEEP - light sleep mode, mesh STA+ *
                    alternate between Active and Doze states,+ *
                     mesh STA should listen to all the beacons+ *
@NL80211_MESH_POWER_DEEP_SLEEP - deep sleep mode, mesh STA+ *
                  alternates between Active and Doze states,+ *
                    may choose not listen to the beacons+ *+ *
@__NL80211_MESH_POWER_AFTER_LAST - internal use+ *
@NL80211_MESH_POWER_MAX - highest possible power save level+ */++enum
nl80211_mesh_power_mode
{+	__NL80211_MESH_POWER_INVALID,++	NL80211_MESH_POWER_ACTIVE,+	NL80211_MESH_POWER_LIGHT_SLEEP,+	NL80211_MESH_POWER_DEEP_SLEEP,++	__NL80211_MESH_POWER_AFTER_LAST,+	NL80211_MESH_POWER_MAX
= __NL80211_MESH_POWER_AFTER_LAST - 1+};++/**  * enum
nl80211_meshconf_params - mesh configuration parameters  *  * Mesh
configuration parameters. These can be changed while the mesh isdiff
--git a/include/net/cfg80211.h b/include/net/cfg80211.hindex
92cf1c2..e00e04e 100644--- a/include/net/cfg80211.h+++
b/include/net/cfg80211.h@@ -765,6 +765,8 @@ struct mesh_config { 	u16
dot11MeshMaxPeerLinks; 	u8  dot11MeshMaxRetries; 	u8
dot11MeshTTL;+	/* non-peer mesh power save mode */+	u8 power_mode; 	/*
ttl used in path selection information elements */ 	u8  element_ttl;
	bool auto_open_plinks;diff --git a/net/wireless/mesh.c
b/net/wireless/mesh.cindex 4423e64..5febd0b 100644---
a/net/wireless/mesh.c+++ b/net/wireless/mesh.c@@ -52,6 +52,7 @@ const
struct mesh_config default_mesh_config = { 	.min_discovery_timeout =
MESH_MIN_DISCOVERY_TIMEOUT, 	.dot11MeshHWMPRannInterval =
MESH_RANN_INTERVAL, 	.dot11MeshGateAnnouncementProtocol =
false,+	.power_mode = NL80211_MESH_POWER_ACTIVE, };  const struct
mesh_setup default_mesh_setup = {-- 1.7.3.4
