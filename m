Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:43487 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754010AbeBPINk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Feb 2018 03:13:40 -0500
From: Maya Erez <merez@codeaurora.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Lior David <liord@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, Maya Erez <merez@codeaurora.org>
Subject: [PATCH 2/8] wil6210: support concurrency record in FW file
Date: Fri, 16 Feb 2018 10:04:37 +0200
Message-Id: <1518768283-2318-3-git-send-email-merez@codeaurora.org> (sfid-20180216_091348_169894_D6116FE4)
In-Reply-To: <1518768283-2318-1-git-send-email-merez@codeaurora.org>
References: <1518768283-2318-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lior David <liord@codeaurora.org>

New FW which supports multiple virtual interfaces, reports
its allowed interface combinations using a special comment
record in the FW file. The format of the interface combinations
is similar to the kernel wiphy->iface_combinations.
When parsing FW file during module initialization, also parse
and validate the concurrency record, and initialize
wiphy->n_iface_combinations and wiphy->iface_combinations
accordingly.

Signed-off-by: Lior David <liord@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 69 +++++++++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/fw.h       | 38 +++++++++++++++-
 drivers/net/wireless/ath/wil6210/fw_inc.c   | 52 ++++++++++++++++++++--
 drivers/net/wireless/ath/wil6210/wil6210.h  |  4 ++
 4 files changed, 158 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 4611d8b..2977f35 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -20,6 +20,7 @@
 #include <net/netlink.h>
 #include "wil6210.h"
 #include "wmi.h"
+#include "fw.h"
 
 #define WIL_MAX_ROC_DURATION_MS 5000
 
@@ -1895,6 +1896,71 @@ static void wil_wiphy_init(struct wiphy *wiphy)
 #endif
 }
 
+int wil_cfg80211_iface_combinations_from_fw(
+	struct wil6210_priv *wil, const struct wil_fw_record_concurrency *conc)
+{
+	struct wiphy *wiphy = wil_to_wiphy(wil);
+	u32 total_limits = 0;
+	u16 n_combos;
+	const struct wil_fw_concurrency_combo *combo;
+	const struct wil_fw_concurrency_limit *limit;
+	struct ieee80211_iface_combination *iface_combinations;
+	struct ieee80211_iface_limit *iface_limit;
+	int i, j;
+
+	if (wiphy->iface_combinations) {
+		wil_dbg_misc(wil, "iface_combinations already set, skipping\n");
+		return 0;
+	}
+
+	combo = conc->combos;
+	n_combos = le16_to_cpu(conc->n_combos);
+	for (i = 0; i < n_combos; i++) {
+		total_limits += combo->n_limits;
+		limit = combo->limits + combo->n_limits;
+		combo = (struct wil_fw_concurrency_combo *)limit;
+	}
+
+	iface_combinations =
+		kzalloc(n_combos * sizeof(struct ieee80211_iface_combination) +
+			total_limits * sizeof(struct ieee80211_iface_limit),
+			GFP_KERNEL);
+	if (!iface_combinations)
+		return -ENOMEM;
+	iface_limit = (struct ieee80211_iface_limit *)(iface_combinations +
+						       n_combos);
+	combo = conc->combos;
+	for (i = 0; i < n_combos; i++) {
+		iface_combinations[i].max_interfaces = combo->max_interfaces;
+		iface_combinations[i].num_different_channels =
+			combo->n_diff_channels;
+		iface_combinations[i].beacon_int_infra_match =
+			combo->same_bi;
+		iface_combinations[i].n_limits = combo->n_limits;
+		wil_dbg_misc(wil,
+			     "iface_combination %d: max_if %d, num_ch %d, bi_match %d\n",
+			     i, iface_combinations[i].max_interfaces,
+			     iface_combinations[i].num_different_channels,
+			     iface_combinations[i].beacon_int_infra_match);
+		limit = combo->limits;
+		for (j = 0; j < combo->n_limits; j++) {
+			iface_limit[j].max = le16_to_cpu(limit[j].max);
+			iface_limit[j].types = le16_to_cpu(limit[j].types);
+			wil_dbg_misc(wil,
+				     "limit %d: max %d types 0x%x\n", j,
+				     iface_limit[j].max, iface_limit[j].types);
+		}
+		iface_combinations[i].limits = iface_limit;
+		iface_limit += combo->n_limits;
+		limit += combo->n_limits;
+		combo = (struct wil_fw_concurrency_combo *)limit;
+	}
+
+	wiphy->n_iface_combinations = n_combos;
+	wiphy->iface_combinations = iface_combinations;
+	return 0;
+}
+
 struct wil6210_priv *wil_cfg80211_init(struct device *dev)
 {
 	struct wiphy *wiphy;
@@ -1933,6 +1999,9 @@ void wil_cfg80211_deinit(struct wil6210_priv *wil)
 	if (!wiphy)
 		return;
 
+	kfree(wiphy->iface_combinations);
+	wiphy->iface_combinations = NULL;
+
 	wiphy_free(wiphy);
 	/* do not access wil6210_priv after returning from here */
 }
