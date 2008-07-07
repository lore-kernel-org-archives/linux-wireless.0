Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:35907 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758131AbYGGQ4m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jul 2008 12:56:42 -0400
Date: Mon, 7 Jul 2008 13:56:35 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Andy Lutomirski <luto@myrealbox.com>
Cc: thomasw@gmail.com, zhu.yi@intel.com,
	linux-wireless@vger.kernel.org, dcbw@redhat.com
Subject: Re: Question on rfkill double block
Message-ID: <20080707165634.GA24815@khazad-dum.debian.net> (sfid-20080707_185726_756494_528EFE64)
References: <1214982208.14590.473.camel@debian.sh.intel.com> <20080702193202.GA20410@khazad-dum.debian.net> <1ba2fa240807051428i3f49f621i7b583bec58a02869@mail.gmail.com> <20080706002037.GD21973@khazad-dum.debian.net> <48719F2F.5060301@myrealbox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <48719F2F.5060301@myrealbox.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 07 Jul 2008, Andy Lutomirski wrote:
> Perhaps it's time to throw out the userspace interface and start over,  
> or at least replace it and emulate the old one, too.

[...]

> NIC."  Wireless-compat's driver just confuses network-manager.)  The  
> rfkill module seems to have no effect, and 'find /sys -name *rfkill*'  
> shows nothing (other than the rfkill class and module).  Rfkill doesn't  

Make sure rfkill is loaded and didn't bitch anything to the kernel log about
errors.  If it is loaded, and there is nothing in /sys/class/rfkill, it
means that the version of the drivers in your kernel lack rfkill class
support.

I understand you're using either 2.6.25.10 or a released Ubuntu kernel, in a
released Ubuntu userspace?   That doesn't have the latest rfkill work in it,
be it core rfkill code or network device driver code.  That's not a small
ammount of stuff.  So, it is quite possible that the iwl driver in there
doesn't have rfkill class support (I don't know for sure, but you can check.
Grep for linux/rfkill.h in the driver source).

So, what you have in a released Ubuntu kernel is not the same rfkill we are
working on yet, unless you managed to patch it in yourself.  And if you
patch it in, you need to check Ubuntu userspace as it might need
configuration changes to not double-handle KEY_WLAN, or thinkpad-acpi HKEY
events for fn+f5, etc.   I understand Ubuntu did a lot to try to get some
wireless hot key support in their releases, but this certainly means they
hooked some stuff in acpid or HAL to do it.

E.g. thinkpad-acpi cannot do anything to your WLAN device directly, and your
kernel apparently has nothing registered in the rfkill subsystem, so
rfkill-input cannot, either.  This means that userspace must be the one that
is processing KEY_WLAN and toggling WLAN rfkill (non-rfkill class based).
What happens to bluetooth might be either the firmware (unlikely), or
something in userspace that is asking thinkpad-acpi to enable/disable
bluetooth (VERY likely).  Maybe it is trying to cycle through NONE, WLAN,
BLUETOOTH, WLAN+BLUETOOTH or somesuch? 

[...]

> Maybe the new semantics should be something sensible with a read-only  
> file called "rfkill" that's backwards-compatible and shows the overall  
> state.  Then we could do gnarly things like making *every* mac80211  
> driver have software rfkill control, add inotify or something to the  
> rfkill file, and generally have good and easily comprehensible control  
> over all radios.  Hardware switches (and momentary swtiches and buttons  

Might as well add "support poll()/select() on the rfkill/state attribute in
sysfs" to the TODO list, then.  That might not be trivial to do, the sysfs
interface for poll/select (at least in 2.6.23 which was the last time I
checked it) requires an pathname relative to /sys to work, which is not
something rfkill knows about its attributes.  And I don't know if
poll()/select() support in sysfs is all that is needed for inotify to work
in sysfs.

But events to userspace have already been added (not in mainline yet), so
even if it can't be through inotify, you will get it through udev (and,
after it is modified to care about/relay those events, HAL and DBUS).

wireless network device driver support for the rfkill class is on the way,
but I don't think the mac80211 layer can help much (it is a very device
specific thing, rfkill is not about stopping data transfers, it is about
stopping energy emissions from the antennae).  If I am wrong about this,
someone will step up and correct me quite soon :-)

> I'd suggest that nothing visible to userspace on the rfkill side go into  
> 2.6.27 until it can be done right and it's clear what this whole  
> mechanism is supposed to do.  I might even be talked into writing some  
> patches, because it would be kind of nice for all this stuff to work  
> right on my laptops.

Well, please get the very latest wireless-testing tree, and read
Documentation/rfkill.txt to see what has been done already (and remember
that there could be some recent patches in this ML that have not been
applied to wireless-testing yet).  You may need to read some threads from
the last month too.

In particular, read the small, recent thread about rfkill double-locking
after you read Documentation/rfkill.txt.

That will bring you up to speed with what is being done, and then we can
talk more about it.  A lot of what you commented about is already in there,
although not exactly in the same way as you talked about it.  The various ML
threads (you can search linux-wireless and LKML for "rfkill" to find them)
have the reasoning behind most of the details.

> If I'm missing something I need to make rfkill suddenly work on my  
> machine, please give me some hints, too :)

That depends.  You want help to get a current Ubuntu setup working as well
as it can given what exists in 2.6.25.10, or do you want hints on how to
help test and develop the bleeding edge rfkill stuff?

I can't help much with the Ubuntu setup, but I think some Ubuntu power users
in linux-thinkpad could, as they likely have fixed that problem already on
their boxes.

Now, for the bleeding edge, you need wireless-testing (or wireless-compat, I
believe it has rfkill in it, now).   For a thinkpad, you will either need
thinkpad-acpi 0.21-20080703 from ibm-acpi.sf.net (filter out patches to
net/rfkill/* and include/linux/rfkill.h, if any of them clash with the ones
in wireless-compat), or the patches I sent to linux-acpi (no net/rfkill
changes there, it is just the thinkpad-acpi part).   And you may need to get
up to speed with what acpid and HAL are doing on your Ubuntu system, you
will want to try to have rfkill-input do all the work, and that means
userspace is to not do anything...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
