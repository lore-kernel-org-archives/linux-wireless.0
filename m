Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5577BC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 09:51:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 240732147C
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 09:51:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbfCLJvr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 05:51:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44032 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725906AbfCLJvr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 05:51:47 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0B635E6A94;
        Tue, 12 Mar 2019 09:51:47 +0000 (UTC)
Received: from localhost (unknown [10.40.205.176])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9ABEA5D70E;
        Tue, 12 Mar 2019 09:51:46 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>
Subject: [PATCH v3 1/4] cfg80211: add ratelimited variants of err and warn
Date:   Tue, 12 Mar 2019 10:51:40 +0100
Message-Id: <1552384303-29529-2-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1552384303-29529-1-git-send-email-sgruszka@redhat.com>
References: <1552384303-29529-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Tue, 12 Mar 2019 09:51:47 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

wiphy_{err,warn}_ratelimited will be used by rt2x00

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 include/net/cfg80211.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index bb307a11ee63..13bfeb712d36 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -7183,6 +7183,11 @@ void cfg80211_pmsr_complete(struct wireless_dev *wdev,
 #define wiphy_info(wiphy, format, args...)			\
 	dev_info(&(wiphy)->dev, format, ##args)
 
+#define wiphy_err_ratelimited(wiphy, format, args...)		\
+	dev_err_ratelimited(&(wiphy)->dev, format, ##args)
+#define wiphy_warn_ratelimited(wiphy, format, args...)		\
+	dev_warn_ratelimited(&(wiphy)->dev, format, ##args)
+
 #define wiphy_debug(wiphy, format, args...)			\
 	wiphy_printk(KERN_DEBUG, wiphy, format, ##args)
 
-- 
2.7.5

