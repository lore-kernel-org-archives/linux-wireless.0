Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:49279 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757989AbXJZUTN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2007 16:19:13 -0400
Received: from [82.171.216.234] (helo=[192.168.1.2])
	by smtp-out3.tiscali.nl with esmtp (Tiscali http://www.tiscali.nl)
	id 1IlVeC-00037Z-EX
	for <linux-wireless@vger.kernel.org>; Fri, 26 Oct 2007 22:19:12 +0200
Message-ID: <47224BBD.3080000@tiscali.nl> (sfid-20071026_211937_994961_598EA4E4)
Date: Fri, 26 Oct 2007 22:19:09 +0200
From: Roel Kluin <12o3l@tiscali.nl>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH split 7/8] fix 'and' typo's in wireless/zd1211rw/zd_rf_uw2453
References: <4722453E.2090801@tiscali.nl> <472248AC.7080201@tiscali.nl>
In-Reply-To: <472248AC.7080201@tiscali.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

        Fix priority mistakes similar to '!x & y'
    
        Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/net/wireless/zd1211rw/zd_rf_uw2453.c b/drivers/net/wireless/zd1211rw/zd_rf_uw2453.c
index 857dcf3..3c1cca4 100644
--- a/drivers/net/wireless/zd1211rw/zd_rf_uw2453.c
+++ b/drivers/net/wireless/zd1211rw/zd_rf_uw2453.c
@@ -403,7 +403,7 @@ static int uw2453_init_hw(struct zd_rf *rf)
 		if (r)
 			return r;
 
-		if (!intr_status & 0xf) {
+		if (!(intr_status & 0xf)) {
 			dev_dbg_f(zd_chip_dev(chip),
 				"PLL locked on configuration %d\n", i);
 			found_config = i;
