Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:37038 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932208AbdABKNA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Jan 2017 05:13:00 -0500
From: Fabio Coatti <fabio.coatti@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: kernel 4.9 iwlwifi startup error
Date: Mon, 02 Jan 2017 11:12:55 +0100
Message-ID: <2029482.jt8IarKZJs@calvin> (sfid-20170102_111323_431432_1C5A1F30)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all, 
I'm using kernel 4.9 and maybe half of the times I boot my laptop I get the 
error reported below, and the wifi does not work. I have to remove iwlwifi (like 
modprobe -r iwldvm iwlwifi) and insert it again to get things workig again.
This seems a bit random, it does not happens all the times so it could be a 
timing issue or even a flaky hardware (unlikely, as I see only this issue with 
wifi, once it starts it works just fine)
I'm pretty sure to have seen the same behaviour at some point in 4.8.X 
release, but right now I lost the related notes.
Environment:
Distro: gentoo
gcc 5.4.0
HW: Hewlett-Packard HP EliteBook Folio 9470m/18DF, BIOS 68IBD Ver. F.63 
04/26/2016
Intel(R) Core(TM) i5-3427U CPU @ 1.80GHz
Network controller: Intel Corporation Centrino Advanced-N 6235 (rev 24)

Of course if more info is needed, just drop me a note.

I'm not subscribed to mailing lists, so please keep me in CC: for any 
information request.

Many thanks.

Dmesg relevant output:

