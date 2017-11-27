Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:37032 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752168AbdK0LnP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Nov 2017 06:43:15 -0500
Message-ID: <1511782993.5456.6.camel@sipsolutions.net> (sfid-20171127_124324_810293_BCFF416D)
Subject: Re: Setting TX power on a monitoring interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Peter =?ISO-8859-1?Q?Gro=DFe?= <pegro@friiks.de>,
        linux-wireless@vger.kernel.org
Date: Mon, 27 Nov 2017 12:43:13 +0100
In-Reply-To: <20171120173415.1ae44829@fem-net.de> (sfid-20171120_173430_381441_284E75CE)
References: <20171120173415.1ae44829@fem-net.de>
         (sfid-20171120_173430_381441_284E75CE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-11-20 at 17:34 +0100, Peter Große wrote:
> Hi everyone.
> 
> The iw tool allows to set TX power settings on network interfaces.
> 
> If I try to set the TX power level on a _monitor_ interface, I get
> a kernel warning:
> 
>  ------------[ cut here ]------------
>  WARNING: CPU: 0 PID: 2193 at net/mac80211/driver-ops.h:167
>  ieee80211_bss_info_change_notify+0x111/0x190 Modules linked in: uvcvideo
>  videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 videobuf2_core 
> rndis_host cdc_ether usbnet mii tp_smapi(O) thinkpad_ec(O) ohci_hcd vboxpci(O)
>  vboxnetadp(O) vboxnetflt(O) v boxdrv(O) x86_pkg_temp_thermal kvm_intel kvm
>  irqbypass iwldvm iwlwifi ehci_pci ehci_hcd tpm_tis tpm_tis_core tpm CPU: 0
>  PID: 2193 Comm: iw Tainted: G           O    4.12.12-gentoo #2 task:
>  ffff880186fd5cc0 task.stack: ffffc90001b54000 RIP:
>  0010:ieee80211_bss_info_change_notify+0x111/0x190 RSP: 0018:ffffc90001b57a10
>  EFLAGS: 00010246 RAX: 0000000000000006 RBX: ffff8801052ce840 RCX:
>  0000000000000064 RDX: 00000000fffffffc RSI: 0000000000040000 RDI:
>  ffff8801052ce840 RBP: ffffc90001b57a38 R08: 0000000000000062 R09:
>  0000000000000000 R10: ffff8802144b5000 R11: ffff880049dc4614 R12:
>  0000000000040000 R13: 0000000000000064 R14: ffff8802105f0760 R15:
>  ffffc90001b57b48 FS:  00007f92644b4580(0000) GS:ffff88021e200000(0000)
>  knlGS:0000000000000000 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 00007f9263c109f0 CR3: 00000001df850000 CR4: 00000000000406f0
>  Call Trace:
>   ieee80211_recalc_txpower+0x33/0x40
>   ieee80211_set_tx_power+0x40/0x180
>   nl80211_set_wiphy+0x32e/0x950
> 
> Steps to reproduce:
> 
>   iw dev wlan0 interface add mon0 type monitor
>   ip link set dev mon0 up
>   iw dev mon0 set txpower fixed 100
> 
> Is that a bug to be fixed?

Yeah, it's a bug.

> What would be the correct way of fixing it? Maybe I can provide a patch.

That's a really good question :-)

I think if the driver has WANT_MONITOR_VIF, then we can pass that
through and let the driver sort it out.

But if not, we probably just have to reject the configuration?

johannes
