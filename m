Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:53837 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144Ab3KNOY3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Nov 2013 09:24:29 -0500
Received: by mail-pb0-f47.google.com with SMTP id rr4so621648pbb.34
        for <linux-wireless@vger.kernel.org>; Thu, 14 Nov 2013 06:24:29 -0800 (PST)
Date: Thu, 14 Nov 2013 06:35:09 -0800
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, j@w1.fi,
	sunitb@qca.qualcomm.com, rsunki@qca.qualcomm.com,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC 5/5] cfg80211: DFS check dfs_region before usage
Message-ID: <20131114143507.GE19070@garbanzo.do-not-panic.com> (sfid-20131114_152451_652008_BA0FEA65)
References: <1384366379-25301-1-git-send-email-mcgrof@do-not-panic.com>
 <1384366379-25301-6-git-send-email-mcgrof@do-not-panic.com>
 <1384378173.28806.22.camel@jlt4.sipsolutions.net>
 <CALhHN=r4y+JDw9_i9FdKwNoHgic+bvkMJRpYwnaXoSK519Metw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CALhHN=r4y+JDw9_i9FdKwNoHgic+bvkMJRpYwnaXoSK519Metw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 14, 2013 at 11:15:25AM +0100, Janusz Dziedzic wrote:
> On 13 November 2013 22:29, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Wed, 2013-11-13 at 19:12 +0100, Luis R. Rodriguez wrote:
> >> Check the DFS region before channel availability check
> >> or declaring a channel as DFS usable.
> >>
> >> Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
> >> ---
> >>  net/wireless/chan.c    | 8 ++++++++
> >>  net/wireless/nl80211.c | 5 +++++
> >>  2 files changed, 13 insertions(+)
> >>
> >> diff --git a/net/wireless/chan.c b/net/wireless/chan.c
> >> index 78559b5..4e6eaa0 100644
> >> --- a/net/wireless/chan.c
> >> +++ b/net/wireless/chan.c
> >> @@ -517,10 +517,18 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
> >>       struct ieee80211_sta_ht_cap *ht_cap;
> >>       struct ieee80211_sta_vht_cap *vht_cap;
> >>       u32 width, control_freq;
> >> +     enum nl80211_dfs_regions dfs_region;
> >>
> >>       if (WARN_ON(!cfg80211_chandef_valid(chandef)))
> >>               return false;
> >>
> >> +     rtnl_lock();
> >> +     dfs_region = reg_get_dfs_region(wiphy);
> >> +     rtnl_unlock();
> >
> 
> 
> Do we need check dfs_region in cfg80211_can_beacon() at all?
> We already check first if all channels NL80211_DFS_AVAILABLE.
> To be DFS_AVAILABLE we need pass CAC, and we will fail CAC if
> dfs_region == UNSET.

SWEET!

> Anyway we can do something like this in cfg80211_can_beacon()
> 
>         if (cfg80211_chandef_dfs_required(wiphy, chandef) > 0 &&
> -           cfg80211_chandef_dfs_available(wiphy, chandef)) {
> +           cfg80211_chandef_dfs_available(wiphy, chandef) &&
> +           reg_get_dfs_region(wiphy) != NL80211_DFS_UNSET) {
> ...
> And change doc that cfg80211_can_beacon() require rtnl_lock.
> But I think this is not required.

If its not required I'd prefer to avoid this junk and just
clarify what you said as part of the documentation, it wasn't
clear to me. I'll just drop this patch in the series.

  Luis
