Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30F2EC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 09:51:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05E672147C
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 09:51:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfCLJvs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 05:51:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33254 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725906AbfCLJvs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 05:51:48 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9068D30820C9;
        Tue, 12 Mar 2019 09:51:48 +0000 (UTC)
Received: from localhost (unknown [10.40.205.176])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2CA2260851;
        Tue, 12 Mar 2019 09:51:47 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>
Subject: [PATCH v3 2/4] rt2x00: use ratelimited variants dev_warn/dev_err
Date:   Tue, 12 Mar 2019 10:51:41 +0100
Message-Id: <1552384303-29529-3-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1552384303-29529-1-git-send-email-sgruszka@redhat.com>
References: <1552384303-29529-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Tue, 12 Mar 2019 09:51:48 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

As reported by Randy we can overwhelm logs on some USB error conditions.
To avoid that use dev_warn_ratelimited() and dev_err_ratelimitd().

Reported-and-tested-by: Randy Oostdyk <linux-kernel@oostdyk.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2x00.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00.h b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
index 4b1744e9fb78..5657495cf626 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
@@ -69,10 +69,10 @@
 	printk(KERN_ERR KBUILD_MODNAME ": %s: Error - " fmt,		\
 	       __func__, ##__VA_ARGS__)
 #define rt2x00_err(dev, fmt, ...)					\
-	wiphy_err((dev)->hw->wiphy, "%s: Error - " fmt,			\
+	wiphy_err_ratelimited((dev)->hw->wiphy, "%s: Error - " fmt,	\
 		  __func__, ##__VA_ARGS__)
 #define rt2x00_warn(dev, fmt, ...)					\
-	wiphy_warn((dev)->hw->wiphy, "%s: Warning - " fmt,		\
+	wiphy_warn_ratelimited((dev)->hw->wiphy, "%s: Warning - " fmt,	\
 		   __func__, ##__VA_ARGS__)
 #define rt2x00_info(dev, fmt, ...)					\
 	wiphy_info((dev)->hw->wiphy, "%s: Info - " fmt,			\
-- 
2.7.5

