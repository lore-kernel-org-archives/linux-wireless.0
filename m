Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:34369 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434AbZCJC2w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2009 22:28:52 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 3/3] iw: add regulatory events notification parsing
Date: Mon,  9 Mar 2009 22:28:50 -0400
Message-Id: <1236652130-29971-4-git-send-email-lrodriguez@atheros.com> (sfid-20090310_032859_969402_FDE01D2A)
In-Reply-To: <1236652130-29971-1-git-send-email-lrodriguez@atheros.com>
References: <1236652130-29971-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 iw.c      |   47 ++++++++++++++++++++++++++++++++++++++++++
 iw.h      |    2 +
 nl80211.h |   67 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 reg.c     |   16 ++++++++++++++
 4 files changed, 132 insertions(+), 0 deletions(-)

diff --git a/iw.c b/iw.c
index 623b16f..f1d912b 100644
--- a/iw.c
+++ b/iw.c
@@ -303,6 +303,7 @@ static int print_event(struct nl_msg *msg, void *arg)
 	struct genlmsghdr *gnlh = nlmsg_data(nlmsg_hdr(msg));
 	struct nlattr *tb[NL80211_ATTR_MAX + 1];
 	char ifname[100];
+	__u8 reg_type;
 
 	nla_parse(tb, NL80211_ATTR_MAX, genlmsg_attrdata(gnlh, 0),
 		  genlmsg_attrlen(gnlh, 0), NULL);
@@ -323,6 +324,42 @@ static int print_event(struct nl_msg *msg, void *arg)
 		printf("scan aborted on %s (phy #%d)\n",
 		       ifname, nla_get_u32(tb[NL80211_ATTR_WIPHY]));
 		break;
+	case NL80211_CMD_REG_CHANGE:
+
+		printf("regulatory domain change: ");
+
+		reg_type = nla_get_u8(tb[NL80211_ATTR_REG_TYPE]);
+
+		switch (reg_type) {
+		case NL80211_REGDOM_TYPE_COUNTRY:
+			printf("set to %s by %s request",
+			       nla_get_string(tb[NL80211_ATTR_REG_ALPHA2]),
+			       reg_initiator_to_string(nla_get_u8(tb[NL80211_ATTR_REG_INITIATOR])));
+			if (tb[NL80211_ATTR_WIPHY])
+				printf(" on phy%d", nla_get_u32(tb[NL80211_ATTR_WIPHY]));
+			break;
+		case NL80211_REGDOM_TYPE_WORLD:
+			printf("set to world roaming by %s request",
+			       reg_initiator_to_string(nla_get_u8(tb[NL80211_ATTR_REG_INITIATOR])));
+			break;
+		case NL80211_REGDOM_TYPE_CUSTOM_WORLD:
+			printf("custom world roaming rules in place on phy%d by %s request",
+			       nla_get_u32(tb[NL80211_ATTR_WIPHY]),
+			       reg_initiator_to_string(nla_get_u32(tb[NL80211_ATTR_REG_INITIATOR])));
+			break;
+		case NL80211_REGDOM_TYPE_INTERSECTION:
+			printf("intersection used due to a request made by %s",
+			       reg_initiator_to_string(nla_get_u32(tb[NL80211_ATTR_REG_INITIATOR])));
+			if (tb[NL80211_ATTR_WIPHY])
+				printf(" on phy%d", nla_get_u32(tb[NL80211_ATTR_WIPHY]));
+			break;
+		default:
+			printf("unknown source (upgrade this utility)");
+			break;
+		}
+
+		printf("\n");
+		break;
 	default:
 		printf("unknown event: %d\n", gnlh->cmd);
 		break;
@@ -342,6 +379,7 @@ static int listen_events(struct nl80211_state *state,
 		return -ENOMEM;
 	}
 
+	/* Configuration multicast group */
 	mcid = nl_get_multicast_id(state->nl_sock, "nl80211", "config");
 	if (mcid < 0)
 		return mcid;
