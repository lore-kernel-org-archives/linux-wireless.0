Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f43.google.com ([209.85.160.43]:65289 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab3GHREY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jul 2013 13:04:24 -0400
Received: by mail-pb0-f43.google.com with SMTP id md12so4495537pbc.2
        for <linux-wireless@vger.kernel.org>; Mon, 08 Jul 2013 10:04:24 -0700 (PDT)
From: Colleen Twitty <colleen@cozybit.com>
To: linux-wirelss <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	open80211s <devel@lists.open80211s.org>
Subject: [PATCH] iw: Add support for mesh peer link expiration.
Date: Mon,  8 Jul 2013 10:04:18 -0700
Message-Id: <1373303058-4229-1-git-send-email-colleen@cozybit.com> (sfid-20130708_190427_820204_FF047937)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

User can configure the peer link expiration time with a
new mesh parameter, mesh_plink_timeout.  This parameter
sets the expiration time, in seconds, for peer links.
After this time, the peer link is expired.  This means the
inactive STA is removed from the list of peers and is not
considered a peer again unless it re-peers.

Signed-off-by: Colleen Twitty <colleen@cozybit.com>
---
 mesh.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mesh.c b/mesh.c
index 5a09b62..ca065bf 100644
--- a/mesh.c
+++ b/mesh.c
@@ -157,6 +157,11 @@ static void _print_u32_timeout(struct nlattr *a)
 	printf("%u milliseconds", nla_get_u32(a));
 }
 
+static void _print_u32_in_seconds(struct nlattr *a)
+{
+	printf("%d seconds", nla_get_u32(a));
+}
+
 static void _print_u32_in_TUs(struct nlattr *a)
 {
 	printf("%d TUs", nla_get_u32(a));
@@ -258,6 +263,8 @@ const static struct mesh_param_descr _mesh_param_descrs[] =
 	_my_nla_put_u32, _parse_u32_power_mode, _print_u32_power_mode},
 	{"mesh_awake_window", NL80211_MESHCONF_AWAKE_WINDOW,
 	_my_nla_put_u16, _parse_u16, _print_u16_in_TUs},
+	{"mesh_plink_timeout", NL80211_MESHCONF_PLINK_TIMEOUT,
+	_my_nla_put_u32, _parse_u32, _print_u32_in_seconds},
 };
 
 static void print_all_mesh_param_descr(void)
-- 
1.7.9.5

