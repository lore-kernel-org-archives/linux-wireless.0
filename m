Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from THAUM.MIT.EDU ([18.95.3.27]:51500 "EHLO luto.stanford.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750807AbYGGEz5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jul 2008 00:55:57 -0400
Message-ID: <48719F2F.5060301@myrealbox.com> (sfid-20080707_065601_369752_A67B96D1)
Date: Mon, 07 Jul 2008 00:44:31 -0400
From: Andy Lutomirski <luto@myrealbox.com>
MIME-Version: 1.0
To: hmh@hmh.eng.br
CC: thomasw@gmail.com, zhu.yi@intel.com,
	linux-wireless@vger.kernel.org, dcbw@redhat.com
Subject: Re: Question on rfkill double block
References: <1214982208.14590.473.camel@debian.sh.intel.com> <20080702193202.GA20410@khazad-dum.debian.net> <1ba2fa240807051428i3f49f621i7b583bec58a02869@mail.gmail.com> <20080706002037.GD21973@khazad-dum.debian.net>
In-Reply-To: <20080706002037.GD21973@khazad-dum.debian.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Henrique de Moraes Holschuh wrote:
> On Sun, 06 Jul 2008, Tomas Winkler wrote:
>> From my experience from other OS the states of SW and HW RF KILL
>> switches should be independent and visible to user space
>> otherwise it's very hard to make something coherent out of it. It
>> should be visible to user himself so he/she knows what switch actually
>> press. And also to let say unmanned application, most important in
>> preserving SW switch state across reboots and resume/suspend events.
>> Radio state is just simple AND function of all the switches in the
>> game anything else just leads to confusion.
>> Currently we have rkill switch from sysfs, hw rfkill, iwconfig txpower
>> off, the last one is better to eliminate but still we have TRIPLE
>> BLOCKING
> 
> I am not convinced it is the best way to go, but I thought on it, and that
> fourth state will at least help on sleep-to-ram resume, so you guys will get
> four states.  
> 
> But I can't give you a bitmap.  Sorry, there is a stablished sysfs ABI in
> mainline that says this:
> 
> 00 - BLOCK ("off")
> 01 - UNBLOCK ("on")
> 
> I hate it, but I can't change it.  We can *extend* it, but that's it.

Perhaps it's time to throw out the userspace interface and start over, 
or at least replace it and emulate the old one, too.

I'm not even kidding.  I have an iwl4965, and I've tried 2.6.25.10's 
built-in driver and wireless-compat from a couple days ago.  The rfkill 
switch *works* but the userspace interface does nothing.  (2.6.25.10's 
module at least causes network-manager to notice that the interface went 
down and gets a ton of "Requesting MAC access during RFKILL wakes up 
NIC."  Wireless-compat's driver just confuses network-manager.)  The 
rfkill module seems to have no effect, and 'find /sys -name *rfkill*' 
shows nothing (other than the rfkill class and module).  Rfkill doesn't 
work on my ath5k system either (no rfkill file).  This is Ubuntu Hardy, 
which has nm 0.6, but I once tried nm 0.7 from svn and I don't recall it 
working any better.

Not to mention the fact that I have both an rfkill switch and an rfkill 
button.  Pressing the button turns WLAN off (same RFKILL messages 
spammed to dmesg) and Bluetooth *on*.  Maybe it's thinkpad_acpi's fault, 
but I don't really see how it's supposed to work right.

So it seems to me that the status quo is:
  - If there's a sysfs file called rfkill, it has such and such 
semantics, and you probably can't change it by writing to it.
  - There probably isn't an rfkill file.
  - Userspace, at least on my laptops, doesn't currently use the rfkill 
ABI in any meaningful manner.
  - Software rfkill control can easily do the wrong thing and there's no 
obvious way to make it do the right thing from userspace, .config, or sysfs.

Maybe the new semantics should be something sensible with a read-only 
file called "rfkill" that's backwards-compatible and shows the overall 
state.  Then we could do gnarly things like making *every* mac80211 
driver have software rfkill control, add inotify or something to the 
rfkill file, and generally have good and easily comprehensible control 
over all radios.  Hardware switches (and momentary swtiches and buttons 
and whatnot) could all be exposed directly to userspace.  Who knows -- 
there could even be files like "hard_rf_enable" (read-only, only there 
if there's a readable switch, like on iwl4965) and "soft_rf_enable" 
(read-write, unconditionally present), and a mechanism for userspace to 
control the software part (i.e. userspace could tell rfkill-input to 
stop doing anything and take control itself).

I'd suggest that nothing visible to userspace on the rfkill side go into 
2.6.27 until it can be done right and it's clear what this whole 
mechanism is supposed to do.  I might even be talked into writing some 
patches, because it would be kind of nice for all this stuff to work 
right on my laptops.

If I'm missing something I need to make rfkill suddenly work on my 
machine, please give me some hints, too :)

--Andy

