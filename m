Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46444 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754872AbcKBOMg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Nov 2016 10:12:36 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 10/10] rt2800: disable CCK rates on HT
Date: Wed,  2 Nov 2016 15:11:05 +0100
Message-Id: <1478095865-8651-11-git-send-email-sgruszka@redhat.com> (sfid-20161102_151240_807097_06F4F89A)
In-Reply-To: <1478095865-8651-1-git-send-email-sgruszka@redhat.com>
References: <1478095865-8651-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sending frames in CCK rates on HT can cause performance problems.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 8d35b2e..2515702 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -7475,7 +7475,6 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Initialize all hw fields.
 	 */
-	ieee80211_hw_set(rt2x00dev->hw, SUPPORTS_HT_CCK_RATES);
 	ieee80211_hw_set(rt2x00dev->hw, REPORTS_TX_ACK_STATUS);
 	ieee80211_hw_set(rt2x00dev->hw, AMPDU_AGGREGATION);
 	ieee80211_hw_set(rt2x00dev->hw, PS_NULLFUNC_STACK);
-- 
1.7.1
