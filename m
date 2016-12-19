Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42352 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758313AbcLSKzI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Dec 2016 05:55:08 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 06/11] rt2800: warn if doing VCO recalibration for unknow RF chip
Date: Mon, 19 Dec 2016 11:52:52 +0100
Message-Id: <1482144777-16760-7-git-send-email-sgruszka@redhat.com> (sfid-20161219_115822_069997_AF715AAC)
In-Reply-To: <1482144777-16760-1-git-send-email-sgruszka@redhat.com>
References: <1482144777-16760-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since we reset TX_PIN_CFG register, we have to finish recalibration.
Warn if this is not possible.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 65f20ca..5ceb006 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -4346,6 +4346,8 @@ void rt2800_vco_calibration(struct rt2x00_dev *rt2x00dev)
 		rt2800_rfcsr_write(rt2x00dev, 3, rfcsr);
 		break;
 	default:
+		WARN_ONCE(1, "Not supported RF chipet %x for VCO recalibration",
+			  rt2x00dev->chip.rf);
 		return;
 	}
 
-- 
1.7.1
