Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3238 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757294AbXENSch (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 May 2007 14:32:37 -0400
Date: Mon, 14 May 2007 14:13:23 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3 1/2] Add 93cx6 eeprom library
Message-ID: <20070514181323.GB6999@tuxdriver.com>
References: <200705140138.52596.flamingice@sourmilk.net> <a32f33a40705132349h367ba18aoa046d5583329ead@mail.gmail.com> <200705141056.01199.flamingice@sourmilk.net> <200705141700.21900.IvDoorn@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200705141700.21900.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 14, 2007 at 05:00:21PM +0200, Ivo van Doorn wrote:
> On Monday 14 May 2007 16:55, Michael Wu wrote:
> > On Monday 14 May 2007 02:49, Ivo Van Doorn wrote:
> > > For the record: I am still not happy with the removal of the udelay() from
> > > the pulse methods as they were indicated by the original Ralink code.
> > > But since I cannot test the effect on Ralink eeprom reading at this time,
> > > and I could otherwise just add it to the register_write handler if
> > > required, I am signing this off anyway.
> > >
> > The udelay is necessary to set a limit on how fast the eeprom is operated.. 
> > but not on all hardware, apparently. adm8211 just uses a read from the eeprom 
> > register to perform the delay.
> 
> Ok, then I'll update rt2x00 to perform the delay during register_write as well. :)

Actually, see the end of the thread from the previous 93cx6 patch
Michael posted on Friday.  I think these delays are actually alright,
but they could use a comment.  How about the patch below (applied on
top of the previous version)?

John

P.S.  No need to repost any 93cx6 patches, I have them.
---


[PATCH] eeprom_93cx6: add comment explaining clocking delays

Signed-off-by: John W. Linville <linville@tuxdriver.com>

diff --git a/drivers/misc/eeprom_93cx6.c b/drivers/misc/eeprom_93cx6.c
index bfcb434..1f615ac 100644
--- a/drivers/misc/eeprom_93cx6.c
+++ b/drivers/misc/eeprom_93cx6.c
@@ -39,6 +39,8 @@ static inline void eeprom_93cx6_pulse_high(struct eeprom_93cx6 *eeprom)
 {
 	eeprom->reg_data_clock = 1;
 	eeprom->register_write(eeprom);
+
+	/* honor T_ckh hold requirements from datasheet */
 	udelay(1);
 }
 
@@ -46,6 +48,8 @@ static inline void eeprom_93cx6_pulse_low(struct eeprom_93cx6 *eeprom)
 {
 	eeprom->reg_data_clock = 0;
 	eeprom->register_write(eeprom);
+
+	/* honor T_ckl hold requirements from datasheet */
 	udelay(1);
 }
 
-- 
John W. Linville
linville@tuxdriver.com
