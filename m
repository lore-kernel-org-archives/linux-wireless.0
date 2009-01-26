Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c1.cosetrain.com ([213.239.209.213]:40878 "EHLO
	mail.cosetrain.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751373AbZAZUhf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2009 15:37:35 -0500
From: Florian Sesser <flomaillist@cosetrain.com>
To: linux-wireless@vger.kernel.org
Cc: Florian Sesser <flomaillist@cosetrain.com>
Subject: [PATCH 1/1] Added capability to get/set individual mesh IDs
Date: Mon, 26 Jan 2009 21:37:32 +0100
Message-Id: <31610094c24d43137b876f9e3f358f76e98b29b8.1233001917.git.flomaillist@cosetrain.com> (sfid-20090126_213741_486864_31855725)
In-Reply-To: <497E1B90.4060803@cosetrain.com>
References: <497E1B90.4060803@cosetrain.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows the setting of
  * Path selection protocol ID
  * Path selection metric ID
  * Congestion control mode ID

Signed-off-by: Florian Sesser <flomaillist@cosetrain.com>
---
 mesh.c    |   29 +++++++++++++++++++++++++++++
 nl80211.h |    3 +++
 2 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/mesh.c b/mesh.c
index f663363..e790175 100644
--- a/mesh.c
+++ b/mesh.c
@@ -93,6 +93,18 @@ static uint32_t _parse_u32(const char *str, _any *ret)
 	return 0;
 }
 
+static uint32_t _parse_hex_u32(const char *str, _any *ret)
+{
+	char *endptr = NULL;
+	long long int v = strtoll(str, &endptr, 16);
+	if (*endptr != '\0')
+		return 0xffffffff;
+	if ((v < 0) || (v > 0xffffffff))
+		return 0xffffffff;
+	ret->u.as_32 = (uint32_t)v;
+	return 0;
+}
+
 static void _print_u8(struct nlattr *a)
 {
 	printf("%d", nla_get_u8(a));
@@ -123,6 +135,11 @@ static void _print_u32_in_TUs(struct nlattr *a)
 	printf("%d TUs", nla_get_u32(a));
 }
 
+void _print_u32_as_hex(struct nlattr *a)
+{
+	printf("%08X", nla_get_u32(a));
+}
+
 /* The current mesh parameters */
 const static struct mesh_param_descr _mesh_param_descrs[] =
 {
@@ -165,6 +182,15 @@ const static struct mesh_param_descr _mesh_param_descrs[] =
 	{"mesh_hwmp_net_diameter_traversal_time",
 	NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME,
 	_my_nla_put_u16, _parse_u16, _print_u16_in_TUs},
+	{"mesh_path_selection_protocol_id",
+	NL80211_MESHCONF_PATH_SELECTION_PROTOCOL_ID,
+	_my_nla_put_u32, _parse_hex_u32, _print_u32_as_hex},
+	{"mesh_path_selection_metric_id",
+	NL80211_MESHCONF_PATH_SELECTION_METRIC_ID,
+	_my_nla_put_u32, _parse_hex_u32, _print_u32_as_hex},
+	{"mesh_congestion_control_mode_id",
+	NL80211_MESHCONF_CONGESTION_CONTROL_MODE_ID,
+	_my_nla_put_u32, _parse_hex_u32, _print_u32_as_hex},
 };
 
 static void print_all_mesh_param_descr(void)
@@ -187,6 +213,9 @@ static const struct mesh_param_descr* find_mesh_param(int argc, char **argv,
 	if (argc < 1) {
 		printf("You must specify which mesh parameter to %s.\n",
 		       action_name);
+		printf("Mesh_param must be one of: ");
+		print_all_mesh_param_descr();
+		printf("\n");
 		return NULL;
 	}
 
diff --git a/nl80211.h b/nl80211.h
index e86ed59..db0fe93 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -765,6 +765,9 @@ enum nl80211_meshconf_params {
 	NL80211_MESHCONF_HWMP_ACTIVE_PATH_TIMEOUT,
 	NL80211_MESHCONF_HWMP_PREQ_MIN_INTERVAL,
 	NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME,
+	NL80211_MESHCONF_PATH_SELECTION_PROTOCOL_ID,
+	NL80211_MESHCONF_PATH_SELECTION_METRIC_ID,
+	NL80211_MESHCONF_CONGESTION_CONTROL_MODE_ID,
 
 	/* keep last */
 	__NL80211_MESHCONF_ATTR_AFTER_LAST,
-- 
1.5.6.5

