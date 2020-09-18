Return-Path: <SRS0=efDY=C3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0713FC43465
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Sep 2020 02:39:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C47EC23770
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Sep 2020 02:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600396770;
	bh=gizUYms1avGM+a5KK5WcbtwwMjQvvFthjI3iF6v7Uz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=iQH1hnSRlgBXfRhER5HAMiX7iaIyzAOk8RZci4UvVK9FXa9+X4di+vcbhSl2+p3bg
	 TUxPYjk8BuBlhwQZtDHWn/vRHLX9TWVGBbzgz2euAzogggL5EklJUqT+IRi6pX5Wne
	 RWP1C3pzM4iXOPeP6VFmm8JiZwuYvDzIW/ujZmuo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728706AbgIRCL7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 17 Sep 2020 22:11:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:37808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728689AbgIRCLx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Sep 2020 22:11:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA43121582;
        Fri, 18 Sep 2020 02:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395112;
        bh=gizUYms1avGM+a5KK5WcbtwwMjQvvFthjI3iF6v7Uz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qVeQ0ViPiZLDzoQqe2IWHrUaH52RigjGmOM6aKXBhd7KALsWwTNSAjEXolD1oeji+
         Dj7xSfLo1Ze7WUvW5ihQNfqmDTF/FwYuOHcRezoDaNozvVBjcLHHdPI7GG0wDemKuF
         dXgrNO4ITXLTC5sWGZr4FnxSmlO6YJhmVKWABRIg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Tony Lindgren <tony@atomide.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 186/206] wlcore: fix runtime pm imbalance in wl1271_tx_work
Date:   Thu, 17 Sep 2020 22:07:42 -0400
Message-Id: <20200918020802.2065198-186-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 9604617e998b49f7695fea1479ed82421ef8c9f0 ]

There are two error handling paths in this functon. When
wlcore_tx_work_locked() returns an error code, we should
decrease the runtime PM usage counter the same way as the
error handling path beginning from pm_runtime_get_sync().

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Acked-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200520124241.9931-1-dinghao.liu@zju.edu.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ti/wlcore/tx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index b6e19c2d66b0a..250bcbf4ea2f2 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -877,6 +877,7 @@ void wl1271_tx_work(struct work_struct *work)
 
 	ret = wlcore_tx_work_locked(wl);
 	if (ret < 0) {
+		pm_runtime_put_noidle(wl->dev);
 		wl12xx_queue_recovery_work(wl);
 		goto out;
 	}
-- 
2.25.1

