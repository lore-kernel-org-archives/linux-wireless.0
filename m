Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from imr-db01.mx.aol.com ([205.188.91.95]:65505 "EHLO
	imr-db01.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab1K1PVZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Nov 2011 10:21:25 -0500
Received: from mtaout-da06.r1000.mx.aol.com (mtaout-da06.r1000.mx.aol.com [172.29.51.134])
	by imr-db01.mx.aol.com (8.14.1/8.14.1) with ESMTP id pASFLDIL020819
	for <linux-wireless@vger.kernel.org>; Mon, 28 Nov 2011 10:21:13 -0500
Received: from [10.43.6.112] (173-14-129-9-NewEngland.hfc.comcastbusiness.net [173.14.129.9])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mtaout-da06.r1000.mx.aol.com (MUA/Third Party Client Interface) with ESMTPSA id 15143E0001A3
	for <linux-wireless@vger.kernel.org>; Mon, 28 Nov 2011 10:21:13 -0500 (EST)
Message-ID: <4ED3A6E8.4050000@aol.com> (sfid-20111128_162130_019351_A7230BA7)
Date: Mon, 28 Nov 2011 10:21:12 -0500
From: AndrewL733 <AndrewL733@aol.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Trouble with Macbook Pro 8,2 (broadcom 4331) and latest b43
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

----------------------
I'm apologize in advance if this posting repeats another posting I made 
on 26 Nov.  I submitted it but don't see it in the archives. I'm 
thinking it never arrived so I am sending it again.
-----------------------

I'm wondering if anybody has any clues about why I cannot get a Broadcom 
4331-based wireless device to work in my Macbook Pro (Model 8,2). When I 
try to load the driver with "modprobe b43" I get the following in dmesg:

[ 3279.117137] bcma-pci-bridge 0000:03:00.0: PCI INT A disabled
[ 3281.301279] bcma-pci-bridge 0000:03:00.0: PCI INT A -> GSI 17 (level, 
low) -> IRQ 17
[ 3281.301297] bcma-pci-bridge 0000:03:00.0: setting latency timer to 64
[ 3281.301381] bcma: Core 0 found: ChipCommon (manuf 0x4BF, id 0x800, 
rev 0x25, class 0x0)
[ 3281.301405] bcma: Core 1 found: IEEE 802.11 (manuf 0x4BF, id 0x812, 
rev 0x1D, class 0x0)
[ 3281.301459] bcma: Core 2 found: PCIe (manuf 0x4BF, id 0x820, rev 
0x13, class 0x0)
[ 3281.301581] bcma: PMU resource config unknown for device 0x4331
[ 3281.301583] bcma: Enabling Ext PA lines not implemented
[ 3281.310508] bcma: Bus registered
[ 3281.312814] cfg80211: Calling CRDA to update world regulatory domain
[ 3281.316215] b43-phy0: Broadcom 4331 WLAN found (core revision 29)
[ 3281.316383] b43-phy0 ERROR: FOUND UNSUPPORTED PHY (Analog 9, Type 7, 
Revision 1)
[ 3281.316391] b43: probe of bcma0:0 failed with error -95
[ 3281.316417] Broadcom 43xx driver loaded [ Features: PMNLS, 
Firmware-ID: FW13 ]
[ 3281.319930] cfg80211: World regulatory domain updated:
[ 3281.319933] cfg80211:     (start_freq - end_freq @ bandwidth), 
(max_antenna_gain, max_eirp)
[ 3281.319935] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), 
(300 mBi, 2000 mBm)
[ 3281.319937] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), 
(300 mBi, 2000 mBm)
[ 3281.319939] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), 
(300 mBi, 2000 mBm)
[ 3281.319941] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), 
(300 mBi, 2000 mBm)
[ 3281.319943] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), 
(300 mBi, 2000 mBm)


