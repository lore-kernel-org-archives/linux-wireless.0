Return-Path: <SRS0=dvfj=ZF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 334A2C43331
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Nov 2019 02:26:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0AFBB20693
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Nov 2019 02:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573612008;
	bh=Won7SlOQeI+Zv/jE+G+dXFjBkqoZGFbtpIQEj4ENMVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=HR7dqhc7aK0kbmi+l3HPHMla3jgOR5Fr7egLhgoHHGk725Qod2g3KeBIJ3nRDltFx
	 hOD7ff0vmGqSLS3idSLYxkpYBEw3oIX/9e9LPnePICI1suFQxJ7mpdueX+nOTxY0Eu
	 py+M8nfSL6wpviZMNqoBY7+DiCTmWQykPgJWv754=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730488AbfKMC0m (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Nov 2019 21:26:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:38668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727736AbfKMBvN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Nov 2019 20:51:13 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CF7F222D3;
        Wed, 13 Nov 2019 01:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573609873;
        bh=Won7SlOQeI+Zv/jE+G+dXFjBkqoZGFbtpIQEj4ENMVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uJGJuScqCyNjsQpQxAa4fRL/39dGOZprNbAmfPBofIJwCYrnHxkOX5yyXSUdjtzQM
         IuEwQm4FNGHrqZVzlzxSUxcAIDiIQvnBqqjIiw0B1BKyVHYHA/Mol1Z/P4cVFbQ5F9
         003PNPm1dIsoAUolU8jrA4bS0zwymcTVAePuGa6s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrew Zaborowski <andrew.zaborowski@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 036/209] nl80211: Fix a GET_KEY reply attribute
Date:   Tue, 12 Nov 2019 20:47:32 -0500
Message-Id: <20191113015025.9685-36-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Andrew Zaborowski <andrew.zaborowski@intel.com>

[ Upstream commit efdfce7270de85a8706d1ea051bef3a7486809ff ]

Use the NL80211_KEY_IDX attribute inside the NL80211_ATTR_KEY in
NL80211_CMD_GET_KEY responses to comply with nl80211_key_policy.
This is unlikely to affect existing userspace.

Signed-off-by: Andrew Zaborowski <andrew.zaborowski@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 2ef1f56504cbb..5075fd293febb 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3396,7 +3396,7 @@ static void get_key_callback(void *c, struct key_params *params)
 			 params->cipher)))
 		goto nla_put_failure;
 
-	if (nla_put_u8(cookie->msg, NL80211_ATTR_KEY_IDX, cookie->idx))
+	if (nla_put_u8(cookie->msg, NL80211_KEY_IDX, cookie->idx))
 		goto nla_put_failure;
 
 	nla_nest_end(cookie->msg, key);
-- 
2.20.1

