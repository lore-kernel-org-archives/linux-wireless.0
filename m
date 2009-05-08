Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.231]:2916 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbZEHUYv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2009 16:24:51 -0400
Received: by rv-out-0506.google.com with SMTP id f9so1305539rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 08 May 2009 13:24:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1241698981.27208.8.camel@johannes.local>
References: <1241698981.27208.8.camel@johannes.local>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 8 May 2009 13:24:31 -0700
Message-ID: <43e72e890905081324k71de0dbbw998e506521b2f721@mail.gmail.com>
Subject: Re: [PATCH] mac80211: fix scan channel race
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	Pavel Roskin <proski@gnu.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 7, 2009 at 5:23 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> When a software scan starts, it first sets sw_scanning, but
> leaves the scan_channel "unset" (it currently actually gets
> initialised to a default). Now, when something else tries
> to (re)configure the hardware in the window between these two
> events (after sw_scanning = true, but before scan_channel is
> set), the current code switches to the (unset!) scan_channel.
> This causes trouble, especially when switching bands and
> sending frames on the wrong channel.
>
> To work around this, leave scan_channel initialised to NULL
> and use it to determine whether or not a switch to a different
> channel should occur (and also use the same condition to check
> whether to adjust power for scan or not).
>
> Additionally, avoid reconfiguring the hardware completely when
> recalculating idle resulted in no changes, this was the problem
> that originally led us to discover the race condition in the
> first place, which was helpfully bisected by Pavel. This part
> of the patch should not be necessary with the other fixes, but
> not calling the ieee80211_hw_config function when we know it to
> be unnecessary is certainly a correct thing to do.
>
> Unfortunately, this patch cannot and does not fix the race
> condition completely, but due to the way the scan code is
> structured it makes the particular problem Pavel discovered
> (race while changing channel at the same time as transmitting
> frames) go away. To fix it completely, more work especially
> with locking configuration is needed.
>
> Bisected-by: Pavel Roskin <proski@gnu.org>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

I've tested this on a dual band card and in fact as I expected it
cured the oops we were seeing with ath9k.

  Luis
