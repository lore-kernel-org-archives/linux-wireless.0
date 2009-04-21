Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost02.isp.att.net ([207.115.11.52]:50719 "EHLO
	fmailhost02.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbZDUQuD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Apr 2009 12:50:03 -0400
Message-ID: <49EDF923.2020102@lwfinger.net> (sfid-20090421_185006_853360_34470F04)
Date: Tue, 21 Apr 2009 11:49:39 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Jack Schneider <puck@dp-indexing.com>
CC: Peter Stuge <stuge-linux-pcmcia@cdy.org>,
	"linux-pcmcia@lists.infradead.org" <linux-pcmcia@lists.infradead.org>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Problem with exclusive interrupt in hostap_cs
References: <20090420101340.142b6bc6@dp-indexing.com>	<49ECCABE.40805@lwfinger.net> <20090420225740.25307.qmail@cdy.org> <20090421103617.05737b01@dp-indexing.com>
In-Reply-To: <20090421103617.05737b01@dp-indexing.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jack Schneider wrote:
>
> Hi, All
> Tried the orinoco_cs driver last nite and got an error, something like;
> device not supported.. 
> 
> Thanks for trying..

I took a second look at the code and found that other drivers are using the
routine prism2_interrupt() with shared interrupts, thus the patch below should
be all that is needed.

I trust that you will be able to build the patched driver.

Larry


Index: wireless-testing/drivers/net/wireless/hostap/hostap_cs.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/hostap/hostap_cs.c
+++ wireless-testing/drivers/net/wireless/hostap/hostap_cs.c
@@ -666,7 +666,8 @@ static int prism2_config(struct pcmcia_d
 	 * irq structure is initialized.
 	 */
 	if (link->conf.Attributes & CONF_ENABLE_IRQ) {
-		link->irq.Attributes = IRQ_TYPE_EXCLUSIVE | IRQ_HANDLE_PRESENT;
+		link->irq.Attributes = IRQ_TYPE_DYNAMIC_SHARING |
+				       IRQ_HANDLE_PRESENT;
 		link->irq.IRQInfo1 = IRQ_LEVEL_ID;
 		link->irq.Handler = prism2_interrupt;
 		link->irq.Instance = dev;
