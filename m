Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:49532 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbZCaECg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2009 00:02:36 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] iw: add beacon hint event parsing
Date: Tue, 31 Mar 2009 00:02:34 -0400
Message-Id: <1238472154-23370-1-git-send-email-lrodriguez@atheros.com> (sfid-20090331_060239_247557_E1F58FF8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's a screenshot:

mcgrof@pogo ~ $ iw event

mcgrof@pogo ~ $ sudo iw dev wlan0 scan trigger

beacon hint:
phy1 5200 MHz [40]:
        o active scanning enabled
        o beaconing enabled
scan finished on wlan1 (phy #1)

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 iw.c      |   75 +++++++++++++++++++++++++++++++++++++++++
 nl80211.h |  111 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 183 insertions(+), 3 deletions(-)

diff --git a/iw.c b/iw.c
index c074554..427ce38 100644
--- a/iw.c
+++ b/iw.c
@@ -12,6 +12,7 @@
 #include <sys/stat.h>
 #include <fcntl.h>
 #include <unistd.h>
+#include <stdbool.h>
                      
 #include <netlink/genl/genl.h>
 #include <netlink/genl/family.h>
@@ -330,6 +331,22 @@ static int print_event(struct nl_msg *msg, void *arg)
 	struct nlattr *tb[NL80211_ATTR_MAX + 1];
 	char ifname[100];
 	__u8 reg_type;
+	struct nlattr *tb_band[NL80211_BAND_ATTR_MAX + 1];
+	struct nlattr *tb_freq[NL80211_FREQUENCY_ATTR_MAX + 1];
+	static struct nla_policy freq_policy[NL80211_FREQUENCY_ATTR_MAX + 1] = {
+		[NL80211_FREQUENCY_ATTR_FREQ] = { .type = NLA_U32 },
+		[NL80211_FREQUENCY_ATTR_PASSIVE_SCAN] = { .type = NLA_FLAG },
+		[NL80211_FREQUENCY_ATTR_NO_IBSS] = { .type = NLA_FLAG },
+	};
+	static struct ieee80211_channel {
+		__u16 center_freq;
+		bool passive_scan;
+		bool no_ibss;
+	} chan_before_beacon,  chan_after_beacon;
+	int rem_band, rem_freq, num_bands = 0;
+	unsigned int num_freqs = 0;
+	struct nlattr *nl_freq, *nl_band;
+	__u32 wiphy_idx = 0;
 
 	nla_parse(tb, NL80211_ATTR_MAX, genlmsg_attrdata(gnlh, 0),
 		  genlmsg_attrlen(gnlh, 0), NULL);
@@ -386,6 +403,64 @@ static int print_event(struct nl_msg *msg, void *arg)
 
 		printf("\n");
 		break;
+	case NL80211_CMD_REG_BEACON_HINT:
+
+		if (!tb[NL80211_ATTR_WIPHY_BANDS])
+			break;
+
+		wiphy_idx = nla_get_u32(tb[NL80211_ATTR_WIPHY]);
+
+		memset(&chan_before_beacon, 0, sizeof(chan_before_beacon));
+		memset(&chan_after_beacon, 0, sizeof(chan_after_beacon));
+
+		nla_for_each_nested(nl_band, tb[NL80211_ATTR_WIPHY_BANDS], rem_band) {
+
+			num_bands++;
+			if (num_bands > 2)
+				continue;
+
+			nla_parse(tb_band, NL80211_BAND_ATTR_MAX, nla_data(nl_band),
+				nla_len(nl_band), NULL);
+			nla_for_each_nested(nl_freq, tb_band[NL80211_BAND_ATTR_FREQS], rem_freq) {
+				struct ieee80211_channel *chan;
+
+				chan = (num_freqs == 0) ? &chan_before_beacon : &chan_after_beacon;
+
+				num_freqs++;
+
+				if (num_freqs > 2)
+					return NL_SKIP;
+
+				nla_parse(tb_freq, NL80211_FREQUENCY_ATTR_MAX, nla_data(nl_freq),
+					  nla_len(nl_freq), freq_policy);
+				if (!tb_freq[NL80211_FREQUENCY_ATTR_FREQ])
+					continue;
+				chan->center_freq = nla_get_u32(tb_freq[NL80211_FREQUENCY_ATTR_FREQ]);
+
+				if (tb_freq[NL80211_FREQUENCY_ATTR_PASSIVE_SCAN])
+					chan->passive_scan = true;
+				if (tb_freq[NL80211_FREQUENCY_ATTR_NO_IBSS])
+					chan->no_ibss = true;
+			}
+		}
+
+		if (chan_before_beacon.center_freq != chan_after_beacon.center_freq)
+			break;
+
+		/* A beacon hint is sent _only_ if something _did_ change */
+		printf("beacon hint:\n");
+
+		printf("phy%d %d MHz [%d]:\n",
+		       wiphy_idx,
+		       chan_before_beacon.center_freq,
+		       ieee80211_frequency_to_channel(chan_before_beacon.center_freq));
+
+		if (chan_before_beacon.passive_scan && !chan_after_beacon.passive_scan)
+			printf("\to active scanning enabled\n");
+		if (chan_before_beacon.no_ibss && !chan_after_beacon.no_ibss)
+			printf("\to beaconing enabled\n");
+
+		break;
 	default:
 		printf("unknown event: %d\n", gnlh->cmd);
 		break;
diff --git a/nl80211.h b/nl80211.h
index f33aa08..946be56 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -7,7 +7,7 @@
  * Copyright 2008 Michael Wu <flamingice@sourmilk.net>
  * Copyright 2008 Luis Carlos Cobo <luisca@cozybit.com>
  * Copyright 2008 Michael Buesch <mb@bu3sch.de>
- * Copyright 2008 Luis R. Rodriguez <lrodriguez@atheros.com>
+ * Copyright 2008, 2009 Luis R. Rodriguez <lrodriguez@atheros.com>
  * Copyright 2008 Jouni Malinen <jouni.malinen@atheros.com>
  * Copyright 2008 Colin McCabe <colin@cozybit.com>
  *
@@ -142,6 +142,12 @@
  *	%NL80211_ATTR_IE. If the command succeeds, the requested data will be
  *	added to all specified management frames generated by
  *	kernel/firmware/driver.
+ *	Note: This command has been removed and it is only reserved at this
+ *	point to avoid re-using existing command number. The functionality this
+ *	command was planned for has been provided with cleaner design with the
+ *	option to specify additional IEs in NL80211_CMD_TRIGGER_SCAN,
+ *	NL80211_CMD_AUTHENTICATE, NL80211_CMD_ASSOCIATE,
+ *	NL80211_CMD_DEAUTHENTICATE, and NL80211_CMD_DISASSOCIATE.
  *
  * @NL80211_CMD_GET_SCAN: get scan results
  * @NL80211_CMD_TRIGGER_SCAN: trigger a new scan with the given parameters
@@ -160,6 +166,57 @@
  * 	set (%NL80211_ATTR_REG_TYPE), if the type of regulatory domain is
  * 	%NL80211_REG_TYPE_COUNTRY the alpha2 to which we have moved on
  * 	to (%NL80211_ATTR_REG_ALPHA2).
+ * @NL80211_CMD_REG_BEACON_HINT: indicates to userspace that an AP beacon
+ * 	has been found while world roaming thus enabling active scan or
+ * 	any mode of operation that initiates TX (beacons) on a channel
+ * 	where we would not have been able to do either before. As an example
+ * 	if you are world roaming (regulatory domain set to world or if your
+ * 	driver is using a custom world roaming regulatory domain) and while
+ * 	doing a passive scan on the 5 GHz band you find an AP there (if not
+ * 	on a DFS channel) you will now be able to actively scan for that AP
+ * 	or use AP mode on your card on that same channel. Note that this will
+ * 	never be used for channels 1-11 on the 2 GHz band as they are always
+ * 	enabled world wide. This beacon hint is only sent if your device had
+ * 	either disabled active scanning or beaconing on a channel. We send to
+ * 	userspace the wiphy on which we removed a restriction from
+ * 	(%NL80211_ATTR_WIPHY) and the channel on which this occured
+ * 	(%NL80211_ATTR_WIPHY_FREQ) before and after the beacon hint was applied.
+ * 	We send the two channels on a frequency nestered attribute
+ * 	(%NL80211_BAND_ATTR_FREQS) the first being the channel prior to the
+ * 	beacon hint processing. We only send these events if something _did_
+ * 	change to the channel.
+ *
+ * @NL80211_CMD_AUTHENTICATE: authentication request and notification.
+ *	This command is used both as a command (request to authenticate) and
+ *	as an event on the "mlme" multicast group indicating completion of the
+ *	authentication process.
+ *	When used as a command, %NL80211_ATTR_IFINDEX is used to identify the
+ *	interface. %NL80211_ATTR_MAC is used to specify PeerSTAAddress (and
+ *	BSSID in case of station mode). %NL80211_ATTR_SSID is used to specify
+ *	the SSID (mainly for association, but is included in authentication
+ *	request, too, to help BSS selection. %NL80211_ATTR_WIPHY_FREQ is used
+ *	to specify the frequence of the channel in MHz. %NL80211_ATTR_AUTH_TYPE
+ *	is used to specify the authentication type. %NL80211_ATTR_IE is used to
+ *	define IEs (VendorSpecificInfo, but also including RSN IE and FT IEs)
+ *	to be added to the frame.
+ *	When used as an event, this reports reception of an Authentication
+ *	frame in station and IBSS modes when the local MLME processed the
+ *	frame, i.e., it was for the local STA and was received in correct
+ *	state. This is similar to MLME-AUTHENTICATE.confirm primitive in the
+ *	MLME SAP interface (kernel providing MLME, userspace SME). The
+ *	included NL80211_ATTR_FRAME attribute contains the management frame
+ *	(including both the header and frame body, but not FCS).
+ * @NL80211_CMD_ASSOCIATE: association request and notification; like
+ *	NL80211_CMD_AUTHENTICATE but for Association and Reassociation
+ *	(similar to MLME-ASSOCIATE.request, MLME-REASSOCIATE.request,
+ *	MLME-ASSOCIATE.confirm or MLME-REASSOCIATE.confirm primitives).
+ * @NL80211_CMD_DEAUTHENTICATE: deauthentication request and notification; like
+ *	NL80211_CMD_AUTHENTICATE but for Deauthentication frames (similar to
+ *	MLME-DEAUTHENTICATION.request and MLME-DEAUTHENTICATE.indication
+ *	primitives).
+ * @NL80211_CMD_DISASSOCIATE: disassociation request and notification; like
+ *	NL80211_CMD_AUTHENTICATE but for Disassociation frames (similar to
+ *	MLME-DISASSOCIATE.request and MLME-DISASSOCIATE.indication primitives).
  *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
@@ -206,7 +263,7 @@ enum nl80211_commands {
 	NL80211_CMD_GET_MESH_PARAMS,
 	NL80211_CMD_SET_MESH_PARAMS,
 
-	NL80211_CMD_SET_MGMT_EXTRA_IE,
+	NL80211_CMD_SET_MGMT_EXTRA_IE /* reserved; not used */,
 
 	NL80211_CMD_GET_REG,
 
@@ -216,6 +273,12 @@ enum nl80211_commands {
 	NL80211_CMD_SCAN_ABORTED,
 
 	NL80211_CMD_REG_CHANGE,
+	NL80211_CMD_REG_BEACON_HINT,
+
+	NL80211_CMD_AUTHENTICATE,
+	NL80211_CMD_ASSOCIATE,
+	NL80211_CMD_DEAUTHENTICATE,
+	NL80211_CMD_DISASSOCIATE,
 
 	/* add new commands above here */
 
@@ -230,8 +293,12 @@ enum nl80211_commands {
  */
 #define NL80211_CMD_SET_BSS NL80211_CMD_SET_BSS
 #define NL80211_CMD_SET_MGMT_EXTRA_IE NL80211_CMD_SET_MGMT_EXTRA_IE
-
 #define NL80211_CMD_REG_CHANGE NL80211_CMD_REG_CHANGE
+#define NL80211_CMD_AUTHENTICATE NL80211_CMD_AUTHENTICATE
+#define NL80211_CMD_ASSOCIATE NL80211_CMD_ASSOCIATE
+#define NL80211_CMD_DEAUTHENTICATE NL80211_CMD_DEAUTHENTICATE
+#define NL80211_CMD_DISASSOCIATE NL80211_CMD_DISASSOCIATE
+#define NL80211_CMD_REG_BEACON_HINT NL80211_CMD_REG_BEACON_HINT
 
 /**
  * enum nl80211_attrs - nl80211 netlink attributes
@@ -349,6 +416,19 @@ enum nl80211_commands {
  * @NL80211_ATTR_REG_TYPE: indicates the type of the regulatory domain currently
  * 	set. This can be one of the nl80211_reg_type (%NL80211_REGDOM_TYPE_*)
  *
+ * @NL80211_ATTR_SUPPORTED_COMMANDS: wiphy attribute that specifies
+ *	an array of command numbers (i.e. a mapping index to command number)
+ *	that the driver for the given wiphy supports.
+ *
+ * @NL80211_ATTR_FRAME: frame data (binary attribute), including frame header
+ *	and body, but not FCS; used, e.g., with NL80211_CMD_AUTHENTICATE and
+ *	NL80211_CMD_ASSOCIATE events
+ * @NL80211_ATTR_SSID: SSID (binary attribute, 0..32 octets)
+ * @NL80211_ATTR_AUTH_TYPE: AuthenticationType, see &enum nl80211_auth_type,
+ *	represented as a u32
+ * @NL80211_ATTR_REASON_CODE: ReasonCode for %NL80211_CMD_DEAUTHENTICATE and
+ *	%NL80211_CMD_DISASSOCIATE, u16
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -426,6 +506,13 @@ enum nl80211_attrs {
 	NL80211_ATTR_REG_INITIATOR,
 	NL80211_ATTR_REG_TYPE,
 
+	NL80211_ATTR_SUPPORTED_COMMANDS,
+
+	NL80211_ATTR_FRAME,
+	NL80211_ATTR_SSID,
+	NL80211_ATTR_AUTH_TYPE,
+	NL80211_ATTR_REASON_CODE,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -445,6 +532,10 @@ enum nl80211_attrs {
 #define NL80211_ATTR_IE NL80211_ATTR_IE
 #define NL80211_ATTR_REG_INITIATOR NL80211_ATTR_REG_INITIATOR
 #define NL80211_ATTR_REG_TYPE NL80211_ATTR_REG_TYPE
+#define NL80211_ATTR_FRAME NL80211_ATTR_FRAME
+#define NL80211_ATTR_SSID NL80211_ATTR_SSID
+#define NL80211_ATTR_AUTH_TYPE NL80211_ATTR_AUTH_TYPE
+#define NL80211_ATTR_REASON_CODE NL80211_ATTR_REASON_CODE
 
 #define NL80211_MAX_SUPP_RATES			32
 #define NL80211_MAX_SUPP_REG_RULES		32
@@ -978,4 +1069,18 @@ enum nl80211_bss {
 	NL80211_BSS_MAX = __NL80211_BSS_AFTER_LAST - 1
 };
 
+/**
+ * enum nl80211_auth_type - AuthenticationType
+ *
+ * @NL80211_AUTHTYPE_OPEN_SYSTEM: Open System authentication
+ * @NL80211_AUTHTYPE_SHARED_KEY: Shared Key authentication (WEP only)
+ * @NL80211_AUTHTYPE_FT: Fast BSS Transition (IEEE 802.11r)
+ * @NL80211_AUTHTYPE_NETWORK_EAP: Network EAP (some Cisco APs and mainly LEAP)
+ */
+enum nl80211_auth_type {
+	NL80211_AUTHTYPE_OPEN_SYSTEM,
+	NL80211_AUTHTYPE_SHARED_KEY,
+	NL80211_AUTHTYPE_FT,
+	NL80211_AUTHTYPE_NETWORK_EAP,
+};
 #endif /* __LINUX_NL80211_H */
-- 
1.6.0.6

