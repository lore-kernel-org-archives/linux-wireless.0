Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:56020 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690AbXISC6I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Sep 2007 22:58:08 -0400
Subject: Re: Fw: build #301 failed for 2.6.23-rc6-g0d4cbb5 in   linux/drivers/net/wireless/libertas/
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-wireless@vger.kernel.org,
	Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
In-Reply-To: <1189954364.29570.15.camel@xo-3E-67-34.localdomain>
References: <20070915020251.2b5b8adc.akpm@linux-foundation.org>
	 <1189847359.23521.2.camel@johannes.berg>
	 <1189954364.29570.15.camel@xo-3E-67-34.localdomain>
Content-Type: text/plain
Date: Tue, 18 Sep 2007 22:55:59 -0400
Message-Id: <1190170559.30482.14.camel@xo-3E-67-34.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2007-09-16 at 10:52 -0400, Dan Williams wrote:
> On Sat, 2007-09-15 at 11:09 +0200, Johannes Berg wrote:
> > On Sat, 2007-09-15 at 02:02 -0700, Andrew Morton wrote:
> > 
> > >   Building modules, stage 2.
> > >   MODPOST 353 modules
> > > ERROR: "libertas_remove_mesh" [drivers/net/wireless/libertas/usb8xxx.ko] undefined!
> > > ERROR: "libertas_add_card" [drivers/net/wireless/libertas/usb8xxx.ko] undefined!
> > > ERROR: "libertas_send_tx_feedback" [drivers/net/wireless/libertas/usb8xxx.ko] undefined!
> > > ERROR: "libertas_prepare_and_send_command" [drivers/net/wireless/libertas/usb8xxx.ko] undefined!
> > > ERROR: "libertas_remove_card" [drivers/net/wireless/libertas/usb8xxx.ko] undefined!
> > > ERROR: "libertas_add_mesh" [drivers/net/wireless/libertas/usb8xxx.ko] undefined!
> > > ERROR: "libertas_process_rxed_packet" [drivers/net/wireless/libertas/usb8xxx.ko] undefined!
> > > ERROR: "libertas_interrupt" [drivers/net/wireless/libertas/usb8xxx.ko] undefined!
> > > ERROR: "libertas_activate_card" [drivers/net/wireless/libertas/usb8xxx.ko] undefined!
> > 
> > I really wonder how this thing works at all. All these symbols need to
> > be exported. I'm pretty sure we've had this before.
> 
> Yeah, I must have accidentally dropped that bit...  But I'm 99% sure
> there are EXPORT_SYMBOL_GPL() notations in the right places for these,
> certainly for libertas_remove_mesh and libertas_add_mesh and the others.
> What else needs to be done?

Any ideas here?

Every single one of these reputedly undefined symbols is currently
marked with EXPORT_SYMBOL_GPL in 2.6.23-rc6.  Is that not relevant to
this issue?  If not, does building libertas into the kernel preclude
building stuff that depends on it as modules?

Dan


