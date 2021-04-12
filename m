Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E27BC433B4
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Apr 2021 16:41:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E110861042
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Apr 2021 16:41:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245702AbhDLQlj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Apr 2021 12:41:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:38886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343653AbhDLQfl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Apr 2021 12:35:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9A22613D9;
        Mon, 12 Apr 2021 16:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244823;
        bh=iSCjhrH7qXR9SQ2svIa8dIQK+hhdiCawt2RDAuaR1As=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WJsYjGaQMV92kfmwp+veHpbPZnAYQlqC5CqDlpgZZvBpAZx06TGdoYcxnPKQLnjmT
         pYDbAnXSMw38+Lgmt6iLGJ86An90iqHD+AvbpzFCGjLHyDwriIYjhJt+7UPKnCskKj
         Sd0+HCXl7L9mmMVJ5HKCTsHk0nlT3r1+Wkh2/JQx0JypwLJoBaerFVYZdM0ww2JetR
         UWb+6TiLb7096CJBh+6d6S0Fg/OICBGRmGSoYjSrsf4FXnpmIYCR0tZfNx7a3dgAj6
         CejwTWsUXzPa2+07bORng7XgSHifxnWrhu7bnGsfQmJksCHs0JDvR9vXQl9b2VoZAq
         /tPQkPO2TtEaQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Du Cheng <ducheng2@gmail.com>,
        syzbot+5f9392825de654244975@syzkaller.appspotmail.com,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 25/25] cfg80211: remove WARN_ON() in cfg80211_sme_connect
Date:   Mon, 12 Apr 2021 12:26:30 -0400
Message-Id: <20210412162630.315526-25-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162630.315526-1-sashal@kernel.org>
References: <20210412162630.315526-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Du Cheng <ducheng2@gmail.com>

[ Upstream commit 1b5ab825d9acc0f27d2f25c6252f3526832a9626 ]

A WARN_ON(wdev->conn) would trigger in cfg80211_sme_connect(), if multiple
send_msg(NL80211_CMD_CONNECT) system calls are made from the userland, which
should be anticipated and handled by the wireless driver. Remove this WARN_ON()
to prevent kernel panic if kernel is configured to "panic_on_warn".

Bug reported by syzbot.

Reported-by: syzbot+5f9392825de654244975@syzkaller.appspotmail.com
Signed-off-by: Du Cheng <ducheng2@gmail.com>
Link: https://lore.kernel.org/r/20210407162756.6101-1-ducheng2@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/sme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 8344153800e2..c9158360154a 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -530,7 +530,7 @@ static int cfg80211_sme_connect(struct wireless_dev *wdev,
 		cfg80211_sme_free(wdev);
 	}
 
-	if (WARN_ON(wdev->conn))
+	if (wdev->conn)
 		return -EINPROGRESS;
 
 	wdev->conn = kzalloc(sizeof(*wdev->conn), GFP_KERNEL);
-- 
2.30.2

