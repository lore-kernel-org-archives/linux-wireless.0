Return-Path: <SRS0=pyzf=O5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25C95C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 15:16:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E674A21852
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 15:16:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731004AbeLTPQP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Dec 2018 10:16:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39654 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729011AbeLTPQP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Dec 2018 10:16:15 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0E94113AA7;
        Thu, 20 Dec 2018 15:16:14 +0000 (UTC)
Received: from localhost (ovpn-204-224.brq.redhat.com [10.40.204.224])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 51DE218240;
        Thu, 20 Dec 2018 15:16:12 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     Randy Oostdyk <linux-kernel@oostdyk.com>,
        =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>
Subject: [PATCH v2 1/3] rt2x00: use ratelimited variants dev_warn/dev_err
Date:   Thu, 20 Dec 2018 16:16:09 +0100
Message-Id: <1545318971-28351-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Thu, 20 Dec 2018 15:16:14 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

As reported by Randy we can overwhelm logs on some USB error conditions.
To avoid that use dev_warn_ratelimited() and dev_err_ratelimitd().

Reported-and-tested-by: Randy Oostdyk <linux-kernel@oostdyk.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2x00.h | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00.h b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
index 4b1744e9fb78..94459d5ee01b 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
@@ -65,14 +65,19 @@
 /* Utility printing macros
  * rt2x00_probe_err is for messages when rt2x00_dev is uninitialized
  */
+#define wiphy_err_ratelimited(wiphy, format, args...)		\
+	dev_err_ratelimited(&(wiphy)->dev, format, ##args)
+#define wiphy_warn_ratelimited(wiphy, format, args...)		\
+	dev_warn_ratelimited(&(wiphy)->dev, format, ##args)
+
 #define rt2x00_probe_err(fmt, ...)					\
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

