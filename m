Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34965 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab1HYFCl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 01:02:41 -0400
Subject: Re: [PATCH v2] Move brcm80211 to mainline
From: Johannes Berg <johannes@sipsolutions.net>
To: Henry Ptasinski <henryp@broadcom.com>
Cc: Greg KH <gregkh@suse.de>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Brett Rudley <brudley@broadcom.com>,
	Arend Van Spriel <arend@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>
In-Reply-To: <20110824231746.GF5280@broadcom.com> (sfid-20110825_011806_291837_334885B7)
References: <20110707002034.GA17885@broadcom.com>
	 <20110824222801.GA5280@broadcom.com> <20110824225357.GA2224@suse.de>
	 <20110824231746.GF5280@broadcom.com> (sfid-20110825_011806_291837_334885B7)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Aug 2011 22:02:48 -0700
Message-ID: <1314248569.5054.43.camel@jlt3.sipsolutions.net> (sfid-20110825_070245_629304_969A8261)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I guess I should review it :)

> +	depends on BCMA=n

I guess that has been discussed, and I agree with you that it should be
done after the move, for the given reasons.


> +	default n

No reason for that, that's the default.


> +subdir-ccflags-y					:= -DBCMDMA32

What's the use of that and other options that seem to always be enabled?
Shouldn't they just be run through "unifdef"? Also, typically, we don't
really use -DXYZ, we use #ifdef CONFIG_ (e.g. for SHOW_EVENTS)


Why are the iovar things needed? It seems very odd to me to look things
up by a string name.


> +#define BRCMF_PM_RESUME_WAIT(a, b) do { \

Should that really be a macro? Also BRCMF_PM_RESUME_RETURN_ERROR seems
rather odd to me. Generally, afaict, macros impacting the code flow are
sort of frowned upon.


What's the ioctl layer in dhd.h? That doesn't seem very
confidence-inspiring :) Also, do you really have your own error codes
still? I see BRCMF_E_..., or are those events? Why have events in the
driver?


brcmf_proto_cdc_query_ioctl and friends seem to really actually use
ioctl strings -- that's not really something we want to see in an
upstream driver.



> +/* Spawn a thread for system ioctls (set mac, set mcast) */
> +uint brcmf_sysioc = true;
> +module_param(brcmf_sysioc, uint, 0);

A thread for system ioctls? What does that even mean?



> +/* Network inteface name */
> +char iface_name[IFNAMSIZ] = "wlan";
> +module_param_string(iface_name, iface_name, IFNAMSIZ, 0);

Seriously? What for? No other driver does that.



> +#ifdef SDTEST

I don't think that needs to be part of the driver (for now)?



> brcmf_netdev_ioctl_entry

Am I looking at the wrong patch? You really want to propose private
driver ioctls? :)




> +/* ARM trap handling */

I hope this is for the device, not the host?



Generally, you have tons of static forward declarations that are
unnecessary.


Also generally, there are tons of macros that really shouldn't/needn't
be and probably would be better as inlines or even real functions.


swap_key_from_BE/swap_key_to_BE have the wrong name since evidently they
do _CPU not _BE


> +	fs = get_fs();
> +	set_fs(get_ds());
> +	err = dev->netdev_ops->ndo_do_ioctl(dev, &ifr, SIOCDEVPRIVATE);
> +	set_fs(fs);

kidding, right? what does that even do?


I also said this to Marvell so I'll repeat it here: I really don't think
you should have an internal ioctl abstraction layer -- there's no
problem with calling the right function directly instead of calling a
single ioctl() function and then demuxing again, cf. calls to
brcmf_dev_ioctl() -- also, really, this thing expects little endian
bytes in a buffer? Or is there some hidden HW abstraction there in
ioctl()? But even then it'd be much better to make that explicit.


brcmf_find_msb() -- what's wrong with all the bitops that already exist
like ffs()?



> +		/*
> +		 * Make sure WPA_Supplicant receives all the event
> +		 * generated due to DISASSOC call to the fw to keep
> +		 * the state fw and WPA_Supplicant state consistent
> +		 */
> +		rtnl_unlock();
> +		brcmf_delay(500);
> +		rtnl_lock();

Wow, you can't be serious -- this will could cause serious locking
issues. You _never_ want to drop a lock that some other function/layer
acquired.



