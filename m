Return-Path: <SRS0=rH0W=QA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5FA1C282C5
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Jan 2019 14:21:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B61321872
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Jan 2019 14:21:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="GVJQ1cDB";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="HvBgRVDz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728164AbfAXOVz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 24 Jan 2019 09:21:55 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:37656 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727694AbfAXOVz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Jan 2019 09:21:55 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id A84C5609C4; Thu, 24 Jan 2019 14:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548339713;
        bh=j98YnBdKymHrND7WlAUh2GILH4c5KaUeM4aMLuEJezc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GVJQ1cDBFygLQixNryimZ0HdmLV7AnZTwfxIepcoL9pnMCgBez+7KX1bC41K8Lmxv
         xYrByUFxCsue/qqCYwlQkoDMwlj4sUniXchgklw0RuyAZOL3+RiGzBC7gtowLnXFtn
         G12m7dybNu//zWIOuYupigC8ZttjQgOPW0VDhhHE=
Received: from aambure-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: aambure@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 80E39609BD;
        Thu, 24 Jan 2019 14:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548339711;
        bh=j98YnBdKymHrND7WlAUh2GILH4c5KaUeM4aMLuEJezc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HvBgRVDzVrAOBJaNwm7r8l/GB/AWrEGDM0LlmWZzpPZ26Y/Y0dX8QFXovVMWPDNhp
         1KYxl9wZsUaqOZ13LgN0TNxQbn3qmT2QV7ruwjTlKIaPAIFDcit7z3pJKdEqs8Om45
         bi0awuOmO+/V4y0dsnfq3sa9iQZxVsey8fnGoGnE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 80E39609BD
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=aambure@codeaurora.org
From:   Abhishek Ambure <aambure@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Abhishek Ambure <aambure@codeaurora.org>
Subject: [PATCH 2/2] ath10k: Update GCMP & GCMP-256 cipher suite number for WCN3990
Date:   Thu, 24 Jan 2019 19:51:37 +0530
Message-Id: <1548339697-17766-3-git-send-email-aambure@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1548339697-17766-1-git-send-email-aambure@codeaurora.org>
References: <1548339697-17766-1-git-send-email-aambure@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

TLV based firmware ex. QCA6174, WCN3990 expects key cipher value
set to 9 while non-TLV firmware expects key cipher value set to 8
for enabling GCMP and GCMP-256 cipher suites.

To fix this problem, attach the key cipher suite values based on
wmi version.

Tested HW: WCN3990
Tested FW: WLAN.HL.2.0-01188-QCAHLSWMTPLZ-1

