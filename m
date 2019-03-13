Return-Path: <SRS0=EMXR=RQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A92FCC43381
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 19:30:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7275A2075C
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 19:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552505447;
	bh=c2HUv8/0cgEKg+1TA/chHORLaO1npFiBLFmYD92ruCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=p33mIgwZNWk8SeAm7RogLfgIyM9yWPzCKxkRzh4xt8j1kZpQmHmpsFvTnYzFtK3LY
	 rbDGm1ikOWoJgIBQEnK476qpjBGzjSZoxwJkkWDiis0hHyhYPZUDO4R/Qsbpg/GPFl
	 JZlcC+px5lZL0pLRB3uZ0oqV80zdX0dHFF8UZefk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728020AbfCMTak (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Mar 2019 15:30:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:43008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726639AbfCMTMZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Mar 2019 15:12:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DC49213A2;
        Wed, 13 Mar 2019 19:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552504345;
        bh=c2HUv8/0cgEKg+1TA/chHORLaO1npFiBLFmYD92ruCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1dKj9SAIACvr/HalmXN03y4sKcko7QTSuKH3jCIbysez1alC0uMgt3T95NIjinBW8
         Ug+b6bxLTsn+Tawku6tZ61GjwxU54RFrObwDiqyRnM0zbCdmPAPQ2h+jLmpbCl2R+K
         dZmT0uJyAyLTxrqm8RwwiM0U5v4TaiUTrXrKXt8s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Li RongQing <lirongqing@baidu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.20 50/60] mac80211_hwsim: propagate genlmsg_reply return code
Date:   Wed, 13 Mar 2019 15:10:11 -0400
Message-Id: <20190313191021.158171-50-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190313191021.158171-1-sashal@kernel.org>
References: <20190313191021.158171-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 17407715240456448e4989bee46ffc93991add83 ]

genlmsg_reply can fail, so propagate its return code

Signed-off-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mac80211_hwsim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index d1464e3e1be2..47a4610e7a5b 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -3449,7 +3449,7 @@ static int hwsim_get_radio_nl(struct sk_buff *msg, struct genl_info *info)
 			goto out_err;
 		}
 
-		genlmsg_reply(skb, info);
+		res = genlmsg_reply(skb, info);
 		break;
 	}
 
-- 
2.19.1

