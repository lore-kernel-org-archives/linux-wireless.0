Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:64321 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485AbYCZSUP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Mar 2008 14:20:15 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: problem with iwl4965 and kernel 2.6.24.4
Date: Wed, 26 Mar 2008 11:16:26 -0700
Message-ID: <D936D925018D154694D8A362EEB0892004073B0C@orsmsx416.amr.corp.intel.com> (sfid-20080326_182022_939832_D08934D3)
In-Reply-To: <183c1cc10803261031p6e7e16bdme000416095de9b7f@mail.gmail.com>
References: <183c1cc10803261031p6e7e16bdme000416095de9b7f@mail.gmail.com>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "John Goulah" <jgoulah@gmail.com>, <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, March 26, 2008 10:31 AM, John Goulah  wrote:

> iwl4965: Intel(R) Wireless WiFi Link 4965AGN driver for Linux, 1.2.26k
> iwl4965: Copyright(c) 2003-2008 Intel Corporation
> ACPI: PCI Interrupt 0000:06:00.0[A] -> GSI 18 (level, low) -> IRQ 18
> PCI: Setting latency timer of device 0000:06:00.0 to 64
> iwl4965: Detected Intel Wireless WiFi Link 4965AGN
> iwl4965: Tunable channels: 11 802.11bg, 13 802.11a channels
> phy0: Selected rate control algorithm 'iwl-4965-rs'
> phy0: Failed to initialize wep
> iwl4965: Failed to register network device (error -12)
> ACPI: PCI interrupt for device 0000:06:00.0 disabled
> iwl4965: probe of 0000:06:00.0 failed with error -12

Everything looks good here ... apart from the initializing wep failure.
This error causes the interface not to show up. For this to succeed you
need to ensure that some crypto modules are loaded. If your kernel is
configured with KMOD then modprobe should take care of this for you. If
not, then you can try loading the following modules manually before
loading the driver: blkcipher aes arc4 ecb cryptomgr crypto_algapi

Reinette
