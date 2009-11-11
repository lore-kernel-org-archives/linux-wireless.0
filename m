Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:42160 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755345AbZKKMUg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Nov 2009 07:20:36 -0500
Message-ID: <4AFAAC18.3090403@openwrt.org>
Date: Wed, 11 Nov 2009 13:20:40 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] iw: add support for setting the wds/4-address flag when creating
 an interface
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---

--- a/interface.c
+++ b/interface.c
@@ -137,6 +137,20 @@ static int get_if_type(int *argc, char *
 	return 2;
 }
 
+static int parse_wds_flag(const char *value, struct nl_msg *msg)
+{
+	if (strcmp(value, "on") == 0)
+		NLA_PUT_U8(msg, NL80211_ATTR_4ADDR, 1);
+	else if (strcmp(value, "off") == 0)
+		NLA_PUT_U8(msg, NL80211_ATTR_4ADDR, 0);
+	else
+		return 1;
+	return 0;
+
+nla_put_failure:
+	return 1;
+}
+
 static int handle_interface_add(struct nl80211_state *state,
 				struct nl_cb *cb,
 				struct nl_msg *msg,
@@ -168,6 +182,15 @@ static int handle_interface_add(struct n
 			mesh_id = argv[0];
 			argc--;
 			argv++;
+		} else if (strcmp(argv[0], "wds") == 0) {
+			argc--;
+			argv++;
+			if (parse_wds_flag(argv[0], msg)) {
+				fprintf(stderr, "wds error\n");
+				return 2;
+			}
+			argc--;
+			argv++;
 		} else if (strcmp(argv[0], "flags") == 0) {
 			argc--;
 			argv++;
@@ -192,14 +215,14 @@ static int handle_interface_add(struct n
  nla_put_failure:
 	return -ENOBUFS;
 }
-COMMAND(interface, add, "<name> type <type> [mesh_id <meshid>] [flags <flag>*]",
+COMMAND(interface, add, "<name> type <type> [mesh_id <meshid>] [wds on|off] [flags <flag>*]",
 	NL80211_CMD_NEW_INTERFACE, 0, CIB_PHY, handle_interface_add,
 	"Add a new virtual interface with the given configuration.\n"
 	IFACE_TYPES "\n\n"
 	"The flags are only used for monitor interfaces, valid flags are:\n"
 	VALID_FLAGS "\n\n"
 	"The mesh_id is used only for mesh mode.");
-COMMAND(interface, add, "<name> type <type> [mesh_id <meshid>] [flags <flag>*]",
+COMMAND(interface, add, "<name> type <type> [mesh_id <meshid>] [wds on|off] [flags <flag>*]",
 	NL80211_CMD_NEW_INTERFACE, 0, CIB_NETDEV, handle_interface_add, NULL);
 
 static int handle_interface_del(struct nl80211_state *state,
--- a/nl80211.h
+++ b/nl80211.h
@@ -584,6 +584,8 @@ enum nl80211_commands {
  *	changed then the list changed and the dump should be repeated
  *	completely from scratch.
  *
+ * @NL80211_ATTR_4ADDR: Use 4-address frames on a virtual interface
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -714,6 +716,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_PID,
 
+	NL80211_ATTR_4ADDR,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
