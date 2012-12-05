Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:53324 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab2LEN0R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 08:26:17 -0500
Message-ID: <1354713933.6234.64.camel@cumari.coelho.fi> (sfid-20121205_142620_906695_59AF00EE)
Subject: Re: [PATCH 03/20] wlcore/wl18xx/wl12xx: FW log params per chip arch
From: Luciano Coelho <coelho@ti.com>
To: Igal Chernobelsky <igalc@ti.com>
CC: Arik Nemtsov <arik@wizery.com>, <linux-wireless@vger.kernel.org>
Date: Wed, 5 Dec 2012 15:25:33 +0200
In-Reply-To: <50BF3E26.1080801@ti.com>
References: <1354095769-8724-1-git-send-email-arik@wizery.com>
		 <1354095769-8724-4-git-send-email-arik@wizery.com>
	 <1354704935.6234.44.camel@cumari.coelho.fi> <50BF3E26.1080801@ti.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-12-05 at 14:29 +0200, Igal Chernobelsky wrote:
> Hi Luca,
> 
> On 12/05/2012 12:55 PM, Luciano Coelho wrote:
> > On Wed, 2012-11-28 at 11:42 +0200, Arik Nemtsov wrote:
> >> From: Igal Chernobelsky<igalc@ti.com>
> >>
> >> FW memory block size and FW log end marker parameters
> >> are added to wl structure and are initialized per
> >> chip architecture. convert_hwaddr hw operation is added
> >> to convert chip dependent FW internal address.
> >> Copy from FW log is also simplified to copy the entire
> >> memory block as FW logger utility is repsponsible
> >> for parsing of FW log content.
> >>
> >> Signed-off-by: Igal Chernobelsky<igalc@ti.com>
> >> Signed-off-by: Arik Nemtsov<arik@wizery.com>
> >> ---
> > This commit log explains what has been done, which can quite easily be
> > see in the patch itself.  That's okay, but what I'm missing here is the
> > explanation *why* this needs to be done.
> 
> I can add to commit that FW logger is supported by wlcore but
> has different parameters per chip (actually written in commit header).

Yeah, could be something like "The FW log data format is slightly
different in the different chips.  They use a different format in the
linked list to point to the address of the next block."  Not necessary
exactly like this, but this kind of information is more important than
describing how it is done (because the latter can be seen in the commit
diff anyway).


> >
> >> diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
> >> index 951b88c..5e3c808 100644
> >> --- a/drivers/net/wireless/ti/wl12xx/main.c
> >> +++ b/drivers/net/wireless/ti/wl12xx/main.c
> >> @@ -706,6 +706,9 @@ static int wl12xx_identify_chip(struct wl1271 *wl)
> >>   		goto out;
> >>   	}
> >>
> >> +	wl->fw_mem_block_size = 256;
> >> +	wl->fwlog_end = 0x2000000;
> > This value used to be in a macro before (WLCORE_FW_LOG_END), why kill
> > it? It should just be renamed to WL12XX_FW_LOG_END and a new one be
> > created for WL18XX.
> These values are used only in one place during initialization and
> are assigned to variables with self explanation name.
> Do you still prefer defines?

Yes, I prefer defines.  I think they would be better placed in the reg.h
file, for instance.  Then you have a single place where you can look up
everything about the hardware memory configuration, instead of having to
look everywhere around the code.

Also, I just noticed that you have added this to the identify_chip
function.  This doesn't change between different chipsets of the same
family.  So it should be set in the setup operation (eg. wl12xx_setup)
instead.


