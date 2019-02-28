Return-Path: <SRS0=yJNj=RD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29BE5C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 15:30:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E501820C01
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 15:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551367856;
	bh=Ez1+l4/ZtUOfUNbqJPa/RpXrbpul15J+t4IXWQlU1yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=kjA3DOsZNRRnDZH1GZgPXxh6qeTDIFxQNRmvu+F9IT/DJTmYQQPNXy+Nuwzdv/qfG
	 ZtmVJ7gu5NJhBUG7KVN81qSMkaa2xOqDun+kM6GCiRrzID7p8zWRZNBmKyl8DgdAUE
	 xq/YAID9r8l5OLM+zq3p9PmOTHlm6D08xaONYBtA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388199AbfB1Pas (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Feb 2019 10:30:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:42006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387524AbfB1PJY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Feb 2019 10:09:24 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF28D218E2;
        Thu, 28 Feb 2019 15:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1551366563;
        bh=Ez1+l4/ZtUOfUNbqJPa/RpXrbpul15J+t4IXWQlU1yw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1TpWOHqFDES+xkFpgWaMOlz2zZn5nbz9MBsBflAh7VaCLIcroSbtnCcumNAS5n0xg
         B5OweKYqBwNRWEaYy8Ff5n20wO2e5lbmxquy27HZLzaPrRTJ6EuEnHov9DEY+LNnTZ
         Qsj+7fs/MEo0QcsOOutDjH96tUFNeBrifCxk0DIo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brian Norris <briannorris@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.20 44/81] ath10k: correct bus type for WCN3990
Date:   Thu, 28 Feb 2019 10:07:36 -0500
Message-Id: <20190228150813.10256-44-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190228150813.10256-1-sashal@kernel.org>
References: <20190228150813.10256-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Brian Norris <briannorris@chromium.org>

[ Upstream commit 2c2008a63e482654ab137c84d3c61c03b75e7df6 ]

WCN3990 is SNOC, not PCI. This prevents probing WCN3990.

Fixes: 367c899f622c ("ath10k: add bus type check in ath10k_init_hw_params")
Signed-off-by: Brian Norris <briannorris@chromium.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 59fdda67f89f4..0a3b2c45549eb 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -548,7 +548,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 	{
 		.id = WCN3990_HW_1_0_DEV_VERSION,
 		.dev_id = 0,
-		.bus = ATH10K_BUS_PCI,
+		.bus = ATH10K_BUS_SNOC,
 		.name = "wcn3990 hw1.0",
 		.continuous_frag_desc = true,
 		.tx_chain_mask = 0x7,
-- 
2.19.1