@@ -350,6 +388,7 @@ static int listen_events(struct nl80211_state *state,
 	if (ret)
 		return ret;
 
+	/* Scan multicast group */
 	mcid = nl_get_multicast_id(state->nl_sock, "nl80211", "scan");
 	if (mcid >= 0) {
 		ret = nl_socket_add_membership(state->nl_sock, mcid);
@@ -357,6 +396,14 @@ static int listen_events(struct nl80211_state *state,
 			return ret;
 	}
 
+	/* Regulatory multicast group */
+	mcid = nl_get_multicast_id(state->nl_sock, "nl80211", "regulatory");
+	if (mcid >= 0) {
+		ret = nl_socket_add_membership(state->nl_sock, mcid);
+		if (ret)
+			return ret;
+	}
+
 	/* no sequence checking for multicast messages */
 	nl_cb_set(cb, NL_CB_SEQ_CHECK, NL_CB_CUSTOM, no_seq_check, NULL);
 	nl_cb_set(cb, NL_CB_VALID, NL_CB_CUSTOM, print_event, NULL);
diff --git a/iw.h b/iw.h
index 7c2ab02..be35bd7 100644
--- a/iw.h
+++ b/iw.h
@@ -69,4 +69,6 @@ int ieee80211_frequency_to_channel(int freq);
 
 int nl_get_multicast_id(struct nl_sock *sock, const char *family, const char *group);
 
+char *reg_initiator_to_string(__u8 initiator);
+
 #endif /* __IW_H */
diff --git a/nl80211.h b/nl80211.h
index 55565a4..9118460 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -150,6 +150,17 @@
  * @NL80211_CMD_SCAN_ABORTED: scan was aborted, for unspecified reasons,
  *	partial scan results may be available
  *
+ * @NL80211_CMD_REG_CHANGE: indicates to userspace the regulatory domain
+ * 	has been changed and provides details of the request information
+ * 	that caused the change such as who initiated the regulatory request
+ * 	(%NL80211_ATTR_REG_INITIATOR), the wiphy_idx
+ * 	(%NL80211_ATTR_REG_ALPHA2) on which the request was made from if
+ * 	the initiator was %NL80211_REGDOM_SET_BY_COUNTRY_IE or
+ * 	%NL80211_REGDOM_SET_BY_DRIVER, the type of regulatory domain
+ * 	set (%NL80211_ATTR_REG_TYPE), if the type of regulatory domain is
+ * 	%NL80211_REG_TYPE_COUNTRY the alpha2 to which we have moved on
+ * 	to (%NL80211_ATTR_REG_ALPHA2).
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -204,6 +215,8 @@ enum nl80211_commands {
 	NL80211_CMD_NEW_SCAN_RESULTS,
 	NL80211_CMD_SCAN_ABORTED,
 
+	NL80211_CMD_REG_CHANGE,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -218,6 +231,8 @@ enum nl80211_commands {
 #define NL80211_CMD_SET_BSS NL80211_CMD_SET_BSS
 #define NL80211_CMD_SET_MGMT_EXTRA_IE NL80211_CMD_SET_MGMT_EXTRA_IE
 
+#define NL80211_CMD_REG_CHANGE NL80211_CMD_REG_CHANGE
+
 /**
  * enum nl80211_attrs - nl80211 netlink attributes
  *
@@ -329,6 +344,11 @@ enum nl80211_commands {
  *	messages carried the same generation number)
  * @NL80211_ATTR_BSS: scan result BSS
  *
+ * @NL80211_ATTR_REG_INITIATOR: indicates who requested the regulatory domain
+ * 	currently in effect. This could be any of the %NL80211_REGDOM_SET_BY_*
+ * @NL80211_ATTR_REG_TYPE: indicates the type of the regulatory domain currently
+ * 	set. This can be one of the nl80211_reg_type (%NL80211_REGDOM_TYPE_*)
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -403,6 +423,9 @@ enum nl80211_attrs {
 	NL80211_ATTR_SCAN_GENERATION,
 	NL80211_ATTR_BSS,
 
+	NL80211_ATTR_REG_INITIATOR,
+	NL80211_ATTR_REG_TYPE,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -420,6 +443,8 @@ enum nl80211_attrs {
 #define NL80211_ATTR_WIPHY_CHANNEL_TYPE NL80211_ATTR_WIPHY_CHANNEL_TYPE
 #define NL80211_ATTR_MGMT_SUBTYPE NL80211_ATTR_MGMT_SUBTYPE
 #define NL80211_ATTR_IE NL80211_ATTR_IE
+#define NL80211_ATTR_REG_INITIATOR NL80211_ATTR_REG_INITIATOR
+#define NL80211_ATTR_REG_TYPE NL80211_ATTR_REG_TYPE
 
 #define NL80211_MAX_SUPP_RATES			32
 #define NL80211_MAX_SUPP_REG_RULES		32
@@ -676,6 +701,48 @@ enum nl80211_bitrate_attr {
 };
 
 /**
+ * enum nl80211_initiator - Indicates the initiator of a reg domain request
+ * @NL80211_REGDOM_SET_BY_CORE: Core queried CRDA for a dynamic world
+ * 	regulatory domain.
+ * @NL80211_REGDOM_SET_BY_USER: User asked the wireless core to set the
+ * 	regulatory domain.
+ * @NL80211_REGDOM_SET_BY_DRIVER: a wireless drivers has hinted to the
+ * 	wireless core it thinks its knows the regulatory domain we should be in.
+ * @NL80211_REGDOM_SET_BY_COUNTRY_IE: the wireless core has received an
+ * 	802.11 country information element with regulatory information it
+ * 	thinks we should consider.
+ */
+enum nl80211_reg_initiator {
+	NL80211_REGDOM_SET_BY_CORE,
+	NL80211_REGDOM_SET_BY_USER,
+	NL80211_REGDOM_SET_BY_DRIVER,
+	NL80211_REGDOM_SET_BY_COUNTRY_IE,
+};
+
+/**
+ * enum nl80211_reg_type - specifies the type of regulatory domain
+ * @NL80211_REGDOM_TYPE_COUNTRY: the regulatory domain set is one that pertains
+ *	to a specific country. When this is set you can count on the
+ *	ISO / IEC 3166 alpha2 country code being valid.
+ * @NL80211_REGDOM_TYPE_WORLD: the regulatory set domain is the world regulatory
+ * 	domain.
+ * @NL80211_REGDOM_TYPE_CUSTOM_WORLD: the regulatory domain set is a custom
+ * 	driver specific world regulatory domain. These do not apply system-wide
+ * 	and are only applicable to the individual devices which have requested
+ * 	them to be applied.
+ * @NL80211_REGDOM_TYPE_INTERSECTION: the regulatory domain set is the product
+ *	of an intersection between two regulatory domains -- the previously
+ *	set regulatory domain on the system and the last accepted regulatory
+ *	domain request to be processed.
+ */
+enum nl80211_reg_type {
+	NL80211_REGDOM_TYPE_COUNTRY,
+	NL80211_REGDOM_TYPE_WORLD,
+	NL80211_REGDOM_TYPE_CUSTOM_WORLD,
+	NL80211_REGDOM_TYPE_INTERSECTION,
+};
+
+/**
  * enum nl80211_reg_rule_attr - regulatory rule attributes
  * @NL80211_ATTR_REG_RULE_FLAGS: a set of flags which specify additional
  * 	considerations for a given frequency range. These are the
diff --git a/reg.c b/reg.c
index 74ae77f..625d695 100644
--- a/reg.c
+++ b/reg.c
@@ -41,6 +41,22 @@ static bool is_world_regdom(char *alpha2)
 	return false;
 }
 
+char *reg_initiator_to_string(__u8 initiator)
+{
+	switch (initiator) {
+	case NL80211_REGDOM_SET_BY_CORE:
+		return "the wireless core upon initialization";
+	case NL80211_REGDOM_SET_BY_USER:
+		return "a user";
+	case NL80211_REGDOM_SET_BY_DRIVER:
+		return "a driver";
+	case NL80211_REGDOM_SET_BY_COUNTRY_IE:
+		return "a country IE";
+	default:
+		return "BUG";
+	}
+}
+
 static int handle_reg_set(struct nl_cb *cb,
 			  struct nl_msg *msg,
 			  int argc, char **argv)
-- 
1.6.0.6

