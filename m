Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:44931 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751280AbeEQXrP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 May 2018 19:47:15 -0400
Received: by mail-lf0-f68.google.com with SMTP id h197-v6so11231176lfg.11
        for <linux-wireless@vger.kernel.org>; Thu, 17 May 2018 16:47:14 -0700 (PDT)
Date: Fri, 18 May 2018 01:47:11 +0200
From: Niklas Cassel <niklas.cassel@linaro.org>
To: Erik Stromdahl <erik.stromdahl@gmail.com>
Cc: johannes@sipsolutions.net, kvalo@qca.qualcomm.com, toke@toke.dk,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: ath10k wake_tx_queue issues
Message-ID: <20180517234711.GA13270@localhost.localdomain> (sfid-20180518_014732_726218_A72DE906)
References: <20180515134516.GA30397@localhost.localdomain>
 <6b81aa2e-09a3-ae48-7626-8ceb33a2a6b5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <6b81aa2e-09a3-ae48-7626-8ceb33a2a6b5@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 16, 2018 at 07:28:21PM +0200, Erik Stromdahl wrote:
> Hello Niklas
> 
> Quick question:
> Are you using my patch: "ath10k: add htt_tx num_pending window"?

Nope, but I definitely think that your patch should be merged,
since the current code can lock/unlock/lock a lot of times for
no good reason.

(I actually tried it, but I could still reproduce the bug with it.)

> 
> I assume (from your logs below) that you are not...
> 

Thanks a lot for you suggestions Erik!

Increasing max_num_pending might be a good idea (perhaps we will
get better thoughput in the SDIO case).

However, increasing either max_num_pending or
HTC_HOST_MAX_MSG_PER_TX_BUNDLE would probably just move the problem,
since it would still be possible for us to get hit by the same problem
again in the future.

I actually took Toke's suggestion and cooked up a patch:
https://marc.info/?l=linux-kernel&m=152659902128543&w=2


Kind regards,
Niklas
