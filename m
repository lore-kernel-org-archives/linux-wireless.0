Return-Path: <SRS0=kZdm=TH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	T_DKIMWL_WL_HIGH,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5826DC004C9
	for <linux-wireless@archiver.kernel.org>; Tue,  7 May 2019 05:36:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2908A21479
	for <linux-wireless@archiver.kernel.org>; Tue,  7 May 2019 05:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1557207379;
	bh=DP+cp4kWbbrvzRa8576r/rkPM2rH+Xn1vnpehE8E6Kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=OQh3JEP7eFmGZDnNJ+OMYxd5gG6fiZnud1PM3fctUGnfR2tX/uwrgXuIbXsGy4Bdq
	 kisGlsaYQeYtpFN0NCf5D6WCD339iW8EaOQmuZ/Fc4rvC3SgjXqaocoPHKtkg3rglD
	 p6t2/eO8vsgrNjgCRmxRDtoljSlCXSHROLVJ69v4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728050AbfEGFgR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 7 May 2019 01:36:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:56270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728034AbfEGFgQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 May 2019 01:36:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 323F320989;
        Tue,  7 May 2019 05:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207375;
        bh=DP+cp4kWbbrvzRa8576r/rkPM2rH+Xn1vnpehE8E6Kc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OiZA5+woQ5WYMcMWra/AmZ64iPBs/z+6e0TOJeLB4ARxu2oeIuUIG4YUc7Gpm0qGx
         ZBdN8x3APAQ59ItP8AVby50SBDASszROtFp9ailVH4wUvychJlrzvlsXDnPLwZUFfQ
         LZBtsXwAjH0/nDae7i80/Mfrx3SekBZjRLMs7jMk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sunil Dutt <usdutt@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 15/81] nl80211: Add NL80211_FLAG_CLEAR_SKB flag for other NL commands
Date:   Tue,  7 May 2019 01:34:46 -0400
Message-Id: <20190507053554.30848-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053554.30848-1-sashal@kernel.org>
References: <20190507053554.30848-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sunil Dutt <usdutt@codeaurora.org>

[ Upstream commit d6db02a88a4aaa1cd7105137c67ddec7f3bdbc05 ]

This commit adds NL80211_FLAG_CLEAR_SKB flag to other NL commands
that carry key data to ensure they do not stick around on heap
after the SKB is freed.

Also introduced this flag for NL80211_CMD_VENDOR as there are sub
commands which configure the keys.

Signed-off-by: Sunil Dutt <usdutt@codeaurora.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 295cd8d5554f..048e004ed0ee 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -13392,7 +13392,8 @@ static const struct genl_ops nl80211_ops[] = {
 		.policy = nl80211_policy,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
-				  NL80211_FLAG_NEED_RTNL,
+				  NL80211_FLAG_NEED_RTNL |
+				  NL80211_FLAG_CLEAR_SKB,
 	},
 	{
 		.cmd = NL80211_CMD_DEAUTHENTICATE,
@@ -13443,7 +13444,8 @@ static const struct genl_ops nl80211_ops[] = {
 		.policy = nl80211_policy,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
-				  NL80211_FLAG_NEED_RTNL,
+				  NL80211_FLAG_NEED_RTNL |
+				  NL80211_FLAG_CLEAR_SKB,
 	},
 	{
 		.cmd = NL80211_CMD_UPDATE_CONNECT_PARAMS,
@@ -13451,7 +13453,8 @@ static const struct genl_ops nl80211_ops[] = {
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
-				  NL80211_FLAG_NEED_RTNL,
+				  NL80211_FLAG_NEED_RTNL |
+				  NL80211_FLAG_CLEAR_SKB,
 	},
 	{
 		.cmd = NL80211_CMD_DISCONNECT,
@@ -13480,7 +13483,8 @@ static const struct genl_ops nl80211_ops[] = {
 		.policy = nl80211_policy,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
-				  NL80211_FLAG_NEED_RTNL,
+				  NL80211_FLAG_NEED_RTNL |
+				  NL80211_FLAG_CLEAR_SKB,
 	},
 	{
 		.cmd = NL80211_CMD_DEL_PMKSA,
@@ -13832,7 +13836,8 @@ static const struct genl_ops nl80211_ops[] = {
 		.policy = nl80211_policy,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_WIPHY |
-				  NL80211_FLAG_NEED_RTNL,
+				  NL80211_FLAG_NEED_RTNL |
+				  NL80211_FLAG_CLEAR_SKB,
 	},
 	{
 		.cmd = NL80211_CMD_SET_QOS_MAP,
@@ -13887,7 +13892,8 @@ static const struct genl_ops nl80211_ops[] = {
 		.doit = nl80211_set_pmk,
 		.policy = nl80211_policy,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
-				  NL80211_FLAG_NEED_RTNL,
+				  NL80211_FLAG_NEED_RTNL |
+				  NL80211_FLAG_CLEAR_SKB,
 	},
 	{
 		.cmd = NL80211_CMD_DEL_PMK,
-- 
2.20.1