> +static s32 brcmf_iscan_thread(void *data)

Why do you need a thread instead of using schedule_work from the timer?
Why do you even run iscan periodically? That's not expected; am I
misinterpreting it?


Is cfg80211_dev really global??



> +#define for_each_bss(list, bss, __i)	\

There's a bss list in cfg80211 -- use it, and if necessary export
functions for it, but why do you need to walk it anyway? We just had
this with Marvell and it cut ~1.5k LOC. (and besides, a statically sized
array is always a really bad idea)



> +++ b/drivers/net/wireless/brcm80211/brcmsmac/alloc.c

Err... what does this do? And it even has weird things like *err=1003;


> dma_alloc_consistent

That's going to get really confusing once you switch, like you should,
away from the pci wrappers for DMA mapping. The function seems kinda
pointless too since alignment should be OK unless there are special
requirements?



> +#define LOCK(wl)	spin_lock_bh(&(wl)->lock)

No way ...



> +static int n_adapters_found;

what for? bound to be racy ...


Again tons of unneeded static forward declarations


Does it just look like brcms_ops_add_interface() accepts any number of
interfaces?


I'm not sure you should have a function called ieee_set_channel. And
what's the "perimeter lock"?


I personally think brcms_c_set_par() should die. And probably
brcms_c_set too, again, why use a single function just to demultiplex
later?


brcms_ops_set_tim -- remove it
brcms_ops_set_tsf -- ditto
brcms_ops_get_stats -- ditto
brcms_ops_sta_notify -- ditto
brcms_ops_get_tsf -- certainly as well with this implementation
brcms_ops_sta_remove -- probably as well, but are you sure you don't
have to tear down the pktq? Oh, and you should probably get rid of pktq
and use skb_queue_head.


> +		 * Future improvement:
> +		 *   Use the starting sequence number provided ...

Err, well, that's not really an improvement but a requirement, at least
setting it to 0 is totally bogus. either you assign seqno in the driver
for QoS packets, or you don't -- if you do, *ssn needs the value, if you
don't, *ssn needs to be left untouched.


brcms_msleep -- that's ... wtf? You're never going to get locking
correct with that!! Almost impossible anyway, please get rid of it. You
can sleep while holding a mutex anyway.



> struct brcms_timer

Why do you need your own timer abstraction? And it doesn't even use
list_head.



> +#ifdef SUPPORT_HWKEYS

No reason for the ifdef, right?



> brcms_c_wme_initparams_sta

Shouldn't be necessary.



> +#define CHIP_SUPPORTS_11N(wlc)	1

Is there a plan to supports others?



> +	/* pull up some info resulting from the low attach */
> +	{
> +		int i;
> +		for (i = 0; i < NFIFO; i++)
> +			wlc->core->txavail[i] = wlc->hw->txavail[i];
> +	}


Not exactly Linux style to add braces if you need a local var.



> brcms_c_print_txdesc

I suggest to add tracing instead -- much more useful to actually record
everything :)


brcms_c_compute_rtscts_dur -- mac80211 has this and similer things as
helper functions, no?



> +	/* Compiler reference to avoid unused variable warning */
> +	(void)(frm_tx2);

wtf? I don't think we have warnings for unused args but why don't you
just remove the arg?



> +	rxh->RxFrameSize = le16_to_cpu(rxh->RxFrameSize);

NACK -- use proper structs with endian annotations, this will either
generate sparse warnings or not have proper endian annotations. Try make
C=2 CFLAGS=-D__CHECK_ENDIAN__ M=... (or just add check endian to the
Makefile like mac80211, iwlwifi etc.)



> +	/* explicitly test bad src address to avoid sending bad deauth */

??



> +	/* due to sheer numbers, toss out probe reqs for now */
> +	if (ieee80211_is_probe_req(h->frame_control))
> +		goto toss;

???



> brcms_c_calc_lsig_len

Ok, I think I like that, can somebody explain to me how to calculate the
length from the ON_AIR_RISE to the timestamp in beacons for HT?



> +/* wrapper BMAC functions to for HIGH driver access */

Not sure that's really necessary? Especially empty ones seem ...
pointless.


Ok I got all the way to 
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/main.h

(not including that file) but I think I've had enough for now :-)


johannes

