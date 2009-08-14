Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f215.google.com ([209.85.220.215]:42334 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbZHNMLx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 08:11:53 -0400
Received: by fxm11 with SMTP id 11so1126253fxm.39
        for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2009 05:11:53 -0700 (PDT)
Message-ID: <4A855489.6010102@gmail.com>
Date: Fri, 14 Aug 2009 14:11:53 +0200
From: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Mark Huijgen <mark@huijgen.tk>
CC: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] ssb: Fix e typo in the rev8 SPROM extraction routine
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No comment. :-)

Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
---
Mark, this should fix your MAC address bug.
Anyone else testing LP-PHY should also apply this.

 drivers/ssb/pci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ssb/pci.c b/drivers/ssb/pci.c
index 50811e4..335a43f 100644
--- a/drivers/ssb/pci.c
+++ b/drivers/ssb/pci.c
@@ -480,7 +480,7 @@ static void sprom_extract_r8(struct ssb_sprom *out, const u16 *in)
 
 	/* extract the MAC address */
 	for (i = 0; i < 3; i++) {
-		v = in[SPOFF(SSB_SPROM1_IL0MAC) + i];
+		v = in[SPOFF(SSB_SPROM8_IL0MAC) + i];
 		*(((__be16 *)out->il0mac) + i) = cpu_to_be16(v);
 	}
 	SPEX(country_code, SSB_SPROM8_CCODE, 0xFFFF, 0);
-- 
1.6.2.4



