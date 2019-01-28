Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96149C282C8
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 17:12:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 682072082C
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 17:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548695577;
	bh=yQ3p0Oi+pSSxJuEmVTuForeJApg9tgTH89nzQzevsrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=RslckPCTd3nsp9hQf1GvO0y9lajH9wOTb/3VyhsPZBRCgYQHfT7GQIk9PGjKaqRZX
	 o/E1kAFeXBTCpjSbu6NZd+vyrD90G6fTaltNIlynxhbU6WVtuwBN9NyvQqDKx5ncqF
	 yqmEzNxt1WMrNL1NftHQWT2ZNXCy6JNpPeqLm18w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732439AbfA1QIl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 11:08:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:60696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732022AbfA1QIk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 11:08:40 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0D5C2147A;
        Mon, 28 Jan 2019 16:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548691719;
        bh=yQ3p0Oi+pSSxJuEmVTuForeJApg9tgTH89nzQzevsrE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gh0kvnsS0q7SR8GVWVeWH6Ty06SMVgZos/H8kXVb6tDx/WsmMgiZw+NeQ79REuYgN
         szSZVSBZGn2U56kqXkDOVCcRmYXIOhMpCCdT73b5t5QkIvxV/QzcTvJl0j238KzvpA
         d4Tjd7xuTAXqwAp+kRyEXV3EPsreCrIqcE2ipRQM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Naftali Goldstein <naftali.goldstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 196/258] iwlwifi: mvm: fix setting HE ppe FW config
Date:   Mon, 28 Jan 2019 10:58:22 -0500
Message-Id: <20190128155924.51521-196-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190128155924.51521-1-sashal@kernel.org>
References: <20190128155924.51521-1-sashal@kernel.org>
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
index 55594c93b014..47dbd2d3e3b4 100644
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
index 9a764af30f36..0f357e8c4f94 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1997,7 +1997,13 @@ static void iwl_mvm_cfg_he_sta(struct iwl_mvm *mvm,
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

