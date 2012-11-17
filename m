Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:39855 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab2KQGtz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Nov 2012 01:49:55 -0500
From: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
To: johannes@sipsolutions.net, javier@cozybit.com
Cc: linux-wireless@vger.kernel.org,
	Marco Porsch <marco.porsch@etit.tu-chemnitz.de>,
	Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
Subject: [RFC 3/4] iw: add support for link-specific mesh power modes
Date: Fri, 16 Nov 2012 22:49:38 -0800
Message-Id: <1353134979-13314-4-git-send-email-marco.porsch@etit.tu-chemnitz.de> (sfid-20121117_074958_373273_A0C3250C)
In-Reply-To: <1353134979-13314-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <1353134979-13314-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The different power modes of links towards neighbor STA can be read using
iw <dev> station get
-or-
iw <dev> station dump

The different power modes shown are:
- mesh local PS mode
- mesh peer PS mode
- mesh non-peer PS mode
where the local PS mode is "our" mode towards the neighbor, the peer PS mode
is the neighbor's mode towards us, and the non-peer PS mode is the neighbor's
non-peer PS mode as indicated in beacons and management frames.

The local PS mode can be modified for each neighbor using
iw <dev> station set <mac-addr> mesh_power_mode <active|light|deep>

Signed-off-by: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Signed-off-by: Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
---
 station.c |   89 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 89 insertions(+)

diff --git a/station.c b/station.c
index 247f445..09ccb8f 100644
--- a/station.c
+++ b/station.c
@@ -29,6 +29,25 @@ enum plink_actions {
 	PLINK_ACTION_BLOCK,
 };
 
+static void print_power_mode(struct nlattr *a)
+{
+	enum nl80211_mesh_power_mode pm = nla_get_u8(a);
+
+	switch (pm) {
+	case NL80211_MESH_POWER_ACTIVE:
+		printf("ACTIVE");
+		break;
+	case NL80211_MESH_POWER_LIGHT_SLEEP:
+		printf("LIGHT SLEEP");
+		break;
+	case NL80211_MESH_POWER_DEEP_SLEEP:
+		printf("DEEP SLEEP");
+		break;
+	default:
+		printf("UNKNOWN");
+		break;
+	}
+}
 
 static int print_sta_handler(struct nl_msg *msg, void *arg)
 {
@@ -54,6 +73,9 @@ static int print_sta_handler(struct nl_msg *msg, void *arg)
 		[NL80211_STA_INFO_TX_FAILED] = { .type = NLA_U32 },
 		[NL80211_STA_INFO_STA_FLAGS] =
 			{ .minlen = sizeof(struct nl80211_sta_flag_update) },
+		[NL80211_STA_INFO_LOCAL_MESH_PS_MODE] = { .type = NLA_U8},
+		[NL80211_STA_INFO_PEER_MESH_PS_MODE] = { .type = NLA_U8},
+		[NL80211_STA_INFO_NONPEER_MESH_PS_MODE] = { .type = NLA_U8},
 	};
 
 	static struct nla_policy rate_policy[NL80211_RATE_INFO_MAX + 1] = {
@@ -177,6 +199,18 @@ static int print_sta_handler(struct nl_msg *msg, void *arg)
 		}
 		printf("\n\tmesh plink:\t%s", state_name);
 	}
+	if (sinfo[NL80211_STA_INFO_LOCAL_MESH_PS_MODE]) {
+		printf("\n\tmesh local PS mode:\t");
+		print_power_mode(sinfo[NL80211_STA_INFO_LOCAL_MESH_PS_MODE]);
+	}
+	if (sinfo[NL80211_STA_INFO_PEER_MESH_PS_MODE]) {
+		printf("\n\tmesh peer PS mode:\t");
+		print_power_mode(sinfo[NL80211_STA_INFO_PEER_MESH_PS_MODE]);
+	}
+	if (sinfo[NL80211_STA_INFO_NONPEER_MESH_PS_MODE]) {
+		printf("\n\tmesh non-peer PS mode:\t");
+		print_power_mode(sinfo[NL80211_STA_INFO_NONPEER_MESH_PS_MODE]);
+	}
 
 	if (sinfo[NL80211_STA_INFO_STA_FLAGS]) {
 		sta_flags = (struct nl80211_sta_flag_update *)
@@ -274,6 +308,7 @@ COMMAND(station, del, "<MAC address>",
 
 static const struct cmd *station_set_plink;
 static const struct cmd *station_set_vlan;
+static const struct cmd *station_set_mesh_power_mode;
 
 static const struct cmd *select_station_cmd(int argc, char **argv)
 {
@@ -283,6 +318,8 @@ static const struct cmd *select_station_cmd(int argc, char **argv)
 		return station_set_plink;
 	if (strcmp(argv[1], "vlan") == 0)
 		return station_set_vlan;
+	if (strcmp(argv[1], "mesh_power_mode") == 0)
+		return station_set_mesh_power_mode;
 	return NULL;
 }
 
@@ -384,6 +421,58 @@ COMMAND_ALIAS(station, set, "<MAC address> vlan <ifindex>",
 	"Set an AP VLAN for this station.",
 	select_station_cmd, station_set_vlan);
 
+static int handle_station_set_mesh_power_mode(struct nl80211_state *state,
+					      struct nl_cb *cb,
+					      struct nl_msg *msg,
+					      int argc, char **argv,
+					      enum id_input id)
+{
+	unsigned char mesh_power_mode;
+	unsigned char mac_addr[ETH_ALEN];
+
+	if (argc < 3)
+		return 1;
+
+	if (mac_addr_a2n(mac_addr, argv[0])) {
+		fprintf(stderr, "invalid mac address\n");
+		return 2;
+	}
+	argc--;
+	argv++;
+
+	if (strcmp("mesh_power_mode", argv[0]) != 0)
+		return 1;
+	argc--;
+	argv++;
+
+	if (strcmp("active", argv[0]) == 0)
+		mesh_power_mode = NL80211_MESH_POWER_ACTIVE;
+	else if (strcmp("light", argv[0]) == 0)
+		mesh_power_mode = NL80211_MESH_POWER_LIGHT_SLEEP;
+	else if (strcmp("deep", argv[0]) == 0)
+		mesh_power_mode = NL80211_MESH_POWER_DEEP_SLEEP;
+	else {
+		fprintf(stderr, "unknown mesh power mode\n");
+		return 2;
+	}
+	argc--;
+	argv++;
+
+	if (argc)
+		return 1;
+
+	NLA_PUT(msg, NL80211_ATTR_MAC, ETH_ALEN, mac_addr);
+	NLA_PUT_U8(msg, NL80211_ATTR_LOCAL_MESH_POWER_MODE, mesh_power_mode);
+
+	return 0;
+nla_put_failure:
+	return -ENOBUFS;
+}
+COMMAND_ALIAS(station, set, "<MAC address> mesh_power_mode "
+	"<active|light|deep>", NL80211_CMD_SET_STATION, 0, CIB_NETDEV,
+	handle_station_set_mesh_power_mode,
+	"Set link-specific mesh power mode for this station",
+	select_station_cmd, station_set_mesh_power_mode);
 
 static int handle_station_dump(struct nl80211_state *state,
 			       struct nl_cb *cb,
-- 
1.7.9.5

