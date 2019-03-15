Return-Path: <SRS0=bI0Y=RS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D33D8C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 15:56:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A434E21872
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 15:56:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729362AbfCOP4a (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Mar 2019 11:56:30 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:44196 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727826AbfCOP43 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Mar 2019 11:56:29 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h4ova-0004n1-F8; Fri, 15 Mar 2019 17:39:22 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 15 Mar 2019 17:39:07 +0200
Message-Id: <20190315153907.16192-12-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190315153907.16192-1-luca@coelho.fi>
References: <20190315153907.16192-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 11/11] ieee80211: update HE IEs to D4.0 spec
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Liad Kaufman <liad.kaufman@intel.com>

Update the out-dated comments as well, and have them point to
the correct sections in the D4.0 spec.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/linux/ieee80211.h | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 522881f31938..61f0a316c6ac 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1557,7 +1557,7 @@ struct ieee80211_vht_operation {
  * struct ieee80211_he_cap_elem - HE capabilities element
  *
  * This structure is the "HE capabilities element" fixed fields as
- * described in P802.11ax_D3.0 section 9.4.2.237.2 and 9.4.2.237.3
+ * described in P802.11ax_D4.0 section 9.4.2.242.2 and 9.4.2.242.3
  */
 struct ieee80211_he_cap_elem {
 	u8 mac_cap_info[6];
@@ -1619,12 +1619,12 @@ struct ieee80211_he_mcs_nss_supp {
  * struct ieee80211_he_operation - HE capabilities element
  *
  * This structure is the "HE operation element" fields as
- * described in P802.11ax_D3.0 section 9.4.2.238
+ * described in P802.11ax_D4.0 section 9.4.2.243
  */
 struct ieee80211_he_operation {
 	__le32 he_oper_params;
 	__le16 he_mcs_nss_set;
-	/* Optional 0,1,3 or 4 bytes: depends on @he_oper_params */
+	/* Optional 0,1,3,4,5,7 or 8 bytes: depends on @he_oper_params */
 	u8 optional[0];
 } __packed;
 
@@ -1632,7 +1632,7 @@ struct ieee80211_he_operation {
  * struct ieee80211_he_mu_edca_param_ac_rec - MU AC Parameter Record field
  *
  * This structure is the "MU AC Parameter Record" fields as
- * described in P802.11ax_D2.0 section 9.4.2.240
+ * described in P802.11ax_D4.0 section 9.4.2.245
  */
 struct ieee80211_he_mu_edca_param_ac_rec {
 	u8 aifsn;
@@ -1644,7 +1644,7 @@ struct ieee80211_he_mu_edca_param_ac_rec {
  * struct ieee80211_mu_edca_param_set - MU EDCA Parameter Set element
  *
  * This structure is the "MU EDCA Parameter Set element" fields as
- * described in P802.11ax_D2.0 section 9.4.2.240
+ * described in P802.11ax_D4.0 section 9.4.2.245
  */
 struct ieee80211_mu_edca_param_set {
 	u8 mu_qos_info;
@@ -2026,6 +2026,7 @@ ieee80211_he_ppe_size(u8 ppe_thres_hdr, const u8 *phy_cap_info)
 #define IEEE80211_HE_OPERATION_VHT_OPER_INFO			0x00004000
 #define IEEE80211_HE_OPERATION_CO_HOSTED_BSS			0x00008000
 #define IEEE80211_HE_OPERATION_ER_SU_DISABLE			0x00010000
+#define IEEE80211_HE_OPERATION_6GHZ_OP_INFO			0x00020000
 #define IEEE80211_HE_OPERATION_BSS_COLOR_MASK			0x3f000000
 #define IEEE80211_HE_OPERATION_BSS_COLOR_OFFSET		24
 #define IEEE80211_HE_OPERATION_PARTIAL_BSS_COLOR		0x40000000
@@ -2056,6 +2057,8 @@ ieee80211_he_oper_size(const u8 *he_oper_ie)
 		oper_len += 3;
 	if (he_oper_params & IEEE80211_HE_OPERATION_CO_HOSTED_BSS)
 		oper_len++;
+	if (he_oper_params & IEEE80211_HE_OPERATION_6GHZ_OP_INFO)
+		oper_len += 4;
 
 	/* Add the first byte (extension ID) to the total length */
 	oper_len++;
-- 
2.20.1

