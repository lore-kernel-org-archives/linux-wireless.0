Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:36927 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962Ab0JGRdn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 13:33:43 -0400
Message-ID: <4CAE0474.4090605@candelatech.com>
Date: Thu, 07 Oct 2010 10:33:40 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: memory clobber in rx path, maybe related to ath9k.
References: <4CAB59B2.5050106@candelatech.com> <AANLkTikhGCTS8kJgpDzjudyBTk-rkyXY33UO7kB0+Cc-@mail.gmail.com> <4CAB5F3D.9060201@candelatech.com> <AANLkTimV3GrwU+9PPtirT4sCzveLY2egr3PRQhfDBET1@mail.gmail.com> <4CAB627F.8020804@candelatech.com> <AANLkTi=sT5QJe4V8gFGjF-nzx0uJAMLG_XG2715qrEEd@mail.gmail.com> <4CAB64AD.4080105@candelatech.com> <AANLkTi=3dHbB5tmQDp3Ba54-DqQydVCkNdFo1vKbfaGY@mail.gmail.com> <4CAB6B08.4050801@candelatech.com>
In-Reply-To: <4CAB6B08.4050801@candelatech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


In case it helps, here is a dump of where the corrupted SKB was deleted.

I added debugging to slub to get this information, but it looks like
it's correct to me.


Reading symbols from /home/greearb/kernel/2.6/wireless-testing-dbg.p4s/net/mac80211/mac80211.ko...done.
(gdb) l *(ieee80211_rx+0x74d)
0x13751 is in ieee80211_rx (/home/greearb/git/linux.wireless-testing/include/linux/rcupdate.h:346).
341	 *
342	 * See rcu_read_lock() for more information.
343	 */
344	static inline void rcu_read_unlock(void)
345	{
346		rcu_read_release();
347		__release(RCU);
348		__rcu_read_unlock();
349	}
350	
(gdb)


# I don't really know what that second address means, but just in case it's useful,
# I printed it out here:

(gdb) l *(ieee80211_rx+0x7b4)
0x137b8 is in ieee80211_process_measurement_req (/home/greearb/git/linux.wireless-testing/net/mac80211/spectmgmt.c:74).
69	}
70	
71	void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,
72					       struct ieee80211_mgmt *mgmt,
73					       size_t len)
74	{
75		/*
76		 * Ignoring measurement request is spec violation.
77		 * Mandatory measurements must be reported optional
78		 * measurements might be refused or reported incapable


INFO: Freed in skb_release_data+0x8c/0x90 age=122 cpu=1 pid=0
         set_track+0x3c/0x89
         __slab_free+0x17f/0x1ba
         skb_release_data+0x8c/0x90
         kfree+0xaf/0xdf
         skb_release_data+0x8c/0x90
         skb_release_data+0x8c/0x90
         skb_release_data+0x8c/0x90
         __kfree_skb+0x12/0x6d
         consume_skb+0x2a/0x2c
         ieee80211_rx+0x74d/0x7b4 [mac80211]
         __kmalloc_track_caller+0xcd/0xf2
         trace_hardirqs_on_caller+0xeb/0x125
         ath_rx_send_to_mac80211+0x5a/0x60 [ath9k]
         trace_hardirqs_on+0xb/0xd

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

