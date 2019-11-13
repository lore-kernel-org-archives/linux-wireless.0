Return-Path: <SRS0=dvfj=ZF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BA65C43331
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Nov 2019 02:15:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D54921783
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Nov 2019 02:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573611346;
	bh=N/YrXusPb2G9RCgcBFHvHfCVYPhvcbkrrCUUliW9ALo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=aQPUNt9mGcSqCVGzigcFXBDGJM1SCfX+tmeWe0RrI5Rj6+ckNFYTnABCTO+wn3sbT
	 5A4mRH1Bm6FHDEzoW/ueyYV02Gu6XXbqUOvPoq0ujmOggZ0jkU0UMdG5Jsrfmdor2k
	 2su+ItjEBxDS6pvl1F8YTo9wVo7tDRcqkEJno6aE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730033AbfKMCPg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Nov 2019 21:15:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:49528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728595AbfKMB4u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Nov 2019 20:56:50 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F13F0222D4;
        Wed, 13 Nov 2019 01:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610209;
        bh=N/YrXusPb2G9RCgcBFHvHfCVYPhvcbkrrCUUliW9ALo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w1kQW83QXRbojMp5xXQUHrA/OpFUQwDYxlUcaBUGTtIDYQ1x6JacZIvOVlKU6IMrv
         jSxmdEsn4Z8zI4Gy6mNEVsr+hTk6IYCcEPsTA14TSxRJ9JJTZoM/HrJJn/42xLWONK
         7Bija0/m2xY/WUp9ZM2TrrtSASimAYn/jqiqqD8Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrew Zaborowski <andrew.zaborowski@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 019/115] nl80211: Fix a GET_KEY reply attribute
Date:   Tue, 12 Nov 2019 20:54:46 -0500
Message-Id: <20191113015622.11592-19-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015622.11592-1-sashal@kernel.org>
References: <20191113015622.11592-1-sashal@kernel.org>
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
index 9627c52c3f937..df8c5312f26ad 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3118,7 +3118,7 @@ static void get_key_callback(void *c, struct key_params *params)
 			 params->cipher)))
 		goto nla_put_failure;
 
-	if (nla_put_u8(cookie->msg, NL80211_ATTR_KEY_IDX, cookie->idx))
+	if (nla_put_u8(cookie->msg, NL80211_KEY_IDX, cookie->idx))
 		goto nla_put_failure;
 
 	nla_nest_end(cookie->msg, key);
-- 
2.20.1

