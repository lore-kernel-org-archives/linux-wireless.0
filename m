Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36D3CC2D0A3
	for <linux-wireless@archiver.kernel.org>; Mon,  9 Nov 2020 14:47:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD614206E3
	for <linux-wireless@archiver.kernel.org>; Mon,  9 Nov 2020 14:47:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="bCS7WBEi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731276AbgKIOrV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 9 Nov 2020 09:47:21 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:22563 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730338AbgKIOrU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Nov 2020 09:47:20 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1604933240; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=UxffCR4cP+x7zfv9qY8Mb+aCJox5HC8xtIwCds7jO64=; b=bCS7WBEiDV4PmtI1T6bP0Dzdqi220Aq+aQ32LHfFmHARYrrf4hAlOtRbuRIe5HFu+VrJOP0Q
 R0ISUJD3CeVLXgNxMD15rJJlS4abOg0bDlFIcaoSwKL8mJ/aDGejAjhMAxKk4i5nT84Gk1op
 YV/qALBCEzSB4A2UJZgaphXv3+I=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 5fa95678f8c560b58078e699 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 09 Nov 2020 14:47:20
 GMT
Sender: rgnanase=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 21DE1C433C9; Mon,  9 Nov 2020 14:47:19 +0000 (UTC)
Received: from rgnanase-linux.qualcomm.com (blr-c-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: rgnanase)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2F1E5C433C6;
        Mon,  9 Nov 2020 14:47:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2F1E5C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=rgnanase@codeaurora.org
From:   Ramya Gnanasekar <rgnanase@codeaurora.org>
To:     ath11k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Ramya Gnanasekar <rgnanase@codeaurora.org>
Subject: [PATCH] ath11k: Fix beamformee STS in HE cap
Date:   Mon,  9 Nov 2020 20:17:09 +0530
Message-Id: <1604933229-15815-1-git-send-email-rgnanase@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

STS Beamformee capability sent from firmware is overwritten as
num_tx_chains - 1.
When num_tx_chains is 2, then STS is set to invalid value 1.
Since STS is not limited by number of TX chain, not overwriting the
capability received from firmware.

Tested on: IPQ6018 WLAN.HK.2.4.0.1-00303-QCAHKSWPL_SILICONZ-1

Signed-off-by: Ramya Gnanasekar <rgnanase@codeaurora.org>
---
 drivers/net/wireless/ath/ath11k/mac.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 7f8dd47..787b052 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -3729,11 +3729,6 @@ static int ath11k_mac_copy_he_cap(struct ath11k *ar,
 
 		he_cap_elem->mac_cap_info[1] &=
 			IEEE80211_HE_MAC_CAP1_TF_MAC_PAD_DUR_MASK;
-		he_cap_elem->phy_cap_info[4] &=
-			~IEEE80211_HE_PHY_CAP4_BEAMFORMEE_MAX_STS_UNDER_80MHZ_MASK;
-		he_cap_elem->phy_cap_info[4] &=
-			~IEEE80211_HE_PHY_CAP4_BEAMFORMEE_MAX_STS_ABOVE_80MHZ_MASK;
-		he_cap_elem->phy_cap_info[4] |= (ar->num_tx_chains - 1) << 2;
 
 		he_cap_elem->phy_cap_info[5] &=
 			~IEEE80211_HE_PHY_CAP5_BEAMFORMEE_NUM_SND_DIM_UNDER_80MHZ_MASK;
-- 
2.7.4

