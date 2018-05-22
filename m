Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:51694 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750707AbeEVJAT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 May 2018 05:00:19 -0400
Message-ID: <1526979617.6787.12.camel@sipsolutions.net> (sfid-20180522_110023_099437_0B4AB757)
Subject: Re: [PATCH] nl80211: fix nlmsg allocation in cfg80211_ft_event
From: Johannes Berg <johannes@sipsolutions.net>
To: Dedy Lansky <dlansky@codeaurora.org>,
        'Jeff Johnson' <jjohnson@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        linux-wireless-owner@vger.kernel.org
Date: Tue, 22 May 2018 11:00:17 +0200
In-Reply-To: <001201d3f0d4$93258900$b9709b00$@codeaurora.org>
References: <000901d3ede2$78a3aa20$69eafe60$@codeaurora.org>
                 <a19275473776283a94997b8f5436f3b9@codeaurora.org>
                 (sfid-20180517_204322_111043_9C68DA25) <1526585345.5351.3.camel@sipsolutions.net>
         <001201d3f0d4$93258900$b9709b00$@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-05-21 at 10:23 +0300, Dedy Lansky wrote:
> > We do, technically we should have something like nla_total_size() of various things including all those wiphy, ifindex, MAC attributes etc.
> > so we just get lazy...
> 
> nla_total_size is currently not used in nl80211.c (actually not used
> in net\wireless\ for that matters).

Like I said, we're lazy ;-)

> IMO, switching nl80211/cfg80211 to use nla_total_size should be done
> separately.

I don't see much value in doing it at all, TBH.

johannes
