Return-Path: <SRS0=23TN=ZT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8072DC432C0
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Nov 2019 14:08:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 586AE2068E
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Nov 2019 14:08:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="md3w4vCM";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="YyeoowwR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbfK0OIx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Nov 2019 09:08:53 -0500
Received: from a27-187.smtp-out.us-west-2.amazonses.com ([54.240.27.187]:51462
        "EHLO a27-187.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726320AbfK0OIw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Nov 2019 09:08:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1574863732;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References;
        bh=HV4smCB74VYZJ5K875gZdWZLAK/+PVmUbYzdYi4213g=;
        b=md3w4vCMagpuSVFj8n3TkSgVUeojKuFrj5ddyOkITEbIojVH+M3FXiJI8qucoTNh
        R/vuUkezPBaU+mYWz+Qwe1DWiK4+Y11jHfxtMVNSPnDF/M9VqMpM7iu19khNMho9ad3
        79E/D06vPbCxcE/c0P0dsygMvFcx7wwpsucNgzps=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1574863732;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:Feedback-ID;
        bh=HV4smCB74VYZJ5K875gZdWZLAK/+PVmUbYzdYi4213g=;
        b=YyeoowwREI1frskS5ysfMmyT57wWYDNHoeerVu+foyqK9Sy9QGOF4NC3EofF04VH
        rQdmc3WOJC94ledJnfK8t7ICdYkPPlYX1Udi+zclXW5BKKty9OFtbWCYM05s/EoipLt
        /EE+PcUUzjQUCj9zix3pSXR+aoiXOIGtG+kdQZ5E=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org EA7D3C447B4
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     linux-wireless@vger.kernel.org
Cc:     ath11k@lists.infradead.org
Subject: [PATCH 05/10] ath11k: avoid burst time conversion logic
Date:   Wed, 27 Nov 2019 14:08:52 +0000
Message-ID: <0101016ead317d3d-cba324be-eca5-4e96-94c1-59aae273bda7-000000@us-west-2.amazonses.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1574863720-25728-1-git-send-email-kvalo@codeaurora.org>
References: <1574863720-25728-1-git-send-email-kvalo@codeaurora.org>
X-SES-Outgoing: 2019.11.27-54.240.27.187
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Karthikeyan Periyasamy <periyasa@codeaurora.org>

WMI_VDEV_SET_WMM_PARAMS commmand expects the txoplimit param in the units of
32 microseconds. convert the txop unit from 32 microseconds to absolute
microseconds leads to the higher burst values which is incorrect. so no need
to convert the txop unit from 32 microseconds to absolute microseconds.

Signed-off-by: Karthikeyan Periyasamy <periyasa@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
---
 drivers/net/wireless/ath/ath11k/mac.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 6f82fdbbd358..412c258143ca 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -3023,12 +3023,7 @@ static int ath11k_mac_op_conf_tx(struct ieee80211_hw *hw,
 	p->cwmin = params->cw_min;
 	p->cwmax = params->cw_max;
 	p->aifs = params->aifs;
-
-	/* The channel time duration programmed in the HW is in absolute
-	 * microseconds, while mac80211 gives the txop in units of
-	 * 32 microseconds.
-	 */
-	p->txop = params->txop * 32;
+	p->txop = params->txop;
 
 	ret = ath11k_wmi_send_wmm_update_cmd_tlv(ar, arvif->vdev_id,
 						 &arvif->wmm_params);
-- 
2.7.4

