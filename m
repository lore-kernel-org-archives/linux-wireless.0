Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:51076 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750869Ab2DPRpX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 13:45:23 -0400
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Stanislav Yakovlev <stas.yakovlev@gmail.com>
Subject: Re: [PATCH] net/wireless: ipw2200: Fix WARN_ON occurring in wiphy_register called by ipw_pci_probe
Date: Mon, 16 Apr 2012 19:45:05 +0200
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	stable@kernel.org, 656813@bugs.debian.org
References: <1334572710-10838-1-git-send-email-stas.yakovlev@gmail.com>
In-Reply-To: <1334572710-10838-1-git-send-email-stas.yakovlev@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201204161945.08522.s.L-H@gmx.de> (sfid-20120416_194530_755392_BAC4BC5A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Monday 16 April 2012, Stanislav Yakovlev wrote:
> The problem was found by Stefan Lippers-Hollmann
> http://marc.info/?l=linux-wireless&m=132720334512946&w=2
> 
> WARNING: at /tmp/buildd/linux-aptosid-3.2/debian/build/source_i386_none/net/wireless/core.c:562 wiphy_register+0x45/0x38d [cfg80211]()
> Hardware name: TravelMate 290 \xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff
> Modules linked in: ipw2200(+) iTCO_wdt libipw joydev drm snd_seq snd_timer snd_seq_device iTCO_vendor_support yenta_socket snd intel_agp i2c_i801 pcmcia_rsrc cfg80211 soundcore parport_pc psmouse parport rng_core snd_page_alloc serio_raw pcspkr i2c_algo_bit intel_gtt pcmcia_core evdev irda crc_ccitt rfkill lib80211 processor container ac battery shpchp pci_hotplug button ext4 mbcache jbd2 crc16 dm_mod sd_mod sr_mod crc_t10dif cdrom ata_generic pata_acpi ata_piix libata scsi_mod firewire_ohci firewire_core crc_itu_t 8139too 8139cp mii uhci_hcd ehci_hcd usbcore usb_common [last unloaded: scsi_wait_scan]
> Pid: 328, comm: modprobe Not tainted 3.2-1.slh.4-aptosid-686 #1
> Call Trace:
> [<c012eaf4>] ? warn_slowpath_common+0x7c/0x8f
> [<e0ff0b3e>] ? wiphy_register+0x45/0x38d [cfg80211]
> [<e0ff0b3e>] ? wiphy_register+0x45/0x38d [cfg80211]
> [<c012eb22>] ? warn_slowpath_null+0x1b/0x1f
> [<e0ff0b3e>] ? wiphy_register+0x45/0x38d [cfg80211]
> [<c01f89d7>] ? internal_create_group+0xf5/0xff
> [<e0a2de1c>] ? ipw_pci_probe+0xa9a/0xbd0 [ipw2200]
[…]
> 
> This warning appears only if we apply Ben Hutchings' fix
> http://marc.info/?l=linux-wireless&m=132720195012653&w=2
> for the bug reported by Cesare Leonardi
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=656813
> with cfg80211 warning during device registration
> ("cfg80211: failed to add phy80211 symlink to netdev!").
> 
> We separate device bring up and registration with network stack
> to avoid the problem.
> 
> After that Ben Hutchings' fix can be applied to fix the bug.
> 
> Cc: stable@kernel.org
> Signed-off-by: Stanislav Yakovlev <stas.yakovlev@gmail.com>
> 
> ---
> 
> Stefan, can you test it once again?
[…]

I've successfully tested this patch on its own and with Ben Hutching's 
patch ("Bug#656813: [PATCH 1/2] ipw2200: Fix order of 
device registration", Message-ID: <1327201775.8004.83.camel@deadeye>)
applied on top, it's working fine in both cases. The "cfg80211: failed 
to add phy80211 symlink to netdev!" warning disappears after applying 
both patches to kernel 3.3.2. 

Feel free to add a tested-by tag, if you like:
Tested-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>

Tested using:
02:02.0 Network controller [0280]: Intel Corporation PRO/Wireless 2200BG [Calexico2] Network Connection [8086:4220] (rev 05)
        Subsystem: Intel Corporation Device [8086:2701]
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 128 (750ns min, 6000ns max)
        Interrupt: pin A routed to IRQ 10
        Region 0: Memory at d0000000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
        Kernel driver in use: ipw2200

Thanks a lot for your efforts!

Regards
	Stefan Lippers-Hollmann
