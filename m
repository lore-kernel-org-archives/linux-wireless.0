Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2A59C282C3
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 15:25:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4BF1217D6
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 15:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548170702;
	bh=be1j1D35A65spkEMYn7nYL7UVinDUwRq/xbFD+k1CyU=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=mCluS99lyXbFUeA0x1KBncB5V0ji68lJWRVY13YPYTtf8B1WlbhOl8gCMOVk8J3mV
	 /mdw4y+vPtIsKnDRnePYJAaqTH3cfzM9bdbgyrFhivTSTi5EZsSnLw4mVgR5f1iGF2
	 WFFfuVENhiATlBTSwzwwtZMJsAf6eQW6OJgGUNuQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730027AbfAVPYH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 10:24:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:37704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730018AbfAVPYG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 10:24:06 -0500
Received: from localhost (5356596B.cm-6-7b.dynamic.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AB1120855;
        Tue, 22 Jan 2019 15:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548170645;
        bh=be1j1D35A65spkEMYn7nYL7UVinDUwRq/xbFD+k1CyU=;
        h=From:To:Cc:Subject:Date:From;
        b=UhkejA5+rsoJrRQaj6lsMF9peP1n4qWcnK3w75Two+45ZH4CurQg7PH4SBGtUcmIT
         m6RgofvjGEWNRPwSmMcoBsrNWZinac4MM+dgpWF635CJ3qQLjfBYbtSiSWh1zpIU5a
         zeA5D65662J8BDM+/EdugVJckAFFVrlz3SIOg7L4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Subject: [PATCH] rt2x00: no need to check return value of debugfs_create functions
Date:   Tue, 22 Jan 2019 16:21:34 +0100
Message-Id: <20190122152151.16139-35-gregkh@linuxfoundation.org>
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

Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../net/wireless/ralink/rt2x00/rt2x00debug.c  | 27 -------------------
 1 file changed, 27 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00debug.c b/drivers/net/wireless/ralink/rt2x00/rt2x00debug.c
index 61ba573e8bf1..05a2e8da412c 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00debug.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00debug.c
@@ -656,36 +656,24 @@ void rt2x00debug_register(struct rt2x00_dev *rt2x00dev)
 	intf->driver_folder =
 	    debugfs_create_dir(intf->rt2x00dev->ops->name,
 			       rt2x00dev->hw->wiphy->debugfsdir);
-	if (IS_ERR(intf->driver_folder) || !intf->driver_folder)
-		goto exit;
 
 	intf->driver_entry =
 	    rt2x00debug_create_file_driver("driver", intf, &intf->driver_blob);
-	if (IS_ERR(intf->driver_entry) || !intf->driver_entry)
-		goto exit;
 
 	intf->chipset_entry =
 	    rt2x00debug_create_file_chipset("chipset",
 					    intf, &intf->chipset_blob);
-	if (IS_ERR(intf->chipset_entry) || !intf->chipset_entry)
-		goto exit;
 
 	intf->dev_flags = debugfs_create_file("dev_flags", 0400,
 					      intf->driver_folder, intf,
 					      &rt2x00debug_fop_dev_flags);
-	if (IS_ERR(intf->dev_flags) || !intf->dev_flags)
-		goto exit;
 
 	intf->cap_flags = debugfs_create_file("cap_flags", 0400,
 					      intf->driver_folder, intf,
 					      &rt2x00debug_fop_cap_flags);
-	if (IS_ERR(intf->cap_flags) || !intf->cap_flags)
-		goto exit;
 
 	intf->register_folder =
 	    debugfs_create_dir("register", intf->driver_folder);
-	if (IS_ERR(intf->register_folder) || !intf->register_folder)
-		goto exit;
 
 #define RT2X00DEBUGFS_CREATE_REGISTER_ENTRY(__intf, __name)		\
 ({									\
@@ -695,9 +683,6 @@ void rt2x00debug_register(struct rt2x00_dev *rt2x00dev)
 					   0600,			\
 					   (__intf)->register_folder,	\
 					   &(__intf)->offset_##__name);	\
-		if (IS_ERR((__intf)->__name##_off_entry) ||		\
-		    !(__intf)->__name##_off_entry)			\
-			goto exit;					\
 									\
 		(__intf)->__name##_val_entry =				\
 			debugfs_create_file(__stringify(__name) "_value", \
@@ -705,9 +690,6 @@ void rt2x00debug_register(struct rt2x00_dev *rt2x00dev)
 					    (__intf)->register_folder,	\
 					    (__intf),			\
 					    &rt2x00debug_fop_##__name); \
-		if (IS_ERR((__intf)->__name##_val_entry) ||		\
-		    !(__intf)->__name##_val_entry)			\
-			goto exit;					\
 	}								\
 })
 
@@ -721,15 +703,10 @@ void rt2x00debug_register(struct rt2x00_dev *rt2x00dev)
 
 	intf->queue_folder =
 	    debugfs_create_dir("queue", intf->driver_folder);
-	if (IS_ERR(intf->queue_folder) || !intf->queue_folder)
-		goto exit;
 
 	intf->queue_frame_dump_entry =
 		debugfs_create_file("dump", 0400, intf->queue_folder,
 				    intf, &rt2x00debug_fop_queue_dump);
-	if (IS_ERR(intf->queue_frame_dump_entry)
-		|| !intf->queue_frame_dump_entry)
-		goto exit;
 
 	skb_queue_head_init(&intf->frame_dump_skbqueue);
 	init_waitqueue_head(&intf->frame_dump_waitqueue);
@@ -747,10 +724,6 @@ void rt2x00debug_register(struct rt2x00_dev *rt2x00dev)
 #endif
 
 	return;
-
-exit:
-	rt2x00debug_deregister(rt2x00dev);
-	rt2x00_err(rt2x00dev, "Failed to register debug handler\n");
 }
 
 void rt2x00debug_deregister(struct rt2x00_dev *rt2x00dev)
-- 
2.20.1

