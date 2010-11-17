Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37912 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935040Ab0KQSwq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Nov 2010 13:52:46 -0500
Received: by wyb28 with SMTP id 28so2288664wyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 17 Nov 2010 10:52:45 -0800 (PST)
From: =?utf-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael Gerdau <mgd@qata.de>
Cc: b43-dev@lists.infradead.org,
	=?utf-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] ssb: drop BCM4328 hack for SPROM revision
Date: Wed, 17 Nov 2010 19:52:13 +0100
Message-Id: <1290019933-9924-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This hacks leads to incorrect SPROM parsing for me and reading for example MAC
as: 00:00:00:54:00:00. Michael G. who introduced this confirmed it is not
needed anymore.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
Michael: I guess I could add your Tested-by. Is that right?

John: it's 2.6.38 ofc. It should apply cleanly no matter if you applied my
previous patch for guessing unknown SPROM revision. There is not dependence
between that 2 patches.
---
 drivers/ssb/pci.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/ssb/pci.c b/drivers/ssb/pci.c
index b5343ac..f529663 100644
--- a/drivers/ssb/pci.c
+++ b/drivers/ssb/pci.c
@@ -580,10 +580,6 @@ static int sprom_extract(struct ssb_bus *bus, struct ssb_sprom *out,
 		 * Always extract r1. */
 		out->revision = 1;
 		ssb_dprintk(KERN_DEBUG PFX "SPROM treated as revision %d\n", out->revision);
-	} else if (bus->chip_id == 0x4321) {
-		/* the BCM4328 has a chipid == 0x4321 and a rev 4 SPROM */
-		out->revision = 4;
-		ssb_dprintk(KERN_DEBUG PFX "SPROM treated as revision %d\n", out->revision);
 	}
 
 	switch (out->revision) {
-- 
1.6.0.4

