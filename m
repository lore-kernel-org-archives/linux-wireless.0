Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:36391 "EHLO
        mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751157AbdAMIdE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 03:33:04 -0500
Received: by mail-qk0-f178.google.com with SMTP id 11so46997876qkl.3
        for <linux-wireless@vger.kernel.org>; Fri, 13 Jan 2017 00:32:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1484292252.19860.5.camel@sipsolutions.net>
References: <1484234070-7431-1-git-send-email-michal.kazior@tieto.com>
 <1484235986.19860.1.camel@sipsolutions.net> <CA+BoTQkgD5umVsGnRM4uu_8GO=KjQ6MuJCjQRnSHrDuQdU4z1w@mail.gmail.com>
 <1484292252.19860.5.camel@sipsolutions.net>
From: Michal Kazior <michal.kazior@tieto.com>
Date: Fri, 13 Jan 2017 09:32:11 +0100
Message-ID: <CA+BoTQmiJiLGQTNHxHA3vAHLJkRdZ=vZm-R9M8aQMUebv_Zwvw@mail.gmail.com> (sfid-20170113_093314_492244_3353665E)
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

On 13 January 2017 at 08:24, Johannes Berg <johannes@sipsolutions.net> wrot=
e:
>
>> Unless you then continue to use that sta pointer after you release
>> data_lock.
>
> Ouch, ok. That's rather strangely hidden though.
>
>> Consider this:
>>
>> >          CPU0             CPU1
>> > 1   synchronize_net()
>> > 2    drv_sta_state()
>> > 3                      htt_fetch_ind(pid,tid) called
>> > 4                      rcu_read_lock()
>> > 5                      get(data_lock)
>> > 6                      txq=3Dpeers[pid]->sta->txq[tid]
>> > 7                      put(data_lock)
>> > 8    get(data_lock)
>> > 9     peer->sta=3D0
>> > 10   put(data_lock)
>> > 11     kfree(sta)
>> > 12                     ieee80211_tx_dequeue(txq)
>>
>> Even though there's no code like (9) per se you can think of it as
>> anything that tries to "remove" the peer--sta association
>> (ath10k_peer
>> is removed implicitly via wmi peer delete command and waiting for htt
>> event completion).
>>
>> Holding data_lock for the entire duration of handling fetch
>> indication isn't really good for performance so it's better to fix
>> RCU handling.
>
> Yeah, I see it now - also the comment where this happens. You probably
> should mark some things __rcu though and actually use RCU primitives,
> so the code is actually understandable :)

Good point. I'll do that in another patch.


Micha=C5=82
