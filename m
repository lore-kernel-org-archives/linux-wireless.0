Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:33142 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753516Ab3LDHws (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Dec 2013 02:52:48 -0500
Message-Id: <1386143567.23274.55300753.5C861343@webmail.messagingengine.com> (sfid-20131204_085307_698596_2D1D5A5E)
From: "Nikita N." <nikitan@operamail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: RTL8187 bugs
Date: Tue, 03 Dec 2013 23:52:47 -0800
In-Reply-To: <529E9437.7020305@lwfinger.net>
References: <1385589961.19021.52907237.3EE33E5B@webmail.messagingengine.com>
 <52966D64.2030805@lwfinger.net>
 <1385593188.3627.52911717.4E0712D9@webmail.messagingengine.com>
 <52968893.6060405@lwfinger.net>
 <1385812990.14905.53777877.7646278B@webmail.messagingengine.com>
 <529A1B52.6040605@lwfinger.net>
 <1385835820.6559.53858669.5FD3F3A6@webmail.messagingengine.com>
 <529A36C5.4060209@lwfinger.net>
 <1386079140.19919.54929613.506DE0D0@webmail.messagingengine.com>
 <529E0166.90302@lwfinger.net>
 <1386105710.9442.55117909.7AF98FBC@webmail.messagingengine.com>
 <529E9437.7020305@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry :) thank you very much for the comments on my patch, really
appreciated.

Anyway, lets try to stick on the issue, ok?
The issue is the malfunction of *MONITOR* mode.
I can't see any monitor mode call from your log, you tested only managed
mode, isn't it?
I repeat, managed mode works perfectly also in my interfaces, no need to
test it.
We need to test *MONITOR* mode.

Since you say that at you, the *MONITOR* mode works ok, I need to
reproduce your environment here, in order to test the *MONITOR* mode.
As already asked in previous email, what OS Linux distro do you use
exactly when you test *MONITOR* mode in your 8187 interfaces?
What programs suite do you use exactly when you test *MONITOR* mode in
your 8187 interfaces?

Thanks :)