diff --git a/drivers/net/wireless/ath/wil6210/fw.h b/drivers/net/wireless/ath/wil6210/fw.h
index 2c7b24f..3e7a280 100644
--- a/drivers/net/wireless/ath/wil6210/fw.h
+++ b/drivers/net/wireless/ath/wil6210/fw.h
@@ -14,6 +14,8 @@
  * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
+#ifndef __WIL_FW_H__
+#define __WIL_FW_H__
 
 #define WIL_FW_SIGNATURE (0x36323130) /* '0126' */
 #define WIL_FW_FMT_VERSION (1) /* format version driver supports */
@@ -71,7 +73,39 @@ struct wil_fw_record_capabilities { /* type == wil_fw_type_comment */
 	struct wil_fw_record_comment_hdr hdr;
 	/* capabilities (variable size), see enum wmi_fw_capability */
 	u8 capabilities[0];
-};
+} __packed;
+
+/* FW VIF concurrency encoded inside a comment record
+ * Format is similar to wiphy->iface_combinations
+ */
+#define WIL_FW_CONCURRENCY_MAGIC (0xfedccdef)
+#define WIL_FW_CONCURRENCY_REC_VER	1
+struct wil_fw_concurrency_limit {
+	__le16 max; /* maximum number of interfaces of these types */
+	__le16 types; /* interface types (bit mask of enum nl80211_iftype) */
+} __packed;
+
+struct wil_fw_concurrency_combo {
+	u8 n_limits; /* number of wil_fw_concurrency_limit entries */
+	u8 max_interfaces; /* max number of concurrent interfaces allowed */
+	u8 n_diff_channels; /* total number of different channels allowed */
+	u8 same_bi; /* for APs, 1 if all APs must have same BI */
+	/* keep last - concurrency limits, variable size by n_limits */
+	struct wil_fw_concurrency_limit limits[0];
+} __packed;
+
+struct wil_fw_record_concurrency { /* type == wil_fw_type_comment */
+	/* identifies concurrency record */
+	__le32 magic;
+	/* structure version, currently always 1 */
+	u8 version;
+	/* maximum number of supported MIDs _in addition_ to MID 0 */
+	u8 n_mids;
+	/* number of concurrency combinations that follow */
+	__le16 n_combos;
+	/* keep last - combinations, variable size by n_combos */
+	struct wil_fw_concurrency_combo combos[0];
+} __packed;
 
 /* brd file info encoded inside a comment record */
 #define WIL_BRD_FILE_MAGIC (0xabcddcbb)
@@ -175,3 +209,5 @@ struct wil_fw_record_gateway_data4 { /* type == wil_fw_type_gateway_data4 */
 	__le32 command;
 	struct wil_fw_data_gw4 data[0]; /* total size [data_size], see above */
 } __packed;
