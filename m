Return-Path: <SRS0=bGvd=SS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 363FBC10F13
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 05:47:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03B312075B
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 05:47:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="bYsNT/oC";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="MOC7+Mhd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbfDPFru (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Apr 2019 01:47:50 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:50566 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726016AbfDPFru (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Apr 2019 01:47:50 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 0FCB861947; Tue, 16 Apr 2019 05:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555393670;
        bh=JoCXGJZ7oEm5VZZgjJCUuOsrKy6qRqB8Xp55RQWFYGE=;
        h=From:To:Cc:Subject:Date:From;
        b=bYsNT/oCGpwWxj+7zmLujxsFLgTJqvMcOaJhaTFoWY2363leDokKiOfrCH2fqRwOe
         ZEVVzQ1hA8gm5NvZPHkKWGrZ9wkzsePZoT9QqJsCE95TwvgKg1GHKrCXLoRnhJtUyA
         TU3GwH+7DoT4q7QlG7u1cnOBkBWrEEzyEmyiZKAo=
Received: from checstp253621-lin.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: srirrama@codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 342AB618CA;
        Tue, 16 Apr 2019 05:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555393628;
        bh=JoCXGJZ7oEm5VZZgjJCUuOsrKy6qRqB8Xp55RQWFYGE=;
        h=From:To:Cc:Subject:Date:From;
        b=MOC7+MhdJoFP6FxlJHcc/6X1Z7bYKnZNV1f/q4Zvd0WvdFvNTh9AxauPlpo2amlHS
         3DT8Mg7Sij871bgKnLlaegZ0WB91IxJZnNyONB2Ol9/6HEcwg4U+bkEjNAXBc350cu
         7nslj7l2Di4SpyJiT2e+Wioni1HTXeAhAXJ1wAi4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 342AB618CA
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=srirrama@codeaurora.org
From:   Sriram R <srirrama@codeaurora.org>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, Sriram R <srirrama@codeaurora.org>
Subject: [PATCH] cfg80211: Notify previous user request during self managed wiphy registration
Date:   Tue, 16 Apr 2019 11:16:33 +0530
Message-Id: <1555393593-19018-1-git-send-email-srirrama@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Commit c82c06ce43d3("cfg80211: Notify all User Hints To self managed wiphys") notifies
all new user hints to self managed wiphy's after device registration.
But it doesn't notify user request (other than cell base hints) which was
set before registration.
This needs to be done during wiphy registration of a self managed device also,
so that the previous user settings are retained.

Signed-off-by: Sriram R <srirrama@codeaurora.org>
---
 net/wireless/reg.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 2f1bf91..85a0b5e 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -3739,10 +3739,9 @@ void wiphy_regulatory_register(struct wiphy *wiphy)
 		/*
 		 * The last request may have been received before this
 		 * registration call. Call the driver notifier if
-		 * initiator is USER and user type is CELL_BASE.
+		 * initiator is USER.
 		 */
-		if (lr->initiator == NL80211_REGDOM_SET_BY_USER &&
-		    lr->user_reg_hint_type == NL80211_USER_REG_HINT_CELL_BASE)
+		if (lr->initiator == NL80211_REGDOM_SET_BY_USER)
 			reg_call_notifier(wiphy, lr);
 	}
 
-- 
2.7.4

