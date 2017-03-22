Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:45388 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752690AbdCVWjQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Mar 2017 18:39:16 -0400
Date: Wed, 22 Mar 2017 15:39:15 -0700 (PDT)
Message-Id: <20170322.153915.842535433384366274.davem@davemloft.net> (sfid-20170322_233941_266414_FEC5B89A)
To: sgruszka@redhat.com
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        xose.vazquez@gmail.com, Larry.Finger@lwfinger.net,
        johannes@sipsolutions.net
Subject: Re: [PATCH 4.11] genetlink: fix counting regression on
 ctrl_dumpfamily()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1490195313-13272-1-git-send-email-sgruszka@redhat.com>
References: <1490195313-13272-1-git-send-email-sgruszka@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <sgruszka@redhat.com>
Date: Wed, 22 Mar 2017 16:08:33 +0100

> Commit 2ae0f17df1cd ("genetlink: use idr to track families") replaced
> 
> 	if (++n < fams_to_skip)
> 		continue;
> into:
> 
> 	if (n++ < fams_to_skip)
> 		continue;
> 
> This subtle change cause that on retry ctrl_dumpfamily() call we omit
> one family that failed to do ctrl_fill_info() on previous call, because
> cb->args[0] = n number counts also family that failed to do
> ctrl_fill_info().
> 
> Patch fixes the problem and avoid confusion in the future just decrease
> n counter when ctrl_fill_info() fail.
> 
> User visible problem caused by this bug is failure to get access to
> some genetlink family i.e. nl80211. However problem is reproducible
> only if number of registered genetlink families is big enough to
> cause second call of ctrl_dumpfamily().
> 
> Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>
> Cc: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Fixes: 2ae0f17df1cd ("genetlink: use idr to track families")
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Applied and queued up for -stable, thanks.
