Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:42466 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707AbZKWOMe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 09:12:34 -0500
Received: by fg-out-1718.google.com with SMTP id d23so2194400fga.1
        for <linux-wireless@vger.kernel.org>; Mon, 23 Nov 2009 06:12:39 -0800 (PST)
Subject: Re: [PATCH 2.6.32] rfkill: fix miscdev ops
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	iwlwifi maling list <ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1258973362.7094.151.camel@johannes.local>
References: <1258968499.3271.5.camel@maxim-laptop>
	 <1258972050.7094.140.camel@johannes.local>
	 <1258973082.3675.0.camel@maxim-laptop>
	 <1258973362.7094.151.camel@johannes.local>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 Nov 2009 16:12:35 +0200
Message-ID: <1258985555.7236.6.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-11-23 at 11:49 +0100, Johannes Berg wrote: 
> On Mon, 2009-11-23 at 12:44 +0200, Maxim Levitsky wrote:
> > On Mon, 2009-11-23 at 11:27 +0100, Johannes Berg wrote: 
> > > The /dev/rfkill ops don't refer to the module,
> > > so it is possible to unload the module while
> > > file descriptors are open. Fix this oversight.
> 
> > Thanks for the quick patch!, works fine.
> 
> :)
> I'd tested myself in kvm so didn't bother asking, but John can add
> Tested-by I guess if you would like.
Not important, however I had seen that iwlwifi now chokes on reload,
sometimes with this:


[  830.333386] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, 1.2.26kds
[  830.333407] iwl3945: Copyright(c) 2003-2009 Intel Corporation
[  830.333536] iwl3945 0000:06:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[  830.374979] iwl3945 0000:06:00.0: Tunable channels: 13 802.11bg, 0 802.11a channels
[  830.374995] iwl3945 0000:06:00.0: Detected Intel Wireless WiFi Link 3945BG
[  830.375163] iwl3945 0000:06:00.0: irq 32 for MSI/MSI-X
[  830.376859] phy0: Selected rate control algorithm 'iwl-3945-rs'
[  830.427214] iwl3945 0000:06:00.0: firmware: requesting iwlwifi-3945-2.ucode
[  830.526945] iwl3945 0000:06:00.0: loaded firmware version 15.32.2.9
[  830.544236] CE: hpet increasing min_delta_ns to 15000 nsec
[  830.575694] iwl3945 0000:06:00.0: BSM uCode verification failed at addr 0x00003800+0 (of 900), is 0xa5a5a5a2, s/b 0xf802020
[  830.578862] iwl3945 0000:06:00.0: Hardware error detected.  Restarting.
[  832.570133] iwl3945 0000:06:00.0: Wait for START_ALIVE timeout after 2000ms.
[  832.622676] iwl3945 0000:06:00.0: BSM uCode verification failed at addr 0x00003800+0 (of 900), is 0xa5a5a5a2, s/b 0xf802020
[  832.625839] iwl3945 0000:06:00.0: Hardware error detected.  Restarting.
[  834.620132] iwl3945 0000:06:00.0: Wait for START_ALIVE timeout after 2000ms.


Note that I used antenna=2 parameter to experiment with quality of reception of both antennas
(this feature strangely works just fine....)

I disabled this option, so next time I feel like rebooting my system, I see if this option was the cause.
(unlikely)


Best regards,
	Maxim Levitsky



