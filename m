Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:55063 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965Ab3EKXKh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 May 2013 19:10:37 -0400
Received: by mail-pa0-f53.google.com with SMTP id kq12so3734908pab.12
        for <linux-wireless@vger.kernel.org>; Sat, 11 May 2013 16:10:36 -0700 (PDT)
Message-ID: <518ECFEA.9090004@gmail.com> (sfid-20130512_011040_089003_16F51F42)
Date: Sat, 11 May 2013 16:10:34 -0700
From: JoSH Lehan <krellan@gmail.com>
MIME-Version: 1.0
To: Hauke Mehrtens <hauke@hauke-m.de>
CC: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: Re: Using compat-drivers conflicts with kernel mac80211 and cfg80211
References: <CALOB5QZCeC7OTqkw5go6E_KUajVe5GDuCsSsc68cpZqE2YVfRQ@mail.gmail.com> <518DF4B1.3020706@broadcom.com> <518E0CD6.3040501@hauke-m.de>
In-Reply-To: <518E0CD6.3040501@hauke-m.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/11/2013 02:18 AM, Hauke Mehrtens wrote:
> You can only use mac80211/cfg80211 from compat-driver *or* the kernel.
> There was a plan to rename all exported symbols and make it possible to
> use both at the same time, but no one fully implemented it. The API
> between mac80211/cfg80211 is not stable and changing very often to
> implement new features so it is not possible to use new drivers with an
> older version of mac80211/cfg80211 or the other way around.

OK, thanks, that's probably why it crashes then.  The ABI is different,
even though the symbols are the same.  That would explain why it
compiles and links OK, but gets very confused at runtime.

Is my workaround acceptable: maintain two different sets of
mac80211/cfg80211 modules, one from the kernel compilation and another
from the compat-drivers compilation, then, based on which driver is
detected at runtime, make sure I load the correct set?  I have a fairly
light embedded system, that lacks modern user features such as udev, so
I do module loading/detection based on a fairly simple hotplug script
that I wrote.  It just takes the USB vendor/device ID and looks that up
in the modules.alias file, and loads that module with modprobe.  So, I
can easily extend that to select the correct mac80211/cfg80211 set, and
make sure that's loaded first.

> compat.ko is not a glue it is more a module containing all the functions
> not available in the kernel comopat-drivers was compiled against, but
> needed by some drivers or frameworks like mac80211.

Thanks for the clarification.  At first, I thought the compat.ko module
was only for the individual wireless device drivers, not for the entire
mac80211/cfg80211 stack, now I know.

> You should take all wireless drivers using mac80211/cfg80211 from
> compat-drivers and not use the in kernel versions any more.

Unfortunately some of my drivers (such as vt6656 and rtl8712) are from
tarballs that come from the vendor, and they exist outside the kernel
directory, but use it as a reference when compiling for that kernel.
It's similar to how compat-drivers is built.  This means they don't see
each other, unfortunately, even though they are eventually being
compiled for the same kernel.  I could not find a way to make these
vendor tarballs compatible with compat-drivers, given this setup.

I wonder if the compat-drivers tree can be copied into the kernel
directory itself, to replace what's already there, so that I can build
the kernel and it would contain the compat-drivers flavor of
mac80211/cfg80211 instead of the original kernel flavor of
mac80211/cfg80211?  Then, I could compile the vendor tarballs against
that, which would seem to neatly solve my problem, if it were possible.
 Does compat-drivers have an option to integrate into the kernel build
instead of being compiled outside of it?

Josh Lehan
