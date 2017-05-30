Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33726 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750761AbdE3ThH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 May 2017 15:37:07 -0400
Message-ID: <1496173021.3327.15.camel@sipsolutions.net> (sfid-20170530_213744_067968_344979E2)
Subject: Re: [net-wireless-orinoco] question about potential null pointer
 dereference
From: Johannes Berg <johannes@sipsolutions.net>
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 30 May 2017 21:37:01 +0200
In-Reply-To: <20170530120032.Horde.GHW0X8-B795CdxPjQOfDPa9@gator4166.hostgator.com> (sfid-20170530_190112_685275_C191B893)
References: <20170530120032.Horde.GHW0X8-B795CdxPjQOfDPa9@gator4166.hostgator.com>
         (sfid-20170530_190112_685275_C191B893)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> The issue here is that line 56 implies that pointer tfm_michael
> might be NULL. If this is the case, there is a potential NULL
> pointer dereference at line 52 once pointer tfm_michael is
> indirectly dereferenced inside macro SHASH_DESC_ON_STACK().
> 
> My question is if there is any chance that pointer tfm_michael
> might be NULL when calling macro SHASH_DESC_ON_STACK() ?
> 
> I'm trying to figure out if this is a false positive or something
> that needs to be fixed somehow.

Look, if you're just sending the coverity reports to the list without
reflecting and researching them, that's not actually useful - we can
look at them ourselves.

It took me at most a few minutes to figure this one out, so please just
do the same, look at the code, and figure out what the right answer is
here.

johannes
