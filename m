Return-Path: <SRS0=s1k3=OY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 228BAC43444
	for <linux-wireless@archiver.kernel.org>; Sat, 15 Dec 2018 09:03:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00AAB2086D
	for <linux-wireless@archiver.kernel.org>; Sat, 15 Dec 2018 09:03:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729959AbeLOJDg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 15 Dec 2018 04:03:36 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:42200 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729192AbeLOJDf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 15 Dec 2018 04:03:35 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gY5rB-0002oc-SR; Sat, 15 Dec 2018 11:03:34 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Sat, 15 Dec 2018 11:03:05 +0200
Message-Id: <20181215090325.31604-5-luca@coelho.fi>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181215090325.31604-1-luca@coelho.fi>
References: <20181215090325.31604-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 04/24] mac80211: update HE operation fields to D3.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shaul Triebitz <shaul.triebitz@intel.com>

HE Operation element has changed in 11ax D3.0.  Update the fields
accordingly.

Signed-off-by: Shaul Triebitz <shaul.triebitz@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/linux/ieee80211.h | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index a9484b3e898d..3b04e72315e1 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1619,7 +1619,7 @@ struct ieee80211_he_mcs_nss_supp {
  * struct ieee80211_he_operation - HE capabilities element
  *
  * This structure is the "HE operation element" fields as
- * described in P802.11ax_D2.0 section 9.4.2.238
+ * described in P802.11ax_D3.0 section 9.4.2.238
  */
 struct ieee80211_he_operation {
 	__le32 he_oper_params;
@@ -2011,17 +2011,17 @@ ieee80211_he_ppe_size(u8 ppe_thres_hdr, const u8 *phy_cap_info)
 }
 
 /* HE Operation defines */
-#define IEEE80211_HE_OPERATION_BSS_COLOR_MASK			0x0000003f
-#define IEEE80211_HE_OPERATION_DFLT_PE_DURATION_MASK		0x000001c0
-#define IEEE80211_HE_OPERATION_DFLT_PE_DURATION_OFFSET		6
-#define IEEE80211_HE_OPERATION_TWT_REQUIRED			0x00000200
-#define IEEE80211_HE_OPERATION_RTS_THRESHOLD_MASK		0x000ffc00
-#define IEEE80211_HE_OPERATION_RTS_THRESHOLD_OFFSET		10
-#define IEEE80211_HE_OPERATION_PARTIAL_BSS_COLOR		0x00100000
-#define IEEE80211_HE_OPERATION_VHT_OPER_INFO			0x00200000
-#define IEEE80211_HE_OPERATION_MULTI_BSSID_AP			0x10000000
-#define IEEE80211_HE_OPERATION_TX_BSSID_INDICATOR		0x20000000
-#define IEEE80211_HE_OPERATION_BSS_COLOR_DISABLED		0x40000000
+#define IEEE80211_HE_OPERATION_DFLT_PE_DURATION_MASK		0x00000003
+#define IEEE80211_HE_OPERATION_TWT_REQUIRED			0x00000008
+#define IEEE80211_HE_OPERATION_RTS_THRESHOLD_MASK		0x00003ff0
+#define IEEE80211_HE_OPERATION_RTS_THRESHOLD_OFFSET		4
+#define IEEE80211_HE_OPERATION_VHT_OPER_INFO			0x00004000
+#define IEEE80211_HE_OPERATION_CO_LOCATED_BSS			0x00008000
+#define IEEE80211_HE_OPERATION_ER_SU_DISABLE			0x00010000
+#define IEEE80211_HE_OPERATION_BSS_COLOR_MASK			0x3f000000
+#define IEEE80211_HE_OPERATION_BSS_COLOR_OFFSET		24
+#define IEEE80211_HE_OPERATION_PARTIAL_BSS_COLOR		0x40000000
+#define IEEE80211_HE_OPERATION_BSS_COLOR_DISABLED		0x80000000
 
 /*
  * ieee80211_he_oper_size - calculate 802.11ax HE Operations IE size
@@ -2046,7 +2046,7 @@ ieee80211_he_oper_size(const u8 *he_oper_ie)
 	he_oper_params = le32_to_cpu(he_oper->he_oper_params);
 	if (he_oper_params & IEEE80211_HE_OPERATION_VHT_OPER_INFO)
 		oper_len += 3;
-	if (he_oper_params & IEEE80211_HE_OPERATION_MULTI_BSSID_AP)
+	if (he_oper_params & IEEE80211_HE_OPERATION_CO_LOCATED_BSS)
 		oper_len++;
 
 	/* Add the first byte (extension ID) to the total length */
-- 
2.19.2

