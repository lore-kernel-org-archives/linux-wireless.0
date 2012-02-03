Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2122 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757615Ab2BCU5I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 15:57:08 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "Ben Hutchings" <ben@decadent.org.uk>
cc: linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 3/4] linux-firmware: brcm: remove nvram file for bcm4329
 development board
Date: Fri, 3 Feb 2012 21:56:44 +0100
Message-ID: <1328302605-3382-4-git-send-email-arend@broadcom.com> (sfid-20120203_215714_668221_B15841AA)
In-Reply-To: <1328302605-3382-1-git-send-email-arend@broadcom.com>
References: <1328302605-3382-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

The nvram file contains configuration info for firmware which varies
with different hardware designs. The version currently in the
repository is for a Broadcom-internal development board that is not
available on the market. This file is not applicable for any exsisting
end-user product. Users should use the nvram file that was
shipped with their device to avoid unexpected or incorrect behavior.
Remove the file from repository to avoid confusion.

Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 WHENCE                     |    1 -
 brcm/bcm4329-fullmac-4.txt |   94 --------------------------------------------
 2 files changed, 0 insertions(+), 95 deletions(-)
 delete mode 100644 brcm/bcm4329-fullmac-4.txt

diff --git a/WHENCE b/WHENCE
index f6f74ec..07534c3 100644
--- a/WHENCE
+++ b/WHENCE
@@ -1553,7 +1553,6 @@ Licence: Redistributable. See LICENCE.broadcom_bcm43xx for details.
 Driver: brcmfmac - Broadcom 802.11n fullmac wireless LAN driver.
 
 File: brcm/bcm4329-fullmac-4.bin
-File: brcm/bcm4329-fullmac-4.txt
 File: brcm/brcmfmac4329.bin
 File: brcm/brcmfmac4330.bin
 
diff --git a/brcm/bcm4329-fullmac-4.txt b/brcm/bcm4329-fullmac-4.txt
deleted file mode 100644
index f757f55..0000000
--- a/brcm/bcm4329-fullmac-4.txt
+++ /dev/null
@@ -1,94 +0,0 @@
-# bcm94329sdagb board
-# $Copyright (C) 2008 Broadcom Corporation$
-# $id$
-
-sromrev=3
-vendid=0x14e4
-devid=0x432e
-# board type
-boardtype=0x4ff
-
-# board revision 1.1
-boardrev=0x19
-
-# boardflags
-boardflags=0x1200
-
-####### IMP ########
-# Specify the xtalfreq if it is otherthan 38.4MHz
-xtalfreq=38400
-
-aa2g=1
-aa5g=1
-
-ag0=255
-
-# 11g paparams
-pa0b0=6003,6003,5112
-pa0b1=64086,64086,64229
-pa0b2=65195,65195,65081
-pa0itssit=62
-pa0maxpwr=66
-opo=0
-mcs2gpo0=0x2222
-mcs2gpo1=0x2222
-
-# sel = 1 : 20% evm  sel = 2 : 27% evm  sel = 3 : 16% evm
-cckdigfilttype=0
-ofdmdigfilttype=1
-
-# 11a paparams lowband
-pa1lob0=5662
-pa1lob1=64130
-pa1lob2=65156
-# paparams midband
-pa1b0=5724
-pa1b1=64128
-pa1b2=65167
-#paparams high band
-pa1hib0=5675
-pa1hib1=64129
-pa1hib2=65169
-pa1itssit=62
-pa1maxpwr=66
-opo=0
-mcs5gpo=0x22222222
-
-# 11g rssi params
-rssismf2g=0xa
-rssismc2g=0xb
-rssisav2g=0x3
-bxa2g=0
-
-# 11a rssi params
-rssismf5g=0xa
-rssismc5g=0xa
-rssisav5g=0x3
-bxa2g=0
-
-# country code
-ccode=X2
-cctl=0x0
-
-rxpo2g=1
-rxpo5g=0
-rxpo2gchnflg=0x1FFF
-
-boardnum=2048
-macaddr=00:90:4c:c5:34:23
-
-#######
-nocrc=1
-
-#for mfgc
-otpimagesize=182
-
-# sdio extra configs
-hwhdr=0x05ffff031030031003100000
-
-#This generates empty F1, F2 and F3 tuple chains, and may be used if the host SDIO stack does not require the standard tuples.
-RAW1=80 02 fe ff
-
-#This includes the standard FUNCID and FUNCE tuples in the F1, F2, F3 and common CIS.
-#RAW1=80 32 fe 21 02 0c 00 22 2a 01 01 00 00 c5 0 e6 00 00 00 00 00 40 00 00 ff ff 80 00 00 00 00 00 00 00 00 00 00 c8 00 00 00 00 00 00 00 00 00 00 00 00 00 ff 20 04 D0 2 29 43 21 02 0c 00 22 04 00 20 00 5A
-nvramver=4.218.0.0
-- 
1.7.5.4


