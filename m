Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.mail.elte.hu ([157.181.1.138]:42241 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754796AbXJOPL5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2007 11:11:57 -0400
Date: Mon, 15 Oct 2007 17:10:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: Re: [patch] ssb: fix build failure
Message-ID: <20071015151054.GB8343@elte.hu> (sfid-20071015_161200_901625_1FA50CDA)
References: <200710151623.04881.mb@bu3sch.de> <20071015080646.d77f5dfb.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20071015080646.d77f5dfb.randy.dunlap@oracle.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


* Randy Dunlap <randy.dunlap@oracle.com> wrote:

> That's usually done more like this:
> 
> 	depends on SSB && (PCMCIA = y || PCMCIA = SSB) && EXPERIMENTAL
> 
> This allows PCMCIA to be y or m, but if PCMCIA is m, then SSB is 
> restricted to m as well (or n). I.e., PCMCIA = SSB is too strict and 
> not required.

indeed - updated patch below.

	Ingo

------------------>
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

