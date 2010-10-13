Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:38246 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab0JMRsM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Oct 2010 13:48:12 -0400
Message-ID: <4CB5F0D4.4020907@candelatech.com>
Date: Wed, 13 Oct 2010 10:48:04 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: memory clobber in rx path, maybe related to ath9k.
References: <4CAB59B2.5050106@candelatech.com> <4CAB6B08.4050801@candelatech.com> <4CAE0474.4090605@candelatech.com> <1286475250.20974.22.camel@jlt3.sipsolutions.net> <AANLkTinbRSnPVgbBxvVpMdnP+K--bye=Q-miHf4X44kz@mail.gmail.com> <4CAE13F6.2010003@candelatech.com> <AANLkTimEZ5GY7WFz-F4YyC+6MEwNn2Dki4tonp645XrS@mail.gmail.com> <4CAE1DFB.303@candelatech.com> <1286479642.20974.32.camel@jlt3.sipsolutions.net> <AANLkTimxp703Gy_Atg8=wpFszRDR=OJCXwOUKRh-a-d7@mail.gmail.com> <AANLkTi=t-P_5c14brJohM8UgxeOknv+3syO=7W=ix6qf@mail.gmail.com> <AANLkTinC46a+nE-XOQuBCmRJwjzgh24uC7ZJ7HtbVHnT@mail.gmail.com> <4CB378CD.1080800@candelatech.com> <AANLkTim42zmDwf744BCrPwa1kT5ph57bNMyvSyOpesVv@mail.gmail.com> <4CB3D598.7050904@candelatech.com> <AANLkTimPEg3ZU8CQUXfdpGdfbmhdE9O=GNY=g9gysTo4@mail.gmail.com> <4CB4AA89.1070009@candelatech.com> <AANLkTinpWvMtexFTYVm5rEZY=gY7qY8WxHFtVGB0o6Se@mail.gmail.com> <4CB5E885.7090305@candelatech.com> <AANLkTi=c=w8MvXZ=vqxkRgbXasacQTYXUX8o_zXoZgxC@mail.gmail.com>
In-Reply-To: <AANLkTi=c=w8MvXZ=vqxkRgbXasacQTYXUX8o_zXoZgxC@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/13/2010 10:29 AM, Luis R. Rodriguez wrote:
> On Wed, Oct 13, 2010 at 10:12 AM, Ben Greear<greearb@candelatech.com>  wrote:
>> On 10/12/2010 11:40 AM, Luis R. Rodriguez wrote:
>>>
>>> On Tue, Oct 12, 2010 at 11:35 AM, Ben Greear<greearb@candelatech.com>
>>>   wrote:
>>>>
>>>> On 10/11/2010 11:10 PM, Luis R. Rodriguez wrote:
>>>>>
>>>>> On Mon, Oct 11, 2010 at 8:27 PM, Ben Greear<greearb@candelatech.com>
>>>>>   wrote:
>>>>
>>>>>> Another thing I was thinking about:  Maybe the queue of skbs and dma
>>>>>> addresses
>>>>>> in ath9k is getting corrupted by multiple VIFs trying to write at once?
>>>>>>   Maybe
>>>>>> some locking is needed in the xmit path?
>>>>>
>>>>> That was my second hunch. My first shot was to use spin_lock_irqsave()
>>>>> over the the uses of the rxbuf list and that seemed to help but I
>>>>> still managed to get a poison eventually. My next item to check for is
>>>>> of the permissibility of creating too much pressure to the point we
>>>>> end up looping over the rxbuf list and race against mac80211 free'ing
>>>>> a buffer. Will test that tomorrow if nothing else comes up creeping my
>>>>> priority queue.
>>>>
>>>> This code looks weird to me.  One of the paprd branches
>>>> deletes the skb, the other doesn't appear to.  Neither
>>>> null out bf->bf_mpdu, which would appear to leave a dangling
>>>> pointer in at least the dev_kfree_skb_any() branch.
>>>>
>>>> ath_tx_complete frees it's skb in all cases, so another
>>>> bf->bf_mpdu dangling pointer issue.
>>>>
>>>> Maybe at the least we should null out bf->bf_mpdu when
>>>> skb is consumed?
>>>
>>> You're reading my mind, that was what I was going to test today. Still
>>> doing e-mail sweep though.
>>
>> At least in the xmit path, it seems cards that have EDMA support do
>> things a bit different.  Out of curiosity, on the system(s), you reproduce
>> this, are any of yours supporting EDMA?  Mine appear to not support EDMA.
>
> EDMA is used on>= AR9003 families by Atheros. And no, I am not
> testing with an EDMA card, I am testing with an AR9002 family card,
> the AR9280 card. I am going to disregard the TX stuff as the bug is an
> RX issue :) I was able to more easily reproduce by doing an skb_copy()
> and free'ing the buffer right afterwards on the ath_send_to_mac80211()
> thingy, So it does appear that the poison check just happens more
> often when we do an skb_copy(). One reason this is easy to reproduce
> with multiple STAs is mac80211 uses skb_copy() to process each
> received skb for each STA.
>
> In my tests so far, protecting the rxbuf list with spin_lock_irqsave()
> did not help, and the wmb(); didn't either, something else is going on
> here. It would be nice to hack slab to keep an entire trace of the
> place the buffer was last free'd at instead of just the caller that
> freed it.

I instrumented slub a while back and got the backtrace.  It
was always in the same place for my testing.

Here's the slub patch if you are interested in using it yourself:
https://patchwork.kernel.org/patch/236921/


Are you able to reproduce this with a single STA interface?  If so, we
should be able to somewhat tie-break mac80211 by using another /n NIC,
hopefully with similar AMPDU support, etc.


[From a mail I sent on 10/7 in this thread]

In case it helps, here is a dump of where the corrupted SKB was deleted.

I added debugging to slub to get this information, but it looks like
it's correct to me.


Reading symbols from /home/greearb/kernel/2.6/wireless-testing-dbg.p4s/net/mac80211/mac80211.ko...done.
(gdb) l *(ieee80211_rx+0x74d)
0x13751 is in ieee80211_rx (/home/greearb/git/linux.wireless-testing/include/linux/rcupdate.h:346).
341     *
342     * See rcu_read_lock() for more information.
343     */
344    static inline void rcu_read_unlock(void)
345    {
346        rcu_read_release();
347        __release(RCU);
348        __rcu_read_unlock();
349    }
350
(gdb)


# I don't really know what that second address means, but just in case it's useful,
# I printed it out here:

(gdb) l *(ieee80211_rx+0x7b4)
0x137b8 is in ieee80211_process_measurement_req (/home/greearb/git/linux.wireless-testing/net/mac80211/spectmgmt.c:74).
69    }
70
71    void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,
72                           struct ieee80211_mgmt *mgmt,
73                           size_t len)
74    {
75        /*
76         * Ignoring measurement request is spec violation.
77         * Mandatory measurements must be reported optional
78         * measurements might be refused or reported incapable


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



-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

