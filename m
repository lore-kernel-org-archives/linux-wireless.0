Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:41020 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518Ab2EJOZw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 10:25:52 -0400
Received: by lbbgm6 with SMTP id gm6so1108238lbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 07:25:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAG9cJmkDf6koV93NyOo2W8D7Y3G6tapQOucjW5M7FLPDnNhvKQ@mail.gmail.com>
References: <CAG9cJmkDf6koV93NyOo2W8D7Y3G6tapQOucjW5M7FLPDnNhvKQ@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 11 May 2012 00:25:30 +1000
Message-ID: <CAGRGNgXDUuLFeKh7KgqMqyyT8Xi_GV2BReYJ66uK_SgBJ5Nb4g@mail.gmail.com> (sfid-20120510_162557_577162_9B79AF51)
Subject: Re: how to remove the b43
To: lina <lina.lastname@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Lina,

Firstly, which distribution are you using, is it Ubuntu? Debian? Suse?
Fedora? or something else?

On Thu, May 10, 2012 at 11:38 PM, lina <lina.lastname@gmail.com> wrote:
> Hi,
>
> I want to clear the
> b43-fwcutter-015
> broadcom-wl-*
> and all it related.

Ok, the first thing you need to understand is which files do what and
how they're related.

Broadcom wireless devices which are driven by the b43 driver have three "parts":

1. The driver in the kernel itself. This is called "b43". This
controls the hardware and provides an interface between the kernel
wireless code and the actual hardware.

2. The firmware, this lives in /lib/firmware or wherever your distro
puts it and are called ucode*.fw. The firmware is software which runs
on the actual wireless card and runs the hardware at a low level.

3. As broadcom has not distributed firmware for these devices in the
linux-firmware repository, a separate tool called b43-fwcutter is used
to extract the firmware from other Broadcom drivers.

> The reason I want to clear is that today I installed the kernel  3.3.5,
> but still keep the last version 3.2.5
>
> I want to clear the b43 related in 3.2.5, and re-install in 3.3.5

Ok, so part 1, the driver, is part of the kernel and will be upgraded
when you upgrade your kernel from version 3.2.5 to 3.3.5.

The firmware (part 2) and b43-fwcutter (part 3) do *not* depend on the
version of the kernel driver, and may safely be left alone when you
upgrade your kernel.

> Thanks ahead for your suggestions.
>
> P.S I have done some robust blind clear, but
> # lsmod
> Module                  Size  Used by
> b43                   353456  0
> mac80211              381396  1 b43
> cfg80211              178201  2 mac80211,b43
> pcmcia                 40801  2 ssb,b43
> pcmcia_core            18294  1 pcmcia
>
> seems I have removed the compact-wireless

Firstly it's 'compat-wireless' not 'compact-wireless'.

Secondly, deleting system files without knowing exactly what you're
doing is a _really_bad_ idea.

Thirdly, what precisely are you trying to do?

Are you:
1. Trying to use the stock driver in 3.3.5?
2. Trying to use the stock driver from 3.2.5?
3. Trying to use the driver in compat-wireless from a later kernel version?

If you are trying option 1, using the stock driver in 3.3.5, then you
should have to do _nothing_ other than upgrade the kernel. I strongly
recommend doing this unless you require some feature or bug fix that
is not present in kernel version 3.3.5. Your distribution should
provide a package for obtaining the firmware, I strongly recommend you
install it and _leave_it_alone_.

If you are trying option 2, using the stock driver from 3.2.5, then
you cannot upgrade your kernel as the driver from kernel version 3.2.5
_will_not_work_ with kernel version 3.3.5. Also, the driver in kernel
version 3.3.5 will have received many improvements over the version in
3.2.5 and as such, will perform better than the older version. I
_strongly_ recommend that you use the driver in kernel version 3.3.5.

If you are trying option 3, then you will need to re-compile whichever
version of compat-wireless you wish to use *every* time you upgrade
your kernel. Remember that the version of compat-wireless *must* be
greater than the version of your kernel. I recommend you do not use
compat-wireless unless you need some feature or bug fix that is not
present in your current kernel.

> Sorry I do really lack understanding about what's going on.

Yes, you really do.

May I strongly recommend you use the stock drivers that come with your
kernel and the firmware that comes with your distribution. You seem to
be very insistent on doing this yourself, and it is simply not
necessary.

Also, remember to use reply-all when replying.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
