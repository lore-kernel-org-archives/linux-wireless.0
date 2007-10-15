Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:41346
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbXJOPYd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2007 11:24:33 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [patch #2] ssb: fix build failure
Date: Mon, 15 Oct 2007 17:23:21 +0200
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	Ingo Molnar <mingo@elte.hu>,
	Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200710151723.21423.mb@bu3sch.de> (sfid-20071015_162438_596764_F2521980)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ingo Molnar <mingo@elte.hu>

fix build failure if PCMCIA=m but SSB=y:

drivers/built-in.o: In function `ssb_pcmcia_switch_coreidx':
: undefined reference to `pcmcia_access_configuration_register'

(fix symmetric bug for PCI too.)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Michael Buesch <mb@bu3sch.de>

---
 drivers/ssb/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/drivers/ssb/Kconfig
===================================================================
--- linux.orig/drivers/ssb/Kconfig
+++ linux/drivers/ssb/Kconfig
@@ -22,7 +22,7 @@ config SSB
 
 config SSB_PCIHOST_POSSIBLE
 	bool
-	depends on SSB && PCI
+	depends on SSB && (PCI = y || PCI = SSB)
 	default y
 
 config SSB_PCIHOST
@@ -37,7 +37,7 @@ config SSB_PCIHOST
 
 config SSB_PCMCIAHOST_POSSIBLE
 	bool
-	depends on SSB && PCMCIA && EXPERIMENTAL
+	depends on SSB && (PCMCIA = y || PCMCIA = SSB) && EXPERIMENTAL
 	default y
 
 config SSB_PCMCIAHOST



-------------------------------------------------------

-- 
Greetings Michael.
