Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52740 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751892AbcKPMGY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Nov 2016 07:06:24 -0500
Date: Wed, 16 Nov 2016 13:02:13 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Mathias Kresin <dev@kresin.me>
Cc: linux-wireless@vger.kernel.org,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH 05/10] rt2800: make ba_size depend on ampdu_factor
Message-ID: <20161116120213.GB26475@redhat.com> (sfid-20161116_130627_692932_976D25F1)
References: <1478095865-8651-1-git-send-email-sgruszka@redhat.com>
 <1478095865-8651-6-git-send-email-sgruszka@redhat.com>
 <ebc4779b-a68b-f3b3-c8fc-87db9401a603@kresin.me>
 <20161114084536.GB12372@redhat.com>
 <20161114124323.GA31857@redhat.com>
 <e4dfaa30-7dd6-c485-3e30-71bfafbc1502@kresin.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <e4dfaa30-7dd6-c485-3e30-71bfafbc1502@kresin.me>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 16, 2016 at 09:07:00AM +0100, Mathias Kresin wrote:
> Here are the results of the requested tests. Please keep in mind, I'm not in
> a lab environment:
> 
> LEDE head
>   connect
>     action 0 sta 9c:f3:87:bc:AA:BB tid 6 buf_size 64 ampdu_factor 3
>     action 2 sta 9c:f3:87:bc:AA:BB tid 0 buf_size 0 ampdu_factor 3
>     action 6 sta 9c:f3:87:bc:AA:BB tid 0 buf_size 64 ampdu_factor 3
>     action 0 sta 9c:f3:87:bc:AA:BB tid 0 buf_size 64 ampdu_factor 3

No problem here - buf_size corresponds to ampdu_factor.

>     ieee80211 phy0: rt2x00queue_flush_queue: Warning - Queue 2 failed
>                     to flush
>     ieee80211 phy0: rt2x00queue_flush_queue: Warning - Queue 2 failed
>                     to flush

I think we do not give device enough time to post AMPDU consisted
with bigger amount of frames. If we want to increase ba_size we will
need also some other changes in the driver. Anyway I already request
Kalle to drop this patch. I assume other patches do not cause
regression for you, correct? 

Thanks for testing.
Stanislaw
