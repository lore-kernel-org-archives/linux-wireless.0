Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp4.pp.htv.fi ([213.243.153.38]:55373 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755992AbYBBVSQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Feb 2008 16:18:16 -0500
Date: Sat, 2 Feb 2008 23:19:01 +0200
From: Adrian Bunk <bunk@kernel.org>
To: yi.zhu@intel.com, reinette.chatre@intel.com, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Subject: [2.6 patch] iwl3945-base.c: fix off-by-one errors
Message-ID: <20080202211901.GI9375@cs181133002.pp.htv.fi> (sfid-20080202_211820_451216_F3B902A4)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes two off-by-one errors resulting in array overflows
spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

I remember having fixed exactly the same bug in iwl4965-base.c some time 
ago - it might perhaps be possible to share some of the duplicated code 
between the two drivers?


--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -4207,13 +4207,13 @@ static u8 ratio2dB[100] = {
  * Conversion assumes that levels are voltages (20*log), not powers (10*log). */
 int iwl3945_calc_db_from_ratio(int sig_ratio)
 {
-	/* Anything above 1000:1 just report as 60 dB */
-	if (sig_ratio > 1000)
+	/* 1000:1 or higher just report as 60 dB */
+	if (sig_ratio >= 1000)
 		return 60;
 
-	/* Above 100:1, divide by 10 and use table,
+	/* 100:1 or higher, divide by 10 and use table,
 	 *   add 20 dB to make up for divide by 10 */
-	if (sig_ratio > 100)
+	if (sig_ratio >= 100)
 		return (20 + (int)ratio2dB[sig_ratio/10]);
 
 	/* We shouldn't see this */

