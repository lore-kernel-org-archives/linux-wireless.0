Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:4717 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbZC2SQL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Mar 2009 14:16:11 -0400
Received: by ey-out-2122.google.com with SMTP id 4so518244eyf.37
        for <linux-wireless@vger.kernel.org>; Sun, 29 Mar 2009 11:16:08 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC] rfkill: rewrite
Date: Sun, 29 Mar 2009 20:16:02 +0200
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Inaky Perez-Gonzalez <inaky@linux.intel.com>,
	Dirk Opfer <Dirk@opfer-online.de>, toshiba_acpi@memebeam.org,
	Matthew Garrett <mjg@redhat.com>
References: <1238349195.24972.5.camel@johannes.local>
In-Reply-To: <1238349195.24972.5.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200903292016.05470.IvDoorn@gmail.com> (sfid-20090329_201616_721337_9779E4AE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 29 March 2009, Johannes Berg wrote:
> This patch completely rewrites the rfkill core to address
> the following deficiencies:
> 
>  * all rfkill drivers need to implement polling where necessary
>    rather than having one central implementation
> 
>  * updating the rfkill state cannot be done from any context,
>    forcing drivers to use schedule_work and requiring lots of
>    code
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
>  * the rfkill structure, despite containing almost only internal
>    variables, is not opaque -- and drivers need to initialise it
>    correctly (lots of sanity checking code required) -- instead
>    force drivers to pass the right variables to rfkill_alloc()
> 
>  * the documentation is hard to read because it always assumes
>    the reader is completely clueless and contains way to many CAPS
> 
>  * the rfkill code needlessly uses a lot of locks and atomic
>    operations in locked sections
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
> RFC only because I haven't fixed all drivers yet, still missing are
> toshiba, thinkpad, wimax and tosa.
> 
> Let the flames begin! (or if you like it feel free to chime in too)

Just for the record, as long as you (or somebody else) takes over maintainership
over rfkill after these changes, I have no objections against the changes. Luckily
you already updated the Maintainers entry, so I'm happy. :)

I know rfkill was poorly designed and I simply lacked the time (and perhaps
some interest as well) to continue with it. The changes you propose sound
reasonable so I hope it will turn rfkill really into something which it was supposed
to be from the start.

Ivo
