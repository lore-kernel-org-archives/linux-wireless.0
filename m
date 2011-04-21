Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4723 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691Ab1DUSah (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2011 14:30:37 -0400
From: "Henry Ptasinski" <henryp@broadcom.com>
To: dwmw2@infradead.org
cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	henryp@broadcom.com, brudley@broadcom.com, rvossen@broadcom.com,
	arend@broadcom.com, "Henry Ptasinski" <henryp@broadcom.com>
Subject: [PATCH 2/3] linux-firmware: Removed codeversion from brcm
 firmware filenames.
Date: Thu, 21 Apr 2011 11:30:23 -0700
Message-ID: <1303410624-10560-3-git-send-email-henryp@broadcom.com>
In-Reply-To: <1303410624-10560-1-git-send-email-henryp@broadcom.com>
References: <1302015522-20601-4-git-send-email-henryp@broadcom.com>
 <1303410624-10560-1-git-send-email-henryp@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The basename-apiversion-codeversion construction for firmware filenames is not
used by most other firmware files, adds complexity, and is not providing any
value.  Renamed the firmware files using just basename-apiversion and fixed
WHENCE to have correct names and path to these files.

Signed-off-by: Henry Ptasinski <henryp@broadcom.com>
---
 WHENCE                                             |   12 ++++++------
 ...llmac-4-218-248-5.bin => bcm4329-fullmac-4.bin} |  Bin 269595 -> 269595 bytes
 ...llmac-4-218-248-5.txt => bcm4329-fullmac-4.txt} |    0
 brcm/{bcm43xx-0-610-809-0.fw => bcm43xx-0.fw}      |  Bin 97376 -> 97376 bytes
 ...bcm43xx_hdr-0-610-809-0.fw => bcm43xx_hdr-0.fw} |  Bin 180 -> 180 bytes
 5 files changed, 6 insertions(+), 6 deletions(-)
 rename brcm/{bcm4329-fullmac-4-218-248-5.bin => bcm4329-fullmac-4.bin} (100%)
 rename brcm/{bcm4329-fullmac-4-218-248-5.txt => bcm4329-fullmac-4.txt} (100%)
 rename brcm/{bcm43xx-0-610-809-0.fw => bcm43xx-0.fw} (100%)
 rename brcm/{bcm43xx_hdr-0-610-809-0.fw => bcm43xx_hdr-0.fw} (100%)

diff --git a/WHENCE b/WHENCE
index 6632b85..c81a2b4 100644
--- a/WHENCE
+++ b/WHENCE
@@ -1433,19 +1433,19 @@ Licence:
 
 --------------------------------------------------------------------------
 
-Driver: brcm80211 - Broadcom 802.11n wireless LAN driver.
+Driver: brcmsmac - Broadcom 802.11n softmac wireless LAN driver.
 
-File: brcm/bcm43xx-0-610-809-0.fw
-File: brcm/bcm43xx_hdr-0-610-809-0.fw
+File: brcm/bcm43xx-0.fw
+File: brcm/bcm43xx_hdr-0.fw
 
 Licence: Redistributable. See LICENCE.broadcom_bcm43xx for details.
 
 --------------------------------------------------------------------------
 
-Driver: brcm80211 - Broadcom 802.11n wireless LAN driver.
+Driver: brcmfmac - Broadcom 802.11n fullmac wireless LAN driver.
 
-File: bcm4329-fullmac-4-218-248-5.bin
-File: bcm4329-fullmac-4-218-248-5.txt
+File: brcm/bcm4329-fullmac-4.bin
+File: brcm/bcm4329-fullmac-4.txt
 
 Licence: Redistributable. See LICENCE.broadcom_bcm43xx for details.
 
diff --git a/brcm/bcm4329-fullmac-4-218-248-5.bin b/brcm/bcm4329-fullmac-4.bin
similarity index 100%
rename from brcm/bcm4329-fullmac-4-218-248-5.bin
rename to brcm/bcm4329-fullmac-4.bin
diff --git a/brcm/bcm4329-fullmac-4-218-248-5.txt b/brcm/bcm4329-fullmac-4.txt
similarity index 100%
rename from brcm/bcm4329-fullmac-4-218-248-5.txt
rename to brcm/bcm4329-fullmac-4.txt
diff --git a/brcm/bcm43xx-0-610-809-0.fw b/brcm/bcm43xx-0.fw
similarity index 100%
rename from brcm/bcm43xx-0-610-809-0.fw
rename to brcm/bcm43xx-0.fw
diff --git a/brcm/bcm43xx_hdr-0-610-809-0.fw b/brcm/bcm43xx_hdr-0.fw
similarity index 100%
rename from brcm/bcm43xx_hdr-0-610-809-0.fw
rename to brcm/bcm43xx_hdr-0.fw
-- 
1.7.4.5


