Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:36984 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932506Ab3CPSTy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Mar 2013 14:19:54 -0400
From: stf_xl@wp.pl
To: "John W. Linville\"" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 11/25] rt2800: 5592: initialize BBP_R138 register
Date: Sat, 16 Mar 2013 19:19:39 +0100
Message-Id: <1363457993-15541-12-git-send-email-stf_xl@wp.pl> (sfid-20130316_191958_652619_260F984B)
In-Reply-To: <1363457993-15541-1-git-send-email-stf_xl@wp.pl>
References: <1363457993-15541-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

Based on:
RT5592LoadRFNormalModeSetup()

from:
DPO_RT5572_LinuxSTA_2.6.1.3_20121022/chips/rt5592.c

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 554bd9b..12e4313 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4859,7 +4859,8 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 		rt2800_rfcsr_write(rt2x00dev, 17, rfcsr);
 	}
 
-	if (rt2x00_rt(rt2x00dev, RT3090)) {
+	if (rt2x00_rt(rt2x00dev, RT3090) ||
+	    rt2x00_rt(rt2x00dev, RT5592)) {
 		rt2800_bbp_read(rt2x00dev, 138, &bbp);
 
 		/*  Turn off unused DAC1 and ADC1 to reduce power consumption */
-- 
1.7.4.4

