Return-Path: <SRS0=oqKg=3N=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 823C5C2D0DB
	for <linux-wireless@archiver.kernel.org>; Fri, 24 Jan 2020 14:23:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CEE12072C
	for <linux-wireless@archiver.kernel.org>; Fri, 24 Jan 2020 14:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579875823;
	bh=AYy4jToqiv3bNr3KMRi79iPfG+Su12lR7mgHwR/x1Mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=biqQYxC71qcgEeZpPD/H983vW7iau/jjBmptudFGi/TfR+WUiGLTc0irK5HtM9sQt
	 iJgCg0CPgQ4GSa7KRcLfRI/tMoTMyTwJ0uqaYQzVtXCPYOAxR+Bq0UraTsx8uFz6yT
	 9FQpDGVfPfcYChte1/cAtIh6XUo05A0Pngyv1mkI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389250AbgAXOXi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 24 Jan 2020 09:23:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:44360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392339AbgAXOWS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Jan 2020 09:22:18 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3782C21734;
        Fri, 24 Jan 2020 14:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875738;
        bh=AYy4jToqiv3bNr3KMRi79iPfG+Su12lR7mgHwR/x1Mc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IXlkIzSP7OXumqCzekuE2n7fFaSqtcWuNg1g5MphmA9k4NQHZmD3W7jVcHhL3wZU6
         LKKBmmVKsC5ZrwMXWnz3sOUnDMNEteV/CVVALAsLmhcq1Gs7+w1+vMu6rVR08+lBXT
         HKcylxbl5h3lO5PZg7RBRbOfyMM33S+IDrL3WVDM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        syzbot+e8a797964a4180eb57d5@syzkaller.appspotmail.com,
        syzbot+34b582cf32c1db008f8e@syzkaller.appspotmail.com,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 16/18] cfg80211: check for set_wiphy_params
Date:   Fri, 24 Jan 2020 09:21:55 -0500
Message-Id: <20200124142157.30931-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124142157.30931-1-sashal@kernel.org>
References: <20200124142157.30931-1-sashal@kernel.org>
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
index 11cf83c8ad4f5..8cd56eaba7d6a 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -525,6 +525,10 @@ static inline int
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

