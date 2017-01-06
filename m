Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47586 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1033941AbdAFNKE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Jan 2017 08:10:04 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Mathias Kresin <dev@kresin.me>
Subject: [PATCH 4/9] rt2800: change default retry settings
Date: Fri,  6 Jan 2017 14:05:13 +0100
Message-Id: <1483707918-31480-5-git-send-email-sgruszka@redhat.com> (sfid-20170106_141126_448225_477FEFC4)
In-Reply-To: <1483707918-31480-1-git-send-email-sgruszka@redhat.com>
References: <1483707918-31480-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We do not have option to set per frame retry count. We have only global
TX_RTY_CFG registers which specify the number or retries. Set setting
of that register to value that correspond rate control algorithm number
of frame post (number of retries + 1), which is 3 for aggregated frames.
This should help with big amount of retries on bad conditions, hence
mitigate buffer-bloat like problems.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 5436cdb..4833ec6 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -4769,8 +4769,8 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2800_register_write(rt2x00dev, PBF_MAX_PCNT, 0x1f3fbf9f);
 
 	rt2800_register_read(rt2x00dev, TX_RTY_CFG, &reg);
-	rt2x00_set_field32(&reg, TX_RTY_CFG_SHORT_RTY_LIMIT, 15);
-	rt2x00_set_field32(&reg, TX_RTY_CFG_LONG_RTY_LIMIT, 31);
+	rt2x00_set_field32(&reg, TX_RTY_CFG_SHORT_RTY_LIMIT, 2);
+	rt2x00_set_field32(&reg, TX_RTY_CFG_LONG_RTY_LIMIT, 2);
 	rt2x00_set_field32(&reg, TX_RTY_CFG_LONG_RTY_THRE, 2000);
 	rt2x00_set_field32(&reg, TX_RTY_CFG_NON_AGG_RTY_MODE, 0);
 	rt2x00_set_field32(&reg, TX_RTY_CFG_AGG_RTY_MODE, 0);
@@ -7514,6 +7514,13 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	rt2x00dev->hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
 
 	/*
+	 * Change default retry settings to values corresponding more closely
+	 * to rate[0].count setting of minstrel rate control algorithm.
+	 */
+	rt2x00dev->hw->wiphy->retry_short = 2;
+	rt2x00dev->hw->wiphy->retry_long = 2;
+
+	/*
 	 * Initialize all hw fields.
 	 */
 	ieee80211_hw_set(rt2x00dev->hw, REPORTS_TX_ACK_STATUS);
-- 
2.7.4
