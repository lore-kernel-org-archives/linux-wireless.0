Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:34537 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816AbbIKQcN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Sep 2015 12:32:13 -0400
Received: by wicfx3 with SMTP id fx3so70534037wic.1
        for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2015 09:32:12 -0700 (PDT)
Subject: Re: [linuxwifi] iwlwifi: FW error in SYNC CMD MAC_CONTEXT_CMD
To: Luca Coelho <luca@coelho.fi>, linux-wireless@vger.kernel.org
References: <55ED93D0.4070509@gmail.com> <1441690676.27148.11.camel@coelho.fi>
 <1441693888.27148.20.camel@coelho.fi> <55F03D91.6020802@gmail.com>
 <1441915203.27148.191.camel@coelho.fi>
Cc: "ilw@linux.intel.com" <ilw@linux.intel.com>,
	linuxwifi <linuxwifi@intel.com>
From: Andreas Reis <andreas.reis@gmail.com>
Message-ID: <55F3020B.8040906@gmail.com> (sfid-20150911_183218_135181_DF0B03A3)
Date: Fri, 11 Sep 2015 18:32:11 +0200
MIME-Version: 1.0
In-Reply-To: <1441915203.27148.191.camel@coelho.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry for another day delay, I've only got so much time for this and 
yesterday it ended in a bit of confusion.

 > Okay, there's probably something else.

I started by using a fresh wpa_supplicant configuration – and could 
connect. Which is just weird, as the old ones worked fine previously.

Anyway, what appears to happen is that something accumulates during 
(repeated) failed connection/authentication attempts, which then 
proceeds to cause kernel warnings and FW resets.

Hardly any of either occurs on 4.2, but then again I mostly messed with 
net.git. I did not find a difference between "its" for-kalle-2015-08-23 
and iwl-next HEAD, either.

(Also, I couldn't connect with the fresh configuration after using the 
"broken" old one for a few dozen attempts. Dunno for certain, but seems 
the local APs block my laptop for a while, when I moved 500m it worked 
again. IOW, prob not a iwl issue either.)

 > I added a small comment to address that.

There's more: journalctl (systemd 226) still showed the iwlfwdump.sh 
script rejected by systemd-udev with "Exec format error". That's caused 
by the #!/bin/sh shebang missing. The "filename" variable also needs to 
be stripped of the duplicated /var/log/ prefix.

 > All major distros package it (including, apparently, ArchLinux).

Actually Arch does not. Still, there's a buildscript in the unofficial 
user repositories, which I used to get v2.6 when I had internet access 
again.

Also, it's curious how "trace-cmd record -e iwlwifi -e mac80211 -e 
cfg80211 -e iwlwifi_msg" tends to include eg. snd and drm events regardless.

 > What shell are you using?

zsh. Seems it requires the use of >>, unlike agnostic bash.

 > I think what happens is that the system is already stuck somehow

