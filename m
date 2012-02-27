Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:43039 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021Ab2B0Wjq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 17:39:46 -0500
Received: by pbcup15 with SMTP id up15so2554756pbc.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Feb 2012 14:39:45 -0800 (PST)
MIME-Version: 1.0
From: Ashok Nagarajan <ashok@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: javier@cozybit.com, ashok@cozybit.com
Subject: [PATCH] iw: Allow setting RSSI threshold for peering
Date: Mon, 27 Feb 2012 14:39:39 -0800
Message-Id: <1330382379-3947-1-git-send-email-ashok@cozybit.com> (sfid-20120227_233950_333327_FC602C2A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 mesh.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/mesh.c b/mesh.c
index 37fd1cd..21c45be 100644
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
+	long long int v = strtoll(str, &endptr, 10);
+	if (*endptr != '\0')
+		return 0xffffffff;
+	if (v > 0xffffffff)
+		return 0xffffffff;
+	ret->u.as_32 = (int32_t)v;
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
@@ -177,6 +197,9 @@ const static struct mesh_param_descr _mesh_param_descrs[] =
 	_my_nla_put_u16, _parse_u16, _print_u16},
 	{"mesh_gate_announcements", NL80211_MESHCONF_GATE_ANNOUNCEMENTS,
 	_my_nla_put_u8, _parse_u8, _print_u8},
+	{"mesh_rssi_threshold",
+	NL80211_MESHCONF_RSSI_THRESHOLD,
+	_my_nla_put_u32, _parse_s32, _print_s32_in_dBm},
 };
 
 static void print_all_mesh_param_descr(void)
-- 
1.7.0.4

