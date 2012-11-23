Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:54276 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756149Ab2KWUx1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2012 15:53:27 -0500
From: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
To: johannes@sipsolutions.net, javier@cozybit.com, thomas@cozybit.com
Cc: linux-wireless@vger.kernel.org,
	Marco Porsch <marco.porsch@etit.tu-chemnitz.de>,
	Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
Subject: [RFCv2 2/4] iw: add default mesh power mode to mesh config
Date: Fri, 23 Nov 2012 12:53:12 -0800
Message-Id: <1353703994-13093-3-git-send-email-marco.porsch@etit.tu-chemnitz.de> (sfid-20121123_215338_862484_60E971D4)
In-Reply-To: <1353703994-13093-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <1353703994-13093-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The default mesh power mode is the power mode that will be assigned to newly
established peer links.

Signed-off-by: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Signed-off-by: Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
---
 mesh.c |   51 +++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 49 insertions(+), 2 deletions(-)

diff --git a/mesh.c b/mesh.c
index 958c2c0..94f1012 100644
--- a/mesh.c
+++ b/mesh.c
@@ -73,6 +73,24 @@ static uint32_t _parse_u8_as_bool(const char *str, _any *ret)
 	return 0;
 }
 
+static uint32_t _parse_u8_power_mode(const char *str, _any *ret)
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
+	ret->u.as_8 = (uint8_t)v;
+	return 0;
+}
+
 static uint32_t _parse_u16(const char *str, _any *ret)
 {
 	char *endptr = NULL;
@@ -115,6 +133,26 @@ static void _print_u8(struct nlattr *a)
 	printf("%d", nla_get_u8(a));
 }
 
+static void _print_u8_power_mode(struct nlattr *a)
+{
+	unsigned long v = nla_get_u8(a);
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
 static void _print_u16(struct nlattr *a)
 {
 	printf("%d", nla_get_u16(a));
@@ -217,6 +255,8 @@ const static struct mesh_param_descr _mesh_param_descrs[] =
 	{"mesh_hwmp_confirmation_interval",
 	NL80211_MESHCONF_HWMP_CONFIRMATION_INTERVAL,
 	_my_nla_put_u16, _parse_u16, _print_u16_in_TUs},
+	{"mesh_power_mode", NL80211_MESHCONF_POWER_MODE,
+	_my_nla_put_u8, _parse_u8_power_mode, _print_u8_power_mode},
 };
 
 static void print_all_mesh_param_descr(void)
@@ -294,8 +334,15 @@ static int set_interface_meshparam(struct nl80211_state *state,
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

