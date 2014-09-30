Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:34727 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186AbaI3StE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2014 14:49:04 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH] iw: support setting vdev MAC during creation.
Date: Tue, 30 Sep 2014 11:48:55 -0700
Message-Id: <1412102935-30887-1-git-send-email-greearb@candelatech.com> (sfid-20140930_204916_791554_FDE9BF7C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This saves an extra call to change it later, and will
also keep udev from potentially messing with a vdev
it should not be messing with.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 info.c      |  2 ++
 interface.c | 20 ++++++++++++++++++--
 nl80211.h   | 30 ++++++++++++++++++++++++++++++
 3 files changed, 50 insertions(+), 2 deletions(-)

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
diff --git a/nl80211.h b/nl80211.h
index be9519b..2a6fc87 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -3951,6 +3951,28 @@ enum nl80211_ap_sme_features {
  * @NL80211_FEATURE_AP_MODE_CHAN_WIDTH_CHANGE: This driver supports dynamic
  *	channel bandwidth change (e.g., HT 20 <-> 40 MHz channel) during the
  *	lifetime of a BSS.
+  * @NL80211_FEATURE_DS_PARAM_SET_IE_IN_PROBES: This device adds a DS Parameter
+ *	Set IE to probe requests.
+ * @NL80211_FEATURE_WFA_TPC_IE_IN_PROBES: This device adds a WFA TPC Report IE
+ *	to probe requests.
+ * @NL80211_FEATURE_QUIET: This device, in client mode, supports Quiet Period
+ *	requests sent to it by an AP.
+ * @NL80211_FEATURE_TX_POWER_INSERTION: This device is capable of inserting the
+ *	current tx power value into the TPC Report IE in the spectrum
+ *	management TPC Report action frame, and in the Radio Measurement Link
+ *	Measurement Report action frame.
+ * @NL80211_FEATURE_ACKTO_ESTIMATION: This driver supports dynamic ACK timeout
+ *	estimation (dynack). %NL80211_ATTR_WIPHY_DYN_ACK flag attribute is used
+ *	to enable dynack.
+ * @NL80211_FEATURE_STATIC_SMPS: Device supports static spatial
+ *	multiplexing powersave, ie. can turn off all but one chain
+ *	even on HT connections that should be using more chains.
+ * @NL80211_FEATURE_DYNAMIC_SMPS: Device supports dynamic spatial
+ *	multiplexing powersave, ie. can turn off all but one chain
+ *	and then wake the rest up as required after, for example,
+ *	rts/cts handshake.
+ * @NL80211_FEATURE_MAC_ON_CREATE: Device supports configuring
+ *	the vdev's MAC address upon creation.
  */
 enum nl80211_feature_flags {
 	NL80211_FEATURE_SK_TX_STATUS			= 1 << 0,
@@ -3972,6 +3994,14 @@ enum nl80211_feature_flags {
 	NL80211_FEATURE_USERSPACE_MPM			= 1 << 16,
 	NL80211_FEATURE_ACTIVE_MONITOR			= 1 << 17,
 	NL80211_FEATURE_AP_MODE_CHAN_WIDTH_CHANGE	= 1 << 18,
+	NL80211_FEATURE_DS_PARAM_SET_IE_IN_PROBES	= 1 << 19,
+	NL80211_FEATURE_WFA_TPC_IE_IN_PROBES		= 1 << 20,
+	NL80211_FEATURE_QUIET				= 1 << 21,
+	NL80211_FEATURE_TX_POWER_INSERTION		= 1 << 22,
+	NL80211_FEATURE_ACKTO_ESTIMATION		= 1 << 23,
+	NL80211_FEATURE_STATIC_SMPS			= 1 << 24,
+	NL80211_FEATURE_DYNAMIC_SMPS			= 1 << 25,
+	NL80211_FEATURE_MAC_ON_CREATE			= 1 << 26,
 };
 
 /**
-- 
1.7.11.7

