Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:48234 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872Ab3GHOIq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jul 2013 10:08:46 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v3 16/20] rt2x00: rt2800lib: enable VCO recalibration for RF3053
Date: Mon,  8 Jul 2013 16:08:31 +0200
Message-Id: <1373292515-21332-17-git-send-email-juhosg@openwrt.org> (sfid-20130708_162043_432995_EB79CE9B)
In-Reply-To: <1373292515-21332-1-git-send-email-juhosg@openwrt.org>
References: <1373292515-21332-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
Changes since v2:
 - keep case statements in alphabetical order
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index e6d6c75..46d5f42 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4194,6 +4194,7 @@ void rt2800_vco_calibration(struct rt2x00_dev *rt2x00dev)
 		rt2x00_set_field8(&rfcsr, RFCSR7_RF_TUNING, 1);
 		rt2800_rfcsr_write(rt2x00dev, 7, rfcsr);
 		break;
+	case RF3053:
 	case RF3290:
 	case RF5360:
 	case RF5370:
@@ -7595,6 +7596,7 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	case RF3022:
 	case RF3320:
 	case RF3052:
+	case RF3053:
 	case RF3290:
 	case RF5360:
 	case RF5370:
-- 
1.7.10

