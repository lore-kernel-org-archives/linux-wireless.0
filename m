Return-Path: <SRS0=dpF5=4C=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4E75C2BA83
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Feb 2020 17:34:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F070222C4
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Feb 2020 17:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581701675;
	bh=JjKT3jkmYWo+VH1cMi7pE58cT6ZhUpPjOMoPMHW4uHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=mYny5FTLQe+vuCgkxA6BFczIwMLO1NGynU3xwgaU+Yn/kLC5VDC1kTSN5SAcI4KJW
	 3IHiGYV1/5Us3fbHKICUdGWw1ZqdjxAQWeoTMonaKrbNPLbiPBFx7JjWNUpCuKzvgY
	 j3Yh1eehMtTqhHKRhzWqjLFeHdwYp928PFdN/JQU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394745AbgBNRee (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 14 Feb 2020 12:34:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:56422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390326AbgBNQGI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Feb 2020 11:06:08 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D0C524680;
        Fri, 14 Feb 2020 16:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696368;
        bh=JjKT3jkmYWo+VH1cMi7pE58cT6ZhUpPjOMoPMHW4uHA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BtiGyvs1zTt9mfVT2qEgwWcLicSiN/lyRscvmaOGU1hIxmY9wr2CKdY0yALXeDvg0
         gDYppxZSEFut5g8cftcGeBmMfuVfFlV4adYDC7HL2Ic4dWywe8DTgFufejp6xng/ea
         FXoB3qNSugGQUpe9i11OsuA550z2c7EW2Yfb7zb0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Phong Tran <tranmanphong@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Kees Cook <keescook@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 198/459] b43legacy: Fix -Wcast-function-type
Date:   Fri, 14 Feb 2020 10:57:28 -0500
Message-Id: <20200214160149.11681-198-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Phong Tran <tranmanphong@gmail.com>

[ Upstream commit 475eec112e4267232d10f4afe2f939a241692b6c ]

correct usage prototype of callback in tasklet_init().
Report by https://github.com/KSPP/linux/issues/20

Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Phong Tran <tranmanphong@gmail.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/b43legacy/main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/b43legacy/main.c b/drivers/net/wireless/broadcom/b43legacy/main.c
index 4325e91736eb3..8b6b657c4b85b 100644
--- a/drivers/net/wireless/broadcom/b43legacy/main.c
+++ b/drivers/net/wireless/broadcom/b43legacy/main.c
@@ -1275,8 +1275,9 @@ static void handle_irq_ucode_debug(struct b43legacy_wldev *dev)
 }
 
 /* Interrupt handler bottom-half */
-static void b43legacy_interrupt_tasklet(struct b43legacy_wldev *dev)
+static void b43legacy_interrupt_tasklet(unsigned long data)
 {
+	struct b43legacy_wldev *dev = (struct b43legacy_wldev *)data;
 	u32 reason;
 	u32 dma_reason[ARRAY_SIZE(dev->dma_reason)];
 	u32 merged_dma_reason = 0;
@@ -3741,7 +3742,7 @@ static int b43legacy_one_core_attach(struct ssb_device *dev,
 	b43legacy_set_status(wldev, B43legacy_STAT_UNINIT);
 	wldev->bad_frames_preempt = modparam_bad_frames_preempt;
 	tasklet_init(&wldev->isr_tasklet,
-		     (void (*)(unsigned long))b43legacy_interrupt_tasklet,
+		     b43legacy_interrupt_tasklet,
 		     (unsigned long)wldev);
 	if (modparam_pio)
 		wldev->__using_pio = true;
-- 
2.20.1

