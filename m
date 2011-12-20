Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:61833 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab1LTUYI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Dec 2011 15:24:08 -0500
Cc: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Petri Karhula <petri.karhula@nokia.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: <linville@tuxdriver.com>
Subject: [PATCH 2/3] cfg80211: replace reg.c Nokia commit 269ac5
Date: Tue, 20 Dec 2011 12:23:37 -0800
Message-ID: <1324412618-25131-3-git-send-email-rodrigue@qca.qualcomm.com> (sfid-20111220_212413_733190_49E63F1A)
In-Reply-To: <1324412618-25131-1-git-send-email-rodrigue@qca.qualcomm.com>
References: <1324412618-25131-1-git-send-email-rodrigue@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>

Nokia hasn't gotten back to me in over 1 month for a relicense
change request. There are only a few changes that they contributed,
so just reverting their changes but replacing with another set.
This change replaces this commit:

commit 269ac5fd2d75b118d76a2291e28796527db2f3f8
Author: Kalle Valo <kalle.valo@nokia.com>
Date:   Tue Dec 1 10:47:15 2009 +0200

    cfg80211: indent regulatory messages with spaces

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

    Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
    Acked: Luis R. Rodriguez <lrodriguez@atheros.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

Cc: Petri Karhula <petri.karhula@nokia.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 net/wireless/reg.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index a7d252e..c0e0e42 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1987,7 +1987,7 @@ static void print_rd_rules(const struct ieee80211_regdomain *rd)
 	const struct ieee80211_freq_range *freq_range = NULL;
 	const struct ieee80211_power_rule *power_rule = NULL;
 
-	pr_info("    (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)\n");
+	pr_info("  (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)\n");
 
 	for (i = 0; i < rd->n_reg_rules; i++) {
 		reg_rule = &rd->reg_rules[i];
@@ -1999,14 +1999,14 @@ static void print_rd_rules(const struct ieee80211_regdomain *rd)
 		 * in certain regions
 		 */
 		if (power_rule->max_antenna_gain)
-			pr_info("    (%d KHz - %d KHz @ %d KHz), (%d mBi, %d mBm)\n",
+			pr_info("  (%d KHz - %d KHz @ %d KHz), (%d mBi, %d mBm)\n",
 				freq_range->start_freq_khz,
 				freq_range->end_freq_khz,
 				freq_range->max_bandwidth_khz,
 				power_rule->max_antenna_gain,
 				power_rule->max_eirp);
 		else
-			pr_info("    (%d KHz - %d KHz @ %d KHz), (N/A, %d mBm)\n",
+			pr_info("  (%d KHz - %d KHz @ %d KHz), (N/A, %d mBm)\n",
 				freq_range->start_freq_khz,
 				freq_range->end_freq_khz,
 				freq_range->max_bandwidth_khz,
-- 
1.7.4.15.g7811d

