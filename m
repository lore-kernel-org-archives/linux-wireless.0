Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51763 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751055Ab1EaPOn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2011 11:14:43 -0400
Received: from public by plane.gmane.org with local (Exim 4.69)
	(envelope-from <public@plane.gmane.org>)
	id 1QRQeU-00077q-Ei
	for linux-wireless@vger.kernel.org; Tue, 31 May 2011 17:14:38 +0200
Message-ID: <4DE505C6.8020601@lwfinger.net> (sfid-20110531_171447_199212_38086B56)
Date: Tue, 31 May 2011 10:14:14 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Andreas Schwab <schwab@linux-m68k.org>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?=
	<public-zajec5-Re5JQEeQqe8AvxtiuMwx3w@plane.gmane.org>,
	=?UTF-8?B?TWljaGE=?= =?UTF-8?B?ZWwgQsO8c2No?=
	<public-mb-fseUSCV1ubazQB+pC5nmwQ@plane.gmane.org>,
	public-linux-wireless-u79uwXL29TY76Z2rM5mHXA@plane.gmane.org,
	"John W. Linville"
	<public-linville-2XuSBdqkA4R54TAoqtyWWQ@plane.gmane.org>,
	public-b43-dev-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@plane.gmane.org,
	linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] ssb: pci: implement serdes workaround
References: <1301657212-12126-1-git-send-email-zajec5@gmail.com> <m2vcwr9pn8.fsf@linux-m68k.org>
In-Reply-To: <m2vcwr9pn8.fsf@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 05/31/2011 04:37 AM, Andreas Schwab wrote:
>
>
> Rafał Miłecki<zajec5-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>  writes:
>
>> +/**************************************************
>> + * Workarounds.
>> + **************************************************/
>> +
>> +static u8 ssb_pcicore_polarity_workaround(struct ssb_pcicore *pc)
>> +{
>> +	return (ssb_pcie_read(pc, 0x204)&  0x10) ? 0xC0 : 0x80;
>> +}
>> +
>> +static void ssb_pcicore_serdes_workaround(struct ssb_pcicore *pc)
>> +{
>> +	const u8 serdes_pll_device = 0x1D;
>> +	const u8 serdes_rx_device = 0x1F;
>> +	u16 tmp;
>> +
>> +	ssb_pcie_mdio_write(pc, serdes_rx_device, 1 /* Control */,
>> +			    ssb_pcicore_polarity_workaround(pc));
>> +	tmp = ssb_pcie_mdio_read(pc, serdes_pll_device, 1 /* Control */);
>> +	if (tmp&  0x4000)
>> +		ssb_pcie_mdio_write(pc, serdes_pll_device, 1, tmp&  ~0x4000);
>> +}
>
> b43-pci-bridge 0001:10:12.0: enabling device (0004 ->  0006)
> ssb: Core 0 found: ChipCommon (cc 0x800, rev 0x0D, vendor 0x4243)
> ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x09, vendor 0x4243)
> ssb: Core 2 found: PCI (cc 0x804, rev 0x0C, vendor 0x4243)
> ssb: Core 3 found: PCMCIA (cc 0x80D, rev 0x07, vendor 0x4243)
> Machine check in kernel mode.
> Caused by (from SRR1=149030): Transfer error ack signal
> Oops: Machine check, sig: 7 [#1]
> PowerMac
> Modules linked in: crc_itu_t ssb(+) snd_aoa_soundbus sungem sungem_phy
> NIP: c0013324 LR: f2143e84 CTR: c001331c
> REGS: c2ca5b80 TRAP: 0200   Not tainted  (3.0.0-rc1)
> MSR: 00149030<EE,ME,IR,DR>   CR: 22004422  XER: 20000000
> TASK = ef9cef90[285] 'modprobe' THREAD: c2ca4000
> GPR00: c2d1f87c c2ca5c30 ef9cef90 00002381 00000134 00000204 00000080 c2ca5bc8
> GPR08: 04773e80 c2d1f87c 00000000 c001331c ffffffff 1002833c f2141968 f214821c
> GPR16: f21478b7 f2148250 f21478c0 f2147894 00100100 00200200 00001310 c2d1fb2c
> GPR24: f2147ee8 00000000 00000000 00000000 f2148204 c2d1f800 00000134 c2d1f800
> NIP [c0013324] ioread32+0x8/0x14
> LR [f2143e84] ssb_pci_read32+0x4c/0x5c [ssb]
> Call Trace:
> [c2ca5c30] [c2d1f800] 0xc2d1f800 (unreliable)
> [c2ca5c40] [f2146244] ssb_pcie_read+0x4c/0x54 [ssb]
> [c2ca5c50] [f2146440] ssb_pcicore_serdes_workaround+0x1c/0x170 [ssb]
> [c2ca5c70] [f2141c24] ssb_attach_queued_buses+0x94/0x288 [ssb]
> [c2ca5cd0] [f2142078] ssb_bus_register+0xe4/0x160 [ssb]
> [c2ca5cf0] [f2142134] ssb_bus_pcibus_register+0x40/0x80 [ssb]
> [c2ca5d00] [f2144a60] ssb_pcihost_probe+0xd8/0x114 [ssb]
> [c2ca5d30] [c018f6ac] local_pci_probe+0x28/0x38
> [c2ca5d40] [c0190690] pci_device_probe+0x68/0x94
> [c2ca5d70] [c02bc8a4] driver_probe_device+0xc8/0x170
> [c2ca5d90] [c02bc9bc] __driver_attach+0x70/0x98
> [c2ca5db0] [c02bb9ec] bus_for_each_dev+0x60/0x90
> [c2ca5de0] [c02bc538] driver_attach+0x24/0x34
> [c2ca5df0] [c02bc11c] bus_add_driver+0xbc/0x23c
> [c2ca5e10] [c02bcfc8] driver_register+0xb8/0x144
> [c2ca5e30] [c01908c8] __pci_register_driver+0x4c/0xc8
> [c2ca5e50] [f214486c] ssb_pcihost_register+0x50/0x60 [ssb]
> [c2ca5e60] [f214c094] b43_pci_ssb_bridge_init+0x18/0xbc [ssb]
> [c2ca5e70] [f214c05c] ssb_modinit+0x5c/0x7c [ssb]
> [c2ca5e80] [c00049d8] do_one_initcall+0xe0/0x1c0
> [c2ca5eb0] [c005f7b0] sys_init_module+0x164c/0x1850
> [c2ca5f40] [c0010cd8] ret_from_syscall+0x0/0x40
> --- Exception: c01 at 0xff0b714
>      LR = 0x100050f0
> Instruction dump:
> 0c030000 4c00012c 5463043e 4e800020 7c0004ac a0630000 0c030000 4c00012c
> 5463043e 4e800020 7c0004ac 7c601c2c<0c030000>  4c00012c 4e800020 7c0004ac
> ---[ end trace 9824f03a7724930b ]---

We get a PPC machine check if we try to read a non-existent register, whereas 
x86 returns all 1's on reads.

Obviously, this section needs to be conditionalized depending on revision info. 
 From the traceback, it must be the serdes_pll_device read that failed. The 
specs say that should be a valid register for PCIe and PCI core rev 3 - 5. As 
the PCI core in this device is 0xc, should we be in this routine? See 
http://bcm-v4.sipsolutions.net/PCI-E.

Larry

