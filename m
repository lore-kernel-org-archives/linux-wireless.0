Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:49212
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300AbXHRXxT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Aug 2007 19:53:19 -0400
Message-Id: <20070818234834.595040000@bu3sch.de>
References: <20070818234833.623623000@bu3sch.de>
Date: Sun, 19 Aug 2007 01:48:35 +0200
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: [patch 2/6] ssb: Fix uevent MODALIAS string.
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the same %-convention as file2alias does.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: ssb-merge-new/drivers/ssb/main.c
===================================================================
--- ssb-merge-new.orig/drivers/ssb/main.c	2007-08-15 18:33:50.000000000 +0200
+++ ssb-merge-new/drivers/ssb/main.c	2007-08-15 18:35:11.000000000 +0200
@@ -331,10 +331,11 @@ static int ssb_device_uevent(struct devi
 
 	ret = add_uevent_var(envp, num_envp, &i,
 			     buffer, buffer_size, &length,
-			     "MODALIAS=ssb:v%.4xid%.4xrev%.2x",
+			     "MODALIAS=ssb:v%04Xid%04Xrev%02X",
 			     ssb_dev->id.vendor, ssb_dev->id.coreid,
 			     ssb_dev->id.revision);
 	envp[i] = NULL;
+
 	return ret;
 }
 

-- 

