Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11926 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860AbcFNRqk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jun 2016 13:46:40 -0400
From: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
	<arnagara@codeaurora.org>,
	Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
Subject: [PATCH] iw: Add support for controlling tx power for per station
Date: Tue, 14 Jun 2016 23:16:00 +0530
Message-ID: <1465926360-6561-1-git-send-email-arnagara@qti.qualcomm.com> (sfid-20160614_194701_619325_1A0462EE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch allows userspace to set transmit power, in mBm units, to a
station associated to the AP.

To set a limit tx power of 2000 mBm:
iw wlan0 station set <mac-addr> txpwr limit 2000

To revert the user defined tx power for a station:
iw wlan0 station set <mac-addr> txpwr auto

Signed-off-by: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
---
 station.c | 69 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 69 insertions(+)

diff --git a/station.c b/station.c
index f3e3da8..8364593 100644
--- a/station.c
+++ b/station.c
@@ -569,6 +569,7 @@ COMMAND(station, del, "<MAC address> [subtype <subtype>] [reason-code <code>]",
 static const struct cmd *station_set_plink;
 static const struct cmd *station_set_vlan;
 static const struct cmd *station_set_mesh_power_mode;
+static const struct cmd *station_set_txpwr;
 
 static const struct cmd *select_station_cmd(int argc, char **argv)
 {
@@ -580,6 +581,8 @@ static const struct cmd *select_station_cmd(int argc, char **argv)
 		return station_set_vlan;
 	if (strcmp(argv[1], "mesh_power_mode") == 0)
 		return station_set_mesh_power_mode;
+	if (strcmp(argv[1], "txpwr") == 0)
+		return station_set_txpwr;
 	return NULL;
 }
 
@@ -731,6 +734,72 @@ COMMAND_ALIAS(station, set, "<MAC address> mesh_power_mode "
 	"Set link-specific mesh power mode for this station",
 	select_station_cmd, station_set_mesh_power_mode);
 
+static int handle_station_set_txpwr(struct nl80211_state *state,
+				    struct nl_msg *msg,
+				    int argc, char **argv,
+				    enum id_input id)
+{
+	enum nl80211_tx_power_setting type;
+	unsigned char mac_addr[ETH_ALEN];
+	unsigned int sta_txpwr = 0;
+	char *err = NULL;
+
+	if (argc != 3 && argc != 4)
+		return 1;
+
+	if (mac_addr_a2n(mac_addr, argv[0])) {
+		fprintf(stderr, "invalid mac address\n");
+		return 2;
+	}
+
+	NLA_PUT(msg, NL80211_ATTR_MAC, ETH_ALEN, mac_addr);
+	argc--;
+	argv++;
+
+	if (strcmp("txpwr", argv[0]) != 0)
+		return 1;
+	argc--;
+	argv++;
+
+	if (!strcmp(argv[0], "auto"))
+		type = NL80211_TX_POWER_AUTOMATIC;
+	else if (!strcmp(argv[0], "limit"))
+		type = NL80211_TX_POWER_LIMITED;
+	else {
+		printf("Invalid parameter: %s\n", argv[0]);
+		return 2;
+	}
+
+	NLA_PUT_U32(msg, NL80211_ATTR_STA_TX_POWER_SETTING, type);
+
+	if (type != NL80211_TX_POWER_AUTOMATIC) {
+		if (argc != 2) {
+			printf("Missing TX power level argument.\n");
+			return 2;
+		}
+
+		argc--;
+		argv++;
+
+		sta_txpwr = strtoul(argv[0], &err, 0);
+		NLA_PUT_U32(msg, NL80211_ATTR_STA_TX_POWER, sta_txpwr);
+	}
+
+	argc--;
+	argv++;
+
+	if (argc)
+		return 1;
+
+	return 0;
+ nla_put_failure:
+	return -ENOBUFS;
+}
+COMMAND_ALIAS(station, set, "<MAC address> txpwr <auto|limit> [<tx power mBm>]",
+	NL80211_CMD_SET_STATION, 0, CIB_NETDEV, handle_station_set_txpwr,
+	"Set Tx power for this station.",
+	select_station_cmd, station_set_txpwr);
+
 static int handle_station_dump(struct nl80211_state *state,
 			       struct nl_msg *msg,
 			       int argc, char **argv,
-- 
1.9.1

