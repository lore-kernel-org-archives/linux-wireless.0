Return-Path: <SRS0=7roA=5D=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D76C4C4332D
	for <linux-wireless@archiver.kernel.org>; Wed, 18 Mar 2020 21:05:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2A1620409
	for <linux-wireless@archiver.kernel.org>; Wed, 18 Mar 2020 21:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1584565546;
	bh=eZ+Gpdfwi9pPSJke0P4s2gg5wBXTOVRai36dhbep4O0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=bvutoRwSR1hxhGnNtAmTXb1i5ZH2ETpJM56FLEs7ms9aMq40WjzMGfDkDNIKzzPFH
	 xt2uHr9w0s31ZEjUsupWnHZ/S5XSJjlJk+mR1o76w+1CV3t3TBxi2c6XCZCbnKnP8D
	 sy+NldlCLkmSarOYji9NgY8pdUa48oD0M1PimhLQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728021AbgCRUyu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 18 Mar 2020 16:54:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:54766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728005AbgCRUyu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Mar 2020 16:54:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB485208DB;
        Wed, 18 Mar 2020 20:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564889;
        bh=eZ+Gpdfwi9pPSJke0P4s2gg5wBXTOVRai36dhbep4O0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GBuJyFDIY8gf9sr4zGTXHZojZWSo4xLpHZGE36tE5hWQOVTusy1tZEqN/G4TAxM31
         W1aZL86KTXqGCRPhKw9rpmlsC1ET68OjKvMpXO/jpodIgVh7EIr25gCyh2KkLNV3nD
         GKP7sEmyvbcFdWKOo11pbcu2/vLlEKU7VNOJLIkA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 58/73] nl80211: add missing attribute validation for channel switch
Date:   Wed, 18 Mar 2020 16:53:22 -0400
Message-Id: <20200318205337.16279-58-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200318205337.16279-1-sashal@kernel.org>
References: <20200318205337.16279-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 5cde05c61cbe13cbb3fa66d52b9ae84f7975e5e6 ]

Add missing attribute validation for NL80211_ATTR_OPER_CLASS
to the netlink policy.

Fixes: 1057d35ede5d ("cfg80211: introduce TDLS channel switch commands")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Link: https://lore.kernel.org/r/20200303051058.4089398-4-kuba@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index f0c6c522964c2..321c132747ce7 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -564,6 +564,7 @@ const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 		NLA_POLICY_MAX(NLA_U8, IEEE80211_NUM_UPS - 1),
 	[NL80211_ATTR_ADMITTED_TIME] = { .type = NLA_U16 },
 	[NL80211_ATTR_SMPS_MODE] = { .type = NLA_U8 },
+	[NL80211_ATTR_OPER_CLASS] = { .type = NLA_U8 },
 	[NL80211_ATTR_MAC_MASK] = {
 		.type = NLA_EXACT_LEN_WARN,
 		.len = ETH_ALEN
-- 
2.20.1

