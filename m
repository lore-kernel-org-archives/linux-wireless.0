Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.89]:53945 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756553AbZC3Uj3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 16:39:29 -0400
From: Inaky Perez-Gonzalez <inaky@linux.intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC] rfkill: rewrite
Date: Mon, 30 Mar 2009 13:36:52 -0700
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Dirk Opfer <Dirk@opfer-online.de>,
	Matthew Garrett <mjg@redhat.com>
References: <1238349195.24972.5.camel@johannes.local> <200903301954.07008.IvDoorn@gmail.com> <1238436058.5970.24.camel@johannes.local>
In-Reply-To: <1238436058.5970.24.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200903301336.52883.inaky@linux.intel.com> (sfid-20090330_223932_963510_90E0F0B2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 30 March 2009, Johannes Berg wrote:
> On Mon, 2009-03-30 at 19:54 +0200, Ivo van Doorn wrote:
> > > > wimax_report_rfkill_hw() -- device driver report to stack
> > > >
> > > >    device reports a change in the hw rfkill key; switch the radio to
> > > >    whichever state AND report a key event through the input layer
> > >
> > > But reporting the key through the input layer is wrong, afaict.
> >
> > Why because it combines it with switching the radio?
> > In rt2x00 all key events are going through the input layer as well,
> > because it has no influence on the radio state of the device.
> > (In other words, you can still happily send and receive all
> > the data you want regardless of the key state).
>
> Yes, but my understanding is (and I've just rewritten the code, heh)
> that if the button switches the hardware kill directly then we don't
> report an input event.
>
> Except in very limited circumstances (like the thinkpad-acpi platform
> driver Henrique explained) I think doing _both_
> rfkill_force_state(hard-blocked) [in new API terms:
> rfkill_set_hw_block(true)] _and_ input_report() is incorrect.

I guess there is both history to both; Johannes, you are right, in this
case the hw rfkill kills the radio in HW and *we* send the input event.

Reason it sends the input event is because I used the rt2x00 code as
reference...

So, if you guys all agree that passing this to the input layer is not
needed,feel free to yank it.

-- 
Inaky

