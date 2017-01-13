Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49488 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751232AbdAMIdk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 03:33:40 -0500
Message-ID: <1484292252.19860.5.camel@sipsolutions.net> (sfid-20170113_093343_000392_210C8E44)
Subject: Re: [PATCH] ath10k: prevent sta pointer rcu violation
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        Ben Greear <greearb@candelatech.com>,
        Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Date: Fri, 13 Jan 2017 08:24:12 +0100
In-Reply-To: <CA+BoTQkgD5umVsGnRM4uu_8GO=KjQ6MuJCjQRnSHrDuQdU4z1w@mail.gmail.com> (sfid-20170112_171858_779498_B3B00B28)
References: <1484234070-7431-1-git-send-email-michal.kazior@tieto.com>
         <1484235986.19860.1.camel@sipsolutions.net>
         <CA+BoTQkgD5umVsGnRM4uu_8GO=KjQ6MuJCjQRnSHrDuQdU4z1w@mail.gmail.com>
         (sfid-20170112_171858_779498_B3B00B28)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Unless you then continue to use that sta pointer after you release
> data_lock.

Ouch, ok. That's rather strangely hidden though.

> Consider this:
> 
> >          CPU0             CPU1
> > 1   synchronize_net()
> > 2    drv_sta_state()
> > 3                      htt_fetch_ind(pid,tid) called
> > 4                      rcu_read_lock()
> > 5                      get(data_lock)
> > 6                      txq=peers[pid]->sta->txq[tid]
> > 7                      put(data_lock)
> > 8    get(data_lock)
> > 9     peer->sta=0
> > 10   put(data_lock)
> > 11     kfree(sta)
> > 12                     ieee80211_tx_dequeue(txq)
> 
> Even though there's no code like (9) per se you can think of it as
> anything that tries to "remove" the peer--sta association
> (ath10k_peer
> is removed implicitly via wmi peer delete command and waiting for htt
> event completion).
> 
> Holding data_lock for the entire duration of handling fetch
> indication isn't really good for performance so it's better to fix
> RCU handling.

Yeah, I see it now - also the comment where this happens. You probably
should mark some things __rcu though and actually use RCU primitives,
so the code is actually understandable :)

johannes