[lun gen  2 10:41:48 2017] IPv6: ADDRCONF(NETDEV_UP): wlo1: link is not ready
[lun gen  2 10:41:48 2017] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
[lun gen  2 10:41:48 2017] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
[lun gen  2 10:41:48 2017] iwlwifi 0000:03:00.0: Radio type=0x2-0x1-0x0
[lun gen  2 10:41:49 2017] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
[lun gen  2 10:41:49 2017] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
[lun gen  2 10:41:49 2017] iwlwifi 0000:03:00.0: Radio type=0x2-0x1-0x0
[lun gen  2 10:41:49 2017] IPv6: ADDRCONF(NETDEV_UP): wlo1: link is not ready
[lun gen  2 10:41:49 2017] IPv6: ADDRCONF(NETDEV_UP): wlo1: link is not ready
 [lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0: Error sending 
REPLY_SCAN_ABORT_CMD: time out after 2000ms.
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0: Current CMD queue read_ptr 34 
write_ptr 35                                                                                                        
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0: Loaded firmware version: 
18.168.6.1                                                                                                               
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0: Start IWL Error Log Dump:                                                                                                                         
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0: Status: 0x000003CC, count: 6                                                                                                                      
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0: 0x00000084 | 
NMI_INTERRUPT_UNKNOWN                                                                                                                
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0: 0x00010564 | uPc                                                                                                                                  
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0: 0x0001054E | branchlink1                                                                                                                          
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0: 0x00010580 | branchlink2                                                                                                                          
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0: 0x0000DBEA | interruptlink1                                                                                                                       
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0: Microcode SW error detected.  
Restarting 0x2000000.                                                                                               
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0: CSR values:                                                                                                                                       
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0: 0x000005A0 | interruptlink2                                                                                                                       
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0: 0x00000081 | data1                                                                                                                                
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0: 0x07030000 | data2                                                                                                                                
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0: 0x000260A4 | line                                                                                                                                 
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0: (2nd byte of 
CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)                                                                                          
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0: 0x0D000A41 | beacon time                                                                                                                          
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0: 0x0052C5BF | tsf low                                                                                                                              
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0: 0x00000000 | tsf hi                                                                                                                               
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0: 0x00000000 | time gp1                                                                                                                             
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0: 0x005B69CC | time gp2                                                                                                                             
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0: 0x00000000 | time gp3                                                                                                                             
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0: 0x754312A8 | uCode version                                                                                                                        
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0: 0x000000B0 | hw version                                                                                                                           
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0: 0x00484B00 | board version                                                                                                                        
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0: 0x0000001C | hcmd                                                                                                                                 
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0: 0x27863040 | isr0                                                                                                                                 
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0: 0x0181E000 | isr1                                                                                                                                 
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0: 0x00000E02 | isr2                                                                                                                                 
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0: 0x0147FC43 | isr3                                                                                                                                 
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0: 0x00000000 | isr4                                                                                                                                 
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0: 0x00000000 | isr_pref                                                                                                                             
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0: 0x000260A4 | wait_event                                                                                                                           
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0: 0x00000050 | l2p_control                                                                                                                          
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0: 0x00000032 | l2p_duration                                                                                                                         
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0: 0x0000003F | l2p_mhvalid                                                                                                                          
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0:        CSR_HW_IF_CONFIG_REG: 
0X00484b00                                                                                                           
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0: 0x00101040 | l2p_addr_match                                                                                                                       
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0: 0x00000005 | lmpm_pmg_sel                                                                                                                         
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0: 0x13011136 | timestamp                                                                                                                            
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0: 0x00000818 | flow_handler                                                                                                                         
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0:          CSR_INT_COALESCING: 
0X00000040                                                                                                           
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0:                     CSR_INT: 
0X00000000                                                                                                           
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0:                CSR_INT_MASK: 
0X00000000                                                                                                           
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0:           CSR_FH_INT_STATUS: 
0X00000000                                                                                                           
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0:                 CSR_GPIO_IN: 
0X00000030                                                                                                           
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0:                   CSR_RESET: 
0X00000000                                                                                                           
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0:                CSR_GP_CNTRL: 
0X080403cd                                                                                                           
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0:                  CSR_HW_REV: 
0X000000b0                                                                                                           
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0:              CSR_EEPROM_REG: 
0X60f10ffd                                                                                                           
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0:               CSR_EEPROM_GP: 
0X90000801                                                                                                           
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0:              CSR_OTP_GP_REG: 
0X00030001                                                                                                           
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0:                 CSR_GIO_REG: 
0X00080042                                                                                                           
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0:            CSR_GP_UCODE_REG: 
0X000004bf                                                                                                           
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0:           CSR_GP_DRIVER_REG: 
0X00000000                                                                                                           
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP1: 
0X00000000                                                                                                           
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP2: 
0X00000000                                                                                                           
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0: Start IWL Event Log Dump: 
display last 1 entries                                                                                                  
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0:                 CSR_LED_REG: 
0X00000040                                                                                                           
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0:        CSR_DRAM_INT_TBL_REG: 
0X880fffff                                                                                                           
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0:        CSR_GIO_CHICKEN_BITS: 
0X27800200                                                                                                           
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0:             CSR_ANA_PLL_CFG: 
0X00000000                                                                                                           
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0:      CSR_MONITOR_STATUS_REG: 
0X43f7f757                                                                                                           
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0: EVT_LOGT:
0005990856:0x0000010c:0123                                                                                                               
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0:           CSR_HW_REV_WA_REG: 
0X0001001a                                                                                                           
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0: Command REPLY_RXON failed: FW 
Error                                                                                                               
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0: Error clearing ASSOC_MSK on 
BSS (-5)                                                                                                              
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0:        CSR_DBG_HPET_MEM_REG: 
0Xffff0000                                                                                                           
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0: FH register values:                                                                                                                               
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0:         
FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X0ffffd00                                                                                                  
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0:        
FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X00ffffe0                                                                                                  
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0:                  
FH_RSCSR_CHNL0_WPTR: 0X00000008                                                                                                  
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0:         
FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X00000000                                                                                                  
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0:          
FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc                                                                                                  
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0:            
FH_MEM_RSSR_RX_STATUS_REG: 0X07030000                                                                                                  
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0:    
FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000                                                                                                  
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0:                
FH_TSSR_TX_STATUS_REG: 0X07ff0001                                                                                                  
[lun gen  2 10:41:55 2017] ------------[ cut here ]------------
[lun gen  2 10:41:55 2017] WARNING: CPU: 3 PID: 2275 at drivers/net/wireless/
intel/iwlwifi/pcie/trans.c:1864 iwl_trans_pcie_grab_nic_access+0xe6/0xf0 
[iwlwifi]
[lun gen  2 10:41:55 2017] Timeout waiting for hardware access (CSR_GP_CNTRL 
0x080003d8)
[lun gen  2 10:41:55 2017] Modules linked in: bnep btusb btintel bluetooth 
uvcvideo videobuf2_vmalloc videobuf2_memops joydev videobuf2_v4l2 hp_wmi 
sparse_keymap videodev cdc_wdm cdc_acm videobuf2_core snd_usb_audio 
snd_usbmidi_lib snd_rawmidi snd_seq_device uas intel_rapl x86_pkg_temp_thermal 
algif_skcipher intel_powerclamp coretemp kvm_intel kvm irqbypass 
crct10dif_pclmul crc32_pclmul snd_hda_codec_hdmi snd_hda_codec_generic 
snd_hda_intel snd_hda_codec psmouse snd_hwdep iwldvm snd_hda_core iwlwifi 
snd_pcm snd_timer snd soundcore mei_me mei hp_accel wmi hp_wireless lis3lv02d 
sch_fq_codel vboxpci(OE) vboxnetadp(OE) vboxnetflt(OE) vboxdrv(OE) dm_zero 
dm_thin_pool dm_persistent_data dm_bio_prison dm_service_time dm_round_robin 
dm_queue_length dm_multipath dm_delay virtio_pci virtio_blk virtio_balloon 
vxlan ip6_udp_tunnel
[lun gen  2 10:41:55 2017]  udp_tunnel macvlan virtio_net virtio_ring virtio 
fuse overlay linear raid0 dm_raid dm_snapshot dm_bufio dm_mirror dm_region_hash 
dm_log hid_apple ohci_pci ohci_hcd uhci_hcd
[lun gen  2 10:41:55 2017] CPU: 3 PID: 2275 Comm: irq/34-iwlwifi Tainted: G           
OE   4.9.0-cova #2
[lun gen  2 10:41:55 2017] Hardware name: Hewlett-Packard HP EliteBook Folio 
9470m/18DF, BIOS 68IBD Ver. F.63 04/26/2016
[lun gen  2 10:41:55 2017]  0000000000000000 ffffffffa84cd5fd ffffba42002bfcf8 
0000000000000000
[lun gen  2 10:41:55 2017]  ffffffffa80d2ee4 ffff9ac674138018 ffffba42002bfd50 
ffff9ac67413fe80
[lun gen  2 10:41:55 2017]  ffffba42002bfd88 0000000002000000 ffff9ac66fd26600 
ffffffffa80d2f5a
[lun gen  2 10:41:55 2017] Call Trace:
[lun gen  2 10:41:55 2017]  [<ffffffffa84cd5fd>] ? dump_stack+0x46/0x59
[lun gen  2 10:41:55 2017]  [<ffffffffa80d2ee4>] ? __warn+0xb4/0xd0
[lun gen  2 10:41:55 2017]  [<ffffffffa80d2f5a>] ? warn_slowpath_fmt+0x5a/0x80
[lun gen  2 10:41:55 2017]  [<ffffffffc045f0fa>] ? iwl_poll_bit+0x2a/0x70 
[iwlwifi]
[lun gen  2 10:41:55 2017]  [<ffffffffc046d4a6>] ? 
iwl_trans_pcie_grab_nic_access+0xe6/0xf0 [iwlwifi]
[lun gen  2 10:41:55 2017]  [<ffffffffc045f167>] ? iwl_read_direct32+0x27/0x70 
[iwlwifi]
[lun gen  2 10:41:55 2017]  [<ffffffffc045f7a7>] ? iwl_dump_fh+0xa7/0x220 
[iwlwifi]
[lun gen  2 10:41:55 2017]  [<ffffffffc0464cdf>] ? iwl_pcie_irq_handle_error
+0x2f/0x130 [iwlwifi]
[lun gen  2 10:41:55 2017]  [<ffffffffc0466fa9>] ? iwl_pcie_irq_handler
+0x539/0x730 [iwlwifi]
[lun gen  2 10:41:55 2017]  [<ffffffffa8117af0>] ? irq_forced_thread_fn
+0x60/0x60
[lun gen  2 10:41:55 2017]  [<ffffffffa8117b06>] ? irq_thread_fn+0x16/0x40
[lun gen  2 10:41:55 2017]  [<ffffffffa8117db9>] ? irq_thread+0x139/0x1c0
[lun gen  2 10:41:55 2017]  [<ffffffffa8117be0>] ? wake_threads_waitq
+0x30/0x30
[lun gen  2 10:41:55 2017]  [<ffffffffa8117c80>] ? irq_thread_dtor+0xa0/0xa0
[lun gen  2 10:41:55 2017]  [<ffffffffa80ee2f9>] ? kthread+0xc9/0xe0
[lun gen  2 10:41:55 2017]  [<ffffffffa80ee230>] ? kthread_park+0x50/0x50
[lun gen  2 10:41:55 2017]  [<ffffffffa8a20ac2>] ? ret_from_fork+0x22/0x30
[lun gen  2 10:41:55 2017] ---[ end trace f47879f89784c9ca ]---
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0:                 
FH_TSSR_TX_ERROR_REG: 0X5a5a5a5a
[lun gen  2 10:41:55 2017] ieee80211 phy0: Hardware restart was requested
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0: Radio type=0x2-0x1-0x0
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0: Radio type=0x2-0x1-0x0
[lun gen  2 10:41:55 2017] IPv6: ADDRCONF(NETDEV_UP): wlo1: link is not ready
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
[lun gen  2 10:41:55 2017] iwlwifi 0000:03:00.0: Radio type=0x2-0x1-0x0
[lun gen  2 10:42:00 2017] iwlwifi 0000:03:00.0: Failed to load firmware chunk!
[lun gen  2 10:42:00 2017] iwlwifi 0000:03:00.0: Could not load the [0] uCode 
section                                                                                                              
[lun gen  2 10:42:00 2017] iwlwifi 0000:03:00.0: Failed to run INIT ucode: -110                                                                                                                    
[lun gen  2 10:42:00 2017] iwlwifi 0000:03:00.0: Unable to initialize device.                                                                                                                      
[lun gen  2 10:42:00 2017] ------------[ cut here ]------------
[lun gen  2 10:42:00 2017] WARNING: CPU: 2 PID: 307 at net/mac80211/util.c:
1863 ieee80211_reconfig+0x231/0xc30
[lun gen  2 10:42:00 2017] Hardware became unavailable during restart.
[lun gen  2 10:42:00 2017] Modules linked in: bnep btusb btintel bluetooth 
uvcvideo videobuf2_vmalloc videobuf2_memops joydev videobuf2_v4l2 hp_wmi 
sparse_keymap videodev cdc_wdm cdc_acm videobuf2_core snd_usb_audio 
snd_usbmidi_lib snd_rawmidi snd_seq_device uas intel_rapl x86_pkg_temp_thermal 
algif_skcipher intel_powerclamp coretemp kvm_intel kvm irqbypass 
crct10dif_pclmul crc32_pclmul snd_hda_codec_hdmi snd_hda_codec_generic 
snd_hda_intel snd_hda_codec psmouse snd_hwdep iwldvm snd_hda_core iwlwifi 
snd_pcm snd_timer snd soundcore mei_me mei hp_accel wmi hp_wireless lis3lv02d 
sch_fq_codel vboxpci(OE) vboxnetadp(OE) vboxnetflt(OE) vboxdrv(OE) dm_zero 
dm_thin_pool dm_persistent_data dm_bio_prison dm_service_time dm_round_robin 
dm_queue_length dm_multipath dm_delay virtio_pci virtio_blk virtio_balloon 
vxlan ip6_udp_tunnel
[lun gen  2 10:42:00 2017]  udp_tunnel macvlan virtio_net virtio_ring virtio 
fuse overlay linear raid0 dm_raid dm_snapshot dm_bufio dm_mirror dm_region_hash 
dm_log hid_apple ohci_pci ohci_hcd uhci_hcd
[lun gen  2 10:42:00 2017] CPU: 2 PID: 307 Comm: kworker/2:3 Tainted: G        
W  OE   4.9.0-cova #2
[lun gen  2 10:42:00 2017] Hardware name: Hewlett-Packard HP EliteBook Folio 
9470m/18DF, BIOS 68IBD Ver. F.63 04/26/2016
[lun gen  2 10:42:00 2017] Workqueue: events_freezable ieee80211_restart_work
[lun gen  2 10:42:00 2017]  0000000000000000 ffffffffa84cd5fd ffffba4200f0fd38 
0000000000000000
[lun gen  2 10:42:00 2017]  ffffffffa80d2ee4 ffff9ac674198700 ffffba4200f0fd90 
ffff9ac6741993f0
[lun gen  2 10:42:00 2017]  ffff9ac674198700 0000000000000000 0000000000000000 
ffffffffa80d2f5a
[lun gen  2 10:42:00 2017] Call Trace:
[lun gen  2 10:42:00 2017]  [<ffffffffa84cd5fd>] ? dump_stack+0x46/0x59
[lun gen  2 10:42:00 2017]  [<ffffffffa80d2ee4>] ? __warn+0xb4/0xd0
[lun gen  2 10:42:00 2017]  [<ffffffffa80d2f5a>] ? warn_slowpath_fmt+0x5a/0x80
[lun gen  2 10:42:00 2017]  [<ffffffffa8a02ee1>] ? ieee80211_reconfig
+0x231/0xc30
[lun gen  2 10:42:00 2017]  [<ffffffffa8124fbf>] ? try_to_del_timer_sync+0x4f/
0x80
[lun gen  2 10:42:00 2017]  [<ffffffffa89d3638>] ? ieee80211_restart_work
+0x88/0xc0
[lun gen  2 10:42:00 2017]  [<ffffffffa80e8d4f>] ? process_one_work+0x11f/
0x3a0
[lun gen  2 10:42:00 2017]  [<ffffffffa80e9012>] ? worker_thread+0x42/0x4c0
[lun gen  2 10:42:00 2017]  [<ffffffffa80e8fd0>] ? process_one_work
+0x3a0/0x3a0
[lun gen  2 10:42:00 2017]  [<ffffffffa80ee2f9>] ? kthread+0xc9/0xe0
[lun gen  2 10:42:00 2017]  [<ffffffffa80ee230>] ? kthread_park+0x50/0x50
[lun gen  2 10:42:00 2017]  [<ffffffffa8a20ac2>] ? ret_from_fork+0x22/0x30
[lun gen  2 10:42:00 2017] ---[ end trace f47879f89784c9cb ]---
[lun gen  2 10:42:00 2017] ------------[ cut here ]------------
[lun gen  2 10:42:00 2017] WARNING: CPU: 2 PID: 307 at net/mac80211/driver-
ops.h:17 ieee80211_do_stop+0x577/0x880
[lun gen  2 10:42:00 2017] wlo1:  Failed check-sdata-in-driver check, flags: 
0x0
[lun gen  2 10:42:00 2017] Modules linked in: bnep btusb btintel bluetooth 
uvcvideo videobuf2_vmalloc videobuf2_memops joydev videobuf2_v4l2 hp_wmi 
sparse_keymap videodev cdc_wdm cdc_acm videobuf2_core snd_usb_audio 
snd_usbmidi_lib snd_rawmidi snd_seq_device uas intel_rapl x86_pkg_temp_thermal 
algif_skcipher intel_powerclamp coretemp kvm_intel kvm irqbypass 
crct10dif_pclmul crc32_pclmul snd_hda_codec_hdmi snd_hda_codec_generic 
snd_hda_intel snd_hda_codec psmouse snd_hwdep iwldvm snd_hda_core iwlwifi 
snd_pcm snd_timer snd soundcore mei_me mei hp_accel wmi hp_wireless lis3lv02d 
sch_fq_codel vboxpci(OE) vboxnetadp(OE) vboxnetflt(OE) vboxdrv(OE) dm_zero 
dm_thin_pool dm_persistent_data dm_bio_prison dm_service_time dm_round_robin 
dm_queue_length dm_multipath dm_delay virtio_pci virtio_blk virtio_balloon 
vxlan ip6_udp_tunnel
[lun gen  2 10:42:00 2017]  udp_tunnel macvlan virtio_net virtio_ring virtio 
fuse overlay linear raid0 dm_raid dm_snapshot dm_bufio dm_mirror dm_region_hash 
dm_log hid_apple ohci_pci ohci_hcd uhci_hcd
[lun gen  2 10:42:00 2017] CPU: 2 PID: 307 Comm: kworker/2:3 Tainted: G        
W  OE   4.9.0-cova #2
[lun gen  2 10:42:00 2017] Hardware name: Hewlett-Packard HP EliteBook Folio 
9470m/18DF, BIOS 68IBD Ver. F.63 04/26/2016
[lun gen  2 10:42:00 2017] Workqueue: events_freezable ieee80211_restart_work
[lun gen  2 10:42:00 2017]  0000000000000000 ffffffffa84cd5fd ffffba4200f0fc00 
0000000000000000
[lun gen  2 10:42:00 2017]  ffffffffa80d2ee4 ffff9ac6742128c0 ffffba4200f0fc58 
0000000000000000
[lun gen  2 10:42:00 2017]  ffff9ac674198700 ffff9ac674198ee8 ffff9ac674213218 
ffffffffa80d2f5a
[lun gen  2 10:42:00 2017] Call Trace:
[lun gen  2 10:42:00 2017]  [<ffffffffa84cd5fd>] ? dump_stack+0x46/0x59
[lun gen  2 10:42:00 2017]  [<ffffffffa80d2ee4>] ? __warn+0xb4/0xd0
[lun gen  2 10:42:00 2017]  [<ffffffffa80d2f5a>] ? warn_slowpath_fmt+0x5a/0x80
[lun gen  2 10:42:00 2017]  [<ffffffffa89e8177>] ? ieee80211_do_stop
+0x577/0x880
[lun gen  2 10:42:00 2017]  [<ffffffffa88b00c5>] ? dev_deactivate_many
+0x1f5/0x230
[lun gen  2 10:42:00 2017]  [<ffffffffa89e8491>] ? ieee80211_stop+0x11/0x20
[lun gen  2 10:42:00 2017]  [<ffffffffa8886502>] ? __dev_close_many+0x82/0xe0
[lun gen  2 10:42:00 2017]  [<ffffffffa88865e8>] ? dev_close_many+0x88/0x130
[lun gen  2 10:42:00 2017]  [<ffffffffa888b29f>] ? dev_close.part.17+0x3f/0x70
[lun gen  2 10:42:00 2017]  [<ffffffffa888b2de>] ? dev_close+0xe/0x20
[lun gen  2 10:42:00 2017]  [<ffffffffa89acbae>] ? 
cfg80211_shutdown_all_interfaces+0x3e/0xb0
[lun gen  2 10:42:00 2017]  [<ffffffffa8a02d54>] ? ieee80211_reconfig
+0xa4/0xc30
[lun gen  2 10:42:00 2017]  [<ffffffffa8124fbf>] ? try_to_del_timer_sync+0x4f/
0x80
[lun gen  2 10:42:00 2017]  [<ffffffffa89d3638>] ? ieee80211_restart_work
+0x88/0xc0
[lun gen  2 10:42:00 2017]  [<ffffffffa80e8d4f>] ? process_one_work+0x11f/
0x3a0
[lun gen  2 10:42:00 2017]  [<ffffffffa80e9012>] ? worker_thread+0x42/0x4c0
[lun gen  2 10:42:00 2017]  [<ffffffffa80e8fd0>] ? process_one_work
+0x3a0/0x3a0
[lun gen  2 10:42:00 2017]  [<ffffffffa80ee2f9>] ? kthread+0xc9/0xe0
[lun gen  2 10:42:00 2017]  [<ffffffffa80ee230>] ? kthread_park+0x50/0x50
[lun gen  2 10:42:00 2017]  [<ffffffffa8a20ac2>] ? ret_from_fork+0x22/0x30
[lun gen  2 10:42:00 2017] ---[ end trace f47879f89784c9cc ]---
[lun gen  2 10:42:00 2017] ------------[ cut here ]------------
[lun gen  2 10:42:00 2017] WARNING: CPU: 2 PID: 307 at net/mac80211/driver-
ops.c:39 ieee80211_do_stop+0x560/0x880
[lun gen  2 10:42:00 2017] Modules linked in: bnep btusb btintel bluetooth 
uvcvideo videobuf2_vmalloc videobuf2_memops joydev videobuf2_v4l2 hp_wmi 
sparse_keymap videodev cdc_wdm cdc_acm videobuf2_core snd_usb_audio 
snd_usbmidi_lib snd_rawmidi snd_seq_device uas intel_rapl x86_pkg_temp_thermal 
algif_skcipher intel_powerclamp coretemp kvm_intel kvm irqbypass 
crct10dif_pclmul crc32_pclmul snd_hda_codec_hdmi snd_hda_codec_generic 
snd_hda_intel snd_hda_codec psmouse snd_hwdep iwldvm snd_hda_core iwlwifi 
snd_pcm snd_timer snd soundcore mei_me mei hp_accel wmi hp_wireless lis3lv02d 
sch_fq_codel vboxpci(OE) vboxnetadp(OE) vboxnetflt(OE) vboxdrv(OE) dm_zero 
dm_thin_pool dm_persistent_data dm_bio_prison dm_service_time dm_round_robin 
dm_queue_length dm_multipath dm_delay virtio_pci virtio_blk virtio_balloon 
vxlan ip6_udp_tunnel
[lun gen  2 10:42:00 2017]  udp_tunnel macvlan virtio_net virtio_ring virtio 
fuse overlay linear raid0 dm_raid dm_snapshot dm_bufio dm_mirror dm_region_hash 
dm_log hid_apple ohci_pci ohci_hcd uhci_hcd
[lun gen  2 10:42:00 2017] CPU: 2 PID: 307 Comm: kworker/2:3 Tainted: G        
W  OE   4.9.0-cova #2
[lun gen  2 10:42:00 2017] Hardware name: Hewlett-Packard HP EliteBook Folio 
9470m/18DF, BIOS 68IBD Ver. F.63 04/26/2016
[lun gen  2 10:42:00 2017] Workqueue: events_freezable ieee80211_restart_work
[lun gen  2 10:42:00 2017]  0000000000000000 ffffffffa84cd5fd 0000000000000000 
0000000000000000
[lun gen  2 10:42:00 2017]  ffffffffa80d2ee4 ffff9ac6742128c0 ffff9ac674198ff0 
0000000000000000
[lun gen  2 10:42:00 2017]  ffff9ac674198700 ffff9ac674198ee8 ffff9ac674213218 
ffffffffa89e8160
[lun gen  2 10:42:00 2017] Call Trace:
[lun gen  2 10:42:00 2017]  [<ffffffffa84cd5fd>] ? dump_stack+0x46/0x59
[lun gen  2 10:42:00 2017]  [<ffffffffa80d2ee4>] ? __warn+0xb4/0xd0
[lun gen  2 10:42:00 2017]  [<ffffffffa89e8160>] ? ieee80211_do_stop
+0x560/0x880
[lun gen  2 10:42:00 2017]  [<ffffffffa88b00c5>] ? dev_deactivate_many
+0x1f5/0x230
[lun gen  2 10:42:00 2017]  [<ffffffffa89e8491>] ? ieee80211_stop+0x11/0x20
[lun gen  2 10:42:00 2017]  [<ffffffffa8886502>] ? __dev_close_many+0x82/0xe0
[lun gen  2 10:42:00 2017]  [<ffffffffa88865e8>] ? dev_close_many+0x88/0x130
[lun gen  2 10:42:00 2017]  [<ffffffffa888b29f>] ? dev_close.part.17+0x3f/0x70
[lun gen  2 10:42:00 2017]  [<ffffffffa888b2de>] ? dev_close+0xe/0x20
[lun gen  2 10:42:00 2017]  [<ffffffffa89acbae>] ? 
cfg80211_shutdown_all_interfaces+0x3e/0xb0
[lun gen  2 10:42:00 2017]  [<ffffffffa8a02d54>] ? ieee80211_reconfig
+0xa4/0xc30
[lun gen  2 10:42:00 2017]  [<ffffffffa8124fbf>] ? try_to_del_timer_sync+0x4f/
0x80
[lun gen  2 10:42:00 2017]  [<ffffffffa89d3638>] ? ieee80211_restart_work
+0x88/0xc0
[lun gen  2 10:42:00 2017]  [<ffffffffa80e8d4f>] ? process_one_work+0x11f/
0x3a0
[lun gen  2 10:42:00 2017]  [<ffffffffa80e9012>] ? worker_thread+0x42/0x4c0
[lun gen  2 10:42:00 2017]  [<ffffffffa80e8fd0>] ? process_one_work
+0x3a0/0x3a0
[lun gen  2 10:42:00 2017]  [<ffffffffa80ee2f9>] ? kthread+0xc9/0xe0
[lun gen  2 10:42:00 2017]  [<ffffffffa80ee230>] ? kthread_park+0x50/0x50
[lun gen  2 10:42:00 2017]  [<ffffffffa8a20ac2>] ? ret_from_fork+0x22/0x30
[lun gen  2 10:42:00 2017] ---[ end trace f47879f89784c9cd ]---

-- 
Fabio
