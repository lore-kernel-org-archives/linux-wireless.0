Return-Path: <SRS0=A7Z7=R6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10B3FC10F00
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 18:57:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6F55205C9
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 18:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553713034;
	bh=UIUXeW/Aut1a/NmMfCr9gK5WIqNPbrDcI5+ziZX0UsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Ab7op0urm8ltC3kefrgveJ821aDhWSfs4e5P2uu+b2kXSKcWrgEqtDGgi8jNOrxtk
	 PCA8t8mf6VXZX6rhabHiwzPMTalL4jj3mfTdQhVNwUdAn4TB0ZflsKXLudHoOpfynZ
	 jbXg+8aryuuiUfsu6175vP2SwpLrExYngnfEgR8o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389990AbfC0SQN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Mar 2019 14:16:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:60030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388950AbfC0SQK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Mar 2019 14:16:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03ADE2082F;
        Wed, 27 Mar 2019 18:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553710569;
        bh=UIUXeW/Aut1a/NmMfCr9gK5WIqNPbrDcI5+ziZX0UsE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qNONTYzsbN0+2wTsEMa+D2Ol4JBrL7I2wKT3KEOn8LPfkNv+3QVNAxIjn+G8VwgHa
         BcdzzMOoy+VwgIP4PEVKDjlv6/sJDKGiTOfMxLpTomJtF3AfDQMq4Uj9L2Jdhggm8k
         kSpvISbMh5fKGFKQ7poFPwi2tGJxblKk9FJBGmEk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zumeng Chen <zumeng.chen@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 181/192] wlcore: Fix memory leak in case wl12xx_fetch_firmware failure
Date:   Wed, 27 Mar 2019 14:10:13 -0400
Message-Id: <20190327181025.13507-181-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190327181025.13507-1-sashal@kernel.org>
References: <20190327181025.13507-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Zumeng Chen <zumeng.chen@gmail.com>

[ Upstream commit ba2ffc96321c8433606ceeb85c9e722b8113e5a7 ]

Release fw_status, raw_fw_status, and tx_res_if when wl12xx_fetch_firmware
failed instead of meaningless goto out to avoid the following memory leak
reports(Only the last one listed):

unreferenced object 0xc28a9a00 (size 512):
  comm "kworker/0:4", pid 31298, jiffies 2783204 (age 203.290s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
  backtrace:
    [<6624adab>] kmemleak_alloc+0x40/0x74
    [<500ddb31>] kmem_cache_alloc_trace+0x1ac/0x270
    [<db4d731d>] wl12xx_chip_wakeup+0xc4/0x1fc [wlcore]
    [<76c5db53>] wl1271_op_add_interface+0x4a4/0x8f4 [wlcore]
    [<cbf30777>] drv_add_interface+0xa4/0x1a0 [mac80211]
    [<65bac325>] ieee80211_reconfig+0x9c0/0x1644 [mac80211]
    [<2817c80e>] ieee80211_restart_work+0x90/0xc8 [mac80211]
    [<7e1d425a>] process_one_work+0x284/0x42c
    [<55f9432e>] worker_thread+0x2fc/0x48c
    [<abb582c6>] kthread+0x148/0x160
    [<63144b13>] ret_from_fork+0x14/0x2c
    [< (null)>] (null)
    [<1f6e7715>] 0xffffffff

Signed-off-by: Zumeng Chen <zumeng.chen@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ti/wlcore/main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 19e3c5a0b715..2ca5658bbc2a 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1084,8 +1084,11 @@ static int wl12xx_chip_wakeup(struct wl1271 *wl, bool plt)
 		goto out;
 
 	ret = wl12xx_fetch_firmware(wl, plt);
-	if (ret < 0)
-		goto out;
+	if (ret < 0) {
+		kfree(wl->fw_status);
+		kfree(wl->raw_fw_status);
+		kfree(wl->tx_res_if);
+	}
 
 out:
 	return ret;
-- 
2.19.1

