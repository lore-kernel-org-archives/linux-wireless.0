Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:54652 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963Ab1EHRw4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 May 2011 13:52:56 -0400
Received: by ewy4 with SMTP id 4so1360065ewy.19
        for <linux-wireless@vger.kernel.org>; Sun, 08 May 2011 10:52:55 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	=?UTF-8?q?Michael=20B=C3=BCsch?= <mb@bu3sch.de>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH V2 1/3] ssb: update list of devices supporting multiple 80211 cores
Date: Sun,  8 May 2011 20:30:31 +0200
Message-Id: <1304879433-7096-2-git-send-email-zajec5@gmail.com> (sfid-20110508_195259_610165_9A62A7C7)
In-Reply-To: <1304879433-7096-1-git-send-email-zajec5@gmail.com>
References: <1304879433-7096-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some of the BCM43xx chips contain cores that are attached to the SSB, but are
inactive as they do not connect to the external environment. These must not be
registered. Several of these types are handled in driver ssb; however, the
specific case of an inactive 802.11 cores is now treated in b43 and b43legacy.
Although the current setup works, this minor change will place all such
workarounds in ssb, and simplify the code in drivers b43 and b43legacy.

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

