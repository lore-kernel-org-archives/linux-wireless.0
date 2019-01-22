Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34392C282C5
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 15:24:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC49A20855
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 15:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548170651;
	bh=VVGely5ydeVrDBODAHMoYQnlw4BUra8XL8cikzWU7Dg=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=mb/lG5RmLOR1g1pnGK1D0vv4o82/JxFiRIX6pa9R+hHjUKNgSepFCu1PVwxSdZjfH
	 O2SDxV7IUR/zHPYQCHeP7HoYQpPiG2o2KM13Vh9alO2AadL/PNzseLNhtej8ruZwgS
	 +bEaXWMSQ///ld2N5XnP9UslwETya0hmscG5C8Hg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730052AbfAVPYJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 10:24:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:37792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729981AbfAVPYJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 10:24:09 -0500
Received: from localhost (5356596B.cm-6-7b.dynamic.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04536217D4;
        Tue, 22 Jan 2019 15:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548170648;
        bh=VVGely5ydeVrDBODAHMoYQnlw4BUra8XL8cikzWU7Dg=;
        h=From:To:Cc:Subject:Date:From;
        b=tjV4SpXbcorZt/URjF9QSvR7G2a5vDFP8LrntS9Km3DqSDBIpiCmev5NB2LrPawA2
         I1LZlGkJk0ftu3wW2mAJtp/Gf8uM5kONfbFnjQnBFH5fDkCHYyKmC6E+a/xGyAQeSu
         P8QxzBGV6Wd9fcdV/lB9/m5W11orqIACOIsOyQB0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Igor Mitsyanko <imitsyanko@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Subject: [PATCH] quantenna: no need to check return value of debugfs_create functions
Date:   Tue, 22 Jan 2019 16:21:35 +0100
Message-Id: <20190122152151.16139-36-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

When calling debugfs functions, there is no need to ever check the
return value.  The function can work or not, but the code logic should
never do something different based on this.

Cc: Igor Mitsyanko <imitsyanko@quantenna.com>
Cc: Avinash Patil <avinashp@quantenna.com>
Cc: Sergey Matyukevich <smatyukevich@quantenna.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/quantenna/qtnfmac/debug.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/debug.c b/drivers/net/wireless/quantenna/qtnfmac/debug.c
index 9f826b9ef5d9..10156780ea37 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/debug.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/debug.c
@@ -16,17 +16,9 @@
 
 #include "debug.h"
 
-#undef pr_fmt
-#define pr_fmt(fmt)	"qtnfmac dbg: %s: " fmt, __func__
-
 void qtnf_debugfs_init(struct qtnf_bus *bus, const char *name)
 {
 	bus->dbg_dir = debugfs_create_dir(name, NULL);
-
-	if (IS_ERR_OR_NULL(bus->dbg_dir)) {
-		pr_warn("failed to create debugfs root dir\n");
-		bus->dbg_dir = NULL;
-	}
 }
 
 void qtnf_debugfs_remove(struct qtnf_bus *bus)
@@ -38,9 +30,5 @@ void qtnf_debugfs_remove(struct qtnf_bus *bus)
 void qtnf_debugfs_add_entry(struct qtnf_bus *bus, const char *name,
 			    int (*fn)(struct seq_file *seq, void *data))
 {
-	struct dentry *entry;
-
-	entry = debugfs_create_devm_seqfile(bus->dev, name, bus->dbg_dir, fn);
-	if (IS_ERR_OR_NULL(entry))
-		pr_warn("failed to add entry (%s)\n", name);
+	debugfs_create_devm_seqfile(bus->dev, name, bus->dbg_dir, fn);
 }
-- 
2.20.1

