Return-Path: <SRS0=xI28=P5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA6DCC282E6
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Jan 2019 07:51:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 820732084A
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Jan 2019 07:51:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728898AbfAUHvH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 21 Jan 2019 02:51:07 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:49180 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726240AbfAUHvH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Jan 2019 02:51:07 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1glULz-0006cr-Fi; Mon, 21 Jan 2019 09:50:43 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Mon, 21 Jan 2019 09:50:25 +0200
Message-Id: <20190121075026.25059-16-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190121075026.25059-1-luca@coelho.fi>
References: <20190121075026.25059-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 15/16] iwlwifi: fw api: remove unused/deprecated filter status
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

These are unused by both firmware and driver, remove them.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/rx.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h b/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h
index 0791a854fc8f..b4f7ea30a7c1 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h
@@ -209,8 +209,6 @@ enum iwl_rx_phy_flags {
  * @RX_MPDU_RES_STATUS_CSUM_OK: checksum found no errors
  * @RX_MPDU_RES_STATUS_STA_ID_MSK: station ID mask
  * @RX_MDPU_RES_STATUS_STA_ID_SHIFT: station ID bit shift
- * @RX_MPDU_RES_STATUS_FILTERING_MSK: filter status
- * @RX_MPDU_RES_STATUS2_FILTERING_MSK: filter status 2
  */
 enum iwl_mvm_rx_status {
 	RX_MPDU_RES_STATUS_CRC_OK			= BIT(0),
@@ -238,8 +236,6 @@ enum iwl_mvm_rx_status {
 	RX_MPDU_RES_STATUS_CSUM_OK			= BIT(17),
 	RX_MDPU_RES_STATUS_STA_ID_SHIFT			= 24,
 	RX_MPDU_RES_STATUS_STA_ID_MSK			= 0x1f << RX_MDPU_RES_STATUS_STA_ID_SHIFT,
-	RX_MPDU_RES_STATUS_FILTERING_MSK		= (0xc00000),
-	RX_MPDU_RES_STATUS2_FILTERING_MSK		= (0xc0000000),
 };
 
 /* 9000 series API */
-- 
2.20.1

