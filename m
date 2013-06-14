Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:59379 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719Ab3FNWsi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Jun 2013 18:48:38 -0400
Received: from [192.168.100.226] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id r5EMmbg4020886
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Fri, 14 Jun 2013 15:48:37 -0700
Message-ID: <51BB9DC5.2020509@candelatech.com> (sfid-20130615_004841_632650_1CE63E73)
Date: Fri, 14 Jun 2013 15:48:37 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: kmemleak report in 3.9.5+, related to cfg80211_inform_bss_frame
References: <51B773B7.5090301@candelatech.com> <51B77594.20000@candelatech.com> <51B7C29C.1060701@candelatech.com>
In-Reply-To: <51B7C29C.1060701@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/11/2013 05:36 PM, Ben Greear wrote:
> On 06/11/2013 12:08 PM, Ben Greear wrote:
>> On 06/11/2013 12:00 PM, Ben Greear wrote:
>>> I see several reports similar to the one below while doing some
>>> kmemleak testing on my 3.9.5+ tree (with local patches applied):
>>>
>>> http://dmz2.candelatech.com/git/gitweb.cgi?p=linux-3.9.dev.y/.git;a=summary
>
>>> The kmemleak report is below:
>>>
>>>
>>> unreferenced object 0xffff8801c8e41e78 (size 192):
>>>    comm "kworker/u:2", pid 157, jiffies 4295509873 (age 86582.869s)
>>>    hex dump (first 32 bytes):
>>>      41 0d 00 30 02 00 00 00 6b 6b 6b 6b 6b 6b 6b 6b  A..0....kkkkkkkk
>>>      6b 6b 6b 6b 6b 6b 6b 6b 69 00 00 00 00 0c 2e 32  kkkkkkkki......2
>>>    backtrace:
>>>      [<ffffffff815de7bf>] kmemleak_alloc+0x73/0x98
>>>      [<ffffffff8118b4d4>] slab_post_alloc_hook+0x28/0x2a
>>>      [<ffffffff8118d605>] __kmalloc+0xf9/0x122
>>>      [<ffffffffa027cb27>] cfg80211_inform_bss_frame+0x114/0x1f8 [cfg80211]
>>>      [<ffffffffa03d6865>] ieee80211_bss_info_update+0x66/0x21f [mac80211]
>>>      [<ffffffffa040aec6>] ieee80211_rx_bss_info+0x12f/0x1ca [mac80211]
>>>      [<ffffffffa040b017>] ieee80211_rx_mgmt_probe_resp+0xb6/0x197 [mac80211]
>>>      [<ffffffffa040e8a3>] ieee80211_sta_rx_queued_mgmt+0xdd/0x60e [mac80211]
>>>      [<ffffffffa03df0ee>] ieee80211_iface_work+0x238/0x2cc [mac80211]
>>>      [<ffffffff810b0cd3>] process_one_work+0x292/0x42e
>>>      [<ffffffff810b36af>] worker_thread+0x14f/0x264
>>>      [<ffffffff810b7bea>] kthread+0xc7/0xcf
>>>      [<ffffffff815f64ec>] ret_from_fork+0x7c/0xb0
>>>      [<ffffffffffffffff>] 0xffffffffffffffff

I am still working on trying to figure this one out.

I've instrumented all (as far as I can tell) allocation points
and destruction points for the ies, and I am keeping a separate
list of structures to record some info about each ies.

I loaded up lots of stations, let them bounce around for a while,
and then did an 'rmmod ath9k'.

I still see 14 ies entries in my debug list.  Should
I expect to see zero ies data structures left after
I rmmod all wifi drivers, or is it normal for a few
to be left around?


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

