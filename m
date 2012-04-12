Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58005 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab2DLXrG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 19:47:06 -0400
Received: by pbcun15 with SMTP id un15so2944402pbc.19
        for <linux-wireless@vger.kernel.org>; Thu, 12 Apr 2012 16:47:05 -0700 (PDT)
From: Ashok Nagarajan <ashok@cozybit.com>
To: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Cc: javier@cozybit.com, devel@lists.open80211s.org,
	Ashok Nagarajan <ashok@cozybit.com>
Subject: [RESEND PATCH 1/2] iw: Allow setting RSSI threshold for peering
Date: Thu, 12 Apr 2012 16:46:53 -0700
Message-Id: <1334274414-17541-1-git-send-email-ashok@cozybit.com> (sfid-20120413_014712_461109_E926B030)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
---
 Forgot to include Johannes in original submissions

 mesh.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/mesh.c b/mesh.c
index b2c7208..3f5a572 100644
--- a/mesh.c
+++ b/mesh.c
@@ -17,6 +17,7 @@ SECTION(mesh);
 typedef struct _any_t {
 	union {
 		uint32_t as_32;
+		int32_t as_s32;
 		uint16_t as_16;
 		uint8_t as_8;
 	} u;
@@ -96,6 +97,19 @@ static uint32_t _parse_u32(const char *str, _any *ret)
 	return 0;
 }
 
+static uint32_t _parse_s32(const char *str, _any *ret)
+{
+	char *endptr = NULL;
+	long int v = strtol(str, &endptr, 10);
+	if (*endptr != '\0')
+		return 0xffffffff;
+	if (v > 0xff)
+		return 0xffffffff;
+	ret->u.as_s32 = (int32_t)v;
+	return 0;
+}
+
+
 static void _print_u8(struct nlattr *a)
 {
 	printf("%d", nla_get_u8(a));
@@ -126,6 +140,12 @@ static void _print_u32_in_TUs(struct nlattr *a)
 	printf("%d TUs", nla_get_u32(a));
 }
 
+static void _print_s32_in_dBm(struct nlattr *a)
+{
+	printf("%d dBm", (int32_t) nla_get_u32(a));
+}
+
+
 /* The current mesh parameters */
 const static struct mesh_param_descr _mesh_param_descrs[] =
 {
@@ -179,6 +199,8 @@ const static struct mesh_param_descr _mesh_param_descrs[] =
 	_my_nla_put_u8, _parse_u8, _print_u8},
 	{"mesh_fwding", NL80211_MESHCONF_FORWARDING,
 	_my_nla_put_u8, _parse_u8_as_bool, _print_u8},
+	{"mesh_rssi_threshold", NL80211_MESHCONF_RSSI_THRESHOLD,
+	_my_nla_put_u32, _parse_s32, _print_s32_in_dBm},
 };
 
 static void print_all_mesh_param_descr(void)
-- 
1.7.5.4

