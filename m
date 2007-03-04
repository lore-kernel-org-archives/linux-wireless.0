Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailgate.cesmail.net ([216.154.195.36]:43839 "HELO
	mailgate.cesmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751455AbXCDHJV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2007 02:09:21 -0500
Message-ID: <20070304020920.b5lej3sw0oogwg4w@webmail.spamcop.net>
Date: Sun,  4 Mar 2007 02:09:20 -0500
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Guido Guenther <agx@sigxcpu.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [patch] at76_usb wireless driver
References: <20070110145724.GA4171@bogon.ms20.nix>
	<20070223221230.GA9965@bogon.ms20.nix>
	<20070303150029.GA19940@bogon.ms20.nix>
	<1172934588.4966.46.camel@johannes.berg>
	<1172939037.4966.97.camel@johannes.berg>
In-Reply-To: <1172939037.4966.97.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Johannes Berg <johannes@sipsolutions.net>:

> Looks pretty good, a few more comments.

Thanks!

> KEVENT_* constants and functions are really really confusing when the
> "kevent" subsystem is being discussed on netdev all the time. They're
> also quite meaningless, please rename them to something like
> AT76_DEVEVENT_* or whatever. While at that, the kevent() function really
> could use splitting up into sub-functions, it's a pretty large mess.

I agree.  The purpose is likely to avoid scheduling too many different tasks,
but I don't think it's worth the trouble.  In fact, it would be better if the
driver had smaller tasks that would all compete with other scheduled tasks.  It
would be fair to others.

> The same about constant names goes for PM_* constants since linux/pm.h
> defines a whole bunch of PM_* constants too (I initially thought you
> were using those and was really confused what the driver does!)

Good catch.

> Having a whole bunch of module parameters that only set initial settings
> for things you later configure with iwconfig seems pretty useless but if
> you really think that they're absolutely required I don't care too much.

I agree, they are not needed.  It should be verified that all parameters can be
set using iwconfig or iwpriv.  Maybe "debug" should stay.

> PRIV_IOCTL_SET_MONITOR_MODE is wrong as far as I can tell, there's
> "iwconfig ... mode monitor" which you should use instead. (Btw, why are
> the priv ioctls spaced so strangely??)

The code is quite old and may predate monitor mode.  Reference to Kismet means
that the driver was meant to emulate an old unofficial patch to orinoco driver.

On the other hand, the same setting selects whether to enable prism header, so
that part should probably stay.

> There doesn't seem to be a need to include rtnetlink.h, what made you
> think you'd need rtnl_lock()?
> "putting this inside rtnl_lock() - rtnl_unlock() hangs modprobe" is
> pretty obvious -- register_netdev does rtnl_lock()! And don't use
> unregister_netdevice(), use unregister_netdev().

I see Guido has done it already.

> Your init_new_device() function can return an error but those errors are
> not always checked, maybe a printk would be appropriate. Also,
> generally, subfunctions are allowed to return errors directly, i.e.
> instead of returning -1 return -ENODEV from there and just hand it up
> from the caller.

Agreed.

> at76c503_do_probe could use splitting into two functions, the two huge
> parts of the if, if only to unindent the whole code a bit and get it to
> adhere to 80 chars/line instead of 99.

Actually, there is some code duplication between the branches.  It would be
great to avoid it first.  I also see that the code overuses debug printing.  I
prefer to add it to fix a specific problem.  Keeping large portions of debug
code just in case is probably not a good idea, since they reduce readability of
the code.

> "Use our own dbg macro" but mabye use dev_dbg?
> Same for err() (which I didn't even know existed..) how about dev_err()?

I think the driver uses USB functions here.  I think it's OK for a USB driver. 
But the own dbg macro should probably be avoided.

> static u8 snapsig/rfc1042sig/bc_addr/off_addr/hw_rates/channel_frequency
> etc etc etc don't belong into a header file.

Absolutely!  But since it's mixed with definitions, perhaps the whole code could
be merged into at76_usb.c.  It's not like any other driver will ever include
that header.  And adding 30k to 200k won't change much.

> Some other (mostly style) issues:
>  * kernel code prefers a space before the brace in
>    "struct at76c503_command{" et al.
>  * both your header and code files contain lots of trailing whitespace
>  * kernel code prefers no space between function names and the opening
>    parenthesis

I think Lindent (from scripts directory in Linux sources) should be run on the
driver.  Better yet, "Linudent --ignore-newlines).

>  * use compare_ether_addr() instead of memcmp (look for ETH_ALEN, lots
>    of places)

OK

>  * all the PROC ===== stuff looks pretty strange to my eyes but hey
>    that's just me I guess :)

That must be style from a language where functions are called procedures.  Sure,
it must be removed.

>  * why does at76c503_get_fw_info take such a huge number of parameters?
>    Couldn't you pass in a struct at76c503 * and have that filled?

Good idea.

>  * struct reg_domain should be tab-indented.

Lindent should take care of it.

>  * don't use typedefs for structs

All that code is prism header implementation from linux-wlan-ng, but I
understand that it's a bad excuse.  Besides, one of the typedefs is not used.

>  * attribute packed on members of a struct is pretty weird

Another ugly legacy of linux-wlan-ng.

>  * the various frame definitions like struct ieee802_11_beacon_data are
>    useless, the same stuff is in struct ieee80211_mgmt (at least on
>    wireless dev kernel, that might not be true on other kernels?)

Yes, this needs to be done, but it requires some work.  The names are different.

>  * hex2str wants proper indentation
>  * get_hw_config has weird indentation

Lindent will fix it.

>  * wait_completion sounds far too generic (wait_for_completion in
>    completion.h!)

Yes, many function should be renamed.

> Hey, I need to go but that probably gives you a lot to review...

Thanks!

I would also add:

* useless macros (NUM_EP, EP)
* macros for locking should be avoided
* istate should be accessed using atomic_set/atomic_read; locking is overkill

--
Regards,
Pavel Roskin
