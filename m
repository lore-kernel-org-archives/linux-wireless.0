Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:42168 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755263AbZKKMWT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Nov 2009 07:22:19 -0500
Message-ID: <4AFAAC7F.8000903@openwrt.org>
Date: Wed, 11 Nov 2009 13:22:23 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] iw: add a command for moving a STA into an AP VLAN
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---

--- a/station.c
+++ b/station.c
@@ -196,7 +196,7 @@ COMMAND(station, del, "<MAC address>",
 	NL80211_CMD_DEL_STATION, 0, CIB_NETDEV, handle_station_get,
 	"Remove the given station entry (use with caution!)");
 
-static int handle_station_set(struct nl80211_state *state,
+static int handle_station_set_plink(struct nl80211_state *state,
 			      struct nl_cb *cb,
 			      struct nl_msg *msg,
 			      int argc, char **argv)
@@ -241,9 +241,56 @@ static int handle_station_set(struct nl8
 	return -ENOBUFS;
 }
 COMMAND(station, set, "<MAC address> plink_action <open|block>",
-	NL80211_CMD_SET_STATION, 0, CIB_NETDEV, handle_station_set,
+	NL80211_CMD_SET_STATION, 0, CIB_NETDEV, handle_station_set_plink,
 	"Set mesh peer link action for this station (peer).");
 
+static int handle_station_set_vlan(struct nl80211_state *state,
+			      struct nl_cb *cb,
+			      struct nl_msg *msg,
+			      int argc, char **argv)
+{
+	unsigned char mac_addr[ETH_ALEN];
+	unsigned long sta_vlan = 0;
+	char *err = NULL;
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
+	if (strcmp("vlan", argv[0]) != 0)
+		return 1;
+	argc--;
+	argv++;
+
+	sta_vlan = strtoul(argv[0], &err, 0);
+	if (err && *err) {
+		fprintf(stderr, "invalid vlan id\n");
+		return 2;
+	}
+	argc--;
+	argv++;
+
+	if (argc)
+		return 1;
+
+	NLA_PUT(msg, NL80211_ATTR_MAC, ETH_ALEN, mac_addr);
+	NLA_PUT_U32(msg, NL80211_ATTR_STA_VLAN, sta_vlan);
+
+	return 0;
+ nla_put_failure:
+	return -ENOBUFS;
+}
+COMMAND(station, set, "<MAC address> vlan <ifindex>",
+	NL80211_CMD_SET_STATION, 0, CIB_NETDEV, handle_station_set_vlan,
+	"Set an AP VLAN for this station.");
+
+
 static int handle_station_dump(struct nl80211_state *state,
 			       struct nl_cb *cb,
 			       struct nl_msg *msg,
