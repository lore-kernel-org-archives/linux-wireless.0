Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:36999 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932506Ab3CPST4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Mar 2013 14:19:56 -0400
From: stf_xl@wp.pl
To: "John W. Linville\"" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 12/25] rt2800: 5592: initialize RF_38/39/30 registers
Date: Sat, 16 Mar 2013 19:19:40 +0100
Message-Id: <1363457993-15541-13-git-send-email-stf_xl@wp.pl> (sfid-20130316_191959_984378_2B827EED)
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
index 12e4313..54d9089 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4916,7 +4916,8 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 	}
 
 	if (rt2x00_rt(rt2x00dev, RT5390) ||
-	    rt2x00_rt(rt2x00dev, RT5392)) {
+	    rt2x00_rt(rt2x00dev, RT5392) ||
+	    rt2x00_rt(rt2x00dev, RT5592)) {
 		rt2800_rfcsr_read(rt2x00dev, 38, &rfcsr);
 		rt2x00_set_field8(&rfcsr, RFCSR38_RX_LO1_EN, 0);
 		rt2800_rfcsr_write(rt2x00dev, 38, rfcsr);
-- 
1.7.4.4

