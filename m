Return-Path: <SRS0=7roA=5D=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B1B4C4332B
	for <linux-wireless@archiver.kernel.org>; Wed, 18 Mar 2020 21:05:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B73A20409
	for <linux-wireless@archiver.kernel.org>; Wed, 18 Mar 2020 21:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1584565555;
	bh=7o8w++Wb1Vkov8poF0rkQiDU3EwYV55GmU8o3zPVUv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=HpCvCZVmdH0BKWFlL8dmQw0vfLpYKALVglu5BVkbdf2JyyJnRZmTtnXQ1KzrCXp3X
	 1orJRMPJeY5dQVBS6/48qEkge0VGcELuxJzGacuu0M9/wD6Pc6ow9oKJCHpeidGps/
	 Mgs/BHvtOuXuMOSw/BiNaPNstV+knrmKjANLWU1w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728350AbgCRVFv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 18 Mar 2020 17:05:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:54676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727992AbgCRUyr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Mar 2020 16:54:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9704A208FE;
        Wed, 18 Mar 2020 20:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564887;
        bh=7o8w++Wb1Vkov8poF0rkQiDU3EwYV55GmU8o3zPVUv8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pLSFx3itg7vnbR1OuP+6f9fApWDU2p/3eGSCrSmS2ZzP4hO6AWvcZqAsy6DppMpEB
         h8i4ypxCVhcfkZ48Sm9+d1xmbCr2tS7QOpa3J6w4DBSflHAH5mT//teDKeWmLwKtoR
         ITGzWhL8vum1zaHPcY0/7ymA8nvsu6v2ajvIZiHA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 56/73] nl80211: add missing attribute validation for critical protocol indication
Date:   Wed, 18 Mar 2020 16:53:20 -0400
Message-Id: <20200318205337.16279-56-sashal@kernel.org>
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

[ Upstream commit 0e1a1d853ecedc99da9d27f9f5c376935547a0e2 ]

Add missing attribute validation for critical protocol fields
to the netlink policy.

Fixes: 5de17984898c ("cfg80211: introduce critical protocol indication from user-space")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Link: https://lore.kernel.org/r/20200303051058.4089398-2-kuba@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 17514744af9e0..9ca16ca0528ac 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -530,6 +530,8 @@ const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_MDID] = { .type = NLA_U16 },
 	[NL80211_ATTR_IE_RIC] = { .type = NLA_BINARY,
 				  .len = IEEE80211_MAX_DATA_LEN },
+	[NL80211_ATTR_CRIT_PROT_ID] = { .type = NLA_U16 },
+	[NL80211_ATTR_MAX_CRIT_PROT_DURATION] = { .type = NLA_U16 },
 	[NL80211_ATTR_PEER_AID] =
 		NLA_POLICY_RANGE(NLA_U16, 1, IEEE80211_MAX_AID),
 	[NL80211_ATTR_CH_SWITCH_COUNT] = { .type = NLA_U32 },
-- 
2.20.1

