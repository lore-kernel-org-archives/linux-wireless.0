Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:41828 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932476Ab3CPSTx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Mar 2013 14:19:53 -0400
From: stf_xl@wp.pl
To: "John W. Linville\"" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 10/25] rt2800: 5592: initalize BBP_R103 register on new revisions
Date: Sat, 16 Mar 2013 19:19:38 +0100
Message-Id: <1363457993-15541-11-git-send-email-stf_xl@wp.pl> (sfid-20130316_191957_248331_FBFED824)
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
 drivers/net/wireless/rt2x00/rt2800lib.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index e6d2b14a..554bd9b 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -3853,6 +3853,8 @@ static void rt2800_init_bbp_5592(struct rt2x00_dev *rt2x00dev)
 	}
 
 	rt2800_bbp_write(rt2x00dev, 84, 0x19);
+	if (rt2x00_rt_rev_gte(rt2x00dev, RT5592, REV_RT5592C))
+		rt2800_bbp_write(rt2x00dev, 103, 0xc0);
 }
 
 static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
-- 
1.7.4.4

