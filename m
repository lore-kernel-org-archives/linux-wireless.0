Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39294 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbZGOAdg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jul 2009 20:33:36 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] iw: Add Wake-on-Wireless LAN (WoW) support
Date: Tue, 14 Jul 2009 20:33:35 -0400
Message-Id: <1247618015-24045-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Your device will need WoW suport and it will need to claim it
to cfg80211. Additionally you will need to ensure your BIOS
supports keeping the device on during suspend and that its
PCI PMEs will be passed and processed so that the box is kicked
on upon a WoW trigger.

We support several WoW events:

 * Reception of a user specified pattern
 * Reception of a Magic Packet frame
 * A change in Link status

Each driver may claim which of these type of events they support.

For more information please read:

http://wireless.kernel.org/en/users/Documentation/WoW

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 Makefile  |    2 +-
 nl80211.h |  103 +++++++++++++++++++++++++++++++++++++++++++++++
 wow.c     |  132 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 236 insertions(+), 1 deletions(-)
 create mode 100644 wow.c

diff --git a/Makefile b/Makefile
index 520723c..72cd207 100644
--- a/Makefile
+++ b/Makefile
@@ -14,7 +14,7 @@ CC ?= "gcc"
 CFLAGS ?= -O2 -g
 CFLAGS += -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration
 
-OBJS = iw.o genl.o event.o info.o phy.o interface.o ibss.o station.o util.o mesh.o mpath.o scan.o reg.o version.o reason.o status.o connect.o
+OBJS = iw.o genl.o event.o info.o phy.o interface.o ibss.o station.o util.o mesh.o mpath.o scan.o reg.o version.o reason.o status.o connect.o wow.o
 ALL = iw
 
 NL1FOUND := $(shell $(PKG_CONFIG) --atleast-version=1 libnl-1 && echo Y)
diff --git a/nl80211.h b/nl80211.h
index b34c17f..0c869ca 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -262,6 +262,18 @@
  *	reasons, for this the %NL80211_ATTR_DISCONNECTED_BY_AP and
  *	%NL80211_ATTR_REASON_CODE attributes are used.
  *
