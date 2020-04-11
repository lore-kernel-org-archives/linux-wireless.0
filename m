Return-Path: <SRS0=JTkr=53=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1819C2BB86
	for <linux-wireless@archiver.kernel.org>; Sat, 11 Apr 2020 23:30:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C28D0206E9
	for <linux-wireless@archiver.kernel.org>; Sat, 11 Apr 2020 23:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586647816;
	bh=tRG72cihYiM6EZUluJkAAhOsZlcgd7QHeyjMoIxs5ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=AwD87bvPdC9FCakiulG0DLFYkWiIXBxGbE5RoA8Mncc/mGUBD3xEotWEjJu4aChEC
	 OSFjvFxDlMLahbdQ6OBNYblm8F1YzFHFEBT12TnRgCGWbp2+TqcBPc3MbPXq6TJTGi
	 7511m3xuNpKpxK7hcP26FeqKHoUHG1odu6TY854I=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730057AbgDKXaI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 11 Apr 2020 19:30:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:49384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729666AbgDKXKk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 11 Apr 2020 19:10:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2FF4E216FD;
        Sat, 11 Apr 2020 23:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646641;
        bh=tRG72cihYiM6EZUluJkAAhOsZlcgd7QHeyjMoIxs5ao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PAQNMInd5t6NhoOJtPltrBMc/RZ+D2bn0gtn1HUW+OBnWRQdg3DWHxf5FArjc4tgZ
         bCG25sG+up0pvtCiMpx5yNCwaxJIWwG/UeszELd5ClZ0oo/36KKSFy2D7HjdIIXtyG
         msmw1VluRDIsCkxPUG2Zdd8i3wKI9oXoigui5Ajo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tzu-En Huang <tehuang@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 047/108] rtw88: 8822c: update power sequence to v16
Date:   Sat, 11 Apr 2020 19:08:42 -0400
Message-Id: <20200411230943.24951-47-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230943.24951-1-sashal@kernel.org>
References: <20200411230943.24951-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Tzu-En Huang <tehuang@realtek.com>

[ Upstream commit 8299adec99b29f341f0ee4269f1ce70ca8508e78 ]

Fix switching xtal mode leads to BT USB error issue.

Signed-off-by: Tzu-En Huang <tehuang@realtek.com>
Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/rtw8822c.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.c b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
index de0505a6a365d..509cc76e6ba54 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
@@ -3336,6 +3336,11 @@ static struct rtw_pwr_seq_cmd trans_cardemu_to_act_8822c[] = {
 	 RTW_PWR_INTF_ALL_MSK,
 	 RTW_PWR_ADDR_MAC,
 	 RTW_PWR_CMD_WRITE, BIT(2), BIT(2)},
+	{0x1064,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(1), BIT(1)},
 	{0xFFFF,
 	 RTW_PWR_CUT_ALL_MSK,
 	 RTW_PWR_INTF_ALL_MSK,
-- 
2.20.1

