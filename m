Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1768 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464Ab0LHUuQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Dec 2010 15:50:16 -0500
Date: Wed, 8 Dec 2010 12:50:00 -0800
From: "Henry Ptasinski" <henryp@broadcom.com>
To: "David Woodhouse" <dwmw2@infradead.org>
cc: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"Brett Rudley" <brudley@broadcom.com>,
	"grundler@google.com" <grundler@google.com>,
	"greg@kroah.com" <greg@kroah.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	henryp@broadcom.com, rvossen@broadcom.com, dowan@broadcom.com,
	arend@broadcom.com
Subject: [PATCH v2] linux-firmware: brcm: Removed codeversion from
 firmware filenames.
Message-ID: <20101208205000.GA30861@broadcom.com>
References: <4CBE23F4.4020104@broadcom.com>
 <20101019233520.GA12510@kroah.com>
 <FD96C117992C584DBC47231B1EB6F5568206D859DC@SJEXCHCCR02.corp.ad.broadcom.com>
 <20101020004743.GB31965@kroah.com>
 <20101020005546.GL10832@broadcom.com> <20101020010320.GA370@kroah.com>
 <20101021170810.GA15357@broadcom.com>
 <1288621739.26983.32.camel@macbook.infradead.org>
MIME-Version: 1.0
In-Reply-To: <1288621739.26983.32.camel@macbook.infradead.org>
Content-Type: text/plain;
 charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Second attempt at cleaning up firmware filenames.

The basename-apiversion-codeversion construction for firmware filenames is not
used by most other firmware files, adds complexity, and is not providing any
value.  Renamed the firmware files using just basename-apiversion.  Also, fixed
WHENCE to have correct path to brcmfmac files.

Signed-off-by: Henry Ptasinski <henryp@broadcom.com>
---
 WHENCE                                             |    8 ++++----
 ...llmac-4-218-248-5.bin => bcm4329-fullmac-4.bin} |  Bin 269595 -> 269595 bytes
 ...llmac-4-218-248-5.txt => bcm4329-fullmac-4.txt} |    0
 brcm/{bcm43xx-0-610-809-0.fw => bcm43xx-0.fw}      |  Bin 97376 -> 97376 bytes
 ...bcm43xx_hdr-0-610-809-0.fw => bcm43xx_hdr-0.fw} |  Bin 180 -> 180 bytes
 5 files changed, 4 insertions(+), 4 deletions(-)
 rename brcm/{bcm4329-fullmac-4-218-248-5.bin => bcm4329-fullmac-4.bin} (100%)
 rename brcm/{bcm4329-fullmac-4-218-248-5.txt => bcm4329-fullmac-4.txt} (100%)
 rename brcm/{bcm43xx-0-610-809-0.fw => bcm43xx-0.fw} (100%)
 rename brcm/{bcm43xx_hdr-0-610-809-0.fw => bcm43xx_hdr-0.fw} (100%)

diff --git a/WHENCE b/WHENCE
index 9fad4fa..5451b3f 100644
--- a/WHENCE
+++ b/WHENCE
@@ -1392,8 +1392,8 @@ Licence:
 
 Driver: brcm80211 - Broadcom 802.11n wireless LAN driver.
 
-File: brcm/bcm43xx-0-610-809-0.fw
-File: brcm/bcm43xx_hdr-0-610-809-0.fw
+File: brcm/bcm43xx-0.fw
+File: brcm/bcm43xx_hdr-0.fw
 
 Licence: Redistributable. See LICENCE.broadcom_bcm43xx for details.
 
@@ -1401,8 +1401,8 @@ Licence: Redistributable. See LICENCE.broadcom_bcm43xx for details.
 
 Driver: brcm80211 - Broadcom 802.11n wireless LAN driver.
 
-File: bcm4329-fullmac-4-218-248-5.bin
-File: bcm4329-fullmac-4-218-248-5.txt
+File: brcm/bcm4329-fullmac-4.bin
+File: brcm/bcm4329-fullmac-4.txt
 
 Licence: Redistributable. See LICENCE.broadcom_bcm43xx for details.
 
diff --git a/brcm/bcm4329-fullmac-4-218-248-5.txt b/brcm/bcm4329-fullmac-4.txt
similarity index 100%
rename from brcm/bcm4329-fullmac-4-218-248-5.txt
rename to brcm/bcm4329-fullmac-4.txt
-- 
1.7.1


