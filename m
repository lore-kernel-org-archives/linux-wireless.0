Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:38094 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022Ab2FMKzJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 06:55:09 -0400
Received: by obbtb18 with SMTP id tb18so688744obb.19
        for <linux-wireless@vger.kernel.org>; Wed, 13 Jun 2012 03:55:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1339575455.4519.12.camel@jlt3.sipsolutions.net>
References: <1339494075-28068-1-git-send-email-eliad@wizery.com>
	<1339575455.4519.12.camel@jlt3.sipsolutions.net>
Date: Wed, 13 Jun 2012 13:55:08 +0300
Message-ID: <CAB3XZEcmyjqsbHQgcsjZfi=EO+U+Q7=h6znQKUMNVrgok4wOrw@mail.gmail.com> (sfid-20120613_125548_865791_726E7A74)
Subject: Re: [PATCH] mac80211: check sdata_running on ieee80211_set_bitrate_mask
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 13, 2012 at 11:17 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2012-06-12 at 12:41 +0300, Eliad Peller wrote:
>> Otherwise, we might call the driver callback before
>> the interface was uploaded.
>>
>> Solves the following warning:
>> [64811.717315] WARNING: at net/mac80211/driver-ops.h:12 ieee80211_set_bitrate_mask+0xbc/0x18c [mac80211]()
>> [64811.727264] wlan0:  Failed check-sdata-in-driver check, flags: 0x0
>> [64811.733856] Modules linked in: wlcore_sdio wl12xx wl18xx wlcore mac80211 cfg80211 [last unloaded: cfg80211]
>> [64811.744232] [<c001b964>] (unwind_backtrace+0x0/0x12c) from [<c0495550>] (dump_stack+0x20/0x24)
>> [64811.753417] [<c0495550>] (dump_stack+0x20/0x24) from [<c003ee28>] (warn_slowpath_common+0x5c/0x74)
>> [64811.762939] [<c003ee28>] (warn_slowpath_common+0x5c/0x74) from [<c003eefc>] (warn_slowpath_fmt+0x40/0x48)
>> [64811.773284] [<c003eefc>] (warn_slowpath_fmt+0x40/0x48) from [<bf5c1ad0>] (ieee80211_set_bitrate_mask+0xbc/0x18c [mac80211])
>> [64811.785491] [<bf5c1ad0>] (ieee80211_set_bitrate_mask+0xbc/0x18c [mac80211]) from [<bf575960>] (nl80211_set_tx_bitrate_mask+0x350/0x358 [cfg80211])
>> [64811.799530] [<bf575960>] (nl80211_set_tx_bitrate_mask+0x350/0x358 [cfg80211]) from [<c03e9e94>] (genl_rcv_msg+0x1a8/0x1e8)
>> [64811.811248] [<c03e9e94>] (genl_rcv_msg+0x1a8/0x1e8) from [<c03e9164>] (netlink_rcv_skb+0x5c/0xc0)
>> [64811.820648] [<c03e9164>] (netlink_rcv_skb+0x5c/0xc0) from [<c03e9ce0>] (genl_rcv+0x28/0x34)
>> [64811.829467] [<c03e9ce0>] (genl_rcv+0x28/0x34) from [<c03e8e74>] (netlink_unicast+0x158/0x234)
>> [64811.838531] [<c03e8e74>] (netlink_unicast+0x158/0x234) from [<c03e93e0>] (netlink_sendmsg+0x218/0x298)
>> [64811.848419] [<c03e93e0>] (netlink_sendmsg+0x218/0x298) from [<c03b4e5c>] (sock_sendmsg+0xa4/0xc0)
>> [64811.857849] [<c03b4e5c>] (sock_sendmsg+0xa4/0xc0) from [<c03b5af4>] (__sys_sendmsg+0x1d8/0x254)
>> [64811.867065] [<c03b5af4>] (__sys_sendmsg+0x1d8/0x254) from [<c03b5ca8>] (sys_sendmsg+0x4c/0x70)
>> [64811.876251] [<c03b5ca8>] (sys_sendmsg+0x4c/0x70) from [<c0013980>] (ret_fast_syscall+0x0/0x3c)
>
> Applied, I removed the timestamps from the log and added a note about
> undefined behaviour in the driver.
>
thanks. i'll do it next time myself :)
