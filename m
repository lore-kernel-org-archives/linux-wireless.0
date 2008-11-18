Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37810 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbYKRUBL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Nov 2008 15:01:11 -0500
Date: Tue, 18 Nov 2008 14:46:52 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Tomas Winkler <tomasw@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] mac80211: remove ieee80211_notify_mac
Message-ID: <20081118194652.GD21772@tuxdriver.com> (sfid-20081118_210116_728123_1EABF436)
References: <1226915999.3599.33.camel@johannes.berg> <1ba2fa240811170632s49c38320y18da189bf2432d54@mail.gmail.com> <1226933141.3902.19.camel@johannes.berg> <1ba2fa240811170714j7d0daf5xe718ffa1d4de8f40@mail.gmail.com> <1226942887.3902.30.camel@johannes.berg> <1ba2fa240811170934u34fa6e28m1411715690fd24b9@mail.gmail.com> <1226944799.3902.52.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1226944799.3902.52.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 17, 2008 at 06:59:59PM +0100, Johannes Berg wrote:
> On Mon, 2008-11-17 at 19:34 +0200, Tomas Winkler wrote:
> 
> > There actually complains about slow reconnection, 
> 
> Ok I guess then I haven't seen them for some reason.
> 
> Either way, here's a quick summary:
>  * locking issues with the callback are fixed by removing it
>  * callback is incorrect when you're only suspended for a very short
>    time
>  * callback is incorrect when you're in non-STA modes
>  * suspend/resume cannot be implemented well through this callback, at
>    least not the way it is written now and needs to do a whole lot more
>  * there's no "slow" issue when you actually resume in a different
>    location where the AP is not around any more
>  * there should be no "slow" issue when the AP properly deauthenticates
>    when receiving data frames
> 
> This was an RFC. I'm convinced it should go in, but I don't make those
> decisions anyway. I've outlined my reasons for it.

I agree that it seems to solve problems, and there is little benefit
tokeeping the callback in question.  I'm going to send this upstream.

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
