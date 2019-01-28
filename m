Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EAC0C282CD
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 17:28:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50C7920857
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 17:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548696486;
	bh=2g2VR35LW0pOulIVISGAM47+1yF4qarYixNWVpr7YE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=JiodvurzDVI5dt04OoSlM5WDHfXGC8qpjtbwcC6vIjX/RswSIyDxKroybw/SOBTX7
	 aO2T3QwSMQjeFeDz80m1lUW2dX61t4ypKtssnA3qx6J+XlsRmpz8DZqiELMi/0oVgU
	 3QxjBBnpzn2qPt1DQOYXQlzLj7Ycwq5gD7qSlR3o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730665AbfA1QAA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 11:00:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:45260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727858AbfA1P75 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 10:59:57 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78E262082E;
        Mon, 28 Jan 2019 15:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548691197;
        bh=2g2VR35LW0pOulIVISGAM47+1yF4qarYixNWVpr7YE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ntx5TCmV1ujkE4d+aeVd/wvQPwafSCHvKbsnSM7w82P462GW2bSJWo/v+32DWQtmQ
         ug07+fTcbMiAmGdwHuL+A/1ugBuPUOqRP+sIDlNtQ3uBRbxekqfgTgRBfFSxlcszbg
         iKryg4wyPau6lF7pRfoGSAVTpYn9YzZrW8GTlB7g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexei Avshalom Lazar <ailizaro@codeaurora.org>,
        Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 011/258] wil6210: fix reset flow for Talyn-mb
Date:   Mon, 28 Jan 2019 10:55:17 -0500
Message-Id: <20190128155924.51521-11-sashal@kernel.org>
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

From: Alexei Avshalom Lazar <ailizaro@codeaurora.org>

[ Upstream commit d083b2e2b7db5cca1791643d036e6597af27f49b ]

With current reset flow, Talyn sometimes get stuck causing PCIe
enumeration to fail. Fix this by removing some reset flow operations
that are not relevant for Talyn.
Setting bit 15 in RGF_HP_CTRL is WBE specific and is not in use for
all wil6210 devices.
For Sparrow, BIT_HPAL_PERST_FROM_PAD and BIT_CAR_PERST_RST were set
as a WA an HW issue.

Signed-off-by: Alexei Avshalom Lazar <ailizaro@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wil6210/main.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 7debed6bec06..a0fe8cbad104 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -995,10 +995,13 @@ static int wil_target_reset(struct wil6210_priv *wil, int no_flash)
 
 	wil_dbg_misc(wil, "Resetting \"%s\"...\n", wil->hw_name);
 
-	/* Clear MAC link up */
-	wil_s(wil, RGF_HP_CTRL, BIT(15));
-	wil_s(wil, RGF_USER_CLKS_CTL_SW_RST_MASK_0, BIT_HPAL_PERST_FROM_PAD);
-	wil_s(wil, RGF_USER_CLKS_CTL_SW_RST_MASK_0, BIT_CAR_PERST_RST);
+	if (wil->hw_version < HW_VER_TALYN) {
+		/* Clear MAC link up */
+		wil_s(wil, RGF_HP_CTRL, BIT(15));
+		wil_s(wil, RGF_USER_CLKS_CTL_SW_RST_MASK_0,
+		      BIT_HPAL_PERST_FROM_PAD);
+		wil_s(wil, RGF_USER_CLKS_CTL_SW_RST_MASK_0, BIT_CAR_PERST_RST);
+	}
 
 	wil_halt_cpu(wil);
 
-- 
2.19.1

