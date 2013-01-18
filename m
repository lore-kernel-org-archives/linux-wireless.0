Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63352 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab3ARMFn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jan 2013 07:05:43 -0500
Received: by mail-bk0-f46.google.com with SMTP id q16so1944200bkw.5
        for <linux-wireless@vger.kernel.org>; Fri, 18 Jan 2013 04:05:42 -0800 (PST)
From: Marco Porsch <marco@cozybit.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Marco Porsch <marco@cozybit.com>,
	Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
Subject: [PATCH 2/3] iw: add default mesh Power Mode and Awake Window to mesh config
Date: Fri, 18 Jan 2013 13:05:31 +0100
Message-Id: <1358510732-32767-3-git-send-email-marco@cozybit.com> (sfid-20130118_130547_213757_A71CD006)
In-Reply-To: <1358510732-32767-1-git-send-email-marco@cozybit.com>
References: <1358510732-32767-1-git-send-email-marco@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The default mesh power mode is the power mode that will be
assigned to newly established peer links.
The awake window is the duration the local STA will stay awake
after sending its own beacon in PS mode.
Both values can be modified as part of the mesh params.

Signed-off-by: Marco Porsch <marco@cozybit.com>
Signed-off-by: Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
---
 mesh.c |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 50 insertions(+), 2 deletions(-)

diff --git a/mesh.c b/mesh.c
index 958c2c0..5a09b62 100644
--- a/mesh.c
+++ b/mesh.c
@@ -109,6 +109,23 @@ static uint32_t _parse_s32(const char *str, _any *ret)
 	return 0;
 }
 
+static uint32_t _parse_u32_power_mode(const char *str, _any *ret)
+{
+	unsigned long int v;
+
+	/* Parse attribute for the name of power mode */
+	if (!strcmp(str, "active"))
+		v = NL80211_MESH_POWER_ACTIVE;
+	else if (!strcmp(str, "light"))
+		v = NL80211_MESH_POWER_LIGHT_SLEEP;
+	else if (!strcmp(str, "deep"))
+		v = NL80211_MESH_POWER_DEEP_SLEEP;
+	else
+		return 0xff;
+
+	ret->u.as_32 = (uint32_t)v;
+	return 0;
+}
 
 static void _print_u8(struct nlattr *a)
 {
@@ -145,6 +162,26 @@ static void _print_u32_in_TUs(struct nlattr *a)
 	printf("%d TUs", nla_get_u32(a));
 }
 
+static void _print_u32_power_mode(struct nlattr *a)
+{
+	unsigned long v = nla_get_u32(a);
+
+	switch (v) {
+	case NL80211_MESH_POWER_ACTIVE:
+		printf("active");
+		break;
+	case NL80211_MESH_POWER_LIGHT_SLEEP:
+		printf("light");
+		break;
+	case NL80211_MESH_POWER_DEEP_SLEEP:
+		printf("deep");
+		break;
+	default:
+		printf("undefined");
+		break;
+	}
+}
+
 static void _print_s32_in_dBm(struct nlattr *a)
 {
 	printf("%d dBm", (int32_t) nla_get_u32(a));
@@ -217,6 +254,10 @@ const static struct mesh_param_descr _mesh_param_descrs[] =
 	{"mesh_hwmp_confirmation_interval",
 	NL80211_MESHCONF_HWMP_CONFIRMATION_INTERVAL,
 	_my_nla_put_u16, _parse_u16, _print_u16_in_TUs},
+	{"mesh_power_mode", NL80211_MESHCONF_POWER_MODE,
+	_my_nla_put_u32, _parse_u32_power_mode, _print_u32_power_mode},
+	{"mesh_awake_window", NL80211_MESHCONF_AWAKE_WINDOW,
+	_my_nla_put_u16, _parse_u16, _print_u16_in_TUs},
 };
 
 static void print_all_mesh_param_descr(void)
@@ -294,8 +335,15 @@ static int set_interface_meshparam(struct nl80211_state *state,
 		/* Parse the new value */
 		ret = mdescr->parse_fn(value, &any);
 		if (ret != 0) {
-			printf("%s must be set to a number "
-			       "between 0 and %u\n", mdescr->name, ret);
+			if (mdescr->mesh_param_num
+			    == NL80211_MESHCONF_POWER_MODE)
+				printf("%s must be set to active, light or "
+					"deep.\n", mdescr->name);
+			else
+				printf("%s must be set to a number "
+					"between 0 and %u\n",
+					mdescr->name, ret);
+
 			return 2;
 		}
 
-- 
1.7.9.5

