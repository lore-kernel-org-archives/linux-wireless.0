Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:1222 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081AbYKQSM6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2008 13:12:58 -0500
Received: by wf-out-1314.google.com with SMTP id 27so2726891wfd.4
        for <linux-wireless@vger.kernel.org>; Mon, 17 Nov 2008 10:12:57 -0800 (PST)
Message-ID: <1ba2fa240811171012je2d5215hc9b3ea870468f4f8@mail.gmail.com> (sfid-20081117_191304_306814_686D59EA)
Date: Mon, 17 Nov 2008 20:12:57 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC] mac80211: remove ieee80211_notify_mac
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John Linville" <linville@tuxdriver.com>
In-Reply-To: <1226944799.3902.52.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1226915999.3599.33.camel@johannes.berg>
	 <1ba2fa240811170632s49c38320y18da189bf2432d54@mail.gmail.com>
	 <1226933141.3902.19.camel@johannes.berg>
	 <1ba2fa240811170714j7d0daf5xe718ffa1d4de8f40@mail.gmail.com>
	 <1226942887.3902.30.camel@johannes.berg>
	 <1ba2fa240811170934u34fa6e28m1411715690fd24b9@mail.gmail.com>
	 <1226944799.3902.52.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 17, 2008 at 7:59 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2008-11-17 at 19:34 +0200, Tomas Winkler wrote:
>
>> There actually complains about slow reconnection,
>
> Ok I guess then I haven't seen them for some reason.
>
> Either way, here's a quick summary:
>  * locking issues with the callback are fixed by removing it
>  * callback is incorrect when you're only suspended for a very short
>   time
>  * callback is incorrect when you're in non-STA modes
>  * suspend/resume cannot be implemented well through this callback, at
>   least not the way it is written now and needs to do a whole lot more
>  * there's no "slow" issue when you actually resume in a different
>   location where the AP is not around any more
>  * there should be no "slow" issue when the AP properly deauthenticates
>   when receiving data frames
>
> This was an RFC. I'm convinced it should go in, but I don't make those
> decisions anyway. I've outlined my reasons for it.

My concern is what is immediate impact of this. Whether we fix mac
notify for short term
and we'll remove it when resume/suspend is available or we have
suspend/resume worked out in 2h.

>
>> Second we used the
>> same mechanism to
>> recover from rfkill which wasn't submitted. rfkill needs also mac80211
>> treatment.
>
> Sure does, and I've even described how I'd do it in some email. Seems
> nobody actually cares enough though to invest the day or two it would
> take to write it. And I don't care about killswitches at all,
> fortunately, so I don't need to touch that mess.

I've posted something based on plugging into notification chain. It
worked but wasn't accepted I hoped that who rejected will supply
alternative solution...

Tomas


> johannes
>
