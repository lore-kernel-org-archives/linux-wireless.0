Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55075 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755126Ab1EHQbt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 May 2011 12:31:49 -0400
Received: by mail-ey0-f174.google.com with SMTP id 24so1350122eyx.19
        for <linux-wireless@vger.kernel.org>; Sun, 08 May 2011 09:31:48 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	=?UTF-8?q?Michael=20B=C3=BCsch?= <mb@bu3sch.de>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/3] ssb: update list of devices supporting multiple 80211 cores
Date: Sun,  8 May 2011 19:09:22 +0200
Message-Id: <1304874564-6426-2-git-send-email-zajec5@gmail.com> (sfid-20110508_183154_242909_AA632902)
In-Reply-To: <1304874564-6426-1-git-send-email-zajec5@gmail.com>
References: <1304874564-6426-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/ssb/scan.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/ssb/scan.c b/drivers/ssb/scan.c
index 7dca719..45e5bab 100644
--- a/drivers/ssb/scan.c
+++ b/drivers/ssb/scan.c
@@ -258,7 +258,10 @@ static int we_support_multiple_80211_cores(struct ssb_bus *bus)
 #ifdef CONFIG_SSB_PCIHOST
 	if (bus->bustype == SSB_BUSTYPE_PCI) {
 		if (bus->host_pci->vendor == PCI_VENDOR_ID_BROADCOM &&
-		    bus->host_pci->device == 0x4324)
+		    ((bus->host_pci->device == 0x4313) ||
+		     (bus->host_pci->device == 0x431A) ||
+		     (bus->host_pci->device == 0x4321) ||
+		     (bus->host_pci->device == 0x4324)))
 			return 1;
 	}
 #endif /* CONFIG_SSB_PCIHOST */
-- 
1.7.3.4

