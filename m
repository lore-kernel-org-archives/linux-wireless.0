Return-Path: <SRS0=F8Dj=QZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09A7BC43381
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 06:15:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4B6A218AD
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 06:15:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="JhQ5d3RH";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="JhQ5d3RH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725881AbfBRGPQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Feb 2019 01:15:16 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:44132 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbfBRGPQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Feb 2019 01:15:16 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id ED4806077A; Mon, 18 Feb 2019 06:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550470515;
        bh=fdnLzBqaHlpkKFft5Fkcwt1PjsGTpovhyuNbIQbPNSY=;
        h=From:To:Cc:Subject:Date:From;
        b=JhQ5d3RHpohgc0xHNZXckpOgeDjC2Q9v6ov/BJ/JZfD91fOQm1Kp6lApDihUgLwuA
         0dTJfmeo/DIFNlw71NS93Vhm2DcCylhsIfrNaUfDYqjCgKU80CT5SOjASHzEDLfamF
         eXGue8Eal2h6EQ08igZaByg3vlp7vVNXmOKgq2sY=
Received: from localhost.localdomain (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: wgong@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B5E0D60500;
        Mon, 18 Feb 2019 06:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550470515;
        bh=fdnLzBqaHlpkKFft5Fkcwt1PjsGTpovhyuNbIQbPNSY=;
        h=From:To:Cc:Subject:Date:From;
        b=JhQ5d3RHpohgc0xHNZXckpOgeDjC2Q9v6ov/BJ/JZfD91fOQm1Kp6lApDihUgLwuA
         0dTJfmeo/DIFNlw71NS93Vhm2DcCylhsIfrNaUfDYqjCgKU80CT5SOjASHzEDLfamF
         eXGue8Eal2h6EQ08igZaByg3vlp7vVNXmOKgq2sY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B5E0D60500
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=wgong@codeaurora.org
From:   Wen Gong <wgong@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
Subject: [PATCH] ath10k: remove the calibration data fetch for sdio
Date:   Mon, 18 Feb 2019 14:14:31 +0800
Message-Id: <1550470471-28002-1-git-send-email-wgong@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The calibration data fetch will trigger sdio error, then sdio will
become fail untill reboot system.

If happens when run ifconfig wlan down, then ifconfig wlan up will
fail untill reboot system.Remove it fix the ifconfig wlan issue.

Tested with QCA6174 SDIO with firmware
WLAN.RMH.4.4.1-00005-QCARMSWP-1.

Signed-off-by: Wen Gong <wgong@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/debug.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 15964b3..c33a51f 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -1263,6 +1263,9 @@ static int ath10k_debug_cal_data_fetch(struct ath10k *ar)
 	if (WARN_ON(ar->hw_params.cal_data_len > ATH10K_DEBUG_CAL_DATA_LEN))
 		return -EINVAL;
 
+	if (ar->hw_params.cal_data_len == 0)
+		return -EOPNOTSUPP;
+
 	hi_addr = host_interest_item_address(HI_ITEM(hi_board_data));
 
 	ret = ath10k_hif_diag_read(ar, hi_addr, &addr, sizeof(addr));
-- 
1.9.1

