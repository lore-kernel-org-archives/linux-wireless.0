Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4407 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580Ab3JAIx7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Oct 2013 04:53:59 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "Ben Hutchings" <ben@decadent.org.uk>
cc: "Linux Wireless" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 1/4] brcm: rename firmware names expressing host
 interface type
Date: Tue, 1 Oct 2013 10:53:07 +0200
Message-ID: <1380617590-5120-2-git-send-email-arend@broadcom.com> (sfid-20131001_105517_342538_A3AAC0E1)
In-Reply-To: <1380617590-5120-1-git-send-email-arend@broadcom.com>
References: <1380617590-5120-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The firmware name used in brcmfmac for SDIO devices was named
generically as brcmfmac-sdio.bin. To use the brcmfmac SDIO driver
the user had to copy the appropriate firmware to brcmfmac-sdio.bin.

This turned out to be inconvenient for developers switching different
devices on their system so brcmfmac was changed to use chip specific
filenames according format brcmfmac<chipid>-sdio.bin. This patch renames
the existing SDIO firmware files to match this format.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 WHENCE                                           |    6 +++---
 brcm/{brcmfmac4329.bin => brcmfmac4329-sdio.bin} |  Bin 253748 -> 253748 bytes
 brcm/{brcmfmac4330.bin => brcmfmac4330-sdio.bin} |  Bin 222126 -> 222126 bytes
 brcm/{brcmfmac4334.bin => brcmfmac4334-sdio.bin} |  Bin 451566 -> 451566 bytes
 4 files changed, 3 insertions(+), 3 deletions(-)
 rename brcm/{brcmfmac4329.bin => brcmfmac4329-sdio.bin} (100%)
 rename brcm/{brcmfmac4330.bin => brcmfmac4330-sdio.bin} (100%)
 rename brcm/{brcmfmac4334.bin => brcmfmac4334-sdio.bin} (100%)

diff --git a/WHENCE b/WHENCE
index e66fea5..c9fdd8e 100644
--- a/WHENCE
+++ b/WHENCE
@@ -1687,9 +1687,9 @@ Driver: brcmfmac - Broadcom 802.11n fullmac wireless LAN driver.
 
 File: brcm/bcm4329-fullmac-4.bin
 File: brcm/brcmfmac43236b.bin
-File: brcm/brcmfmac4329.bin
-File: brcm/brcmfmac4330.bin
-File: brcm/brcmfmac4334.bin
+File: brcm/brcmfmac4329-sdio.bin
+File: brcm/brcmfmac4330-sdio.bin
+File: brcm/brcmfmac4334-sdio.bin
 
 Licence: Redistributable. See LICENCE.broadcom_bcm43xx for details.
 
diff --git a/brcm/brcmfmac4329.bin b/brcm/brcmfmac4329-sdio.bin
similarity index 100%
rename from brcm/brcmfmac4329.bin
rename to brcm/brcmfmac4329-sdio.bin
diff --git a/brcm/brcmfmac4330.bin b/brcm/brcmfmac4330-sdio.bin
similarity index 100%
rename from brcm/brcmfmac4330.bin
rename to brcm/brcmfmac4330-sdio.bin
diff --git a/brcm/brcmfmac4334.bin b/brcm/brcmfmac4334-sdio.bin
similarity index 100%
rename from brcm/brcmfmac4334.bin
rename to brcm/brcmfmac4334-sdio.bin
-- 
1.7.10.4


