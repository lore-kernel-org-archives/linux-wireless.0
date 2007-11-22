Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:20835 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753249AbXKVELm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2007 23:11:42 -0500
From: bruno randolf <bruno@thinktube.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [ath5k-devel] ath5k: more consistent debug, info and error logging
Date: Thu, 22 Nov 2007 13:11:40 +0900
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, "Jiri Slaby" <jirislaby@gmail.com>,
	"Nick Kossifidis" <mickflemm@gmail.com>
References: <1195549767-21983-1-git-send-email-bruno@thinktube.com> <200711201817.40243.bruno@thinktube.com> <43e72e890711201757m159a5147j3984c3f1555e5444@mail.gmail.com>
In-Reply-To: <43e72e890711201757m159a5147j3984c3f1555e5444@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200711221311.42072.bruno@thinktube.com> (sfid-20071122_041152_303283_4A02E118)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 21 November 2007 10:57:51 Luis R. Rodriguez wrote:
> thanks for this work BTW. CC'ing other maintainers, you probably just
> forgot. I know this is a pain but this is a pretty big patch, can you
> split it into a few for better review? I also know this is just debug
> stuff but it would help. One for each main task you mention below
> might do it, or something like that.

ok. i did that in my last 2 posts, but you are right - i missed your comments 
here. i will address them now, but please be aware, that the last 2 patches 
are slightly different, i.e. i renamed AR5K_... to ATH5K_... and a few 
smaller things to keep scripts/checkpatch.pl happy.

