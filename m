Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:46718 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283AbZLAIr1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2009 03:47:27 -0500
Received: from esebh105.NOE.Nokia.com (esebh105.ntc.nokia.com [172.21.138.211])
	by mgw-mx06.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id nB18l6d7019673
	for <linux-wireless@vger.kernel.org>; Tue, 1 Dec 2009 10:47:31 +0200
Received: from [127.0.1.1] (essapo-nirac253175.europe.nokia.com [10.162.253.175])
	by mgw-sa01.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id nB18lM97017073
	for <linux-wireless@vger.kernel.org>; Tue, 1 Dec 2009 10:47:23 +0200
Subject: [PATCH] cfg80211: indent regulatory messages with spaces
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 01 Dec 2009 10:47:15 +0200
Message-ID: <20091201084715.7996.37035.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

The regulatory messages in syslog look weird:

kernel: cfg80211: Regulatory domain: US
kernel: ^I(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
kernel: ^I(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
kernel: ^I(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
kernel: ^I(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
kernel: ^I(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
kernel: ^I(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
kernel: ^I(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)

Indent them with four spaces instead of the tab character to get prettier
output.

Cc: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---
 net/wireless/reg.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 1f33017..c01470e 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1931,7 +1931,7 @@ static void print_rd_rules(const struct ieee80211_regdomain *rd)
 	const struct ieee80211_freq_range *freq_range = NULL;
 	const struct ieee80211_power_rule *power_rule = NULL;
 
-	printk(KERN_INFO "\t(start_freq - end_freq @ bandwidth), "
+	printk(KERN_INFO "    (start_freq - end_freq @ bandwidth), "
 		"(max_antenna_gain, max_eirp)\n");
 
 	for (i = 0; i < rd->n_reg_rules; i++) {
@@ -1944,7 +1944,7 @@ static void print_rd_rules(const struct ieee80211_regdomain *rd)
 		 * in certain regions
 		 */
 		if (power_rule->max_antenna_gain)
-			printk(KERN_INFO "\t(%d KHz - %d KHz @ %d KHz), "
+			printk(KERN_INFO "    (%d KHz - %d KHz @ %d KHz), "
 				"(%d mBi, %d mBm)\n",
 				freq_range->start_freq_khz,
 				freq_range->end_freq_khz,
@@ -1952,7 +1952,7 @@ static void print_rd_rules(const struct ieee80211_regdomain *rd)
 				power_rule->max_antenna_gain,
 				power_rule->max_eirp);
 		else
-			printk(KERN_INFO "\t(%d KHz - %d KHz @ %d KHz), "
+			printk(KERN_INFO "    (%d KHz - %d KHz @ %d KHz), "
 				"(N/A, %d mBm)\n",
 				freq_range->start_freq_khz,
 				freq_range->end_freq_khz,

