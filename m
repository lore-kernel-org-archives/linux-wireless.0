Return-Path: <SRS0=hbYo=M5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 389A4ECDE3B
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 21:18:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03587208E4
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 21:18:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 03587208E4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727213AbeJRFPj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Oct 2018 01:15:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:49585 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725745AbeJRFPj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Oct 2018 01:15:39 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Oct 2018 14:13:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.54,393,1534834800"; 
   d="scan'208";a="242160251"
Received: from jprestwo.jf.intel.com ([10.54.74.38])
  by orsmga004.jf.intel.com with ESMTP; 17 Oct 2018 14:13:07 -0700
From:   James Prestwood <james.prestwood@linux.intel.com>
To:     linux-wireless@vger.kernel.org
Cc:     James Prestwood <james.prestwood@linux.intel.com>
Subject: [PATCH v3 2/2] mac80211_hwsim: allow configurable cipher types
Date:   Wed, 17 Oct 2018 14:16:24 -0700
Message-Id: <20181017211624.7338-2-james.prestwood@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20181017211624.7338-1-james.prestwood@linux.intel.com>
References: <20181017211624.7338-1-james.prestwood@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The mac80211_hwsim driver does not specify supported cipher types, which
in turn enables all ciphers to be supported in software. (see
net/mac80211/main.c:ieee80211_init_cipher_suites). Allowing ciphers
to be configurable is valuable for simulating older drivers that may
not support all ciphers.

This patch adds a new attribute:

 - HWSIM_ATTR_CIPHER_SUPPORT
	A u32 array/list of supported cipher types

This only allows enabling/disabling cipher types listed in the (new)
"hwsim_ciphers" array in mac80211_hwsim.c. Any unknown cipher type
will result in -EINVAL.

