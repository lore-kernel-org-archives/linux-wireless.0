Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:34596 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab3KMRm7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Nov 2013 12:42:59 -0500
Received: by mail-ie0-f169.google.com with SMTP id tp5so1005234ieb.14
        for <linux-wireless@vger.kernel.org>; Wed, 13 Nov 2013 09:42:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALkVjQZZVHUxuBkS+ret23Bt61TV_x_kj-ey=y93gC0e3cw__Q@mail.gmail.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB301DEA052@HASMSX103.ger.corp.intel.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301DEA097@HASMSX103.ger.corp.intel.com>
 <CALkVjQY7uRFQ3Qs9T_bgqnYRNcWgsk5gfd=R8RfGFxOdDpFYTQ@mail.gmail.com>
 <527A8166.6000701@gmail.com> <CAErSpo5H9Mf-xmdzThudNO2WHAOt-1T7CQZvgGUmK4jm7_zf+g@mail.gmail.com>
 <CALkVjQaHYpR4Tifbt7nh4VeQSrOz5J-xxSrUBKX2kXCZcvkivA@mail.gmail.com>
 <CAErSpo5dX=cPdThxi-ok=B4beo_jPv2n2n0C1u4UyZMbQDMxqg@mail.gmail.com>
 <CALkVjQYkAWrwRabQfBSvC1pm47ZyRT5jQ0mYBwbiGh-Bt29gbg@mail.gmail.com>
 <20131111224439.GA30638@google.com> <CALkVjQb-AJRSGARCQaDFkd+mHBk2qFkAVyVBTW7RHSaxzbZsbw@mail.gmail.com>
 <CALkVjQaXEBpbwu9Qy3+17Eg-nSg-k7iin8G3f1RsTLkCOB-2XQ@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301DF044C@HASMSX103.ger.corp.intel.com>
 <CAErSpo5iU15AoSVL9WmLp4gNCiNmt6pFZuTsd-Vui4SCrSc_Hw@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301DF0865@HASMSX103.ger.corp.intel.com>
 <CAErSpo77vnfRvEdgj470WWKo_8p8cv2xQUdaGQvvkY3tPBXzyQ@mail.gmail.com>
 <52828364.6080103@gmail.com> <CAErSpo6JdKgU0M-wu84_U2Hb4-4mdSr_V8f70Pi-ox8H45+Diw@mail.gmail.com>
 <CALkVjQZZVHUxuBkS+ret23Bt61TV_x_kj-ey=y93gC0e3cw__Q@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 13 Nov 2013 10:42:37 -0700
Message-ID: <CAErSpo6xCUDqfvKB66nZJYBOWnZLEcSJ39+aTGnKKnuZP6+dRQ@mail.gmail.com> (sfid-20131113_184305_478038_4EC3BDFA)
Subject: Re: [Ilw] Intel Wireless 7260 hardware timed out randomly
To: wzyboy <wzyboy@wzyboy.org>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	=?ISO-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[+cc Bjørn]

On Tue, Nov 12, 2013 at 10:39 PM, wzyboy <wzyboy@wzyboy.org> wrote:
> 2013/11/13 Bjorn Helgaas <bhelgaas@google.com>:
>> wzyboy, can you run these commands before the bug occurs and before
>> using the "setpci" workaround:
>>
>>   lspci -vvxxxx -s00:1c.1
>>   lspci -vvxxxx -s03:00.0
>
> After today's morning lessons I booted up my laptop with pci=earlydump
> kernel perameter and here are the output of lspci (without setpci and
> before bug hit) and dmesg.

Thanks.  Are you 100% sure the lspci output is before the setpci
workaround?  The dmesg earlydump shows this (the ASPM control bits are
in the 16-bit Link Control register, which is at 0x50 for both
devices):

    00:1c.1 Root Port config
         50: 42 00 11 70 00 b2 14 00 00 00 40 01 00 00 00 00
    03:00.0 Intel 7260 config:
         50: 42 01 11 10 00 00 00 00 00 00 00 00 00 00 00 00

So at boot-time, ASPM was enabled.  But the lspci shows:

    00:1c.1 Root Port config
      Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
        LnkCtl: ASPM Disabled
         50: 40 00 11 70 00 b2 14 00 00 00 40 01 00 00 00 00
    03:00.0 Intel 7620 config
      Capabilities: [40] Express (v2) Endpoint, MSI 00
        LnkCtl: ASPM Disabled
         50: 40 01 11 10 00 00 00 00 00 00 00 00 00 00 00 00

And now ASPM is disabled.  I'm pretty sure the kernel did not disable
ASPM, so I assume it was disabled by setpci.

I manually decoded the L1 PM Substates registers for both the Root
Port and the 7260 device (details appended below), and everything
appears enabled there (though I think that since ASPM is disabled, L1
PM substates is ignored).

My conclusion is that the BIOS enabled both ASPM and L1 PM substates.
Obviously the BIOS will do the same when booting Windows, and I assume
the device works fine with the Windows driver.  Based on our previous
experience with Windows, I don't think it will change the ASPM
configuration because the ACPI FADT table and the PCI _OSC method do
not grant control of ASPM to the OS.  Therefore, I think the problem
is in the Linux iwlwifi driver.

I don't think there's anything more I can do here because there's no
evidence that the PCI core is doing anything wrong.  But if it turns
out that we *should* be doing something differently, let me know.

Bjorn


    00:1c.1 Root Port config
      Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
        LnkCtl: ASPM Disabled
         50: 40 00 11 70 00 b2 14 00 00 00 40 01 00 00 00 00
      Capabilities: [200 v1] #1e
        200: 1e 00 01 00 1f 28 28 00 1f 28 a0 40 f0 00 00 00
        210: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
          Header                        0x0001001e
            ID 0x001e (L1 Substates)
            Version 1
          Capabilities                  0x0028281f
          Control 1                     0x40a0281f
            0x40a0281f  Control 1
            0x00000001    PCI-PM L1.2 Enable
            0x00000002    PCI-PM L1.1 Enable
            0x00000004    ASPM L1.2 Enable
            0x00000008    ASPM L1.1 Enable
            0x00000010    RsvdP
            0x00002800    Common_Mode_Restore_Time
            0x00a00000    LTR_L1.2_THRESHOLD_Value
            0x40000000    LTR_L1.2_THRESHOLD_Scale
          Control 2                     0x000000f0
            0x000000f0  Control 2
            0x000000f0    T_POWER_ON Value

    03:00.0 Intel 7620 config
      Capabilities: [40] Express (v2) Endpoint, MSI 00
        LnkCtl: ASPM Disabled
         50: 40 01 11 10 00 00 00 00 00 00 00 00 00 00 00 00
      Capabilities: [154 v1] Vendor Specific Information: ID=cafe
Rev=1 Len=014 <?>
        150:             0b 00 01 00 fe ca 41 01 1f 1e f0 00
        160: 0f 00 a0 40 f0 00 00 00 00 00 00 00 00 00 00 00
          Header                        0x0001000b
            ID 0x000b (Vendor-specific)
            Version 1
          Vendor-specific header        0x0141cafe
            VSEC ID 0xcafe
            VSEC Rev 1
            Length 0x14
          Capabilities                  0x00f01e1f
          Control 1                     0x40a0000f
            0x40a0000f  Control 1
            0x00000001    PCI-PM L1.2 Enable
            0x00000002    PCI-PM L1.1 Enable
            0x00000004    ASPM L1.2 Enable
            0x00000008    ASPM L1.1 Enable
          Control 2                     0x000000f0
