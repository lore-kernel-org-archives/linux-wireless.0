Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:57868 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727383AbeHGK5C (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Aug 2018 06:57:02 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH] mt76x0: perform mt76x0_mac_set_ampdu_factor
Date: Tue,  7 Aug 2018 10:43:37 +0200
Message-Id: <1533631417-477-1-git-send-email-sgruszka@redhat.com> (sfid-20180807_104356_242596_024BCA5F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove return added accidentally in mt76x0_mac_set_ampdu_factor.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: a77443498137 ("mt76x0: mac files")
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/mac.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
index 95f28492a843..91a84be36d3b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
@@ -424,8 +424,6 @@ void mt76x0_mac_set_ampdu_factor(struct mt76x0_dev *dev)
 	u8 min_factor = 3;
 	int i;
 
-	return;
-
 	rcu_read_lock();
 	for (i = 0; i < ARRAY_SIZE(dev->wcid); i++) {
 		wcid = rcu_dereference(dev->wcid[i]);
-- 
1.9.3
