Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56498 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964Ab2GMOA0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jul 2012 10:00:26 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1SpgPt-0000Kz-QL
	for linux-wireless@vger.kernel.org; Fri, 13 Jul 2012 16:00:22 +0200
Received: from 201-8-46-167.user.veloxzone.com.br ([201.8.46.167])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 13 Jul 2012 16:00:21 +0200
Received: from arliton by 201-8-46-167.user.veloxzone.com.br with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 13 Jul 2012 16:00:21 +0200
To: linux-wireless@vger.kernel.org
From: Arliton Rocha <arliton@gmail.com>
Subject: Problem: Realtek Semiconductor RTL8190 does not work
Date: Fri, 13 Jul 2012 13:57:41 +0000 (UTC)
Message-ID: <loom.20120713T155036-592@post.gmane.org> (sfid-20120713_160030_673186_F9D36467)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

The following card does not work. 
    Realtek Semiconductor Co., Ltd. RTL8190 802.11n Wireless LAN
Tried in various versions of the linux kernel, even the recent version (3.5-
rc6).
Finding i could see several people reporting the same problem. In mailing list 
archives i not find anything related.

The command lspci -n returns id: 10ec:8190 
http://cateee.net/lkddb/web-lkddb/RTL8192E.html
The link above shows that is related with the module rtl8192e_pci (staging).
Load this module does not change anything.
Version 2.6.38.8 has this id: 
http://lxr.linux.no/linux+v2.6.38.8/drivers/staging/rtl8192e/r8192E_core.c (not 
works).
Version 2.6.39 removed (i think): 
http://lxr.linux.no/linux+v2.6.39/drivers/staging/rtl8192e/r8192E_core.c
Version 3.2.23 doesn't have: 
http://lxr.linux.no/linux+v3.2.23/drivers/staging/rtl8192e/rtl_core.c
Version 3.4.4 doesn't have: 
http://lxr.linux.no/linux+v3.4.4/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
I have tried but so far I could not understand the code, so I'm available to 
test code suggestions or give more information.

Best regards.

Hardware information:

lspci -n:

    03:00.0 0280: 10ec:8190


lspci -vvv:

    03:00.0 Network controller: Realtek Semiconductor Co., Ltd. RTL8190 802.11n 
Wireless LAN
        Subsystem: Realtek Semiconductor Co., Ltd. RTL8190 802.11n Wireless LAN
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR+ INTx-
        Interrupt: pin A routed to IRQ 255
        Region 0: I/O ports at <unassigned> [disabled]
        Region 1: Memory at bfa00000 (32-bit, non-prefetchable) [disabled] 
[size=64K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0-
,D1+,D2+,D3hot+,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-



ver_linux:

If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.
 
Linux linux 3.2.0-3-686-pae #1 SMP Thu Jun 28 08:56:46 UTC 2012 i686 GNU/Linux
 
Gnu C                  4.6
Gnu make               3.81
binutils               2.22
util-linux             2.20.1
mount                  support
module-init-tools      3.16
e2fsprogs              1.42
reiserfsprogs          3.6.21
PPP                    2.4.5
Linux C Library        2.13
Dynamic linker (ldd)   2.13
Procps                 3.2.8
Net-tools              1.60
Kbd                    1.15.3
Sh-utils               8.13
wireless-tools         30
Modules Loaded         cpufreq_userspace cpufreq_stats cpufreq_powersave 
cpufreq_conservative ppdev lp bnep rfcomm bluetooth rfkill crc16 fuse nfsd nfs 
lockd fscache auth_rpcgss nfs_acl sunrpc loop snd_hda_codec_hdmi 
snd_hda_codec_realtek coretemp snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss 
snd_mixer_oss snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event crc32c_intel 
snd_seq snd_timer snd_seq_device snd soundcore snd_page_alloc aesni_intel 
iTCO_wdt cryptd aes_i586 aes_generic i2c_i801 iTCO_vendor_support evdev 
acpi_cpufreq mperf pcspkr parport_pc parport processor ext3 jbd mbcache sd_mod 
crc_t10dif sr_mod cdrom usb_storage uas usbhid hid ata_generic ata_piix ehci_hcd 
i915 libata scsi_mod usbcore usb_common r8169 mii drm_kms_helper drm 
i2c_algo_bit button i2c_core video thermal_sys



