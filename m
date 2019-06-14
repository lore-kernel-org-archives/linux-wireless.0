Return-Path: <SRS0=mNjQ=UN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27782C31E4C
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Jun 2019 11:02:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F36792082C
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Jun 2019 11:02:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="H2hzFWG1";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="E+uxoPv8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727168AbfFNLCF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 14 Jun 2019 07:02:05 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:34808 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726900AbfFNLCE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Jun 2019 07:02:04 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 20204607C6; Fri, 14 Jun 2019 11:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1560510124;
        bh=1IlAp9jSvQzTQdWzKxGBiN0r8rhi5HJLVRfcaggg3Ok=;
        h=From:To:Cc:Subject:Date:From;
        b=H2hzFWG1L2lr44W8YSOqsrJMfwGUz6gSX/9l989T7SkCDMOsWSQ2Y/vQOtgnTxpH6
         yLjwFclxAoTBBHzXLi9n8vMNT6r9grthu2XbRfnXoHV0+vKmRUhBAeIwplLegwlmUF
         f6XVbzI/ufshpqOmkprCSBfyV10DQbVR/B1Vbw10=
Received: from ybzhao-HP-Z230-SFF-Workstation.ap.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: yiboz@codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3CDB260240;
        Fri, 14 Jun 2019 11:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1560510123;
        bh=1IlAp9jSvQzTQdWzKxGBiN0r8rhi5HJLVRfcaggg3Ok=;
        h=From:To:Cc:Subject:Date:From;
        b=E+uxoPv8OBm4o1XlolNELLSu/mf7GW2fuTHrac1c66n5W5BE8Zau4eaGY6hk2XneZ
         o57V8uBg3vmuGEbfz6WZBPvOPLf9a0RbdumBNJGsXkxJWVVWEh6dkZwpYPf3IpM/W5
         go7Ifkx7erVDle8rSxh2zaBR+yaAwU4H1GdLttlA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3CDB260240
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=yiboz@codeaurora.org
From:   Yibo Zhao <yiboz@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, Yibo Zhao <yiboz@codeaurora.org>,
        Zhi Chen <zhichen@codeaurora.org>
Subject: [PATCH] mac80211: suppress kernel warning message
Date:   Fri, 14 Jun 2019 19:01:52 +0800
Message-Id: <1560510112-21613-1-git-send-email-yiboz@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In multiple SSID cases, it takes time to prepare every AP interface
to be ready in initializing phase. If a sta already knows everything it
needs to join one of the APs and sends authentication to the AP which
is not fully prepared at this point of time, AP's channel context
could be NULL. As a result, warning message occurs.

Even worse, if the AP is under attack via tools such as MDK3 and massive
authentication requests are received in a very short time, console will
be hung due to kernel warning messages.

WARN_ON_ONCE() could be a better way for indicating warning messages
without duplicate messages to flood the console.

Signed-off-by: Zhi Chen <zhichen@codeaurora.org>
Signed-off-by: Yibo Zhao <yiboz@codeaurora.org>
---
 net/mac80211/ieee80211_i.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index a8af4aa..682d0ab 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1435,7 +1435,7 @@ struct ieee80211_local {
 	rcu_read_lock();
 	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
 
-	if (WARN_ON(!chanctx_conf)) {
+	if (WARN_ON_ONCE(!chanctx_conf)) {
 		rcu_read_unlock();
 		return NULL;
 	}
-- 
1.9.1