> > > +#define AR5K_PRINTK(_sc, _level, _fmt, ...) \
> > > +     printk(_level "ath5k %s: " _fmt, \
> > > +             ((_sc) && (_sc)->hw) ? wiphy_name((_sc)->hw->wiphy) : "",
> > > \ +             ##__VA_ARGS__)
> > > +
> > > +#define AR5K_PRINTK_LIMIT(_sc, _level, _fmt, ...) do { \
> > > +     if (net_ratelimit()) \
> > > +             AR5K_PRINTK(_sc, _level, _fmt, ##__VA_ARGS__); \
> > > +     } while (0)
> > > +
> > > +#define AR5K_INFO(_sc, _fmt, ...) \
> > > +     AR5K_PRINTK(_sc, KERN_INFO, _fmt, ##__VA_ARGS__)
> > > +
> > > +#define AR5K_WARN(_sc, _fmt, ...) \
> > > +     AR5K_PRINTK_LIMIT(_sc, KERN_WARNING, _fmt, ##__VA_ARGS__)
> > > +
> > > +#define AR5K_ERR(_sc, _fmt, ...) \
> > > +     AR5K_PRINTK_LIMIT(_sc, KERN_ERR, _fmt, ##__VA_ARGS__)
>
> I was kind of hoping we could stick to dev_[info|warn|err] for these.
> IIRC you had mentioned you can't get the device name printed? Is that
> right?

no. i print the name of the phyX device which i get with "wiphy_name()". i 
think this is more descriptive than the PCI bus id, especially if you want to 
match output from mac80211 to messages within ath5k. i do print a message 
like "ath5k_pci 0000:00:0e.0: registered as 'phy0'" via dev_info and from 
that point on the phyX device name is used.

anyways using these defines, and giving them sc gives us the possibility to 
switch them to use dev_info as well, we'd just have to change

#define ATH5K_PRINTK(_sc, _level, _fmt, ...) \
	dev_info(&(_sc)->pdev->dev, _fmt, ##__VA_ARGS__)

but i think, as i said above, using the phy name makes things clearer. also 
note that this is more or less the same as used in other mac80211 based 
drivers.

> > > diff --git a/drivers/net/wireless/ath5k/base.c
> > > b/drivers/net/wireless/ath5k/base.c index 77e3855..6ca7ebf 100644
> > > --- a/drivers/net/wireless/ath5k/base.c
> > > +++ b/drivers/net/wireless/ath5k/base.c
>
> Notice the license on base.[ch]. It's a "Dual GPL/BSD" license.
> Although all of our recent changes have been licensed the 3-clause-BSD
> for these files we did not verify the same for previous changes on
> MadWifi's files (stuff in base.[ch]) so its best to just keep the Dual
> license there for that code in case previous authors did intend on
> licesning their changes under the GPL (hence the problem with using
> vague "alternatively" language for Dual licensing). This presents a
> problem in trying to shift code on base.[ch] onto what you would think
> is an OK ISC-only licensed code. This is also the problem we knew we'd
> face down the road with trying to help OpenBSD -- in the end we may
> want to just shuffle around GPL code into ISC licensed code and well,
> then it becomes a pretty heavy nightmware for us to keep track of
> which part of the code is licensed under what for them.
>
> As we have it right now base.[ch] contains code which *may* have been
> patched in for GPL-only intentions (prior to kernel inclusion). In
> your patch series I'd like to see careful use of this shifting. If you
> are just deleting code, great, but if you are reusing code please
> either go through the git-log to see what license the changes were
> made (haha, good one huh!) or well lets just GPL those new files you
> are creating. The debug print stuff is pretty useless to other kernels
> too as its very specific to Linux.

ugh, that's getting complicated...

ok then. let's split it up into the 2 patches i've sent. i think the first one 
is pretty clear, as it just renames stuff, especially in base.c (i doubt that 
it's even worth a copyright claim). so would that be fine with a BSD license?

next: patch 2, debugging, is the complicated one, because i move stuff from 
base.c and hc.c to a different file, debugging.c (ath_printrxbuf(), 
ath_printtxbuf(), ath_dump_skb() and various other debugging parts). most of 
this code comes into git from Jiri Slaby's initial commit 88c37f32... "Net: 
add ath5k wireless driver" (git blame and git-gui is great!)

tracking things further than that is difficult but i found:

ath5k_printrxbuf() and ath5k_printtxbuf() also exist in a very similar way in 
madwifi, and it's pretty obvious they come from there, hence they are dual 
GPL/BSD licensed, right?

the debugging code i took out of ath_stoprecv() into a new function 
ath5k_debug_printrxbuffs() also seems to have it's origin in madwifi too, 
although modified for different list handling. so probably dual BSD/GPL too.

as far as i can tell ath_dump_skb and ath_dump_modes first appeared in Jiri 
Slaby's initial commit 88c37f32 so i'm not sure about their license. i found 
some messages which indicate that he intended GPL, but that did not hold or 
something?

ath5k_debug_dump_hwstate() clearly comes from openbsd 
ar5k_ar5212/11_dump_state, so it's ISC license (afaik, or BSD???).

so as a summary these are the functions i moved into debug.c:
function			source	license
-----------------------------------------------
ath5k_debug_printrxbuf()	madwifi	BSD/GPL
ath5k_debug_printrxbuffs()	madwifi	BSD/GPL
ath5k_debug_printtxbuf()	madwifi	BSD/GPL
ath5k_debug_dump_hwstate()	openbsd	ISC
ath5k_debug_dump_modes()	jiri	???
ath5k_debug_dump_skb()		jiri	???

+ it contains additional stuff (debugfs) which i made, therefore can license 
however i like.

which makes it license-able under what? i personally don't really care, and as 
you said it's only debugging stuff, so probably it won't go back into BSD 
systems anyways. at the same time as far as i understand we can take BSD 
stuff and re-license it under GPL, right, it's just not considered to be a 
nice thing to do. so would it be o.k. in this case to make debug.c licensed 
as GPL only?

anyhow i don't care about which license, and i don't want to get into license 
politics, but it is a real pain if we have to spend the same amount of time 
doing that kind of history searching as we spend coding - for every change we 
make. especially since most of this is probably irrelevant as nobody is going 
to port it back to BSD or it came from the ultra-permissive dual BSD/GPL 
anyways.

so please advise me which license is the most practical to use.

> > > 0x%x)\n", +     AR5K_INFO(sc, "Atheros AR%s chip found (MAC: 0x%x, PHY:
> > > 0x%x)\n", ath5k_chip_name(AR5K_VERSION_VER,sc->ah->ah_mac_srev),
> > > sc->ah->ah_mac_srev,
> > >                                       sc->ah->ah_phy_revision);
> > > @@ -580,27 +490,28 @@ ath5k_pci_probe(struct pci_dev *pdev,
> > >               if(sc->ah->ah_radio_5ghz_revision &&
> > > !sc->ah->ah_radio_2ghz_revision) { /* No 5GHz support -> report 2GHz
> > > radio */ if(!test_bit(MODE_IEEE80211A,
> > > sc->ah->ah_capabilities.cap_mode)){ -                            
> > > dev_info(&pdev->dev, "RF%s 2GHz radio found (0x%x)\n", +               
> > >              AR5K_INFO(sc, "RF%s 2GHz radio found (0x%x)\n",
> > > ath5k_chip_name(AR5K_VERSION_RAD,sc->ah->ah_radio_5ghz_revision),
> > > sc->ah->ah_radio_5ghz_revision); /* No 2GHz support (5110 and some 5Ghz
> > > only cards) -> report 5Ghz radio */ } else
> > > if(!test_bit(MODE_IEEE80211B, sc->ah->ah_capabilities.cap_mode)){ -    
> > >                         dev_info(&pdev->dev, "RF%s 5GHz radio found
> > > (0x%x)\n", +                             AR5K_INFO(sc, "RF%s 5GHz radio
> > > found (0x%x)\n",
>
> See for example, here I wouldn't mind leaving dev_info, etc, with our
> own macros.

well i can change these lines back to use dev_info, but don't you think this 
output is o.k. too? an example:

ath5k_pci 0000:00:0e.0: registered as 'phy4'
ath5k phy4: Device only partially supported.
ath5k phy4: Atheros AR5414 chip found (MAC: 0xa5, PHY: 0x61)
ath5k_pci 0000:00:0f.0: registered as 'phy5'
ath5k phy5: Atheros AR5213 chip found (MAC: 0x56, PHY: 0x41)
ath5k phy5: RF5111 5GHz radio found (0x17)
ath5k phy5: RF2111 2GHz radio found (0x23)

> > > +++ b/drivers/net/wireless/ath5k/debug.c
> > > @@ -0,0 +1,256 @@
> > > +/*
> > > + * Copyright (c) 2004-2007 Reyk Floeter <reyk@openbsd.org>
> > > + * Copyright (c) 2006-2007 Nick Kossifidis <mickflemm@gmail.com>
>
> You're adding unique code (debugfs stuff), you should add your
> Copyright entry here.

o.k.

> But note that this will look very different if 
> this is GPL'd. Please refer to SFLC's guidelines if you are to GPL
> these files (probably going to be needed).

> > > +     for (m = 0; m < NUM_DRIVER_MODES; m++) {
> > > +             printk(KERN_DEBUG "Mode %u: channels %d, rates %d\n", m,
> > > +                             modes[m].num_channels,
> > > modes[m].num_rates); +             printk(KERN_DEBUG " channels:\n");
>
> How about dev_dbg instead?

i think in general we should stick with one method, so that would be 
ATH5K_DBG. which in turn can be made to use dev_dbg if we choose to. but i 
made ATH5K_DBG rate limited (net_ratelimit()) so we can't use it to print 
several lines like this. i think it's ok, now, as all printk(KERN_DEBUG,... 
are within debug.[ch], and we can change it easily to have the same output 
like ATH5K_DGB. or we add another ATH5k_DBG_NONLIMITED or something?

> > > +     ATH_DEBUG_RESET         = 0x00000001,   /* reset processing */
> > > +     ATH_DEBUG_INTR          = 0x00000002,   /* ISR */
> > > +     ATH_DEBUG_MODE          = 0x00000004,   /* mode init/setup */
> > > +     ATH_DEBUG_XMIT          = 0x00000008,   /* basic xmit operation
> > > */ +     ATH_DEBUG_BEACON        = 0x00000010,   /* beacon handling */
> > > +     ATH_DEBUG_BEACON_PROC   = 0x00000020,   /* beacon ISR proc */ +  
> > >   ATH_DEBUG_CALIBRATE     = 0x00000100,   /* periodic calibration */ + 
> > >    ATH_DEBUG_TXPOWER       = 0x00000200,   /* transmit power */ +    
> > > ATH_DEBUG_LED           = 0x00000400,   /* led management */ +    
> > > ATH_DEBUG_DUMP_RX       = 0x00001000,   /* print received skb content
> > > */ +     ATH_DEBUG_DUMP_TX       = 0x00002000,   /* print transmit skb
> > > content */ +     ATH_DEBUG_DUMPSTATE     = 0x00004000,   /* dump
> > > register state */ +     ATH_DEBUG_DUMPMODES     = 0x00008000,   /* dump
> > > modes */ +     ATH_DEBUG_TRACE         = 0x00010000,   /* trace
> > > function calls */ +     ATH_DEBUG_FATAL         = 0x80000000,   /*
> > > fatal errors */ +     ATH_DEBUG_ANY           = 0xffffffff
> > > +};
>
> While you're at it can you move these to use kernel-doc? You'll have
> to name the enum, perhaps ath5k_debug ?

o.k.

thank you for your comments, luis!

i would appreciate it if you could give me more advice concerning the 
licensing issues as discussed above, so i can send in a correctly licensed 
patch.

bruno
