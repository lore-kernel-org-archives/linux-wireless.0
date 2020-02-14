Return-Path: <SRS0=dpF5=4C=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCC3DC3B1A1
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Feb 2020 16:43:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94EEC2187F
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Feb 2020 16:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581698621;
	bh=1ywl+QwAdgWilFw5oOkBA3uu1fQkNbjoTatcUAqUP/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=rtGAk2erRyyr9gDlleTO/7NobTXfe10NyAykul0QzkeswrCfiaWU4/f6j7uGVDBEL
	 s36EMvMzj8kurTldBvPPKi/uHmfJHuddf3P7Cw26Zc0rVOWCWRVQm68OBBTvwxnzcV
	 hTK9lrNydoLP1gHKjLOvjzJTYnkogFUBEtgy5R7Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394036AbgBNQnh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 14 Feb 2020 11:43:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:56992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393153AbgBNQWA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Feb 2020 11:22:00 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77D73246B7;
        Fri, 14 Feb 2020 16:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697319;
        bh=1ywl+QwAdgWilFw5oOkBA3uu1fQkNbjoTatcUAqUP/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nJlhHNersyFIlfOLrx9DH2AYpkT3GRpBy/GnGsSI7NfWOcIUi01EHZk75wswB8XiY
         Uw9gQ2+fWgwDwxi22p9ds40hwsgJQtzwPz0HAYRvskEDTbS3q7omh510/cZHVmHpMe
         mVCTKZ6XPsr0haIFGr5Rw3M8828ng56jgfTSzBRw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicolai Stange <nstange@suse.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 029/141] libertas: make lbs_ibss_join_existing() return error code on rates overflow
Date:   Fri, 14 Feb 2020 11:19:29 -0500
Message-Id: <20200214162122.19794-29-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214162122.19794-1-sashal@kernel.org>
References: <20200214162122.19794-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Nicolai Stange <nstange@suse.de>

[ Upstream commit 1754c4f60aaf1e17d886afefee97e94d7f27b4cb ]

Commit e5e884b42639 ("libertas: Fix two buffer overflows at parsing bss
descriptor") introduced a bounds check on the number of supplied rates to
lbs_ibss_join_existing() and made it to return on overflow.

However, the aforementioned commit doesn't set the return value accordingly
and thus, lbs_ibss_join_existing() would return with zero even though it
failed.

Make lbs_ibss_join_existing return -EINVAL in case the bounds check on the
number of supplied rates fails.

Fixes: e5e884b42639 ("libertas: Fix two buffer overflows at parsing bss descriptor")
Signed-off-by: Nicolai Stange <nstange@suse.de>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/libertas/cfg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/marvell/libertas/cfg.c b/drivers/net/wireless/marvell/libertas/cfg.c
index 0b61942fedd90..ece6d72cf90c8 100644
--- a/drivers/net/wireless/marvell/libertas/cfg.c
+++ b/drivers/net/wireless/marvell/libertas/cfg.c
@@ -1860,6 +1860,7 @@ static int lbs_ibss_join_existing(struct lbs_private *priv,
 		if (rates_max > MAX_RATES) {
 			lbs_deb_join("invalid rates");
 			rcu_read_unlock();
+			ret = -EINVAL;
 			goto out;
 		}
 		rates = cmd.bss.rates;
-- 
2.20.1

