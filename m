Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58336 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420Ab2ATIVm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jan 2012 03:21:42 -0500
Received: by iagf6 with SMTP id f6so592059iag.19
        for <linux-wireless@vger.kernel.org>; Fri, 20 Jan 2012 00:21:41 -0800 (PST)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, thomas@cozybit.com,
	devel@lists.open80211s.org, Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] iw: Add support of setting non-forwarding entity in Mesh
Date: Sat, 21 Jan 2012 01:10:19 +0800
Message-Id: <1327079419-27765-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20120120_092210_041527_2F49FDE5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch creates a new mesh parameter known as mesh_fwding. Mesh node will become
non-forwarding entity if this parameter is set to 0. By default, it is set as 1.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 mesh.c    |    2 ++
 nl80211.h |    4 ++++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/mesh.c b/mesh.c
index 37fd1cd..764cc32 100644
--- a/mesh.c
+++ b/mesh.c
@@ -177,6 +177,8 @@ const static struct mesh_param_descr _mesh_param_descrs[] =
 	_my_nla_put_u16, _parse_u16, _print_u16},
 	{"mesh_gate_announcements", NL80211_MESHCONF_GATE_ANNOUNCEMENTS,
 	_my_nla_put_u8, _parse_u8, _print_u8},
+	{"mesh_fwding", NL80211_MESHCONF_FORWARDING,
+	_my_nla_put_u8, _parse_u8_as_bool, _print_u8},
 };

 static void print_all_mesh_param_descr(void)
diff --git a/nl80211.h b/nl80211.h
index a187606..92a1cc5 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -2098,6 +2098,9 @@ enum nl80211_mntr_flags {
  * TUs) during which a mesh STA can send only one Action frame containing a
  * PERR element.
  *
+ * @NL80211_MESHCONF_FORWARDING: set Mesh STA as forwarding or non-forwarding
+ * or forwarding entity (default is TRUE - forwarding entity)
+ *
  * @NL80211_MESHCONF_ATTR_MAX: highest possible mesh configuration attribute
  *
  * @__NL80211_MESHCONF_ATTR_AFTER_LAST: internal use
@@ -2122,6 +2125,7 @@ enum nl80211_meshconf_params {
 	NL80211_MESHCONF_HWMP_RANN_INTERVAL,
 	NL80211_MESHCONF_GATE_ANNOUNCEMENTS,
 	NL80211_MESHCONF_HWMP_PERR_MIN_INTERVAL,
+	NL80211_MESHCONF_FORWARDING,

 	/* keep last */
 	__NL80211_MESHCONF_ATTR_AFTER_LAST,
--
1.7.0.4

