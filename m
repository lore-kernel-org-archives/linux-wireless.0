Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:62295 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992AbaCNLlZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Mar 2014 07:41:25 -0400
Received: by mail-ee0-f54.google.com with SMTP id d49so1285469eek.27
        for <linux-wireless@vger.kernel.org>; Fri, 14 Mar 2014 04:41:24 -0700 (PDT)
From: Marek Puzyniak <marek.puzyniak@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Marek Puzyniak <marek.puzyniak@tieto.com>
Subject: [PATCH] ath10k: update regulatory domain settings for 10.x firmware
Date: Fri, 14 Mar 2014 12:41:01 +0100
Message-Id: <1394797261-9219-1-git-send-email-marek.puzyniak@tieto.com> (sfid-20140314_124129_599928_0964D132)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Regulatory domain settings for firmware 10.x has more options
than main firmware, so handle regulatory domain setup separately
for both supported firmwares. Fill in additional dfs domain
parameter according to current regulatory.
This patch does not solve any known bug. Not handled parameter
for firmware 10.x was found during code review.

Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 10 +++++-
 drivers/net/wireless/ath/ath10k/wmi.c | 61 +++++++++++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath10k/wmi.h | 26 ++++++++++++++-
 3 files changed, 93 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 9e24ae9..52ae380 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1730,6 +1730,8 @@ static void ath10k_regd_update(struct ath10k *ar)
 {
 	struct reg_dmn_pair_mapping *regpair;
 	int ret;
+	enum wmi_dfs_region wmi_dfs_reg = WMI_UNINIT_DFS_DOMAIN;
+	enum nl80211_dfs_regions nl_dfs_reg;
 
 	lockdep_assert_held(&ar->conf_mutex);
 
@@ -1739,6 +1741,11 @@ static void ath10k_regd_update(struct ath10k *ar)
 
 	regpair = ar->ath_common.regulatory.regpair;
 
+	if (config_enabled(CONFIG_ATH10K_DFS_CERTIFIED) && ar->dfs_detector) {
+		nl_dfs_reg = ar->dfs_detector->region;
+		wmi_dfs_reg = ath10k_wmi_dfs_region_from_nl80211(nl_dfs_reg);
+	}
+
 	/* Target allows setting up per-band regdomain but ath_common provides
 	 * a combined one only */
 	ret = ath10k_wmi_pdev_set_regdomain(ar,
@@ -1746,7 +1753,8 @@ static void ath10k_regd_update(struct ath10k *ar)
 					    regpair->reg_domain, /* 2ghz */
 					    regpair->reg_domain, /* 5ghz */
 					    regpair->reg_2ghz_ctl,
-					    regpair->reg_5ghz_ctl);
+					    regpair->reg_5ghz_ctl,
+					    wmi_dfs_reg);
 	if (ret)
 		ath10k_warn("could not set pdev regdomain (%d)\n", ret);
 }
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index d61bdf6..48130fe 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2393,8 +2393,9 @@ int ath10k_wmi_connect_htc_service(struct ath10k *ar)
 	return 0;
 }
 
-int ath10k_wmi_pdev_set_regdomain(struct ath10k *ar, u16 rd, u16 rd2g,
-				  u16 rd5g, u16 ctl2g, u16 ctl5g)
+static int ath10k_wmi_main_pdev_set_regdomain(struct ath10k *ar, u16 rd,
+					      u16 rd2g, u16 rd5g, u16 ctl2g,
+					      u16 ctl5g)
 {
 	struct wmi_pdev_set_regdomain_cmd *cmd;
 	struct sk_buff *skb;
@@ -2418,6 +2419,62 @@ int ath10k_wmi_pdev_set_regdomain(struct ath10k *ar, u16 rd, u16 rd2g,
 				   ar->wmi.cmd->pdev_set_regdomain_cmdid);
 }
 
