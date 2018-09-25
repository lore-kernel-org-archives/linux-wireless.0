Return-Path: <SRS0=9L0z=MH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAAA8C43382
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 07:51:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A4272087A
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 07:51:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6A4272087A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=strongswan.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728810AbeIYN5Z (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Sep 2018 09:57:25 -0400
Received: from sitav-80046.hsr.ch ([152.96.80.46]:57596 "EHLO
        mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727341AbeIYN5Z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Sep 2018 09:57:25 -0400
Received: from book.wlp.is (unknown [185.12.128.225])
        by mail.strongswan.org (Postfix) with ESMTPSA id CE90D404AC;
        Tue, 25 Sep 2018 09:51:13 +0200 (CEST)
From:   Martin Willi <martin@strongswan.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211_hwsim: do not omit multicast announce of first added radio
Date:   Tue, 25 Sep 2018 09:51:02 +0200
Message-Id: <20180925075102.18922-1-martin@strongswan.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The allocation of hwsim radio identifiers uses a post-increment from 0,
so the first radio has idx 0. This idx is explicitly excluded from
multicast announcements ever since, but it is unclear why.

Drop that idx check and announce the first radio as well. This makes
userspace happy if it relies on these events.

Signed-off-by: Martin Willi <martin@strongswan.org>
---
 drivers/net/wireless/mac80211_hwsim.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 70229a839c84..aa8058264d5b 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2929,8 +2929,7 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 	hwsim_radios_generation++;
 	spin_unlock_bh(&hwsim_radio_lock);
 
-	if (idx > 0)
-		hwsim_mcast_new_radio(idx, info, param);
+	hwsim_mcast_new_radio(idx, info, param);
 
 	return idx;
 
-- 
2.17.1

