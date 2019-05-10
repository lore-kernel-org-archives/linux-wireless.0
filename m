Return-Path: <SRS0=s/o7=TK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E4F1C04A6B
	for <linux-wireless@archiver.kernel.org>; Fri, 10 May 2019 07:02:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D080A2175B
	for <linux-wireless@archiver.kernel.org>; Fri, 10 May 2019 07:02:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="bArGWL9n";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="bArGWL9n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbfEJHCD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 10 May 2019 03:02:03 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:45300 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726855AbfEJHCC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 May 2019 03:02:02 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E4D46607EB; Fri, 10 May 2019 07:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1557471721;
        bh=jOTxeffynwtDEKNRNC1OxZc+a8+J8mZ7VRSufbn91VU=;
        h=From:To:Cc:Subject:Date:From;
        b=bArGWL9nJ66fYJj7+WZZ3ygFZH0RM7D4Z7nht3etTIzG/CiAZ4pQonmD/cm+Hdf7E
         dLC8hd68qQXZ4xvLVQHN1+G8SCpBSA+6+NimHoDr90TFnWbjtVxQmVOPuitKptC4R7
         maq0EB1zXdUP3zOHtqVjVGRJxy3rLFnbVL611j7o=
Received: from ybzhao-Latitude-E5440.ap.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: yiboz@codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 00A8F6076C;
        Fri, 10 May 2019 07:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1557471721;
        bh=jOTxeffynwtDEKNRNC1OxZc+a8+J8mZ7VRSufbn91VU=;
        h=From:To:Cc:Subject:Date:From;
        b=bArGWL9nJ66fYJj7+WZZ3ygFZH0RM7D4Z7nht3etTIzG/CiAZ4pQonmD/cm+Hdf7E
         dLC8hd68qQXZ4xvLVQHN1+G8SCpBSA+6+NimHoDr90TFnWbjtVxQmVOPuitKptC4R7
         maq0EB1zXdUP3zOHtqVjVGRJxy3rLFnbVL611j7o=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 00A8F6076C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=yiboz@codeaurora.org
From:   Yibo Zhao <yiboz@codeaurora.org>
To:     linux-wireless@vger.kernel.org
Cc:     ath10k@lists.infradead.org, Yibo Zhao <yiboz@codeaurora.org>,
        Zhi Chen <zhichen@codeaurora.org>
Subject: [PATCH] mac80211: remove warning message
Date:   Fri, 10 May 2019 15:01:02 +0800
Message-Id: <1557471662-1355-1-git-send-email-yiboz@codeaurora.org>
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

If this case can be hit during normal functionality, there should be no
WARN_ON(). Those should be reserved to cases that are not supposed to be
hit at all or some other more specific cases like indicating obsolete
interface.

Signed-off-by: Zhi Chen <zhichen@codeaurora.org>
Signed-off-by: Yibo Zhao <yiboz@codeaurora.org>
---
 net/mac80211/ieee80211_i.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 2ae0364..f39c289 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1435,7 +1435,7 @@ struct ieee80211_local {
 	rcu_read_lock();
 	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
 
-	if (WARN_ON_ONCE(!chanctx_conf)) {
+	if (!chanctx_conf) {
 		rcu_read_unlock();
 		return NULL;
 	}
-- 
1.9.1