+static int ath10k_wmi_10x_pdev_set_regdomain(struct ath10k *ar, u16 rd,
+					     u16 rd2g, u16 rd5g,
+					     u16 ctl2g, u16 ctl5g,
+					     enum wmi_dfs_region dfs_reg)
+{
+	struct wmi_pdev_set_regdomain_cmd_10x *cmd;
+	struct sk_buff *skb;
+
+	skb = ath10k_wmi_alloc_skb(sizeof(*cmd));
+	if (!skb)
+		return -ENOMEM;
+
+	cmd = (struct wmi_pdev_set_regdomain_cmd_10x *)skb->data;
+	cmd->reg_domain = __cpu_to_le32(rd);
+	cmd->reg_domain_2G = __cpu_to_le32(rd2g);
+	cmd->reg_domain_5G = __cpu_to_le32(rd5g);
+	cmd->conformance_test_limit_2G = __cpu_to_le32(ctl2g);
+	cmd->conformance_test_limit_5G = __cpu_to_le32(ctl5g);
+	cmd->dfs_domain = __cpu_to_le32(dfs_reg);
+
+	ath10k_dbg(ATH10K_DBG_WMI,
+		   "wmi pdev regdomain rd %x rd2g %x rd5g %x ctl2g %x ctl5g %x dfs_region %x\n",
+		   rd, rd2g, rd5g, ctl2g, ctl5g, dfs_reg);
+
+	return ath10k_wmi_cmd_send(ar, skb,
+				   ar->wmi.cmd->pdev_set_regdomain_cmdid);
+}
+
+enum wmi_dfs_region
+ath10k_wmi_dfs_region_from_nl80211(enum nl80211_dfs_regions dfs_region)
+{
+	switch (dfs_region) {
+	case NL80211_DFS_UNSET:
+		return WMI_UNINIT_DFS_DOMAIN;
+	case NL80211_DFS_FCC:
+		return WMI_FCC_DFS_DOMAIN;
+	case NL80211_DFS_ETSI:
+		return WMI_ETSI_DFS_DOMAIN;
+	case NL80211_DFS_JP:
+		return WMI_MKK4_DFS_DOMAIN;
+	}
+	return WMI_UNINIT_DFS_DOMAIN;
+}
+
+int ath10k_wmi_pdev_set_regdomain(struct ath10k *ar, u16 rd, u16 rd2g,
+				  u16 rd5g, u16 ctl2g, u16 ctl5g,
+				  enum wmi_dfs_region dfs_reg)
+{
+	if (test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features))
+		return ath10k_wmi_10x_pdev_set_regdomain(ar, rd, rd2g, rd5g,
+							ctl2g, ctl5g, dfs_reg);
+	else
+		return ath10k_wmi_main_pdev_set_regdomain(ar, rd, rd2g, rd5g,
+							 ctl2g, ctl5g);
+}
+
 int ath10k_wmi_pdev_set_channel(struct ath10k *ar,
 				const struct wmi_channel_arg *arg)
 {
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index e78a7ad..6ef0742 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -2185,6 +2185,27 @@ struct wmi_pdev_set_regdomain_cmd {
 	__le32 conformance_test_limit_5G;
 } __packed;
 
+enum wmi_dfs_region {
+	/* Uninitialized dfs domain */
+	WMI_UNINIT_DFS_DOMAIN = 0,
+	/* FCC3 dfs domain */
+	WMI_FCC_DFS_DOMAIN = 1,
+	/* ETSI dfs domain */
+	WMI_ETSI_DFS_DOMAIN = 2,
+	/*Japan dfs domain */
+	WMI_MKK4_DFS_DOMAIN = 3,
+};
+
+struct wmi_pdev_set_regdomain_cmd_10x {
+	__le32 reg_domain;
+	__le32 reg_domain_2G;
+	__le32 reg_domain_5G;
+	__le32 conformance_test_limit_2G;
+	__le32 conformance_test_limit_5G;
+	/* dfs domain from wmi_dfs_region */
+	__le32 dfs_domain;
+} __packed;
+
 /* Command to set/unset chip in quiet mode */
 struct wmi_pdev_set_quiet_cmd {
 	/* period in TUs */
@@ -4214,8 +4235,11 @@ int ath10k_wmi_pdev_set_channel(struct ath10k *ar,
 				const struct wmi_channel_arg *);
 int ath10k_wmi_pdev_suspend_target(struct ath10k *ar, u32 suspend_opt);
 int ath10k_wmi_pdev_resume_target(struct ath10k *ar);
+enum wmi_dfs_region
+ath10k_wmi_dfs_region_from_nl80211(enum nl80211_dfs_regions dfs_region);
 int ath10k_wmi_pdev_set_regdomain(struct ath10k *ar, u16 rd, u16 rd2g,
-				  u16 rd5g, u16 ctl2g, u16 ctl5g);
+				  u16 rd5g, u16 ctl2g, u16 ctl5g,
+				  enum wmi_dfs_region dfs_reg);
 int ath10k_wmi_pdev_set_param(struct ath10k *ar, u32 id, u32 value);
 int ath10k_wmi_cmd_init(struct ath10k *ar);
 int ath10k_wmi_start_scan(struct ath10k *ar, const struct wmi_start_scan_arg *);
-- 
1.8.1.2

