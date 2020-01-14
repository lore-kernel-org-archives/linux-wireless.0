Return-Path: <SRS0=6QfK=3D=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB646C33CB3
	for <linux-wireless@archiver.kernel.org>; Tue, 14 Jan 2020 10:39:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B325524672
	for <linux-wireless@archiver.kernel.org>; Tue, 14 Jan 2020 10:39:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729433AbgANKjz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 14 Jan 2020 05:39:55 -0500
Received: from mx2.suse.de ([195.135.220.15]:45600 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729399AbgANKjy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Jan 2020 05:39:54 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 604B3ACA0;
        Tue, 14 Jan 2020 10:39:52 +0000 (UTC)
From:   Nicolai Stange <nstange@suse.de>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Wen Huang <huangwenabc@gmail.com>,
        Nicolai Stange <nstange@suse.de>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>, Miroslav Benes <mbenes@suse.cz>
Subject: [PATCH 2/2] libertas: make lbs_ibss_join_existing() return error code on rates overflow
Date:   Tue, 14 Jan 2020 11:39:03 +0100
Message-Id: <20200114103903.2336-3-nstange@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200114103903.2336-1-nstange@suse.de>
References: <87woa04t2v.fsf@suse.de>
 <20200114103903.2336-1-nstange@suse.de>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Commit e5e884b42639 ("libertas: Fix two buffer overflows at parsing bss
descriptor") introduced a bounds check on the number of supplied rates to
lbs_ibss_join_existing() and made it to return on overflow.

However, the aforementioned commit doesn't set the return value accordingly
and thus, lbs_ibss_join_existing() would return with zero even though it
failed.

Make lbs_ibss_join_existing return -EINVAL in case the bounds check on the
number of supplied rates fails.

Fixes: e5e884b42639 ("libertas: Fix two buffer overflows at parsing bss
                      descriptor")
Signed-off-by: Nicolai Stange <nstange@suse.de>
---
 drivers/net/wireless/marvell/libertas/cfg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/marvell/libertas/cfg.c b/drivers/net/wireless/marvell/libertas/cfg.c
index 68985d766349..4e3de684928b 100644
--- a/drivers/net/wireless/marvell/libertas/cfg.c
+++ b/drivers/net/wireless/marvell/libertas/cfg.c
@@ -1786,6 +1786,7 @@ static int lbs_ibss_join_existing(struct lbs_private *priv,
 		if (rates_max > MAX_RATES) {
 			lbs_deb_join("invalid rates");
 			rcu_read_unlock();
+			ret = -EINVAL;
 			goto out;
 		}
 		rates = cmd.bss.rates;
-- 
2.16.4

