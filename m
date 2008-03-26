Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.191]:47449 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761543AbYCZStW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Mar 2008 14:49:22 -0400
Received: by rv-out-0910.google.com with SMTP id k20so2112043rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 26 Mar 2008 11:49:22 -0700 (PDT)
Message-ID: <183c1cc10803261149r2f518772j2ea3a1b5df55b2cc@mail.gmail.com> (sfid-20080326_184943_183214_BDCC80C0)
Date: Wed, 26 Mar 2008 14:49:21 -0400
From: "John Goulah" <jgoulah@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: problem with iwl4965 and kernel 2.6.24.4
In-Reply-To: <D936D925018D154694D8A362EEB0892004073B0C@orsmsx416.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <183c1cc10803261031p6e7e16bdme000416095de9b7f@mail.gmail.com>
	 <D936D925018D154694D8A362EEB0892004073B0C@orsmsx416.amr.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 26, 2008 at 2:16 PM, Chatre, Reinette
<reinette.chatre@intel.com> wrote:
> On Wednesday, March 26, 2008 10:31 AM, John Goulah  wrote:
>
>  > iwl4965: Intel(R) Wireless WiFi Link 4965AGN driver for Linux, 1.2.26k
>  > iwl4965: Copyright(c) 2003-2008 Intel Corporation
>  > ACPI: PCI Interrupt 0000:06:00.0[A] -> GSI 18 (level, low) -> IRQ 18
>  > PCI: Setting latency timer of device 0000:06:00.0 to 64
>  > iwl4965: Detected Intel Wireless WiFi Link 4965AGN
>  > iwl4965: Tunable channels: 11 802.11bg, 13 802.11a channels
>  > phy0: Selected rate control algorithm 'iwl-4965-rs'
>  > phy0: Failed to initialize wep
>  > iwl4965: Failed to register network device (error -12)
>  > ACPI: PCI interrupt for device 0000:06:00.0 disabled
>  > iwl4965: probe of 0000:06:00.0 failed with error -12
>
>  Everything looks good here ... apart from the initializing wep failure.
>  This error causes the interface not to show up. For this to succeed you
>  need to ensure that some crypto modules are loaded. If your kernel is
>  configured with KMOD then modprobe should take care of this for you. If
>  not, then you can try loading the following modules manually before
>  loading the driver: blkcipher aes arc4 ecb cryptomgr crypto_algapi
>


Thanks!  That got me somewhere- dmesg has no errors and iwconfig looks like:

$ iwconfig
lo        no wireless extensions.

eth1      no wireless extensions.

sit0      no wireless extensions.

wmaster0  no wireless extensions.

Warning: Driver for device wlan0 has been compiled with version 22
of Wireless Extension, while this program supports up to version 20.
Some things may be broken...

wlan0     IEEE 802.11  ESSID:"goulahnet"
          Mode:Managed  Frequency:2.412 GHz  Access Point: Not-Associated
          Tx-Power=0 dBm
          Retry min limit:7   RTS thr:off   Fragment thr=2352 B
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0



Is this warning a problem?  Does this mean I need to get a newer
iwconfig (I'm on debian etch, Wireless-Tools version 28)


Also, is this driver known to work with wpa_supplicant?



Thank you,
John
