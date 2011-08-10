Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f170.google.com ([209.85.210.170]:55390 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab1HJAEg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 20:04:36 -0400
Received: by iye16 with SMTP id 16so50111iye.1
        for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2011 17:04:35 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Javier Cardona <javier@cozybit.com>
Subject: [PATCH] support for setting RANN interval and mesh gate
Date: Tue,  9 Aug 2011 17:03:30 -0700
Message-Id: <1312934610-10728-1-git-send-email-thomas@cozybit.com> (sfid-20110810_020439_299562_95ADE93A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

---
 mesh.c    |    4 ++++
 nl80211.h |    9 +++++++++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/mesh.c b/mesh.c
index 7c6ab3d..dc8f49c 100644
--- a/mesh.c
+++ b/mesh.c
@@ -173,6 +173,10 @@ const static struct mesh_param_descr _mesh_param_descrs[] =
 	_my_nla_put_u16, _parse_u16, _print_u16_in_TUs},
 	{"mesh_hwmp_rootmode", NL80211_MESHCONF_HWMP_ROOTMODE,
 	_my_nla_put_u8, _parse_u8, _print_u8},
+	{"mesh_hwmp_rann_interval", NL80211_MESHCONF_HWMP_RANN_INTERVAL,
+	_my_nla_put_u16, _parse_u16, _print_u16},
+	{"mesh_gate_announcements", NL80211_MESHCONF_GATE_ANNOUNCEMENTS,
+	_my_nla_put_u8, _parse_u8, _print_u8},
 };
 
 static void print_all_mesh_param_descr(void)
diff --git a/nl80211.h b/nl80211.h
index 7ba71e4..4830bd6 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -1826,6 +1826,13 @@ enum nl80211_mntr_flags {
  * @NL80211_MESHCONF_ELEMENT_TTL: specifies the value of TTL field set at a
  * source mesh point for path selection elements.
  *
+ * @NL80211_MESHCONF_HWMP_RANN_INTERVAL:  The interval of time (in TUs) between
+ * root announcements are transmitted.
+ *
+ * @NL80211_MESHCONF_GATE_ANNOUNCEMENTS: Advertise that this mesh station has
+ * access to a broader network beyond the MBSS.  This is done via Root
+ * Announcement frames.
+ *
  * @NL80211_MESHCONF_ATTR_MAX: highest possible mesh configuration attribute
  *
  * @__NL80211_MESHCONF_ATTR_AFTER_LAST: internal use
@@ -1847,6 +1854,8 @@ enum nl80211_meshconf_params {
 	NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME,
 	NL80211_MESHCONF_HWMP_ROOTMODE,
 	NL80211_MESHCONF_ELEMENT_TTL,
+	NL80211_MESHCONF_HWMP_RANN_INTERVAL,
+	NL80211_MESHCONF_GATE_ANNOUNCEMENTS,
 
 	/* keep last */
 	__NL80211_MESHCONF_ATTR_AFTER_LAST,
-- 
1.7.6

