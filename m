Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0141.hostedemail.com ([216.40.44.141]:34921 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750708AbaLXA4D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 19:56:03 -0500
Message-ID: <1419382559.6157.1.camel@perches.com> (sfid-20141224_015635_336752_B8C20D51)
Subject: Re: [PATCH] Drivers: bcma: Fix three coding style issues, more than
 80 characters per line.
From: Joe Perches <joe@perches.com>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Oscar Forner Martinez <oscar.forner.martinez@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 23 Dec 2014 16:55:59 -0800
In-Reply-To: <CACna6rwTwrZurN+bgerQu_UPsTTv=1iB-C3_MeMiQN0GSyDoMg@mail.gmail.com>
References: <1419378909-14414-1-git-send-email-oscar.forner.martinez@gmail.com>
	 <CACna6rwTwrZurN+bgerQu_UPsTTv=1iB-C3_MeMiQN0GSyDoMg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-12-24 at 00:46 +0100, Rafał Miłecki wrote:
> On 24 December 2014 at 00:55, Oscar Forner Martinez
> <oscar.forner.martinez@gmail.com> wrote:
> > Three lines with more than 80 characters per line have been split in several lines.
> >
> > Signed-off-by: Oscar Forner Martinez <oscar.forner.martinez@gmail.com>
> > ---
> >  drivers/bcma/driver_chipcommon.c | 10 +++++++---
> >  1 file changed, 7 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/bcma/driver_chipcommon.c b/drivers/bcma/driver_chipcommon.c
[]
> > -               bcma_err(cc->core->bus, "serial not supported on this device ccrev: 0x%x\n", ccrev);
> > +               bcma_err(cc->core->bus,
> > +                        "serial not supported on this device ccrev: 0x%x\n",
> > +                        ccrev);
> 
> I think some subsystems agreed to keep dev/bus pointed and string in
> the one line. It makes more sense for me too.

And it would probably be better to invert the test above
and error out immediately to reduce the indentation.

Something like:

 drivers/bcma/driver_chipcommon.c | 42 +++++++++++++++++++++-------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

diff --git a/drivers/bcma/driver_chipcommon.c b/drivers/bcma/driver_chipcommon.c
index 19f6796..e63fabfc 100644
--- a/drivers/bcma/driver_chipcommon.c
+++ b/drivers/bcma/driver_chipcommon.c
@@ -316,29 +316,31 @@ void bcma_chipco_serial_init(struct bcma_drv_cc *cc)
 	unsigned int ccrev = cc->core->id.rev;
 	struct bcma_serial_port *ports = cc->serial_ports;
 
-	if (ccrev >= 11 && ccrev != 15) {
-		baud_base = bcma_chipco_get_alp_clock(cc);
-		if (ccrev >= 21) {
-			/* Turn off UART clock before switching clocksource. */
-			bcma_cc_write32(cc, BCMA_CC_CORECTL,
-				       bcma_cc_read32(cc, BCMA_CC_CORECTL)
-				       & ~BCMA_CC_CORECTL_UARTCLKEN);
-		}
-		/* Set the override bit so we don't divide it */
-		bcma_cc_write32(cc, BCMA_CC_CORECTL,
-			       bcma_cc_read32(cc, BCMA_CC_CORECTL)
-			       | BCMA_CC_CORECTL_UARTCLK0);
-		if (ccrev >= 21) {
-			/* Re-enable the UART clock. */
-			bcma_cc_write32(cc, BCMA_CC_CORECTL,
-				       bcma_cc_read32(cc, BCMA_CC_CORECTL)
-				       | BCMA_CC_CORECTL_UARTCLKEN);
-		}
-	} else {
-		bcma_err(cc->core->bus, "serial not supported on this device ccrev: 0x%x\n", ccrev);
+	if (ccrev < 11 || ccrev == 15) {
+		bcma_err(cc->core->bus,
+			 "serial not supported on this device ccrev: 0x%x\n",
+			 ccrev);
 		return;
 	}
 
+	baud_base = bcma_chipco_get_alp_clock(cc);
+	if (ccrev >= 21) {
+		/* Turn off UART clock before switching clocksource */
+		bcma_cc_write32(cc, BCMA_CC_CORECTL,
+				bcma_cc_read32(cc, BCMA_CC_CORECTL)
+				& ~BCMA_CC_CORECTL_UARTCLKEN);
+	}
+	/* Set the override bit so we don't divide it */
+	bcma_cc_write32(cc, BCMA_CC_CORECTL,
+			bcma_cc_read32(cc, BCMA_CC_CORECTL) |
+			BCMA_CC_CORECTL_UARTCLK0);
+	if (ccrev >= 21) {
+		/* Re-enable the UART clock */
+		bcma_cc_write32(cc, BCMA_CC_CORECTL,
+				bcma_cc_read32(cc, BCMA_CC_CORECTL)
+				| BCMA_CC_CORECTL_UARTCLKEN);
+	}
+
 	irq = bcma_core_irq(cc->core, 0);
 
 	/* Determine the registers of the UARTs */


