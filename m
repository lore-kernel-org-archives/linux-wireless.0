Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:48365 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843Ab2GDQ0w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jul 2012 12:26:52 -0400
Received: by ghrr11 with SMTP id r11so6621718ghr.19
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jul 2012 09:26:52 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, devel@lists.open80211s.org,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] iw: allow setting mesh proactive tree building mode related parameters
Date: Thu,  5 Jul 2012 00:26:33 +0800
Message-Id: <1341419193-5670-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20120704_182655_587151_13C2EAB2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch allows the setting of following mesh parameters:
mesh_hwmp_active_path_to_root_timeout
mesh_hwmp_root_interval
mesh_hwmp_confirmation_interval

Also ensure the TU is printed for mesh_hwmp_rann_interval.
---
 mesh.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/mesh.c b/mesh.c
index f678dc0..7b7efe8 100644
--- a/mesh.c
+++ b/mesh.c
@@ -199,7 +199,7 @@ const static struct mesh_param_descr _mesh_param_descrs[] =
 	{"mesh_hwmp_rootmode", NL80211_MESHCONF_HWMP_ROOTMODE,
 	_my_nla_put_u8, _parse_u8, _print_u8},
 	{"mesh_hwmp_rann_interval", NL80211_MESHCONF_HWMP_RANN_INTERVAL,
-	_my_nla_put_u16, _parse_u16, _print_u16},
+	_my_nla_put_u16, _parse_u16, _print_u16_in_TUs},
 	{"mesh_gate_announcements", NL80211_MESHCONF_GATE_ANNOUNCEMENTS,
 	_my_nla_put_u8, _parse_u8, _print_u8},
 	{"mesh_fwding", NL80211_MESHCONF_FORWARDING,
@@ -209,6 +209,14 @@ const static struct mesh_param_descr _mesh_param_descrs[] =
 	_my_nla_put_u32, _parse_u32, _print_u32},
 	{"mesh_rssi_threshold", NL80211_MESHCONF_RSSI_THRESHOLD,
 	_my_nla_put_u32, _parse_s32, _print_s32_in_dBm},
+	{"mesh_hwmp_active_path_to_root_timeout",
+	NL80211_MESHCONF_HWMP_PATH_TO_ROOT_TIMEOUT,
+	_my_nla_put_u32, _parse_u32, _print_u32_in_TUs},
+	{"mesh_hwmp_root_interval", NL80211_MESHCONF_HWMP_ROOT_INTERVAL,
+	_my_nla_put_u16, _parse_u16, _print_u16_in_TUs},
+	{"mesh_hwmp_confirmation_interval",
+	NL80211_MESHCONF_HWMP_CONFIRMATION_INTERVAL,
+	_my_nla_put_u16, _parse_u16, _print_u16_in_TUs},
 };
 
 static void print_all_mesh_param_descr(void)
-- 
1.7.0.4

