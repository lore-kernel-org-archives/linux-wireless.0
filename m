Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:38713 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504Ab3KHRUr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Nov 2013 12:20:47 -0500
Received: by mail-ie0-f173.google.com with SMTP id x13so1126888ief.32
        for <linux-wireless@vger.kernel.org>; Fri, 08 Nov 2013 09:20:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALkVjQaHYpR4Tifbt7nh4VeQSrOz5J-xxSrUBKX2kXCZcvkivA@mail.gmail.com>
References: <5276134B.8070808@wzyboy.org> <CALkVjQYh-SUte4S6LdqOc3KSc3_pDU6jz1KXp+Jsd5_RFPXSqA@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301DE8338@HASMSX103.ger.corp.intel.com>
 <CALkVjQb7fCMFpqhdUs8w-Mx_Y0RtAYYFtKxXkqyrCQ39UFGxKg@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301DE960E@HASMSX103.ger.corp.intel.com>
 <CALkVjQbW8FeiEh8pBZ=KQFD9+8AdjgT0G_RG7qJe0MRdBvMD-A@mail.gmail.com>
 <CALkVjQaLx2spaOqUPcs_EwMkU7npMki1Reo1MeZwxB7m=c24=g@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301DE9FC6@HASMSX103.ger.corp.intel.com>
 <CALkVjQZDNSgUUFyi94Y8da_NDzW61rCvaMrZpUugFKW_LRNFFA@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301DEA052@HASMSX103.ger.corp.intel.com>
 <CALkVjQZRJw7ghjBa1aPKNKe3Zj2B1Mhk5bWVaRdcCYzfoLRovg@mail.gmail.com>
 <CALkVjQY7r=YKhsgDKR0mnYVtZy5BAdj83nY2jL0VFaiew6ha7A@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301DEA097@HASMSX103.ger.corp.intel.com>
 <CALkVjQY7uRFQ3Qs9T_bgqnYRNcWgsk5gfd=R8RfGFxOdDpFYTQ@mail.gmail.com>
 <527A8166.6000701@gmail.com> <CAErSpo5H9Mf-xmdzThudNO2WHAOt-1T7CQZvgGUmK4jm7_zf+g@mail.gmail.com>
 <CALkVjQaHYpR4Tifbt7nh4VeQSrOz5J-xxSrUBKX2kXCZcvkivA@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 8 Nov 2013 10:20:27 -0700
Message-ID: <CAErSpo5dX=cPdThxi-ok=B4beo_jPv2n2n0C1u4UyZMbQDMxqg@mail.gmail.com> (sfid-20131108_182054_162377_436DD272)
Subject: Re: [Ilw] Intel Wireless 7260 hardware timed out randomly
To: wzyboy <wzyboy@wzyboy.org>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 6, 2013 at 9:49 PM, wzyboy <wzyboy@wzyboy.org> wrote:
> 2013/11/7 Bjorn Helgaas <bhelgaas@google.com>:
>> Do you have any more details?  Maybe open a bugzilla.kernel.org report
>> and attach:
>>
>>   - complete dmesg log
>>   - lspci -vvxxx output for entire system before issue occurs
>>   - lspci -vvxxx output for entire system after issue occurs
>
>
> Hi, I have filed a bug on bugzilla:
> https://bugzilla.kernel.org/show_bug.cgi?id=64541
>
> Actually I have posted some more logs before, you could find them on
> the mailing lists archive:
> http://thread.gmane.org/gmane.linux.kernel.wireless.general/115259
>
> Here is the output of lspci -vxxxx just now. I'll run this command
> again when the bug occurs next time:

Thanks.  But can you please attach the output of "lspci -vvxxx" (not
"-vxxxx") for the entire system before the problem occurs?  All the
info is in the "-xxxx" output, but it's really painful to decode it
all by hand.  Using "-vv" will decode the PCIe Capability structures
where the ASPM configuration is.  And the entire system is
interesting, because ASPM requires configuration on upstream bridges
as well as on the device itself.

My only guess is that there's something wrong with the ASPM
configuration and the device just stops responding to config accesses
(and probably MMIO accesses, too, based on the errors in your dmesg
log).  Or maybe the device got powered off somehow.

Bjorn