I did it repeatedly yesterday and got the "trigger 1 fired" message, 
both with (as in the case of the trace I'll send) and without the dmesg 
warning immediately afterwards.

 > wpa_supplicant seems to be using WEXT which is deprecated and 
certainly not as well maintained as the nl80211 API.

Huh. Wicd defaults to Wext, guess that's badly outdated behavior then. 
OTOH, the project has been on life support for a while now, but I still 
find it the most straightforward manager.

 > I don't think this has any relation with the wifi problems you're having.

Yeah. I actually know which commit to the r8169 driver causes it, but 
found it notable enough as it both appears also triggerable by wifi 
activity and stops once either (wifi/eth) link becomes ready.

 > Just out of curiosity, why are you using iwlwifi-next.git?

I use net.git + iwl + fixes from vanilla. That started back when 
(compared to my previous 7yo laptop) the 7260's Linux QoS was frankly 
abysmal, at least on certain 11g connections. That way I would instantly 
get any improvements. Now it's just curiosity and habit.

Anyhow, I got a trace (net.git 519f526 + iwl-next) with a reset that 
followed repeated connection/authentication failure. I got the resets 
both with Wext and nl80211, this one with the latter. I'll send it to 
you directly via mail once I figure out how to set up my PGP.

Should I still open a bugzilla entry?

-- Andreas

On 09/10/2015 10:00 PM, Luca Coelho wrote:
> On Wed, 2015-09-09 at 16:09 +0200, Andreas Reis wrote:
>> Hi,
>>
>>   > seems that your system is trying to connect to two different APs
>> forth and back
>>
>> Yes, this is a major network with multiple APs for each of its SSIDs
>> always available. Unlike my single AP home network, unsurprisingly.
>>
>>   > whether you have more than wpa_supplicant instance running
>>
>> I disabled wicd, invoked wpa_supplicant manually and checked with
>> pidof,
>> there isn't. I also checked for changes with wpa_supplicant 2.3 vs
>> git,
>> none.
>
> Okay, there's probably something else.  Checking for two "competing"
> instances of wpa_supplicant is low hanging fruit and the symptom is the
> same you saw.
>
>
>>   > was this working before you upgraded to iwlwifi-next 5bff6536f742
>>
>> That's the weird part, IIRC it and the 16er firmware actually were
>> working fine *with* it (I had 4.2-RCs running with available
>> iwlwifi-next commits for weeks), which is why I was inclined to blame
>> net.git until I found out that it currently doesn't work with the
>> vanilla Arch 4.2-3 kernel either. Honestly no idea why.
>>
>> But I'll check with iwlwifi-next-for-kalle-2015-08-23 tomorrow.
>
> Okay, please let us now if it makes any difference.
>
>
>>   > directions in our debugging wiki page
>>
>> Two remarks on that page:
>> iwlfwdump.sh should probably get a note about chmod +x
>
> Right, even though making scripts executable is a pretty standard
> practice, people may forget it and then it's too late (i.e. the capture
> was already lost).  I added a small comment to address that.
>
>
>
>> trace-cmd is not part of standard kernel packages and thus should get
>> a
>> note that it may need to be installed separately
>>
>>> Since I wasn't aware of the latter, I'll only be able to post a
>>> trace in
>> a bugzilla report tomorrow–
>
> trace-cmd is not part of the kernel, it's just a userspace helper.  It
> is pretty standard, though.  All major distros package it (including,
> apparently, ArchLinux).
>
>
>> – if that isn't bugged as well: "echo 1 >
>> /sys/kernel/debug/iwlwifi/0000\:02\:00.0/iwlmvm/fw_dbg_collect"
>> currently yields a "file exists", cat'ing it an invalid argument
>> error,
>> "echo 1 >>" ostensibly works but shows in dmesg as (1), see
>> "excerpts"
>> attachment.
>
> That's weird.  This debugfs entry accepts anything as input... What
> shell are you using? The (1) error seems to be totally unrelated.  I
> think what happens is that the system is already stuck somehow, that's
> why neither of the commands work.  Could you try the same command
> cleanly (i.e. before you start experiencing any problems)? You should
> see something like this in dmesg:
>
> iwlwifi 0000:02:00.0: Collecting data: trigger 1 fired.
>
>
>
>> (2) shows an example of what wpa_supplicant currently prints. This
>> continues ad inf, and at some non-predictable point the driver
>> bug(s?)
>> and/or FW reset appear in dmesg.
>
> Hmmm... wpa_supplicant seems to be using WEXT which is deprecated and
> certainly not as well maintained as the nl80211 API.  Could you try to
> make sure that wpa_supplicant is using the nl80211 API instead? It
> needs to be started with -Dnl80211 in the command line.
>
>
>>   (3) shows two more variants I got with
>> net.git (now at 7845989) and Arch's 4.2-3 kernel.
>
> There's some different stuff there... For some reason the system seems
> to be quite unstable, probably the firmware is stuck or something.
>
>
>> dmesg is also spammed with "r8169 0000:03:00.1 enp3s0f1:
>> rtl_counters_cond == 1 (loop: 1000, delay: 10).", but that's prob an
>> unrelated bug which has been there (but far) less frequent since
>> early 4.2.
>
> I don't think this has any relation with the wifi problems you're
> having.
>
>
>> As for net.git kernel config, "grep IWLWIFI":
>> CONFIG_IWLWIFI=m
>> CONFIG_IWLWIFI_LEDS=y
>> CONFIG_IWLWIFI_OPMODE_MODULAR=y
>> CONFIG_IWLWIFI_BCAST_FILTERING=y
>> CONFIG_IWLWIFI_UAPSD=y
>> CONFIG_IWLWIFI_DEBUG=y
>> CONFIG_IWLWIFI_DEBUGFS=y
>> # CONFIG_IWLWIFI_DEBUG_EXPERIMENTAL_UCODE is not set
>> CONFIG_IWLWIFI_DEVICE_TRACING=y
>
> This looks fine.  Just out of curiosity, why are you using iwlwifi
> -next.git? That is just a feeding tree for wireless-drivers-next.git.
>   It usually is prepared to send a pull request, but due to the merge
> window (and to the temporary transition from Emmanuel to me as the
> maintainer of that tree), the pull request is delayed.
>
> To conclude, we don't really have much information here.  It will be
> very helpful if you can provide trace-cmd logs and the firmware dump at
> some point.
>
> --
> Luca.
>

