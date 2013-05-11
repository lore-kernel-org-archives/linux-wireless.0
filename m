Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:59544 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408Ab3EKWyw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 May 2013 18:54:52 -0400
Received: by mail-pa0-f48.google.com with SMTP id kp6so3713706pab.7
        for <linux-wireless@vger.kernel.org>; Sat, 11 May 2013 15:54:52 -0700 (PDT)
Message-ID: <518ECC39.9090401@gmail.com> (sfid-20130512_005511_407072_0FC5F863)
Date: Sat, 11 May 2013 15:54:49 -0700
From: JoSH Lehan <krellan@gmail.com>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: Re: Using compat-drivers conflicts with kernel mac80211 and cfg80211
References: <CALOB5QZCeC7OTqkw5go6E_KUajVe5GDuCsSsc68cpZqE2YVfRQ@mail.gmail.com> <518DF4B1.3020706@broadcom.com>
In-Reply-To: <518DF4B1.3020706@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/11/2013 12:35 AM, Arend van Spriel wrote:
> On 05/11/2013 02:52 AM, JoSH Lehan wrote:
> Luis may correct me, but I think you are correct. compat-drivers
> provides a compat.ko which is the glue between new drivers and your
> kernel. With the new drivers you get new features provided you have new
> mac80211/cfg80211 as well. Hence the glue is between wireless modules
> (including mac80211/cfg80211) and rest of your kernel. On a non-embedded
> system the compat-driver modules are installed in a separate folder
> /lib/modules/<your_kernel_version/updates. depmod is run during the
> install in which this folder takes precedence.

Thanks!  So, I'll need to maintain two sets of mac80211/cfg80211
modules: one for drivers that were compiled along with the kernel, and
another for drivers that were compiled as part of the compat-drivers
package.

> Not sure what your use-case is. You have a system in which different
> wireless devices may be plugged in or ...?

Yes.  It's an embedded system, however, it has an exposed USB port and
the user is free (within reason) to plug in a USB device.  I'm trying to
add support for as many USB wireless adapters that I can find.  For some
adapters (such as vt6656 and rtl8712), I use the vendor's tarball (which
compiles directly against the kernel).  So, this is why I need to mix
and match drivers compiled against the kernel's mac80211/cfg80211 with
drivers compiled against the mac80211/cfg80211 from compat.

> Probably not, provided you build it for your kernel version.

Thanks.  Everything's being built for the same version, which is good.
It all compiles and loads OK.  The problem is when the drivers are
actually used, then they oops.

> Depends what you call an embedded system. We used it to run our driver
> on Android. Just cross-compiling it and install it on the system is what
> we did. Recently, there have been a number of people walking that path
> and contacting us. It may be an idea to have a compat-drivers feature to
> generate Android tarballs as it is always running a few kernel versions
> behind mainline.

I'm just running the upstream Linux from kernel.org, not Android.  Good
to see you supporting Android, though.  Thanks for your help!

Josh Lehan
