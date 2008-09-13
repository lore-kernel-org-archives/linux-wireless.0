Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:34235 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbYIMXrJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Sep 2008 19:47:09 -0400
Received: by gxk9 with SMTP id 9so21858372gxk.13
        for <linux-wireless@vger.kernel.org>; Sat, 13 Sep 2008 16:47:06 -0700 (PDT)
Message-ID: <43e72e890809131647u7055f41am19ac37ea9a8ee250@mail.gmail.com> (sfid-20080914_014750_039989_93A46624)
Date: Sat, 13 Sep 2008 16:47:05 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: ingeideas@yahoo.com
Subject: Re: Bug report compat-wireless-2.6-old
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890809131236v6b5893c1q16a11231c6131741@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <201197.56850.qm@web34804.mail.mud.yahoo.com>
	 <43e72e890809131236v6b5893c1q16a11231c6131741@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Sep 13, 2008 at 12:36 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Sat, Sep 13, 2008 at 9:12 AM, Edgar Velasco <ingeideas@yahoo.com> wrote:
>> I'm reporting a bug.
>> Went I make, this is what I get:
>>
>> compat-wireless-2.6-old # make
>> /root/compat-wireless-2.6-old/config.mk:30: *** "ERROR: There is a bug with compat-wireless on 2.6.22. Remove me if you want to fix me".  Stop.
>>
>> How can I fix it?
>> Edgar Velasco
>
> (keeping the subject now)
>
> The error happens because config.mk checks for your kernel release and
> if it detects its you are using a kernel release <= 2.6.22 it'll stop
> and error out with that message. The problem is there is an oops
> (kernel crash) that will occur if you enable the compile to go through
> and use it. The error indicates to you that if you want to try to fix
> the issue you can remove the force check on config.mk.
>
> I used to support 2.6.22 but distributions have newer kernels so I
> rather focus attention on newer kernels as we move forward. This gives
> the opportunity for those developers interested in using 2.6.22 to go
> ahead and fix it if they wish.
>
> If you are a user I'd recommend to upgrade to at least 2.6.26.

BTW this was the oops IIRC:

wme_qdiscop_dequeue+0x120
__qdisc_run
ieee80211_send_probe_req+0x1a0
ieee80211_send_probe_req+0x1a0
dev_queue_xmit+0x218
ieee80211_sta_scan_work+0xe6
ieee80211_sta_scan_work+0x0
run_workqueue+0x81

So at least people interested can look at some code path. Turns out I
did have my old module lying around so I'm able to also tell you
exactly where this happens:

mcgrof@tesla /lib/modules/2.6.22-15-generic/updates/net/mac80211 $ gdb
mac80211.ko
GNU gdb 6.8-debian
Copyright (C) 2008 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "i486-linux-gnu"...
(gdb) l *(wme_qdiscop_dequeue+0x120)
0x18a20 is in wme_qdiscop_dequeue
(/home/mcgrof/devel/compat-wireless-2.6/net/mac80211/ieee80211_i.h:768).
warning: Source file is more recent than executable.
763	static inline struct ieee80211_sub_if_data *
764	IEEE80211_DEV_TO_SUB_IF(struct net_device *dev)
765	{
766		struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
767	
768		BUG_ON(!local || local->mdev == dev);
769	
770		return netdev_priv(dev);
771	}
772	
(gdb)

So line 768 is the culprit. I've stashed this here for now as we have
no bugzilla thingy for compat-wireless-old (should we?):

http://wireless.kernel.org/en/users/Download/compat-wireless-old-2.6.22-bug

  Luis
