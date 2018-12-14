Return-Path: <SRS0=OWo+=OX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FDC8C43387
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Dec 2018 20:30:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E62ED208C2
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Dec 2018 20:30:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730882AbeLNU35 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 14 Dec 2018 15:29:57 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:41960 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730868AbeLNU34 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Dec 2018 15:29:56 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=localhost.localdomain)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gXu5q-0002RG-By; Fri, 14 Dec 2018 22:29:54 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Naftali Goldstein <naftali.goldstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 14 Dec 2018 22:29:32 +0200
Message-Id: <20181214202945.32375-6-luca@coelho.fi>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181214202945.32375-1-luca@coelho.fi>
References: <20181214202945.32375-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 05/18] iwlwifi: mvm: fix setting HE ppe FW config
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Naftali Goldstein <naftali.goldstein@intel.com>

The FW expects to get the ppe value for each NSS-BW pair in the same
format as in the he phy capabilities IE, which means that a value of 0
implies ppe should be used for BPSK (mcs 0). If there are no PPE
thresholds in the IE, or if for some NSS-RU pair there's no threshold
set for it (this could happen because it's a variable-sized field), it
means no PPE should not be used for that pair, so the value sent to FW
should be 7 which corresponds to "none".

Fixes: 514c30696fbc ("iwlwifi: add support for IEEE802.11ax")
Signed-off-by: Naftali Goldstein <naftali.goldstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/mac.h   | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 8 +++++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/mac.h b/drivers/net/wireless/intel/iwlwifi/fw/api/mac.h
index 2c9e40eedef5..7a3f7b7e6358 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/mac.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/mac.h
@@ -443,7 +443,7 @@ struct iwl_he_backoff_conf {
  * Support for Nss x BW (or RU) matrix:
  *	(0=SISO, 1=MIMO2) x (0-20MHz, 1-40MHz, 2-80MHz, 3-160MHz)
  * Each entry contains 2 QAM thresholds for 8us and 16us:
- *	0=BPSK, 1=QPSK, 2=16QAM, 3=64QAM, 4=256QAM, 5=1024QAM, 6/7=RES
+ *	0=BPSK, 1=QPSK, 2=16QAM, 3=64QAM, 4=256QAM, 5=1024QAM, 6=RES, 7=NONE
  * i.e. QAM_th1 < QAM_th2 such if TX uses QAM_tx:
  *	QAM_tx < QAM_th1            --> PPE=0us
  *	QAM_th1 <= QAM_tx < QAM_th2 --> PPE=8us
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 65c225a54076..99a0dafde382 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -2023,7 +2023,13 @@ static void iwl_mvm_cfg_he_sta(struct iwl_mvm *mvm,
 	if (sta->he_cap.he_cap_elem.mac_cap_info[4] & IEEE80211_HE_MAC_CAP4_BQR)
 		sta_ctxt_cmd.htc_flags |= cpu_to_le32(IWL_HE_HTC_BQR_SUPP);
 
-	/* If PPE Thresholds exist, parse them into a FW-familiar format */
+	/*
+	 * Initialize the PPE thresholds to "None" (7), as described in Table
+	 * 9-262ac of 80211.ax/D3.0.
+	 */
+	memset(&sta_ctxt_cmd.pkt_ext, 7, sizeof(sta_ctxt_cmd.pkt_ext));
+
+	/* If PPE Thresholds exist, parse them into a FW-familiar format. */
 	if (sta->he_cap.he_cap_elem.phy_cap_info[6] &
 	    IEEE80211_HE_PHY_CAP6_PPE_THRESHOLD_PRESENT) {
 		u8 nss = (sta->he_cap.ppe_thres[0] &
-- 
2.19.2

