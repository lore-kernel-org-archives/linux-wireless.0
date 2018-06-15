Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:50474 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755749AbeFOMaq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Jun 2018 08:30:46 -0400
Message-ID: <1529065843.10037.22.camel@sipsolutions.net> (sfid-20180615_143049_491924_D7175844)
Subject: Re: [BUG] mac80211: Using smp_processor_id() in preemptible code:
 iwd
From: Johannes Berg <johannes@sipsolutions.net>
To: "McGinn, Dan" <dan.mcginn@imperial.ac.uk>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Denis Kenzior <denkenz@gmail.com>
Date: Fri, 15 Jun 2018 14:30:43 +0200
In-Reply-To: <DB5PR06MB106451FE83810B8A129CE1E4A47C0@DB5PR06MB1064.eurprd06.prod.outlook.com> (sfid-20180615_133718_270290_EB030DCF)
References: <DB5PR06MB106451FE83810B8A129CE1E4A47C0@DB5PR06MB1064.eurprd06.prod.outlook.com>
         (sfid-20180615_133718_270290_EB030DCF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2018-06-15 at 11:09 +0000, McGinn, Dan wrote:
> Hi, I'm newly trying out Intel iwd daemon but I experience regular kernel errors in 4.17, although WPA2-PSK connection remains stable.  These errors don't seem to be experienced with wpa_supplicant.  The errors reliably appear around the following events:
> netdev_unicast_notify()
> netdev_control_port_frame_event()
> netdev_set_rekey_offload()
> netdev_set_gtk()
> 
> @Denkenz in IRC helpfully suggests Johannes could follow the finger of suspicion to this commit:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=911806491425d79107cadddbde11b42bbdfe38c8

It's his code ;-)

Clearly this comes from cfg80211 without any locking other than rtnl, so
you don't have preemption disabled. That's the minimum needed to get rid
of the warning you found.

I was thinking this is also wrong because of locking assumptions, but I
don't see that in the code now, so I guess it's fine.

johannes