+
+#endif /* __WIL_FW_H__ */
diff --git a/drivers/net/wireless/ath/wil6210/fw_inc.c b/drivers/net/wireless/ath/wil6210/fw_inc.c
index 914c010..718161b 100644
--- a/drivers/net/wireless/ath/wil6210/fw_inc.c
+++ b/drivers/net/wireless/ath/wil6210/fw_inc.c
@@ -136,8 +136,8 @@ static int fw_ignore_section(struct wil6210_priv *wil, const void *data,
 	size_t capa_size;
 
 	if (size < sizeof(*rec)) {
-		wil_hex_dump_fw("", DUMP_PREFIX_OFFSET, 16, 1,
-				data, size, true);
+		wil_err_fw(wil, "capabilities record too short: %zu\n", size);
+		/* let the FW load anyway */
 		return 0;
 	}
 
@@ -158,8 +158,7 @@ static int fw_ignore_section(struct wil6210_priv *wil, const void *data,
 	const struct wil_fw_record_brd_file *rec = data;
 
 	if (size < sizeof(*rec)) {
-		wil_hex_dump_fw("", DUMP_PREFIX_OFFSET, 16, 1,
-				data, size, true);
+		wil_err_fw(wil, "brd_file record too short: %zu\n", size);
 		return 0;
 	}
 
@@ -173,6 +172,44 @@ static int fw_ignore_section(struct wil6210_priv *wil, const void *data,
 }
 
 static int
+fw_handle_concurrency(struct wil6210_priv *wil, const void *data,
+		      size_t size)
+{
+	const struct wil_fw_record_concurrency *rec = data;
+	const struct wil_fw_concurrency_combo *combo;
+	const struct wil_fw_concurrency_limit *limit;
+	size_t remain, lsize;
+	int i, n_combos;
+
+	if (size < sizeof(*rec)) {
+		wil_err_fw(wil, "concurrency record too short: %zu\n", size);
+		/* continue, let the FW load anyway */
+		return 0;
+	}
+
+	n_combos = le16_to_cpu(rec->n_combos);
+	remain = size - offsetof(struct wil_fw_record_concurrency, combos);
+	combo = rec->combos;
+	for (i = 0; i < n_combos; i++) {
+		if (remain < sizeof(*combo))
+			goto out_short;
+		remain -= sizeof(*combo);
+		limit = combo->limits;
+		lsize = combo->n_limits * sizeof(*limit);
+		if (remain < lsize)
+			goto out_short;
+		remain -= lsize;
+		limit += combo->n_limits;
+		combo = (struct wil_fw_concurrency_combo *)limit;
+	}
+
+	return wil_cfg80211_iface_combinations_from_fw(wil, rec);
+out_short:
+	wil_err_fw(wil, "concurrency record truncated\n");
+	return 0;
+}
+
+static int
 fw_handle_comment(struct wil6210_priv *wil, const void *data,
 		  size_t size)
 {
@@ -194,6 +231,13 @@ static int fw_ignore_section(struct wil6210_priv *wil, const void *data,
 		wil_dbg_fw(wil, "magic is WIL_BRD_FILE_MAGIC\n");
 		rc = fw_handle_brd_file(wil, data, size);
 		break;
+	case WIL_FW_CONCURRENCY_MAGIC:
+		wil_dbg_fw(wil, "magic is WIL_FW_CONCURRENCY_MAGIC\n");
+		rc = fw_handle_concurrency(wil, data, size);
+		break;
+	default:
+		wil_hex_dump_fw("", DUMP_PREFIX_OFFSET, 16, 1,
+				data, size, true);
 	}
 
 	return rc;
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index b33aa7d..81cb27a 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -26,6 +26,7 @@
 #include <linux/types.h>
 #include "wmi.h"
 #include "wil_platform.h"
+#include "fw.h"
 
 extern bool no_fw_recovery;
 extern unsigned int mtu_max;
@@ -1012,6 +1013,9 @@ int wil_p2p_listen(struct wil6210_priv *wil, struct wireless_dev *wdev,
 int wil_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 			 struct cfg80211_mgmt_tx_params *params,
 			 u64 *cookie);
+int wil_cfg80211_iface_combinations_from_fw(
+	struct wil6210_priv *wil,
+	const struct wil_fw_record_concurrency *conc);
 
 #if defined(CONFIG_WIL6210_DEBUGFS)
 int wil6210_debugfs_init(struct wil6210_priv *wil);
-- 
1.9.1
