Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f182.google.com ([209.85.223.182]:38414 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757388Ab3KLWJf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Nov 2013 17:09:35 -0500
Received: by mail-ie0-f182.google.com with SMTP id e14so562580iej.41
        for <linux-wireless@vger.kernel.org>; Tue, 12 Nov 2013 14:09:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52828364.6080103@gmail.com>
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
 <CAErSpo77vnfRvEdgj470WWKo_8p8cv2xQUdaGQvvkY3tPBXzyQ@mail.gmail.com> <52828364.6080103@gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 12 Nov 2013 15:09:14 -0700
Message-ID: <CAErSpo6JdKgU0M-wu84_U2Hb4-4mdSr_V8f70Pi-ox8H45+Diw@mail.gmail.com> (sfid-20131112_230950_439051_2919591F)
Subject: Re: [Ilw] Intel Wireless 7260 hardware timed out randomly
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	wzyboy <wzyboy@wzyboy.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 12, 2013 at 12:37 PM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
> On 11/12/2013 09:14 PM, Bjorn Helgaas wrote:
>> On Tue, Nov 12, 2013 at 11:25 AM, Grumbach, Emmanuel
>> <emmanuel.grumbach@intel.com> wrote:
>>
>>> Right - I remember the discussion we had on that.
>>> On this device (7260 that has an issue with ASPM), we don't call pci_disable_link_state, because we know it is supposed to work...
>>
>> If ASPM is supposed to work as far as the hardware is concerned, I
>> guess you're saying this must be an iwlwifi driver issue.  Right?
>
> ASPM is supposed to work as far as the hardware is concerned.
> We might very well have an issue in iwlwifi - and I am checking this
> internally with our System guys.
> It can be a PCI core problem too, and it could also be a platform / BIOS
> / Lenovo issue.
> Of course, I have no clue which of these is the culprit here.
> Our System folks seemed to say that this new device uses L1 substates
> which can be enabled in Haswell platform which the user owns.
> Now - L1 substates is a new feature and might introduce issues
> (apparently) - and this is why they (System folks) wanted the try
> without L1 substates. But disabling L1 substates doesn't seem trivial
> with the production BIOS of Lenovo. So I am pretty stuck here.

For debugging purposes, we could configure L1 substates with setpci,
as we did for ASPM.  The Linux kernel knows nothing about L1
substates, so the PCI core isn't doing anything with them.  It's
possible the driver itself could muck with L1 substate configuration,
but that would be discouraged, and I don't see anything in iwlwifi
that is doing that.

The lspci output in
https://bugzilla.kernel.org/attachment.cgi?id=114061 shows an L1 PM
Substates extended capability (capability ID 0x1e) for the Root Port
leading to the 7260 device, but not for the 7260 device itself:

  00:1c.1 PCI bridge: Intel Corporation Lynx Point-LP PCI Express Root
Port 3 (rev e4) (prog-if 00 [Normal decode])
    Capabilities: [200 v1] #1e

Per sec 5.5.4 of the ECN for L1 PM Substates (15 Aug 2012), I think L1
substates must be configured on both ends of the link, and if the 7260
device doesn't have that capability, I don't see how it could be
enabled.

The lspci version wzyboy has doesn't decode the L1 PM Substates
capability, but there is a newer version at
git://git.kernel.org/pub/scm/utils/pciutils/pciutils.git that should
decode it.  Also, "lspci -vvxxx" didn't hexdump this capability, which
should be at offset 0x200.  Using "lspci -xxxx" (four "x"s) should
dump it, and we can decode it manually.

wzyboy, can you run these commands before the bug occurs and before
using the "setpci" workaround:

  lspci -vvxxxx -s00:1c.1
  lspci -vvxxxx -s03:00.0

Bjorn
