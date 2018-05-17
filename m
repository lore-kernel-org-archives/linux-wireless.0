Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:60112 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751061AbeEQT3I (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 May 2018 15:29:08 -0400
Message-ID: <1526585345.5351.3.camel@sipsolutions.net> (sfid-20180517_212915_154980_0C1E1F0E)
Subject: Re: [PATCH] nl80211: fix nlmsg allocation in cfg80211_ft_event
From: Johannes Berg <johannes@sipsolutions.net>
To: Jeff Johnson <jjohnson@codeaurora.org>,
        Dedy Lansky <dlansky@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        linux-wireless-owner@vger.kernel.org
Date: Thu, 17 May 2018 21:29:05 +0200
In-Reply-To: <a19275473776283a94997b8f5436f3b9@codeaurora.org> (sfid-20180517_204322_111043_9C68DA25)
References: <000901d3ede2$78a3aa20$69eafe60$@codeaurora.org>
         <a19275473776283a94997b8f5436f3b9@codeaurora.org>
         (sfid-20180517_204322_111043_9C68DA25)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-05-17 at 11:43 -0700, Jeff Johnson wrote:
> 
> > -	msg = nlmsg_new(100 + ft_event->ric_ies_len, GFP_KERNEL);
> > +	msg = nlmsg_new(100 + ft_event->ies_len + ft_event->ric_ies_len,
> > +			GFP_KERNEL);
> >  	if (!msg)
> >  		return;
> 
> should these really be nla_total_size(ft_event->ies_len) + 
> nla_total_size(ft_event->ric_ies_len) to properly account for the NLA 
> header + padding? or do we consider that to be noise captured by the 
> "100"?

We do, technically we should have something like nla_total_size() of
various things including all those wiphy, ifindex, MAC attributes etc.
so we just get lazy...

johannes
