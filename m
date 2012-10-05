Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31822 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755391Ab2JELp5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Oct 2012 07:45:57 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 3/7] rt2800: compensate tx power also for non 11b rates on 2GHz
Date: Fri,  5 Oct 2012 13:44:11 +0200
Message-Id: <1349437455-18754-3-git-send-email-sgruszka@redhat.com> (sfid-20121005_134559_821001_53A9A714)
In-Reply-To: <1349437455-18754-1-git-send-email-sgruszka@redhat.com>
References: <1349437455-18754-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We skip compensate calculation for non 11b rates on 2.4GHz band. I do
not see that on vendor driver
(2011_0719_RT3070_RT3370_RT5370_RT5372_Linux_STA_V2.5.0.3_DPO).

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index f3060d3..57ffbca 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2531,9 +2531,6 @@ static u8 rt2800_compensate_txpower(struct rt2x00_dev *rt2x00dev, int is_rate_b,
 	u8 eirp_txpower_criterion;
 	u8 reg_limit;
 
-	if (!((band == IEEE80211_BAND_5GHZ) && is_rate_b))
-		return txpower;
-
 	if (test_bit(CAPABILITY_POWER_LIMIT, &rt2x00dev->cap_flags)) {
 		/*
 		 * Check if eirp txpower exceed txpower_limit.
-- 
1.7.1

