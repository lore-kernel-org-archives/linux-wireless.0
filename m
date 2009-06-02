Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.175]:60351 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793AbZFBBaS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2009 21:30:18 -0400
Received: by wf-out-1314.google.com with SMTP id 26so2686378wfd.4
        for <linux-wireless@vger.kernel.org>; Mon, 01 Jun 2009 18:30:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1243905828-21933-1-git-send-email-lrodriguez@atheros.com>
References: <1243905828-21933-1-git-send-email-lrodriguez@atheros.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 1 Jun 2009 18:30:00 -0700
Message-ID: <43e72e890906011830q2867ed1el7914846c15c8eb3e@mail.gmail.com>
Subject: Re: [RFC] mac80211: handle -EXIST on sta_info_insert()
To: linville@tuxdriver.com, johannes@sipsolutions.net,
	Jouni.Malinen@atheros.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 1, 2009 at 6:23 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> There's a few places where we either did not rcu_read_lock()
> prior to addition of a a new sta or we allocated it before
> checking for its existance. In most places, like device open
> and close we should have at least some guarantee the stas are
> wiped but in other places this could not be the case.
>
> Lets protect against RCU in the missing places. The only
> place I see is is in ieee80211_rx_bss_info(). Not sure
> we are calling ieee80211_ibss_add_sta() twice there though.
>
> In our mac80211 cfg80211 callback for device addition we
> also can simplify the code by first checking for the STA
> before trying to add it and then checking for -EEXIST which
> we were not doing. If that actualy would happen we could
> end up potentially with a stale sta and the rate info was
> never updated. It seems cleaner to check for the sta first.
>
> Lastly, we add a WARN_ON() on the STA mlme path upon call to
> ieee80211_rx_mgmt_assoc_resp() for -EEXIST. This should not
> happen, we could just return -EIO or simply ignore it.

Hm, actually on second thought what if we simply kdoc that you should
check for the sta's existence first prior to addition. Then we can
remove the pesky -EEXIST.

  Luis
