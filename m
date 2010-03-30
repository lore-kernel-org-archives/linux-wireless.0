Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml105.kpnxchange.com ([195.121.3.9]:59056 "EHLO
	CPSMTPM-EML105.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752051Ab0C3VCf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Mar 2010 17:02:35 -0400
Message-ID: <4BB266E9.2010404@gmail.com>
Date: Tue, 30 Mar 2010 23:02:33 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: rt2x00 Users List <users@rt2x00.serialmonkey.com>
CC: Ondrej Zary <linux@rainbow-software.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [rt2x00-users] [PATCH] [RFC] rt2500pci: fix powersaving
References: <201003290956.54234.linux@rainbow-software.org>	<201003301433.55355.linux@rainbow-software.org>	<20100330125620.GA2173@katherina.student.utwente.nl> <201003302209.23334.linux@rainbow-software.org>
In-Reply-To: <201003302209.23334.linux@rainbow-software.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/30/10 22:09, Ondrej Zary wrote:
> On Tuesday 30 March 2010, Matthijs Kooijman wrote:
>> Hi all,
>>
>>> phy0 -> rt2500pci_set_device_state: Error - Device failed to enter state
>>> 1 (-16).
>>
>> I'm seeing this one on my rt2500pci as well (and also works ok otherwise).
> 
> OK, so let's try to fix it.
> 
> The first patch below fixes this problem. And reveals two other problems. Now the
> device has problems entering states 3 and 4 (remains stuck in state 1) - the
> driver seems to not like this and oopses.
> The second patch fixes the "stuck state 1" problem (same fix as in rt2500usb).
> The oops does not appear anymore with the second patch - but I think that it
> should be fixed anyway separately.
> (I'm testing this with "while true; do ifdown wlan0; ifup wlan0; done")
> 

Thanks again for your hard and persistent work on this.

> oops:
> 
> phy0 -> rt2500pci_set_device_state: Error - Device failed to enter state 3 (-16).
> phy0 -> rt2500pci_set_device_state: Error - Device failed to enter state 3 (-16).
> phy0 -> rt2500pci_set_device_state: Error - Device failed to enter state 3 (-16).
> wlan0: deauthenticating from 00:13:d4:0f:f3:19 by local choice (reason=3)
> phy0 -> rt2500pci_set_device_state: Error - Device failed to enter state 3 (-16).
> cfg80211: Calling CRDA to update world regulatory domain
> phy0 -> rt2500pci_set_device_state: Error - Device failed to enter state 3 (-16).
> phy0 -> rt2500pci_set_device_state: Error - Device failed to enter state 4 (-5).
> BUG: unable to handle kernel NULL pointer dereference at (null)
> IP: [<c8949726>] rt2x00queue_init_queues+0x25/0x64 [rt2x00lib]
> *pde = 00000000
> Oops: 0002 [#1] SMP
> last sysfs file: /sys/devices/virtual/input/mice/uevent
> Modules linked in: aes_generic arc4 ecb rt2500pci rt2x00pci rt2x00lib mac80211 cfg80211 rfkill ns558 pcspkr eeprom_93cx6 gameport 8139too 
> 8139cp mii [last 
> unloaded: scsi_wait_scan]
> 
> Pid: 2051, comm: ifconfig Not tainted 2.6.34-rc2 #8 i815-W83627/
> EIP: 0060:[<c8949726>] EFLAGS: 00010202 CPU: 0
> EIP is at rt2x00queue_init_queues+0x25/0x64 [rt2x00lib]
> EAX: 00000000 EBX: c703b100 ECX: c703b10c EDX: 00000000
> ESI: c72b2ac0 EDI: 00000001 EBP: c7293df4 ESP: c7293de4
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process ifconfig (pid: 2051, ti=c7293000 task=c7253280 task.ti=c7293000)
> Stack:
>  c703b130 c72b2ac0 00000000 c72b2884 c7293e04 c894868a c72b2ac0 00000000
> <0> c7293e14 c8948773 c72b2240 c72b53c0 c7293e1c c8949039 c7293e48 c890cd83
> <0> c72b2240 c72b2884 c72b5000 00000000 00005d31 00000000 c72b5000 c891e46c
> Call Trace:
>  [<c894868a>] ? rt2x00lib_stop+0x54/0xb4 [rt2x00lib]
>  [<c8948773>] ? rt2x00lib_start+0x89/0xa6 [rt2x00lib]
>  [<c8949039>] ? rt2x00mac_start+0x18/0x1a [rt2x00lib]
>  [<c890cd83>] ? ieee80211_open+0x24a/0x567 [mac80211]
>  [<c05f73dd>] ? __dev_open+0x7b/0xa4
>  [<c05f5a81>] ? __dev_change_flags+0x93/0x108
>  [<c05f7336>] ? dev_change_flags+0x13/0x3f
>  [<c062aa81>] ? devinet_ioctl+0x21e/0x497
>  [<c062bcce>] ? inet_ioctl+0x8e/0xa7
>  [<c05eac3e>] ? sock_ioctl+0x1c0/0x1e4
>  [<c04a762d>] ? vfs_ioctl+0x27/0x91
>  [<c05eaa7e>] ? sock_ioctl+0x0/0x1e4
>  [<c04a7bce>] ? do_vfs_ioctl+0x48e/0x4cc
>  [<c048a13f>] ? handle_mm_fault+0x3fd/0x86a
>  [<c046cff1>] ? call_rcu_sched+0xd/0xf
>  [<c04a7c3a>] ? sys_ioctl+0x2e/0x48
>  [<c0402ed8>] ? sysenter_do_call+0x12/0x28
> Code: f7 5b 5e 5f 5d c3 55 89 e5 57 56 89 c6 53 83 ec 04 8b 98 c8 02 00 00 eb 30 89 d8 31 ff e8 a9 ff ff ff eb 1a 6b c7 14 8b 53 04 47 <c7> 
> 04 02 00 00 00 
> 00 8b 56 04 03 43 04 8b 52 2c ff 52 20 0f b7
> EIP: [<c8949726>] rt2x00queue_init_queues+0x25/0x64 [rt2x00lib] SS:ESP 0068:c7293de4
> CR2: 0000000000000000
> ---[ end trace 65bcf981f552d652 ]---
> 
> 
> 
> 
> --- linux-2.6.34-rc2-orig/drivers/net/wireless/rt2x00/rt2500pci.c	2010-03-20 02:17:57.000000000 +0100
> +++ linux-2.6.34-rc2/drivers/net/wireless/rt2x00/rt2500pci.c	2010-03-30 15:04:50.000000000 +0200
> @@ -1079,7 +1079,7 @@
>  static int rt2500pci_set_state(struct rt2x00_dev *rt2x00dev,
>  			       enum dev_state state)
>  {
> -	u32 reg;
> +	u32 reg, reg2;
>  	unsigned int i;
>  	char put_to_sleep;
>  	char bbp_state;
> @@ -1100,11 +1100,12 @@
>  	 * device has entered the correct state.
>  	 */
>  	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
> -		rt2x00pci_register_read(rt2x00dev, PWRCSR1, &reg);
> -		bbp_state = rt2x00_get_field32(reg, PWRCSR1_BBP_CURR_STATE);
> -		rf_state = rt2x00_get_field32(reg, PWRCSR1_RF_CURR_STATE);
> +		rt2x00pci_register_read(rt2x00dev, PWRCSR1, &reg2);
> +		bbp_state = rt2x00_get_field32(reg2, PWRCSR1_BBP_CURR_STATE);
> +		rf_state = rt2x00_get_field32(reg2, PWRCSR1_RF_CURR_STATE);
>  		if (bbp_state == state && rf_state == state)
>  			return 0;
> +		rt2x00pci_register_write(rt2x00dev, PWRCSR1, reg);
>  		msleep(10);
>  	}
>  

Hmmm, checking the old legacy Ralink rt2500 driver it shows that the legacy driver never waits and checks
whether the device has come in the right power state. What does happen to the stability of the connection
if you simply remove this entire for-loop?

> 
> 
> --- linux-2.6.34-rc2-orig/drivers/net/wireless/rt2x00/rt2500pci.c       2010-03-20 02:17:57.000000000 +0100
> +++ linux-2.6.34-rc2/drivers/net/wireless/rt2x00/rt2500pci.c    2010-03-30 21:15:03.000000000 +0200
> @@ -573,6 +573,10 @@
> 
>  		rt2x00_set_field32(&reg, CSR20_AUTOWAKE, 1);
>  		rt2x00pci_register_write(rt2x00dev, CSR20, reg);
> +	} else {
> +		rt2x00pci_register_read(rt2x00dev, CSR20, &reg);
> +		rt2x00_set_field32(&reg, CSR20_AUTOWAKE, 0);
> +		rt2x00pci_register_write(rt2x00dev, CSR20, reg);
>  	}
> 
>  	rt2x00dev->ops->lib->set_device_state(rt2x00dev, state);

OK. Got this queued up already (based upon your patch to rt2500usb).

---
Gertjan.
