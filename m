Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:45016 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965239AbaDJHLP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2014 03:11:15 -0400
Received: by mail-we0-f172.google.com with SMTP id t61so3551625wes.3
        for <linux-wireless@vger.kernel.org>; Thu, 10 Apr 2014 00:11:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87k3axhdqc.fsf@kamboji.qca.qualcomm.com>
References: <1396611464-5940-1-git-send-email-michal.kazior@tieto.com>
	<1397040531-6224-1-git-send-email-michal.kazior@tieto.com>
	<1397040531-6224-4-git-send-email-michal.kazior@tieto.com>
	<87k3axhdqc.fsf@kamboji.qca.qualcomm.com>
Date: Thu, 10 Apr 2014 09:11:13 +0200
Message-ID: <CA+BoTQ=c+dTcK_diBKi6VJVgUkyBv21bDkRf+9GvGyhhqqMuNQ@mail.gmail.com> (sfid-20140410_091136_262994_6303F50E)
Subject: Re: [RFTv2 3/5] ath10k: rework peer accounting
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	Ben Greear <greearb@candelatech.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10 April 2014 08:59, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> It was troublesome to iterate over peers and
>> perform sleepable calls. This will be necessary
>> for some upcomming changes to tx flushing.
>>
>> Make peer allocation and initial setup
>> protected by both ar->conf_mutex and
>> ar->data_lock. This way it's possible to iterate
>> over peers with conf_mutex and call sleepable
>> functions.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> First comments, but I need to read this much more carefully still:
>
>> --- a/drivers/net/wireless/ath/ath10k/core.h
>> +++ b/drivers/net/wireless/ath/ath10k/core.h
>> @@ -199,9 +199,14 @@ struct ath10k_dfs_stats {
>>  #define ATH10K_MAX_NUM_PEER_IDS (1 << 11) /* htt rx_desc limit */
>>
>>  struct ath10k_peer {
>> +     /* protected by conf_mutex + data_lock */
>>       struct list_head list;
>
> This really needs a lot more documentation. And besides, don't we
> actually want to protect struct ath10k::peers, not this?

Parts of the structure needs to be locked differently.

I suppose we can say we just protect everything with data_lock except
`struct list_head list` which needs to be write-protected by both
conf_mutex and data_lock. But then again, addr and vdev_id don't need
any locking as they are immutable (and set before adding to the list).


>
>> +/* hold conf_mutex for simple iteration, or conf_mutex+data_lock for
>> + * modifications */
>>  struct ath10k_peer *ath10k_peer_find(struct ath10k *ar, int vdev_id,
>>                                    const u8 *addr)
>>  {
>>       struct ath10k_peer *peer;
>>
>> -     lockdep_assert_held(&ar->data_lock);
>> -
>>       list_for_each_entry(peer, &ar->peers, list) {
>>               if (peer->vdev_id != vdev_id)
>>                       continue;
>
> The comment here makes me suspicious. How can we safely iterate the list
> if we don't take data_lock? Doesn't it mean that the list can change
> while we have conf_mutex?

The idea is you need BOTH locks to modify the list structure, but you
need only one of them to iterate over the list safely and
consistently. This means writer will not alter the list structure
until there are no readers.


Michał