Signed-off-by: James Prestwood <james.prestwood@linux.intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 64 +++++++++++++++++++++++++++
 drivers/net/wireless/mac80211_hwsim.h |  2 +
 2 files changed, 66 insertions(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 2799eb247b7e..69596eb255d7 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -371,6 +371,20 @@ static const struct ieee80211_rate hwsim_rates[] = {
 	{ .bitrate = 540 }
 };
 
+static const u32 hwsim_ciphers[] = {
+	WLAN_CIPHER_SUITE_WEP40,
+	WLAN_CIPHER_SUITE_WEP104,
+	WLAN_CIPHER_SUITE_TKIP,
+	WLAN_CIPHER_SUITE_CCMP,
+	WLAN_CIPHER_SUITE_CCMP_256,
+	WLAN_CIPHER_SUITE_GCMP,
+	WLAN_CIPHER_SUITE_GCMP_256,
+	WLAN_CIPHER_SUITE_AES_CMAC,
+	WLAN_CIPHER_SUITE_BIP_CMAC_256,
+	WLAN_CIPHER_SUITE_BIP_GMAC_128,
+	WLAN_CIPHER_SUITE_BIP_GMAC_256,
+};
+
 #define OUI_QCA 0x001374
 #define QCA_NL80211_SUBCMD_TEST 1
 enum qca_nl80211_vendor_subcmds {
@@ -474,6 +488,8 @@ struct mac80211_hwsim_data {
 	struct ieee80211_iface_limit if_limits[3];
 	int n_if_limits;
 
+	u32 ciphers[ARRAY_SIZE(hwsim_ciphers)];
+
 	struct mac_address addresses[2];
 	int channels, idx;
 	bool use_chanctx;
@@ -602,6 +618,7 @@ static const struct nla_policy hwsim_genl_policy[HWSIM_ATTR_MAX + 1] = {
 	[HWSIM_ATTR_FREQ] = { .type = NLA_U32 },
 	[HWSIM_ATTR_PERM_ADDR] = { .type = NLA_UNSPEC, .len = ETH_ALEN },
 	[HWSIM_ATTR_IFTYPE_SUPPORT] = { .type = NLA_U32 },
+	[HWSIM_ATTR_CIPHER_SUPPORT] = { .type = NLA_BINARY },
 };
 
 static void mac80211_hwsim_tx_frame(struct ieee80211_hw *hw,
@@ -2375,6 +2392,8 @@ struct hwsim_new_radio_params {
 	bool no_vif;
 	const u8 *perm_addr;
 	u32 iftypes;
+	u32 *ciphers;
+	u8 n_ciphers;
 };
 
 static void hwsim_mcast_config_msg(struct sk_buff *mcast_skb,
@@ -2638,6 +2657,13 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 	hw->wiphy->iface_combinations = &data->if_combination;
 	hw->wiphy->n_iface_combinations = 1;
 
+	if (param->ciphers) {
+		memcpy(data->ciphers, param->ciphers,
+				param->n_ciphers * sizeof(u32));
+		hw->wiphy->cipher_suites = data->ciphers;
+		hw->wiphy->n_cipher_suites = param->n_ciphers;
+	}
+
 	INIT_DELAYED_WORK(&data->roc_start, hw_roc_start);
 	INIT_DELAYED_WORK(&data->roc_done, hw_roc_done);
 	INIT_DELAYED_WORK(&data->hw_scan, hw_scan_work);
@@ -3185,6 +3211,29 @@ static int hwsim_register_received_nl(struct sk_buff *skb_2,
 	return 0;
 }
 
+/* ensures ciphers only include ciphers listed in 'hwsim_ciphers' array */
+static int hwsim_validate_ciphers(const u32 *ciphers, int n_ciphers)
+{
+	int i;
+
+	for (i = 0; i < n_ciphers; i++) {
+		int j;
+		int found = 0;
+
+		for (j = 0; j < ARRAY_SIZE(hwsim_ciphers); j++) {
+			if (ciphers[i] == hwsim_ciphers[j]) {
+				found = 1;
+				break;
+			}
+		}
+
+		if (!found)
+			return -1;
+	}
+
+	return 0;
+}
+
 static int hwsim_new_radio_nl(struct sk_buff *msg, struct genl_info *info)
 {
 	struct hwsim_new_radio_params param = { 0 };
@@ -3267,6 +3316,21 @@ static int hwsim_new_radio_nl(struct sk_buff *msg, struct genl_info *info)
 		param.p2p_device = true;
 	}
 
+	if (info->attrs[HWSIM_ATTR_CIPHER_SUPPORT]) {
+		param.ciphers = nla_data(
+					info->attrs[HWSIM_ATTR_CIPHER_SUPPORT]);
+		param.n_ciphers = nla_len(
+					info->attrs[HWSIM_ATTR_CIPHER_SUPPORT]);
+
+		if (param.n_ciphers > sizeof(hwsim_ciphers))
+			return -EINVAL;
+
+		param.n_ciphers /= sizeof(u32);
+
+		if (hwsim_validate_ciphers(param.ciphers, param.n_ciphers))
+			return -EINVAL;
+	}
+
 	ret = mac80211_hwsim_new_radio(info, &param);
 	kfree(hwname);
 	return ret;
diff --git a/drivers/net/wireless/mac80211_hwsim.h b/drivers/net/wireless/mac80211_hwsim.h
index 3f6b670116d0..a1ef8457fad4 100644
--- a/drivers/net/wireless/mac80211_hwsim.h
+++ b/drivers/net/wireless/mac80211_hwsim.h
@@ -133,6 +133,7 @@ enum {
  *	rates of %HWSIM_ATTR_TX_INFO
  * @HWSIM_ATTR_PERM_ADDR: permanent mac address of new radio
  * @HWSIM_ATTR_IFTYPE_SUPPORT: u32 attribute of supported interface types bits
+ * @HWSIM_ATTR_CIPHER_SUPPORT: u32 array of supported cipher types
  * @__HWSIM_ATTR_MAX: enum limit
  */
 
@@ -162,6 +163,7 @@ enum {
 	HWSIM_ATTR_TX_INFO_FLAGS,
 	HWSIM_ATTR_PERM_ADDR,
 	HWSIM_ATTR_IFTYPE_SUPPORT,
+	HWSIM_ATTR_CIPHER_SUPPORT,
 	__HWSIM_ATTR_MAX,
 };
 #define HWSIM_ATTR_MAX (__HWSIM_ATTR_MAX - 1)
-- 
2.17.1

