Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:33924 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932846AbcCJIoY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2016 03:44:24 -0500
Received: by mail-wm0-f54.google.com with SMTP id p65so18583453wmp.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 Mar 2016 00:44:23 -0800 (PST)
From: Andreas Fenkart <afenkart@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Julian Calaby <julian.calaby@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Andreas Fenkart <afenkart@gmail.com>
Subject: [PATCH v2 3/7] mwifiex: scan: simplify ternary operators using gnu extension
Date: Thu, 10 Mar 2016 09:44:07 +0100
Message-Id: <1457599451-13910-4-git-send-email-afenkart@gmail.com> (sfid-20160310_094427_412361_33E75A17)
In-Reply-To: <1457599451-13910-1-git-send-email-afenkart@gmail.com>
References: <1457599451-13910-1-git-send-email-afenkart@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"x ? x : y" can be simplified as "x ? : y"
https://gcc.gnu.org/onlinedocs/gcc/Conditionals.html#Conditionals

Reviewed-by: Julian Calaby <julian.calaby@gmail.com>
Signed-off-by: Andreas Fenkart <afenkart@gmail.com>
---
 drivers/net/wireless/marvell/mwifiex/scan.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
index ed886af..f623834 100644
--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -845,14 +845,11 @@ mwifiex_config_scan(struct mwifiex_private *priv,
 		/* Set the BSS type scan filter, use Adapter setting if
 		   unset */
 		scan_cfg_out->bss_mode =
-			(user_scan_in->bss_mode ? (u8) user_scan_in->
-			 bss_mode : (u8) adapter->scan_mode);
+			(u8)(user_scan_in->bss_mode ?: adapter->scan_mode);
 
 		/* Set the number of probes to send, use Adapter setting
 		   if unset */
-		num_probes =
-			(user_scan_in->num_probes ? user_scan_in->
-			 num_probes : adapter->scan_probes);
+		num_probes = user_scan_in->num_probes ?: adapter->scan_probes;
 
 		/*
 		 * Set the BSSID filter to the incoming configuration,
-- 
2.7.0

