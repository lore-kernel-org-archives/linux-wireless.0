Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from a80-127-65-128.adsl.xs4all.nl ([80.127.65.128]:14309 "EHLO
	linux.wilsoft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbZAFUcM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2009 15:32:12 -0500
Received: from notebook.wilsoft.nl ([192.168.4.4])
	by linux.wilsoft.nl with esmtp (Exim 4.69)
	(envelope-from <listsrv@wilsoft.nl>)
	id 1LKIaq-0001Mr-Ky
	for linux-wireless@vger.kernel.org; Tue, 06 Jan 2009 21:32:04 +0100
From: "W. van den Akker" <listsrv@wilsoft.nl>
To: linux-wireless@vger.kernel.org
Subject: Re: Still problems to get ath9k in accessmode. Kernel hangs
Date: Tue, 6 Jan 2009 21:32:04 +0100
References: <200901011444.20333.listsrv@wilsoft.nl> <200901060857.41357.listsrv@wilsoft.nl> <200901061552.45729.listsrv@wilsoft.nl>
In-Reply-To: <200901061552.45729.listsrv@wilsoft.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200901062132.04403.listsrv@wilsoft.nl> (sfid-20090106_213215_912482_36235D3F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 06 January 2009 15:52:45 you wrote:
> On Tuesday 06 January 2009, you wrote:
> > On Monday 05 January 2009, you wrote:
> > > On Thu, Jan 01, 2009 at 02:44:20PM +0100, W. van den Akker wrote:
> > > > I have tested on the server  with the latest wireless-testing the
> > > > past days (2.6.28-rc9-wl). The wireless-testing looks somewhat more
> > > > stable then the compat-wireless.
> > > >
> > > > I have also installed the netconsole module to watch any kernel
> > > > prints. After running hostapd (v0.6.6) from command line the AP is
> > > > up-and-running. Then if I connect with the laptop (tested it with
> > > > kernel .26 and .28 on the laptop) I get a connection and can start a
> > > > browser en explore the internet. If I start a second session (Kmail
> > > > or second browser) the
> > > > server hangs within a minute. Leaving again no trace on the console,
> > > > hostapd-log or netconsole.
> > >
> > > Just to make sure I understood this correctly.. Does this happen with
> > > just a single association station (your laptop)? What are you referring
> > > to with a "session"? Just another program using network (i.e., no new
> > > wireless associations, etc.)? As far as the ath9k driver is concerned,
> > > new applications (e.g., new TCP connection) should not really matter
> > > much.. If you have IEEE 802.11n enabled, could you please run a test
> > > with it disabled to make sure this is not related to frame aggregation?
> > >
> > > As far as getting any output from the system is concerned, the next
> > > step could be to see if NMI watchdog would be able to provide any help.
> > > Please take a look at Documentation/nmi_watchdog.txt in the kernel
> > > source code and see if you could use that on the AP to get some output
> > > when the system hangs (running without X on console to make sure you
> > > see the output).
> >
> > Hi Jouni,
> >
> > Yes you understood correctly. Only a laptop, start a browser then start
> > Kmail over the same wireless connection. Then it hangs. This is always
> > reproducable. There are also other sorts or hangups (for example when
> > starting hostapd, but that is not always reproducable when it happens).
> >
> > I will try today the watchdog-suggestion. Hope that it will provide some
> > help.
>
> I have enabled the NMI_watchdog (see below)
>           CPU0       CPU1
>   0:     322372          0   IO-APIC-edge      timer
>   1:         12          0   IO-APIC-edge      i8042
>   4:        101          0   IO-APIC-edge      serial
>   6:          3          0   IO-APIC-edge      floppy
>   7:          0          0   IO-APIC-edge      parport0
>   8:          2          0   IO-APIC-edge      rtc0
>   9:          0          0   IO-APIC-fasteoi   acpi
>  12:          4          0   IO-APIC-edge      i8042
>  16:          0          0   IO-APIC-fasteoi   uhci_hcd:usb1
>  17:       6282          0   IO-APIC-fasteoi   eth1
>  18:     364152          0   IO-APIC-fasteoi   ata_piix, ata_piix, eth0
>  19:          0          0   IO-APIC-fasteoi   uhci_hcd:usb2
>  21:       1727          0   IO-APIC-fasteoi   ath
>  23:          0          0   IO-APIC-fasteoi   ehci_hcd:usb3
>  27:         89          0   IO-APIC-fasteoi   aic79xx
> NMI:     322364     322307   Non-maskable interrupts
> LOC:          0     322302   Local timer interrupts
> RES:      10695      24691   Rescheduling interrupts
> CAL:         36        112   Function call interrupts
> TLB:       2371       3165   TLB shootdowns
> TRM:          0          0   Thermal event interrupts
> SPU:          0          0   Spurious interrupts
> ERR:          0
> MIS:          0
>
> However, after starting a internet session and Kmail session the server
> hangs again without any output. Does the NMI-handler not process per CPU?
> So if one CPU hangs, the other would still proceed?
>
> I have no 802.11n enabled, nor X.
>
> This means I think the system halted hard 'hlt-instruction'
>
> Any further suggestion? I am little bit hopeless now. I have placed the PCI
> card into another slot, no result.

Some additional information:
I have booted the server at approx 16:00. Hostapd was started at boot-time.
After 5 hours without any connection from any computers the server hangs.

-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.

