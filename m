Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:59330 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616Ab3KLSOv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Nov 2013 13:14:51 -0500
Received: by mail-ie0-f172.google.com with SMTP id to1so4481340ieb.31
        for <linux-wireless@vger.kernel.org>; Tue, 12 Nov 2013 10:14:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB301DF044C@HASMSX103.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB301DEA052@HASMSX103.ger.corp.intel.com>
 <CALkVjQZRJw7ghjBa1aPKNKe3Zj2B1Mhk5bWVaRdcCYzfoLRovg@mail.gmail.com>
 <CALkVjQY7r=YKhsgDKR0mnYVtZy5BAdj83nY2jL0VFaiew6ha7A@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301DEA097@HASMSX103.ger.corp.intel.com>
 <CALkVjQY7uRFQ3Qs9T_bgqnYRNcWgsk5gfd=R8RfGFxOdDpFYTQ@mail.gmail.com>
 <527A8166.6000701@gmail.com> <CAErSpo5H9Mf-xmdzThudNO2WHAOt-1T7CQZvgGUmK4jm7_zf+g@mail.gmail.com>
 <CALkVjQaHYpR4Tifbt7nh4VeQSrOz5J-xxSrUBKX2kXCZcvkivA@mail.gmail.com>
 <CAErSpo5dX=cPdThxi-ok=B4beo_jPv2n2n0C1u4UyZMbQDMxqg@mail.gmail.com>
 <CALkVjQYkAWrwRabQfBSvC1pm47ZyRT5jQ0mYBwbiGh-Bt29gbg@mail.gmail.com>
 <20131111224439.GA30638@google.com> <CALkVjQb-AJRSGARCQaDFkd+mHBk2qFkAVyVBTW7RHSaxzbZsbw@mail.gmail.com>
 <CALkVjQaXEBpbwu9Qy3+17Eg-nSg-k7iin8G3f1RsTLkCOB-2XQ@mail.gmail.com> <0BA3FCBA62E2DC44AF3030971E174FB301DF044C@HASMSX103.ger.corp.intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 12 Nov 2013 11:14:31 -0700
Message-ID: <CAErSpo5iU15AoSVL9WmLp4gNCiNmt6pFZuTsd-Vui4SCrSc_Hw@mail.gmail.com> (sfid-20131112_191456_390734_10477412)
Subject: Re: [Ilw] Intel Wireless 7260 hardware timed out randomly
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: wzyboy <wzyboy@wzyboy.org>,
	Emmanuel Grumbach <egrumbach@gmail.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 12, 2013 at 5:16 AM, Grumbach, Emmanuel
<emmanuel.grumbach@intel.com> wrote:
>>
>> 2013/11/12 wzyboy <wzyboy@wzyboy.org>:
>> > I will continue downloading big files to benchmark it.
>>
>> Hi guys, good news!
>>
>> Six hours ago I ran a simple loop script to repeatly download big files (and
>> saving to /dev/null) and went to have lessons. Six hours later it's after school.
>> I found that the wireless still works!
>>
>> So I believe that the two "setpci" commands really work! Thanks Bjorn and
>> Emmanuel!
>
> Well... I haven't done much, but the setpci isn't really a solution - it is more a work around.
> Bjorn is basically disabling L1 PCIe feature which allows to save power. While you might not care, I do :)
> The HW folks here would still want to know if you can disable L1 substates feature (not that I know what it is - but I can guess).
> If you can try to:
>  * upgrade your BIOS (if needed)
>  * check the advanced options I sent to you to see if you can unlock the advanced menu in your BIOS
>
> it'd help me to understand the issue.
> In any case, I am happy that you have a way to reliably use your NIC now.

The setpci experiment was only for debugging.  Obviously it's not a
real fix, and it doesn't help any other users of this ThinkPad X240s.
But it does seem clear that the problem is related to ASPM.

And it looks like the same thing we investigated here:
https://bugzilla.kernel.org/show_bug.cgi?id=57331, which is even on
the same device.

>From your dmesg logs:

  ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
  acpi PNP0A08:00: ACPI _OSC control for PCIe not granted, disabling ASPM

The messages are misleading.  Linux does not actually disable ASPM as
you did with setpci.  All Linux does is leave the current ASPM
configuration untouched, because we believe that the BIOS is managing
it.  The BIOS must have enabled ASPM on this device (you could verify
this by booting with "pci=earlydump"), and BIOS also says the OS must
not enable ASPM control (via the ACPI FADT table and the PCI host
bridge _OSC method).

It would really help if you still had Windows on this system, and we
could look and see whether it disables ASPM for this device (if
anybody does have Windows, I would probably use AIDA64 to dump the PCI
config space).  I did experiments for bug 57331 that suggested that
Windows leaves ASPM alone just like Linux does, but my experiments
were on qemu, not on real hardware, and I didn't have an Intel wifi
device.

If the Windows driver works fine even with ASPM enabled, that would
suggest that the problem is something in the Linux iwlwifi driver.  If
Windows does actually disable ASPM on this device, then we would have
to figure out if there's a way we can safely make Linux also disable
ASPM.

Bjorn
