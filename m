Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAD4CC282CF
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 17:35:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 778092147A
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 17:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548696954;
	bh=rp143R/6ocT74mEir/w3Ruv0tkQPdjUsWD+7LHUVTrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=2C3z/hSSE3nB6cMCqV8+PoV4wnK7w5Qo+JiZSIdMbtUVyLbT/KZBNjKgKn/44+l82
	 tis9Wo4GX3wXUOVJ747SoMLJDw8Q1y3RWyykTsQ6/NkxG9ZK105K+9SGsfTu3+q+RZ
	 8phV1L7QpeiVxPrwdVfvtLqm8hmxWFsDnN1CR9TY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730442AbfA1Rfm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 12:35:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:41240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729868AbfA1PzS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 10:55:18 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50FD920855;
        Mon, 28 Jan 2019 15:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548690918;
        bh=rp143R/6ocT74mEir/w3Ruv0tkQPdjUsWD+7LHUVTrA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XhVs9S+pRzwRe6/aGLurCpgzjzDZWgVMmb+wbuAUcHh7YJtwozLn8f4gGPhVURufi
         fhVG168l1GX9NUPUgMbImNgVgMYeQI8xU+my+MsxUxYMdgQB687Xjh/YeZtHwhe2v6
         DU4mVZ8nzJX/WhJYU92zBLE3KLu2iQziVtpU4jP4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Naftali Goldstein <naftali.goldstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.20 234/304] iwlwifi: mvm: fix setting HE ppe FW config
Date:   Mon, 28 Jan 2019 10:42:31 -0500
Message-Id: <20190128154341.47195-234-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190128154341.47195-1-sashal@kernel.org>
References: <20190128154341.47195-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Naftali Goldstein <naftali.goldstein@intel.com>

[ Upstream commit 189b8d441b0f7825f0b4278851c52afaa0515ed2 ]

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
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/mac.h   | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 8 +++++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/mac.h b/drivers/net/wireless/intel/iwlwifi/fw/api/mac.h
index 1dd23f846fb9..f3ccd7948340 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/mac.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/mac.h
@@ -442,7 +442,7 @@ struct iwl_he_backoff_conf {
  * Support for Nss x BW (or RU) matrix:
  *	(0=SISO, 1=MIMO2) x (0-20MHz, 1-40MHz, 2-80MHz, 3-160MHz)
  * Each entry contains 2 QAM thresholds for 8us and 16us:
- *	0=BPSK, 1=QPSK, 2=16QAM, 3=64QAM, 4=256QAM, 5=1024QAM, 6/7=RES
+ *	0=BPSK, 1=QPSK, 2=16QAM, 3=64QAM, 4=256QAM, 5=1024QAM, 6=RES, 7=NONE
  * i.e. QAM_th1 < QAM_th2 such if TX uses QAM_tx:
  *	QAM_tx < QAM_th1            --> PPE=0us
  *	QAM_th1 <= QAM_tx < QAM_th2 --> PPE=8us
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 00f831d88366..5a42c617c54c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -2005,7 +2005,13 @@ static void iwl_mvm_cfg_he_sta(struct iwl_mvm *mvm,
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
2.19.1

