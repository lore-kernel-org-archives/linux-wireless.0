Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34932 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755691Ab0JNV0M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 17:26:12 -0400
Received: by iwn35 with SMTP id 35so50184iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Oct 2010 14:26:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4CB5F0D4.4020907@candelatech.com>
References: <4CAB59B2.5050106@candelatech.com> <4CAB6B08.4050801@candelatech.com>
 <4CAE0474.4090605@candelatech.com> <1286475250.20974.22.camel@jlt3.sipsolutions.net>
 <AANLkTinbRSnPVgbBxvVpMdnP+K--bye=Q-miHf4X44kz@mail.gmail.com>
 <4CAE13F6.2010003@candelatech.com> <AANLkTimEZ5GY7WFz-F4YyC+6MEwNn2Dki4tonp645XrS@mail.gmail.com>
 <4CAE1DFB.303@candelatech.com> <1286479642.20974.32.camel@jlt3.sipsolutions.net>
 <AANLkTimxp703Gy_Atg8=wpFszRDR=OJCXwOUKRh-a-d7@mail.gmail.com>
 <AANLkTi=t-P_5c14brJohM8UgxeOknv+3syO=7W=ix6qf@mail.gmail.com>
 <AANLkTinC46a+nE-XOQuBCmRJwjzgh24uC7ZJ7HtbVHnT@mail.gmail.com>
 <4CB378CD.1080800@candelatech.com> <AANLkTim42zmDwf744BCrPwa1kT5ph57bNMyvSyOpesVv@mail.gmail.com>
 <4CB3D598.7050904@candelatech.com> <AANLkTimPEg3ZU8CQUXfdpGdfbmhdE9O=GNY=g9gysTo4@mail.gmail.com>
 <4CB4AA89.1070009@candelatech.com> <AANLkTinpWvMtexFTYVm5rEZY=gY7qY8WxHFtVGB0o6Se@mail.gmail.com>
 <4CB5E885.7090305@candelatech.com> <AANLkTi=c=w8MvXZ=vqxkRgbXasacQTYXUX8o_zXoZgxC@mail.gmail.com>
 <4CB5F0D4.4020907@candelatech.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 14 Oct 2010 14:25:51 -0700
Message-ID: <AANLkTimCyHRRoh34Cfv=b+h-9SoeuJzur46WyEZ7BKT-@mail.gmail.com>
Subject: Re: memory clobber in rx path, maybe related to ath9k.
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 13, 2010 at 10:48 AM, Ben Greear <greearb@candelatech.com> wrote:
> On 10/13/2010 10:29 AM, Luis R. Rodriguez wrote:
>>
>> On Wed, Oct 13, 2010 at 10:12 AM, Ben Greear<greearb@candelatech.com>
>>  wrote:
>>>
>>> On 10/12/2010 11:40 AM, Luis R. Rodriguez wrote:
>>>>
>>>> On Tue, Oct 12, 2010 at 11:35 AM, Ben Greear<greearb@candelatech.com>
>>>>  wrote:
>>>>>
>>>>> On 10/11/2010 11:10 PM, Luis R. Rodriguez wrote:
>>>>>>
>>>>>> On Mon, Oct 11, 2010 at 8:27 PM, Ben Greear<greearb@candelatech.com>
>>>>>>  wrote:
>>>>>
>>>>>>> Another thing I was thinking about:  Maybe the queue of skbs and dma
>>>>>>> addresses
>>>>>>> in ath9k is getting corrupted by multiple VIFs trying to write at
>>>>>>> once?
>>>>>>>  Maybe
>>>>>>> some locking is needed in the xmit path?
>>>>>>
>>>>>> That was my second hunch. My first shot was to use spin_lock_irqsave()
>>>>>> over the the uses of the rxbuf list and that seemed to help but I
>>>>>> still managed to get a poison eventually. My next item to check for is
>>>>>> of the permissibility of creating too much pressure to the point we
>>>>>> end up looping over the rxbuf list and race against mac80211 free'ing
>>>>>> a buffer. Will test that tomorrow if nothing else comes up creeping my
>>>>>> priority queue.
>>>>>
>>>>> This code looks weird to me.  One of the paprd branches
>>>>> deletes the skb, the other doesn't appear to.  Neither
>>>>> null out bf->bf_mpdu, which would appear to leave a dangling
>>>>> pointer in at least the dev_kfree_skb_any() branch.
>>>>>
>>>>> ath_tx_complete frees it's skb in all cases, so another
>>>>> bf->bf_mpdu dangling pointer issue.
>>>>>
>>>>> Maybe at the least we should null out bf->bf_mpdu when
>>>>> skb is consumed?
>>>>
>>>> You're reading my mind, that was what I was going to test today. Still
>>>> doing e-mail sweep though.
>>>
>>> At least in the xmit path, it seems cards that have EDMA support do
>>> things a bit different.  Out of curiosity, on the system(s), you
>>> reproduce
>>> this, are any of yours supporting EDMA?  Mine appear to not support EDMA.
>>
>> EDMA is used on>= AR9003 families by Atheros. And no, I am not
>> testing with an EDMA card, I am testing with an AR9002 family card,
>> the AR9280 card. I am going to disregard the TX stuff as the bug is an
>> RX issue :) I was able to more easily reproduce by doing an skb_copy()
>> and free'ing the buffer right afterwards on the ath_send_to_mac80211()
>> thingy, So it does appear that the poison check just happens more
>> often when we do an skb_copy(). One reason this is easy to reproduce
>> with multiple STAs is mac80211 uses skb_copy() to process each
>> received skb for each STA.
>>
>> In my tests so far, protecting the rxbuf list with spin_lock_irqsave()
>> did not help, and the wmb(); didn't either, something else is going on
>> here. It would be nice to hack slab to keep an entire trace of the
>> place the buffer was last free'd at instead of just the caller that
>> freed it.
>
> I instrumented slub a while back and got the backtrace.  It
> was always in the same place for my testing.
>
> Here's the slub patch if you are interested in using it yourself:
> https://patchwork.kernel.org/patch/236921/

when compiling this patch I get:

arch/x86/built-in.o: In function `store_stack':
/home/mcgrof/wireless-testing/arch/x86/kernel/dumpstack.c:259:
undefined reference to `store_trace'

  Luis
