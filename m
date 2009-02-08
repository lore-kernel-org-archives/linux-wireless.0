Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c1.cosetrain.com ([213.239.209.213]:47125 "EHLO
	mail.cosetrain.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753312AbZBHT4v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Feb 2009 14:56:51 -0500
From: Florian Sesser <flomaillist@cosetrain.com>
To: linux-wireless@vger.kernel.org
Cc: Florian Sesser <flomaillist@cosetrain.com>
Subject: [PATCH 1/1] iw: Added capability to set individual mesh IDs
Date: Sun,  8 Feb 2009 20:56:40 +0100
Message-Id: <01b48b275f07cb009e20b7302edc935a11dec8c3.1234122907.git.flomaillist@cosetrain.com> (sfid-20090208_205654_599723_FC9446BC)
In-Reply-To: <498F36B7.40806@cosetrain.com>
References: <498F36B7.40806@cosetrain.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows the setting of
  * Path selection protocol ID
  * Path selection metric ID
  * Congestion control mode ID

Signed-off-by: Florian Sesser <flomaillist@cosetrain.com>
---
 mesh.c    |   26 ++++++++++++++++++++++++++
 nl80211.h |    3 +++
 2 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/mesh.c b/mesh.c
index 932196e..5dabe19 100644
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
diff --git a/nl80211.h b/nl80211.h
index 4bc2704..150029c 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -795,6 +795,9 @@ enum nl80211_meshconf_params {
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

