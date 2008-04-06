Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:49761 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752376AbYDFPLP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Apr 2008 11:11:15 -0400
Date: Sun, 6 Apr 2008 17:10:53 +0200
From: Stefano Brivio <stefano.brivio@polimi.it>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	bcm43xx-dev@lists.berlios.de
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH RFT] b43legacy: fix initvals loading on bcm4303
Message-ID: <20080406171053.62008810@polimi.it> (sfid-20080406_161119_768853_BE7C94DE)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows for the correct initial values to be uploaded to bcm4303
devices. It should be correct, but I can't reliably test this as I suspect
there's something going wrong with an hardware rfkill switch on my laptop.
Please test.

Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
---
Please note that for this patch to be tested a previous patch:
'b43legacy: fix bcm4303 crash'
needs to be applied.
---
Index: bcm-testing/drivers/net/wireless/b43legacy/main.c
===================================================================
--- bcm-testing.orig/drivers/net/wireless/b43legacy/main.c
+++ bcm-testing/drivers/net/wireless/b43legacy/main.c
@@ -1516,6 +1516,7 @@ static int b43legacy_request_firmware(st
 	}
 	if (!fw->initvals) {
 		switch (dev->phy.type) {
+		case B43legacy_PHYTYPE_B:
 		case B43legacy_PHYTYPE_G:
 			if ((rev >= 5) && (rev <= 10))
 				filename = "b0g0initvals5";
@@ -1533,6 +1534,7 @@ static int b43legacy_request_firmware(st
 	}
 	if (!fw->initvals_band) {
 		switch (dev->phy.type) {
+		case B43legacy_PHYTYPE_B:
 		case B43legacy_PHYTYPE_G:
 			if ((rev >= 5) && (rev <= 10))
 				filename = "b0g0bsinitvals5";


--
Ciao
Stefano

