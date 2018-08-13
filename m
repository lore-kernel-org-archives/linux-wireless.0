Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:53766 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729029AbeHMVJT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Aug 2018 17:09:19 -0400
Received: by mail-wm0-f65.google.com with SMTP id s9-v6so9824739wmh.3
        for <linux-wireless@vger.kernel.org>; Mon, 13 Aug 2018 11:25:57 -0700 (PDT)
Subject: Re: [PATCH] mac80211: Run TXQ teardown code before de-registering
 interfaces
To: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        linux-wireless@vger.kernel.org
References: <20180813121625.18367-1-toke@toke.dk>
Cc: Ben Greear <greearb@candelatech.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5B71CD33.7020700@broadcom.com> (sfid-20180813_202600_825272_AD143BA9)
Date: Mon, 13 Aug 2018 20:25:55 +0200
MIME-Version: 1.0
In-Reply-To: <20180813121625.18367-1-toke@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/13/2018 2:16 PM, Toke Høiland-Jørgensen wrote:
> The TXQ teardown code can reference the vif data structures that are
> stored in the netdev private memory area if there are still packets on
> the queue when it is being freed. Since the TXQ teardown code is run
> after the netdevs are freed, this can lead to a use-after-free. Fix this
> by moving the TXQ teardown code to earlier in ieee80211_unregister_hw().

Just off the bat, but from reading the above I am wondering whether the 
use-after-free could also happen upon removing an interface?

Regards,
Arend

> Reported-by: Ben Greear <greearb@candelatech.com>
> Tested-by: Ben Greear <greearb@candelatech.com>
> Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
> ---
>   net/mac80211/main.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