I had this working a few weeks ago with the same Macbook Pro model (Core 
i7 Quad Core 15 inch), but then an Apple firmware update (applied via OS 
X) bricked the laptop and I had to exchange it.  I'm suspecting that the 
replacement has slightly revised hardware but I cannot be sure.  
According to lspci, the hardware still seems the same as before, as far 
as I can remember.

02:00.0 Ethernet controller [0200]: Broadcom Corporation NetXtreme 
BCM57765 Gigabit Ethernet PCIe [14e4:16b4] (rev 10)
         Subsystem: Broadcom Corporation NetXtreme BCM57765 Gigabit 
Ethernet PCIe [14e4:16b4]
02:00.1 SD Host controller [0805]: Broadcom Corporation Device 
[14e4:16bc] (rev 10) (prog-if 01)
         Subsystem: Broadcom Corporation Device [14e4:0000]
03:00.0 Network controller [0280]: Broadcom Corporation Device 
[14e4:4331] (rev 02)
         Subsystem: Broadcom Corporation Device [14e4:4331]

I have in tried the b43 driver that comes with the 3.1.2 kernel.  I have 
tried installing the "bleeding edge linux-next" version of b43 as of 26 
November (compat-wireless-2011-11-08-11-gd32558f) as well as the 
"3.2-rc1" version. I have installed the broadcom firmware with 
b43-fwcutter with "broadcom-wl-5.100.138" and also with the version 
recommended with Mandriva 2011.

I did get the same error when installing the linux-next and 3.2-rc1 
versions.  It seemed to compile properly but then:

