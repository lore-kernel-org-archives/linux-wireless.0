Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:33115 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758414Ab3KMMNg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Nov 2013 07:13:36 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>
CC: wzyboy <wzyboy@wzyboy.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: RE: [Ilw] Intel Wireless 7260 hardware timed out randomly
Date: Wed, 13 Nov 2013 12:13:31 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB301E00262@HASMSX103.ger.corp.intel.com> (sfid-20131113_131341_417897_A8E5995B)
References: <0BA3FCBA62E2DC44AF3030971E174FB301DEA052@HASMSX103.ger.corp.intel.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301DEA097@HASMSX103.ger.corp.intel.com>
 <CALkVjQY7uRFQ3Qs9T_bgqnYRNcWgsk5gfd=R8RfGFxOdDpFYTQ@mail.gmail.com>
 <527A8166.6000701@gmail.com>
 <CAErSpo5H9Mf-xmdzThudNO2WHAOt-1T7CQZvgGUmK4jm7_zf+g@mail.gmail.com>
 <CALkVjQaHYpR4Tifbt7nh4VeQSrOz5J-xxSrUBKX2kXCZcvkivA@mail.gmail.com>
 <CAErSpo5dX=cPdThxi-ok=B4beo_jPv2n2n0C1u4UyZMbQDMxqg@mail.gmail.com>
 <CALkVjQYkAWrwRabQfBSvC1pm47ZyRT5jQ0mYBwbiGh-Bt29gbg@mail.gmail.com>
 <20131111224439.GA30638@google.com>
 <CALkVjQb-AJRSGARCQaDFkd+mHBk2qFkAVyVBTW7RHSaxzbZsbw@mail.gmail.com>
 <CALkVjQaXEBpbwu9Qy3+17Eg-nSg-k7iin8G3f1RsTLkCOB-2XQ@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301DF044C@HASMSX103.ger.corp.intel.com>
 <CAErSpo5iU15AoSVL9WmLp4gNCiNmt6pFZuTsd-Vui4SCrSc_Hw@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301DF0865@HASMSX103.ger.corp.intel.com>
 <CAErSpo77vnfRvEdgj470WWKo_8p8cv2xQUdaGQvvkY3tPBXzyQ@mail.gmail.com>
 <52828364.6080103@gmail.com>
 <CAErSpo6JdKgU0M-wu84_U2Hb4-4mdSr_V8f70Pi-ox8H45+Diw@mail.gmail.com>  
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > > On Tue, Nov 12, 2013 at 12:37 PM, Emmanuel Grumbach
> > > <egrumbach@gmail.com> wrote:
> > > > On 11/12/2013 09:14 PM, Bjorn Helgaas wrote:
> > > >> On Tue, Nov 12, 2013 at 11:25 AM, Grumbach, Emmanuel
> > > >> <emmanuel.grumbach@intel.com> wrote:
> > > >>
> > > >>> Right - I remember the discussion we had on that.
> > > >>> On this device (7260 that has an issue with ASPM), we don't call
> > > pci_disable_link_state, because we know it is supposed to work...
> > > >>
> > > >> If ASPM is supposed to work as far as the hardware is concerned,
> > > >> I guess you're saying this must be an iwlwifi driver issue.  Right?
> > > >
> > > > ASPM is supposed to work as far as the hardware is concerned.
> > > > We might very well have an issue in iwlwifi - and I am checking
> > > > this internally with our System guys.
> > > > It can be a PCI core problem too, and it could also be a platform
> > > > / BIOS / Lenovo issue.
> > > > Of course, I have no clue which of these is the culprit here.
> > > > Our System folks seemed to say that this new device uses L1
> > > > substates which can be enabled in Haswell platform which the user
> owns.
> > > > Now - L1 substates is a new feature and might introduce issues
> > > > (apparently) - and this is why they (System folks) wanted the try
> > > > without L1 substates. But disabling L1 substates doesn't seem
> > > > trivial with the production BIOS of Lenovo. So I am pretty stuck here.
> > >
> > > For debugging purposes, we could configure L1 substates with setpci,
> > > as we did for ASPM.  The Linux kernel knows nothing about L1
> > > substates, so the PCI core isn't doing anything with them.  It's
> > > possible the driver itself could muck with L1 substate
> > > configuration, but that would be discouraged, and I don't see
> > > anything in iwlwifi that is
> > doing that.
> > >
> > > The lspci output in
> > > https://bugzilla.kernel.org/attachment.cgi?id=114061 shows an L1 PM
> > > Substates extended capability (capability ID 0x1e) for the Root Port
> > > leading to the 7260 device, but not for the 7260 device itself:
> > >
> > >   00:1c.1 PCI bridge: Intel Corporation Lynx Point-LP PCI Express
> > > Root Port 3 (rev e4) (prog-if 00 [Normal decode])
> > >     Capabilities: [200 v1] #1e
> > >
> > > Per sec 5.5.4 of the ECN for L1 PM Substates (15 Aug 2012), I think
> > > L1 substates must be configured on both ends of the link, and if the
> > > 7260 device doesn't have that capability, I don't see how it could be
> enabled.
> >
> > Makes sense.
> >
> > >
> > > The lspci version wzyboy has doesn't decode the L1 PM Substates
> > > capability, but there is a newer version at
> > > git://git.kernel.org/pub/scm/utils/pciutils/pciutils.git that should decode
> it.
> > > Also, "lspci -vvxxx" didn't hexdump this capability, which should be
> > > at offset 0x200.  Using "lspci -xxxx" (four "x"s) should dump it,
> > > and we can decode it manually.
> > >
> >
> > You can find this in
> > http://permalink.gmane.org/gmane.linux.kernel.wireless.general/115378.
> >
> > Somehow my System team says that it should be at offset 0x160?
> > Is it possible that there is a "walk algorithm" with pointers just
> > like for the ASPM register?
> > I'll try to check the PCI spec when I'll find the time for that.
> 
> So I read a bit the lspci code, and it looks that there are plenty of pointers
> inside the config space. Fun :) So basically, since:
> #define PCI_EXT_CAP_ID_L1PM        0x1e
> This means that I need to find an 0x1e in the output of wzyboy's lspci. I found
> only one: at offset 0x15d.
> Should that mean that my System team was right when they asked for offset
> 0x160 which is 3 bytes afterwards (and matches more the less the code of
> lspci)?
> If so,
> 160: 0f 00 a0 40 f0 00 00 00 00 00 00 00 00 00 00 00 seems to say that it is
> enabled?
> 
> OTOH, 0x15d is 0x1e and not 0x001e as required by PCI-SIG ECN? Me scraping
> my head.

Ok - so I have now the complete picture.
This device was designed before PCI-SIG gave an ID to L1 PM Substates, so Intel had to use the L1 PM Substate as a Vendor Define whose ID is 0xCAFE. Layout is the same as defined now in PCI-SIG (page 21 in http://www.pcisig.com/specifications/pciexpress/specifications/ECN_L1_PM_Substates_with_CLKREQ_31_May_2013_Rev10a.pdf).

So:
150: 03 10 03 10 0b 00 01 00 fe ca 41 01 1f 1e f0 00
160: 0f 00 a0 40 f0 00 00 00 00 00 00 00 00 00 00 00

We can see that L1 PM Substate *is* enabled:
004h = 41 01 1f 1e
008h = 0f 00 f0 00
00Ch = a0 40 f0 00

I may have messed up things here...

According to System / HW, it is unsafe to disable L1 PM Substate using setpci, even if we disable it from both sides (device and bridge). This kind of settings should be done by BIOS only.
So we have 2 options here (assuming that we can't disable that in BIOS):
* either we try to disable L1 PM Substate even my colleagues think it is not safe
* either we just disable L1 altogether
