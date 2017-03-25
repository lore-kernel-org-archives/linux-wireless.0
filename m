Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:51436 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S936370AbdCYBkp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Mar 2017 21:40:45 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <glkwg-linux-wireless@m.gmane.org>)
        id 1cragW-0002Zo-A6
        for linux-wireless@vger.kernel.org; Sat, 25 Mar 2017 02:40:04 +0100
To: linux-wireless@vger.kernel.org
From: Dennis New <dennisn@dennisn.mooo.com>
Subject: wlan0 keeps deauthenticating DEAUTH_LEAVING about every minute
Date: Fri, 24 Mar 2017 21:32:37 -0400
Message-ID: <20170324213237.6f122a9173fa464a5d936f9d@dennisn.mooo.com> (sfid-20170325_024055_755712_8E7A9C9D)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ever since I upgraded to the 4.10 kernels (I don't think this behavior
existed in the 4.8 series), after I startup my laptop (either from cold
boot, or from standby), my wlan0 interface keeps deauthenticating

19:24:29 kernel: wlan0: deauthenticating from 00:11:22:33:44:55 by
local choice (Reason: 3=DEAUTH_LEAVING)

usually exactly 60 seconds after it authenticates/associates (to my
open wifi access point), but not always 60 seconds after -- sometimes
it happens in less than 60 seconds. Although, if it somehow manages to
pass the 60 second mark without deauthenticating, it remains stable --
unless I decide to /etc/init.d/net.wlan0 restart it :s. I'm not sure
what makes makes the deauthentications suddenly stop, but after various
incantations and module unloading/reloading and a fair amount of
cursing, or possibly just waiting some random amount of time, the
problem goes away for the day ... and returns the next day when I boot
up again, and I have to go through this torturous process all over
again, of praying and restarting my wlan0 interface.

Here's a snippet of my messages log, of the usual 60 second deauth:

...
19:23:29 kernel: wlan0: authenticate with 00:11:22:33:44:55
19:23:29 kernel: ------------[ cut here ]------------
19:23:29 kernel: WARNING: CPU: 0 PID: 18925 at net/mac80211/mlme.c:287 ieee80211_determine_chantype+0x12e/0x380
19:23:29 kernel: Modules linked in: b43 [last unloaded: b43]
19:23:29 kernel: Hardware name: Acer, inc. Ferrari 4000
19:23:29 kernel: Call Trace:
19:23:29 kernel:  ? __warn+0xdd/0x100
19:23:29 kernel:  ? ieee80211_determine_chantype+0x12e/0x380
19:23:29 kernel:  ? ieee80211_prep_connection+0x121/0x8a0
19:23:29 kernel:  ? printk+0x42/0x4a
19:23:29 kernel:  ? ieee80211_mgd_auth+0x247/0x3a0
19:23:29 kernel:  ? cfg80211_get_bss+0x1bb/0x230
19:23:29 kernel:  ? cfg80211_mlme_auth+0x11a/0x180
19:23:29 kernel:  ? nl80211_authenticate+0x2e2/0x340
19:23:29 kernel:  ? genl_family_rcv_msg+0x196/0x390
19:23:29 kernel:  ? genl_rcv_msg+0x3e/0x90
19:23:29 kernel:  ? genl_family_rcv_msg+0x390/0x390
19:23:29 kernel:  ? netlink_rcv_skb+0x8f/0xb0
19:23:29 kernel:  ? genl_rcv+0x1f/0x30
19:23:29 kernel:  ? netlink_unicast+0x12f/0x1d0
19:23:29 kernel:  ? netlink_sendmsg+0x2e1/0x380
19:23:29 kernel:  ? rw_copy_check_uvector+0x51/0x100
19:23:29 kernel:  ? sock_sendmsg+0xe/0x20
19:23:29 kernel:  ? ___sys_sendmsg+0x26b/0x280
19:23:29 kernel:  ? core_sys_select+0x232/0x320
19:23:29 kernel:  ? _copy_to_user+0x25/0x30
19:23:29 kernel:  ? sock_getsockopt+0x10d/0x720
19:23:29 kernel:  ? unix_ioctl+0x43/0x50
19:23:29 kernel:  ? sock_do_ioctl.constprop.17+0x19/0x60
19:23:29 kernel:  ? sock_ioctl+0x1dd/0x2b0
19:23:29 kernel:  ? __sys_sendmsg+0x47/0x80
19:23:29 kernel:  ? entry_SYSCALL_64_fastpath+0x13/0x93
19:23:29 kernel: ---[ end trace 17d46d9355f2a966 ]---
19:23:29 kernel: wlan0: send auth to 00:11:22:33:44:55 (try 1/3)
19:23:29 kernel: wlan0: authenticated
19:23:29 kernel: wlan0: associate with 00:11:22:33:44:55 (try 1/3)
19:23:29 kernel: wlan0: RX AssocResp from 00:11:22:33:44:55 (capab=0x401 status=0 aid=1)
19:23:29 kernel: wlan0: associated

