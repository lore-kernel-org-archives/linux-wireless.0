Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:55597 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757333Ab2EJPAD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 11:00:03 -0400
Received: by qcro28 with SMTP id o28so1178425qcr.19
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 08:00:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGRGNgXDUuLFeKh7KgqMqyyT8Xi_GV2BReYJ66uK_SgBJ5Nb4g@mail.gmail.com>
References: <CAG9cJmkDf6koV93NyOo2W8D7Y3G6tapQOucjW5M7FLPDnNhvKQ@mail.gmail.com>
	<CAGRGNgXDUuLFeKh7KgqMqyyT8Xi_GV2BReYJ66uK_SgBJ5Nb4g@mail.gmail.com>
Date: Thu, 10 May 2012 23:00:02 +0800
Message-ID: <CAG9cJmmRZvf=EW9k6AVLEv_zeU86thGaEWHv5R0ADNX9B6jMmw@mail.gmail.com> (sfid-20120510_170010_436904_03FD8660)
Subject: Re: how to remove the b43
From: lina <lina.lastname@gmail.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 10, 2012 at 10:25 PM, Julian Calaby <julian.calaby@gmail.com> wrote:
> Hi Lina,
>
> Firstly, which distribution are you using, is it Ubuntu? Debian? Suse?
> Fedora? or something else?

Debian,

The going-to-be-retired kernel version 3.2.5

Recently I forget to follow up, does it still need the compat-wireless
in 3.3.5 for
03:00.0 Network controller: Broadcom Corporation BCM4331 802.11a/b/g/n (rev 02)

>
> On Thu, May 10, 2012 at 11:38 PM, lina <lina.lastname@gmail.com> wrote:
>> Hi,
>>
>> I want to clear the
>> b43-fwcutter-015
>> broadcom-wl-*
>> and all it related.
>
> Ok, the first thing you need to understand is which files do what and
> how they're related.
>
> Broadcom wireless devices which are driven by the b43 driver have three "parts":
>
> 1. The driver in the kernel itself. This is called "b43". This
> controls the hardware and provides an interface between the kernel
> wireless code and the actual hardware.

I compared what under the
/lib/modules/3.3.5/kernel/drivers/net/wireless/
form the time-stamp, I notice the b43 was installed at the same time
with kernel,

Thanks for confirming me that the b43 driver is in kernel itself.
>
> 2. The firmware, this lives in /lib/firmware or wherever your distro
> puts it and are called ucode*.fw. The firmware is software which runs
> on the actual wireless card and runs the hardware at a low level.

:/lib/firmware$  ls -1
3.2.5mj-lina
3.3.5
b43

$ cd 3.3.5/
$ ls
3com         bnx2   edgeport     korg         qlogic      ti_5052.fw
        yamaha
acenic       bnx2x  emi26        matrox       r128        tigon
adaptec      cis    emi62        mts_cdma.fw  radeon      ttusb-budget
advansys     cpia2  ess          mts_edge.fw  sun         whiteheat.fw
atmsar11.fw  cxgb3  kaweth       mts_gsm.fw   tehuti      whiteheat_loader.fw
av7110       e100   keyspan_pda  ositech      ti_3410.fw  yam

another question, why I have so many things under /lib/firmware/3.3.5,

Did I build a heavy kernel, what does those firmware for? are they for
some other type of firmware?

Thanks ahead,

>
> 3. As broadcom has not distributed firmware for these devices in the
> linux-firmware repository, a separate tool called b43-fwcutter is used
> to extract the firmware from other Broadcom drivers.
I start to understand now.
trying hard to get the meaning of the firmware, can guess now, still
lack a strong sense of what it is though.
Thanks for your explaination.
>
>> The reason I want to clear is that today I installed the kernel  3.3.5,
>> but still keep the last version 3.2.5
>>
>> I want to clear the b43 related in 3.2.5, and re-install in 3.3.5
>
> Ok, so part 1, the driver, is part of the kernel and will be upgraded
> when you upgrade your kernel from version 3.2.5 to 3.3.5.

Ha ... I didn't upgrade. I just obtained from kernel.org, not from
debian repository.

now kept two, is it redundant? maybe just in case.
>
> The firmware (part 2) and b43-fwcutter (part 3) do *not* depend on the
> version of the kernel driver, and may safely be left alone when you
> upgrade your kernel.
>
>> Thanks ahead for your suggestions.
>>
>> P.S I have done some robust blind clear, but
>> # lsmod
>> Module                  Size  Used by
>> b43                   353456  0
>> mac80211              381396  1 b43
>> cfg80211              178201  2 mac80211,b43
>> pcmcia                 40801  2 ssb,b43
>> pcmcia_core            18294  1 pcmcia
>>
>> seems I have removed the compact-wireless
>
> Firstly it's 'compat-wireless' not 'compact-wireless'.

^_^.  I did lack of understanding.

>
> Secondly, deleting system files without knowing exactly what you're
> doing is a _really_bad_ idea.
>
> Thirdly, what precisely are you trying to do?
>
> Are you:
> 1. Trying to use the stock driver in 3.3.5?
in 3.3.5
> 2. Trying to use the stock driver from 3.2.5?
keep it as plan C or D, in case I have problem or mess up something in
future, so I can ...
> 3. Trying to use the driver in compat-wireless from a later kernel version?

Can I ?  I don't know the latest progress in this area, no need the
compat-wireless support in latest kernel version?

>
> If you are trying option 1, using the stock driver in 3.3.5, then you
> should have to do _nothing_ other than upgrade the kernel. I strongly
> recommend doing this unless you require some feature or bug fix that
> is not present in kernel version 3.3.5. Your distribution should
> provide a package for obtaining the firmware, I strongly recommend you
> install it and _leave_it_alone_.

Before strangly it not work in the 3.3.5, or maybe something not
activate in my network manager,

so I came up the idea to remove the one in 3.2.5, I didn't realize
it's independent from kernel version until later.

another reason to remove it from 3.2.5 is to reduce the chance of my /
get saturated. I only give  666M.

>
> If you are trying option 2, using the stock driver from 3.2.5, then
> you cannot upgrade your kernel as the driver from kernel version 3.2.5
> _will_not_work_ with kernel version 3.3.5. Also, the driver in kernel
> version 3.3.5 will have received many improvements over the version in
> 3.2.5 and as such, will perform better than the older version. I
> _strongly_ recommend that you use the driver in kernel version 3.3.5.

Thanks, I will.
>
> If you are trying option 3, then you will need to re-compile whichever
> version of compat-wireless you wish to use *every* time you upgrade
> your kernel. Remember that the version of compat-wireless *must* be
> greater than the version of your kernel. I recommend you do not use
> compat-wireless unless you need some feature or bug fix that is not
> present in your current kernel.
>
>> Sorry I do really lack understanding about what's going on.
>
> Yes, you really do.
Now better. haha ...
>
> May I strongly recommend you use the stock drivers that come with your
> kernel and the firmware that comes with your distribution. You seem to
> be very insistent on doing this yourself, and it is simply not
> necessary.
>
> Also, remember to use reply-all when replying.

Yes. Thanks Julian,
>
> Thanks,
>
> --
> Julian Calaby
>
> Email: julian.calaby@gmail.com
> Profile: http://www.google.com/profiles/julian.calaby/
> .Plan: http://sites.google.com/site/juliancalaby/
