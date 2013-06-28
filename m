Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:49924 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752468Ab3F1TNR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jun 2013 15:13:17 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 15/19] rt2x00: rt2800lib: enable VCO recalibration for RF3053
Date: Fri, 28 Jun 2013 21:12:29 +0200
Message-Id: <1372446753-11408-16-git-send-email-juhosg@openwrt.org> (sfid-20130628_211335_359197_D70E70AF)
In-Reply-To: <1372446753-11408-1-git-send-email-juhosg@openwrt.org>
References: <1372446753-11408-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index ab67dba..0a0f96f 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4196,6 +4196,7 @@ void rt2800_vco_calibration(struct rt2x00_dev *rt2x00dev)
 		rt2800_rfcsr_write(rt2x00dev, 7, rfcsr);
 		break;
 	case RF3290:
+	case RF3053:
 	case RF5360:
 	case RF5370:
 	case RF5372:
@@ -7596,6 +7597,7 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	case RF3022:
 	case RF3320:
 	case RF3052:
+	case RF3053:
 	case RF3290:
 	case RF5360:
 	case RF5370:
-- 
1.7.10

