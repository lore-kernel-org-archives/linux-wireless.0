Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:42429 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754848Ab0KKS01 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 13:26:27 -0500
Message-ID: <4CDC354C.2060503@candelatech.com>
Date: Thu, 11 Nov 2010 10:26:20 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath5k/mac80211:  Reproducible deadlock with 64-stations.
References: <4CDB2488.4040802@candelatech.com> <1289437356.3748.25.camel@jlt3.sipsolutions.net> <4CDBB716.7020802@kernel.org> <4CDC2016.8020200@candelatech.com>
In-Reply-To: <4CDC2016.8020200@candelatech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/11/2010 08:55 AM, Ben Greear wrote:
> On 11/11/2010 01:27 AM, Tejun Heo wrote:
>> Hello,
>>
>> On 11/11/2010 02:02 AM, Johannes Berg wrote:
>>> I don't really see any deadlock here... hmm. Tejun, do you see anything
>>> wrong with the "locking" in workq stuff here?
>>>
>>> Something is holding the RTNL, and a bunch of other things are trying to
>>> acquire it. We don't really know who's holding it and who's acquiring it
>>> though.

I notice that the system is consistently running OOM, even though
it has 2GB RAM.  I'll try disabling some of the memory-poisoning debugging that may
be consuming excess amounts of RAM to see if that helps any.

Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd:   0
HighMem per-cpu:
CPU    0: hi:  186, btch:  31 usd:   0
active_anon:13122 inactive_anon:4414 isolated_anon:0
  active_file:2904 inactive_file:16491 isolated_file:13
  unevictable:0 dirty:1 writeback:0 unstable:0
  free:257367 slab_reclaimable:2005 slab_unreclaimable:210550
  mapped:9108 shmem:521 pagetables:964 bounce:0
DMA free:3484kB min:64kB low:80kB high:96kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isoo
lowmem_reserve[]: 0 865 2007 2007
Normal free:2296kB min:3728kB low:4660kB high:5592kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anono
lowmem_reserve[]: 0 0 9135 9135
HighMem free:1023688kB min:512kB low:1740kB high:2972kB active_anon:52488kB inactive_anon:17656kB active_file:11616kB inactive_file:65964kB unevictablo
lowmem_reserve[]: 0 0 0 0
DMA: 3*4kB 0*8kB 1*16kB 0*32kB 0*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3484kB
Normal: 402*4kB 64*8kB 1*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2296kB
HighMem: 694*4kB 868*8kB 463*16kB 277*32kB 175*64kB 25*128kB 7*256kB 3*512kB 3*1024kB 1*2048kB 238*4096kB = 1023688kB
19928 total pagecache pages
0 pages in swap cache
Swap cache stats: add 0, delete 0, find 0/0
Free swap  = 4112380kB
Total swap = 4112380kB
521952 pages RAM
294642 pages HighMem
10948 pages reserved
58052 pages shared
241328 pages non-shared


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

