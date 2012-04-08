Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53757 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625Ab2DHQQJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Apr 2012 12:16:09 -0400
Received: by iagz16 with SMTP id z16so4988540iag.19
        for <linux-wireless@vger.kernel.org>; Sun, 08 Apr 2012 09:16:08 -0700 (PDT)
Message-ID: <4F81B9C4.1010901@lwfinger.net> (sfid-20120408_181613_964155_6D96E154)
Date: Sun, 08 Apr 2012 11:16:04 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: jan@simonson.se
CC: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: RTL8192e-pci NIC
References: <1502184.lhzNHmlX61@ymer>
In-Reply-To: <1502184.lhzNHmlX61@ymer>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/08/2012 06:16 AM, Jan Simonson wrote:
> Hello,
>
> I'm using a Samsung R720 laptop with a RTL8192e-pci NIC and Fedora 16. The
> driver has been in kmod-staging from fusion until recently. Now it is removed
> from staging and instead a driver is included in the kernel pack from Fedora.
> After booting with this new kernel the relevant modules are loaded (see below)
> but the wireless connection is not available. Using the module earlier from
> Fusion worked most of the time and better and better over time.
>
> [root@ymer ~]# uname -r
> 3.3.0-8.fc16.x86_64
> [root@ymer ~]# lsmod|grep rtl
> rtl8192se              93742  0
> rtlwifi               104513  1 rtl8192se
> mac80211              496450  2 rtl8192se,rtlwifi
> cfg80211              195558  2 rtlwifi,mac80211
> [root@ymer ~]# modinfo rtl8192se
> filename:
> /lib/modules/3.3.0-8.fc16.x86_64/kernel/drivers/net/wireless/rtlwifi/rtl8192se/rtl8192se.ko
> firmware:       rtlwifi/rtl8192sefw.bin
> description:    Realtek 8192S/8191S 802.11n PCI wireless
> license:        GPL
> author:         Larry Finger<Larry.Finger@lwfinger.net>
> author:         Realtek WlanFAE<wlanfae@realtek.com>
> author:         lizhaoming<chaoming_li@realsil.com.cn>
> alias:          pci:v000010ECd00008174sv*sd*bc*sc*i*
> alias:          pci:v000010ECd00008173sv*sd*bc*sc*i*
> alias:          pci:v000010ECd00008172sv*sd*bc*sc*i*
> alias:          pci:v000010ECd00008171sv*sd*bc*sc*i*
> alias:          pci:v000010ECd00008192sv*sd*bc*sc*i*
> depends:        rtlwifi,mac80211
> intree:         Y
> vermagic:       3.3.0-8.fc16.x86_64 SMP mod_unload
> parm:           swenc:Set to 1 for software crypto (default 0)
>   (bool)
> parm:           ips:Set to 0 to not use link power save (default 1)
>   (bool)
> parm:           swlps:Set to 1 to use SW control power save (default 0)
>   (bool)
> parm:           fwlps:Set to 1 to use FW control power save (default 1)
>   (bool)
> parm:           debug:Set debug level (0-5) (default 0) (int)
> [root@ymer ~]# lspci -nnv
> snip---
> 02:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd.
> RTL8192E/RTL8192SE Wireless LAN Controller [10ec:8192] (rev 01)
>          Subsystem: Askey Computer Corp. Device [144f:7160]
>          Flags: fast devsel, IRQ 16
>          I/O ports at 3000 [size=256]
>          Memory at f6000000 (32-bit, non-prefetchable) [size=16K]
>          Capabilities: [40] Power Management version 3
>          Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
>          Capabilities: [70] Express Legacy Endpoint, MSI 00
>          Capabilities: [100] Advanced Error Reporting
>          Capabilities: [140] Virtual Channel
>          Capabilities: [160] Device Serial Number 93-8a-a9-fe-ff-d2-24-00
>          Kernel modules: rtl8192se
> snip---
> [root@ymer ~]#
>
> What is wrong and what shall I do to make the NIC function?

Unfortunately, there are two PCI devices with ID 10ec:8192. The one with rev 10 
uses rtl8192se, but the one with rev 01 (your device) uses driver r8192e_pci.ko 
from drivers/staging/r8192e/.

When the system finds that PCI ID, it will load one of the two drivers. In the 
probe routine of that driver, the revision number is tested, and an error is 
returned. At that point, the other driver (if available) is loaded and it tests 
the revision. Again it returns an error if the revision is wrong.

When the correct driver was not loaded first, the incorrect one will remain 
loaded; however, it will be inactive.

To fix your problem, you need to run a kernel that contains r8192e_pci in its 
configuration. Driver rtl8192se cannot work with this device under any 
circumstances.

I just downloaded a copy of the Fedora 16 Live CD and booted it in a virtual 
machine. The kernel there is 3.1.0-7.fc16.i686. It the configuration file, 
CONFIG_RTL8192E is not set, thus your device would not work with this kernel.

@John: Was there a policy change at Fedora regarding staging drivers? Is there 
some kernel that has them enabled?

Larry



