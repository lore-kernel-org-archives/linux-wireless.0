Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:37629 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755200AbcGHQbU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2016 12:31:20 -0400
Subject: Re: [v3] ath9k: Switch to using mac80211 intermediate software
 queues.
To: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>
References: <ac5b5bc6532d4fe7ae3198124ecce7fc@euamsexm01a.eu.qualcomm.com>
 <87wpkwktx9.fsf@toke.dk> <112300e0-7d39-0c4c-45c9-158651f0c0ed@nbd.name>
 <87lh1cksao.fsf@toke.dk>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org,
	make-wifi-fast@lists.bufferbloat.net, ath9k-devel@lists.ath9k.org,
	Tim Shepard <shep@alum.mit.edu>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <aba77f01-cfee-0e5a-9b84-9d2e0439bb56@nbd.name> (sfid-20160708_183124_071271_1EAB60A5)
Date: Fri, 8 Jul 2016 18:31:11 +0200
MIME-Version: 1.0
In-Reply-To: <87lh1cksao.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-07-08 18:28, Toke Høiland-Jørgensen wrote:
> Felix Fietkau <nbd@nbd.name> writes:
> 
>> On 2016-07-08 17:53, Toke Høiland-Jørgensen wrote:
>>> Kalle Valo <kvalo@qca.qualcomm.com> writes:
>>> 
>>>> Toke Høiland-Jørgensen wrote:
>>>>> This switches ath9k over to using the mac80211 intermediate software
>>>>> queueing mechanism for data packets. It removes the queueing inside the
>>>>> driver, except for the retry queue, and instead pulls from mac80211 when
>>>>> a packet is needed. The retry queue is used to store a packet that was
>>>>> pulled but can't be sent immediately.
>>>>> 
>>>>> The old code path in ath_tx_start that would queue packets has been
>>>>> removed completely, as has the qlen limit tunables (since there's no
>>>>> longer a queue in the driver to limit).
>>>>> 
>>>>> Based on Tim's original patch set, but reworked quite thoroughly.
>>>>> 
>>>>> Cc: Tim Shepard <shep@alum.mit.edu>
>>>>> Cc: Felix Fietkau <nbd@nbd.name>
>>>>> Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
>>>>
>>>> Nice work.
>>> 
>>> Thanks :)
>>> 
>>>> Because this is such a significant change, and to maximise testing
>>>> time, I'm planning to queue this for 4.9 (so I would apply this to
>>>> ath-next in 3-4 weeks after the merge window closes). But anyone who
>>>> wants to test this can use master-pending branch from my ath.git tree
>>>> (uses wireless-testing as the baseline). Sounds good?
>>> 
>>> Sounds good to me. I'm planning on backporting this and Michael's
>>> mac80211 FQ-CoDel patches to 4.4 and post them for inclusion in LEDE.
>>> Hopefully that will get it some more testing as well.
>> I've pushed a backport of this into my LEDE staging tree:
>> https://git.lede-project.org/?p=lede/nbd/staging.git;a=summary
> 
> Awesome! What about the FQ-CoDel mac80211 patches themselves? I have a
> tree where I've separated out the needed patches and rebased them on
> mainline 4.4.9. Can I post that somewhere (or just email you the series)
> and get you to include those as well? Or do I just dump the patch files
> into the LEDE patches dir and send that as a patch to LEDE? (I see your
> patch also refreshed subsequent patches; is there a script to do that
> automatically?)
You don't need to do anything here. LEDE does not use mac80211 and
drivers from the kernel tree, it's built using backports.
It's currently using a backports snapshot that I built myself from
wireless-testing 2016-06-20, which already includes FQ-Codel.

- Felix
