Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23414 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044Ab3FDMRK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jun 2013 08:17:10 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r54CHAwc016426
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Tue, 4 Jun 2013 08:17:10 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 3.10] iwlegacy: fix rate control regression
Date: Tue,  4 Jun 2013 14:19:10 +0200
Message-Id: <1370348350-17193-1-git-send-email-sgruszka@redhat.com> (sfid-20130604_141714_011486_F966AE64)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since driver does not use control.rates[0].count, we have never set that
variable. But currently, after rate control API rewrite, this is required
by mac80211. Otherwise legacy rates control does not work and we transmit
always at 1Mbit/s on pre 11n networks.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945-rs.c | 1 +
 drivers/net/wireless/iwlegacy/4965-rs.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlegacy/3945-rs.c b/drivers/net/wireless/iwlegacy/3945-rs.c
index c9f197d..fe31590 100644
--- a/drivers/net/wireless/iwlegacy/3945-rs.c
+++ b/drivers/net/wireless/iwlegacy/3945-rs.c
@@ -816,6 +816,7 @@ out:
 		rs_sta->last_txrate_idx = idx;
 		info->control.rates[0].idx = rs_sta->last_txrate_idx;
 	}
+	info->control.rates[0].count = 1;
 
 	D_RATE("leave: %d\n", idx);
 }
diff --git a/drivers/net/wireless/iwlegacy/4965-rs.c b/drivers/net/wireless/iwlegacy/4965-rs.c
index 1fc0b22..ed3c42a 100644
--- a/drivers/net/wireless/iwlegacy/4965-rs.c
+++ b/drivers/net/wireless/iwlegacy/4965-rs.c
@@ -2268,7 +2268,7 @@ il4965_rs_get_rate(void *il_r, struct ieee80211_sta *sta, void *il_sta,
 		info->control.rates[0].flags = 0;
 	}
 	info->control.rates[0].idx = rate_idx;
-
+	info->control.rates[0].count = 1;
 }
 
 static void *
-- 
1.7.11.7