19:24:29 kernel: wlan0: deauthenticating from 00:11:22:33:44:55 by local choice (Reason: 3=DEAUTH_LEAVING)
19:24:30 kernel: wlan0: authenticate with 00:11:22:33:44:55
19:24:30 kernel: ------------[ cut here ]------------
19:24:30 kernel: WARNING: CPU: 0 PID: 18925 at net/mac80211/mlme.c:287 ieee80211_determine_chantype+0x12e/0x380
19:24:30 kernel: Modules linked in: b43 [last unloaded: b43]
19:24:30 kernel: Hardware name: Acer, inc. Ferrari 4000
19:24:30 kernel: Call Trace:
19:24:30 kernel:  ? __warn+0xdd/0x100
19:24:30 kernel:  ? ieee80211_determine_chantype+0x12e/0x380
19:24:30 kernel:  ? ieee80211_prep_connection+0x121/0x8a0
19:24:30 kernel:  ? printk+0x42/0x4a
19:24:30 kernel:  ? ieee80211_mgd_auth+0x247/0x3a0
19:24:30 kernel:  ? cfg80211_get_bss+0x1bb/0x230
19:24:30 kernel:  ? cfg80211_mlme_auth+0x11a/0x180
19:24:30 kernel:  ? nl80211_authenticate+0x2e2/0x340
19:24:30 kernel:  ? genl_family_rcv_msg+0x196/0x390
19:24:30 kernel:  ? genl_rcv_msg+0x3e/0x90
19:24:30 kernel:  ? genl_family_rcv_msg+0x390/0x390
19:24:30 kernel:  ? netlink_rcv_skb+0x8f/0xb0
19:24:30 kernel:  ? genl_rcv+0x1f/0x30
19:24:30 kernel:  ? netlink_unicast+0x12f/0x1d0
19:24:30 kernel:  ? netlink_sendmsg+0x2e1/0x380
19:24:30 kernel:  ? rw_copy_check_uvector+0x51/0x100
19:24:30 kernel:  ? sock_sendmsg+0xe/0x20
19:24:30 kernel:  ? ___sys_sendmsg+0x26b/0x280
19:24:30 kernel:  ? core_sys_select+0x232/0x320
19:24:30 kernel:  ? _copy_to_user+0x25/0x30
19:24:30 kernel:  ? sock_getsockopt+0x10d/0x720
19:24:30 kernel:  ? unix_ioctl+0x43/0x50
19:24:30 kernel:  ? sock_do_ioctl.constprop.17+0x19/0x60
19:24:30 kernel:  ? sock_ioctl+0x1dd/0x2b0
19:24:30 kernel:  ? _copy_to_user+0x25/0x30
19:24:30 kernel:  ? __sys_sendmsg+0x47/0x80
19:24:30 kernel:  ? entry_SYSCALL_64_fastpath+0x13/0x93
19:24:30 kernel: ---[ end trace 17d46d9355f2a967 ]---
19:24:30 kernel: wlan0: send auth to 00:11:22:33:44:55 (try 1/3)
19:24:30 kernel: wlan0: authenticated
19:24:30 kernel: wlan0: associate with 00:11:22:33:44:55 (try 1/3)
19:24:30 kernel: wlan0: RX AssocResp from 00:11:22:33:44:55 (capab=0x401 status=0 aid=1)
19:24:30 kernel: wlan0: associated

19:25:30 kernel: wlan0: deauthenticating from 00:11:22:33:44:55 by local choice (Reason: 3=DEAUTH_LEAVING)
...
