Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12540 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759257Ab2FUSap (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 14:30:45 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH 3/3] ath9k: fix 'side effect in macro' smatch warning
Date: Fri, 22 Jun 2012 00:01:32 +0530
Message-ID: <1340303492-30947-4-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120621_203047_867277_DA679F15)
In-Reply-To: <1340303492-30947-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1340303492-30947-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k_get_et_stats() warn: side effect in macro
'AWDATA' doing 'i++'

Cc: Ben Greear <greearb@candelatech.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 85f9ab4..32474b0 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2003,10 +2003,11 @@ static int ath9k_get_et_sset_count(struct ieee80211_hw *hw,
 #define PR_QNUM(_n) (sc->tx.txq_map[_n]->axq_qnum)
 #define AWDATA(elem)							\
 	do {								\
-		data[i++] = sc->debug.stats.txstats[PR_QNUM(WME_AC_BE)].elem; \
-		data[i++] = sc->debug.stats.txstats[PR_QNUM(WME_AC_BK)].elem; \
-		data[i++] = sc->debug.stats.txstats[PR_QNUM(WME_AC_VI)].elem; \
-		data[i++] = sc->debug.stats.txstats[PR_QNUM(WME_AC_VO)].elem; \
+		data[i+0] = sc->debug.stats.txstats[PR_QNUM(WME_AC_BE)].elem; \
+		data[i+1] = sc->debug.stats.txstats[PR_QNUM(WME_AC_BK)].elem; \
+		data[i+2] = sc->debug.stats.txstats[PR_QNUM(WME_AC_VI)].elem; \
+		data[i+3] = sc->debug.stats.txstats[PR_QNUM(WME_AC_VO)].elem; \
+		i += 4; \
 	} while (0)
 
 #define AWDATA_RX(elem)						\
-- 
1.7.11

