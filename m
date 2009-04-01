Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.231]:17561 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321AbZDACIE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2009 22:08:04 -0400
Received: by rv-out-0506.google.com with SMTP id g37so1930016rvb.5
        for <linux-wireless@vger.kernel.org>; Tue, 31 Mar 2009 19:08:02 -0700 (PDT)
Message-ID: <49D2CC77.808@gmail.com> (sfid-20090401_040819_508880_5D16B01D)
Date: Tue, 31 Mar 2009 22:07:51 -0400
From: David Ellingsworth <david@identd.dyndns.org>
Reply-To: david@identd.dyndns.org
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: bcm43xx-dev@lists.berlios.de, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43: Implement fullmac-mode support
References: <200904010101.44380.mb@bu3sch.de> <49D2C52D.5030207@gmail.com>
In-Reply-To: <49D2C52D.5030207@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Ellingsworth wrote:
> Michael Buesch wrote:
>> Recent work on the device firmware discovered a completely new hardware
>> mode for b43 devices.
>> All b43 devices have a bit in the MAC-control register to enable true
>> hardware-fullMAC support. In fullmac mode the MAC and PHY is 
>> completely serviced
>> by the firmware, so no driver support is required anymore.
>>
>> Full hardware MAC support has advantages and disadvantages:
>>
>> PRO:
>> - The b43 driver does support _all_ devices (also 802.11n) in STA and 
>> AP mode.
>> - The driver code is a lot simpler for the fullmac case. (It skips 
>> all of
>>   the software MAC and PHY init).
>> - People finally stop poking me to implement the N-PHY and LP-PHY 
>> code, yay.
>>
>> CON:
>> - Packet injection is not supported in fullmac mode, yet. It's on
>>   the TODO list with deadline 1.4.2010.
>>
>> The feature currently is disabled by default, because it isn't tested 
>> enough.
>> It can be enabled at modprobe time with the "fullmac=1" module 
>> parameter.
>>
>> Signed-off-by: Michael Buesch <mb@bu3sch.de>
>>
>> ---
>>
>> John, please queue this patch for 3.6.31.
>>
>>
>> Index: wireless-testing/drivers/net/wireless/b43/b43.h
>> ===================================================================
>> --- wireless-testing.orig/drivers/net/wireless/b43/b43.h    
>> 2009-04-01 00:00:18.000000000 +0200
>> +++ wireless-testing/drivers/net/wireless/b43/b43.h    2009-04-01 
>> 00:00:20.000000000 +0200
>> @@ -347,6 +347,7 @@ enum {
>>  #define B43_MACCTL_ENABLED        0x00000001    /* MAC Enabled */
>>  #define B43_MACCTL_PSM_RUN        0x00000002    /* Run Microcode */
>>  #define B43_MACCTL_PSM_JMP0        0x00000004    /* Microcode jump 
>> to 0 */
>> +#define B43_MACCTL_FULLMAC        0x00000008    /* Enable hardware 
>> full-MAC support */
>>  #define B43_MACCTL_SHM_ENABLED        0x00000100    /* SHM Enabled */
>>  #define B43_MACCTL_SHM_UPPER        0x00000200    /* SHM Upper */
>>  #define B43_MACCTL_IHR_ENABLED        0x00000400    /* IHR Region 
>> Enabled */
>> Index: wireless-testing/drivers/net/wireless/b43/main.c
>> ===================================================================
>> --- wireless-testing.orig/drivers/net/wireless/b43/main.c    
>> 2009-04-01 00:00:18.000000000 +0200
>> +++ wireless-testing/drivers/net/wireless/b43/main.c    2009-04-01 
>> 00:00:20.000000000 +0200
>> @@ -63,6 +63,10 @@ MODULE_LICENSE("GPL");
>>  MODULE_FIRMWARE(B43_SUPPORTED_FIRMWARE_ID);
>>  
>>  
>> +static int modparam_fullmac;
>> +module_param_named(fullmac, modparam_fullmac, int, 0444);
>> +MODULE_PARM_DESC(fullmac, "Switch the hardware into fullmac mode");
>> +
>>  static int modparam_bad_frames_preempt;
>>  module_param_named(bad_frames_preempt, modparam_bad_frames_preempt, 
>> int, 0444);
>>  MODULE_PARM_DESC(bad_frames_preempt,
>> @@ -4113,6 +4117,9 @@ static void b43_wireless_core_exit(struc
>>          return;
>>      b43_set_status(dev, B43_STAT_UNINIT);
>>  
>> +    if (modparam_fullmac)
>> +        goto ssb_disable;
>> +
>>      /* Stop the microcode PSM. */
>>      macctl = b43_read32(dev, B43_MMIO_MACCTL);
>>      macctl &= ~B43_MACCTL_PSM_RUN;
>> @@ -4132,6 +4139,7 @@ static void b43_wireless_core_exit(struc
>>          dev->wl->current_beacon = NULL;
>>      }
>>  
>> +ssb_disable:
>>      ssb_device_disable(dev->dev, 0);
>>      ssb_bus_may_powerdown(dev->dev->bus);
>>  }
>> @@ -4157,6 +4165,14 @@ static int b43_wireless_core_init(struct
>>          b43_wireless_core_reset(dev, tmp);
>>      }
>>  
>> +    if (modparam_fullmac) {
>> +        b43_write32(dev, B43_MMIO_MACCTL,
>> +                b43_read32(dev, B43_MMIO_MACCTL)
>> +                | B43_MACCTL_FULLMAC);
>> +        err = 0;
>> +        goto out;
>> +    }
>> +
>>      /* Reset all data structures. */
>>      setup_struct_wldev_for_init(dev);
>>      phy->ops->prepare_structs(dev);
>>
>>   
> Michael Buesch wrote:
>> Recent work on the device firmware discovered a completely new hardware
>> mode for b43 devices.
>> All b43 devices have a bit in the MAC-control register to enable true
>> hardware-fullMAC support. In fullmac mode the MAC and PHY is 
>> completely serviced
>> by the firmware, so no driver support is required anymore.
>>
>> Full hardware MAC support has advantages and disadvantages:
>>
>> PRO:
>> - The b43 driver does support _all_ devices (also 802.11n) in STA and 
>> AP mode.
>> - The driver code is a lot simpler for the fullmac case. (It skips 
>> all of
>>   the software MAC and PHY init).
>> - People finally stop poking me to implement the N-PHY and LP-PHY 
>> code, yay.
>>
>> CON:
>> - Packet injection is not supported in fullmac mode, yet. It's on
>>   the TODO list with deadline 1.4.2010.
>>
>> The feature currently is disabled by default, because it isn't tested 
>> enough.
>> It can be enabled at modprobe time with the "fullmac=1" module 
>> parameter.
>>
>> Signed-off-by: Michael Buesch <mb@bu3sch.de>
>>
>> ---
>>
>> John, please queue this patch for 3.6.31.
>>
>>
>> Index: wireless-testing/drivers/net/wireless/b43/b43.h
>> ===================================================================
>> --- wireless-testing.orig/drivers/net/wireless/b43/b43.h    
>> 2009-04-01 00:00:18.000000000 +0200
>> +++ wireless-testing/drivers/net/wireless/b43/b43.h    2009-04-01 
>> 00:00:20.000000000 +0200
>> @@ -347,6 +347,7 @@ enum {
>>  #define B43_MACCTL_ENABLED        0x00000001    /* MAC Enabled */
>>  #define B43_MACCTL_PSM_RUN        0x00000002    /* Run Microcode */
>>  #define B43_MACCTL_PSM_JMP0        0x00000004    /* Microcode jump 
>> to 0 */
>> +#define B43_MACCTL_FULLMAC        0x00000008    /* Enable hardware 
>> full-MAC support */
>>  #define B43_MACCTL_SHM_ENABLED        0x00000100    /* SHM Enabled */
>>  #define B43_MACCTL_SHM_UPPER        0x00000200    /* SHM Upper */
>>  #define B43_MACCTL_IHR_ENABLED        0x00000400    /* IHR Region 
>> Enabled */
>> Index: wireless-testing/drivers/net/wireless/b43/main.c
>> ===================================================================
>> --- wireless-testing.orig/drivers/net/wireless/b43/main.c    
>> 2009-04-01 00:00:18.000000000 +0200
>> +++ wireless-testing/drivers/net/wireless/b43/main.c    2009-04-01 
>> 00:00:20.000000000 +0200
>> @@ -63,6 +63,10 @@ MODULE_LICENSE("GPL");
>>  MODULE_FIRMWARE(B43_SUPPORTED_FIRMWARE_ID);
>>  
>>  
>> +static int modparam_fullmac;
>> +module_param_named(fullmac, modparam_fullmac, int, 0444);
>> +MODULE_PARM_DESC(fullmac, "Switch the hardware into fullmac mode");
>> +
>>  static int modparam_bad_frames_preempt;
>>  module_param_named(bad_frames_preempt, modparam_bad_frames_preempt, 
>> int, 0444);
>>  MODULE_PARM_DESC(bad_frames_preempt,
>> @@ -4113,6 +4117,9 @@ static void b43_wireless_core_exit(struc
>>          return;
>>      b43_set_status(dev, B43_STAT_UNINIT);
>>  
>> +    if (modparam_fullmac)
>> +        goto ssb_disable;
>> +
>>      /* Stop the microcode PSM. */
>>      macctl = b43_read32(dev, B43_MMIO_MACCTL);
>>      macctl &= ~B43_MACCTL_PSM_RUN;
>> @@ -4132,6 +4139,7 @@ static void b43_wireless_core_exit(struc
>>          dev->wl->current_beacon = NULL;
>>      }
>>  
>> +ssb_disable:
>>      ssb_device_disable(dev->dev, 0);
>>      ssb_bus_may_powerdown(dev->dev->bus);
>>  }
>> @@ -4157,6 +4165,14 @@ static int b43_wireless_core_init(struct
>>          b43_wireless_core_reset(dev, tmp);
>>      }
>>  
>> +    if (modparam_fullmac) {
>> +        b43_write32(dev, B43_MMIO_MACCTL,
>> +                b43_read32(dev, B43_MMIO_MACCTL)
>> +                | B43_MACCTL_FULLMAC);
>> +        err = 0;
>> +        goto out;
>> +    }
>> +
>>      /* Reset all data structures. */
>>      setup_struct_wldev_for_init(dev);
>>      phy->ops->prepare_structs(dev);
>>
>>   
> Enabling the fullmac option causes the following oops while trying to 
> bring up the interface as an AP using hostapd. This oops does not 
> occur if the fullmac option is not set. The stack trace is as follows:
>
> kernel: [  546.416409] Oops: 0000 [#1]
> kernel: [  546.416493] last sysfs file: 
> /sys/devices/virtual/input/input4/capabilities/sw
> kernel: [  546.420045] Process phy1 (pid: 3581, ti=cdb62000 
> task=cc5da810 task.ti=cdb62000)
> kernel: [  546.420045] Stack:
> kernel: [  546.420045]  cf44a00a cd135000 cf446fa9 cd135274 ccd3c720 
> cf446ec3 00000000 c0127664
> kernel: [  546.420045]  ccd3c720 c0127a29 ccd3c728 c0127ad6 00000000 
> cc5da810 c012a29a cdb63fc4
> kernel: [  546.420045] Call Trace:
> kernel: [  546.420045]  [<cf444ab8>] b43_mac_suspend+0x1e/0xbf [b43]
> kernel: [  546.420045]  [<cf44a00a>] b43_gphy_op_pwork_15sec+0xf/0x17 
> [b43]
> kernel: [  546.420045]  [<cf446fa9>] 
> b43_periodic_work_handler+0xe6/0x13c [b43]
> kernel: [  546.420045]  [<cf446ec3>] 
> b43_periodic_work_handler+0x0/0x13c [b43]
> kernel: [  546.420045]  [<c0127664>] run_workqueue+0x74/0xec
> kernel: [  546.420045]  [<c0127a29>] worker_thread+0x0/0xb8
> kernel: [  546.420045]  [<c0127ad6>] worker_thread+0xad/0xb8
> kernel: [  546.420045]  [<c012a29a>] autoremove_wake_function+0x0/0x2d
> kernel: [  546.420045]  [<c0127a29>] worker_thread+0x0/0xb8
> kernel: [  546.420045]  [<c0129eb7>] kthread+0x36/0x5a
> kernel: [  546.420045]  [<c0129e81>] kthread+0x0/0x5a
> kernel: [  546.420045]  [<c01038e7>] kernel_thread_helper+0x7/0x10
> kernel: [  546.420045] Code: 89 1c 24 74 20 39 5f 58 0f 89 73 01 00 00 
> 89 f0 e8 c8 e9 ff ff 89 f0 31 d2 83 c4 10 5b 5e 5f 5d e9 4c fe ff ff 
> 8b 47 50 8d 58 f4 <8b> 43 0c c6 44 24 0f 00 83 e8 0c 89 44 24 08 8d 47 
> 50 89 44 24
> kernel: [  546.420045] EIP: [<cf450872>] 
> b43_lo_g_maintanance_work+0x55/0x1b3 [b43] SS:ESP 0068:cdb63f68
>
> Relevant dmesg device info is as follows:
> [    7.361106] b43-pci-bridge 0000:00:0f.0: enabling device (0000 -> 
> 0002)
> [    7.384831] b43-pci-bridge 0000:00:0f.0: PCI INT A -> Link[LNKC] -> 
> GSI 10 (level, low) -> IRQ 10
> [    9.697536] b43-phy0: Broadcom 4318 WLAN found (core revision 9)
> [    9.744147] b43-phy0 debug: Found PHY: Analog 3, Type 2, Revision 7
> [    9.744183] b43-phy0 debug: Found Radio: Manuf 0x17F, Version 
> 0x2050, Revision 8
> [   60.181642] input: b43-phy0 as /devices/virtual/input/input4
> [   60.224169] b43 ssb0:0: firmware: requesting b43/ucode5.fw
> [   60.309769] b43 ssb0:0: firmware: requesting b43/pcm5.fw
> [   60.347726] b43 ssb0:0: firmware: requesting b43/b0g0initvals5.fw
> [   60.377113] b43 ssb0:0: firmware: requesting b43/b0g0bsinitvals5.fw
> [   60.520049] b43-phy0: Loading firmware version 410.2160 (2007-05-26 
> 15:32:10)
>
> Regards,
>
> David Ellingsworth
Hmm.. looks like there was a lot more to this than I last posted. Here's 
the complete output from an oops:

Mar 31 21:46:36 Source kernel: [ 1502.192145] WARNING: at 
drivers/net/wireless/b43/main.c:2571 b43_mac_suspend+0x1e/0xbf [b43]()
Mar 31 21:46:36 Source kernel: [ 1502.192215] Hardware name: 
Mocha/Moorea   
Mar 31 21:46:36 Source kernel: [ 1502.192266] Modules linked in: b43 
aes_i586 aes_generic rfkill_input ppdev lp xt_dscp xt_multiport xt_MARK 
xt_state ipt_REJECT iptable_filter ipt_MASQUERADE ipt_REDIRECT xt_tcpudp 
iptable_nat nfsd exportfs nfs lockd nfs_acl auth_rpcgss sunrpc cls_fw 
sch_sfq sch_htb ipv6 iptable_mangle ip_tables x_tables nf_nat_irc 
nf_conntrack_irc nf_nat_ftp nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 
nf_conntrack_ftp nf_conntrack fuse psmouse arc4 ecb rfkill rng_core 
mac80211 cfg80211 led_class input_polldev snd_via82xx gameport 
snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc 
snd_mpu401_uart snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi 
snd_seq_midi_event snd_seq snd_timer snd_seq_device snd pcspkr evdev 
soundcore ssb via686a i2c_viapro i2c_core via_agp agpgart shpchp 
pci_hotplug parport_pc parport container button reiserfs dm_mirror 
dm_region_hash dm_log dm_snapshot dm_mod ide_cd_mod cdrom ide_gd_mod 
ata_generic libata scsi_mod ide_pci_generic uhci_hcd ehci_hcd via82
Mar 31 21:46:36 Source kernel: xxx 8139cp 8139too mii usbcore ide_core 
thermal processor fan thermal_sys [last unloaded: b43]
Mar 31 21:46:36 Source kernel: [ 1502.196263] Pid: 3816, comm: hostapd 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:36 Source kernel: [ 1502.196321] Call Trace:
Mar 31 21:46:36 Source kernel: [ 1502.196378]  [<c011bb0c>] 
warn_slowpath+0x80/0xb5
Mar 31 21:46:36 Source kernel: [ 1502.196448]  [<c020831d>] 
extract_entropy+0x3e/0x84
Mar 31 21:46:36 Source kernel: [ 1502.197860]  [<c0208430>] 
get_random_bytes+0x12/0x15
Mar 31 21:46:36 Source kernel: [ 1502.197931]  [<c0257a74>] 
rt_cache_flush+0x19/0xae
Mar 31 21:46:36 Source kernel: [ 1502.198009]  [<cf4a1ab8>] 
b43_mac_suspend+0x1e/0xbf [b43]
Mar 31 21:46:36 Source kernel: [ 1502.198090]  [<cf4a3c64>] 
b43_op_config+0x20e/0x3ad [b43]
Mar 31 21:46:36 Source kernel: [ 1502.198182]  [<ceb450e6>] 
ieee80211_hw_config+0x78/0x7e [mac80211]
Mar 31 21:46:36 Source kernel: [ 1502.198264]  [<ceb4f46e>] 
ieee80211_open+0x54b/0x643 [mac80211]
Mar 31 21:46:36 Source kernel: [ 1502.198327]  [<c0239296>] 
sys_recvmsg+0x146/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.198387]  [<c0243d76>] 
dev_open+0x67/0xa2
Mar 31 21:46:36 Source kernel: [ 1502.198442]  [<c0243836>] 
dev_change_flags+0xa2/0x153
Mar 31 21:46:36 Source kernel: [ 1502.198501]  [<c027aefa>] 
devinet_ioctl+0x22a/0x530
Mar 31 21:46:36 Source kernel: [ 1502.198558]  [<c0237c19>] 
sock_ioctl+0x0/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.198614]  [<c0237dc6>] 
sock_ioctl+0x1ad/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.198671]  [<c0237c19>] 
sock_ioctl+0x0/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.198726]  [<c017a17e>] 
vfs_ioctl+0x16/0x4a
Mar 31 21:46:36 Source kernel: [ 1502.198782]  [<c017a6b8>] 
do_vfs_ioctl+0x41f/0x461
Mar 31 21:46:36 Source kernel: [ 1502.198838]  [<c017c409>] d_kill+0x3e/0x43
Mar 31 21:46:36 Source kernel: [ 1502.198895]  [<c017c8cc>] dput+0x19/0xec
Mar 31 21:46:36 Source kernel: [ 1502.198951]  [<c0171475>] 
__fput+0x131/0x154
Mar 31 21:46:36 Source kernel: [ 1502.199006]  [<c0180cb6>] 
mntput_no_expire+0x16/0xa4
Mar 31 21:46:36 Source kernel: [ 1502.199062]  [<c017a73b>] 
sys_ioctl+0x41/0x58
Mar 31 21:46:36 Source kernel: [ 1502.199119]  [<c01032a6>] 
syscall_call+0x7/0xb
Mar 31 21:46:36 Source kernel: [ 1502.199172] ---[ end trace 
9a27304ff7b46a2c ]---
Mar 31 21:46:36 Source kernel: [ 1502.231154] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:36 Source kernel: [ 1502.231178] Pid: 3816, comm: hostapd 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:36 Source kernel: [ 1502.231253] Call Trace:
Mar 31 21:46:36 Source kernel: [ 1502.231378]  [<cf4a4ced>] 
b43_phy_read+0x28/0x38 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.231528]  [<cf4a7525>] 
b43_gphy_op_set_rx_antenna+0x3e/0x156 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.231603]  [<cf4a3d15>] 
b43_op_config+0x2bf/0x3ad [b43]
Mar 31 21:46:36 Source kernel: [ 1502.231733]  [<ceb450e6>] 
ieee80211_hw_config+0x78/0x7e [mac80211]
Mar 31 21:46:36 Source kernel: [ 1502.231819]  [<ceb4f46e>] 
ieee80211_open+0x54b/0x643 [mac80211]
Mar 31 21:46:36 Source kernel: [ 1502.231891]  [<c0239296>] 
sys_recvmsg+0x146/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.231963]  [<c0243d76>] 
dev_open+0x67/0xa2
Mar 31 21:46:36 Source kernel: [ 1502.232130]  [<c0243836>] 
dev_change_flags+0xa2/0x153
Mar 31 21:46:36 Source kernel: [ 1502.232200]  [<c027aefa>] 
devinet_ioctl+0x22a/0x530
Mar 31 21:46:36 Source kernel: [ 1502.232259]  [<c0237c19>] 
sock_ioctl+0x0/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.232314]  [<c0237dc6>] 
sock_ioctl+0x1ad/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.232371]  [<c0237c19>] 
sock_ioctl+0x0/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.232435]  [<c017a17e>] 
vfs_ioctl+0x16/0x4a
Mar 31 21:46:36 Source kernel: [ 1502.232490]  [<c017a6b8>] 
do_vfs_ioctl+0x41f/0x461
Mar 31 21:46:36 Source kernel: [ 1502.232547]  [<c017c409>] d_kill+0x3e/0x43
Mar 31 21:46:36 Source kernel: [ 1502.232605]  [<c017c8cc>] dput+0x19/0xec
Mar 31 21:46:36 Source kernel: [ 1502.232671]  [<c0171475>] 
__fput+0x131/0x154
Mar 31 21:46:36 Source kernel: [ 1502.232735]  [<c0180cb6>] 
mntput_no_expire+0x16/0xa4
Mar 31 21:46:36 Source kernel: [ 1502.232791]  [<c017a73b>] 
sys_ioctl+0x41/0x58
Mar 31 21:46:36 Source kernel: [ 1502.232854]  [<c01032a6>] 
syscall_call+0x7/0xb
Mar 31 21:46:36 Source kernel: [ 1502.232913] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:36 Source kernel: [ 1502.232925] Pid: 3816, comm: hostapd 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:36 Source kernel: [ 1502.232982] Call Trace:
Mar 31 21:46:36 Source kernel: [ 1502.233058]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.233138]  [<cf4a7548>] 
b43_gphy_op_set_rx_antenna+0x61/0x156 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.233215]  [<cf4a3d15>] 
b43_op_config+0x2bf/0x3ad [b43]
Mar 31 21:46:36 Source kernel: [ 1502.233299]  [<ceb450e6>] 
ieee80211_hw_config+0x78/0x7e [mac80211]
Mar 31 21:46:36 Source kernel: [ 1502.233381]  [<ceb4f46e>] 
ieee80211_open+0x54b/0x643 [mac80211]
Mar 31 21:46:36 Source kernel: [ 1502.233441]  [<c0239296>] 
sys_recvmsg+0x146/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.233500]  [<c0243d76>] 
dev_open+0x67/0xa2
Mar 31 21:46:36 Source kernel: [ 1502.233556]  [<c0243836>] 
dev_change_flags+0xa2/0x153
Mar 31 21:46:36 Source kernel: [ 1502.233613]  [<c027aefa>] 
devinet_ioctl+0x22a/0x530
Mar 31 21:46:36 Source kernel: [ 1502.233673]  [<c0237c19>] 
sock_ioctl+0x0/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.233727]  [<c0237dc6>] 
sock_ioctl+0x1ad/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.233783]  [<c0237c19>] 
sock_ioctl+0x0/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.233838]  [<c017a17e>] 
vfs_ioctl+0x16/0x4a
Mar 31 21:46:36 Source kernel: [ 1502.233895]  [<c017a6b8>] 
do_vfs_ioctl+0x41f/0x461
Mar 31 21:46:36 Source kernel: [ 1502.233952]  [<c017c409>] d_kill+0x3e/0x43
Mar 31 21:46:36 Source kernel: [ 1502.234007]  [<c017c8cc>] dput+0x19/0xec
Mar 31 21:46:36 Source kernel: [ 1502.234060]  [<c0171475>] 
__fput+0x131/0x154
Mar 31 21:46:36 Source kernel: [ 1502.234117]  [<c0180cb6>] 
mntput_no_expire+0x16/0xa4
Mar 31 21:46:36 Source kernel: [ 1502.234174]  [<c017a73b>] 
sys_ioctl+0x41/0x58
Mar 31 21:46:36 Source kernel: [ 1502.234229]  [<c01032a6>] 
syscall_call+0x7/0xb
Mar 31 21:46:36 Source kernel: [ 1502.234283] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:36 Source kernel: [ 1502.234292] Pid: 3816, comm: hostapd 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:36 Source kernel: [ 1502.234348] Call Trace:
Mar 31 21:46:36 Source kernel: [ 1502.234417]  [<cf4a4ced>] 
b43_phy_read+0x28/0x38 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.234495]  [<cf4a7558>] 
b43_gphy_op_set_rx_antenna+0x71/0x156 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.234570]  [<cf4a3d15>] 
b43_op_config+0x2bf/0x3ad [b43]
Mar 31 21:46:36 Source kernel: [ 1502.234651]  [<ceb450e6>] 
ieee80211_hw_config+0x78/0x7e [mac80211]
Mar 31 21:46:36 Source kernel: [ 1502.234733]  [<ceb4f46e>] 
ieee80211_open+0x54b/0x643 [mac80211]
Mar 31 21:46:36 Source kernel: [ 1502.234792]  [<c0239296>] 
sys_recvmsg+0x146/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.234853]  [<c0243d76>] 
dev_open+0x67/0xa2
Mar 31 21:46:36 Source kernel: [ 1502.234911]  [<c0243836>] 
dev_change_flags+0xa2/0x153
Mar 31 21:46:36 Source kernel: [ 1502.234968]  [<c027aefa>] 
devinet_ioctl+0x22a/0x530
Mar 31 21:46:36 Source kernel: [ 1502.235025]  [<c0237c19>] 
sock_ioctl+0x0/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.235080]  [<c0237dc6>] 
sock_ioctl+0x1ad/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.235135]  [<c0237c19>] 
sock_ioctl+0x0/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.235190]  [<c017a17e>] 
vfs_ioctl+0x16/0x4a
Mar 31 21:46:36 Source kernel: [ 1502.235246]  [<c017a6b8>] 
do_vfs_ioctl+0x41f/0x461
Mar 31 21:46:36 Source kernel: [ 1502.235302]  [<c017c409>] d_kill+0x3e/0x43
Mar 31 21:46:36 Source kernel: [ 1502.235357]  [<c017c8cc>] dput+0x19/0xec
Mar 31 21:46:36 Source kernel: [ 1502.235412]  [<c0171475>] 
__fput+0x131/0x154
Mar 31 21:46:36 Source kernel: [ 1502.235466]  [<c0180cb6>] 
mntput_no_expire+0x16/0xa4
Mar 31 21:46:36 Source kernel: [ 1502.235523]  [<c017a73b>] 
sys_ioctl+0x41/0x58
Mar 31 21:46:36 Source kernel: [ 1502.235579]  [<c01032a6>] 
syscall_call+0x7/0xb
Mar 31 21:46:36 Source kernel: [ 1502.235633] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:36 Source kernel: [ 1502.235642] Pid: 3816, comm: hostapd 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:36 Source kernel: [ 1502.235701] Call Trace:
Mar 31 21:46:36 Source kernel: [ 1502.235767]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.235845]  [<cf4a7575>] 
b43_gphy_op_set_rx_antenna+0x8e/0x156 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.235920]  [<cf4a3d15>] 
b43_op_config+0x2bf/0x3ad [b43]
Mar 31 21:46:36 Source kernel: [ 1502.236000]  [<ceb450e6>] 
ieee80211_hw_config+0x78/0x7e [mac80211]
Mar 31 21:46:36 Source kernel: [ 1502.236111]  [<ceb4f46e>] 
ieee80211_open+0x54b/0x643 [mac80211]
Mar 31 21:46:36 Source kernel: [ 1502.236171]  [<c0239296>] 
sys_recvmsg+0x146/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.236231]  [<c0243d76>] 
dev_open+0x67/0xa2
Mar 31 21:46:36 Source kernel: [ 1502.236286]  [<c0243836>] 
dev_change_flags+0xa2/0x153
Mar 31 21:46:36 Source kernel: [ 1502.236344]  [<c027aefa>] 
devinet_ioctl+0x22a/0x530
Mar 31 21:46:36 Source kernel: [ 1502.236401]  [<c0237c19>] 
sock_ioctl+0x0/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.236457]  [<c0237dc6>] 
sock_ioctl+0x1ad/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.236512]  [<c0237c19>] 
sock_ioctl+0x0/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.236568]  [<c017a17e>] 
vfs_ioctl+0x16/0x4a
Mar 31 21:46:36 Source kernel: [ 1502.236623]  [<c017a6b8>] 
do_vfs_ioctl+0x41f/0x461
Mar 31 21:46:36 Source kernel: [ 1502.236680]  [<c017c409>] d_kill+0x3e/0x43
Mar 31 21:46:36 Source kernel: [ 1502.236734]  [<c017c8cc>] dput+0x19/0xec
Mar 31 21:46:36 Source kernel: [ 1502.236789]  [<c0171475>] 
__fput+0x131/0x154
Mar 31 21:46:36 Source kernel: [ 1502.236844]  [<c0180cb6>] 
mntput_no_expire+0x16/0xa4
Mar 31 21:46:36 Source kernel: [ 1502.236900]  [<c017a73b>] 
sys_ioctl+0x41/0x58
Mar 31 21:46:36 Source kernel: [ 1502.236956]  [<c01032a6>] 
syscall_call+0x7/0xb
Mar 31 21:46:36 Source kernel: [ 1502.237009] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:36 Source kernel: [ 1502.237018] Pid: 3816, comm: hostapd 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:36 Source kernel: [ 1502.237075] Call Trace:
Mar 31 21:46:36 Source kernel: [ 1502.237141]  [<cf4a4ced>] 
b43_phy_read+0x28/0x38 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.237219]  [<cf4a7581>] 
b43_gphy_op_set_rx_antenna+0x9a/0x156 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.237293]  [<cf4a3d15>] 
b43_op_config+0x2bf/0x3ad [b43]
Mar 31 21:46:36 Source kernel: [ 1502.237373]  [<ceb450e6>] 
ieee80211_hw_config+0x78/0x7e [mac80211]
Mar 31 21:46:36 Source kernel: [ 1502.237455]  [<ceb4f46e>] 
ieee80211_open+0x54b/0x643 [mac80211]
Mar 31 21:46:36 Source kernel: [ 1502.237515]  [<c0239296>] 
sys_recvmsg+0x146/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.237574]  [<c0243d76>] 
dev_open+0x67/0xa2
Mar 31 21:46:36 Source kernel: [ 1502.237629]  [<c0243836>] 
dev_change_flags+0xa2/0x153
Mar 31 21:46:36 Source kernel: [ 1502.237687]  [<c027aefa>] 
devinet_ioctl+0x22a/0x530
Mar 31 21:46:36 Source kernel: [ 1502.237743]  [<c0237c19>] 
sock_ioctl+0x0/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.237798]  [<c0237dc6>] 
sock_ioctl+0x1ad/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.237854]  [<c0237c19>] 
sock_ioctl+0x0/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.237909]  [<c017a17e>] 
vfs_ioctl+0x16/0x4a
Mar 31 21:46:36 Source kernel: [ 1502.237964]  [<c017a6b8>] 
do_vfs_ioctl+0x41f/0x461
Mar 31 21:46:36 Source kernel: [ 1502.238021]  [<c017c409>] d_kill+0x3e/0x43
Mar 31 21:46:36 Source kernel: [ 1502.238076]  [<c017c8cc>] dput+0x19/0xec
Mar 31 21:46:36 Source kernel: [ 1502.238131]  [<c0171475>] 
__fput+0x131/0x154
Mar 31 21:46:36 Source kernel: [ 1502.238186]  [<c0180cb6>] 
mntput_no_expire+0x16/0xa4
Mar 31 21:46:36 Source kernel: [ 1502.238242]  [<c017a73b>] 
sys_ioctl+0x41/0x58
Mar 31 21:46:36 Source kernel: [ 1502.238296]  [<c01032a6>] 
syscall_call+0x7/0xb
Mar 31 21:46:36 Source kernel: [ 1502.238351] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:36 Source kernel: [ 1502.238359] Pid: 3816, comm: hostapd 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:36 Source kernel: [ 1502.238417] Call Trace:
Mar 31 21:46:36 Source kernel: [ 1502.238483]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.238561]  [<cf4a759d>] 
b43_gphy_op_set_rx_antenna+0xb6/0x156 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.238636]  [<cf4a3d15>] 
b43_op_config+0x2bf/0x3ad [b43]
Mar 31 21:46:36 Source kernel: [ 1502.238716]  [<ceb450e6>] 
ieee80211_hw_config+0x78/0x7e [mac80211]
Mar 31 21:46:36 Source kernel: [ 1502.238798]  [<ceb4f46e>] 
ieee80211_open+0x54b/0x643 [mac80211]
Mar 31 21:46:36 Source kernel: [ 1502.238858]  [<c0239296>] 
sys_recvmsg+0x146/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.238917]  [<c0243d76>] 
dev_open+0x67/0xa2
Mar 31 21:46:36 Source kernel: [ 1502.238976]  [<c0243836>] 
dev_change_flags+0xa2/0x153
Mar 31 21:46:36 Source kernel: [ 1502.239033]  [<c027aefa>] 
devinet_ioctl+0x22a/0x530
Mar 31 21:46:36 Source kernel: [ 1502.239090]  [<c0237c19>] 
sock_ioctl+0x0/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.239146]  [<c0237dc6>] 
sock_ioctl+0x1ad/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.239201]  [<c0237c19>] 
sock_ioctl+0x0/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.239257]  [<c017a17e>] 
vfs_ioctl+0x16/0x4a
Mar 31 21:46:36 Source kernel: [ 1502.239312]  [<c017a6b8>] 
do_vfs_ioctl+0x41f/0x461
Mar 31 21:46:36 Source kernel: [ 1502.239369]  [<c017c409>] d_kill+0x3e/0x43
Mar 31 21:46:36 Source kernel: [ 1502.239423]  [<c017c8cc>] dput+0x19/0xec
Mar 31 21:46:36 Source kernel: [ 1502.239478]  [<c0171475>] 
__fput+0x131/0x154
Mar 31 21:46:36 Source kernel: [ 1502.239533]  [<c0180cb6>] 
mntput_no_expire+0x16/0xa4
Mar 31 21:46:36 Source kernel: [ 1502.239589]  [<c017a73b>] 
sys_ioctl+0x41/0x58
Mar 31 21:46:36 Source kernel: [ 1502.239645]  [<c01032a6>] 
syscall_call+0x7/0xb
Mar 31 21:46:36 Source kernel: [ 1502.239700] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:36 Source kernel: [ 1502.239708] Pid: 3816, comm: hostapd 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:36 Source kernel: [ 1502.239767] Call Trace:
Mar 31 21:46:36 Source kernel: [ 1502.239832]  [<cf4a4ced>] 
b43_phy_read+0x28/0x38 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.239909]  [<cf4a75af>] 
b43_gphy_op_set_rx_antenna+0xc8/0x156 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.239984]  [<cf4a3d15>] 
b43_op_config+0x2bf/0x3ad [b43]
Mar 31 21:46:36 Source kernel: [ 1502.240086]  [<ceb450e6>] 
ieee80211_hw_config+0x78/0x7e [mac80211]
Mar 31 21:46:36 Source kernel: [ 1502.240169]  [<ceb4f46e>] 
ieee80211_open+0x54b/0x643 [mac80211]
Mar 31 21:46:36 Source kernel: [ 1502.240228]  [<c0239296>] 
sys_recvmsg+0x146/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.240287]  [<c0243d76>] 
dev_open+0x67/0xa2
Mar 31 21:46:36 Source kernel: [ 1502.240345]  [<c0243836>] 
dev_change_flags+0xa2/0x153
Mar 31 21:46:36 Source kernel: [ 1502.240403]  [<c027aefa>] 
devinet_ioctl+0x22a/0x530
Mar 31 21:46:36 Source kernel: [ 1502.240459]  [<c0237c19>] 
sock_ioctl+0x0/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.240515]  [<c0237dc6>] 
sock_ioctl+0x1ad/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.240571]  [<c0237c19>] 
sock_ioctl+0x0/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.240628]  [<c017a17e>] 
vfs_ioctl+0x16/0x4a
Mar 31 21:46:36 Source kernel: [ 1502.240684]  [<c017a6b8>] 
do_vfs_ioctl+0x41f/0x461
Mar 31 21:46:36 Source kernel: [ 1502.240740]  [<c017c409>] d_kill+0x3e/0x43
Mar 31 21:46:36 Source kernel: [ 1502.240794]  [<c017c8cc>] dput+0x19/0xec
Mar 31 21:46:36 Source kernel: [ 1502.240851]  [<c0171475>] 
__fput+0x131/0x154
Mar 31 21:46:36 Source kernel: [ 1502.240905]  [<c0180cb6>] 
mntput_no_expire+0x16/0xa4
Mar 31 21:46:36 Source kernel: [ 1502.240962]  [<c017a73b>] 
sys_ioctl+0x41/0x58
Mar 31 21:46:36 Source kernel: [ 1502.241018]  [<c01032a6>] 
syscall_call+0x7/0xb
Mar 31 21:46:36 Source kernel: [ 1502.241074] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:36 Source kernel: [ 1502.241082] Pid: 3816, comm: hostapd 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:36 Source kernel: [ 1502.241139] Call Trace:
Mar 31 21:46:36 Source kernel: [ 1502.241205]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.241285]  [<cf4a75c1>] 
b43_gphy_op_set_rx_antenna+0xda/0x156 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.242717]  [<cf4a3d15>] 
b43_op_config+0x2bf/0x3ad [b43]
Mar 31 21:46:36 Source kernel: [ 1502.242798]  [<ceb450e6>] 
ieee80211_hw_config+0x78/0x7e [mac80211]
Mar 31 21:46:36 Source kernel: [ 1502.242879]  [<ceb4f46e>] 
ieee80211_open+0x54b/0x643 [mac80211]
Mar 31 21:46:36 Source kernel: [ 1502.242938]  [<c0239296>] 
sys_recvmsg+0x146/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.242998]  [<c0243d76>] 
dev_open+0x67/0xa2
Mar 31 21:46:36 Source kernel: [ 1502.243053]  [<c0243836>] 
dev_change_flags+0xa2/0x153
Mar 31 21:46:36 Source kernel: [ 1502.243111]  [<c027aefa>] 
devinet_ioctl+0x22a/0x530
Mar 31 21:46:36 Source kernel: [ 1502.243169]  [<c0237c19>] 
sock_ioctl+0x0/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.243224]  [<c0237dc6>] 
sock_ioctl+0x1ad/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.243279]  [<c0237c19>] 
sock_ioctl+0x0/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.243334]  [<c017a17e>] 
vfs_ioctl+0x16/0x4a
Mar 31 21:46:36 Source kernel: [ 1502.243391]  [<c017a6b8>] 
do_vfs_ioctl+0x41f/0x461
Mar 31 21:46:36 Source kernel: [ 1502.243447]  [<c017c409>] d_kill+0x3e/0x43
Mar 31 21:46:36 Source kernel: [ 1502.243503]  [<c017c8cc>] dput+0x19/0xec
Mar 31 21:46:36 Source kernel: [ 1502.243557]  [<c0171475>] 
__fput+0x131/0x154
Mar 31 21:46:36 Source kernel: [ 1502.243613]  [<c0180cb6>] 
mntput_no_expire+0x16/0xa4
Mar 31 21:46:36 Source kernel: [ 1502.243670]  [<c017a73b>] 
sys_ioctl+0x41/0x58
Mar 31 21:46:36 Source kernel: [ 1502.243725]  [<c01032a6>] 
syscall_call+0x7/0xb
Mar 31 21:46:36 Source kernel: [ 1502.243778] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:36 Source kernel: [ 1502.243786] Pid: 3816, comm: hostapd 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:36 Source kernel: [ 1502.243843] Call Trace:
Mar 31 21:46:36 Source kernel: [ 1502.243909]  [<cf4a4ced>] 
b43_phy_read+0x28/0x38 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.243986]  [<cf4a75cd>] 
b43_gphy_op_set_rx_antenna+0xe6/0x156 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.244083]  [<cf4a3d15>] 
b43_op_config+0x2bf/0x3ad [b43]
Mar 31 21:46:36 Source kernel: [ 1502.244165]  [<ceb450e6>] 
ieee80211_hw_config+0x78/0x7e [mac80211]
Mar 31 21:46:36 Source kernel: [ 1502.244246]  [<ceb4f46e>] 
ieee80211_open+0x54b/0x643 [mac80211]
Mar 31 21:46:36 Source kernel: [ 1502.244306]  [<c0239296>] 
sys_recvmsg+0x146/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.244365]  [<c0243d76>] 
dev_open+0x67/0xa2
Mar 31 21:46:36 Source kernel: [ 1502.244420]  [<c0243836>] 
dev_change_flags+0xa2/0x153
Mar 31 21:46:36 Source kernel: [ 1502.244478]  [<c027aefa>] 
devinet_ioctl+0x22a/0x530
Mar 31 21:46:36 Source kernel: [ 1502.244537]  [<c0237c19>] 
sock_ioctl+0x0/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.244592]  [<c0237dc6>] 
sock_ioctl+0x1ad/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.244648]  [<c0237c19>] 
sock_ioctl+0x0/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.244703]  [<c017a17e>] 
vfs_ioctl+0x16/0x4a
Mar 31 21:46:36 Source kernel: [ 1502.244759]  [<c017a6b8>] 
do_vfs_ioctl+0x41f/0x461
Mar 31 21:46:36 Source kernel: [ 1502.244816]  [<c017c409>] d_kill+0x3e/0x43
Mar 31 21:46:36 Source kernel: [ 1502.244871]  [<c017c8cc>] dput+0x19/0xec
Mar 31 21:46:36 Source kernel: [ 1502.244925]  [<c0171475>] 
__fput+0x131/0x154
Mar 31 21:46:36 Source kernel: [ 1502.244982]  [<c0180cb6>] 
mntput_no_expire+0x16/0xa4
Mar 31 21:46:36 Source kernel: [ 1502.245039]  [<c017a73b>] 
sys_ioctl+0x41/0x58
Mar 31 21:46:36 Source kernel: [ 1502.245094]  [<c01032a6>] 
syscall_call+0x7/0xb
Mar 31 21:46:36 Source kernel: [ 1502.245149] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:36 Source kernel: [ 1502.245157] Pid: 3816, comm: hostapd 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:36 Source kernel: [ 1502.245214] Call Trace:
Mar 31 21:46:36 Source kernel: [ 1502.245282]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.245359]  [<cf4a75e4>] 
b43_gphy_op_set_rx_antenna+0xfd/0x156 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.245435]  [<cf4a3d15>] 
b43_op_config+0x2bf/0x3ad [b43]
Mar 31 21:46:36 Source kernel: [ 1502.245516]  [<ceb450e6>] 
ieee80211_hw_config+0x78/0x7e [mac80211]
Mar 31 21:46:36 Source kernel: [ 1502.245597]  [<ceb4f46e>] 
ieee80211_open+0x54b/0x643 [mac80211]
Mar 31 21:46:36 Source kernel: [ 1502.245657]  [<c0239296>] 
sys_recvmsg+0x146/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.245716]  [<c0243d76>] 
dev_open+0x67/0xa2
Mar 31 21:46:36 Source kernel: [ 1502.245774]  [<c0243836>] 
dev_change_flags+0xa2/0x153
Mar 31 21:46:36 Source kernel: [ 1502.245831]  [<c027aefa>] 
devinet_ioctl+0x22a/0x530
Mar 31 21:46:36 Source kernel: [ 1502.245887]  [<c0237c19>] 
sock_ioctl+0x0/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.245942]  [<c0237dc6>] 
sock_ioctl+0x1ad/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.245998]  [<c0237c19>] 
sock_ioctl+0x0/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.246053]  [<c017a17e>] 
vfs_ioctl+0x16/0x4a
Mar 31 21:46:36 Source kernel: [ 1502.246108]  [<c017a6b8>] 
do_vfs_ioctl+0x41f/0x461
Mar 31 21:46:36 Source kernel: [ 1502.246165]  [<c017c409>] d_kill+0x3e/0x43
Mar 31 21:46:36 Source kernel: [ 1502.246220]  [<c017c8cc>] dput+0x19/0xec
Mar 31 21:46:36 Source kernel: [ 1502.246274]  [<c0171475>] 
__fput+0x131/0x154
Mar 31 21:46:36 Source kernel: [ 1502.246329]  [<c0180cb6>] 
mntput_no_expire+0x16/0xa4
Mar 31 21:46:36 Source kernel: [ 1502.246386]  [<c017a73b>] 
sys_ioctl+0x41/0x58
Mar 31 21:46:36 Source kernel: [ 1502.246441]  [<c01032a6>] 
syscall_call+0x7/0xb
Mar 31 21:46:36 Source kernel: [ 1502.246495] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:36 Source kernel: [ 1502.246503] Pid: 3816, comm: hostapd 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:36 Source kernel: [ 1502.246561] Call Trace:
Mar 31 21:46:36 Source kernel: [ 1502.246627]  [<cf4a4ced>] 
b43_phy_read+0x28/0x38 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.246704]  [<cf4a75fb>] 
b43_gphy_op_set_rx_antenna+0x114/0x156 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.246779]  [<cf4a3d15>] 
b43_op_config+0x2bf/0x3ad [b43]
Mar 31 21:46:36 Source kernel: [ 1502.246859]  [<ceb450e6>] 
ieee80211_hw_config+0x78/0x7e [mac80211]
Mar 31 21:46:36 Source kernel: [ 1502.246941]  [<ceb4f46e>] 
ieee80211_open+0x54b/0x643 [mac80211]
Mar 31 21:46:36 Source kernel: [ 1502.247000]  [<c0239296>] 
sys_recvmsg+0x146/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.247059]  [<c0243d76>] 
dev_open+0x67/0xa2
Mar 31 21:46:36 Source kernel: [ 1502.247114]  [<c0243836>] 
dev_change_flags+0xa2/0x153
Mar 31 21:46:36 Source kernel: [ 1502.247172]  [<c027aefa>] 
devinet_ioctl+0x22a/0x530
Mar 31 21:46:36 Source kernel: [ 1502.247229]  [<c0237c19>] 
sock_ioctl+0x0/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.247284]  [<c0237dc6>] 
sock_ioctl+0x1ad/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.247339]  [<c0237c19>] 
sock_ioctl+0x0/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.247396]  [<c017a17e>] 
vfs_ioctl+0x16/0x4a
Mar 31 21:46:36 Source kernel: [ 1502.247453]  [<c017a6b8>] 
do_vfs_ioctl+0x41f/0x461
Mar 31 21:46:36 Source kernel: [ 1502.247509]  [<c017c409>] d_kill+0x3e/0x43
Mar 31 21:46:36 Source kernel: [ 1502.247564]  [<c017c8cc>] dput+0x19/0xec
Mar 31 21:46:36 Source kernel: [ 1502.247619]  [<c0171475>] 
__fput+0x131/0x154
Mar 31 21:46:36 Source kernel: [ 1502.247675]  [<c0180cb6>] 
mntput_no_expire+0x16/0xa4
Mar 31 21:46:36 Source kernel: [ 1502.247732]  [<c017a73b>] 
sys_ioctl+0x41/0x58
Mar 31 21:46:36 Source kernel: [ 1502.247787]  [<c01032a6>] 
syscall_call+0x7/0xb
Mar 31 21:46:36 Source kernel: [ 1502.247841] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:36 Source kernel: [ 1502.247850] Pid: 3816, comm: hostapd 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:36 Source kernel: [ 1502.247907] Call Trace:
Mar 31 21:46:36 Source kernel: [ 1502.247973]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.248073]  [<cf4a7612>] 
b43_gphy_op_set_rx_antenna+0x12b/0x156 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.248149]  [<cf4a3d15>] 
b43_op_config+0x2bf/0x3ad [b43]
Mar 31 21:46:36 Source kernel: [ 1502.248230]  [<ceb450e6>] 
ieee80211_hw_config+0x78/0x7e [mac80211]
Mar 31 21:46:36 Source kernel: [ 1502.248312]  [<ceb4f46e>] 
ieee80211_open+0x54b/0x643 [mac80211]
Mar 31 21:46:36 Source kernel: [ 1502.248371]  [<c0239296>] 
sys_recvmsg+0x146/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.248430]  [<c0243d76>] 
dev_open+0x67/0xa2
Mar 31 21:46:36 Source kernel: [ 1502.248486]  [<c0243836>] 
dev_change_flags+0xa2/0x153
Mar 31 21:46:36 Source kernel: [ 1502.248544]  [<c027aefa>] 
devinet_ioctl+0x22a/0x530
Mar 31 21:46:36 Source kernel: [ 1502.248603]  [<c0237c19>] 
sock_ioctl+0x0/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.248659]  [<c0237dc6>] 
sock_ioctl+0x1ad/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.248715]  [<c0237c19>] 
sock_ioctl+0x0/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.248770]  [<c017a17e>] 
vfs_ioctl+0x16/0x4a
Mar 31 21:46:36 Source kernel: [ 1502.248826]  [<c017a6b8>] 
do_vfs_ioctl+0x41f/0x461
Mar 31 21:46:36 Source kernel: [ 1502.248882]  [<c017c409>] d_kill+0x3e/0x43
Mar 31 21:46:36 Source kernel: [ 1502.248937]  [<c017c8cc>] dput+0x19/0xec
Mar 31 21:46:36 Source kernel: [ 1502.248991]  [<c0171475>] 
__fput+0x131/0x154
Mar 31 21:46:36 Source kernel: [ 1502.249047]  [<c0180cb6>] 
mntput_no_expire+0x16/0xa4
Mar 31 21:46:36 Source kernel: [ 1502.249104]  [<c017a73b>] 
sys_ioctl+0x41/0x58
Mar 31 21:46:36 Source kernel: [ 1502.249159]  [<c01032a6>] 
syscall_call+0x7/0xb
Mar 31 21:46:36 Source kernel: [ 1502.249213] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:36 Source kernel: [ 1502.249221] Pid: 3816, comm: hostapd 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:36 Source kernel: [ 1502.249278] Call Trace:
Mar 31 21:46:36 Source kernel: [ 1502.249346]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.249423]  [<cf4a7629>] 
b43_gphy_op_set_rx_antenna+0x142/0x156 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.249498]  [<cf4a3d15>] 
b43_op_config+0x2bf/0x3ad [b43]
Mar 31 21:46:36 Source kernel: [ 1502.249579]  [<ceb450e6>] 
ieee80211_hw_config+0x78/0x7e [mac80211]
Mar 31 21:46:36 Source kernel: [ 1502.249660]  [<ceb4f46e>] 
ieee80211_open+0x54b/0x643 [mac80211]
Mar 31 21:46:36 Source kernel: [ 1502.249720]  [<c0239296>] 
sys_recvmsg+0x146/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.249780]  [<c0243d76>] 
dev_open+0x67/0xa2
Mar 31 21:46:36 Source kernel: [ 1502.249836]  [<c0243836>] 
dev_change_flags+0xa2/0x153
Mar 31 21:46:36 Source kernel: [ 1502.249894]  [<c027aefa>] 
devinet_ioctl+0x22a/0x530
Mar 31 21:46:36 Source kernel: [ 1502.249951]  [<c0237c19>] 
sock_ioctl+0x0/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.250006]  [<c0237dc6>] 
sock_ioctl+0x1ad/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.250062]  [<c0237c19>] 
sock_ioctl+0x0/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.250117]  [<c017a17e>] 
vfs_ioctl+0x16/0x4a
Mar 31 21:46:36 Source kernel: [ 1502.250172]  [<c017a6b8>] 
do_vfs_ioctl+0x41f/0x461
Mar 31 21:46:36 Source kernel: [ 1502.250229]  [<c017c409>] d_kill+0x3e/0x43
Mar 31 21:46:36 Source kernel: [ 1502.250284]  [<c017c8cc>] dput+0x19/0xec
Mar 31 21:46:36 Source kernel: [ 1502.250339]  [<c0171475>] 
__fput+0x131/0x154
Mar 31 21:46:36 Source kernel: [ 1502.250393]  [<c0180cb6>] 
mntput_no_expire+0x16/0xa4
Mar 31 21:46:36 Source kernel: [ 1502.250450]  [<c017a73b>] 
sys_ioctl+0x41/0x58
Mar 31 21:46:36 Source kernel: [ 1502.250506]  [<c01032a6>] 
syscall_call+0x7/0xb
Mar 31 21:46:36 Source kernel: [ 1502.644105] b43-phy1 ERROR: MAC 
suspend failed
Mar 31 21:46:36 Source kernel: [ 1502.644236] b43-phy1: Radio turned on 
by software
Mar 31 21:46:36 Source kernel: [ 1502.644324] b43-phy1: The hardware 
RF-kill button still turns the radio physically off. Press the button to 
turn it on.
Mar 31 21:46:36 Source kernel: [ 1502.644496] ------------[ cut here 
]------------
Mar 31 21:46:36 Source kernel: [ 1502.644550] WARNING: at 
drivers/net/wireless/b43/main.c:2550 b43_mac_enable+0x64/0xc4 [b43]()
Mar 31 21:46:36 Source kernel: [ 1502.644622] Hardware name: 
Mocha/Moorea   
Mar 31 21:46:36 Source kernel: [ 1502.644674] Modules linked in: b43 
aes_i586 aes_generic rfkill_input ppdev lp xt_dscp xt_multiport xt_MARK 
xt_state ipt_REJECT iptable_filter ipt_MASQUERADE ipt_REDIRECT xt_tcpudp 
iptable_nat nfsd exportfs nfs lockd nfs_acl auth_rpcgss sunrpc cls_fw 
sch_sfq sch_htb ipv6 iptable_mangle ip_tables x_tables nf_nat_irc 
nf_conntrack_irc nf_nat_ftp nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 
nf_conntrack_ftp nf_conntrack fuse psmouse arc4 ecb rfkill rng_core 
mac80211 cfg80211 led_class input_polldev snd_via82xx gameport 
snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc 
snd_mpu401_uart snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi 
snd_seq_midi_event snd_seq snd_timer snd_seq_device snd pcspkr evdev 
soundcore ssb via686a i2c_viapro i2c_core via_agp agpgart shpchp 
pci_hotplug parport_pc parport container button reiserfs dm_mirror 
dm_region_hash dm_log dm_snapshot dm_mod ide_cd_mod cdrom ide_gd_mod 
ata_generic libata scsi_mod ide_pci_generic uhci_hcd ehci_hcd via82
Mar 31 21:46:36 Source kernel: xxx 8139cp 8139too mii usbcore ide_core 
thermal processor fan thermal_sys [last unloaded: b43]
Mar 31 21:46:36 Source kernel: [ 1502.648754] Pid: 3816, comm: hostapd 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:36 Source kernel: [ 1502.648813] Call Trace:
Mar 31 21:46:36 Source kernel: [ 1502.648888]  [<c011bb0c>] 
warn_slowpath+0x80/0xb5
Mar 31 21:46:36 Source kernel: [ 1502.648962]  [<c0290020>] 
unix_stream_sendmsg+0x2ae/0x2c7
Mar 31 21:46:36 Source kernel: [ 1502.649043]  [<cf4a213f>] 
b43info+0x5b/0x61 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.649113]  [<cf4a1d4a>] 
b43_mac_enable+0x64/0xc4 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.649189]  [<cf4a3df0>] 
b43_op_config+0x39a/0x3ad [b43]
Mar 31 21:46:36 Source kernel: [ 1502.649322]  [<ceb450e6>] 
ieee80211_hw_config+0x78/0x7e [mac80211]
Mar 31 21:46:36 Source kernel: [ 1502.649409]  [<ceb4f46e>] 
ieee80211_open+0x54b/0x643 [mac80211]
Mar 31 21:46:36 Source kernel: [ 1502.649483]  [<c0239296>] 
sys_recvmsg+0x146/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.649555]  [<c0243d76>] 
dev_open+0x67/0xa2
Mar 31 21:46:36 Source kernel: [ 1502.649612]  [<c0243836>] 
dev_change_flags+0xa2/0x153
Mar 31 21:46:36 Source kernel: [ 1502.649679]  [<c027aefa>] 
devinet_ioctl+0x22a/0x530
Mar 31 21:46:36 Source kernel: [ 1502.649736]  [<c0237c19>] 
sock_ioctl+0x0/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.649792]  [<c0237dc6>] 
sock_ioctl+0x1ad/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.649849]  [<c0237c19>] 
sock_ioctl+0x0/0x1d1
Mar 31 21:46:36 Source kernel: [ 1502.649912]  [<c017a17e>] 
vfs_ioctl+0x16/0x4a
Mar 31 21:46:36 Source kernel: [ 1502.649969]  [<c017a6b8>] 
do_vfs_ioctl+0x41f/0x461
Mar 31 21:46:36 Source kernel: [ 1502.650027]  [<c017c409>] d_kill+0x3e/0x43
Mar 31 21:46:36 Source kernel: [ 1502.650083]  [<c017c8cc>] dput+0x19/0xec
Mar 31 21:46:36 Source kernel: [ 1502.650149]  [<c0171475>] 
__fput+0x131/0x154
Mar 31 21:46:36 Source kernel: [ 1502.650211]  [<c0180cb6>] 
mntput_no_expire+0x16/0xa4
Mar 31 21:46:36 Source kernel: [ 1502.650268]  [<c017a73b>] 
sys_ioctl+0x41/0x58
Mar 31 21:46:36 Source kernel: [ 1502.650330]  [<c01032a6>] 
syscall_call+0x7/0xb
Mar 31 21:46:36 Source kernel: [ 1502.650386] ---[ end trace 
9a27304ff7b46a2d ]---
Mar 31 21:46:36 Source kernel: [ 1502.650464] ------------[ cut here 
]------------
Mar 31 21:46:36 Source kernel: [ 1502.650518] WARNING: at 
drivers/net/wireless/b43/main.c:2571 b43_mac_suspend+0x1e/0xbf [b43]()
Mar 31 21:46:36 Source kernel: [ 1502.650589] Hardware name: 
Mocha/Moorea   
Mar 31 21:46:36 Source kernel: [ 1502.650642] Modules linked in: b43 
aes_i586 aes_generic rfkill_input ppdev lp xt_dscp xt_multiport xt_MARK 
xt_state ipt_REJECT iptable_filter ipt_MASQUERADE ipt_REDIRECT xt_tcpudp 
iptable_nat nfsd exportfs nfs lockd nfs_acl auth_rpcgss sunrpc cls_fw 
sch_sfq sch_htb ipv6 iptable_mangle ip_tables x_tables nf_nat_irc 
nf_conntrack_irc nf_nat_ftp nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 
nf_conntrack_ftp nf_conntrack fuse psmouse arc4 ecb rfkill rng_core 
mac80211 cfg80211 led_class input_polldev snd_via82xx gameport 
snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc 
snd_mpu401_uart snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi 
snd_seq_midi_event snd_seq snd_timer snd_seq_device snd pcspkr evdev 
soundcore ssb via686a i2c_viapro i2c_core via_agp agpgart shpchp 
pci_hotplug parport_pc parport container button reiserfs dm_mirror 
dm_region_hash dm_log dm_snapshot dm_mod ide_cd_mod cdrom ide_gd_mod 
ata_generi 1502.932619]  [<cf4a3f16>] b43_periodic_work_handler+0x5
Mar 31 21:46:36 Source kernel: /0x13c [b43]
Mar 31 21:46:36 Source kernel: [ 1502.932694]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:36 Source kernel: [ 1502.932754]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:36 Source kernel: [ 1502.932809]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:36 Source kernel: [ 1502.932864]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:36 Source kernel: [ 1502.932924]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:36 Source kernel: [ 1502.932984]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:36 Source kernel: [ 1502.933040]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:36 Source kernel: [ 1502.933094]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:36 Source kernel: [ 1502.933149]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:36 Source kernel: [ 1502.933207] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:36 Source kernel: [ 1502.933215] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:36 Source kernel: [ 1502.933271] Call Trace:
Mar 31 21:46:36 Source kernel: [ 1502.933337]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.933415]  [<cf4a5714>] 
b43_set_all_gains+0x95/0xfd [b43]
Mar 31 21:46:36 Source kernel: [ 1502.933489]  [<cf4b0018>] 
b43_dma_tx+0x5c8/0x735 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.933564]  [<cf4a6247>] 
b43_calc_nrssi_slope+0x956/0xd71 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.933641]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.933715]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:36 Source kernel: [ 1502.933793]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:36 Source kernel: [ 1502.933853]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:36 Source kernel: [ 1502.933908]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:36 Source kernel: [ 1502.933963]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:36 Source kernel: [ 1502.934020]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:36 Source kernel: [ 1502.934077]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:36 Source kernel: [ 1502.934132]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:36 Source kernel: [ 1502.934189]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:36 Source kernel: [ 1502.934243]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:36 Source kernel: [ 1502.934298] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:36 Source kernel: [ 1502.934306] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:36 Source kernel: [ 1502.934362] Call Trace:
Mar 31 21:46:36 Source kernel: [ 1502.934430]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.935850]  [<cf4a5714>] 
b43_set_all_gains+0x95/0xfd [b43]
Mar 31 21:46:36 Source kernel: [ 1502.935925]  [<cf4b0018>] 
b43_dma_tx+0x5c8/0x735 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.936000]  [<cf4a6247>] 
b43_calc_nrssi_slope+0x956/0xd71 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.936096]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.936171]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:36 Source kernel: [ 1502.936246]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:36 Source kernel: [ 1502.936305]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:36 Source kernel: [ 1502.936361]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:36 Source kernel: [ 1502.936416]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:36 Source kernel: [ 1502.936472]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:36 Source kernel: [ 1502.936530]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:36 Source kernel: [ 1502.936585]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:36 Source kernel: [ 1502.936640]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:36 Source kernel: [ 1502.936694]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:36 Source kernel: [ 1502.936749] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:36 Source kernel: [ 1502.936757] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:36 Source kernel: [ 1502.936814] Call Trace:
Mar 31 21:46:36 Source kernel: [ 1502.936912]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.936989]  [<cf4a5714>] 
b43_set_all_gains+0x95/0xfd [b43]
Mar 31 21:46:36 Source kernel: [ 1502.937063]  [<cf4b0018>] 
b43_dma_tx+0x5c8/0x735 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.937139]  [<cf4a6247>] 
b43_calc_nrssi_slope+0x956/0xd71 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.937215]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.937289]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:36 Source kernel: [ 1502.937364]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:36 Source kernel: [ 1502.937423]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:36 Source kernel: [ 1502.937479]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:36 Source kernel: [ 1502.937534]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:36 Source kernel: [ 1502.937592]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:36 Source kernel: [ 1502.937652]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:36 Source kernel: [ 1502.937708]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:36 Source kernel: [ 1502.937762]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:36 Source kernel: [ 1502.937816]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:36 Source kernel: [ 1502.937874] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:36 Source kernel: [ 1502.937882] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:36 Source kernel: [ 1502.937938] Call Trace:
Mar 31 21:46:36 Source kernel: [ 1502.938004]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.938081]  [<cf4a5714>] 
b43_set_all_gains+0x95/0xfd [b43]
Mar 31 21:46:36 Source kernel: [ 1502.938155]  [<cf4b0018>] 
b43_dma_tx+0x5c8/0x735 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.938231]  [<cf4a6247>] 
b43_calc_nrssi_slope+0x956/0xd71 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.938307]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.938381]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:36 Source kernel: [ 1502.938456]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:36 Source kernel: [ 1502.938516]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:36 Source kernel: [ 1502.938574]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:36 Source kernel: [ 1502.938629]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:36 Source kernel: [ 1502.938686]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:36 Source kernel: [ 1502.938744]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:36 Source kernel: [ 1502.938799]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:36 Source kernel: [ 1502.938853]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:36 Source kernel: [ 1502.938908]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:36 Source kernel: [ 1502.938963] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:36 Source kernel: [ 1502.938971] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:36 Source kernel: [ 1502.939027] Call Trace:
Mar 31 21:46:36 Source kernel: [ 1502.939093]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.939169]  [<cf4a5714>] 
b43_set_all_gains+0x95/0xfd [b43]
Mar 31 21:46:36 Source kernel: [ 1502.939244]  [<cf4b0018>] 
b43_dma_tx+0x5c8/0x735 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.939322]  [<cf4a6247>] 
b43_calc_nrssi_slope+0x956/0xd71 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.939398]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.939472]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:36 Source kernel: [ 1502.939547]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:36 Source kernel: [ 1502.939606]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:36 Source kernel: [ 1502.939661]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:36 Source kernel: [ 1502.939718]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:36 Source kernel: [ 1502.939774]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:36 Source kernel: [ 1502.939831]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:36 Source kernel: [ 1502.939887]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:36 Source kernel: [ 1502.939941]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:36 Source kernel: [ 1502.939996]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:36 Source kernel: [ 1502.940074] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:36 Source kernel: [ 1502.940082] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:36 Source kernel: [ 1502.940139] Call Trace:
Mar 31 21:46:36 Source kernel: [ 1502.940205]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.940281]  [<cf4a5714>] 
b43_set_all_gains+0x95/0xfd [b43]
Mar 31 21:46:36 Source kernel: [ 1502.940356]  [<cf4b0018>] 
b43_dma_tx+0x5c8/0x735 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.940431]  [<cf4a6247>] 
b43_calc_nrssi_slope+0x956/0xd71 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.940507]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.940582]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:36 Source kernel: [ 1502.940657]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:36 Source kernel: [ 1502.940717]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:36 Source kernel: [ 1502.940773]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:36 Source kernel: [ 1502.940831]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:36 Source kernel: [ 1502.940887]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:36 Source kernel: [ 1502.940945]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:36 Source kernel: [ 1502.941001]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:36 Source kernel: [ 1502.941055]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:36 Source kernel: [ 1502.941110]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:36 Source kernel: [ 1502.941165] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:36 Source kernel: [ 1502.941173] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:36 Source kernel: [ 1502.941229] Call Trace:
Mar 31 21:46:36 Source kernel: [ 1502.941294]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.941372]  [<cf4a5714>] 
b43_set_all_gains+0x95/0xfd [b43]
Mar 31 21:46:36 Source kernel: [ 1502.941449]  [<cf4b0018>] 
b43_dma_tx+0x5c8/0x735 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.941524]  [<cf4a6247>] 
b43_calc_nrssi_slope+0x956/0xd71 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.941600]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.941674]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:36 Source kernel: [ 1502.941749]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:36 Source kernel: [ 1502.941809]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:36 Source kernel: [ 1502.941865]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:36 Source kernel: [ 1502.941920]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:36 Source kernel: [ 1502.941977]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:36 Source kernel: [ 1502.942037]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:36 Source kernel: [ 1502.942092]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:36 Source kernel: [ 1502.942147]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:36 Source kernel: [ 1502.942202]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:36 Source kernel: [ 1502.942258] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:36 Source kernel: [ 1502.942266] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:36 Source kernel: [ 1502.942322] Call Trace:
Mar 31 21:46:36 Source kernel: [ 1502.942387]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.942463]  [<cf4a5714>] 
b43_set_all_gains+0x95/0xfd [b43]
Mar 31 21:46:36 Source kernel: [ 1502.942538]  [<cf4b0018>] 
b43_dma_tx+0x5c8/0x735 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.942613]  [<cf4a6247>] 
b43_calc_nrssi_slope+0x956/0xd71 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.942690]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.942764]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:36 Source kernel: [ 1502.942840]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:36 Source kernel: [ 1502.942900]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:36 Source kernel: [ 1502.942957]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:36 Source kernel: [ 1502.943013]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:36 Source kernel: [ 1502.943070]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:36 Source kernel: [ 1502.943128]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:36 Source kernel: [ 1502.943183]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:36 Source kernel: [ 1502.943240]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:36 Source kernel: [ 1502.943294]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:36 Source kernel: [ 1502.943350] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:36 Source kernel: [ 1502.943358] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:36 Source kernel: [ 1502.943415] Call Trace:
Mar 31 21:46:36 Source kernel: [ 1502.943481]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.943558]  [<cf4a5714>] 
b43_set_all_gains+0x95/0xfd [b43]
Mar 31 21:46:36 Source kernel: [ 1502.943633]  [<cf4b0018>] 
b43_dma_tx+0x5c8/0x735 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.943708]  [<cf4a6247>] 
b43_calc_nrssi_slope+0x956/0xd71 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.943784]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.943862]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:36 Source kernel: [ 1502.943936]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:36 Source kernel: [ 1502.943996]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:36 Source kernel: [ 1502.944072]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:36 Source kernel: [ 1502.944127]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:36 Source kernel: [ 1502.944184]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:36 Source kernel: [ 1502.944241]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:36 Source kernel: [ 1502.944298]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:36 Source kernel: [ 1502.944354]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:36 Source kernel: [ 1502.944408]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:36 Source kernel: [ 1502.944463] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:36 Source kernel: [ 1502.944471] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:36 Source kernel: [ 1502.944528] Call Trace:
Mar 31 21:46:36 Source kernel: [ 1502.944595]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.944673]  [<cf4a5714>] 
b43_set_all_gains+0x95/0xfd [b43]
Mar 31 21:46:36 Source kernel: [ 1502.944749]  [<cf4b0018>] 
b43_dma_tx+0x5c8/0x735 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.944824]  [<cf4a6247>] 
b43_calc_nrssi_slope+0x956/0xd71 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.944901]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.944976]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:36 Source kernel: [ 1502.945051]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:36 Source kernel: [ 1502.945111]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:36 Source kernel: [ 1502.945166]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:36 Source kernel: [ 1502.945221]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:36 Source kernel: [ 1502.945278]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:36 Source kernel: [ 1502.945338]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:36 Source kernel: [ 1502.945394]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:36 Source kernel: [ 1502.945448]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:36 Source kernel: [ 1502.945502]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:36 Source kernel: [ 1502.945560] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:36 Source kernel: [ 1502.945568] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:36 Source kernel: [ 1502.945624] Call Trace:
Mar 31 21:46:36 Source kernel: [ 1502.945690]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.945768]  [<cf4a5714>] 
b43_set_all_gains+0x95/0xfd [b43]
Mar 31 21:46:36 Source kernel: [ 1502.945843]  [<cf4b0018>] 
b43_dma_tx+0x5c8/0x735 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.945919]  [<cf4a6247>] 
b43_calc_nrssi_slope+0x956/0xd71 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.945995]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.946068]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:36 Source kernel: [ 1502.946146]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:36 Source kernel: [ 1502.946205]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:36 Source kernel: [ 1502.946261]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:36 Source kernel: [ 1502.946317]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:36 Source kernel: [ 1502.946373]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:36 Source kernel: [ 1502.946431]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:36 Source kernel: [ 1502.946486]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:36 Source kernel: [ 1502.946544]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:36 Source kernel: [ 1502.946598]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:36 Source kernel: [ 1502.946653] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:36 Source kernel: [ 1502.946661] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:36 Source kernel: [ 1502.946717] Call Trace:
Mar 31 21:46:36 Source kernel: [ 1502.946784]  [<cf4a4ced>] 
b43_phy_read+0x28/0x38 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.946860]  [<cf4a4d13>] 
b43_phy_maskset+0x16/0x2a [b43]
Mar 31 21:46:36 Source kernel: [ 1502.946933]  [<cf4a5747>] 
b43_set_all_gains+0xc8/0xfd [b43]
Mar 31 21:46:36 Source kernel: [ 1502.947008]  [<cf4b0018>] 
b43_dma_tx+0x5c8/0x735 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.947083]  [<cf4a6247>] 
b43_calc_nrssi_slope+0x956/0xd71 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.947159]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.947233]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:36 Source kernel: [ 1502.947307]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:36 Source kernel: [ 1502.947369]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:36 Source kernel: [ 1502.947424]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:36 Source kernel: [ 1502.947479]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:36 Source kernel: [ 1502.948893]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:36 Source kernel: [ 1502.948951]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:36 Source kernel: [ 1502.949006]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:36 Source kernel: [ 1502.949060]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:36 Source kernel: [ 1502.949115]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:36 Source kernel: [ 1502.949171] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:36 Source kernel: [ 1502.949179] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:36 Source kernel: [ 1502.949235] Call Trace:
Mar 31 21:46:36 Source kernel: [ 1502.949300]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.949378]  [<cf4a5747>] 
b43_set_all_gains+0xc8/0xfd [b43]
Mar 31 21:46:36 Source kernel: [ 1502.949454]  [<cf4b0018>] 
b43_dma_tx+0x5c8/0x735 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.949530]  [<cf4a6247>] 
b43_calc_nrssi_slope+0x956/0xd71 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.949606]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:36 Source kernel: [ 1502.949680]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:36 Source kernel: [ 1502.949755]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:36 Source kernel: [ 1502.949816]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:36 Source kernel: [ 1502.949871]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:36 Source kernel: [ 1502.949927]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:36 Source kernel: [ 1502.949984]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:36 Source kernel: [ 1502.950042]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:36 Source kernel: [ 1502.950097]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:36 Source kernel: [ 1502.950152]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:36 Source kernel: [ 1502.950206]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:36 Source kernel: [ 1502.950261] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:36 Source kernel: [ 1502.950269] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1502.950325] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1502.950391]  [<cf4a4ced>] 
b43_phy_read+0x28/0x38 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.950467]  [<cf4a4d13>] 
b43_phy_maskset+0x16/0x2a [b43]
Mar 31 21:46:37 Source kernel: [ 1502.950540]  [<cf4a5759>] 
b43_set_all_gains+0xda/0xfd [b43]
Mar 31 21:46:37 Source kernel: [ 1502.950615]  [<cf4b0018>] 
b43_dma_tx+0x5c8/0x735 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.950691]  [<cf4a6247>] 
b43_calc_nrssi_slope+0x956/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.950767]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.950841]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.950915]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.950975]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1502.951030]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.951085]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.951142]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1502.951199]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.951254]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.951309]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.951363]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1502.951419] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1502.951427] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1502.951483] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1502.951549]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.951625]  [<cf4a5759>] 
b43_set_all_gains+0xda/0xfd [b43]
Mar 31 21:46:37 Source kernel: [ 1502.951699]  [<cf4b0018>] 
b43_dma_tx+0x5c8/0x735 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.951774]  [<cf4a6247>] 
b43_calc_nrssi_slope+0x956/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.951851]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.951927]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.952002]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.952080]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1502.952138]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.952193]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.952249]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1502.952306]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.952363]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.952418]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.952473]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1502.952528] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1502.952536] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1502.952593] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1502.952661]  [<cf4a4ced>] 
b43_phy_read+0x28/0x38 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.952737]  [<cf4a4d13>] 
b43_phy_maskset+0x16/0x2a [b43]
Mar 31 21:46:37 Source kernel: [ 1502.952810]  [<cf4a576b>] 
b43_set_all_gains+0xec/0xfd [b43]
Mar 31 21:46:37 Source kernel: [ 1502.952885]  [<cf4b0018>] 
b43_dma_tx+0x5c8/0x735 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.952960]  [<cf4a6247>] 
b43_calc_nrssi_slope+0x956/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.953035]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.953109]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.953184]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.953245]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1502.953301]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.953355]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.953412]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1502.953471]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.953527]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.953581]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.953636]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1502.953692] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1502.953700] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1502.953756] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1502.953821]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.953901]  [<cf4a576b>] 
b43_set_all_gains+0xec/0xfd [b43]
Mar 31 21:46:37 Source kernel: [ 1502.953975]  [<cf4b0018>] 
b43_dma_tx+0x5c8/0x735 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.954050]  [<cf4a6247>] 
b43_calc_nrssi_slope+0x956/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.954126]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.954200]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.954277]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.954337]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1502.954393]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.954449]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.954506]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1502.954563]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.954620]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.954676]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.954730]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1502.954898] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1502.954907] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1502.954963] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1502.955029]  [<cf4a4dd4>] 
b43_radio_read+0x28/0x38 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.955109]  [<cf4a4e41>] 
b43_radio_mask+0x11/0x22 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.955185]  [<cf4a6258>] 
b43_calc_nrssi_slope+0x967/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.955263]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.955337]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.955411]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.955472]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1502.955530]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.955585]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.955641]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1502.955700]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.955757]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.955811]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.955865]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1502.955922] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1502.955930] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1502.955987] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1502.956076]  [<cf4a4d97>] 
b43_radio_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.956156]  [<cf4a6258>] 
b43_calc_nrssi_slope+0x967/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.956232]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.956306]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.956381]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.956440]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1502.956496]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.956552]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.956608]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1502.956665]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.956721]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.956776]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.956830]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1502.956886] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1502.956894] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1502.956951] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1502.957017]  [<cf4a4ced>] 
b43_phy_read+0x28/0x38 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.957093]  [<cf4a4d13>] 
b43_phy_maskset+0x16/0x2a [b43]
Mar 31 21:46:37 Source kernel: [ 1502.957172]  [<cf4a6272>] 
b43_calc_nrssi_slope+0x981/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.957248]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.957323]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.957398]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.957458]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1502.957514]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.957569]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.957626]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1502.957684]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.957740]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.957794]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.957851]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1502.957907] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1502.957915] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1502.957972] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1502.958038]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.958117]  [<cf4a6272>] 
b43_calc_nrssi_slope+0x981/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.958192]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.958266]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.958343]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.958403]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1502.958458]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.958514]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.958570]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1502.958628]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.958684]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.958742]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.958796]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1502.958851] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1502.958859] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1502.958916] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1502.958982]  [<cf4a4ced>] 
b43_phy_read+0x28/0x38 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.959058]  [<cf4a4d13>] 
b43_phy_maskset+0x16/0x2a [b43]
Mar 31 21:46:37 Source kernel: [ 1502.959134]  [<cf4a6285>] 
b43_calc_nrssi_slope+0x994/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.959209]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.959284]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.959361]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.959420]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1502.959475]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.959534]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.959591]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1502.959648]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.959703]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.959758]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.959813]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1502.959869] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1502.959877] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1502.959933] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1502.960000]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.960099]  [<cf4a6285>] 
b43_calc_nrssi_slope+0x994/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.960176]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.960252]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.960326]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.960386]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1502.960441]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.960497]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.961908]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1502.961965]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.962021]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.962077]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.962132]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1502.962186] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1502.962195] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1502.962251] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1502.962316]  [<cf4a4dd4>] 
b43_radio_read+0x28/0x38 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.962392]  [<cf4a4e1f>] 
b43_radio_set+0x11/0x22 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.962468]  [<cf4a6298>] 
b43_calc_nrssi_slope+0x9a7/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.962543]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.962617]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.962694]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.962753]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1502.962810]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.962864]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.962921]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1502.962979]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.963034]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.963092]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.963147]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1502.963203] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1502.963211] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1502.963268] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1502.963333]  [<cf4a4d97>] 
b43_radio_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.963414]  [<cf4a6298>] 
b43_calc_nrssi_slope+0x9a7/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.963491]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.963565]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.963640]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.963700]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1502.963757]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.963812]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.963869]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1502.963926]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.963982]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.964057]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.964113]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1502.964190] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1502.964198] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1502.964255] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1502.964320]  [<cf4a4ced>] 
b43_phy_read+0x28/0x38 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.964398]  [<cf4a62ae>] 
b43_calc_nrssi_slope+0x9bd/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.964474]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.964548]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.964622]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.964682]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1502.964736]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.964791]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.964848]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1502.964906]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.964961]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.965016]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.965071]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1502.965127] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1502.965135] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1502.965191] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1502.965257]  [<cf4a4dd4>] 
b43_radio_read+0x28/0x38 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.965332]  [<cf4a4e41>] 
b43_radio_mask+0x11/0x22 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.965408]  [<cf4a62d2>] 
b43_calc_nrssi_slope+0x9e1/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.965484]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.965558]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.965632]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.965691]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1502.965747]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.965802]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.965859]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1502.965916]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.965971]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.966026]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.966081]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1502.966140] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1502.966148] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1502.966205] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1502.966271]  [<cf4a4d97>] 
b43_radio_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.966352]  [<cf4a62d2>] 
b43_calc_nrssi_slope+0x9e1/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.966428]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.966503]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.966577]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.966637]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1502.966692]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.966747]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.966805]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1502.966862]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.966918]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.966972]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.967029]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1502.967084] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1502.967092] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1502.967149] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1502.967215]  [<cf4a4ced>] 
b43_phy_read+0x28/0x38 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.967291]  [<cf4a4d13>] 
b43_phy_maskset+0x16/0x2a [b43]
Mar 31 21:46:37 Source kernel: [ 1502.967368]  [<cf4a62eb>] 
b43_calc_nrssi_slope+0x9fa/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.967444]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.967521]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.967597]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.967656]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1502.967712]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.967767]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.967826]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1502.967886]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.967941]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.967996]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.968070]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1502.968126] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1502.968134] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1502.968190] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1502.968256]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.968335]  [<cf4a62eb>] 
b43_calc_nrssi_slope+0x9fa/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.968413]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.968487]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.968562]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.968623]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1502.968678]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.968733]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.968790]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1502.968847]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.968906]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.968960]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.969014]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1502.969070] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1502.969079] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1502.969136] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1502.969202]  [<cf4a4dd4>] 
b43_radio_read+0x28/0x38 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.969279]  [<cf4a4e1f>] 
b43_radio_set+0x11/0x22 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.969355]  [<cf4a631d>] 
b43_calc_nrssi_slope+0xa2c/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.969431]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.969505]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.969580]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.969640]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1502.969697]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.969753]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.969810]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1502.969867]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.969923]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.969978]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.970032]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1502.970088] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1502.970097] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1502.970154] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1502.970222]  [<cf4a4d97>] 
b43_radio_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.970301]  [<cf4a631d>] 
b43_calc_nrssi_slope+0xa2c/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.970377]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.970452]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.970526]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.970588]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1502.970643]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.970698]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.970755]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1502.970813]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.970868]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.970922]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.970977]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1502.971031] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1502.971039] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1502.971096] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1502.971162]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.971243]  [<cf4a632e>] 
b43_calc_nrssi_slope+0xa3d/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.971319]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.971395]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.971470]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.971529]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1502.971585]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.971640]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.971700]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1502.971759]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.971815]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.971870]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.971924]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1502.971981] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1502.971989] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1502.972066] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1502.972132]  [<cf4a4ced>] 
b43_phy_read+0x28/0x38 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.972208]  [<cf4a4d13>] 
b43_phy_maskset+0x16/0x2a [b43]
Mar 31 21:46:37 Source kernel: [ 1502.972285]  [<cf4a6347>] 
b43_calc_nrssi_slope+0xa56/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.972361]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.972435]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.972512]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.972572]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1502.972628]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.972685]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.972741]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1502.972799]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.972855]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.972910]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.972966]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1502.973023] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1502.973031] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1502.973087] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1502.973153]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.973231]  [<cf4a6347>] 
b43_calc_nrssi_slope+0xa56/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.973307]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.974719]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.974795]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.974855]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1502.974910]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.974969]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.975026]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1502.975084]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.975139]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.975194]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.975248]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1502.975303] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1502.975311] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1502.975367] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1502.975433]  [<cf4a4ced>] 
b43_phy_read+0x28/0x38 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.975510]  [<cf4a4d13>] 
b43_phy_maskset+0x16/0x2a [b43]
Mar 31 21:46:37 Source kernel: [ 1502.975587]  [<cf4a635a>] 
b43_calc_nrssi_slope+0xa69/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.975663]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.975737]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.975813]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.975872]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1502.975927]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.975986]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.976062]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1502.976121]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.976179]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.976234]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.976289]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1502.976344] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1502.976353] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1502.976409] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1502.976476]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.976554]  [<cf4a635a>] 
b43_calc_nrssi_slope+0xa69/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.976629]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.976705]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.976780]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.976840]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1502.976896]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.976951]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.977008]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1502.977067]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.977123]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.977178]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.977232]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1502.977289] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1502.977297] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1502.977354] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1502.977420]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.977498]  [<cf4a47e7>] 
b43_ofdmtab_write16+0x37/0x5b [b43]
Mar 31 21:46:37 Source kernel: [ 1502.977573]  [<cf4a56d2>] 
b43_set_all_gains+0x53/0xfd [b43]
Mar 31 21:46:37 Source kernel: [ 1502.977646]  [<cf4a4cc0>] 
b43_phy_write+0x3c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.977720]  [<cf4a636c>] 
b43_calc_nrssi_slope+0xa7b/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.977796]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.977870]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.977945]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.978004]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1502.978060]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.978116]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.978172]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1502.978230]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.978285]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.978339]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.978394]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1502.978449] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1502.978457] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1502.978513] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1502.978579]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.978656]  [<cf4a56d2>] 
b43_set_all_gains+0x53/0xfd [b43]
Mar 31 21:46:37 Source kernel: [ 1502.978729]  [<cf4a4cc0>] 
b43_phy_write+0x3c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.978803]  [<cf4a636c>] 
b43_calc_nrssi_slope+0xa7b/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.978878]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.978953]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.979029]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.979089]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1502.979144]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.979198]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.979255]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1502.979312]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.979368]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.979422]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.979477]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1502.979531] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1502.979539] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1502.979596] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1502.979661]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.979738]  [<cf4a56e1>] 
b43_set_all_gains+0x62/0xfd [b43]
Mar 31 21:46:37 Source kernel: [ 1502.979811]  [<cf4a4cc0>] 
b43_phy_write+0x3c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.979884]  [<cf4a636c>] 
b43_calc_nrssi_slope+0xa7b/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.979960]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.980054]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.980130]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.980189]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1502.980244]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.980299]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.980356]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1502.980413]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.980469]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.980524]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.980578]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1502.980633] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1502.980641] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1502.980697] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1502.980763]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.980839]  [<cf4a56f0>] 
b43_set_all_gains+0x71/0xfd [b43]
Mar 31 21:46:37 Source kernel: [ 1502.980912]  [<cf4a4cc0>] 
b43_phy_write+0x3c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.980987]  [<cf4a636c>] 
b43_calc_nrssi_slope+0xa7b/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.981063]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.981137]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.981212]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.981272]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1502.981327]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.981385]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.981442]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1502.981500]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.981555]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.981611]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.981665]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1502.981720] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1502.981728] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1502.981785] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1502.981851]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.981927]  [<cf4a56ff>] 
b43_set_all_gains+0x80/0xfd [b43]
Mar 31 21:46:37 Source kernel: [ 1502.982000]  [<cf4a4cc0>] 
b43_phy_write+0x3c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.982073]  [<cf4a636c>] 
b43_calc_nrssi_slope+0xa7b/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.982148]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.982224]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.982299]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.982358]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1502.982414]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.982468]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.982525]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1502.982583]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.982639]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.982694]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.982752]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1502.982806] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1502.982814] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1502.982871] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1502.982936]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.983012]  [<cf4a47e7>] 
b43_ofdmtab_write16+0x37/0x5b [b43]
Mar 31 21:46:37 Source kernel: [ 1502.983086]  [<cf4a5714>] 
b43_set_all_gains+0x95/0xfd [b43]
Mar 31 21:46:37 Source kernel: [ 1502.983159]  [<cf4a4cc0>] 
b43_phy_write+0x3c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.983233]  [<cf4a636c>] 
b43_calc_nrssi_slope+0xa7b/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.983309]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.983383]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.983458]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.983517]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1502.983576]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.983631]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.983687]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1502.983745]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.983801]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.983855]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.983909]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1502.983964] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1502.983973] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1502.984049] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1502.984115]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.984192]  [<cf4a5714>] 
b43_set_all_gains+0x95/0xfd [b43]
Mar 31 21:46:37 Source kernel: [ 1502.984266]  [<cf4a4cc0>] 
b43_phy_write+0x3c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.984339]  [<cf4a636c>] 
b43_calc_nrssi_slope+0xa7b/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.984414]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.984488]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.984563]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.984625]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1502.984681]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.984736]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.984792]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1502.984850]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.984906]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.984960]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.985016]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1502.985071] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1502.985079] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1502.985135] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1502.985200]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.985278]  [<cf4a5714>] 
b43_set_all_gains+0x95/0xfd [b43]
Mar 31 21:46:37 Source kernel: [ 1502.985352]  [<cf4a4cc0>] 
b43_phy_write+0x3c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.985425]  [<cf4a636c>] 
b43_calc_nrssi_slope+0xa7b/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.985501]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.985577]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.985652]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.985712]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1502.985769]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.985825]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.985882]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1502.985939]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.985995]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.986049]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.986104]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1502.986159] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1502.986167] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1502.987571] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1502.987636]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.987714]  [<cf4a5714>] 
b43_set_all_gains+0x95/0xfd [b43]
Mar 31 21:46:37 Source kernel: [ 1502.987788]  [<cf4a4cc0>] 
b43_phy_write+0x3c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.987861]  [<cf4a636c>] 
b43_calc_nrssi_slope+0xa7b/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.987936]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.988011]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.988107]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.988167]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1502.988223]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.988280]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.988337]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1502.988394]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.988450]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.988505]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.988560]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1502.988615] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1502.988623] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1502.988680] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1502.988746]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.988823]  [<cf4a5714>] 
b43_set_all_gains+0x95/0xfd [b43]
Mar 31 21:46:37 Source kernel: [ 1502.988898]  [<cf4a4cc0>] 
b43_phy_write+0x3c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.988972]  [<cf4a636c>] 
b43_calc_nrssi_slope+0xa7b/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.989048]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.989122]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.989198]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.989258]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1502.989313]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.989369]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.989425]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1502.989484]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.989540]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.989594]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.989649]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1502.989707] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1502.989715] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1502.989771] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1502.989837]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.989916]  [<cf4a5714>] 
b43_set_all_gains+0x95/0xfd [b43]
Mar 31 21:46:37 Source kernel: [ 1502.989989]  [<cf4a4cc0>] 
b43_phy_write+0x3c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.990063]  [<cf4a636c>] 
b43_calc_nrssi_slope+0xa7b/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.990138]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.990213]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.990288]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.990348]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1502.990406]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.990461]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.990518]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1502.990575]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.990630]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.990686]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.990741]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1502.990796] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1502.990804] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1502.990861] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1502.990929]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.991005]  [<cf4a5714>] 
b43_set_all_gains+0x95/0xfd [b43]
Mar 31 21:46:37 Source kernel: [ 1502.991079]  [<cf4a4cc0>] 
b43_phy_write+0x3c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.991153]  [<cf4a636c>] 
b43_calc_nrssi_slope+0xa7b/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.991228]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.991303]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.991378]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.991438]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1502.991494]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.991549]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.991606]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1502.991663]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.991719]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.991774]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.991829]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1502.991884] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1502.991892] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1502.991948] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1502.992013]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.992110]  [<cf4a5714>] 
b43_set_all_gains+0x95/0xfd [b43]
Mar 31 21:46:37 Source kernel: [ 1502.992184]  [<cf4a4cc0>] 
b43_phy_write+0x3c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.992257]  [<cf4a636c>] 
b43_calc_nrssi_slope+0xa7b/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.992332]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.992406]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.992481]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.992540]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1502.992598]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.992653]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.992709]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1502.992767]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.992823]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.992877]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.992931]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1502.992986] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1502.992994] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1502.993051] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1502.993117]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.993193]  [<cf4a5714>] 
b43_set_all_gains+0x95/0xfd [b43]
Mar 31 21:46:37 Source kernel: [ 1502.993266]  [<cf4a4cc0>] 
b43_phy_write+0x3c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.993339]  [<cf4a636c>] 
b43_calc_nrssi_slope+0xa7b/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.993414]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.993489]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.993563]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.993623]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1502.993678]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.993733]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.993790]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1502.993847]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.993903]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.993957]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.994011]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1502.994067] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1502.994076] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1502.994132] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1502.994198]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.994275]  [<cf4a5714>] 
b43_set_all_gains+0x95/0xfd [b43]
Mar 31 21:46:37 Source kernel: [ 1502.994349]  [<cf4a4cc0>] 
b43_phy_write+0x3c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.994422]  [<cf4a636c>] 
b43_calc_nrssi_slope+0xa7b/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.994498]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.994572]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.994648]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.994708]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1502.994763]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.994820]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.994876]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1502.994933]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.994989]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.995044]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.995099]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1502.995155] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1502.995163] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1502.995219] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1502.995285]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.995361]  [<cf4a5714>] 
b43_set_all_gains+0x95/0xfd [b43]
Mar 31 21:46:37 Source kernel: [ 1502.995436]  [<cf4a4cc0>] 
b43_phy_write+0x3c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.995508]  [<cf4a636c>] 
b43_calc_nrssi_slope+0xa7b/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.995584]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.995660]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.995735]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.995795]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1502.995851]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.995906]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.995965]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1502.996045]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.996102]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.996157]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.996212]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1502.996267] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1502.996275] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1502.996331] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1502.996397]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.996474]  [<cf4a5714>] 
b43_set_all_gains+0x95/0xfd [b43]
Mar 31 21:46:37 Source kernel: [ 1502.996547]  [<cf4a4cc0>] 
b43_phy_write+0x3c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.996620]  [<cf4a636c>] 
b43_calc_nrssi_slope+0xa7b/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.996696]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.996773]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.996848]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.996908]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1502.996963]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.997018]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.997078]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1502.997138]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.997194]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.997248]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.997302]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1502.997360] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1502.997369] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1502.997425] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1502.997490]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.997567]  [<cf4a5714>] 
b43_set_all_gains+0x95/0xfd [b43]
Mar 31 21:46:37 Source kernel: [ 1502.997640]  [<cf4a4cc0>] 
b43_phy_write+0x3c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.997714]  [<cf4a636c>] 
b43_calc_nrssi_slope+0xa7b/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.997791]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.997865]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.997940]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.997999]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1502.998055]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.998110]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.998166]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1502.998224]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1502.998281]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.998336]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1502.998391]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1502.998446] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1502.998454] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1502.998510] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1502.998578]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.998654]  [<cf4a5714>] 
b43_set_all_gains+0x95/0xfd [b43]
Mar 31 21:46:37 Source kernel: [ 1502.998727]  [<cf4a4cc0>] 
b43_phy_write+0x3c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.998801]  [<cf4a636c>] 
b43_calc_nrssi_slope+0xa7b/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.998876]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1502.998950]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.999027]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1502.999086]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1502.999141]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.000568]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.000625]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.000682]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.000738]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.000793]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.000847]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.000902] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.000911] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.000967] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.001033]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.001111]  [<cf4a5714>] 
b43_set_all_gains+0x95/0xfd [b43]
Mar 31 21:46:37 Source kernel: [ 1503.001184]  [<cf4a4cc0>] 
b43_phy_write+0x3c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.001258]  [<cf4a636c>] 
b43_calc_nrssi_slope+0xa7b/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.001333]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.001410]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.001485]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.001544]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.001599]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.001654]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.001713]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.001770]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.001825]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.001880]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.001936]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.001991] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.001999] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.002059] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.002125]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.002201]  [<cf4a5714>] 
b43_set_all_gains+0x95/0xfd [b43]
Mar 31 21:46:37 Source kernel: [ 1503.002274]  [<cf4a4cc0>] 
b43_phy_write+0x3c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.002347]  [<cf4a636c>] 
b43_calc_nrssi_slope+0xa7b/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.002423]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.002497]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.002572]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.002633]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.002689]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.002744]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.002800]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.002857]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.002913]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.002967]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.003022]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.003077] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.003085] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.003141] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.003207]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.003285]  [<cf4a5714>] 
b43_set_all_gains+0x95/0xfd [b43]
Mar 31 21:46:37 Source kernel: [ 1503.003359]  [<cf4a4cc0>] 
b43_phy_write+0x3c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.003432]  [<cf4a636c>] 
b43_calc_nrssi_slope+0xa7b/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.003509]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.003583]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.003658]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.003717]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.003775]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.003829]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.003886]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.003944]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.003999]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.004074]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.004130]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.004188] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.004196] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.004253] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.004318]  [<cf4a4ced>] 
b43_phy_read+0x28/0x38 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.004395]  [<cf4a4d13>] 
b43_phy_maskset+0x16/0x2a [b43]
Mar 31 21:46:37 Source kernel: [ 1503.004469]  [<cf4a5747>] 
b43_set_all_gains+0xc8/0xfd [b43]
Mar 31 21:46:37 Source kernel: [ 1503.004542]  [<cf4a4cc0>] 
b43_phy_write+0x3c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.004616]  [<cf4a636c>] 
b43_calc_nrssi_slope+0xa7b/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.004691]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.004766]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.004842]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.004901]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.004957]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.005013]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.005069]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.005126]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.005181]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.005239]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.005293]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.005349] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.005357] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.005413] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.005479]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.005557]  [<cf4a5747>] 
b43_set_all_gains+0xc8/0xfd [b43]
Mar 31 21:46:37 Source kernel: [ 1503.005632]  [<cf4a4cc0>] 
b43_phy_write+0x3c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.005706]  [<cf4a636c>] 
b43_calc_nrssi_slope+0xa7b/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.005781]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.005857]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.005932]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.005991]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.006046]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.006102]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.006160]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.006217]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.006272]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.006327]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.006382]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.006437] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.006445] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.006503] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.006569]  [<cf4a4ced>] 
b43_phy_read+0x28/0x38 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.006645]  [<cf4a4d13>] 
b43_phy_maskset+0x16/0x2a [b43]
Mar 31 21:46:37 Source kernel: [ 1503.006718]  [<cf4a5759>] 
b43_set_all_gains+0xda/0xfd [b43]
Mar 31 21:46:37 Source kernel: [ 1503.006791]  [<cf4a4cc0>] 
b43_phy_write+0x3c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.006864]  [<cf4a636c>] 
b43_calc_nrssi_slope+0xa7b/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.006940]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.007014]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.007090]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.007150]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.007207]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.007261]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.007318]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.007375]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.007430]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.007484]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.007539]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.007595] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.007603] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.007660] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.007726]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.007802]  [<cf4a5759>] 
b43_set_all_gains+0xda/0xfd [b43]
Mar 31 21:46:37 Source kernel: [ 1503.007875]  [<cf4a4cc0>] 
b43_phy_write+0x3c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.007948]  [<cf4a636c>] 
b43_calc_nrssi_slope+0xa7b/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.008045]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.008120]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.008195]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.008254]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.008309]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.008364]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.008420]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.008478]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.008533]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.008587]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.008641]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.008696] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.008704] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.008761] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.008827]  [<cf4a4ced>] 
b43_phy_read+0x28/0x38 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.008903]  [<cf4a4d13>] 
b43_phy_maskset+0x16/0x2a [b43]
Mar 31 21:46:37 Source kernel: [ 1503.008976]  [<cf4a576b>] 
b43_set_all_gains+0xec/0xfd [b43]
Mar 31 21:46:37 Source kernel: [ 1503.009050]  [<cf4a4cc0>] 
b43_phy_write+0x3c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.009122]  [<cf4a636c>] 
b43_calc_nrssi_slope+0xa7b/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.009198]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.009272]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.009349]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.009409]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.009464]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.009520]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.009576]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.009634]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.009690]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.009747]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.009802]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.009857] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.009865] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.009922] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.009987]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.010063]  [<cf4a576b>] 
b43_set_all_gains+0xec/0xfd [b43]
Mar 31 21:46:37 Source kernel: [ 1503.010136]  [<cf4a4cc0>] 
b43_phy_write+0x3c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.010209]  [<cf4a636c>] 
b43_calc_nrssi_slope+0xa7b/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.010284]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.010360]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.010434]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.010493]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.010548]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.010605]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.010661]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.010718]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.010774]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.010828]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.010883]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.011050] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.011058] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.011114] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.011181]  [<cf4a4d97>] 
b43_radio_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.011260]  [<cf4a63be>] 
b43_calc_nrssi_slope+0xacd/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.011336]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.011412]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.011487]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.011547]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.011602]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.011657]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.011716]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.011774]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.011829]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.011884]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.011939]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.011994] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.012002] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.012080] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.012148]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.013567]  [<cf4a63cf>] 
b43_calc_nrssi_slope+0xade/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.013643]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.013717]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.013795]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.013854]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.013910]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.013964]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.014022]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.014079]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.014134]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.014191]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.014246]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.014301] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.014309] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.014365] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.014433]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.014510]  [<cf4a63e0>] 
b43_calc_nrssi_slope+0xaef/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.014586]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.014661]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.014737]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.014798]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.014855]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.014910]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.014966]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.015024]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.015082]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.015137]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.015191]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.015246] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.015256] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.015312] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.015378]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.015456]  [<cf4a63f1>] 
b43_calc_nrssi_slope+0xb00/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.015531]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.015606]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.015681]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.015741]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.015796]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.015851]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.015910]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.015969]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.016045]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.016102]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.016156]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.016230] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.016240] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.016296] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.016362]  [<cf4a4ced>] 
b43_phy_read+0x28/0x38 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.016439]  [<cf4a6407>] 
b43_calc_nrssi_slope+0xb16/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.016514]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.016590]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.016665]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.016725]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.016780]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.016835]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.016894]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.016952]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.017008]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.017063]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.017118]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.017176] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.017184] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.017241] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.017307]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.017383]  [<cf4a647c>] 
b43_calc_nrssi_slope+0xb8b/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.017459]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.017533]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.017609]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.017669]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.017725]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.017783]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.017839]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.017896]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.017953]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.018007]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.018062]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.018116] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.018124] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.018181] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.018246]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.018322]  [<cf4a648d>] 
b43_calc_nrssi_slope+0xb9c/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.018400]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.018474]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.018548]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.018609]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.018664]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.018719]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.018776]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.018833]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.018891]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.018945]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.019000]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.019054] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.019063] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.019119] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.019185]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.019263]  [<cf4a649e>] 
b43_calc_nrssi_slope+0xbad/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.019339]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.019415]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.019490]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.019549]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.019605]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.019660]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.019720]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.019777]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.019832]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.019887]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.019943]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.019997] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.020028] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.020085] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.020151]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.020228]  [<cf4a64af>] 
b43_calc_nrssi_slope+0xbbe/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.020303]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.020377]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.020452]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.020513]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.020569]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.020623]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.020680]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.020738]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.020794]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.020848]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.020902]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.020959] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.020967] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.021023] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.021089]  [<cf4a4ced>] 
b43_phy_read+0x28/0x38 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.021166]  [<cf4a4d5a>] 
b43_phy_mask+0x11/0x22 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.021238]  [<cf4a64c6>] 
b43_calc_nrssi_slope+0xbd5/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.021313]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.021390]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.021466]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.021525]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.021581]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.021635]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.021692]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.021749]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.021805]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.021860]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.021914]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.021969] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.021977] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.022034] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.022100]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.022177]  [<cf4a64c6>] 
b43_calc_nrssi_slope+0xbd5/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.022252]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.022327]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.022402]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.022461]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.022516]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.022571]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.022628]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.022685]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.022740]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.022794]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.022849]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.022903] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.022911] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.022968] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.023033]  [<cf4a4ced>] 
b43_phy_read+0x28/0x38 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.023109]  [<cf4a4d5a>] 
b43_phy_mask+0x11/0x22 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.023181]  [<cf4a64d7>] 
b43_calc_nrssi_slope+0xbe6/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.023258]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.023332]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.023407]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.023468]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.023523]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.023595]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.023653]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.023710]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.023766]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.023820]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.023875]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.023930] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.023939] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.023995] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.024082]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.024159]  [<cf4a64d7>] 
b43_calc_nrssi_slope+0xbe6/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.024234]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.024310]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.024385]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.024446]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.024501]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.024556]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.024615]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.024674]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.024731]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.024785]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.024839]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.024896] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.024904] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.026322] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.026388]  [<cf4a4d97>] 
b43_radio_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.026465]  [<cf4a64e8>] 
b43_calc_nrssi_slope+0xbf7/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.026541]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.026615]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.026691]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.026750]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.026806]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.026864]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.026920]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.026977]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.027033]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.027089]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.027144]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.027199] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.027207] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.027264] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.027330]  [<cf4a4d97>] 
b43_radio_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.027407]  [<cf4a64f9>] 
b43_calc_nrssi_slope+0xc08/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.027484]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.027558]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.027633]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.027693]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.027751]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.027806]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.027862]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.027919]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.027977]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.028051]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.028107]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.028163] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.028171] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.028229] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.028295]  [<cf4a4d97>] 
b43_radio_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.028373]  [<cf4a650a>] 
b43_calc_nrssi_slope+0xc19/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.028449]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.028524]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.028599]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.028659]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.028715]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.028771]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.028828]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.028885]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.028941]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.028996]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.029050]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.029105] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.029113] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.029170] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.029240]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.029318]  [<cf4a654e>] 
b43_calc_nrssi_slope+0xc5d/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.029394]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.029468]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.029542]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.029602]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.029661]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.029715]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.029772]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.029829]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.029885]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.029939]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.029994]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.030049] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.030058] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.030114] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.030183]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.030260]  [<cf4a655f>] 
b43_calc_nrssi_slope+0xc6e/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.030337]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.030412]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.030486]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.030548]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.030604]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.030659]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.030715]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.030773]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.030829]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.030883]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.030938]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.030993] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.031001] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.031058] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.031127]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.031206]  [<cf4a6570>] 
b43_calc_nrssi_slope+0xc7f/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.031282]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.031358]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.031433]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.031492]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.031547]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.031602]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.031662]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.031721]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.031776]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.031830]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.031884]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.031939] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.031947] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.032026] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.032097]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.032176]  [<cf4a6581>] 
b43_calc_nrssi_slope+0xc90/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.032253]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.032327]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.032401]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.032461]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.032519]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.032574]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.032630]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.032687]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.032744]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.032798]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.032853]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.032911] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.032919] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.032975] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.033043]  [<cf4a4ced>] 
b43_phy_read+0x28/0x38 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.033119]  [<cf4a4d38>] 
b43_phy_set+0x11/0x22 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.033194]  [<cf4a659d>] 
b43_calc_nrssi_slope+0xcac/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.033269]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.033344]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.033419]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.033478]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.033536]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.033591]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.033647]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.033705]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.033760]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.033814]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.033869]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.033925] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.033933] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.033989] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.034060]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.034138]  [<cf4a659d>] 
b43_calc_nrssi_slope+0xcac/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.034214]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.034288]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.034363]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.034424]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.034479]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.034535]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.034591]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.034648]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.034705]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.034759]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.034813]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.034869] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.034877] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.034933] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.034999]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.035078]  [<cf4a47e7>] 
b43_ofdmtab_write16+0x37/0x5b [b43]
Mar 31 21:46:37 Source kernel: [ 1503.035153]  [<cf4a57dc>] 
b43_set_original_gains+0x60/0xd9 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.035230]  [<cf4a65a4>] 
b43_calc_nrssi_slope+0xcb3/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.035306]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.035381]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.035457]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.035517]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.035572]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.035630]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.035686]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.035743]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.035798]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.035853]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.035908]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.035962] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.035970] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.036046] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.036113]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.036190]  [<cf4a57dc>] 
b43_set_original_gains+0x60/0xd9 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.036269]  [<cf4a65a4>] 
b43_calc_nrssi_slope+0xcb3/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.036344]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.036418]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.036494]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.036553]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.036608]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.036663]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.036719]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.036777]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.036832]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.036886]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.036941]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.036996] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.037004] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.037060] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.037126]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.037201]  [<cf4a57dc>] 
b43_set_original_gains+0x60/0xd9 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.037278]  [<cf4a65a4>] 
b43_calc_nrssi_slope+0xcb3/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.037353]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.037428]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.037502]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.037562]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.037617]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.037672]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.037730]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.039130]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.039187]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.039242]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.039296]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.039353] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.039361] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.039417] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.039484]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.039560]  [<cf4a57dc>] 
b43_set_original_gains+0x60/0xd9 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.039638]  [<cf4a65a4>] 
b43_calc_nrssi_slope+0xcb3/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.039713]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.039787]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.039861]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.039920]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.039978]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.040053]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.040113]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.040171]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.040227]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.040281]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.040336]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.040393] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.040402] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.040458] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.040524]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.040601]  [<cf4a57dc>] 
b43_set_original_gains+0x60/0xd9 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.040679]  [<cf4a65a4>] 
b43_calc_nrssi_slope+0xcb3/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.040754]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.040828]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.040902]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.040961]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.041016]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.041072]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.041129]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.041189]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.041244]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.041299]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.041354]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.041412] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.041420] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.041476] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.041542]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.041621]  [<cf4a47e7>] 
b43_ofdmtab_write16+0x37/0x5b [b43]
Mar 31 21:46:37 Source kernel: [ 1503.041695]  [<cf4a57fc>] 
b43_set_original_gains+0x80/0xd9 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.041773]  [<cf4a65a4>] 
b43_calc_nrssi_slope+0xcb3/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.041848]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.041922]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.041999]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.042059]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.042115]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.042173]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.042229]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.042286]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.042342]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.042398]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.042453]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.042508] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.042516] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.042572] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.042638]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.042714]  [<cf4a57fc>] 
b43_set_original_gains+0x80/0xd9 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.042794]  [<cf4a65a4>] 
b43_calc_nrssi_slope+0xcb3/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.042870]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.042944]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.043018]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.043078]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.043133]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.043190]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.043246]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.043304]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.043359]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.043414]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.043468]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.043523] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.043531] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.043588] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.043653]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.043730]  [<cf4a57fc>] 
b43_set_original_gains+0x80/0xd9 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.043810]  [<cf4a65a4>] 
b43_calc_nrssi_slope+0xcb3/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.043885]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.043959]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.044053]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.044114]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.044171]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.044226]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.044282]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.044340]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.044399]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.044454]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.044509]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.044564] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.044573] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.044629] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.044694]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.044770]  [<cf4a57fc>] 
b43_set_original_gains+0x80/0xd9 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.044848]  [<cf4a65a4>] 
b43_calc_nrssi_slope+0xcb3/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.044924]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.044998]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.045073]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.045133]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.045192]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.045247]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.045336]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.045393]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.045449]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.045503]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.045557]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.045612] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.045620] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.045677] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.045745]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.045822]  [<cf4a57fc>] 
b43_set_original_gains+0x80/0xd9 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.045899]  [<cf4a65a4>] 
b43_calc_nrssi_slope+0xcb3/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.045974]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.046048]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.046125]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.046184]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.046240]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.046295]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.046352]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.046410]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.046465]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.046522]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.046576]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.046631] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.046639] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.046695] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.046762]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.046839]  [<cf4a57fc>] 
b43_set_original_gains+0x80/0xd9 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.046916]  [<cf4a65a4>] 
b43_calc_nrssi_slope+0xcb3/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.046992]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.047065]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.047142]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.047202]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.047257]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.047315]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.047372]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.047429]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.047484]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.047541]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.047595]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.047650] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.047658] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.047714] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.047780]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.047856]  [<cf4a57fc>] 
b43_set_original_gains+0x80/0xd9 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.047934]  [<cf4a65a4>] 
b43_calc_nrssi_slope+0xcb3/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.048010]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.048104]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.048180]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.048241]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.048297]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.048352]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.048408]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.048466]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.048521]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.048576]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.048631]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.048686] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.048694] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.048750] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.048815]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.048893]  [<cf4a57fc>] 
b43_set_original_gains+0x80/0xd9 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.048971]  [<cf4a65a4>] 
b43_calc_nrssi_slope+0xcb3/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.049046]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.049120]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.049194]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.049256]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.049311]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.049366]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.049423]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.049480]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.049535]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.049589]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.049644]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.049701] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.049709] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.049765] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.049831]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.049910]  [<cf4a57fc>] 
b43_set_original_gains+0x80/0xd9 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.049988]  [<cf4a65a4>] 
b43_calc_nrssi_slope+0xcb3/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.050063]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.050137]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.050211]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.050270]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.050326]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.050381]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.050437]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.050495]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.050551]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.050606]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.051900]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.051955] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.051963] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.052039] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.052106]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.052182]  [<cf4a57fc>] 
b43_set_original_gains+0x80/0xd9 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.052261]  [<cf4a65a4>] 
b43_calc_nrssi_slope+0xcb3/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.052337]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.052411]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.052486]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.052545]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.052600]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.052657]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.052715]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.052773]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.052828]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.052882]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.052939]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.052994] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.053002] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.053058] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.053124]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.053201]  [<cf4a57fc>] 
b43_set_original_gains+0x80/0xd9 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.053278]  [<cf4a65a4>] 
b43_calc_nrssi_slope+0xcb3/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.053354]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.053429]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.053504]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.053564]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.053620]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.053675]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.053734]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.053793]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.053848]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.053903]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.053958]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.054013] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.054021] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.054080] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.054145]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.054222]  [<cf4a57fc>] 
b43_set_original_gains+0x80/0xd9 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.054300]  [<cf4a65a4>] 
b43_calc_nrssi_slope+0xcb3/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.054376]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.054450]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.054524]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.054584]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.054639]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.054694]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.054751]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.054810]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.054866]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.054920]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.054974]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.055031] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.055039] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.055096] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.055162]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.055238]  [<cf4a57fc>] 
b43_set_original_gains+0x80/0xd9 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.055315]  [<cf4a65a4>] 
b43_calc_nrssi_slope+0xcb3/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.055391]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.055465]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.055539]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.055599]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.055654]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.055709]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.055767]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.055826]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.055882]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.055936]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.055991]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.056068] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.056077] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.056133] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.056199]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.056276]  [<cf4a57fc>] 
b43_set_original_gains+0x80/0xd9 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.056354]  [<cf4a65a4>] 
b43_calc_nrssi_slope+0xcb3/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.056430]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.056504]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.056579]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.056639]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.056694]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.056752]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.056808]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.056866]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.056921]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.056976]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.057031]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.057085] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.057093] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.057150] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.057215]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.057291]  [<cf4a57fc>] 
b43_set_original_gains+0x80/0xd9 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.057369]  [<cf4a65a4>] 
b43_calc_nrssi_slope+0xcb3/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.057444]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.057518]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.057594]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.057654]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.057709]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.057767]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.057823]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.057881]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.057936]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.057992]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.058046]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.058100] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.058109] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.058165] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.058231]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.058307]  [<cf4a57fc>] 
b43_set_original_gains+0x80/0xd9 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.058384]  [<cf4a65a4>] 
b43_calc_nrssi_slope+0xcb3/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.058460]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.058534]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.058610]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.058669]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.058725]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.058783]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.058840]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.058897]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.058952]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.059007]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.059061]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.059117] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.059125] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.059181] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.059247]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.059323]  [<cf4a57fc>] 
b43_set_original_gains+0x80/0xd9 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.059402]  [<cf4a65a4>] 
b43_calc_nrssi_slope+0xcb3/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.059477]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.059551]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.059626]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.059685]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.059740]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.059798]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.059855]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.059912]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.059968]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.060044]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.060099]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.060153] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.060161] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.060217] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.060283]  [<cf4a4ced>] 
b43_phy_read+0x28/0x38 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.060362]  [<cf4a4d13>] 
b43_phy_maskset+0x16/0x2a [b43]
Mar 31 21:46:37 Source kernel: [ 1503.060435]  [<cf4a581b>] 
b43_set_original_gains+0x9f/0xd9 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.060513]  [<cf4a65a4>] 
b43_calc_nrssi_slope+0xcb3/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.060589]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.060663]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.060739]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.060799]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.060854]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.060912]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.060969]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.061026]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.061082]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.061137]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.061191]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.061248] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.061256] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.061312] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.061378]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.061455]  [<cf4a581b>] 
b43_set_original_gains+0x9f/0xd9 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.061534]  [<cf4a65a4>] 
b43_calc_nrssi_slope+0xcb3/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.061609]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.061684]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.061758]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.061818]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.061874]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.061929]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.061986]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.062043]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.062099]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.062154]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.062208]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.062262] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.062271] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.062327] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.062392]  [<cf4a4ced>] 
b43_phy_read+0x28/0x38 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.062468]  [<cf4a4d13>] 
b43_phy_maskset+0x16/0x2a [b43]
Mar 31 21:46:37 Source kernel: [ 1503.062541]  [<cf4a5831>] 
b43_set_original_gains+0xb5/0xd9 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.062618]  [<cf4a65a4>] 
b43_calc_nrssi_slope+0xcb3/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.062693]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.062769]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.062843]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.062903]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.062958]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.063013]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.063071]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.063129]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.063185]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.063239]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.063294]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.063350] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.063358] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.064736] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.064804]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.064881]  [<cf4a5831>] 
b43_set_original_gains+0xb5/0xd9 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.064960]  [<cf4a65a4>] 
b43_calc_nrssi_slope+0xcb3/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.065036]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.065111]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.065186]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.065245]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.065301]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.065356]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.065412]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.065470]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.065525]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.065580]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.065634]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.065689] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.065697] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.065753] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.065819]  [<cf4a4ced>] 
b43_phy_read+0x28/0x38 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.065895]  [<cf4a4d13>] 
b43_phy_maskset+0x16/0x2a [b43]
Mar 31 21:46:37 Source kernel: [ 1503.065969]  [<cf4a5847>] 
b43_set_original_gains+0xcb/0xd9 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.066047]  [<cf4a65a4>] 
b43_calc_nrssi_slope+0xcb3/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.066122]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.066199]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.066274]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.066334]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.066390]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.066446]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.066503]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.066562]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.066617]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.066672]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.066727]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.066785] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.066793] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.066850] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.066916]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.066992]  [<cf4a5847>] 
b43_set_original_gains+0xcb/0xd9 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.067070]  [<cf4a65a4>] 
b43_calc_nrssi_slope+0xcb3/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.067146]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.067220]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.067294]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.067354]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.067409]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.067464]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.067521]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.067581]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.067637]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.067691]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.067745]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.067914] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.067923] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.067978] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.068064]  [<cf4a4ced>] 
b43_phy_read+0x28/0x38 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.068143]  [<cf4a4d38>] 
b43_phy_set+0x11/0x22 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.068218]  [<cf4a65b5>] 
b43_calc_nrssi_slope+0xcc4/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.068295]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.068369]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.068443]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.068504]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.068559]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.068615]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.068671]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.068728]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.068784]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.068838]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.068893]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.068949] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.068957] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.069013] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.069083]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.069161]  [<cf4a65b5>] 
b43_calc_nrssi_slope+0xcc4/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.069237]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.069313]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.069388]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.069447]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.069502]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.069557]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.069616]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.069675]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.069731]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.069785]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.069840]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.069896] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.069904] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.069961] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.070031]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.070110]  [<cf4a65cc>] 
b43_calc_nrssi_slope+0xcdb/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.070186]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.070262]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.070338]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.070397]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.070452]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.070507]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.070567]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.070624]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.070680]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.070734]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.070791]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.070847] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.070855] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.070914] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.070982]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.071063]  [<cf4a65dd>] 
b43_calc_nrssi_slope+0xcec/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.071139]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.071216]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.071291]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.071351]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.071406]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.071461]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.071519]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.071576]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.071632]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.071687]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.071742]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.071797] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.071805] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.071864] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.071933]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.072011]  [<cf4a65ee>] 
b43_calc_nrssi_slope+0xcfd/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.072107]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.072182]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.072257]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.072317]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.072373]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.072428]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.072484]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.072541]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.072600]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.072655]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.072709]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.072764] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.072774] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.072830] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.072901]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.072979]  [<cf4a65ff>] 
b43_calc_nrssi_slope+0xd0e/0xd71 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.073054]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.073128]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.073203]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.073264]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.073319]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.073374]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.073430]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.073489]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.073545]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.073599]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.073653]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.073716] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.073724] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.073780] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.073846]  [<cf4a4ced>] 
b43_phy_read+0x28/0x38 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.073922]  [<cf4a55d8>] 
b43_calc_nrssi_threshold+0x10b/0x149 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.073997]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.074073]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.074147]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.074206]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.074262]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.074317]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.074374]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.074431]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.074487]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.074541]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.074599]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.074655] b43-phy1 debug: PHY/RADIO 
register access with enabled MAC.
Mar 31 21:46:37 Source kernel: [ 1503.074663] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.074719] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.074784]  [<cf4a4cb0>] 
b43_phy_write+0x2c/0x41 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.074861]  [<cf4a6684>] 
b43_gphy_op_pwork_60sec+0x22/0x65 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.074936]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.075010]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.075071]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.075127]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.075182]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.075238]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.075298]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.075353]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.075408]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.075462]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.260151] ------------[ cut here 
]------------
Mar 31 21:46:37 Source kernel: [ 1503.260221] WARNING: at 
drivers/net/wireless/b43/main.c:2550 b43_mac_enable+0x64/0xc4 [b43]()
Mar 31 21:46:37 Source kernel: [ 1503.260292] Hardware name: 
Mocha/Moorea   
Mar 31 21:46:37 Source kernel: [ 1503.260344] Modules linked in: b43 
aes_i586 aes_generic rfkill_input ppdev lp xt_dscp xt_multiport xt_MARK 
xt_state ipt_REJECT iptable_filter ipt_MASQUERADE ipt_REDIRECT xt_tcpudp 
iptable_nat nfsd exportfs nfs lockd nfs_acl auth_rpcgss sunrpc cls_fw 
sch_sfq sch_htb ipv6 iptable_mangle ip_tables x_tables nf_nat_irc 
nf_conntrack_irc nf_nat_ftp nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 
nf_conntrack_ftp nf_conntrack fuse psmouse arc4 ecb rfkill rng_core 
mac80211 cfg80211 led_class input_polldev snd_via82xx gameport 
snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc 
snd_mpu401_uart snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi 
snd_seq_midi_event snd_seq snd_timer snd_seq_device snd pcspkr evdev 
soundcore ssb via686a i2c_viapro i2c_core via_agp agpgart shpchp 
pci_hotplug parport_pc parport container button reiserfs dm_mirror 
dm_region_hash dm_log dm_snapshot dm_mod ide_cd_mod cdrom ide_gd_mod 
ata_generic libata scsi_mod ide_pci_generic uhci_hcd ehci_hcd via82
Mar 31 21:46:37 Source kernel: xxx 8139cp 8139too mii usbcore ide_core 
thermal processor fan thermal_sys [last unloaded: b43]
Mar 31 21:46:37 Source kernel: [ 1503.265719] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.265776] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.265848]  [<c011bb0c>] 
warn_slowpath+0x80/0xb5
Mar 31 21:46:37 Source kernel: [ 1503.265913]  [<c029adfc>] 
schedule_timeout+0x9a/0xaf
Mar 31 21:46:37 Source kernel: [ 1503.265978]  [<c01227f8>] 
process_timeout+0x0/0x5
Mar 31 21:46:37 Source kernel: [ 1503.266034]  [<c0122bdc>] msleep+0xd/0x12
Mar 31 21:46:37 Source kernel: [ 1503.266105]  [<cf4a1d4a>] 
b43_mac_enable+0x64/0xc4 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.266191]  [<cf4a3f16>] 
b43_periodic_work_handler+0x53/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.266266]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.266329]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.266385]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.266441]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.266506]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.266564]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.266620]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.266674]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.266736]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.266791] ---[ end trace 
9a27304ff7b46a37 ]---
Mar 31 21:46:37 Source kernel: [ 1503.266881] ------------[ cut here 
]------------
Mar 31 21:46:37 Source kernel: [ 1503.266936] WARNING: at 
drivers/net/wireless/b43/main.c:2571 b43_mac_suspend+0x1e/0xbf [b43]()
Mar 31 21:46:37 Source kernel: [ 1503.267006] Hardware name: 
Mocha/Moorea   
Mar 31 21:46:37 Source kernel: [ 1503.267058] Modules linked in: b43 
aes_i586 aes_generic rfkill_input ppdev lp xt_dscp xt_multiport xt_MARK 
xt_state ipt_REJECT iptable_filter ipt_MASQUERADE ipt_REDIRECT xt_tcpudp 
iptable_nat nfsd exportfs nfs lockd nfs_acl auth_rpcgss sunrpc cls_fw 
sch_sfq sch_htb ipv6 iptable_mangle ip_tables x_tables nf_nat_irc 
nf_conntrack_irc nf_nat_ftp nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 
nf_conntrack_ftp nf_conntrack fuse psmouse arc4 ecb rfkill rng_core 
mac80211 cfg80211 led_class input_polldev snd_via82xx gameport 
snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc 
snd_mpu401_uart snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi 
snd_seq_midi_event snd_seq snd_timer snd_seq_device snd pcspkr evdev 
soundcore ssb via686a i2c_viapro i2c_core via_agp agpgart shpchp 
pci_hotplug parport_pc parport container button reiserfs dm_mirror 
dm_region_hash dm_log dm_snapshot dm_mod ide_cd_mod cdrom ide_gd_mod 
ata_generic libata scsi_mod ide_pci_generic uhci_hcd ehci_hcd via82
Mar 31 21:46:37 Source kernel: xxx 8139cp 8139too mii usbcore ide_core 
thermal processor fan thermal_sys [last unloaded: b43]
Mar 31 21:46:37 Source kernel: [ 1503.271044] Pid: 3793, comm: phy1 
Tainted: G        W  2.6.29-wl #6
Mar 31 21:46:37 Source kernel: [ 1503.271100] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.271152]  [<c011bb0c>] 
warn_slowpath+0x80/0xb5
Mar 31 21:46:37 Source kernel: [ 1503.271229]  [<cf49fc32>] 
__b43_shm_read32+0xac/0xb1 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.271304]  [<cf49f4f0>] 
__b43_shm_write16+0x91/0x97 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.271377]  [<cf4a1ab8>] 
b43_mac_suspend+0x1e/0xbf [b43]
Mar 31 21:46:37 Source kernel: [ 1503.271455]  [<cf4a7003>] 
b43_gphy_op_pwork_15sec+0x8/0x17 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.271530]  [<cf4a3fa9>] 
b43_periodic_work_handler+0xe6/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.271605]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.271666]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.271721]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.271776]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.271832]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.271890]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.271946]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.271999]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.272074]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.272130] ---[ end trace 
9a27304ff7b46a38 ]---
Mar 31 21:46:37 Source kernel: [ 1503.272207] BUG: unable to handle 
kernel NULL pointer dereference at (null)
Mar 31 21:46:37 Source kernel: [ 1503.272333] IP: [<cf4ad872>] 
b43_lo_g_maintanance_work+0x55/0x1b3 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.272447] *pde = 00000000
Mar 31 21:46:37 Source kernel: [ 1503.272532] Oops: 0000 [#1]
Mar 31 21:46:37 Source kernel: [ 1503.272617] last sysfs file: 
/sys/devices/virtual/input/input5/capabilities/sw
Mar 31 21:46:37 Source kernel: [ 1503.272686] Modules linked in: b43 
aes_i586 aes_generic rfkill_input ppdev lp xt_dscp xt_multiport xt_MARK 
xt_state ipt_REJECT iptable_filter ipt_MASQUERADE ipt_REDIRECT xt_tcpudp 
iptable_nat nfsd exportfs nfs lockd nfs_acl auth_rpcgss sunrpc cls_fw 
sch_sfq sch_htb ipv6 iptable_mangle ip_tables x_tables nf_nat_irc 
nf_conntrack_irc nf_nat_ftp nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 
nf_conntrack_ftp nf_conntrack fuse psmouse arc4 ecb rfkill rng_core 
mac80211 cfg80211 led_class input_polldev snd_via82xx gameport 
snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc 
snd_mpu401_uart snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi 
snd_seq_midi_event snd_seq snd_timer snd_seq_device snd pcspkr evdev 
soundcore ssb via686a i2c_viapro i2c_core via_agp agpgart shpchp 
pci_hotplug parport_pc parport container button reiserfs dm_mirror 
dm_region_hash dm_log dm_snapshot dm_mod ide_cd_mod cdrom ide_gd_mod 
ata_generic libata scsi_mod ide_pci_generic uhci_hcd ehci_hcd via82
Mar 31 21:46:37 Source kernel: xxx 8139cp 8139too mii usbcore ide_core 
thermal processor fan thermal_sys [last unloaded: b43]
Mar 31 21:46:37 Source kernel: [ 1503.276059]
Mar 31 21:46:37 Source kernel: [ 1503.276059] Pid: 3793, comm: phy1 
Tainted: G        W  (2.6.29-wl #6) Mocha/Moorea   
Mar 31 21:46:37 Source kernel: [ 1503.276059] EIP: 0060:[<cf4ad872>] 
EFLAGS: 00010246 CPU: 0
Mar 31 21:46:37 Source kernel: [ 1503.276059] EIP is at 
b43_lo_g_maintanance_work+0x55/0x1b3 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.276059] EAX: 00000000 EBX: 
fffffff4 ECX: cdbb9e80 EDX: cc948000
Mar 31 21:46:37 Source kernel: [ 1503.276059] ESI: cc948000 EDI: 
cc86a3e0 EBP: cc94dc00 ESP: cdbb9f68
Mar 31 21:46:37 Source kernel: [ 1503.276059]  DS: 007b ES: 007b FS: 
0000 GS: 0000 SS: 0068
Mar 31 21:46:37 Source kernel: [ 1503.276059] Process phy1 (pid: 3793, 
ti=cdbb8000 task=cce56420 task.ti=cdbb8000)
Mar 31 21:46:37 Source kernel: [ 1503.276059] Stack:
Mar 31 21:46:37 Source kernel: [ 1503.276059]  00047bba cc948000 
cf4a1ab8 cf4b3ab0 cc948000 00000000 cce7f920 cce7f928
Mar 31 21:46:37 Source kernel: [ 1503.276059]  cf4a700a cc948000 
cf4a3fa9 cc948274 ccc25760 cf4a3ec3 00000000 c0127664
Mar 31 21:46:37 Source kernel: [ 1503.276059]  ccc25760 c0127a29 
ccc25768 c0127ad6 00000000 cce56420 c012a29a cdbb9fc4
Mar 31 21:46:37 Source kernel: [ 1503.276059] Call Trace:
Mar 31 21:46:37 Source kernel: [ 1503.276059]  [<cf4a1ab8>] 
b43_mac_suspend+0x1e/0xbf [b43]
Mar 31 21:46:37 Source kernel: [ 1503.276059]  [<cf4a700a>] 
b43_gphy_op_pwork_15sec+0xf/0x17 [b43]
Mar 31 21:46:37 Source kernel: [ 1503.276059]  [<cf4a3fa9>] 
b43_periodic_work_handler+0xe6/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.276059]  [<cf4a3ec3>] 
b43_periodic_work_handler+0x0/0x13c [b43]
Mar 31 21:46:37 Source kernel: [ 1503.276059]  [<c0127664>] 
run_workqueue+0x74/0xec
Mar 31 21:46:37 Source kernel: [ 1503.276059]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.276059]  [<c0127ad6>] 
worker_thread+0xad/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.276059]  [<c012a29a>] 
autoremove_wake_function+0x0/0x2d
Mar 31 21:46:37 Source kernel: [ 1503.276059]  [<c0127a29>] 
worker_thread+0x0/0xb8
Mar 31 21:46:37 Source kernel: [ 1503.276059]  [<c0129eb7>] 
kthread+0x36/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.276059]  [<c0129e81>] kthread+0x0/0x5a
Mar 31 21:46:37 Source kernel: [ 1503.276059]  [<c01038e7>] 
kernel_thread_helper+0x7/0x10
Mar 31 21:46:37 Source kernel: [ 1503.276059] Code: 89 1c 24 74 20 39 5f 
58 0f 89 73 01 00 00 89 f0 e8 c8 e9 ff ff 89 f0 31 d2 83 c4 10 5b 5e 5f 
5d e9 4c fe ff ff 8b 47 50 8d 58 f4 <8b> 43 0c c6 44 24 0f 00 83 e8 0c 
89 44 24 08 8d 47 50 89 44 24
Mar 31 21:46:37 Source kernel: [ 1503.276059] EIP: [<cf4ad872>] 
b43_lo_g_maintanance_work+0x55/0x1b3 [b43] SS:ESP 0068:cdbb9f68

Regards,

David Ellingsworth
