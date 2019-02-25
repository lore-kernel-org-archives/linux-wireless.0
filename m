Return-Path: <SRS0=l+aR=RA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9020C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Feb 2019 10:07:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A4D1A20842
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Feb 2019 10:07:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ZgwwaO8D";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="SBWdBolb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbfBYKHe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 25 Feb 2019 05:07:34 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:55828 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726574AbfBYKHe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Feb 2019 05:07:34 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 36C0F60A05; Mon, 25 Feb 2019 10:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551089253;
        bh=SBwvy9DQK1Muo2jIFHi8TjuWa6WwnsfCGB6yQbEdoyg=;
        h=From:To:Cc:Subject:Date:From;
        b=ZgwwaO8Dq71t1uIQZwWdNqPJ1fgyZbxn7Kxe2fPzYsfu20mrkNLwXZFYQxHvZk4Qg
         Z4eY/b9OdqsxSEUXZdeTvnuCUrXAtIVktIFdUR1Qp3mIb6slsrLVhEfr8QjfeI6lbK
         KXxh4F+TQckiqSY5xawr/+Uhm+70/Eh9SP8BUbh4=
Received: from usdutt-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: usdutt@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7ECE06074F;
        Mon, 25 Feb 2019 10:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551089252;
        bh=SBwvy9DQK1Muo2jIFHi8TjuWa6WwnsfCGB6yQbEdoyg=;
        h=From:To:Cc:Subject:Date:From;
        b=SBWdBolb6ozozlghqmq6SSdy3ny+MSAbcjAsRTJXBKsKPOF0WOzWIlQRFJhBIcxKu
         zJhhSvlagZFYIHyLifiP8DE/NnNKYShwIWZcxfOtEQnXzxEosQZfVqEoovsyieQ/jr
         sX9TLvOsBe4aTQcHbSF7AWBzQYXILat58JxZuyQE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7ECE06074F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=usdutt@codeaurora.org
From:   Sunil Dutt <usdutt@codeaurora.org>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, Sunil Dutt <usdutt@codeaurora.org>
Subject: [PATCH] nl80211: Add NL80211_FLAG_CLEAR_SKB flag for other NL commands
Date:   Mon, 25 Feb 2019 15:37:20 +0530
Message-Id: <1551089240-26588-1-git-send-email-usdutt@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This commit adds NL80211_FLAG_CLEAR_SKB flag to other NL commands
that carry key data to ensure they do not stick around on heap
after the SKB is freed.

Also introduced this flag for NL80211_CMD_VENDOR as there are sub
commands which configure the keys.

Signed-off-by: Sunil Dutt <usdutt@codeaurora.org>
---
 net/wireless/nl80211.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 1c2530e..9a2f5a0 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -13663,11 +13663,12 @@ static void nl80211_post_doit(const struct genl_ops *ops, struct sk_buff *skb,
 		.cmd = NL80211_CMD_ASSOCIATE,
 		.doit = nl80211_associate,
 		.policy = nl80211_policy,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
-				  NL80211_FLAG_NEED_RTNL,
+				  NL80211_FLAG_NEED_RTNL |
+				  NL80211_FLAG_CLEAR_SKB,
 	},
 	{
 		.cmd = NL80211_CMD_DEAUTHENTICATE,
 		.doit = nl80211_deauthenticate,
 		.policy = nl80211_policy,
@@ -13714,19 +13715,21 @@ static void nl80211_post_doit(const struct genl_ops *ops, struct sk_buff *skb,
 		.cmd = NL80211_CMD_CONNECT,
 		.doit = nl80211_connect,
 		.policy = nl80211_policy,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
-				  NL80211_FLAG_NEED_RTNL,
+				  NL80211_FLAG_NEED_RTNL |
+				  NL80211_FLAG_CLEAR_SKB,
 	},
 	{
 		.cmd = NL80211_CMD_UPDATE_CONNECT_PARAMS,
 		.doit = nl80211_update_connect_params,
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
-				  NL80211_FLAG_NEED_RTNL,
+				  NL80211_FLAG_NEED_RTNL |
+				  NL80211_FLAG_CLEAR_SKB,
 	},
 	{
 		.cmd = NL80211_CMD_DISCONNECT,
 		.doit = nl80211_disconnect,
 		.policy = nl80211_policy,
@@ -13751,11 +13754,12 @@ static void nl80211_post_doit(const struct genl_ops *ops, struct sk_buff *skb,
 		.cmd = NL80211_CMD_SET_PMKSA,
 		.doit = nl80211_setdel_pmksa,
 		.policy = nl80211_policy,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
-				  NL80211_FLAG_NEED_RTNL,
+				  NL80211_FLAG_NEED_RTNL |
+				  NL80211_FLAG_CLEAR_SKB,
 	},
 	{
 		.cmd = NL80211_CMD_DEL_PMKSA,
 		.doit = nl80211_setdel_pmksa,
 		.policy = nl80211_policy,
@@ -14103,11 +14107,12 @@ static void nl80211_post_doit(const struct genl_ops *ops, struct sk_buff *skb,
 		.doit = nl80211_vendor_cmd,
 		.dumpit = nl80211_vendor_cmd_dump,
 		.policy = nl80211_policy,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_WIPHY |
-				  NL80211_FLAG_NEED_RTNL,
+				  NL80211_FLAG_NEED_RTNL |
+				  NL80211_FLAG_CLEAR_SKB,
 	},
 	{
 		.cmd = NL80211_CMD_SET_QOS_MAP,
 		.doit = nl80211_set_qos_map,
 		.policy = nl80211_policy,
@@ -14158,11 +14163,12 @@ static void nl80211_post_doit(const struct genl_ops *ops, struct sk_buff *skb,
 	{
 		.cmd = NL80211_CMD_SET_PMK,
 		.doit = nl80211_set_pmk,
 		.policy = nl80211_policy,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
-				  NL80211_FLAG_NEED_RTNL,
+				  NL80211_FLAG_NEED_RTNL |
+				  NL80211_FLAG_CLEAR_SKB,
 	},
 	{
 		.cmd = NL80211_CMD_DEL_PMK,
 		.doit = nl80211_del_pmk,
 		.policy = nl80211_policy,
-- 
1.9.1

