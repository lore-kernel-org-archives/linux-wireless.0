Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:59131 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496AbZJBTau (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2009 15:30:50 -0400
Received: from cpc2-whit1-0-0-cust96.cdif.cable.ntl.com ([82.13.80.97] helo=plato.andrewprice.me.uk)
	by silver.sucs.swan.ac.uk with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.69)
	(envelope-from <andy@andrewprice.me.uk>)
	id 1Mtnq9-0007Lt-Gq
	for linux-wireless@vger.kernel.org; Fri, 02 Oct 2009 20:30:53 +0100
Date: Fri, 2 Oct 2009 20:30:43 +0100
From: Andrew Price <andy@andrewprice.me.uk>
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: WARNING: at drivers/net/wireless/b43/main.c:3923
 b43_wireless_core_stop+0x1c8/0x1d0()
Message-ID: <20091002193042.GA3719@plato.andrewprice.me.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm seeing this warning when I unplug my wireless card while the
network interface is still up. It doesn't seem to cause any permanent
damage - when I plug it back in I can use the wireless card again.

I'm using today's mainline kernel as of 0efe5e32 with Michael Buesch's
"b43: Don't use struct wldev after detach" patch added, though I don't
believe that patch is the culprit because the warning triggers without
it too.

The line it refers to is:
    B43_WARN_ON(b43_read32(dev, B43_MMIO_GEN_IRQ_MASK));

Andrew

