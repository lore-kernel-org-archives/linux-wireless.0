Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:30265 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934241AbaDJHSq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2014 03:18:46 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	Ben Greear <greearb@candelatech.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFTv2 3/5] ath10k: rework peer accounting
References: <1396611464-5940-1-git-send-email-michal.kazior@tieto.com>
	<1397040531-6224-1-git-send-email-michal.kazior@tieto.com>
	<1397040531-6224-4-git-send-email-michal.kazior@tieto.com>
	<87k3axhdqc.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQ=c+dTcK_diBKi6VJVgUkyBv21bDkRf+9GvGyhhqqMuNQ@mail.gmail.com>
Date: Thu, 10 Apr 2014 10:18:40 +0300
In-Reply-To: <CA+BoTQ=c+dTcK_diBKi6VJVgUkyBv21bDkRf+9GvGyhhqqMuNQ@mail.gmail.com>
	(Michal Kazior's message of "Thu, 10 Apr 2014 09:11:13 +0200")
Message-ID: <87fvllhctr.fsf@kamboji.qca.qualcomm.com> (sfid-20140410_091850_989675_4AE0D9B1)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

>>> +/* hold conf_mutex for simple iteration, or conf_mutex+data_lock for
>>> + * modifications */
>>>  struct ath10k_peer *ath10k_peer_find(struct ath10k *ar, int vdev_id,
>>>                                    const u8 *addr)
>>>  {
>>>       struct ath10k_peer *peer;
>>>
>>> -     lockdep_assert_held(&ar->data_lock);
>>> -
>>>       list_for_each_entry(peer, &ar->peers, list) {
>>>               if (peer->vdev_id != vdev_id)
>>>                       continue;
>>
>> The comment here makes me suspicious. How can we safely iterate the list
>> if we don't take data_lock? Doesn't it mean that the list can change
>> while we have conf_mutex?
>
> The idea is you need BOTH locks to modify the list structure, but you
> need only one of them to iterate over the list safely and
> consistently. This means writer will not alter the list structure
> until there are no readers.

Still not understanding this. Why not then use conf_mutex always, why do
we need data_lock at all?

Or are you saying that one can iterate the list by either taking
conf_mutex or by taking data_lock, depending on context?

-- 
Kalle Valo
