Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:47784 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751976AbeBAWrI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Feb 2018 17:47:08 -0500
Message-ID: <1517525226.28814.15.camel@sipsolutions.net> (sfid-20180201_234712_674970_7776BD7E)
Subject: Re: lockdep warning in mac80211/tx.c, 4.13.16+ kernel, ath9k related
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 01 Feb 2018 23:47:06 +0100
In-Reply-To: <1517524837.28814.14.camel@sipsolutions.net> (sfid-20180201_234043_361624_199087E3)
References: <d4632910-7dd9-b066-0c10-b21dd7cbfc61@candelatech.com>
         <1517523817.28814.10.camel@sipsolutions.net>
         <e8f8b910-ffa8-fbc7-3152-58ccf70b1ace@candelatech.com>
         <1517524837.28814.14.camel@sipsolutions.net>
         (sfid-20180201_234043_361624_199087E3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-02-01 at 23:40 +0100, Johannes Berg wrote:
> 
> The code does a plain rcu_dereference(), no locking other than
> rcu_read_lock() involved.
> 
> On second thought though, I'm not convinced that your modifications
> caused the problem.
> 
> Given your call stack, we'd expect rcu_read_lock() somewhere around
> ath_tid_dequeue (or its caller(s)), since ieee80211_tx_dequeue clearly
> requires it.
> 
> Normally, ieee80211_tx_dequeue() is called from various places that
> probably come from mac80211 and already hold the rcu_read_lock(), e.g.
> the wake_tx_queue op.
> 
> In this case, you're coming from drv_sta_state, so not sure why the
> driver thinks it's OK to call the dequeue there.

Just to clarify - it could just be that in the "normal" case, when a
station dies, there's nothing on the queues - so the dequeue just
doesn't do anything and never goes into the code path where the
rcu_dereference() is, hence it might be a bug in mainline that just
never triggers in ordinary scenarios.

johannes
