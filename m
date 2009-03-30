Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost02.isp.att.net ([204.127.217.102]:39643 "EHLO
	fmailhost02.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbZC3XVY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 19:21:24 -0400
Message-ID: <49D153C2.7010706@lwfinger.net> (sfid-20090331_012128_105338_817116C1)
Date: Mon, 30 Mar 2009 18:20:34 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Inaky Perez-Gonzalez <inaky@linux.intel.com>,
	Dirk Opfer <Dirk@Opfer-Online.de>, toshiba_acpi@memebeam.org,
	Matthew Garrett <mjg@redhat.com>
Subject: Re: [RFC/RFT v2] rfkill: rewrite
References: <1238349195.24972.5.camel@johannes.local>	 (sfid-20090329_195345_745378_2F2074B3) <1238451390.5970.59.camel@johannes.local>
In-Reply-To: <1238451390.5970.59.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> This patch completely rewrites the rfkill core to address
> the following deficiencies:
> 
>  * all rfkill drivers need to implement polling where necessary
>    rather than having one central implementation
> 
>  * updating the rfkill state cannot be done from arbitrary
>    contexts, forcing drivers to use schedule_work and requiring
>    lots of code
> 
>  * rfkill drivers need to keep track of soft/hard blocked
>    internally -- the core should do this
> 
>  * the rfkill API has many unexpected quirks, for example being
>    asymmetric wrt. alloc/free and register/unregister
> 
>  * rfkill can call back into a driver from within a function the
>    driver called -- this is prone to deadlocks and generally
>    should be avoided
> 
>  * rfkill-input pointlessly is a separate module
> 
>  * drivers need to #ifdef rfkill functions (unless they want to
>    depend on or select RFKILL) -- rfkill should provide inlines
>    that do nothing if it isn't compiled in
> 
>  * the rfkill structure is not opaque -- drivers need to initialise
>    it correctly (lots of sanity checking code required) -- instead
>    force drivers to pass the right variables to rfkill_alloc()
> 
>  * the documentation is hard to read because it always assumes the
>    reader is completely clueless and contains way TOO MANY CAPS
> 
>  * the rfkill code needlessly uses a lot of locks and atomic
>    operations in locked sections
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
> TODO
>  * convert toshiba, thinkpad
>  * compile-test tosa conversion
>  * figure out tosa-default LED trigger thing
>  * apply default state to devices after being registered
>  * test
> 
> Requires the other rfkill patches -- which you can also get at
> http://johannes.sipsolutions.net/patches/kernel/all/LATEST/

Initial testing shows at least two problems with b43legacy (and probably b43 as
well):

(1) On bootup with my radio switch OFF, the driver ignored that switch and
associated with my AP. Only when the switch was turned on and off again did the
driver log the expected "switch off" message".

(2) The radio LED is on no matter the state of the switch.

Larry
