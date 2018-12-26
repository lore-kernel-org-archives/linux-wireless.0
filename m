Return-Path: <SRS0=rEuJ=PD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 743FCC43387
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Dec 2018 22:48:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4248B214D8
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Dec 2018 22:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1545864482;
	bh=TxwReZtWs8NJFyzYUWDbeGCB+0EjbtrSmOxeHT8RxXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=2iuXETZS8lIaRUowQ8XQB5DymvQgtOGCIQ9g18OXC2vtQ+FGpmKX2O6DTtBV7Eeqq
	 SlstUbfPlwwPxDyJ7km/HofHY1Q7ru52N1e9YbQ2nsmZdbXoZqTUeh1re80nyuRtpY
	 0ygNZzhen/1bu0mcIqCMwV1345x1FKXGJXBJTg4k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729717AbeLZWrz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 26 Dec 2018 17:47:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:38480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728710AbeLZWiN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Dec 2018 17:38:13 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B0DB21741;
        Wed, 26 Dec 2018 22:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1545863892;
        bh=TxwReZtWs8NJFyzYUWDbeGCB+0EjbtrSmOxeHT8RxXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uJrJ8ovjpYelM3KjG7t7E6Hxdw8vdo8Am1lKjywygHY3ipDebELUnrtctXTAlbLbB
         dyCd7Nf0t+GvrL3S+7iVFhLP9mIS2CMA7SOPu/DgagVvKEDFfZld7JBsH/0UET4POG
         w8WSenFG3JSVb0mwtJWl4+1UVf6zAmyY5Qdr/0j4=
From:   Sasha Levin <sashal@kernel.org>
To:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 80/97] nl80211: fix memory leak if validate_pae_over_nl80211() fails
Date:   Wed, 26 Dec 2018 17:35:40 -0500
Message-Id: <20181226223557.149329-80-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181226223557.149329-1-sashal@kernel.org>
References: <20181226223557.149329-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit d350a0f431189517b1af0dbbb605c273231a8966 ]

If validate_pae_over_nl80211() were to fail in nl80211_crypto_settings(),
we might leak the 'connkeys' allocation. Fix this.

Fixes: 64bf3d4bc2b0 ("nl80211: Add CONTROL_PORT_OVER_NL80211 attribute")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 176edfefcbaa..295cd8d5554f 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -8993,8 +8993,10 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 	if (info->attrs[NL80211_ATTR_CONTROL_PORT_OVER_NL80211]) {
 		int r = validate_pae_over_nl80211(rdev, info);
 
-		if (r < 0)
+		if (r < 0) {
+			kzfree(connkeys);
 			return r;
+		}
 
 		ibss.control_port_over_nl80211 = true;
 	}
-- 
2.19.1