Signed-off-by: Abhishek Ambure <aambure@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/core.h    |  1 +
 drivers/net/wireless/ath/ath10k/mac.c     | 12 +++++------
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |  6 ++++--
 drivers/net/wireless/ath/ath10k/wmi.c     | 30 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h     | 33 ++++++++++++++++++++++---------
 5 files changed, 65 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 46e9c8c..f2278d0 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -1182,6 +1182,7 @@ struct ath10k {
 
 	u32 ampdu_reference;
 
+	const u8 *wmi_key_cipher;
 	void *ce_priv;
 
 	u32 sta_tid_stats_mask;
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index e49b367..beaff23 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -250,24 +250,24 @@ static int ath10k_send_key(struct ath10k_vif *arvif,
 
 	switch (key->cipher) {
 	case WLAN_CIPHER_SUITE_CCMP:
-		arg.key_cipher = WMI_CIPHER_AES_CCM;
+		arg.key_cipher = ar->wmi_key_cipher[WMI_CIPHER_AES_CCM];
 		key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV_MGMT;
 		break;
 	case WLAN_CIPHER_SUITE_TKIP:
-		arg.key_cipher = WMI_CIPHER_TKIP;
+		arg.key_cipher = ar->wmi_key_cipher[WMI_CIPHER_TKIP];
 		arg.key_txmic_len = 8;
 		arg.key_rxmic_len = 8;
 		break;
 	case WLAN_CIPHER_SUITE_WEP40:
 	case WLAN_CIPHER_SUITE_WEP104:
-		arg.key_cipher = WMI_CIPHER_WEP;
+		arg.key_cipher = ar->wmi_key_cipher[WMI_CIPHER_WEP];
 		break;
 	case WLAN_CIPHER_SUITE_CCMP_256:
-		arg.key_cipher = WMI_CIPHER_AES_CCM;
+		arg.key_cipher = ar->wmi_key_cipher[WMI_CIPHER_AES_CCM];
 		break;
 	case WLAN_CIPHER_SUITE_GCMP:
 	case WLAN_CIPHER_SUITE_GCMP_256:
-		arg.key_cipher = WMI_CIPHER_AES_GCM;
+		arg.key_cipher = ar->wmi_key_cipher[WMI_CIPHER_AES_GCM];
 		break;
 	case WLAN_CIPHER_SUITE_BIP_GMAC_128:
 	case WLAN_CIPHER_SUITE_BIP_GMAC_256:
@@ -284,7 +284,7 @@ static int ath10k_send_key(struct ath10k_vif *arvif,
 		key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
 
 	if (cmd == DISABLE_KEY) {
-		arg.key_cipher = WMI_CIPHER_NONE;
+		arg.key_cipher = ar->wmi_key_cipher[WMI_CIPHER_NONE];
 		arg.key_data = NULL;
 	}
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index e85d6be..bba032b 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -2060,9 +2060,11 @@ static struct sk_buff *ath10k_wmi_tlv_op_gen_init(struct ath10k *ar)
 	size_t len;
 	void *ptr;
 
-	if (arg->key_cipher == WMI_CIPHER_NONE && arg->key_data != NULL)
+	if (arg->key_cipher == ar->wmi_key_cipher[WMI_CIPHER_NONE] &&
+	    arg->key_data)
 		return ERR_PTR(-EINVAL);
-	if (arg->key_cipher != WMI_CIPHER_NONE && arg->key_data == NULL)
+	if (arg->key_cipher != ar->wmi_key_cipher[WMI_CIPHER_NONE] &&
+	    !arg->key_data)
 		return ERR_PTR(-EINVAL);
 
 	len = sizeof(*tlv) + sizeof(*cmd) +
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 971ff36..a7f00a5 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1606,6 +1606,30 @@
 	.enable_btcoex = WMI_10_4_PDEV_PARAM_ENABLE_BTCOEX,
 };
 
+static const u8 wmi_key_cipher_suites[] = {
+	[WMI_CIPHER_NONE] = WMI_CIPHER_NONE,
+	[WMI_CIPHER_WEP] = WMI_CIPHER_WEP,
+	[WMI_CIPHER_TKIP] = WMI_CIPHER_TKIP,
+	[WMI_CIPHER_AES_OCB] = WMI_CIPHER_AES_OCB,
+	[WMI_CIPHER_AES_CCM] = WMI_CIPHER_AES_CCM,
+	[WMI_CIPHER_WAPI] = WMI_CIPHER_WAPI,
+	[WMI_CIPHER_CKIP] = WMI_CIPHER_CKIP,
+	[WMI_CIPHER_AES_CMAC] = WMI_CIPHER_AES_CMAC,
+	[WMI_CIPHER_AES_GCM] = WMI_CIPHER_AES_GCM,
+};
+
+static const u8 wmi_tlv_key_cipher_suites[] = {
+	[WMI_CIPHER_NONE] = WMI_TLV_CIPHER_NONE,
+	[WMI_CIPHER_WEP] = WMI_TLV_CIPHER_WEP,
+	[WMI_CIPHER_TKIP] = WMI_TLV_CIPHER_TKIP,
+	[WMI_CIPHER_AES_OCB] = WMI_TLV_CIPHER_AES_OCB,
+	[WMI_CIPHER_AES_CCM] = WMI_TLV_CIPHER_AES_CCM,
+	[WMI_CIPHER_WAPI] = WMI_TLV_CIPHER_WAPI,
+	[WMI_CIPHER_CKIP] = WMI_TLV_CIPHER_CKIP,
+	[WMI_CIPHER_AES_CMAC] = WMI_TLV_CIPHER_AES_CMAC,
+	[WMI_CIPHER_AES_GCM] = WMI_TLV_CIPHER_AES_GCM,
+};
+
 static const struct wmi_peer_flags_map wmi_peer_flags_map = {
 	.auth = WMI_PEER_AUTH,
 	.qos = WMI_PEER_QOS,
@@ -9252,6 +9276,7 @@ int ath10k_wmi_attach(struct ath10k *ar)
 		ar->wmi.vdev_param = &wmi_10_4_vdev_param_map;
 		ar->wmi.pdev_param = &wmi_10_4_pdev_param_map;
 		ar->wmi.peer_flags = &wmi_10_2_peer_flags_map;
+		ar->wmi_key_cipher = wmi_key_cipher_suites;
 		break;
 	case ATH10K_FW_WMI_OP_VERSION_10_2_4:
 		ar->wmi.cmd = &wmi_10_2_4_cmd_map;
@@ -9259,6 +9284,7 @@ int ath10k_wmi_attach(struct ath10k *ar)
 		ar->wmi.vdev_param = &wmi_10_2_4_vdev_param_map;
 		ar->wmi.pdev_param = &wmi_10_2_4_pdev_param_map;
 		ar->wmi.peer_flags = &wmi_10_2_peer_flags_map;
+		ar->wmi_key_cipher = wmi_key_cipher_suites;
 		break;
 	case ATH10K_FW_WMI_OP_VERSION_10_2:
 		ar->wmi.cmd = &wmi_10_2_cmd_map;
@@ -9266,6 +9292,7 @@ int ath10k_wmi_attach(struct ath10k *ar)
 		ar->wmi.vdev_param = &wmi_10x_vdev_param_map;
 		ar->wmi.pdev_param = &wmi_10x_pdev_param_map;
 		ar->wmi.peer_flags = &wmi_10_2_peer_flags_map;
+		ar->wmi_key_cipher = wmi_key_cipher_suites;
 		break;
 	case ATH10K_FW_WMI_OP_VERSION_10_1:
 		ar->wmi.cmd = &wmi_10x_cmd_map;
@@ -9273,6 +9300,7 @@ int ath10k_wmi_attach(struct ath10k *ar)
 		ar->wmi.vdev_param = &wmi_10x_vdev_param_map;
 		ar->wmi.pdev_param = &wmi_10x_pdev_param_map;
 		ar->wmi.peer_flags = &wmi_10x_peer_flags_map;
+		ar->wmi_key_cipher = wmi_key_cipher_suites;
 		break;
 	case ATH10K_FW_WMI_OP_VERSION_MAIN:
 		ar->wmi.cmd = &wmi_cmd_map;
@@ -9280,9 +9308,11 @@ int ath10k_wmi_attach(struct ath10k *ar)
 		ar->wmi.vdev_param = &wmi_vdev_param_map;
 		ar->wmi.pdev_param = &wmi_pdev_param_map;
 		ar->wmi.peer_flags = &wmi_peer_flags_map;
+		ar->wmi_key_cipher = wmi_key_cipher_suites;
 		break;
 	case ATH10K_FW_WMI_OP_VERSION_TLV:
 		ath10k_wmi_tlv_attach(ar);
+		ar->wmi_key_cipher = wmi_tlv_key_cipher_suites;
 		break;
 	case ATH10K_FW_WMI_OP_VERSION_UNSET:
 	case ATH10K_FW_WMI_OP_VERSION_MAX:
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index ac04077c..ddd4d0f 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -4929,15 +4929,30 @@ struct wmi_key_seq_counter {
 	__le32 key_seq_counter_h;
 } __packed;
 
-#define WMI_CIPHER_NONE     0x0 /* clear key */
-#define WMI_CIPHER_WEP      0x1
-#define WMI_CIPHER_TKIP     0x2
-#define WMI_CIPHER_AES_OCB  0x3
-#define WMI_CIPHER_AES_CCM  0x4
-#define WMI_CIPHER_WAPI     0x5
-#define WMI_CIPHER_CKIP     0x6
-#define WMI_CIPHER_AES_CMAC 0x7
-#define WMI_CIPHER_AES_GCM  0x8
+enum wmi_cipher_suites {
+	WMI_CIPHER_NONE,
+	WMI_CIPHER_WEP,
+	WMI_CIPHER_TKIP,
+	WMI_CIPHER_AES_OCB,
+	WMI_CIPHER_AES_CCM,
+	WMI_CIPHER_WAPI,
+	WMI_CIPHER_CKIP,
+	WMI_CIPHER_AES_CMAC,
+	WMI_CIPHER_AES_GCM,
+};
+
+enum wmi_tlv_cipher_suites {
+	WMI_TLV_CIPHER_NONE,
+	WMI_TLV_CIPHER_WEP,
+	WMI_TLV_CIPHER_TKIP,
+	WMI_TLV_CIPHER_AES_OCB,
+	WMI_TLV_CIPHER_AES_CCM,
+	WMI_TLV_CIPHER_WAPI,
+	WMI_TLV_CIPHER_CKIP,
+	WMI_TLV_CIPHER_AES_CMAC,
+	WMI_TLV_CIPHER_ANY,
+	WMI_TLV_CIPHER_AES_GCM,
+};
 
 struct wmi_vdev_install_key_cmd {
 	__le32 vdev_id;
-- 
1.9.1

