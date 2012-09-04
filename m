Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42258 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab2IDTiO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2012 15:38:14 -0400
Message-ID: <1346787524.3737.43.camel@jlt4.sipsolutions.net> (sfid-20120904_213817_611719_D52E79AD)
Subject: Re: [RFC] cfg/nl/mac80211: use per-band basic rates bitmap in IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <ordex@autistici.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Tue, 04 Sep 2012 21:38:44 +0200
In-Reply-To: <1346784741-7003-1-git-send-email-ordex@autistici.org>
References: <1346784741-7003-1-git-send-email-ordex@autistici.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-09-04 at 20:52 +0200, Antonio Quartulli wrote:
> Each band maps the bitmap of rates to different real bitrates, therefore using
> the same bitmask for every band (as it is now) is not correct.
> Each band must have its own bitmask where the bits of the rates specified by the
> user on IBSS join have to be set
> 
> Signed-off-by: Antonio Quartulli <ordex@autistici.org>
> ---
>  include/net/cfg80211.h     |  4 ++--
>  net/mac80211/ibss.c        |  6 ++++--
>  net/mac80211/ieee80211_i.h |  2 +-
>  net/wireless/nl80211.c     | 12 +++++++-----

I'm not sure I see the need to change nl80211, and the change seems
wrong anyway.

As far as I understand it, the basic rates that are passed into the
kernel are intended to be used when the kernel creates a new IBSS. This
always happens on the channel that is also passed in, so it's always
bound to a given channel (band).

Now mac80211 internally seems to mess this up a bit, but that doesn't
affect nl80211/cfg80211?

johannes

