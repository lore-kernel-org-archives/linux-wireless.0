Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:41031 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729891AbeHMVYx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Aug 2018 17:24:53 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: Re: [PATCH] mac80211: Run TXQ teardown code before de-registering interfaces
In-Reply-To: <5B71CD33.7020700@broadcom.com>
References: <20180813121625.18367-1-toke@toke.dk> <5B71CD33.7020700@broadcom.com>
Date: Mon, 13 Aug 2018 20:41:27 +0200
Message-ID: <87tvnycdns.fsf@toke.dk> (sfid-20180813_204154_319916_035FFEF8)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

> On 8/13/2018 2:16 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> The TXQ teardown code can reference the vif data structures that are
>> stored in the netdev private memory area if there are still packets on
>> the queue when it is being freed. Since the TXQ teardown code is run
>> after the netdevs are freed, this can lead to a use-after-free. Fix this
>> by moving the TXQ teardown code to earlier in ieee80211_unregister_hw().
>
> Just off the bat, but from reading the above I am wondering whether
> the use-after-free could also happen upon removing an interface?

Hmm, there doesn't appear to be *any* teardown of TXQs when an interface
is removed...? So I guess that if an interface is removed while it still
has frames on the multicast TXQ, that those packets would be left
hanging there? I don't think there would be an explicit use-after-free,
because they will never get dequeued, so they would just constitute a
memory leak?

Am I missing some automatic mechanism that always empties out queues
before an interface is brought down?

-Toke
