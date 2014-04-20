Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:61649 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755321AbaDTLGX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Apr 2014 07:06:23 -0400
Received: by mail-ee0-f42.google.com with SMTP id d17so2948387eek.1
        for <linux-wireless@vger.kernel.org>; Sun, 20 Apr 2014 04:06:22 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 9/9] b43: N-PHY: enable forgotten write of hw power adjust table
Date: Sun, 20 Apr 2014 13:05:51 +0200
Message-Id: <1397991951-13478-10-git-send-email-zajec5@gmail.com> (sfid-20140420_130706_675846_C5C9830C)
In-Reply-To: <1397991951-13478-1-git-send-email-zajec5@gmail.com>
References: <1397991951-13478-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We've implemented table calculation, but forgot to enable writing it in
power setup function.
By the way document table layout.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 291b38c..482b312 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -3400,6 +3400,20 @@ static void b43_nphy_tx_prepare_adjusted_power_table(struct b43_wldev *dev)
 	u8 idx, delta;
 	u8 i, stf_mode;
 
+	/* Array adj_pwr_tbl corresponds to the hardware table. It consists of
+	 * 21 groups, each containing 4 entries.
+	 *
+	 * First group has entries for CCK modulation.
+	 * The rest of groups has 1 entry per modulation (SISO, CDD, STBC, SDM).
+	 *
+	 * Group 0 is for CCK
+	 * Groups 1..4 use BPSK (group per coding rate)
+	 * Groups 5..8 use QPSK (group per coding rate)
+	 * Groups 9..12 use 16-QAM (group per coding rate)
+	 * Groups 13..16 use 64-QAM (group per coding rate)
+	 * Groups 17..20 are unknown
+	 */
+
 	for (i = 0; i < 4; i++)
 		nphy->adj_pwr_tbl[i] = nphy->tx_power_offset[i];
 
@@ -3598,10 +3612,8 @@ static void b43_nphy_tx_power_ctl_setup(struct b43_wldev *dev)
 	}
 
 	b43_nphy_tx_prepare_adjusted_power_table(dev);
-	/*
 	b43_ntab_write_bulk(dev, B43_NTAB16(26, 64), 84, nphy->adj_pwr_tbl);
 	b43_ntab_write_bulk(dev, B43_NTAB16(27, 64), 84, nphy->adj_pwr_tbl);
-	*/
 
 	if (nphy->hang_avoid)
 		b43_nphy_stay_in_carrier_search(dev, false);
-- 
1.8.4.5

