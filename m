Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35912 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab1HMCIy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 22:08:54 -0400
Received: by ywf7 with SMTP id 7so2344134ywf.19
        for <linux-wireless@vger.kernel.org>; Fri, 12 Aug 2011 19:08:53 -0700 (PDT)
Message-ID: <4E45DCB2.5020905@lwfinger.net> (sfid-20110813_040857_658908_59D2FAD6)
Date: Fri, 12 Aug 2011 21:08:50 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Roman Krylov <volyrkr@gmail.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: rtl8192* wifi driver
References: <4E45A973.6060305@gmail.com> <4E45AF82.5040407@lwfinger.net> <4E45D65F.6000306@gmail.com>
In-Reply-To: <4E45D65F.6000306@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/12/2011 08:41 PM, Roman Krylov wrote:
> Hi Larry,
> I can't figure out why this happens, this is what I see in dmesg with the
> drivers supplied with the kernel:
>
> rtl8192cu 1-6:1.0: usb_probe_interface
> rtl8192cu 1-6:1.0: usb_probe_interface - got id
> rtl8192cu: MAC address: 00:08:a1:ca:6a:33
> rtl8192cu: Board Type 0
> rtl8192cu: rx_max_size 15360, rx_urb_num 8, in_ep 1
> ieee80211 phy1: Selected rate control algorithm 'rtl_rc'
> drivers/usb/core/inode.c: creating file '004'
> hub 1-0:1.0: state 7 ports 8 chg 0000 evt 0040
> udev: renamed network interface wlan0 to wlan3
> rtl8192cu: MAC auto ON okay!
> rtl8192cu: Tx queue select: 0x05
> rtl8192c: Loading firmware file rtlwifi/rtl8192cufw.bin
> ADDRCONF(NETDEV_UP): wlan3: link is not ready
>
> Though I can see the list of networks in NetworkManager, but I cannot connect to
> any of these networks.
> So I'm stuck with what I have.
> It probably did not compile on your computer because you were cross-compiling.
> Thanks,

Do NOT drop the mailing list. ALWAYS Reply All. I do not do private debugging 
unless you are paying!

The dmesg fragment showed no reason for a failure to even try to connect. On my 
system, I get

[24756.876119] usb 1-2: new high speed USB device number 7 using ehci_hcd
[24757.467946] rtl8192cu: MAC address: 00:1f:1f:c8:8e:cb
[24757.467968] rtl8192cu: Board Type 0
[24757.507037] rtlwifi: rx_max_size 15360, rx_urb_num 8, in_ep 1
[24757.510400] ieee80211 phy5: Selected rate control algorithm 'rtl_rc'
[24757.520562] usbcore: registered new interface driver rtl8192cu
[24757.605980] udev[1038]: renamed network interface wlan0 to wlan5
[24757.693068] rtl8192cu: MAC auto ON okay!
[24757.776251] rtl8192cu: Tx queue select: 0x05
[24757.780586] rtl8192c_common: Loading firmware file rtlwifi/rtl8192cufw.bin
[24758.527878] ADDRCONF(NETDEV_UP): wlan5: link is not ready
[24761.249067] wlan5: authenticate with c0:3f:0e:be:2b:44 (try 1)
[24761.254431] wlan5: authenticated
[24761.254540] wlan5: associate with c0:3f:0e:be:2b:44 (try 1)
[24761.266899] wlan5: RX AssocResp from c0:3f:0e:be:2b:44 (capab=0x411 status=0 
aid=2)
[24761.266912] wlan5: associated
[24761.289844] ADDRCONF(NETDEV_CHANGE): wlan5: link becomes ready

It looks exactly like your output through the "link is not ready" message. At 
that point, NetworkManager starts the authentication process.

What do you see in the NM log file? It should be at /var/log/NetworkManager?

I would also like to see the output of the 'iwlist scan' command when run as root.

Larry



