Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42356 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758331AbcLSKzJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Dec 2016 05:55:09 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 07/11] rt2800: perform VCO recalibration for RF5592 chip
Date: Mon, 19 Dec 2016 11:52:53 +0100
Message-Id: <1482144777-16760-8-git-send-email-sgruszka@redhat.com> (sfid-20161219_120034_317423_8E0824BD)
In-Reply-To: <1482144777-16760-1-git-send-email-sgruszka@redhat.com>
References: <1482144777-16760-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 5ceb006..615eaf8 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -4341,6 +4341,7 @@ void rt2800_vco_calibration(struct rt2x00_dev *rt2x00dev)
 	case RF5372:
 	case RF5390:
 	case RF5392:
+	case RF5592:
 		rt2800_rfcsr_read(rt2x00dev, 3, &rfcsr);
 		rt2x00_set_field8(&rfcsr, RFCSR3_VCOCAL_EN, 1);
 		rt2800_rfcsr_write(rt2x00dev, 3, rfcsr);
@@ -7719,6 +7720,7 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	case RF5372:
 	case RF5390:
 	case RF5392:
+	case RF5592:
 		__set_bit(CAPABILITY_VCO_RECALIBRATION, &rt2x00dev->cap_flags);
 		break;
 	}
-- 
1.7.1
