Return-Path: <SRS0=EMXR=RQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3A55C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 19:24:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87D302075C
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 19:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552505053;
	bh=s0Y30+6zvvAhFwJG/9l5jEOyJ1TCFBe/4YC0Dd+0SLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=GC4zzzf82VJF4O2FQ6aMRm7m1JGu2zQh7aoGWBFwmV71c+N6dts2m3gWRHtAZvkTT
	 uqLenegGnVOW3rC2vkLacGSaxPayax7n8LpmgzVWLPXM2QV+rZixWjq/Aj4VdDswcK
	 NiLQ3g+AyayCWQfr/87ixgUAVaLNl+Kkh/TXaCdQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727947AbfCMTQe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Mar 2019 15:16:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:46894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728677AbfCMTQd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Mar 2019 15:16:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 738F32171F;
        Wed, 13 Mar 2019 19:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552504593;
        bh=s0Y30+6zvvAhFwJG/9l5jEOyJ1TCFBe/4YC0Dd+0SLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2d8Qs9e20iZ8946lRjSLlytkwSz+SZkrGdzcGKp1Juf0BrdIAYexjZnJhtc1aAuiX
         DquL1mTZaWl9M6Dy1X8PaXm9JaMGltCKY2A2I68tItfLkrC5M7MpN13ZyWu7nbR1R2
         sOB+xo0DbZy2FFfsFv5HIMTIuKaGnOxSjXrKElJ4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Li RongQing <lirongqing@baidu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 28/33] mac80211_hwsim: propagate genlmsg_reply return code
Date:   Wed, 13 Mar 2019 15:15:01 -0400
Message-Id: <20190313191506.159677-28-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190313191506.159677-1-sashal@kernel.org>
References: <20190313191506.159677-1-sashal@kernel.org>
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
index 8f57ca969c9f..27224dc26413 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -3241,7 +3241,7 @@ static int hwsim_get_radio_nl(struct sk_buff *msg, struct genl_info *info)
 			goto out_err;
 		}
 
-		genlmsg_reply(skb, info);
+		res = genlmsg_reply(skb, info);
 		break;
 	}
 
-- 
2.19.1

