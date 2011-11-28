Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:33984 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956Ab1K1Skf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Nov 2011 13:40:35 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH v3] iw: Support ht-capability overrides mask.
Date: Mon, 28 Nov 2011 10:40:22 -0800
Message-Id: <1322505622-13446-1-git-send-email-greearb@candelatech.com> (sfid-20111128_194043_702798_6A11361F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Let user know which capabilities are supported.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

v3:  Don't make modifications to nl80211.h..put new code
  in iw.h instead.

:100644 100644 b55b282... 040937c... M	info.c
:100644 100644 a50d447... 441c724... M	iw.h
:100644 100644 e03ec2c... c452a64... M	util.c
 info.c |   33 +++++++++++++++++++++++++++++++++
 iw.h   |   47 ++++++++++++++++++++++++++++++++++++++++++++++-
 util.c |    8 ++++++++
 3 files changed, 87 insertions(+), 1 deletions(-)

diff --git a/info.c b/info.c
index b55b282..040937c 100644
--- a/info.c
+++ b/info.c
@@ -400,6 +400,39 @@ broken_combination:
 	if (tb_msg[NL80211_ATTR_SUPPORT_AP_UAPSD])
 		printf("\tDevice supports AP-side u-APSD.\n");
 
+	if (tb_msg[NL80211_ATTR_HT_CAPABILITY_MASK]) {
+		struct ieee80211_ht_cap *cm;
+		printf("\tHT Capabilities over-rides:\n");
+		if (nla_len(tb_msg[NL80211_ATTR_HT_CAPABILITY_MASK]) >=
+		    sizeof(*cm)) {
+			cm = nla_data(tb_msg[NL80211_ATTR_HT_CAPABILITY_MASK]);
+			printf("\t\t * MCS: %02hx %02hx %02hx %02hx %02hx %02hx"
+			       " %02hx %02hx %02hx %02hx\n",
+			       cm->mcs.rx_mask[0], cm->mcs.rx_mask[1],
+			       cm->mcs.rx_mask[2], cm->mcs.rx_mask[3],
+			       cm->mcs.rx_mask[4], cm->mcs.rx_mask[5],
+			       cm->mcs.rx_mask[6], cm->mcs.rx_mask[7],
+			       cm->mcs.rx_mask[8], cm->mcs.rx_mask[9]);
+			printf("\t\t * MAX-AMSDU:     %s\n"
+			       "\t\t * WIDTH-20-40:   %s\n"
+			       "\t\t * SGI-40:        %s\n"
+			       "\t\t * AMPDU-Factor:  %s\n"
+			       "\t\t * AMPDU-Density: %s\n",
+			       cm->cap_info & cpu_to_le16(IEEE80211_HT_CAP_MAX_AMSDU) ? "Yes" : "No",
+			       cm->cap_info & cpu_to_le16(IEEE80211_HT_CAP_SUP_WIDTH_20_40) ? "Yes" : "No",
+			       cm->cap_info & cpu_to_le16(IEEE80211_HT_CAP_SGI_40) ? "Yes" : "No",
+			       cm->ampdu_params_info & IEEE80211_HT_AMPDU_PARM_FACTOR ? "Yes" : "No",
+			       cm->ampdu_params_info & IEEE80211_HT_AMPDU_PARM_DENSITY ? "Yes" : "No");
+		} else {
+			printf("\tERROR:  capabilities mask is too short, expected: %d"
+			       ", received: %d\n",
+			       (int)(sizeof(*cm)),
+			       (int)(nla_len(tb_msg[NL80211_ATTR_HT_CAPABILITY_MASK])));
+		}
+	} else {
+		printf("\tHT Capabilities over-rides are NOT supported.\n");
+	}
+
 	return NL_SKIP;
 }
 
diff --git a/iw.h b/iw.h
index a50d447..441c724 100644
--- a/iw.h
+++ b/iw.h
@@ -125,7 +125,52 @@ __u32 __do_listen_events(struct nl80211_state *state,
 			 const int n_waits, const __u32 *waits,
 			 struct print_event_args *args);
 
-
+/* 802.11n HT capability AMPDU settings (for ampdu_params_info) */
+#define IEEE80211_HT_AMPDU_PARM_FACTOR          0x03
+#define IEEE80211_HT_AMPDU_PARM_DENSITY         0x1C
+
+#define IEEE80211_HT_CAP_SUP_WIDTH_20_40        0x0002
+#define IEEE80211_HT_CAP_SGI_40                 0x0040
+#define IEEE80211_HT_CAP_MAX_AMSDU              0x0800
+
+#define IEEE80211_HT_MCS_MASK_LEN               10
+
+/**
+ * struct ieee80211_mcs_info - MCS information
+ * @rx_mask: RX mask
+ * @rx_highest: highest supported RX rate. If set represents
+ *      the highest supported RX data rate in units of 1 Mbps.
+ *      If this field is 0 this value should not be used to
+ *      consider the highest RX data rate supported.
+ * @tx_params: TX parameters
+ */
+struct ieee80211_mcs_info {
+	__u8 rx_mask[IEEE80211_HT_MCS_MASK_LEN];
+	__u16 rx_highest;
+	__u8 tx_params;
+	__u8 reserved[3];
+} __attribute__ ((packed));
+
+
+/**
+ * struct ieee80211_ht_cap - HT capabilities
+ *
+ * This structure is the "HT capabilities element" as
+ * described in 802.11n D5.0 7.3.2.57
+ */
+struct ieee80211_ht_cap {
+	__u16 cap_info;
+	__u8 ampdu_params_info;
+
+	/* 16 bytes MCS information */
+	struct ieee80211_mcs_info mcs;
+
+	__u16 extended_ht_cap_info;
+	__u32 tx_BF_cap_info;
+	__u8 antenna_selection_info;
+} __attribute__ ((packed));
+
+unsigned short cpu_to_le16(unsigned short v);
 int mac_addr_a2n(unsigned char *mac_addr, char *arg);
 void mac_addr_n2a(char *mac_addr, unsigned char *arg);
 int parse_hex_mask(char *hexmask, unsigned char **result, size_t *result_len,
diff --git a/util.c b/util.c
index e03ec2c..c452a64 100644
--- a/util.c
+++ b/util.c
@@ -5,6 +5,14 @@
 #include "iw.h"
 #include "nl80211.h"
 
+unsigned short cpu_to_le16(unsigned short v)
+{
+	unsigned short nv = htons(v);
+	/* and now swap this to get litte-endian */
+	return ((nv & 0xff) << 8) | ((nv & 0xff00) >> 8);
+}
+
+
 void mac_addr_n2a(char *mac_addr, unsigned char *arg)
 {
 	int i, l;
-- 
1.7.3.4

