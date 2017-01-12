Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f181.google.com ([209.85.220.181]:33897 "EHLO
        mail-qk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750730AbdALQS6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Jan 2017 11:18:58 -0500
Received: by mail-qk0-f181.google.com with SMTP id a20so25625018qkc.1
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jan 2017 08:18:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1484235986.19860.1.camel@sipsolutions.net>
References: <1484234070-7431-1-git-send-email-michal.kazior@tieto.com> <1484235986.19860.1.camel@sipsolutions.net>
From: Michal Kazior <michal.kazior@tieto.com>
Date: Thu, 12 Jan 2017 17:18:57 +0100
Message-ID: <CA+BoTQkgD5umVsGnRM4uu_8GO=KjQ6MuJCjQRnSHrDuQdU4z1w@mail.gmail.com> (sfid-20170112_171902_090833_571D0FD0)
Subject: Re: [PATCH] ath10k: prevent sta pointer rcu violation
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        Ben Greear <greearb@candelatech.com>,
        Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12 January 2017 at 16:46, Johannes Berg <johannes@sipsolutions.net> wrot=
e:
> On Thu, 2017-01-12 at 16:14 +0100, Michal Kazior wrote:
>> Station pointers are RCU protected so driver must
>> be extra careful if it tries to store them
>> internally for later use outside of the RCU
>> section it obtained it in.
>>
>> It was possible for station teardown to race with
>> some htt events. The possible outcome could be a
>> use-after-free and a crash.
>>
>> Only peer-flow-control capable firmware was
>> affected (so hardware-wise qca99x0 and qca4019).
>>
>> This could be done in sta_state() itself via
>> explicit synchronize_net() call but there's
>> already a convenient sta_pre_rcu_remove() op that
>> can be hooked up to avoid extra rcu stall.
>
> I don't think this makes sense. You're not using RCU-protected pointers
> to the stations yourself, all accesses to them are locked under the
> &ar->data_lock. As a consequence, you can't have any need for waiting
> for a grace period. Since you also remove the pointer (under lock) when
> the station gets removed, I don't think RCU can be the problem?

Unless you then continue to use that sta pointer after you release
data_lock. Consider this:

>          CPU0             CPU1
> 1   synchronize_net()
> 2    drv_sta_state()
> 3                      htt_fetch_ind(pid,tid) called
> 4                      rcu_read_lock()
> 5                      get(data_lock)
> 6                      txq=3Dpeers[pid]->sta->txq[tid]
> 7                      put(data_lock)
> 8    get(data_lock)
> 9     peer->sta=3D0
> 10   put(data_lock)
> 11     kfree(sta)
> 12                     ieee80211_tx_dequeue(txq)

Even though there's no code like (9) per se you can think of it as
anything that tries to "remove" the peer--sta association (ath10k_peer
is removed implicitly via wmi peer delete command and waiting for htt
event completion).

Holding data_lock for the entire duration of handling fetch indication
isn't really good for performance so it's better to fix RCU handling.


Micha=C5=82
