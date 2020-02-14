Return-Path: <SRS0=dpF5=4C=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA159C3B1A1
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Feb 2020 16:43:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 941852187F
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Feb 2020 16:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581698616;
	bh=itWkoEn71T71AO/soIL9Y/hO0hjGCrgB5AHWBByO/GU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ORT/JD6FTtro1cSo0T4rOADHgdkoUVAYlIteH3gmLBqJOIEHfldEno0RTSoW+rd5A
	 wujjh4cY7IYbFMerMtw23a55+38s+Bxoa+YgNDsmqtz+cGqUmZA1FqvJfgFB9o+8Jq
	 1CazDkiTann/Jth0R9pBK+rCFzY6dy4OYCX4L/G8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393160AbgBNQWA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 14 Feb 2020 11:22:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:56972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393148AbgBNQV6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Feb 2020 11:21:58 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31CB2246C5;
        Fri, 14 Feb 2020 16:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697318;
        bh=itWkoEn71T71AO/soIL9Y/hO0hjGCrgB5AHWBByO/GU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0yX6IxO3hbkqhtw9o8hof2k7aYKRJOYRtmHAM8v1jyB7DZZQF6xycV3KbM9HTe84g
         z4o2cKjOaxSHpFTkYxYVZMhQX6tfOpVBnThJQSSMsXhqvqKckS0gMqMKRuUvwrdOZ1
         6PV45hWbHpqENynRevWbyzhdkDgR0/oQIe2xhD9E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicolai Stange <nstange@suse.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 028/141] libertas: don't exit from lbs_ibss_join_existing() with RCU read lock held
Date:   Fri, 14 Feb 2020 11:19:28 -0500
Message-Id: <20200214162122.19794-28-sashal@kernel.org>
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

[ Upstream commit c7bf1fb7ddca331780b9a733ae308737b39f1ad4 ]

Commit e5e884b42639 ("libertas: Fix two buffer overflows at parsing bss
descriptor") introduced a bounds check on the number of supplied rates to
lbs_ibss_join_existing().

Unfortunately, it introduced a return path from within a RCU read side
critical section without a corresponding rcu_read_unlock(). Fix this.

Fixes: e5e884b42639 ("libertas: Fix two buffer overflows at parsing bss descriptor")
Signed-off-by: Nicolai Stange <nstange@suse.de>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/libertas/cfg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/marvell/libertas/cfg.c b/drivers/net/wireless/marvell/libertas/cfg.c
index 3eab802c7d3f3..0b61942fedd90 100644
--- a/drivers/net/wireless/marvell/libertas/cfg.c
+++ b/drivers/net/wireless/marvell/libertas/cfg.c
@@ -1859,6 +1859,7 @@ static int lbs_ibss_join_existing(struct lbs_private *priv,
 		rates_max = rates_eid[1];
 		if (rates_max > MAX_RATES) {
 			lbs_deb_join("invalid rates");
+			rcu_read_unlock();
 			goto out;
 		}
 		rates = cmd.bss.rates;
-- 
2.20.1

