Return-Path: <SRS0=7mY+=OP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F4A0C04EB8
	for <linux-wireless@archiver.kernel.org>; Thu,  6 Dec 2018 10:05:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA7FC20672
	for <linux-wireless@archiver.kernel.org>; Thu,  6 Dec 2018 10:05:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="MpIpPz2e";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="numgkIQy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EA7FC20672
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728953AbeLFKFa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 6 Dec 2018 05:05:30 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:46816 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727575AbeLFKF3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Dec 2018 05:05:29 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 5EB0C6014B; Thu,  6 Dec 2018 10:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544090729;
        bh=KaxUIsc4uc8PB25E4Z4IKDff07A6IceM4beBa9Z2n1s=;
        h=From:To:Cc:Subject:Date:From;
        b=MpIpPz2eRUcvYOpJ+tq3HJ6NOZovK3cRm1WG4v4h6xYrN8BcXQXS/ebWbSJw2FROe
         NaNEC8WRUJdZ4/uAa5yZnnjImmxTSZwKKBKk8SeJ1PaStbuHoO0loFhrTgRxBFJz+4
         K4rIEMGy+pXZDpQvmfBtEyuZ8fEdshBmqTk4FlbI=
Received: from checstp253621-lin.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: srirrama@codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 328AF6014B;
        Thu,  6 Dec 2018 10:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544090728;
        bh=KaxUIsc4uc8PB25E4Z4IKDff07A6IceM4beBa9Z2n1s=;
        h=From:To:Cc:Subject:Date:From;
        b=numgkIQyiL7ZyciCUvKH60qs+ZnEa1oEX190qJ7CXQQMCMNIQhMyV0IJOMzCoadOP
         d3fO+xZLgQObK5ybPUaAouQ4tiOxVnN9v1FoeSF2ZzmQWTbRdgTR4j3j0XPrjOn7YX
         I6ifNQbq0LLH8pQrdZ603e0ulIVjDpjhE0sl2gr4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 328AF6014B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=srirrama@codeaurora.org
From:   Sriram R <srirrama@codeaurora.org>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, Sriram R <srirrama@codeaurora.org>
Subject: [PATCH] cfg80211: Notify all User Hints To self managed wiphys
Date:   Thu,  6 Dec 2018 15:34:57 +0530
Message-Id: <1544090697-30709-1-git-send-email-srirrama@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Currently Self Managed WIPHY's are not notified on any
hints other than user cell base station hints.
Self Managed wiphy's basically rely on hints from firmware
and its local regdb for regulatory management, so hints from wireless
core can be ignored. But all user hints needs to be notified
to them to provide flexibility to these drivers to honour or
ignore these user hints.

Currently none of the drivers supporting self managed wiphy
register a notifier with cfg80211. Hence this change does not affect
any other driver behavior.

Signed-off-by: Sriram R <srirrama@codeaurora.org>
---
 net/wireless/reg.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index ecfb1a0..7def1ec 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2724,9 +2724,7 @@ static void notify_self_managed_wiphys(struct regulatory_request *request)
 	list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
 		wiphy = &rdev->wiphy;
 		if (wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED &&
-		    request->initiator == NL80211_REGDOM_SET_BY_USER &&
-		    request->user_reg_hint_type ==
-				NL80211_USER_REG_HINT_CELL_BASE)
+		    request->initiator == NL80211_REGDOM_SET_BY_USER)
 			reg_call_notifier(wiphy, request);
 	}
 }
-- 
2.7.4

