Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48214 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752445AbaEWNOv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 09:14:51 -0400
Message-ID: <1400850877.4358.38.camel@jlt4.sipsolutions.net> (sfid-20140523_151505_039274_4B004C61)
Subject: Re: [PATCH v6 2/6] mac80211: implement multi-vif in-place
 reservations
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luca Coelho <luca@coelho.fi>
Date: Fri, 23 May 2014 15:14:37 +0200
In-Reply-To: <CA+BoTQ=gjJw1e2osxuemxK1M+bLQpFQKUD9qozOm5frbLiXB5Q@mail.gmail.com> (sfid-20140523_142344_776623_02D08AE8)
References: <1400767676-15994-1-git-send-email-michal.kazior@tieto.com>
	 <1400767676-15994-3-git-send-email-michal.kazior@tieto.com>
	 <1400770304.4174.34.camel@jlt4.sipsolutions.net>
	 <CA+BoTQk3stQoK34q6VcXhHm8+9Rh67UF4TTfgy5P1JY1o1dTFA@mail.gmail.com>
	 <CA+BoTQ=gjJw1e2osxuemxK1M+bLQpFQKUD9qozOm5frbLiXB5Q@mail.gmail.com>
	 (sfid-20140523_142344_776623_02D08AE8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-05-23 at 14:23 +0200, Michal Kazior wrote:

> Actually I think I've just spotted a little problem. This is also
> related to the `[PATCH v6 6/6] cfg80211: remove channel_switch
> combination check` thread.
> 
> Currently mac80211 verifies interface combinations in channel_switch.
> It has an implicit assumption that channel switch does not change the
> number of different channels (or at least it doesn't decrease it).
> 
> We were discussing degradation of number of different channels
> earlier, e.g. due to non-radar -> radar change (going from max 2
> channels to 1). With how things are now it's impossible to perform
> such a channel switch.

Good point.

> Basically if we want to support this kind of channel switch we must
> remove interface combination checks from ieee80211_channel_switch
> because it's simply impossible to know the future (userspace may or
> may not submit subsequent requests to match an existing interface
> combination).

I guess this is a side effect of not having all the channel switches in
the API in a single call, which I think you had originally? :-)

> So while I still intend to rework the multi-vif reservation a little
> (to support cross-swapping at least) I'd like to know if I should
> invest my time implementing degradation of number of channels in
> multi-vif reservation or not.

It doesn't matter to me. If you don't need the feature now, don't
implement it now. It's not like it restricts the API (much) making
future implementation difficult.

johannes

