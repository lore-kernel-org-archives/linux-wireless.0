Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:48088 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755262AbaJXPfr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2014 11:35:47 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2] iw: support setting vif MAC during creation
Date: Fri, 24 Oct 2014 08:35:42 -0700
Message-Id: <1414164942-23125-1-git-send-email-greearb@candelatech.com> (sfid-20141024_173550_984752_BE7C984B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This saves an extra call to change it later, and will
also keep udev from potentially messing with a vif
it should not be messing with.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

v2:  Removed header changes per request.

 info.c      |  2 ++
 interface.c | 20 ++++++++++++++++++--
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/info.c b/info.c
index c5917d7..6244218 100644
--- a/info.c
+++ b/info.c
@@ -558,6 +558,8 @@ broken_combination:
 			printf("\tDevice supports scan flush.\n");
 		if (features & NL80211_FEATURE_AP_SCAN)
 			printf("\tDevice supports AP scan.\n");
+		if (features & NL80211_FEATURE_MAC_ON_CREATE)
+			printf("\tDevice supports configuring vdev MAC-addr on create.\n");
 	}
 
 	if (tb_msg[NL80211_ATTR_TDLS_SUPPORT])
diff --git a/interface.c b/interface.c
index f769752..f8e39b3 100644
--- a/interface.c
+++ b/interface.c
@@ -171,6 +171,8 @@ static int handle_interface_add(struct nl80211_state *state,
 	char *mesh_id = NULL;
 	enum nl80211_iftype type;
 	int tpset;
+	unsigned char mac_addr[ETH_ALEN];
+	int found_mac = 0;
 
 	if (argc < 1)
 		return 1;
@@ -183,6 +185,7 @@ static int handle_interface_add(struct nl80211_state *state,
 	if (tpset)
 		return tpset;
 
+try_another:
 	if (argc) {
 		if (strcmp(argv[0], "mesh_id") == 0) {
 			argc--;
@@ -193,6 +196,17 @@ static int handle_interface_add(struct nl80211_state *state,
 			mesh_id = argv[0];
 			argc--;
 			argv++;
+		} else if (strcmp(argv[0], "addr") == 0) {
+			argc--;
+			argv++;
+			if (mac_addr_a2n(mac_addr, argv[0])) {
+				fprintf(stderr, "Invalid MAC address\n");
+				return 2;
+			}
+			argc--;
+			argv++;
+			found_mac = 1;
+			goto try_another;
 		} else if (strcmp(argv[0], "4addr") == 0) {
 			argc--;
 			argv++;
@@ -221,19 +235,21 @@ static int handle_interface_add(struct nl80211_state *state,
 	NLA_PUT_U32(msg, NL80211_ATTR_IFTYPE, type);
 	if (mesh_id)
 		NLA_PUT(msg, NL80211_ATTR_MESH_ID, strlen(mesh_id), mesh_id);
+	if (found_mac)
+		NLA_PUT(msg, NL80211_ATTR_MAC, ETH_ALEN, mac_addr);
 
 	return 0;
  nla_put_failure:
 	return -ENOBUFS;
 }
-COMMAND(interface, add, "<name> type <type> [mesh_id <meshid>] [4addr on|off] [flags <flag>*]",
+COMMAND(interface, add, "<name> type <type> [mesh_id <meshid>] [4addr on|off] [flags <flag>*] [addr <mac-addr>]",
 	NL80211_CMD_NEW_INTERFACE, 0, CIB_PHY, handle_interface_add,
 	"Add a new virtual interface with the given configuration.\n"
 	IFACE_TYPES "\n\n"
 	"The flags are only used for monitor interfaces, valid flags are:\n"
 	VALID_FLAGS "\n\n"
 	"The mesh_id is used only for mesh mode.");
-COMMAND(interface, add, "<name> type <type> [mesh_id <meshid>] [4addr on|off] [flags <flag>*]",
+COMMAND(interface, add, "<name> type <type> [mesh_id <meshid>] [4addr on|off] [flags <flag>*] [addr <mac-addr>]",
 	NL80211_CMD_NEW_INTERFACE, 0, CIB_NETDEV, handle_interface_add, NULL);
 
 static int handle_interface_del(struct nl80211_state *state,
-- 
1.7.11.7

