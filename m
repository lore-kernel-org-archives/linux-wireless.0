Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33268 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752365AbbIJUAH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2015 16:00:07 -0400
Message-ID: <1441915203.27148.191.camel@coelho.fi> (sfid-20150910_220016_476315_4F26AE50)
From: Luca Coelho <luca@coelho.fi>
To: Andreas Reis <andreas.reis@gmail.com>,
	linux-wireless@vger.kernel.org
Cc: "ilw@linux.intel.com" <ilw@linux.intel.com>,
	linuxwifi <linuxwifi@intel.com>
Date: Thu, 10 Sep 2015 23:00:03 +0300
In-Reply-To: <55F03D91.6020802@gmail.com>
References: <55ED93D0.4070509@gmail.com>
	 <1441690676.27148.11.camel@coelho.fi> <1441693888.27148.20.camel@coelho.fi>
	 <55F03D91.6020802@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [linuxwifi] iwlwifi: FW error in SYNC CMD MAC_CONTEXT_CMD
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-09-09 at 16:09 +0200, Andreas Reis wrote:
> Hi,
> 
>  > seems that your system is trying to connect to two different APs 
> forth and back
> 
> Yes, this is a major network with multiple APs for each of its SSIDs 
> always available. Unlike my single AP home network, unsurprisingly.
> 
>  > whether you have more than wpa_supplicant instance running
> 
> I disabled wicd, invoked wpa_supplicant manually and checked with
> pidof, 
> there isn't. I also checked for changes with wpa_supplicant 2.3 vs
> git, 
> none.

Okay, there's probably something else.  Checking for two "competing"
instances of wpa_supplicant is low hanging fruit and the symptom is the
same you saw.


>  > was this working before you upgraded to iwlwifi-next 5bff6536f742
> 
> That's the weird part, IIRC it and the 16er firmware actually were 
> working fine *with* it (I had 4.2-RCs running with available 
> iwlwifi-next commits for weeks), which is why I was inclined to blame
> net.git until I found out that it currently doesn't work with the 
> vanilla Arch 4.2-3 kernel either. Honestly no idea why.
> 
> But I'll check with iwlwifi-next-for-kalle-2015-08-23 tomorrow.

Okay, please let us now if it makes any difference.


>  > directions in our debugging wiki page
> 
> Two remarks on that page:
> iwlfwdump.sh should probably get a note about chmod +x

Right, even though making scripts executable is a pretty standard
practice, people may forget it and then it's too late (i.e. the capture
was already lost).  I added a small comment to address that.



> trace-cmd is not part of standard kernel packages and thus should get
> a 
> note that it may need to be installed separately
> 
> > Since I wasn't aware of the latter, I'll only be able to post a
> > trace in 
> a bugzilla report tomorrow–

trace-cmd is not part of the kernel, it's just a userspace helper.  It
is pretty standard, though.  All major distros package it (including,
apparently, ArchLinux).


> – if that isn't bugged as well: "echo 1 > 
> /sys/kernel/debug/iwlwifi/0000\:02\:00.0/iwlmvm/fw_dbg_collect" 
> currently yields a "file exists", cat'ing it an invalid argument
> error, 
> "echo 1 >>" ostensibly works but shows in dmesg as (1), see
> "excerpts" 
> attachment.

That's weird.  This debugfs entry accepts anything as input... What
shell are you using? The (1) error seems to be totally unrelated.  I
think what happens is that the system is already stuck somehow, that's
why neither of the commands work.  Could you try the same command
cleanly (i.e. before you start experiencing any problems)? You should
see something like this in dmesg:

iwlwifi 0000:02:00.0: Collecting data: trigger 1 fired.



> (2) shows an example of what wpa_supplicant currently prints. This 
> continues ad inf, and at some non-predictable point the driver
> bug(s?) 
> and/or FW reset appear in dmesg.

Hmmm... wpa_supplicant seems to be using WEXT which is deprecated and
certainly not as well maintained as the nl80211 API.  Could you try to
make sure that wpa_supplicant is using the nl80211 API instead? It
needs to be started with -Dnl80211 in the command line.


>  (3) shows two more variants I got with 
> net.git (now at 7845989) and Arch's 4.2-3 kernel.

There's some different stuff there... For some reason the system seems
to be quite unstable, probably the firmware is stuck or something.


> dmesg is also spammed with "r8169 0000:03:00.1 enp3s0f1: 
> rtl_counters_cond == 1 (loop: 1000, delay: 10).", but that's prob an 
> unrelated bug which has been there (but far) less frequent since
> early 4.2.

I don't think this has any relation with the wifi problems you're
having.


> As for net.git kernel config, "grep IWLWIFI":
> CONFIG_IWLWIFI=m
> CONFIG_IWLWIFI_LEDS=y
> CONFIG_IWLWIFI_OPMODE_MODULAR=y
> CONFIG_IWLWIFI_BCAST_FILTERING=y
> CONFIG_IWLWIFI_UAPSD=y
> CONFIG_IWLWIFI_DEBUG=y
> CONFIG_IWLWIFI_DEBUGFS=y
> # CONFIG_IWLWIFI_DEBUG_EXPERIMENTAL_UCODE is not set
> CONFIG_IWLWIFI_DEVICE_TRACING=y

This looks fine.  Just out of curiosity, why are you using iwlwifi
-next.git? That is just a feeding tree for wireless-drivers-next.git. 
 It usually is prepared to send a pull request, but due to the merge
window (and to the temporary transition from Emmanuel to me as the
maintainer of that tree), the pull request is delayed.

To conclude, we don't really have much information here.  It will be
very helpful if you can provide trace-cmd logs and the firmware dump at
some point.

--
Luca.
