Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:35577 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab3KFSdR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 13:33:17 -0500
Received: by mail-ie0-f170.google.com with SMTP id at1so18382898iec.15
        for <linux-wireless@vger.kernel.org>; Wed, 06 Nov 2013 10:33:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <527A8166.6000701@gmail.com>
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
 <CALkVjQY7uRFQ3Qs9T_bgqnYRNcWgsk5gfd=R8RfGFxOdDpFYTQ@mail.gmail.com> <527A8166.6000701@gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 6 Nov 2013 11:32:56 -0700
Message-ID: <CAErSpo5H9Mf-xmdzThudNO2WHAOt-1T7CQZvgGUmK4jm7_zf+g@mail.gmail.com> (sfid-20131106_193321_190962_413AC257)
Subject: Re: [Ilw] Intel Wireless 7260 hardware timed out randomly
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: wzyboy <wzyboy@wzyboy.org>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 6, 2013 at 10:50 AM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
> Hi,
>
> adding PCI folks.
> Here is the story:
>
> * Wzyboy has a Lenovo laptop with _OSC control *not* granted
> * L1 Active is enabled
> * kernel: 3.12.0
> * Nic is PCIe (Gen2 but not sure...)
>
> At some random point, the driver loses access to the NIC: all readl
> operation return 0xff.
> Even lspci returns 0xff:
>
> 03:00.0 Network controller: Intel Corporation Wireless 7260 (rev ff)
> 00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>
> here is the output of lspci *before* the issue hits:
>
> 03:00.0 Network controller: Intel Corporation Wireless 7260 (rev 6b)
> 00: 86 80 b2 08 06 04 10 00 6b 00 80 02 10 00 00 00
> 10: 04 00 40 f0 00 00 00 00 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 62 c2
> 30: 00 00 00 00 c8 00 00 00 00 00 00 00 09 01 00 00
>
> have you any idea of what we can do to understand what it going wrong here?

Do you have any more details?  Maybe open a bugzilla.kernel.org report
and attach:

  - complete dmesg log
  - lspci -vvxxx output for entire system before issue occurs
  - lspci -vvxxx output for entire system after issue occurs

Bjorn

> On 11/06/2013 09:12 AM, wzyboy wrote:
>> 2013/11/6 Grumbach, Emmanuel <emmanuel.grumbach@intel.com>:
>>> Wait - you mean that after the bug occurred before you rebooted, lspci -xxx show all 00?
>>> I can see 0xff here.
>>> Anyway - this is very bad... checking with HW guys...
>>
>>
>> Sorry, that's my typo. They are all 0xff... (I don't know what do they
>> mean but it look bad...)
>>
>> Thanks for your effort! I'm waiting for good news from you and HW guys. :-)
>>
