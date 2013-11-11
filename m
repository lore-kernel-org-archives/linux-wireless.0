Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f171.google.com ([209.85.223.171]:44351 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990Ab3KKWon (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Nov 2013 17:44:43 -0500
Received: by mail-ie0-f171.google.com with SMTP id at1so2933097iec.30
        for <linux-wireless@vger.kernel.org>; Mon, 11 Nov 2013 14:44:43 -0800 (PST)
Date: Mon, 11 Nov 2013 15:44:39 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: wzyboy <wzyboy@wzyboy.org>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [Ilw] Intel Wireless 7260 hardware timed out randomly
Message-ID: <20131111224439.GA30638@google.com> (sfid-20131111_234448_223456_4228E8CC)
References: <0BA3FCBA62E2DC44AF3030971E174FB301DEA052@HASMSX103.ger.corp.intel.com>
 <CALkVjQZRJw7ghjBa1aPKNKe3Zj2B1Mhk5bWVaRdcCYzfoLRovg@mail.gmail.com>
 <CALkVjQY7r=YKhsgDKR0mnYVtZy5BAdj83nY2jL0VFaiew6ha7A@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301DEA097@HASMSX103.ger.corp.intel.com>
 <CALkVjQY7uRFQ3Qs9T_bgqnYRNcWgsk5gfd=R8RfGFxOdDpFYTQ@mail.gmail.com>
 <527A8166.6000701@gmail.com>
 <CAErSpo5H9Mf-xmdzThudNO2WHAOt-1T7CQZvgGUmK4jm7_zf+g@mail.gmail.com>
 <CALkVjQaHYpR4Tifbt7nh4VeQSrOz5J-xxSrUBKX2kXCZcvkivA@mail.gmail.com>
 <CAErSpo5dX=cPdThxi-ok=B4beo_jPv2n2n0C1u4UyZMbQDMxqg@mail.gmail.com>
 <CALkVjQYkAWrwRabQfBSvC1pm47ZyRT5jQ0mYBwbiGh-Bt29gbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CALkVjQYkAWrwRabQfBSvC1pm47ZyRT5jQ0mYBwbiGh-Bt29gbg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 09, 2013 at 10:46:21AM +0800, wzyboy wrote:
> 2013/11/9 Bjorn Helgaas <bhelgaas@google.com>:
> > Thanks.  But can you please attach the output of "lspci -vvxxx" (not
> > "-vxxxx") for the entire system before the problem occurs?
> 
> 
> Sorry I used the wrong command...
> 
> I've attached the output of -vvxxx below.
> 
> There are three files:
> 
> * lspci.vvxxx.normal.txt: When the interface is "state DOWN" in "ip link".
> * lspci.vvxxx.normal2.txt: When the interface is "state UP" in "ip
> link" after I ran "ip link set wlan0 up".
> * lspci.vvxxx.normal3.txt" When the interface is connected to the
> Wi-Fi of my dormitory and got an address (but without default
> gateway, I'm using wired network now).

The only interesting difference is this (between "normal" and "normal3"):

--- lspci.vvxxx.normal.txt      2013-11-11 14:42:14.000000000 -0700
+++ lspci.vvxxx.normal3.txt     2013-11-11 14:42:14.000000000 -0700

 00:1c.1 PCI bridge: Intel Corporation Lynx Point-LP PCI Express Root Port 3 (rev e4) (prog-if 00 [Normal decode])
-               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
+               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train+ SlotClk+ DLActive+ BWMgmt+ ABWMgmt-

In "normal3", the Link Training bit is set.  I'm not a hardware person,
but my guess it this might be normal.  The spec says Link Training
indicates that the "LTSSM is in the Configuration or Recovery state,"
and Figure 5-1 shows that the transition from L1 to L0 goes through
the Recovery state.  So we might just be seeing the device returning
from L1 to L0.  Maybe Emmanuel can confirm this with the hardware guys.

Comparing "lspci.vvxxx.normal.txt" with "lspci.vvxxx.patched.bug.txt",
I see these changes in the 00:1c.1 Downstream Port (the bridge that
leads to the 7260 NIC):

--- before      2013-11-11 15:24:04.755738964 -0700
+++ after       2013-11-11 15:24:11.875722068 -0700
 00:1c.1 PCI bridge: Intel Corporation Lynx Point-LP PCI Express Root Port 3 (rev e4) (prog-if 00 [Normal decode])
-               DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
+               DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
-               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
+               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt+ ABWMgmt-
-               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
-                       Changed: MRL- PresDet- LinkState+
+               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
+                       Changed: MRL- PresDet+ LinkState+
-               DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR+, OBFF Disabled ARIFwd-
+               DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled ARIFwd-

So when the bug occurs,

  - Correctable Error Detected is set
  - Data Link Layer Link Active is cleared
  - Presence Detect State is cleared
  - LTR Mechanism Enable is cleared (spec says this bit must be
    reset to the default value when a Downstream Port goes to
    DL_Down)

This all seems consistent with the device being powered off.  Maybe
the 7260 is on a daughterboard with a bad connection to the system
board?  Any chance you can open up the box and make sure the
connection is tight?

It's possible there's some ASPM issue, but I would think Presence
Detect would still work even if the 7260 had a problem with ASPM.
Here's another experiment to try to rule out ASPM.  Run these
commands as root after the driver is loaded but before the bug occurs:

  setpci -s03:00.0 0x50.W=0x140
  setpci -s00:1c.1 0x50.W=0x040
  lspci -vv

This should disable ASPM completely on that link, and the lspci output
will help verify that.

Bjorn
