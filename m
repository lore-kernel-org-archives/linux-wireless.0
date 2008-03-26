Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp4.versatel.nl ([62.58.50.91]:42646 "EHLO smtp4.versatel.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762704AbYCZSyj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Mar 2008 14:54:39 -0400
Subject: Re: hostapd with mac80211 and rt2500pci: hostapd doesn't receive
	clients EAPOL keys unless mon.wlan1 is promiscuous
From: Bas Hulsken <bhulsken@hotmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <1206281653.2902.45.camel@Bas>
References: <1206271458.2902.27.camel@Bas>
	 (sfid-20080323_113430_380950_98BCE00E)  <1206274341.16475.185.camel@johannes.berg>
	 <1206277237.2902.37.camel@Bas>  <1206281653.2902.45.camel@Bas>
Content-Type: text/plain
Date: Wed, 26 Mar 2008 19:51:04 +0100
Message-Id: <1206557464.2844.3.camel@Bas> (sfid-20080326_185447_763908_06DB6F69)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

don't mean to push you or anything, but I was wondering if you
overlooked my last mail. You asked me to add some printk's to the
rt2500pci driver to debug hostapd authentication failure. I did this,
and these are the results:

upon ifupping the interface:
------------------------------------------------
phy0: Selected rate control algorithm 'pid'
Registered led device: rt2500pci-phy0:radio
rt2500pci MAC changed: 00:0c:f6:14:05:19
rt2500pci filter_flags: 2
ADDRCONF(NETDEV_UP): wlan1: link is not ready
------------------------------------------------
when I run hostapd, this is in dmesg:
------------------------------------------------
rt2500pci MAC changed: 00:00:00:00:00:00
rt2500pci MAC changed: 00:0c:f6:14:05:19
rt2500pci MAC changed: 00:00:00:00:00:00
rt2500pci MAC changed: 00:0c:f6:14:05:19
rt2500pci filter_flags: 2
rt2500pci filter_flags: 0
rt2500pci MAC changed: 00:00:00:00:00:00
rt2500pci MAC changed: 00:0c:f6:14:05:19
rt2500pci filter_flags: 2
------------------------------------------------
this is immediately on startup of hostapd, after that filter and MAC
remain unchanged (at least if my printk catches everything).

does this look ok to you? Does it explain why I can only receive EOPOL
keys when in promiscuous mode?

thanks for your help,
Bas



On Sun, 2008-03-23 at 15:14 +0100, Bas Hulsken wrote:
> Hi Johannes,
> 
> On Sun, 2008-03-23 at 14:00 +0100, Bas Hulsken wrote:
> 
> > before I blow up the system, I guess this should do the trick?
> > (remember, I'm not a kernel hacker ;-):
> 
> ok.. so I decided to just give it a try.. seems to work, this is dmesg
> upon ifupping the interface:
> 
> phy0: Selected rate control algorithm 'pid'
> Registered led device: rt2500pci-phy0:radio
> rt2500pci MAC changed: 00:0c:f6:14:05:19
> rt2500pci filter_flags: 2
> ADDRCONF(NETDEV_UP): wlan1: link is not ready
> 
> when I run hostapd, this is in dmesg:
> 
> rt2500pci MAC changed: 00:00:00:00:00:00
> rt2500pci MAC changed: 00:0c:f6:14:05:19
> rt2500pci MAC changed: 00:00:00:00:00:00
> rt2500pci MAC changed: 00:0c:f6:14:05:19
> rt2500pci filter_flags: 2
> rt2500pci filter_flags: 0
> rt2500pci MAC changed: 00:00:00:00:00:00
> rt2500pci MAC changed: 00:0c:f6:14:05:19
> rt2500pci filter_flags: 2
> 
> this is immediately on startup of hostapd, after that filter and MAC
> remain unchanged (at least if my printk catches everything).
> 
> thanks,
> Bas
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

