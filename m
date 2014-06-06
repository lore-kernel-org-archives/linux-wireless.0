Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:52122 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbaFFIMn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jun 2014 04:12:43 -0400
Received: by mail-we0-f173.google.com with SMTP id u57so2431915wes.32
        for <linux-wireless@vger.kernel.org>; Fri, 06 Jun 2014 01:12:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1402041842.2004.24.camel@dubbel>
References: <1401985567-27336-3-git-send-email-emmanuel.grumbach@intel.com>
	<CA+BoTQn7H7808DFhAmfBtNsO+o0CEsy3_=4QMnxU4eML7JUCQQ@mail.gmail.com>
	<1402036258.2004.10.camel@dubbel>
	<CA+BoTQ=wZV8dviGE8HAFC1j=XNqJDkxUaHV5HFkiLMs2arCVHQ@mail.gmail.com>
	<1402040251.2004.20.camel@dubbel>
	<CA+BoTQ=X9Vg+=PvdRuFTcL+1hA6Yg6Vne3_NfBx_A6yS91b0PA@mail.gmail.com>
	<1402041842.2004.24.camel@dubbel>
Date: Fri, 6 Jun 2014 10:12:42 +0200
Message-ID: <CA+BoTQnKmJONd3Rp5MjKRPrRxs8DagA4p3Ww2VTEwYA6U1ogVQ@mail.gmail.com> (sfid-20140606_101251_014423_CFB342C6)
Subject: Re: [PATCH 3/3] mac80211: stop only the queues assigned to the vif
 during channel switch
From: Michal Kazior <michal.kazior@tieto.com>
To: "Coelho, Luciano" <luciano.coelho@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6 June 2014 10:04, Coelho, Luciano <luciano.coelho@intel.com> wrote:
> On Fri, 2014-06-06 at 09:56 +0200, Michal Kazior wrote:
>> On 6 June 2014 09:37, Coelho, Luciano <luciano.coelho@intel.com> wrote:
[...]
>> > static u32 ieee80211_vif_queues_to_wake(struct ieee80211_local *local,
>> >                                         struct ieee80211_sub_if_data *sdata,
>> >                                         enum queue_stop_reason reason)
>> > {
>> >         struct ieee80211_sub_if_data *sdata_iter;
>> >         unsigned long queues, queues_iter, q;
>> >         int i;
>> >
>> >         lockdep_assert_held(&local->mtx);
>> >
>> >         queues = ieee80211_get_vif_queues(local, sdata);
>> >
>> >         rcu_read_lock();
>> >         list_for_each_entry_rcu(sdata_iter, &local->interfaces, list) {
>> >                 if (!ieee80211_sdata_running(sdata_iter))
>> >                         continue;

Hmm, actually, shouldn't we `if (sdata == sdata_iter) continue`?
Otherwise you'll never wake queues, will you?


>> >                 queues_iter = ieee80211_get_vif_queues(local, sdata_iter);
>> >                 for_each_set_bit(i, &queues_iter, local->hw.queues) {
>> >                         q = sdata->vif.hw_queue[i];
>> >
>> >                         if (test_bit(reason, &local->queue_stop_reasons[q]))
>> >                                 queues &= ~q;
>> >                 }
>> >         }
>> >         rcu_read_unlock();
>> >
>> >         return queues;
>> > }
>> >
>> > void ieee80211_wake_vif_queues(struct ieee80211_local *local,
>> >                                struct ieee80211_sub_if_data *sdata,
>> >                                enum queue_stop_reason reason)
>> > {
>> >         unsigned int queues = ieee80211_vif_queues_to_wake(local, sdata, reason);
>> >
>> >         ieee80211_wake_queues_by_reason(&local->hw, queues, reason);
>> > }
>>
>> Once you set local->queue_stop_reasons[] for an overlapping queue you
>> won't be able to wake it with ieee80211_wake_vif_queues() alone.
>> You'll need to call ieee80211_wake_queues() to do that. Is that what
>> you intended?
>
> More or less.  My idea is that only the *last* vif that tries to wake
> the overlapping queue, will actually do so.

So ieee80211_wake_vif_queues() would be called regardless of the
ieee80211_csa_needs_block_tx() and ieee80211_wake_queues() is called
like it was before (i.e. when all block_tx interfaces are done).


Michał