> >> @@ -1632,6 +1635,11 @@ static int wl12xx_set_peer_cap(struct wl1271 *wl,
> >>   					      hlid);
> >>   }
> >>
> >> +static u32 wl12xx_convert_hwaddr(struct wl1271 *wl, u32 hwaddr)
> >> +{
> >> +	return hwaddr<<  5;
> >> +}
> > There was a good comment about this calculation before, it should be
> > moved here instead of deleted.
> Sorry, I will restore the comment for wl12xx:
> /* Addresses are stored internally as addresses to 32 bytes blocks */
> 
> >
> >> @@ -1669,6 +1677,7 @@ static struct wlcore_ops wl12xx_ops = {
> >>   	.channel_switch		= wl12xx_cmd_channel_switch,
> >>   	.pre_pkt_send		= NULL,
> >>   	.set_peer_cap		= wl12xx_set_peer_cap,
> >> +	.convert_hwaddr = wl12xx_convert_hwaddr,
> > No need to break the alignment here.
> I will fix it.
> >
> >>   static struct ieee80211_sta_ht_cap wl12xx_ht_cap = {
> >> diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
> >> index df8de71..d806241 100644
> >> --- a/drivers/net/wireless/ti/wl18xx/main.c
> >> +++ b/drivers/net/wireless/ti/wl18xx/main.c
> >> @@ -667,6 +667,9 @@ static int wl18xx_identify_chip(struct wl1271 *wl)
> >>   		goto out;
> >>   	}
> >>
> >> +	wl->fw_mem_block_size = 272;
> >> +	wl->fwlog_end = 0x40000000;
> > Again, the magic number here can be avoided.
> The same as for wl12xx.

Same as my answer above. :)


> >> @@ -1423,6 +1426,11 @@ static int wl18xx_set_peer_cap(struct wl1271 *wl,
> >>   				       rate_set, hlid);
> >>   }
> >>
> >> +static u32 wl18xx_convert_hwaddr(struct wl1271 *wl, u32 hwaddr)
> >> +{
> >> +	return hwaddr&  ~0x80000000;
> >> +}
> > A small explanation here would be nice.
> That is formula to convert from HW address ...

What I mean is that, in practice, what you're doing here is masking out
bit 31.  Do we know what they use that bit for?



> >>   	/* Traverse the memory blocks linked list */
> >>   	do {
> >> -		memset(block, 0, WL12XX_HW_BLOCK_SIZE);
> >> -		ret = wlcore_read_hwaddr(wl, addr, block, WL12XX_HW_BLOCK_SIZE,
> >> -					 false);
> >> +		part.mem.start = wlcore_hw_convert_hwaddr(wl, addr);
> >> +		part.mem.size  = PAGE_SIZE;
> >> +
> >> +		ret = wlcore_set_partition(wl,&part);
> >> +		if (ret<  0) {
> >> +			wl1271_error("%s: set_partition start=0x%X size=%d",
> >> +				__func__, part.mem.start, part.mem.size);
> > This could probably be a bit more descriptive, like saying that the
> > fwlog seems to be corrupt because the address in the linked list can't
> > be used for setting the partition.
> Ok, will add the comment.

Maybe you could add something in the debug message itself? That way it
would be clear in the log and in the code at the same time. ;)


> >> diff --git a/drivers/net/wireless/ti/wlcore/io.h b/drivers/net/wireless/ti/wlcore/io.h
> >> index f48530f..5897747 100644
> >> --- a/drivers/net/wireless/ti/wlcore/io.h
> >> +++ b/drivers/net/wireless/ti/wlcore/io.h
> >> @@ -165,8 +165,8 @@ static inline int __must_check wlcore_read_hwaddr(struct wl1271 *wl, int hwaddr,
> >>          int physical;
> >>          int addr;
> >>
> >> -       /* Addresses are stored internally as addresses to 32 bytes blocks */
> >> -       addr = hwaddr<<  5;
> >> +       /* Convert from FW internal address which is chip arch dependent */
> >> +       addr = wl->ops->convert_hwaddr(wl, hwaddr);
> > This could be more descriptive.  As I understand, this is converting an
> > internal representation of pointers in the hardware to an address that
> > can be used to set the partitions.
> >
> Ok, will add more comment: convert to address used for setting partition 
> and reading over SDIO

Yes, that would be nice, thanks!

--
Luca.

