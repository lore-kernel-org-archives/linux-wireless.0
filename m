Return-Path: <SRS0=LENq=3F=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20A10C33CAF
	for <linux-wireless@archiver.kernel.org>; Thu, 16 Jan 2020 18:19:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EEEC720730
	for <linux-wireless@archiver.kernel.org>; Thu, 16 Jan 2020 18:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579198781;
	bh=9jFjZ5bu+tsaBRyIe6orZnczu0wyPfyxbPpkonaWPQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=W0O53bUV29gujLzPflEXcD84a7oJspyI6Og56Htr9QgpmkFNoi7wbpOIeXJ8ulFX7
	 XGMJPB63W1tcg7j2XHExFr/Z9fc+SRPe3HPFv4wKt0ksGchve1JTigh8yT4Eh0KqMJ
	 DTnChGvtf5tCCUHDzqGKGRwNZhLQ8Vn5j6HDDdss=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392560AbgAPR20 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 16 Jan 2020 12:28:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:39450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404213AbgAPR2Y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Jan 2020 12:28:24 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E00BB246D3;
        Thu, 16 Jan 2020 17:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195704;
        bh=9jFjZ5bu+tsaBRyIe6orZnczu0wyPfyxbPpkonaWPQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iW9/3SYbmECG92M9oSb8Ys1mfai3SOD4mrS2z8/gBbxWHoTzOXJ6rnqMR/WYGgrHu
         byGtGimaVw8ZoMXTwIQrNX0g/kgcx9TC7dItuvjAnMHF/rhw+Fs2Aogn4kKtzKfXFM
         dc5vusEknMG8z7cvW9IaNrYJQ+J49s6Tqeecre/Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 251/371] libertas_tf: Use correct channel range in lbtf_geo_init
Date:   Thu, 16 Jan 2020 12:22:03 -0500
Message-Id: <20200116172403.18149-194-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 2ec4ad49b98e4a14147d04f914717135eca7c8b1 ]

It seems we should use 'range' instead of 'priv->range'
in lbtf_geo_init(), because 'range' is the corret one
related to current regioncode.

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: 691cdb49388b ("libertas_tf: command helper functions for libertas_tf")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/libertas_tf/cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/libertas_tf/cmd.c b/drivers/net/wireless/marvell/libertas_tf/cmd.c
index 909ac3685010..2b193f1257a5 100644
--- a/drivers/net/wireless/marvell/libertas_tf/cmd.c
+++ b/drivers/net/wireless/marvell/libertas_tf/cmd.c
@@ -69,7 +69,7 @@ static void lbtf_geo_init(struct lbtf_private *priv)
 			break;
 		}
 
-	for (ch = priv->range.start; ch < priv->range.end; ch++)
+	for (ch = range->start; ch < range->end; ch++)
 		priv->channels[CHAN_TO_IDX(ch)].flags = 0;
 }
 
-- 
2.20.1