+ * @NL80211_CMD_GET_WOW: get Wake-on-Wireless-LAN (WoW) settings.
+ * @NL80211_CMD_SET_WOW: set Wake-on-Wireless-LAN (Wow) settings. Wake on
+ *	wireless makes use of standard Wake-on-LAN (WoL) frames, you receive
+ *	a WoW frame when your AP sends you a regular WOL frame. The difference
+ *	difference WoL is you need to be associated to an AP in order to
+ *	receive WoW frames, so additional triggers are available for a wakeup.
+ *	A driver capable of WoW should initialize the wiphy with its supported
+ *	WoW triggers. Upon suspend cfg80211 will inform the driver of the user
+ *	enabled triggers. By default no WoW triggers are enabled.
+ *	For more information see:
+ *	http://wireless.kernel.org/en/users/Documentation/WoW
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -336,6 +348,9 @@ enum nl80211_commands {
 	NL80211_CMD_ROAM,
 	NL80211_CMD_DISCONNECT,
 
+	NL80211_CMD_GET_WOW,
+	NL80211_CMD_SET_WOW,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -355,6 +370,8 @@ enum nl80211_commands {
 #define NL80211_CMD_DEAUTHENTICATE NL80211_CMD_DEAUTHENTICATE
 #define NL80211_CMD_DISASSOCIATE NL80211_CMD_DISASSOCIATE
 #define NL80211_CMD_REG_BEACON_HINT NL80211_CMD_REG_BEACON_HINT
+#define NL80211_CMD_GET_WOW NL80211_CMD_GET_WOW
+#define NL80211_CMD_SET_WOW NL80211_CMD_SET_WOW
 
 /**
  * enum nl80211_attrs - nl80211 netlink attributes
@@ -564,6 +581,21 @@ enum nl80211_commands {
  * @NL80211_ATTR_RESP_IE: (Re)association response information elements as
  *	sent by peer, for ROAM and successful CONNECT events.
  *
+ * @NL80211_ATTR_PREV_BSSID: previous BSSID, to be used by in ASSOCIATE
+ *	commands to specify using a reassociate frame
+ *
+ * @NL80211_ATTR_KEY: key information in a nested attribute with
+ *	%NL80211_KEY_* sub-attributes
+ * @NL80211_ATTR_KEYS: array of keys for static WEP keys for connect()
+ *	and join_ibss(), key information is in a nested attribute each
+ *	with %NL80211_KEY_* sub-attributes
+ *
+ * @NL80211_ATTR_WOW_TRIGGERS_SUPPORTED: the supported WoW triggers
+ * @NL80211_ATTR_WOW_TRIGGERS_ENABLED: used by %NL80211_CMD_SET_WOW to
+ *	indicate which WoW triggers should be enabled. This is also
+ *	used by %NL80211_CMD_GET_WOW to get the currently enabled WoW
+ *	triggers.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -687,6 +719,14 @@ enum nl80211_attrs {
 	NL80211_ATTR_REQ_IE,
 	NL80211_ATTR_RESP_IE,
 
+	NL80211_ATTR_PREV_BSSID,
+
+	NL80211_ATTR_KEY,
+	NL80211_ATTR_KEYS,
+
+	NL80211_ATTR_WOW_TRIGGERS_SUPPORTED,
+	NL80211_ATTR_WOW_TRIGGERS_ENABLED,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -715,6 +755,8 @@ enum nl80211_attrs {
 #define NL80211_ATTR_CIPHER_SUITE_GROUP NL80211_ATTR_CIPHER_SUITE_GROUP
 #define NL80211_ATTR_WPA_VERSIONS NL80211_ATTR_WPA_VERSIONS
 #define NL80211_ATTR_AKM_SUITES NL80211_ATTR_AKM_SUITES
+#define NL80211_ATTR_KEY NL80211_ATTR_KEY
+#define NL80211_ATTR_KEYS NL80211_ATTR_KEYS
 
 #define NL80211_MAX_SUPP_RATES			32
 #define NL80211_MAX_SUPP_REG_RULES		32
@@ -1244,6 +1286,7 @@ enum nl80211_channel_type {
  *	in mBm (100 * dBm) (s32)
  * @NL80211_BSS_SIGNAL_UNSPEC: signal strength of the probe response/beacon
  *	in unspecified units, scaled to 0..100 (u8)
+ * @NL80211_BSS_STATUS: status, if this BSS is "used"
  * @__NL80211_BSS_AFTER_LAST: internal
  * @NL80211_BSS_MAX: highest BSS attribute
  */
@@ -1257,6 +1300,7 @@ enum nl80211_bss {
 	NL80211_BSS_INFORMATION_ELEMENTS,
 	NL80211_BSS_SIGNAL_MBM,
 	NL80211_BSS_SIGNAL_UNSPEC,
+	NL80211_BSS_STATUS,
 
 	/* keep last */
 	__NL80211_BSS_AFTER_LAST,
@@ -1264,6 +1308,15 @@ enum nl80211_bss {
 };
 
 /**
+ * enum nl80211_bss_status - BSS "status"
+ */
+enum nl80211_bss_status {
+	NL80211_BSS_STATUS_AUTHENTICATED,
+	NL80211_BSS_STATUS_ASSOCIATED,
+	NL80211_BSS_STATUS_IBSS_JOINED,
+};
+
+/**
  * enum nl80211_auth_type - AuthenticationType
  *
  * @NL80211_AUTHTYPE_OPEN_SYSTEM: Open System authentication
@@ -1315,4 +1368,54 @@ enum nl80211_wpa_versions {
 	NL80211_WPA_VERSION_2 = 1 << 1,
 };
 
+/**
+ * enum nl80211_key_attributes - key attributes
+ * @__NL80211_KEY_INVALID: invalid
+ * @NL80211_KEY_DATA: (temporal) key data; for TKIP this consists of
+ *	16 bytes encryption key followed by 8 bytes each for TX and RX MIC
+ *	keys
+ * @NL80211_KEY_IDX: key ID (u8, 0-3)
+ * @NL80211_KEY_CIPHER: key cipher suite (u32, as defined by IEEE 802.11
+ *	section 7.3.2.25.1, e.g. 0x000FAC04)
+ * @NL80211_KEY_SEQ: transmit key sequence number (IV/PN) for TKIP and
+ *	CCMP keys, each six bytes in little endian
+ * @NL80211_KEY_DEFAULT: flag indicating default key
+ * @NL80211_KEY_DEFAULT_MGMT: flag indicating default management key
+ * @__NL80211_KEY_AFTER_LAST: internal
+ * @NL80211_KEY_MAX: highest key attribute
+ */
+enum nl80211_key_attributes {
+	__NL80211_KEY_INVALID,
+	NL80211_KEY_DATA,
+	NL80211_KEY_IDX,
+	NL80211_KEY_CIPHER,
+	NL80211_KEY_SEQ,
+	NL80211_KEY_DEFAULT,
+	NL80211_KEY_DEFAULT_MGMT,
+
+	/* keep last */
+	__NL80211_KEY_AFTER_LAST,
+	NL80211_KEY_MAX = __NL80211_KEY_AFTER_LAST - 1
+};
+
+/**
+ * enum nl80211_wow_triggers - Wake-on-Wireless-LAN triggers
+ *
+ * NL80211_WOW_TRIGGER_MAGIC_PACKET: a wake signal will be sent to the
+ *     devices if a magic packet is received.
+ * NL80211_WOW_TRIGGER_BMISS: WoW signal will be sent to the device when
+ *     a beacon has been missed by the associated AP.
+ * NL80211_WOW_TRIGGER_LINK_CHANGE: a wake signal will be sent to
+ *     the device if a link change is detected on the device.
+ * NL80211_WOW_TRIGGER_USER_PATTERN: a wake signal will be sent to the
+ *     device if a user configurable pattern is received by
+ *     the device.
+ */
+enum nl80211_wow_triggers {
+	NL80211_WOW_TRIGGER_MAGIC_PACKET	= 1 << 0,
+	NL80211_WOW_TRIGGER_BMISS		= 1 << 1,
+	NL80211_WOW_TRIGGER_LINK_CHANGE		= 1 << 2,
+	NL80211_WOW_TRIGGER_PATTERN		= 1 << 3,
+};
+
 #endif /* __LINUX_NL80211_H */
diff --git a/wow.c b/wow.c
new file mode 100644
index 0000000..cec1565
--- /dev/null
+++ b/wow.c
@@ -0,0 +1,132 @@
+#include <net/if.h>
+#include <errno.h>
+#include <string.h>
+#include <stdbool.h>
+
+#include <netlink/genl/genl.h>
+#include <netlink/genl/family.h>
+#include <netlink/genl/ctrl.h>
+#include <netlink/msg.h>
+#include <netlink/attr.h>
+
+#include "nl80211.h"
+#include "iw.h"
+
+__u32 parse_wow_request(char *argv, int len)
+{
+	unsigned int i;
+	__u32 flags = 0;
+	for (i = 0; i < len; i++) {
+		switch (argv[i]) {
+			case 'g':
+			flags |= NL80211_WOW_TRIGGER_MAGIC_PACKET;
+			break;
+		case 'l':
+			flags |= NL80211_WOW_TRIGGER_LINK_CHANGE;
+			break;
+		case 'u':
+			flags |= NL80211_WOW_TRIGGER_PATTERN;
+			break;
+		case 'b':
+			flags |= NL80211_WOW_TRIGGER_BMISS;
+			break;
+		}
+	}
+	return flags;
+}
+
+
+static int handle_wow_set(struct nl80211_state *state,
+			  struct nl_cb *cb,
+			  struct nl_msg *msg,
+			  int argc, char **argv)
+{
+	__u32 triggers_requested;
+
+	if (argc < 1)
+		return 1;
+
+	triggers_requested = parse_wow_request(argv[0], strlen(argv[0]));
+
+	if (!triggers_requested) {
+		fprintf(stderr, "Usage: iw wow set [glub]\n");
+		return 2;
+	}
+
+	argc--;
+	argv++;
+
+	if (argc)
+		return 1;
+
+	NLA_PUT_U32(msg, NL80211_ATTR_WOW_TRIGGERS_ENABLED, triggers_requested);
+
+	return 0;
+ nla_put_failure:
+	return -ENOBUFS;
+}
+COMMAND(wow, set, "[glub]",
+	NL80211_CMD_SET_WOW, 0, CIB_NETDEV, handle_wow_set,
+	"Set WoW enabled triggers. The device must support the triggers being set"
+	"The possible WoW triggers are:\n"
+	"\tg: Magic packet\n"
+	"\tl: Link change\n"
+	"\tu: User pattern\n"
+	"\tb: Beacon miss\n"
+	);
+
+static int print_wow_handler(struct nl_msg *msg, void *arg)
+
+{
+#define PARSE_WOW_FLAG(nl_flag, string_value)  do { \
+		if ((triggers_supported & nl_flag)) { \
+			printf("  %c %s\n", \
+				(nl_flag & triggers_enabled) ? '+' : ' ', \
+				string_value); \
+		} \
+	} while (0)
+	struct nlattr *tb_msg[NL80211_ATTR_MAX + 1];
+	struct genlmsghdr *gnlh = nlmsg_data(nlmsg_hdr(msg));
+	__u32 triggers_supported;
+	__u32 triggers_enabled;
+
+	nla_parse(tb_msg, NL80211_ATTR_MAX, genlmsg_attrdata(gnlh, 0),
+		genlmsg_attrlen(gnlh, 0), NULL);
+
+	if (!tb_msg[NL80211_ATTR_WOW_TRIGGERS_SUPPORTED] ||
+	    !tb_msg[NL80211_ATTR_WOW_TRIGGERS_ENABLED]) {
+		printf("We got nothing useful back...\n");
+		return NL_SKIP;
+	}
+
+	triggers_supported = nla_get_u32(tb_msg[NL80211_ATTR_WOW_TRIGGERS_SUPPORTED]);
+	triggers_enabled   = nla_get_u32(tb_msg[NL80211_ATTR_WOW_TRIGGERS_ENABLED]);
+
+	if (!triggers_supported) {
+		printf("WoW not supported by device\n");
+		return NL_OK;
+	}
+
+	printf("WoW triggers:\n");
+
+	PARSE_WOW_FLAG(NL80211_WOW_TRIGGER_MAGIC_PACKET, "Magic Packet (g)");
+	PARSE_WOW_FLAG(NL80211_WOW_TRIGGER_LINK_CHANGE, "Link change (l)");
+	PARSE_WOW_FLAG(NL80211_WOW_TRIGGER_PATTERN, "User pattern (u)");
+	PARSE_WOW_FLAG(NL80211_WOW_TRIGGER_BMISS, "Beacon miss (b)");
+
+	return NL_OK;
+
+#undef PARSE_WOW_FLAG
+}
+
+static int handle_wow_get(struct nl80211_state *state,
+			  struct nl_cb *cb,
+			  struct nl_msg *msg,
+			  int argc, char **argv)
+{
+	nl_cb_set(cb, NL_CB_VALID, NL_CB_CUSTOM, print_wow_handler, NULL);
+	return 0;
+}
+COMMAND(wow, get, NULL, NL80211_CMD_GET_WOW, 0, CIB_NETDEV, handle_wow_get,
+	"Gives you the device suppported WoW triggerable events as well as the "
+	"enable devents. By default all WoW triggers are disabled.");
-- 
1.6.0.4

