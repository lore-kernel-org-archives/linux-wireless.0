Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:35072 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755960AbcBYAJE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Feb 2016 19:09:04 -0500
Received: by mail-wm0-f54.google.com with SMTP id c200so5766340wme.0
        for <linux-wireless@vger.kernel.org>; Wed, 24 Feb 2016 16:09:04 -0800 (PST)
From: Andreas Fenkart <afenkart@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Andreas Fenkart <afenkart@gmail.com>
Subject: [PATCH 3/7] mwifiex: scan: simplify ternary operators using gnu extension
Date: Thu, 25 Feb 2016 01:08:48 +0100
Message-Id: <1456358932-23114-4-git-send-email-afenkart@gmail.com> (sfid-20160225_010943_452744_1FC39006)
In-Reply-To: <1456358932-23114-1-git-send-email-afenkart@gmail.com>
References: <1456358932-23114-1-git-send-email-afenkart@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"x ? x : y" can be simplified as "x ? : y"
https://gcc.gnu.org/onlinedocs/gcc/Conditionals.html#Conditionals

Signed-off-by: Andreas Fenkart <afenkart@gmail.com>
---
 drivers/net/wireless/marvell/mwifiex/scan.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
index 276382e..f612c1b 100644
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

