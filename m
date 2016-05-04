Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:34359 "EHLO
	mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbcEDPjJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 May 2016 11:39:09 -0400
Received: by mail-lf0-f54.google.com with SMTP id m64so64686644lfd.1
        for <linux-wireless@vger.kernel.org>; Wed, 04 May 2016 08:39:08 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] iw: support setting frame subtype and reason code when deleting station
Date: Wed,  4 May 2016 17:38:57 +0200
Message-Id: <1462376337-26902-1-git-send-email-zajec5@gmail.com> (sfid-20160504_173913_725750_F79F51EB)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 station.c | 65 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 62 insertions(+), 3 deletions(-)

diff --git a/station.c b/station.c
index 8fdb83a..b29b788 100644
--- a/station.c
+++ b/station.c
@@ -498,9 +498,68 @@ static int handle_station_get(struct nl80211_state *state,
 COMMAND(station, get, "<MAC address>",
 	NL80211_CMD_GET_STATION, 0, CIB_NETDEV, handle_station_get,
 	"Get information for a specific station.");
-COMMAND(station, del, "<MAC address>",
-	NL80211_CMD_DEL_STATION, 0, CIB_NETDEV, handle_station_get,
-	"Remove the given station entry (use with caution!)");
+
+static int handle_station_del(struct nl80211_state *state,
+			      struct nl_msg *msg,
+			      int argc, char **argv,
+			      enum id_input id)
+{
+	char *end;
+	unsigned char mac_addr[ETH_ALEN];
+	int subtype;
+	int reason_code;
+
+	if (argc < 1)
+		return 1;
+
+	if (mac_addr_a2n(mac_addr, argv[0])) {
+		fprintf(stderr, "invalid mac address\n");
+		return 2;
+	}
+
+	argc--;
+	argv++;
+	NLA_PUT(msg, NL80211_ATTR_MAC, ETH_ALEN, mac_addr);
+
+	if (argc > 1 && strcmp(argv[0], "subtype") == 0) {
+		argv++;
+		argc--;
+
+		subtype = strtod(argv[0], &end);
+		if (*end != '\0')
+			return 1;
+
+		NLA_PUT_U8(msg, NL80211_ATTR_MGMT_SUBTYPE, subtype);
+		argv++;
+		argc--;
+	}
+
+	if (argc > 1 && strcmp(argv[0], "reason-code") == 0) {
+		argv++;
+		argc--;
+
+		reason_code = strtod(argv[0], &end);
+		if (*end != '\0')
+			return 1;
+
+		NLA_PUT_U16(msg, NL80211_ATTR_REASON_CODE, reason_code);
+		argv++;
+		argc--;
+	}
+
+	if (argc)
+		return 1;
+
+	register_handler(print_sta_handler, NULL);
+
+	return 0;
+ nla_put_failure:
+	return -ENOBUFS;
+}
+COMMAND(station, del, "<MAC address> [subtype <subtype>] [reason-code <code>]",
+	NL80211_CMD_DEL_STATION, 0, CIB_NETDEV, handle_station_del,
+	"Remove the given station entry (use with caution!)\n"
+	"Example subtype values: 0xA (disassociation), 0xC (deauthentication)");
 
 static const struct cmd *station_set_plink;
 static const struct cmd *station_set_vlan;
-- 
1.8.4.5

