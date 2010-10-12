Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:55265 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403Ab0JLSkx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Oct 2010 14:40:53 -0400
Received: by gwj17 with SMTP id 17so1537685gwj.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Oct 2010 11:40:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4CB4AA89.1070009@candelatech.com>
References: <4CAB59B2.5050106@candelatech.com> <4CAB627F.8020804@candelatech.com>
 <AANLkTi=sT5QJe4V8gFGjF-nzx0uJAMLG_XG2715qrEEd@mail.gmail.com>
 <4CAB64AD.4080105@candelatech.com> <AANLkTi=3dHbB5tmQDp3Ba54-DqQydVCkNdFo1vKbfaGY@mail.gmail.com>
 <4CAB6B08.4050801@candelatech.com> <4CAE0474.4090605@candelatech.com>
 <1286475250.20974.22.camel@jlt3.sipsolutions.net> <AANLkTinbRSnPVgbBxvVpMdnP+K--bye=Q-miHf4X44kz@mail.gmail.com>
 <4CAE13F6.2010003@candelatech.com> <AANLkTimEZ5GY7WFz-F4YyC+6MEwNn2Dki4tonp645XrS@mail.gmail.com>
 <4CAE1DFB.303@candelatech.com> <1286479642.20974.32.camel@jlt3.sipsolutions.net>
 <AANLkTimxp703Gy_Atg8=wpFszRDR=OJCXwOUKRh-a-d7@mail.gmail.com>
 <AANLkTi=t-P_5c14brJohM8UgxeOknv+3syO=7W=ix6qf@mail.gmail.com>
 <AANLkTinC46a+nE-XOQuBCmRJwjzgh24uC7ZJ7HtbVHnT@mail.gmail.com>
 <4CB378CD.1080800@candelatech.com> <AANLkTim42zmDwf744BCrPwa1kT5ph57bNMyvSyOpesVv@mail.gmail.com>
 <4CB3D598.7050904@candelatech.com> <AANLkTimPEg3ZU8CQUXfdpGdfbmhdE9O=GNY=g9gysTo4@mail.gmail.com>
 <4CB4AA89.1070009@candelatech.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 12 Oct 2010 11:40:14 -0700
Message-ID: <AANLkTinpWvMtexFTYVm5rEZY=gY7qY8WxHFtVGB0o6Se@mail.gmail.com>
Subject: Re: memory clobber in rx path, maybe related to ath9k.
To: Ben Greear <greearb@candelatech.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 12, 2010 at 11:35 AM, Ben Greear <greearb@candelatech.com> wrote:
> On 10/11/2010 11:10 PM, Luis R. Rodriguez wrote:
>>
>> On Mon, Oct 11, 2010 at 8:27 PM, Ben Greear<greearb@candelatech.com>
>>  wrote:
>
>>> Another thing I was thinking about:  Maybe the queue of skbs and dma
>>> addresses
>>> in ath9k is getting corrupted by multiple VIFs trying to write at once?
>>>  Maybe
>>> some locking is needed in the xmit path?
>>
>> That was my second hunch. My first shot was to use spin_lock_irqsave()
>> over the the uses of the rxbuf list and that seemed to help but I
>> still managed to get a poison eventually. My next item to check for is
>> of the permissibility of creating too much pressure to the point we
>> end up looping over the rxbuf list and race against mac80211 free'ing
>> a buffer. Will test that tomorrow if nothing else comes up creeping my
>> priority queue.
>
> This code looks weird to me.  One of the paprd branches
> deletes the skb, the other doesn't appear to.  Neither
> null out bf->bf_mpdu, which would appear to leave a dangling
> pointer in at least the dev_kfree_skb_any() branch.
>
> ath_tx_complete frees it's skb in all cases, so another
> bf->bf_mpdu dangling pointer issue.
>
> Maybe at the least we should null out bf->bf_mpdu when
> skb is consumed?

You're reading my mind, that was what I was going to test today. Still
doing e-mail sweep though.

 Luis
