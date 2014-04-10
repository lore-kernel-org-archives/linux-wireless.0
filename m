Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:38261 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965383AbaDJHnO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2014 03:43:14 -0400
Received: by mail-we0-f174.google.com with SMTP id t60so3539139wes.19
        for <linux-wireless@vger.kernel.org>; Thu, 10 Apr 2014 00:43:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87fvllhctr.fsf@kamboji.qca.qualcomm.com>
References: <1396611464-5940-1-git-send-email-michal.kazior@tieto.com>
	<1397040531-6224-1-git-send-email-michal.kazior@tieto.com>
	<1397040531-6224-4-git-send-email-michal.kazior@tieto.com>
	<87k3axhdqc.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQ=c+dTcK_diBKi6VJVgUkyBv21bDkRf+9GvGyhhqqMuNQ@mail.gmail.com>
	<87fvllhctr.fsf@kamboji.qca.qualcomm.com>
Date: Thu, 10 Apr 2014 09:43:13 +0200
Message-ID: <CA+BoTQkL8Vp_hjOP-=RZL97QXScF+WVX=BGf6d-HY8cQmu=WCQ@mail.gmail.com> (sfid-20140410_094320_024843_C74428AA)
Subject: Re: [RFTv2 3/5] ath10k: rework peer accounting
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	Ben Greear <greearb@candelatech.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10 April 2014 09:18, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>>>> +/* hold conf_mutex for simple iteration, or conf_mutex+data_lock for
>>>> + * modifications */
>>>>  struct ath10k_peer *ath10k_peer_find(struct ath10k *ar, int vdev_id,
>>>>                                    const u8 *addr)
>>>>  {
>>>>       struct ath10k_peer *peer;
>>>>
>>>> -     lockdep_assert_held(&ar->data_lock);
>>>> -
>>>>       list_for_each_entry(peer, &ar->peers, list) {
>>>>               if (peer->vdev_id != vdev_id)
>>>>                       continue;
>>>
>>> The comment here makes me suspicious. How can we safely iterate the list
>>> if we don't take data_lock? Doesn't it mean that the list can change
>>> while we have conf_mutex?
>>
>> The idea is you need BOTH locks to modify the list structure, but you
>> need only one of them to iterate over the list safely and
>> consistently. This means writer will not alter the list structure
>> until there are no readers.
>
> Still not understanding this. Why not then use conf_mutex always, why do
> we need data_lock at all?

htt peer map/unmap which is in tasklet context needs to iterate over
the list. It can't take conf_mutex.


> Or are you saying that one can iterate the list by either taking
> conf_mutex or by taking data_lock, depending on context?

Yes.


Michał
