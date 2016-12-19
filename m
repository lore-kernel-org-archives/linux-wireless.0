Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39964 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758347AbcLSKzM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Dec 2016 05:55:12 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 09/11] rt2800: replace mdelay by usleep on vco calibration.
Date: Mon, 19 Dec 2016 11:52:55 +0100
Message-Id: <1482144777-16760-10-git-send-email-sgruszka@redhat.com> (sfid-20161219_115615_515968_FBBA82E4)
In-Reply-To: <1482144777-16760-1-git-send-email-sgruszka@redhat.com>
References: <1482144777-16760-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This procedure can sleep, hence mdelay is not needed.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 615eaf8..29d98e4 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -4352,7 +4352,7 @@ void rt2800_vco_calibration(struct rt2x00_dev *rt2x00dev)
 		return;
 	}
 
-	mdelay(1);
+	usleep_range(1000, 1500);
 
 	rt2800_register_read(rt2x00dev, TX_PIN_CFG, &tx_pin);
 	if (rt2x00dev->rf_channel <= 14) {
-- 
1.7.1
