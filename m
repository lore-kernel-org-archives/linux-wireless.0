Return-Path: <SRS0=6Pxi=7L=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E995C433E1
	for <linux-wireless@archiver.kernel.org>; Fri, 29 May 2020 06:39:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E65320721
	for <linux-wireless@archiver.kernel.org>; Fri, 29 May 2020 06:39:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725855AbgE2Gjm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 29 May 2020 02:39:42 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:34980 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725768AbgE2Gjm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 May 2020 02:39:42 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <luca@coelho.fi>)
        id 1jeYg8-000jvb-5s; Fri, 29 May 2020 09:39:40 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 29 May 2020 09:39:21 +0300
Message-Id: <iwlwifi.20200529092401.c3e50c36c628.I991bfa662c0ef35de5be9eaf5b78ef190b67cb56@changeid>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529063931.80551-1-luca@coelho.fi>
References: <20200529063931.80551-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 01/11] iwlwifi: set NO_HE if the regulatory domain forbids it
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Haim Dreyfuss <haim.dreyfuss@intel.com>

If the firmware's regulatory domain forbids HE operation, set it
in the cfg80211 regdomain.

Signed-off-by: Haim Dreyfuss <haim.dreyfuss@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index d91a8e8349e6..ee410417761d 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -240,6 +240,7 @@ enum iwl_nvm_channel_flags {
  * @REG_CAPA_40MHZ_FORBIDDEN: 11n channel with a width of 40Mhz is forbidden
  *	for this regulatory domain (valid only in 5Ghz).
  * @REG_CAPA_DC_HIGH_ENABLED: DC HIGH allowed.
+ * @REG_CAPA_11AX_DISABLED: 11ax is forbidden for this regulatory domain.
  */
 enum iwl_reg_capa_flags {
 	REG_CAPA_BF_CCD_LOW_BAND	= BIT(0),
@@ -250,6 +251,7 @@ enum iwl_reg_capa_flags {
 	REG_CAPA_MCS_9_ALLOWED		= BIT(5),
 	REG_CAPA_40MHZ_FORBIDDEN	= BIT(7),
 	REG_CAPA_DC_HIGH_ENABLED	= BIT(9),
+	REG_CAPA_11AX_DISABLED		= BIT(10),
 };
 
 static inline void iwl_nvm_print_channel_flags(struct device *dev, u32 level,
@@ -1115,6 +1117,9 @@ static u32 iwl_nvm_get_regdom_bw_flags(const u16 *nvm_chan,
 			flags |= NL80211_RRF_NO_160MHZ;
 	}
 
+	if (cap_flags & REG_CAPA_11AX_DISABLED)
+		flags |= NL80211_RRF_NO_HE;
+
 	return flags;
 }
 
-- 
2.26.2

