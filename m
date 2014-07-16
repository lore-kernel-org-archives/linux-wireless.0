Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:40652 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932770AbaGPMl3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jul 2014 08:41:29 -0400
Received: by mail-wi0-f179.google.com with SMTP id f8so1251891wiw.6
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jul 2014 05:41:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+BoTQn8TYX4vDx=K4P5rE+LBXrrUL2q1E7GsiOpBj82QgRKsw@mail.gmail.com>
References: <1405505855-13741-1-git-send-email-michal.kazior@tieto.com>
	<1405509540-32691-1-git-send-email-michal.kazior@tieto.com>
	<53C66422.10702@gmail.com>
	<CA+BoTQn8TYX4vDx=K4P5rE+LBXrrUL2q1E7GsiOpBj82QgRKsw@mail.gmail.com>
Date: Wed, 16 Jul 2014 14:41:27 +0200
Message-ID: <CA+BoTQkk5oYS4JZ5a6W02rZ62AgxcHE76knS7QA2VfZDxYi2Jg@mail.gmail.com> (sfid-20140716_144133_189682_65BEE4CE)
Subject: Re: [PATCH v3] ath10k: fix Rx aggregation reordering
From: Michal Kazior <michal.kazior@tieto.com>
To: Varka Bhadram <varkabhadram@gmail.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Denton Gentry <denton.gentry@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16 July 2014 14:35, Michal Kazior <michal.kazior@tieto.com> wrote:
> On 16 July 2014 13:38, Varka Bhadram <varkabhadram@gmail.com> wrote:
>> On 07/16/2014 04:49 PM, Michal Kazior wrote:
>>
>> (...)
>>
>>
>>> +static void ath10k_htt_rx_addba(struct ath10k *ar, struct htt_resp *resp)
>>> +{
>>> +       struct htt_rx_addba *ev = &resp->rx_addba;
>>> +       struct ath10k_peer *peer;
>>> +       struct ath10k_vif *arvif;
>>> +       u16 info0, tid, peer_id;
>>> +
>>> +       info0 = __le32_to_cpu(ev->info0);
>>> +       tid = MS(info0, HTT_RX_BA_INFO0_TID);
>>> +       peer_id = MS(info0, HTT_RX_BA_INFO0_PEER_ID);
>>> +
>>> +       ath10k_dbg(ATH10K_DBG_HTT,
>>> +                  "htt rx addba tid %hu peer_id %hu size %hhu\n",
>>> +                  tid, peer_id, ev->window_size);
>>> +
>>> +       spin_lock_bh(&ar->data_lock);
>>> +       peer = ath10k_peer_find_by_id(ar, peer_id);
>>> +       if (!peer) {
>>> +               ath10k_warn("received addba event for invalid peer_id:
>>> %hu\n",
>>> +                           peer_id);
>>> +               spin_unlock_bh(&ar->data_lock);
>>> +               return;
>>> +       }
>>
>>
>> Here my concern in amount of time holding the lock...
>>
>> spin_lock_bh(&ar->data_lock);
>> peer = ath10k_peer_find_by_id(ar, peer_id);
>> if (!peer) {
>>         spin_unlock_bh(&ar->data_lock);
>>
>>         ath10k_warn("received addba event for invalid peer_id: %hu\n",
>>                     peer_id);
>>         return;
>> }
>>
>> No need to of putting the debug message inside the critical region...  :-)
>
> Sounds reasonable in this case as I'm not printing spinlock-protected values.

..and I realized this isn't true upon hitting the send button.

The other print uses peer->vdev_id. The peer was acquired under a lock
and must not be used after the lock is released. It'll just look
confusing if I mix ordering of unlock/print in some cases so I'll
leave it as is.

(sorry for the noise)


Michał
