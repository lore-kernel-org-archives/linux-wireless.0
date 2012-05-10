Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:64326 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760008Ab2EJPd7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 11:33:59 -0400
Received: by qadb17 with SMTP id b17so446473qad.19
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 08:33:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGRGNgXQ3o-2bD9J+C2cAu9M-fo69tiXWfugZKjqU3o9ki7f7Q@mail.gmail.com>
References: <CAG9cJmkDf6koV93NyOo2W8D7Y3G6tapQOucjW5M7FLPDnNhvKQ@mail.gmail.com>
	<CAGRGNgXDUuLFeKh7KgqMqyyT8Xi_GV2BReYJ66uK_SgBJ5Nb4g@mail.gmail.com>
	<CAG9cJmmRZvf=EW9k6AVLEv_zeU86thGaEWHv5R0ADNX9B6jMmw@mail.gmail.com>
	<CAGRGNgXQ3o-2bD9J+C2cAu9M-fo69tiXWfugZKjqU3o9ki7f7Q@mail.gmail.com>
Date: Thu, 10 May 2012 23:33:58 +0800
Message-ID: <CAG9cJm=tJcOnbEfcxV7zyizbUEerO52+NdEGMN13Z0oGmu_2dg@mail.gmail.com> (sfid-20120510_173406_318425_BCF4C36D)
Subject: Re: how to remove the b43
From: lina <lina.lastname@gmail.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 10, 2012 at 11:25 PM, Julian Calaby <julian.calaby@gmail.com> wrote:
> Hi Lina,
>
> On Fri, May 11, 2012 at 1:00 AM, lina <lina.lastname@gmail.com> wrote:
>> On Thu, May 10, 2012 at 10:25 PM, Julian Calaby <julian.calaby@gmail.com> wrote:
>>> Hi Lina,
>>>
>>> Firstly, which distribution are you using, is it Ubuntu? Debian? Suse?
>>> Fedora? or something else?
>>
>> Debian,
>
> I use Debian too, if you're fully up-to-date, all you need to do is
> install these packages:
>

Thanks, I will install the linux-image-amd64.
suddenly all things become not so hard, seems.
I have spent whole day on it.
Before my fglrx-driver even lack the transplant.

> One of the linux-image-<arch> metapackages, e.g. linux-image-i686 or
> linux-image-amd64
> firmware-b43-installer
>
> Support for your card was included in 3.2, so you should have no
> problems using it with the stock Debian kernel.
>
> There is no need to compile your own kernel unless the stock kernel
> doesn't work on your system.
>
>>> 2. The firmware, this lives in /lib/firmware or wherever your distro
>>> puts it and are called ucode*.fw. The firmware is software which runs
>>> on the actual wireless card and runs the hardware at a low level.
>>
>> :/lib/firmware$  ls -1
>> 3.2.5mj-lina
>> 3.3.5
>> b43
>>
>> $ cd 3.3.5/
>> $ ls
>> 3com         bnx2   edgeport     korg         qlogic      ti_5052.fw
>>        yamaha
>> acenic       bnx2x  emi26        matrox       r128        tigon
>> adaptec      cis    emi62        mts_cdma.fw  radeon      ttusb-budget
>> advansys     cpia2  ess          mts_edge.fw  sun         whiteheat.fw
>> atmsar11.fw  cxgb3  kaweth       mts_gsm.fw   tehuti      whiteheat_loader.fw
>> av7110       e100   keyspan_pda  ositech      ti_3410.fw  yam
>>
>> another question, why I have so many things under /lib/firmware/3.3.5,
>
> These files are firmware for other devices, e.g. 3com network cards,
> qlogic SCSI cards, etc. I believe that they are all part of the
> standard linux-firmware package.
>
>>>> The reason I want to clear is that today I installed the kernel  3.3.5,
>>>> but still keep the last version 3.2.5
>>>>
>>>> I want to clear the b43 related in 3.2.5, and re-install in 3.3.5
>>>
>>> Ok, so part 1, the driver, is part of the kernel and will be upgraded
>>> when you upgrade your kernel from version 3.2.5 to 3.3.5.
>>
>> Ha ... I didn't upgrade. I just obtained from kernel.org, not from
>> debian repository.
>>
>> now kept two, is it redundant? maybe just in case.
>
> You should be fine just installing the kernel images that come with
> Debian. Unless you're having a problem with those packages, there is
> no need to build your own kernel.
>
>>> If you are trying option 1, using the stock driver in 3.3.5, then you
>>> should have to do _nothing_ other than upgrade the kernel. I strongly
>>> recommend doing this unless you require some feature or bug fix that
>>> is not present in kernel version 3.3.5. Your distribution should
>>> provide a package for obtaining the firmware, I strongly recommend you
>>> install it and _leave_it_alone_.
>>
>> Before strangly it not work in the 3.3.5, or maybe something not
>> activate in my network manager,
>
> If you had deleted the firmware before this, then that will be the
> reason why it is not working.
>
> Otherwise, it's likely that there are errors in the system log, if you
> post them here, we might be able to help you fix them.
>
>> so I came up the idea to remove the one in 3.2.5, I didn't realize
>> it's independent from kernel version until later.
>>
>> another reason to remove it from 3.2.5 is to reduce the chance of my /
>> get saturated. I only give  666M.
>
> I'm surprised you are managing to fit an entire Linux system in 666 MB.
>
> To re-iterate, I strongly recommend that you install the stock kernel
> that comes with Debian. There is no need to build your own unless
> there is a problem with that kernel.
>
> To get the firmware for your broadcom wireless card, just install the
> firmware-b43-installer package and this will automatically install and
> maintain the latest versions of the firmware for you.
>
> b43-fwcutter and the firmware itself are separate from the kernel and
> there is no need to delete them when upgrading.
>
> Thanks,

Best regards,
>
> --
> Julian Calaby
>
> Email: julian.calaby@gmail.com
> Profile: http://www.google.com/profiles/julian.calaby/
> .Plan: http://sites.google.com/site/juliancalaby/
