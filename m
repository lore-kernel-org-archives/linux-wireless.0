Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.186]:10268 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760950AbYDAVTT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 17:19:19 -0400
Received: by rn-out-0910.google.com with SMTP id e24so1343063rng.1
        for <linux-wireless@vger.kernel.org>; Tue, 01 Apr 2008 14:19:18 -0700 (PDT)
Message-ID: <1ba2fa240804011419l1b825c7cnd02790257af9112c@mail.gmail.com> (sfid-20080401_221937_344116_2D036939)
Date: Wed, 2 Apr 2008 00:19:12 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: mac80211: holding sta_info for non associated stations
Cc: "Ron Rindjunsky" <ron.rindjunsky@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1207052896.5143.76.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <c85cb4470803310746h36b20d0egce98f8cea3becb0b@mail.gmail.com>
	 <1207052896.5143.76.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 1, 2008 at 3:28 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> Hi,
>
>
>  > If i associate to a random AP "x" (what happened automatically as i
>  > was configured by ifup scripts to do that), and then scan and
>  > associate to my desired AP "y", i notice that AP "x" was not removed
>  > from the mac80211 station table. Then, what happened was that during
>  > ieee80211_stop, when we reach
>  >
>  > list_for_each_entry_rcu(sta, &local->sta_list, list) {
>  >     if (sta->sdata == sdata)
>  >     ieee80211_sta_tear_down_BA_sessions(dev, sta->addr);
>  > }
>  >
>  > we try to tear down sessions to irrelevant stations (AP "x" in my
>  > example), which leads to bugs.
>
>  Why would that lead to bugs? That station was known, and there are no
>  sessions for that AP.

It's like freeing twice the same a pointer. On what level will you
check that there are no BA session with this ghost  AP?

>
>  > did i miss something, or is there really a problem in the state
>  > machine in the described scenario?
>
>  There might be a problem in that we forget to remove that AP under some
>  circumstances but it shouldn't matter, we always can have multiple
>  stations in our table.

Not in STA mode, should be associated only to one AP at a time. (Hope
this also cover roaming).

Tomas
