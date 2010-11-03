Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42598 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158Ab0KCW3c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Nov 2010 18:29:32 -0400
Received: by wyf28 with SMTP id 28so1170627wyf.19
        for <linux-wireless@vger.kernel.org>; Wed, 03 Nov 2010 15:29:31 -0700 (PDT)
From: =?utf-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	=?utf-8?q?Michael=20B=C3=BCsch?= <mb@bu3sch.de>
Cc: b43-dev@lists.infradead.org,
	=?utf-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] ssb: fail registration for unknown SPROM revision
Date: Wed,  3 Nov 2010 23:28:46 +0100
Message-Id: <1288823326-9686-2-git-send-email-zajec5@gmail.com>
In-Reply-To: <1288823326-9686-1-git-send-email-zajec5@gmail.com>
References: <1288823326-9686-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
As noticed my Michael we have this left from old times of limited amount of
revisions. It's not reliable to treat unknown as rev1.

Michael: would you like to add Reported-by?

John: it's for 2.6.38.
---
 drivers/ssb/pci.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/ssb/pci.c b/drivers/ssb/pci.c
index b5343ac..41a7337 100644
--- a/drivers/ssb/pci.c
+++ b/drivers/ssb/pci.c
@@ -600,11 +600,9 @@ static int sprom_extract(struct ssb_bus *bus, struct ssb_sprom *out,
 		sprom_extract_r8(out, in);
 		break;
 	default:
-		ssb_printk(KERN_WARNING PFX "Unsupported SPROM"
-			   "  revision %d detected. Will extract"
-			   " v1\n", out->revision);
-		out->revision = 1;
-		sprom_extract_r123(out, in);
+		ssb_printk(KERN_ERR PFX "Unsupported SPROM revision %d"
+			   " detected\n", out->revision);
+		return -EINVAL;
 	}
 
 	if (out->boardflags_lo == 0xFFFF)
-- 
1.6.0.4

