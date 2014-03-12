Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61870 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752942AbaCLOLg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Mar 2014 10:11:36 -0400
Date: Wed, 12 Mar 2014 15:14:04 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Kevin Lo <kevlo@kevlo.org>
Subject: [PATCH 3.14] Revert "rt2x00: rt2800lib: Update BBP register
 initialization for RT53xx"
Message-ID: <20140312141403.GA1924@redhat.com> (sfid-20140312_151139_442026_0D127706)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts commit eac40d9631a7db43570df859fa8a9922e9623607. It cause
random connection drops on RT5390 PCI adapters.

On Mediatek there is different driver version available for RT53xx chip
based on bus type (2.5.0.3 for PCI and 2.6.1.3 for USB). Hence possibly
we should set registers differently based on bus type. But is also
possible that new driver (i.e. 2.6.1.3) was not verified on RT53xx USB.

Until we figure out how to initialize registers properly for RT53xx just
revert commit eac40d9631a7db43570df859fa8a9922e9623607 since it cause
regression.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
John, if possible queue this patch to 3.14, if not plese add
Cc: <stable@vger.kernel.org> #3.14+

 drivers/net/wireless/rt2x00/rt2800lib.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 7f8b5d1..41d4a81 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -5460,14 +5460,15 @@ static void rt2800_init_bbp_53xx(struct rt2x00_dev *rt2x00dev)
 
 	rt2800_bbp_write(rt2x00dev, 68, 0x0b);
 
-	rt2800_bbp_write(rt2x00dev, 69, 0x0d);
-	rt2800_bbp_write(rt2x00dev, 70, 0x06);
+	rt2800_bbp_write(rt2x00dev, 69, 0x12);
 	rt2800_bbp_write(rt2x00dev, 73, 0x13);
 	rt2800_bbp_write(rt2x00dev, 75, 0x46);
 	rt2800_bbp_write(rt2x00dev, 76, 0x28);
 
 	rt2800_bbp_write(rt2x00dev, 77, 0x59);
 
+	rt2800_bbp_write(rt2x00dev, 70, 0x0a);
+
 	rt2800_bbp_write(rt2x00dev, 79, 0x13);
 	rt2800_bbp_write(rt2x00dev, 80, 0x05);
 	rt2800_bbp_write(rt2x00dev, 81, 0x33);
@@ -5510,7 +5511,6 @@ static void rt2800_init_bbp_53xx(struct rt2x00_dev *rt2x00dev)
 	if (rt2x00_rt(rt2x00dev, RT5392)) {
 		rt2800_bbp_write(rt2x00dev, 134, 0xd0);
 		rt2800_bbp_write(rt2x00dev, 135, 0xf6);
-		rt2800_bbp_write(rt2x00dev, 148, 0x84);
 	}
 
 	rt2800_disable_unused_dac_adc(rt2x00dev);
-- 
1.7.11.7

