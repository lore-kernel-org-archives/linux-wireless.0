Return-Path: <SRS0=oqKg=3N=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E277C2D0DB
	for <linux-wireless@archiver.kernel.org>; Fri, 24 Jan 2020 14:29:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCBFD2077C
	for <linux-wireless@archiver.kernel.org>; Fri, 24 Jan 2020 14:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579876154;
	bh=Le2GyrE1tocvcCAb0URGRUi/5wyXZGjo2SaBa3UdYrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=0NWqeik5tB8sONcpXsYmSyLyvxZ9XEZxPb+xOknGRhujBMlaxEl1ocfdZbYaU7Ab8
	 6U83cDUiQQBnliN8RLOqAU3AFskLSIxDAG2dzsGn0gZVc22BEq4xRQzXkg0gls0608
	 /Ay9mfXH+QwfrN/SCtubQBuez8HjabP/A44ChSY8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391037AbgAXO3C (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 24 Jan 2020 09:29:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:42430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392165AbgAXOVB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Jan 2020 09:21:01 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E496B2087E;
        Fri, 24 Jan 2020 14:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875660;
        bh=Le2GyrE1tocvcCAb0URGRUi/5wyXZGjo2SaBa3UdYrs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dwQviSC/bMjWep0Q8i62Z2OxO35skdVTFYgId82ID0tBYvLY41g2H2jn66MABFS68
         Ple5qvOoJ1IV01CYKk0SUmdWH9TQ+kMaIXRuqzcah7fMbxDrVYOkbtUquOlLD2+JXR
         Fga39KKb5lSquSnX37Q3Uxe+U1YCxJJk+KVuJiMY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        syzbot+e8a797964a4180eb57d5@syzkaller.appspotmail.com,
        syzbot+34b582cf32c1db008f8e@syzkaller.appspotmail.com,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 41/56] cfg80211: check for set_wiphy_params
Date:   Fri, 24 Jan 2020 09:19:57 -0500
Message-Id: <20200124142012.29752-41-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124142012.29752-1-sashal@kernel.org>
References: <20200124142012.29752-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 24953de0a5e31dcca7e82c8a3c79abc2dfe8fb6e ]

Check if set_wiphy_params is assigned and return an error if not,
some drivers (e.g. virt_wifi where syzbot reported it) don't have
it.

Reported-by: syzbot+e8a797964a4180eb57d5@syzkaller.appspotmail.com
Reported-by: syzbot+34b582cf32c1db008f8e@syzkaller.appspotmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Link: https://lore.kernel.org/r/20200113125358.ac07f276efff.Ibd85ee1b12e47b9efb00a2adc5cd3fac50da791a@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/rdev-ops.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 16dad14aabd7c..a8c58aeb9dde9 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -537,6 +537,10 @@ static inline int
 rdev_set_wiphy_params(struct cfg80211_registered_device *rdev, u32 changed)
 {
 	int ret;
+
+	if (!rdev->ops->set_wiphy_params)
+		return -EOPNOTSUPP;
+
 	trace_rdev_set_wiphy_params(&rdev->wiphy, changed);
 	ret = rdev->ops->set_wiphy_params(&rdev->wiphy, changed);
 	trace_rdev_return_int(&rdev->wiphy, ret);
-- 
2.20.1

