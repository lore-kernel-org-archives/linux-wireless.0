Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:36147 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459Ab1KEMZr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Nov 2011 08:25:47 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [RFC] iw: Support ht-capability overrides mask.
Date: Sat,  5 Nov 2011 05:25:42 -0700
Message-Id: <1320495942-8993-1-git-send-email-greearb@candelatech.com> (sfid-20111105_132623_134674_D27C3AC8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Let user know which capabilities are supported.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 b55b282... aeec06f... M	info.c
:100644 100644 8049bf7... e732da8... M	nl80211.h
 info.c    |   28 ++++++++++++++++++++++++++++
 nl80211.h |   54 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 82 insertions(+), 0 deletions(-)

diff --git a/info.c b/info.c
index b55b282..aeec06f 100644
--- a/info.c
+++ b/info.c
@@ -400,6 +400,34 @@ broken_combination:
 	if (tb_msg[NL80211_ATTR_SUPPORT_AP_UAPSD])
 		printf("\tDevice supports AP-side u-APSD.\n");
 
+	if (tb_msg[NL80211_ATTR_HT_CAPABILITY_MASK]) {
+		struct ieee80211_ht_cap *cm;
+		printf("\tHT Capabilities over-rides:\n");
+		if (nla_len(tb_msg[NL80211_ATTR_HT_CAPABILITY_MASK]) >=
+		    sizeof(*cm)) {
+			cm = nla_data(tb_msg[NL80211_ATTR_HT_CAPABILITY_MASK]);
+			printf("\t\t* MCS: %02hx %02hx %02hx %02hx %02hx %02hx"
+			       " %02hx %02hx %02hx %02hx\n",
+			       cm->mcs.rx_mask[0], cm->mcs.rx_mask[1],
+			       cm->mcs.rx_mask[2], cm->mcs.rx_mask[3],
+			       cm->mcs.rx_mask[4], cm->mcs.rx_mask[5],
+			       cm->mcs.rx_mask[6], cm->mcs.rx_mask[7],
+			       cm->mcs.rx_mask[8], cm->mcs.rx_mask[9]);
+			printf("\t\t* MAX-AMSDU:     %s\n"
+			       "\t\t* AMPDU-Factor:  %s\n"
+			       "\t\t* AMPDU-Density: %s\n",
+			       cm->cap_info & IEEE80211_HT_CAP_MAX_AMSDU ? "Yes" : "No",
+			       cm->ampdu_params_info & IEEE80211_HT_AMPDU_PARM_FACTOR ? "Yes" : "No",
+			       cm->ampdu_params_info & IEEE80211_HT_AMPDU_PARM_DENSITY ? "Yes" : "No");
+		} else {
+			printf("\tERROR:  capabilities mask is too short, expected: %d"
+			       ", received: %d\n",
+			       sizeof(*cm), nla_len(tb_msg[NL80211_ATTR_HT_CAPABILITY_MASK]));
+		}
+	} else {
+		printf("\tHT Capabilities over-rides are NOT supported\n");
+	}
+
 	return NL_SKIP;
 }
 
diff --git a/nl80211.h b/nl80211.h
index 8049bf7..e732da8 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -1109,6 +1109,12 @@ enum nl80211_commands {
  *	%NL80211_CMD_TDLS_MGMT. Otherwise %NL80211_CMD_TDLS_OPER should be
  *	used for asking the driver to perform a TDLS operation.
  *
+ * @NL80211_ATTR_DISABLE_HT:  Force HT capable interfaces to disable
+ *      this feature.
+ * @NL80211_ATTR_DISABLE_HT40:  Disable HT-40 even if AP and hardware
+ *      support it.
+ * @NL80211_ATTR_HT_CAPABILITY_MASK: Specify which bits of the HT_CAPs
+ *      to pay attention to.
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1337,6 +1343,10 @@ enum nl80211_attrs {
 	NL80211_ATTR_TDLS_SUPPORT,
 	NL80211_ATTR_TDLS_EXTERNAL_SETUP,
 
+	NL80211_ATTR_DISABLE_HT,
+	NL80211_ATTR_DISABLE_HT40,
+	NL80211_ATTR_HT_CAPABILITY_MASK,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -1421,6 +1431,50 @@ enum nl80211_iftype {
 	NL80211_IFTYPE_MAX = NUM_NL80211_IFTYPES - 1
 };
 
+/* 802.11n HT capability AMPDU settings (for ampdu_params_info) */
+#define IEEE80211_HT_AMPDU_PARM_FACTOR          0x03
+#define IEEE80211_HT_AMPDU_PARM_DENSITY         0x1C
+
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
+
 /**
  * enum nl80211_sta_flags - station flags
  *
-- 
1.7.3.4

