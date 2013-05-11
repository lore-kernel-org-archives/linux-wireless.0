Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1639 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596Ab3EKHf0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 May 2013 03:35:26 -0400
Message-ID: <518DF4B1.3020706@broadcom.com> (sfid-20130511_093543_404629_38A61C4C)
Date: Sat, 11 May 2013 09:35:13 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "JoSH Lehan" <krellan@gmail.com>
cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: Re: Using compat-drivers conflicts with kernel mac80211 and
 cfg80211
References: <CALOB5QZCeC7OTqkw5go6E_KUajVe5GDuCsSsc68cpZqE2YVfRQ@mail.gmail.com>
In-Reply-To: <CALOB5QZCeC7OTqkw5go6E_KUajVe5GDuCsSsc68cpZqE2YVfRQ@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/11/2013 02:52 AM, JoSH Lehan wrote:
> It seems I can choose to use the mac80211/cfg80211 that came with the
> kernel,*or*, the mac80211/cfg80211 that come with compat-drivers.  Is
> this correct?  I'll have to maintain these two mac80211/cfg80211
> drivers in separate directories, since they have the same name, and it
> will complicate my detection/loading script, but if there's no other
> way, then this is what needs to be done.

Luis may correct me, but I think you are correct. compat-drivers 
provides a compat.ko which is the glue between new drivers and your 
kernel. With the new drivers you get new features provided you have new 
mac80211/cfg80211 as well. Hence the glue is between wireless modules 
(including mac80211/cfg80211) and rest of your kernel. On a non-embedded 
system the compat-driver modules are installed in a separate folder 
/lib/modules/<your_kernel_version/updates. depmod is run during the 
install in which this folder takes precedence.

Not sure what your use-case is. You have a system in which different 
wireless devices may be plugged in or ...?

> Could it be because I cross-compile compat-drivers?  Looking at the
> installation scripts, it's clearly intended to be ran by the end user
> to replace the drivers in their distribution with updated drivers, and
> it could be that I missed something when tweaking it to cross-compile
> the drivers and not install them locally.

Probably not, provided you build it for your kernel version.

> Has anybody else tried to use compat-drivers to build for an embedded
> system?  If so, what's the recommended solution?  How to solve the
> mac80211/cfg80211 problem, where the kernel-compiled mac80211/cfg80211
> modules conflict with their equivalent compat-drivers modules?

Depends what you call an embedded system. We used it to run our driver 
on Android. Just cross-compiling it and install it on the system is what 
we did. Recently, there have been a number of people walking that path 
and contacting us. It may be an idea to have a compat-drivers feature to 
generate Android tarballs as it is always running a few kernel versions 
behind mainline.

Regards,
Arend

