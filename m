Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36402 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751367AbdB0NVI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Feb 2017 08:21:08 -0500
Message-ID: <1488201577.28431.3.camel@sipsolutions.net> (sfid-20170227_142113_283703_A672EF13)
Subject: Re: [PATCH v2] mac80211:  allow overriding station bandwidth.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com, linux-wireless@vger.kernel.org
Date: Mon, 27 Feb 2017 14:19:37 +0100
In-Reply-To: <1487207794-19663-1-git-send-email-greearb@candelatech.com> (sfid-20170216_021641_438391_8E454871)
References: <1487207794-19663-1-git-send-email-greearb@candelatech.com>
         (sfid-20170216_021641_438391_8E454871)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-02-15 at 17:16 -0800, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> This allows one to disable VHT160 (or 80+80) on hardware
> that might otherwise try to use it.

I just decided against applying this now because of the changing VHT
extended NSS BW stuff. This would in that case not actually override
the 160/80+80 capability, which would probably actually be the right
thing given how this works (mask & shift stuff), but without also
allowing to override the *new* things you'd not actually gain the
ability to get rid of 160/80+80... so overall I think right now that's
just confusing things even more.

johannes