make -C /lib/modules/3.1.2-1.1-desktop/build 
M=/home/andy/kernel/compat-wireless-2011-11-22 modules
make[1]: Entering directory `/usr/src/devel/3.1.2-1.1-desktop'
   CC [M]  /home/andy/kernel/compat-wireless-2011-11-22/compat/main.o
   LD [M]  /home/andy/kernel/compat-wireless-2011-11-22/compat/compat.o
   CC [M]  /home/andy/kernel/compat-wireless-2011-11-22/drivers/bcma/main.o
   CC [M]  /home/andy/kernel/compat-wireless-2011-11-22/drivers/bcma/scan.o
   CC [M]  /home/andy/kernel/compat-wireless-2011-11-22/drivers/bcma/core.o
   CC [M]  /home/andy/kernel/compat-wireless-2011-11-22/drivers/bcma/sprom.o
   CC [M]  
/home/andy/kernel/compat-wireless-2011-11-22/drivers/bcma/driver_chipcommon.o
   CC [M]  
/home/andy/kernel/compat-wireless-2011-11-22/drivers/bcma/driver_chipcommon_pmu.o
   CC [M]  
/home/andy/kernel/compat-wireless-2011-11-22/drivers/bcma/driver_pci.o
   CC [M]  
/home/andy/kernel/compat-wireless-2011-11-22/drivers/bcma/host_pci.o
   LD [M]  /home/andy/kernel/compat-wireless-2011-11-22/drivers/bcma/bcma.o
   CC [M]  
/home/andy/kernel/compat-wireless-2011-11-22/drivers/net/wireless/b43/main.o
   CC [M]  
/home/andy/kernel/compat-wireless-2011-11-22/drivers/net/wireless/b43/bus.o
   CC [M]  
/home/andy/kernel/compat-wireless-2011-11-22/drivers/net/wireless/b43/tables.o
   CC [M]  
/home/andy/kernel/compat-wireless-2011-11-22/drivers/net/wireless/b43/tables_nphy.o
   CC [M]  
/home/andy/kernel/compat-wireless-2011-11-22/drivers/net/wireless/b43/radio_2055.o
   CC [M]  
/home/andy/kernel/compat-wireless-2011-11-22/drivers/net/wireless/b43/radio_2056.o
   CC [M]  
/home/andy/kernel/compat-wireless-2011-11-22/drivers/net/wireless/b43/phy_common.o
   CC [M]  
/home/andy/kernel/compat-wireless-2011-11-22/drivers/net/wireless/b43/phy_g.o
   CC [M]  
/home/andy/kernel/compat-wireless-2011-11-22/drivers/net/wireless/b43/phy_a.o
   CC [M]  
/home/andy/kernel/compat-wireless-2011-11-22/drivers/net/wireless/b43/phy_n.o
   CC [M]  
/home/andy/kernel/compat-wireless-2011-11-22/drivers/net/wireless/b43/phy_lp.o
   CC [M]  
/home/andy/kernel/compat-wireless-2011-11-22/drivers/net/wireless/b43/tables_lpphy.o
   CC [M]  
/home/andy/kernel/compat-wireless-2011-11-22/drivers/net/wireless/b43/phy_ht.o
   CC [M]  
/home/andy/kernel/compat-wireless-2011-11-22/drivers/net/wireless/b43/tables_phy_ht.o
   CC [M]  
/home/andy/kernel/compat-wireless-2011-11-22/drivers/net/wireless/b43/radio_2059.o
   CC [M]  
/home/andy/kernel/compat-wireless-2011-11-22/drivers/net/wireless/b43/sysfs.o
   CC [M]  
/home/andy/kernel/compat-wireless-2011-11-22/drivers/net/wireless/b43/xmit.o
   CC [M]  
/home/andy/kernel/compat-wireless-2011-11-22/drivers/net/wireless/b43/lo.o
   CC [M]  
/home/andy/kernel/compat-wireless-2011-11-22/drivers/net/wireless/b43/wa.o
   CC [M]  
/home/andy/kernel/compat-wireless-2011-11-22/drivers/net/wireless/b43/dma.o
   CC [M]  
/home/andy/kernel/compat-wireless-2011-11-22/drivers/net/wireless/b43/pio.o
   CC [M]  
/home/andy/kernel/compat-wireless-2011-11-22/drivers/net/wireless/b43/rfkill.o
   CC [M]  
/home/andy/kernel/compat-wireless-2011-11-22/drivers/net/wireless/b43/leds.o
   CC [M]  
/home/andy/kernel/compat-wireless-2011-11-22/drivers/net/wireless/b43/pcmcia.o
   CC [M]  
/home/andy/kernel/compat-wireless-2011-11-22/drivers/net/wireless/b43/sdio.o
   LD [M]  
/home/andy/kernel/compat-wireless-2011-11-22/drivers/net/wireless/b43/b43.o
   CC [M]  /home/andy/kernel/compat-wireless-2011-11-22/drivers/ssb/main.o
   CC [M]  /home/andy/kernel/compat-wireless-2011-11-22/drivers/ssb/scan.o
   CC [M]  /home/andy/kernel/compat-wireless-2011-11-22/drivers/ssb/sprom.o
   CC [M]  /home/andy/kernel/compat-wireless-2011-11-22/drivers/ssb/pci.o
   CC [M]  
/home/andy/kernel/compat-wireless-2011-11-22/drivers/ssb/pcihost_wrapper.o
   CC [M]  /home/andy/kernel/compat-wireless-2011-11-22/drivers/ssb/pcmcia.o
   CC [M]  /home/andy/kernel/compat-wireless-2011-11-22/drivers/ssb/sdio.o
   CC [M]  
/home/andy/kernel/compat-wireless-2011-11-22/drivers/ssb/driver_chipcommon.o
   CC [M]  
/home/andy/kernel/compat-wireless-2011-11-22/drivers/ssb/driver_chipcommon_pmu.o
   CC [M]  
/home/andy/kernel/compat-wireless-2011-11-22/drivers/ssb/driver_pcicore.o
   CC [M]  
/home/andy/kernel/compat-wireless-2011-11-22/drivers/ssb/b43_pci_bridge.o
   LD [M]  /home/andy/kernel/compat-wireless-2011-11-22/drivers/ssb/ssb.o
   CC [M]  /home/andy/kernel/compat-wireless-2011-11-22/net/mac80211/main.o
   CC [M]  
/home/andy/kernel/compat-wireless-2011-11-22/net/mac80211/status.o
   CC [M]  
/home/andy/kernel/compat-wireless-2011-11-22/net/mac80211/sta_info.o
   CC [M]  /home/andy/kernel/compat-wireless-2011-11-22/net/mac80211/wep.o
   CC [M]  /home/andy/kernel/compat-wireless-2011-11-22/net/mac80211/wpa.o
   CC [M]  /home/andy/kernel/compat-wireless-2011-11-22/net/mac80211/scan.o
   CC [M]  
/home/andy/kernel/compat-wireless-2011-11-22/net/mac80211/offchannel.o
   CC [M]  /home/andy/kernel/compat-wireless-2011-11-22/net/mac80211/ht.o
   CC [M]  
/home/andy/kernel/compat-wireless-2011-11-22/net/mac80211/agg-tx.o
   CC [M]  
/home/andy/kernel/compat-wireless-2011-11-22/net/mac80211/agg-rx.o
   CC [M]  /home/andy/kernel/compat-wireless-2011-11-22/net/mac80211/ibss.o
   CC [M]  /home/andy/kernel/compat-wireless-2011-11-22/net/mac80211/mlme.o
   CC [M]  /home/andy/kernel/compat-wireless-2011-11-22/net/mac80211/work.o
   CC [M]  /home/andy/kernel/compat-wireless-2011-11-22/net/mac80211/iface.o
   CC [M]  /home/andy/kernel/compat-wireless-2011-11-22/net/mac80211/rate.o
   CC [M]  
/home/andy/kernel/compat-wireless-2011-11-22/net/mac80211/michael.o
   CC [M]  /home/andy/kernel/compat-wireless-2011-11-22/net/mac80211/tkip.o
   CC [M]  
/home/andy/kernel/compat-wireless-2011-11-22/net/mac80211/aes_ccm.o
   CC [M]  
/home/andy/kernel/compat-wireless-2011-11-22/net/mac80211/aes_cmac.o
   CC [M]  /home/andy/kernel/compat-wireless-2011-11-22/net/mac80211/cfg.o
   CC [M]  /home/andy/kernel/compat-wireless-2011-11-22/net/mac80211/rx.o
   CC [M]  
/home/andy/kernel/compat-wireless-2011-11-22/net/mac80211/spectmgmt.o
   CC [M]  /home/andy/kernel/compat-wireless-2011-11-22/net/mac80211/tx.o
   CC [M]  /home/andy/kernel/compat-wireless-2011-11-22/net/mac80211/key.o
   CC [M]  /home/andy/kernel/compat-wireless-2011-11-22/net/mac80211/util.o
   CC [M]  /home/andy/kernel/compat-wireless-2011-11-22/net/mac80211/wme.o
   CC [M]  /home/andy/kernel/compat-wireless-2011-11-22/net/mac80211/event.o
   CC [M]  /home/andy/kernel/compat-wireless-2011-11-22/net/mac80211/chan.o
   CC [M]  /home/andy/kernel/compat-wireless-2011-11-22/net/mac80211/led.o
   CC [M]  /home/andy/kernel/compat-wireless-2011-11-22/net/mac80211/mesh.o
   CC [M]  
/home/andy/kernel/compat-wireless-2011-11-22/net/mac80211/mesh_pathtbl.o
   CC [M]  
/home/andy/kernel/compat-wireless-2011-11-22/net/mac80211/mesh_plink.o
   CC [M]  
/home/andy/kernel/compat-wireless-2011-11-22/net/mac80211/mesh_hwmp.o
   CC [M]  /home/andy/kernel/compat-wireless-2011-11-22/net/mac80211/pm.o
   CC [M]  
/home/andy/kernel/compat-wireless-2011-11-22/net/mac80211/rc80211_pid_algo.o
   CC [M]  
/home/andy/kernel/compat-wireless-2011-11-22/net/mac80211/rc80211_minstrel.o
   CC [M]  
/home/andy/kernel/compat-wireless-2011-11-22/net/mac80211/rc80211_minstrel_ht.o
   LD [M]  
/home/andy/kernel/compat-wireless-2011-11-22/net/mac80211/mac80211.o
   CC [M]  /home/andy/kernel/compat-wireless-2011-11-22/net/wireless/core.o
/home/andy/kernel/compat-wireless-2011-11-22/net/wireless/core.c:7:0: 
warning: "pr_fmt" redefined [enabled by default]
include/linux/printk.h:152:0: note: this is the location of the previous 
definition
/home/andy/kernel/compat-wireless-2011-11-22/net/wireless/core.c:7:0: 
warning: "pr_fmt" redefined [enabled by default]
include/linux/printk.h:152:0: note: this is the location of the previous 
definition
   CC [M]  /home/andy/kernel/compat-wireless-2011-11-22/net/wireless/sysfs.o
   CC [M]  
/home/andy/kernel/compat-wireless-2011-11-22/net/wireless/radiotap.o
   CC [M]  /home/andy/kernel/compat-wireless-2011-11-22/net/wireless/util.o
   CC [M]  /home/andy/kernel/compat-wireless-2011-11-22/net/wireless/reg.o
/home/andy/kernel/compat-wireless-2011-11-22/net/wireless/reg.c:36:0: 
warning: "pr_fmt" redefined [enabled by default]
include/linux/printk.h:152:0: note: this is the location of the previous 
definition
/home/andy/kernel/compat-wireless-2011-11-22/net/wireless/reg.c:36:0: 
warning: "pr_fmt" redefined [enabled by default]
include/linux/printk.h:152:0: note: this is the location of the previous 
definition
   CC [M]  /home/andy/kernel/compat-wireless-2011-11-22/net/wireless/scan.o
   CC [M]  
/home/andy/kernel/compat-wireless-2011-11-22/net/wireless/nl80211.o
   CC [M]  /home/andy/kernel/compat-wireless-2011-11-22/net/wireless/mlme.o
   CC [M]  /home/andy/kernel/compat-wireless-2011-11-22/net/wireless/ibss.o
   CC [M]  /home/andy/kernel/compat-wireless-2011-11-22/net/wireless/sme.o
   CC [M]  /home/andy/kernel/compat-wireless-2011-11-22/net/wireless/chan.o
   CC [M]  
/home/andy/kernel/compat-wireless-2011-11-22/net/wireless/ethtool.o
   CC [M]  /home/andy/kernel/compat-wireless-2011-11-22/net/wireless/mesh.o
   CC [M]  
/home/andy/kernel/compat-wireless-2011-11-22/net/wireless/wext-compat.o
   CC [M]  
/home/andy/kernel/compat-wireless-2011-11-22/net/wireless/wext-sme.o
   LD [M]  
/home/andy/kernel/compat-wireless-2011-11-22/net/wireless/cfg80211.o
   Building modules, stage 2.
   MODPOST 6 modules
   CC      /home/andy/kernel/compat-wireless-2011-11-22/compat/compat.mod.o
   LD [M]  /home/andy/kernel/compat-wireless-2011-11-22/compat/compat.ko
   CC      
/home/andy/kernel/compat-wireless-2011-11-22/drivers/bcma/bcma.mod.o
   LD [M]  /home/andy/kernel/compat-wireless-2011-11-22/drivers/bcma/bcma.ko
   CC      
/home/andy/kernel/compat-wireless-2011-11-22/drivers/net/wireless/b43/b43.mod.o
   LD [M]  
/home/andy/kernel/compat-wireless-2011-11-22/drivers/net/wireless/b43/b43.ko
   CC      
/home/andy/kernel/compat-wireless-2011-11-22/drivers/ssb/ssb.mod.o
   LD [M]  /home/andy/kernel/compat-wireless-2011-11-22/drivers/ssb/ssb.ko
   CC      
/home/andy/kernel/compat-wireless-2011-11-22/net/mac80211/mac80211.mod.o
   LD [M]  
/home/andy/kernel/compat-wireless-2011-11-22/net/mac80211/mac80211.ko
   CC      
/home/andy/kernel/compat-wireless-2011-11-22/net/wireless/cfg80211.mod.o
   LD [M]  
/home/andy/kernel/compat-wireless-2011-11-22/net/wireless/cfg80211.ko
make[1]: Leaving directory `/usr/src/devel/3.1.2-1.1-desktop'
make -C /lib/modules/3.1.2-1.1-desktop/build 
M=/home/andy/kernel/compat-wireless-2011-11-22 "INSTALL_MOD_DIR=updates"  \
         modules_install
