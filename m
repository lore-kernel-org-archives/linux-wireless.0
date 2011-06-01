Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48694 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758644Ab1FAJAy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 05:00:54 -0400
Received: by eyx24 with SMTP id 24so1941983eyx.19
        for <linux-wireless@vger.kernel.org>; Wed, 01 Jun 2011 02:00:53 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Andreas Schwab <schwab@linux-m68k.org>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	=?UTF-8?q?Michael=20B=C3=BCsch?= <mb@bu3sch.de>
Cc: b43-dev@lists.infradead.org, linuxppc-dev@ozlabs.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [RFT][PATCH 3.0] ssb: fix PCI(e) driver regression causing oops on PCI cards
Date: Wed,  1 Jun 2011 11:01:11 +0200
Message-Id: <1306918871-16965-1-git-send-email-zajec5@gmail.com> (sfid-20110601_110106_886498_B43F3D46)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We were incorrectly executing PCIe specific workarounds on PCI cards.
This resulted in:
Machine check in kernel mode.
Caused by (from SRR1=149030): Transfer error ack signal
Oops: Machine check, sig: 7 [#1]

Reported-by: Andreas Schwab <schwab@linux-m68k.org>
Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/ssb/driver_pcicore.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/ssb/driver_pcicore.c b/drivers/ssb/driver_pcicore.c
index 82feb34..2a20dab 100644
--- a/drivers/ssb/driver_pcicore.c
+++ b/drivers/ssb/driver_pcicore.c
@@ -539,10 +539,12 @@ void ssb_pcicore_init(struct ssb_pcicore *pc)
 	if (!pc->hostmode)
 		ssb_pcicore_init_clientmode(pc);
 
-	/* Additional always once-executed workarounds */
-	ssb_pcicore_serdes_workaround(pc);
-	/* TODO: ASPM */
-	/* TODO: Clock Request Update */
+	/* Additional PCIe always once-executed workarounds */
+	if (dev->id.coreid == SSB_DEV_PCIE) {
+		ssb_pcicore_serdes_workaround(pc);
+		/* TODO: ASPM */
+		/* TODO: Clock Request Update */
+	}
 }
 
 static u32 ssb_pcie_read(struct ssb_pcicore *pc, u32 address)
-- 
1.7.1

