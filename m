Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:39179 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbZKWIN1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 03:13:27 -0500
Received: by bwz27 with SMTP id 27so4744486bwz.21
        for <linux-wireless@vger.kernel.org>; Mon, 23 Nov 2009 00:13:32 -0800 (PST)
Subject: Re: mac80211 breaks suspend to disk
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1258640999.7094.19.camel@johannes.local>
References: <1258568836.4512.13.camel@maxim-laptop>
	 <20091118202802.GE2911@tuxdriver.com>
	 <1258576749.8018.7.camel@maxim-laptop>
	 <1258578199.30511.80.camel@johannes.local>
	 <1258579170.4525.2.camel@maxim-laptop>
	 <1258579261.30511.84.camel@johannes.local>
	 <1258638183.5063.4.camel@maxim-laptop>
	 <1258640999.7094.19.camel@johannes.local>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 Nov 2009 10:13:27 +0200
Message-ID: <1258964007.30731.3.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-11-19 at 15:29 +0100, Johannes Berg wrote: 
> On Thu, 2009-11-19 at 15:43 +0200, Maxim Levitsky wrote:
> 
> > This problem definitely is fixed.
> 
> Thanks for checking.
> 
> > One more finding from the hibernate loop though:
> > 
> > Nov 19 12:25:49 maxim-laptop NetworkManager: <info>  (wlan0): deactivating device (reason: 37).
> > Nov 19 12:25:49 maxim-laptop NetworkManager: <info>  (wlan0): canceled DHCP transaction, dhcp client pid 6130
> > Nov 19 12:25:49 maxim-laptop kernel: [  239.925841] wlan0: disassociating from 00:1b:9e:d8:77:02 by local choice (reason=3)
> > Nov 19 12:25:49 maxim-laptop kernel: [  239.940401] phy0: Removed STA 00:1b:9e:d8:77:02
> > Nov 19 12:25:49 maxim-laptop kernel: [  239.982746] phy0: Destroyed STA 00:1b:9e:d8:77:02
> > Nov 19 12:25:49 maxim-laptop NetworkManager: <WARN>  check_one_route(): (wlan0) error -34 returned from rtnl_route_del(): Sucess#012
> > Nov 19 12:25:49 maxim-laptop NetworkManager: <info>  (wlan0): cleaning up...
> > Nov 19 12:25:49 maxim-laptop NetworkManager: <info>  (wlan0): taking down device.
> > Nov 19 12:25:49 maxim-laptop avahi-daemon[1626]: Withdrawing address record for 10.1.0.2 on wlan0.
> > Nov 19 12:25:49 maxim-laptop avahi-daemon[1626]: Leaving mDNS multicast group on interface wlan0.IPv4 with address 10.1.0.2.
> > Nov 19 12:25:49 maxim-laptop kernel: [  239.998665] wlan0: deauthenticating from 00:1b:9e:d8:77:02 by local choice (reason=3)
> > Nov 19 12:25:49 maxim-laptop kernel: [  240.072664] phy0: device now idle
> > Nov 19 12:25:49 maxim-laptop kernel: [  240.105115] ------------[ cut here ]------------
> > Nov 19 12:25:49 maxim-laptop avahi-daemon[1626]: Interface wlan0.IPv4 no longer relevant for mDNS.
> > Nov 19 12:25:49 maxim-laptop kernel: [  240.120021] WARNING: at /home/maxim/software/kernel/linux-2.6/net/wireless/core.c:618 wdev_cleanup_work+0xe9/0x110 [cfg80211]()
> 
> You're using 3945 it seems, this kind of warning happens when it doesn't
> do the scan notifications properly. I'd look at 3945 for this one.
> 
> > Other that that, I got few freezes, this time with no feedback whatsoever, blank screen, thus very likely something different.
> > Might be nvidia proprietary driver fault too.
> 
> Fun
And after removing acpi global lock that protects access to EC on my
system, but somehow ether isn't released, or I don't know what, my
system just survived 280 s2disk cycles, with everything enabled.

http://bugzilla.kernel.org/show_bug.cgi?id=14668
(not related to wireless stack in any way)