make[1]: Entering directory `/usr/src/devel/3.1.2-1.1-desktop'
   INSTALL  /home/andy/kernel/compat-wireless-2011-11-22/compat/compat.ko
   INSTALL  
/home/andy/kernel/compat-wireless-2011-11-22/drivers/bcma/bcma.ko
   INSTALL  
/home/andy/kernel/compat-wireless-2011-11-22/drivers/net/wireless/b43/b43.ko
   INSTALL  /home/andy/kernel/compat-wireless-2011-11-22/drivers/ssb/ssb.ko
   INSTALL  
/home/andy/kernel/compat-wireless-2011-11-22/net/mac80211/mac80211.ko
   INSTALL  
/home/andy/kernel/compat-wireless-2011-11-22/net/wireless/cfg80211.ko
   DEPMOD  3.1.2-1-desktop
WARNING: /lib/modules/3.1.2-1-desktop/updates/net/wireless/cfg80211.ko 
needs unknown symbol rfkill_unregister
WARNING: /lib/modules/3.1.2-1-desktop/updates/net/wireless/cfg80211.ko 
needs unknown symbol rfkill_blocked
WARNING: /lib/modules/3.1.2-1-desktop/updates/net/wireless/cfg80211.ko 
needs unknown symbol rfkill_destroy
WARNING: /lib/modules/3.1.2-1-desktop/updates/net/wireless/cfg80211.ko 
needs unknown symbol rfkill_resume_polling
WARNING: /lib/modules/3.1.2-1-desktop/updates/net/wireless/cfg80211.ko 
needs unknown symbol rfkill_pause_polling
WARNING: /lib/modules/3.1.2-1-desktop/updates/net/wireless/cfg80211.ko 
needs unknown symbol rfkill_set_hw_state
WARNING: /lib/modules/3.1.2-1-desktop/updates/net/wireless/cfg80211.ko 
needs unknown symbol rfkill_alloc
WARNING: /lib/modules/3.1.2-1-desktop/updates/net/wireless/cfg80211.ko 
needs unknown symbol rfkill_register
WARNING: /lib/modules/3.1.2-1-desktop/updates/net/wireless/cfg80211.ko 
needs unknown symbol rfkill_set_sw_state
WARNING: 
/lib/modules/3.1.2-1-desktop/updates/drivers/net/wireless/b43/b43.ko 
needs unknown symbol sdio_release_host
WARNING: 
/lib/modules/3.1.2-1-desktop/updates/drivers/net/wireless/b43/b43.ko 
needs unknown symbol sdio_disable_func
WARNING: 
/lib/modules/3.1.2-1-desktop/updates/drivers/net/wireless/b43/b43.ko 
needs unknown symbol sdio_set_block_size
WARNING: 
/lib/modules/3.1.2-1-desktop/updates/drivers/net/wireless/b43/b43.ko 
needs unknown symbol pcmcia_disable_device
WARNING: 
/lib/modules/3.1.2-1-desktop/updates/drivers/net/wireless/b43/b43.ko 
needs unknown symbol hwrng_unregister
WARNING: 
/lib/modules/3.1.2-1-desktop/updates/drivers/net/wireless/b43/b43.ko 
needs unknown symbol sdio_claim_host
WARNING: 
/lib/modules/3.1.2-1-desktop/updates/drivers/net/wireless/b43/b43.ko 
needs unknown symbol sdio_register_driver
WARNING: 
/lib/modules/3.1.2-1-desktop/updates/drivers/net/wireless/b43/b43.ko 
needs unknown symbol pcmcia_unregister_driver
WARNING: 
/lib/modules/3.1.2-1-desktop/updates/drivers/net/wireless/b43/b43.ko 
needs unknown symbol pcmcia_map_mem_page
WARNING: 
/lib/modules/3.1.2-1-desktop/updates/drivers/net/wireless/b43/b43.ko 
needs unknown symbol hwrng_register
WARNING: 
/lib/modules/3.1.2-1-desktop/updates/drivers/net/wireless/b43/b43.ko 
needs unknown symbol sdio_release_irq
WARNING: 
/lib/modules/3.1.2-1-desktop/updates/drivers/net/wireless/b43/b43.ko 
needs unknown symbol sdio_unregister_driver
WARNING: 
/lib/modules/3.1.2-1-desktop/updates/drivers/net/wireless/b43/b43.ko 
needs unknown symbol pcmcia_request_window
WARNING: 
/lib/modules/3.1.2-1-desktop/updates/drivers/net/wireless/b43/b43.ko 
needs unknown symbol sdio_claim_irq
WARNING: 
/lib/modules/3.1.2-1-desktop/updates/drivers/net/wireless/b43/b43.ko 
needs unknown symbol sdio_enable_func
WARNING: 
/lib/modules/3.1.2-1-desktop/updates/drivers/net/wireless/b43/b43.ko 
needs unknown symbol pcmcia_register_driver
WARNING: 
/lib/modules/3.1.2-1-desktop/updates/drivers/net/wireless/b43/b43.ko 
needs unknown symbol pcmcia_enable_device
WARNING: /lib/modules/3.1.2-1-desktop/updates/drivers/ssb/ssb.ko needs 
unknown symbol sdio_release_host
WARNING: /lib/modules/3.1.2-1-desktop/updates/drivers/ssb/ssb.ko needs 
unknown symbol sdio_claim_host
WARNING: /lib/modules/3.1.2-1-desktop/updates/drivers/ssb/ssb.ko needs 
unknown symbol sdio_readw
WARNING: /lib/modules/3.1.2-1-desktop/updates/drivers/ssb/ssb.ko needs 
unknown symbol sdio_writew
WARNING: /lib/modules/3.1.2-1-desktop/updates/drivers/ssb/ssb.ko needs 
unknown symbol sdio_readsb
WARNING: /lib/modules/3.1.2-1-desktop/updates/drivers/ssb/ssb.ko needs 
unknown symbol sdio_readl
WARNING: /lib/modules/3.1.2-1-desktop/updates/drivers/ssb/ssb.ko needs 
unknown symbol pcmcia_write_config_byte
WARNING: /lib/modules/3.1.2-1-desktop/updates/drivers/ssb/ssb.ko needs 
unknown symbol sdio_writel
WARNING: /lib/modules/3.1.2-1-desktop/updates/drivers/ssb/ssb.ko needs 
unknown symbol sdio_writesb
WARNING: /lib/modules/3.1.2-1-desktop/updates/drivers/ssb/ssb.ko needs 
unknown symbol pcmcia_read_config_byte
WARNING: /lib/modules/3.1.2-1-desktop/updates/drivers/ssb/ssb.ko needs 
unknown symbol pcmcia_loop_tuple
WARNING: /lib/modules/3.1.2-1-desktop/updates/drivers/ssb/ssb.ko needs 
unknown symbol sdio_readb
WARNING: /lib/modules/3.1.2-1-desktop/updates/drivers/ssb/ssb.ko needs 
unknown symbol sdio_writeb
make[1]: *** [_emodinst_post] Error 1
make[1]: Leaving directory `/usr/src/devel/3.1.2-1.1-desktop'
make: *** [install-modules] Error 2


Any help here would be appreciated. Thanks in advance.

Andy Liebman
