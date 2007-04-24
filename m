Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:48701 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422984AbXDXSJ2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Apr 2007 14:09:28 -0400
Message-ID: <462E47D0.8030800@warmcat.com>
Date: Tue, 24 Apr 2007 19:09:20 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Michael Wu <flamingice@sourmilk.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 03/13] mac80211: fix virtual interface related locking
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net> <20070423184812.7029.7682.stgit@magic.sourmilk.net> <462D1DD8.8060507@warmcat.com> <200704231722.07280.flamingice@sourmilk.net>
In-Reply-To: <200704231722.07280.flamingice@sourmilk.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Wu wrote:

> On Monday 23 April 2007 16:58, Andy Green wrote:
>> Couldn't get this to apply on current wireless-dev, and there is a
>> trailing whitespace.  Maybe it's a problem with a script I concocted to
>> extract the patch from saved Thunderbird 2.0 mails... ?  Is it just that
>> wireless-dev changed inbetweentimes?
>>
> This patch series depends on the recent cfg80211/mac80211 rtnl locking 
> patches.

Thanks for that.  I added

cfg80211_nl80211-use-rtnl.patch
mac80211-update-for-cfg80211-rtnl-locking.patch

(these names are made from the originally posted subject line) before 
your series and they went in fine.  And the injection patches went in 
fine on top of that, and continue to work.

However I saw this on reinsertion of zd1211rw-mac80211 module:

=============================================
[ INFO: possible recursive locking detected ]
2.6.21-rc7 #11
---------------------------------------------
ip/2600 is trying to acquire lock:
  (&dev->_xmit_lock){-+..}, at: [<e09199c5>] 
ieee80211_set_multicast_list+0x46/0x167 [mac80211]

but task is already holding lock:
  (&dev->_xmit_lock){-+..}, at: [<c05abc05>] dev_mc_upload+0x14/0x3c

other info that might help us debug this:
2 locks held by ip/2600:
  #0:  (rtnl_mutex){--..}, at: [<c0609593>] mutex_lock+0x21/0x24
  #1:  (&dev->_xmit_lock){-+..}, at: [<c05abc05>] dev_mc_upload+0x14/0x3c

stack backtrace:
  [<c0405ea6>] show_trace_log_lvl+0x1a/0x2f
  [<c0406456>] show_trace+0x12/0x14
  [<c04064da>] dump_stack+0x16/0x18
  [<c04428c7>] __lock_acquire+0x116/0xb46
  [<c04436b8>] lock_acquire+0x56/0x6f
  [<c060a7d1>] _spin_lock+0x2b/0x38
  [<e09199c5>] ieee80211_set_multicast_list+0x46/0x167 [mac80211]
  [<c05abad8>] __dev_mc_upload+0x20/0x22
  [<c05abc18>] dev_mc_upload+0x27/0x3c
  [<c05a9e79>] dev_open+0x47/0x66
  [<c05a87b9>] dev_change_flags+0x51/0xf1
  [<c05e60c4>] devinet_ioctl+0x235/0x53b
  [<c05e6684>] inet_ioctl+0x73/0x91
  [<c059f531>] sock_ioctl+0x1ac/0x1c9
  [<c048464a>] do_ioctl+0x22/0x67
  [<c04848e1>] vfs_ioctl+0x252/0x265
  [<c048493d>] sys_ioctl+0x49/0x64
  [<c0404eec>] syscall_call+0x7/0xb

-Andy