[  405.463902] pcmcia_socket pcmcia_socket0: pccard: card ejected from slot 0
[  405.496420] b43-phy3 debug: Disabling hardware based encryption for keyidx: 0, mac: [...]
[  405.496444] wlan1: deauthenticating from [...] by local choice (reason=3)
[  405.502031] b43-phy3 debug: Disabling hardware based encryption for keyidx: 2, mac: ff:ff:ff:ff:ff:ff
[  405.502046] b43-phy3 debug: Removing Interface type 2
[  405.502092] ------------[ cut here ]------------
[  405.502110] WARNING: at drivers/net/wireless/b43/main.c:3923 b43_wireless_core_stop+0x1c8/0x1d0()
[  405.502117] Hardware name: W730-K8
[  405.502121] Modules linked in:
[  405.502131] Pid: 721, comm: pccardd Tainted: G        W  2.6.32-rc2-00197-g82bb352 #4
[  405.502137] Call Trace:
[  405.502149]  [<c13adfa8>] ? b43_wireless_core_stop+0x1c8/0x1d0
[  405.502158]  [<c13adfa8>] ? b43_wireless_core_stop+0x1c8/0x1d0
[  405.502168]  [<c1038f6f>] ? warn_slowpath_common+0x6f/0xd0
[  405.502178]  [<c13adfa8>] ? b43_wireless_core_stop+0x1c8/0x1d0
[  405.502186]  [<c1038fe3>] ? warn_slowpath_null+0x13/0x20
[  405.502195]  [<c13adfa8>] ? b43_wireless_core_stop+0x1c8/0x1d0
[  405.502204]  [<c13adfe7>] ? b43_op_stop+0x37/0x70
[  405.502217]  [<c15c161d>] ? ieee80211_stop_device+0x1d/0x60
[  405.502226]  [<c15b72a7>] ? ieee80211_stop+0x3f7/0x5e0
[  405.502236]  [<c14afc73>] ? dev_close+0x63/0xb0
[  405.502244]  [<c14afd01>] ? rollback_registered+0x41/0x280
[  405.502255]  [<c10e4164>] ? fsnotify_clear_marks_by_inode+0x74/0xb0
[  405.502263]  [<c14aff56>] ? unregister_netdevice+0x16/0x70
[  405.502272]  [<c15b6a24>] ? ieee80211_remove_interfaces+0x64/0xa0
[  405.502284]  [<c15abc48>] ? ieee80211_unregister_hw+0x38/0xd0
[  405.502293]  [<c13abe42>] ? b43_remove+0xa2/0xd0
[  405.502303]  [<c1449c1a>] ? ssb_device_remove+0x1a/0x30
[  405.502313]  [<c135876e>] ? __device_release_driver+0x4e/0xa0
[  405.502321]  [<c135886d>] ? device_release_driver+0x1d/0x30
[  405.502330]  [<c1357e03>] ? bus_remove_device+0x73/0xa0
[  405.502337]  [<c13562a3>] ? device_del+0xf3/0x180
[  405.502345]  [<c1356338>] ? device_unregister+0x8/0x10
[  405.502354]  [<c144ad13>] ? ssb_bus_unregister+0x33/0x90
[  405.502362]  [<c144cc11>] ? ssb_pcihost_remove+0x21/0x50
[  405.502372]  [<c1255e26>] ? pci_device_remove+0x16/0x40
[  405.502380]  [<c135876e>] ? __device_release_driver+0x4e/0xa0
[  405.502389]  [<c135886d>] ? device_release_driver+0x1d/0x30
[  405.502397]  [<c1357e03>] ? bus_remove_device+0x73/0xa0
[  405.502404]  [<c13562a3>] ? device_del+0xf3/0x180
[  405.502411]  [<c1356338>] ? device_unregister+0x8/0x10
[  405.502422]  [<c12518ee>] ? pci_stop_bus_device+0x4e/0x60
[  405.502432]  [<c125197a>] ? pci_remove_bus_device+0xa/0xa0
[  405.502441]  [<c1251a39>] ? pci_remove_behind_bridge+0x29/0x40
[  405.502452]  [<c13d82b4>] ? socket_shutdown+0x84/0x120
[  405.502461]  [<c13d90c7>] ? pccardd+0x1a7/0x250
[  405.502469]  [<c13d8f20>] ? pccardd+0x0/0x250
[  405.502480]  [<c1051f34>] ? kthread+0x74/0x80
[  405.502488]  [<c1051ec0>] ? kthread+0x0/0x80
[  405.502498]  [<c100381f>] ? kernel_thread_helper+0x7/0x18
[  405.502504] ---[ end trace 5fab67b52b76e31e ]---
[  405.502516] b43-phy3 debug: Wireless interface stopped
[  405.502524] b43-phy3 debug: DMA-30 rx_ring: Used slots 2/64, Failed frames 0/0 = 0.0%, Average tries 0.00
[  405.522030] b43-phy3 ERROR: DMA RX reset timed out
[  405.522089] b43-phy3 debug: DMA-30 tx_ring_AC_BK: Used slots 0/256, Failed frames 0/0 = 0.0%, Average tries 0.00
[  405.562030] b43-phy3 ERROR: DMA TX reset timed out
[  405.562039] b43-phy3 debug: DMA-30 tx_ring_AC_BE: Used slots 2/256, Failed frames 2/27 = 7.4%, Average tries 1.29
[  405.602029] b43-phy3 ERROR: DMA TX reset timed out
[  405.602038] b43-phy3 debug: DMA-30 tx_ring_AC_VI: Used slots 0/256, Failed frames 0/0 = 0.0%, Average tries 0.00
[  405.642028] b43-phy3 ERROR: DMA TX reset timed out
[  405.642037] b43-phy3 debug: DMA-30 tx_ring_AC_VO: Used slots 4/256, Failed frames 0/15 = 0.0%, Average tries 1.00
[  405.682030] b43-phy3 ERROR: DMA TX reset timed out
[  405.682044] b43-phy3 debug: DMA-30 tx_ring_mcast: Used slots 0/256, Failed frames 0/0 = 0.0%, Average tries 0.00
[  405.722029] b43-phy3 ERROR: DMA TX reset timed out
[  405.722660] ssb: Failed to switch to core 0
[  405.979518] b43-pci-bridge 0000:02:00.0: PCI INT A disabled

