Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:36975 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932495Ab3CPSTv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Mar 2013 14:19:51 -0400
From: stf_xl@wp.pl
To: "John W. Linville\"" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 09/25] rt2800: 5592: initalize RF_R27 on older revisions
Date: Sat, 16 Mar 2013 19:19:37 +0100
Message-Id: <1363457993-15541-10-git-send-email-stf_xl@wp.pl> (sfid-20130316_191956_480352_581D69C1)
In-Reply-To: <1363457993-15541-1-git-send-email-stf_xl@wp.pl>
References: <1363457993-15541-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

Based on:
NICInitRT5592RFRegisters()

from:
DPO_RT5572_LinuxSTA_2.6.1.3_20121022/chips/rt5592.c

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 57afd6b..e6d2b14a 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4832,7 +4832,8 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 	if (rt2x00_rt_rev_lt(rt2x00dev, RT3070, REV_RT3070F) ||
 	    rt2x00_rt_rev_lt(rt2x00dev, RT3071, REV_RT3071E) ||
 	    rt2x00_rt_rev_lt(rt2x00dev, RT3090, REV_RT3090E) ||
-	    rt2x00_rt_rev_lt(rt2x00dev, RT3390, REV_RT3390E))
+	    rt2x00_rt_rev_lt(rt2x00dev, RT3390, REV_RT3390E) ||
+	    rt2x00_rt_rev_lt(rt2x00dev, RT5592, REV_RT5592C))
 		rt2800_rfcsr_write(rt2x00dev, 27, 0x03);
 
 	rt2800_register_read(rt2x00dev, OPT_14_CSR, &reg);
-- 
1.7.4.4

