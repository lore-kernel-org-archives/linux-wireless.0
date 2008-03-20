Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3981 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755404AbYCTUg1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Mar 2008 16:36:27 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: ashok.raj@intel.com, "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] arlan: fix warning when PROC_FS=n
Date: Thu, 20 Mar 2008 16:19:04 -0400
Message-Id: <1206044344-32260-1-git-send-email-linville@tuxdriver.com> (sfid-20080320_203635_289868_5CC7AD2A)
In-Reply-To: <200803192144.35718.toralf.foerster@gmx.de>
References: <200803192144.35718.toralf.foerster@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drivers/net/wireless/arlan-proc.c:1216: warning: 'arlan_root_table' defined but not used

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
Does anyone actually have this hardware anymore?  Perhaps we should just
remove this driver from the kernel?

FWIW, this issue has been with us since before the first git kernel...

 drivers/net/wireless/arlan-proc.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/arlan-proc.c b/drivers/net/wireless/arlan-proc.c
index c6e70db..2ab1d59 100644
--- a/drivers/net/wireless/arlan-proc.c
+++ b/drivers/net/wireless/arlan-proc.c
@@ -1202,13 +1202,6 @@ static ctl_table arlan_table[MAX_ARLANS + 1] =
 	{ .ctl_name = 0 }
 };
 #endif
-#else
-
-static ctl_table arlan_table[MAX_ARLANS + 1] =
-{
-	{ .ctl_name = 0 }
-};
-#endif
 
 
 // static int mmtu = 1234;
@@ -1233,7 +1226,6 @@ static ctl_table arlan_root_table[] =
 //};
 
 
-#ifdef CONFIG_PROC_FS
 static struct ctl_table_header *arlan_device_sysctl_header;
 
 int __init init_arlan_proc(void)
-- 
1.5.3.3

