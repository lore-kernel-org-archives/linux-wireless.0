Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:62984 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653Ab3KOJh0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Nov 2013 04:37:26 -0500
Received: by mail-lb0-f182.google.com with SMTP id w7so76202lbi.27
        for <linux-wireless@vger.kernel.org>; Fri, 15 Nov 2013 01:37:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131114144638.GF19070@garbanzo.do-not-panic.com>
References: <1384366379-25301-1-git-send-email-mcgrof@do-not-panic.com>
	<1384366379-25301-6-git-send-email-mcgrof@do-not-panic.com>
	<1384378173.28806.22.camel@jlt4.sipsolutions.net>
	<CALhHN=r4y+JDw9_i9FdKwNoHgic+bvkMJRpYwnaXoSK519Metw@mail.gmail.com>
	<CALhHN=o-LQfXuyujFOj6A7hzE0mBbC5Q6r3ByL6APJffOx4sHQ@mail.gmail.com>
	<20131114144638.GF19070@garbanzo.do-not-panic.com>
Date: Fri, 15 Nov 2013 10:37:24 +0100
Message-ID: <CALhHN=pZ_v+kupuU=wVmWLYp7_9w-uEerrJUJkXfZqh1kxiUOw@mail.gmail.com> (sfid-20131115_103734_989093_94D2F8E3)
Subject: Re: [RFC 5/5] cfg80211: DFS check dfs_region before usage
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, j@w1.fi,
	sunitb <sunitb@qca.qualcomm.com>,
	rsunki <rsunki@qca.qualcomm.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14 November 2013 15:46, Luis R. Rodriguez <mcgrof@do-not-panic.com> wrote:
> On Thu, Nov 14, 2013 at 12:52:26PM +0100, Janusz Dziedzic wrote:
>> On 14 November 2013 11:15, Janusz Dziedzic <janusz.dziedzic@tieto.com> wrote:
>> > On 13 November 2013 22:29, Johannes Berg <johannes@sipsolutions.net> wrote:
>> >> On Wed, 2013-11-13 at 19:12 +0100, Luis R. Rodriguez wrote:
>> >>> Check the DFS region before channel availability check
>> >>> or declaring a channel as DFS usable.
>> >>>
>> >>> Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
>> >>> ---
>> >>>  net/wireless/chan.c    | 8 ++++++++
>> >>>  net/wireless/nl80211.c | 5 +++++
>> >>>  2 files changed, 13 insertions(+)
>> >>>
>> >>> diff --git a/net/wireless/chan.c b/net/wireless/chan.c
>> >>> index 78559b5..4e6eaa0 100644
>> >>> --- a/net/wireless/chan.c
>> >>> +++ b/net/wireless/chan.c
>> >>> @@ -517,10 +517,18 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
>> >>>       struct ieee80211_sta_ht_cap *ht_cap;
>> >>>       struct ieee80211_sta_vht_cap *vht_cap;
>> >>>       u32 width, control_freq;
>> >>> +     enum nl80211_dfs_regions dfs_region;
>> >>>
>> >>>       if (WARN_ON(!cfg80211_chandef_valid(chandef)))
>> >>>               return false;
>> >>>
>> >>> +     rtnl_lock();
>> >>> +     dfs_region = reg_get_dfs_region(wiphy);
>> >>> +     rtnl_unlock();
>> >>
>> >
>> >
>> > Do we need check dfs_region in cfg80211_can_beacon() at all?
>> > We already check first if all channels NL80211_DFS_AVAILABLE.
>> > To be DFS_AVAILABLE we need pass CAC, and we will fail CAC if
>> > dfs_region == UNSET.
>> >
>> > Anyway we can do something like this in cfg80211_can_beacon()
>> >
>> >         if (cfg80211_chandef_dfs_required(wiphy, chandef) > 0 &&
>> > -           cfg80211_chandef_dfs_available(wiphy, chandef)) {
>> > +           cfg80211_chandef_dfs_available(wiphy, chandef) &&
>> > +           reg_get_dfs_region(wiphy) != NL80211_DFS_UNSET) {
>> > ...
>> > And change doc that cfg80211_can_beacon() require rtnl_lock.
>> > But I think this is not required.
>> >
>> Or if we should handle dfs_region change after we start CAC and
>> start beaconing,
>
> Can you clarify what you mean?
>
> Right now update_all_wiphy_regulatory() contends on the rtnl_lock(),
> I am not sure if starting CAC and beaconing does. I also just did
> not get what you mean here.
>
CAC is only a request - so as I understand correctly rtnl_lock() is
not held whole CAC time (1minute, 10 minutes)
So we could have something like this

1) request CAC
2) mac80211 will call driver radar detection (ETSI) and will start cac
timer (60s)
3) after 40 seconds we will change regdom and dfs_region (eg. from
ETSI -> FCC) - tested using iw reg set US

Currently we will not cancel CAC and will mark channels as
DFS_AVAILABLE after 1 minute.
So, probably we will need cancel_radar_detection() callback that will
cancel mac80211 timer here when cac_started and regulatory_update()
and different dfs_regions.

4) CAC end and we set DFS_AVAILABLE state
5) we start beaconning (even we do radar_detection for FCC only for
about 20 seconds)

This is probably rare case when we will change dfs_region between
start_cac() and can_beacon() - so I am not sure we have to handle
this?

BR
Janusz


>> we could add __cfg80211_can_beacon() without rtnl
>> locking and cfg80211_can_beacon() with locking.
>
> If to use DFS we need DFS_AVAILABLE and if it is *never* set
> if dfs region is unset I think we should be good *if* we handle
> quiescing properly.
>
>> BTW
>> Luis should we handle dfs_region change also during CAC? Who should
>> fail CAC in case we switch eg. from ETSI to FCC? Should we handle this
>> in driver?
>
> I gave this a lot of thought and decided to just do it in kernel
> on cfg80211 by quescing upon regulatory domain changes where
> appropriately (not just for DFS region change), *and* by having
> wiphy_core_dfs_region_usable() always be checked before sending
> to userspace the supported DFS regions. The trick here is that
> since we are quiescing it means that userspace in theory (if
> we do quescing properly) will always have to check query for the
> DFS regions *anytime* it will want to start a new interface for
> initiating radiation, ie just once upon init. If the DFS region
> changes quescing would have turned off radiation and what I was
> aiming for is for then userspace to have to get the DFS region
> again and only if its set would it then again start radiation.
>
> Doing it this way avoid us having to do anything on any driver.
> It also allows us to not even have to deal with this in userspace,
> which would have required userspace to provide support for handling
> DFS region changes by monitoring the multicast regulatory group,
> and upon a regulatory change, if a DFS region change, or any
> regulatory change queisce itself.
>
> Notice that upon a regulatory intersection we end up using DFS
> unset if the DFS regions disagree, and that we now always use
> the central cfg80211 DFS region. This ensures that DFS is tied
> down to regulatory agreement on the system.
>
>   Luis