On Tue, Dec 3, 2013, at 06:32 PM, Larry Finger wrote:
> On 12/03/2013 03:21 PM, Nikita N. wrote:
> 
> After rewriting your patch a bit (see attached copy), I got the
> following:
> 
> usb 1-5: new high-speed USB device number 5 using ehci-pci
> rtl8187: inconsistency between id with OEM info!
> -- regulatory rules --
> ieee80211 phy3: Selected rate control algorithm 'minstrel_ht'
> ieee80211 phy3: hwaddr 00:11:6b:3e:c4:0a, RTL8187BvB(early) V0 +
> rtl8225z2, 
> rfkill mask 2
> rtl8187: Customer ID is 0x00
> rtl8187: wireless switch is on
> usbcore: registered new interface driver rtl8187
> systemd-udevd[5366]: renamed network interface wlan1 to wlp0s2f1u5
> rtl8187_configure_filter
> IN>changed_flags=0x0 ,total_flags=0x80000000 ,multicast=0x1 
> ,priv->rx_conf=0x9094fc0e
>  >FIF_ALLMULTI
> OUT>total_flags=0x2 ,priv->rx_conf=0x9094fc0e
> rtl8187_configure_filter
> IN>changed_flags=0x2 ,total_flags=0x80000000 ,multicast=0x1 
> ,priv->rx_conf=0x9094fc0e
>  >FIF_ALLMULTI
> OUT>total_flags=0x2 ,priv->rx_conf=0x9094fc0e
> IPv6: ADDRCONF(NETDEV_UP): wlp0s2f1u5: link is not ready
> rtl8187_configure_filter
> IN>changed_flags=0x2 ,total_flags=0x80000000 ,multicast=0x2 
> ,priv->rx_conf=0x9094fc0e
>  >FIF_ALLMULTI
> OUT>total_flags=0x2 ,priv->rx_conf=0x9094fc0e
> rtl8187_configure_filter
> IN>changed_flags=0x12 ,total_flags=0x80000010 ,multicast=0x2 
> ,priv->rx_conf=0x9094fc0e
>  >FIF_ALLMULTI
> OUT>total_flags=0x2 ,priv->rx_conf=0x9094fc0e
> rtl8187_configure_filter
> IN>changed_flags=0x2 ,total_flags=0x80000000 ,multicast=0x2 
> ,priv->rx_conf=0x9094fc0e
>  >FIF_ALLMULTI
> OUT>total_flags=0x2 ,priv->rx_conf=0x9094fc0e
> rtl8187_configure_filter
> IN>changed_flags=0x12 ,total_flags=0x80000010 ,multicast=0x2 
> ,priv->rx_conf=0x9094fc0e
>  >FIF_ALLMULTI
> OUT>total_flags=0x2 ,priv->rx_conf=0x9094fc0e
> wlp0s2f1u5: authenticate with 20:e5:2a:01:f7:ea
> rtl8187_configure_filter
> IN>changed_flags=0x2 ,total_flags=0x80000000 ,multicast=0x2 
> ,priv->rx_conf=0x9094fc0e
>  >FIF_ALLMULTI
> OUT>total_flags=0x2 ,priv->rx_conf=0x9094fc0e
> wlp0s2f1u5: send auth to 20:e5:2a:01:f7:ea (try 1/3)
> wlp0s2f1u5: authenticated
> wlp0s2f1u5: associate with 20:e5:2a:01:f7:ea (try 1/3)
> wlp0s2f1u5: RX AssocResp from 20:e5:2a:01:f7:ea (capab=0x411 status=0
> aid=7)
> wlp0s2f1u5: associated
> IPv6: ADDRCONF(NETDEV_CHANGE): wlp0s2f1u5: link becomes ready
> rtl8187_configure_filter
> IN>changed_flags=0x2 ,total_flags=0x80000000 ,multicast=0x3 
> ,priv->rx_conf=0x9094fc0e
>  >FIF_ALLMULTI
> OUT>total_flags=0x2 ,priv->rx_conf=0x9094fc0e
> rtl8187_configure_filter
> IN>changed_flags=0x2 ,total_flags=0x80000000 ,multicast=0x4 
> ,priv->rx_conf=0x9094fc0e
>  >FIF_ALLMULTI
> OUT>total_flags=0x2 ,priv->rx_conf=0x9094fc0e
> rtl8187_configure_filter
> IN>changed_flags=0x2 ,total_flags=0x80000000 ,multicast=0x5 
> ,priv->rx_conf=0x9094fc0e
>  >FIF_ALLMULTI
> OUT>total_flags=0x2 ,priv->rx_conf=0x9094fc0e
> rtl8187_configure_filter
> IN>changed_flags=0x12 ,total_flags=0x80000010 ,multicast=0x5 
> ,priv->rx_conf=0x9094fc0e
>  >FIF_ALLMULTI
> OUT>total_flags=0x2 ,priv->rx_conf=0x9094fc0e
> 
> Some comments on your patch:
> 
> 1. The routine can be gotten from ("%s\n", __func__). That is a lot
> easier than 
> hand coding the routine name.
> 
> 2. Every printk should be terminated with \n (new line).
> 
> 3. You can print multi-byte values with 0x%x. No need to split out the
> bytes the 
> way you did.
> 
> I do not have aircrack running on my system, thus I cannot issue exactly
> the 
> same command that you did.
> 
> The "daemon" that keeps calling rtl8187_configure_filter() is the
> transmit 
> packet process of the kernel. You get one call for every packet out.
> 
> Larry
> 
> Email had 1 attachment:
> + nikita8187.patch
>   2k (text/x-patch)

-- 
http://www.fastmail.fm - Choose from over 50 domains or use your own

