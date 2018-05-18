Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:39908 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752130AbeERKhF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 May 2018 06:37:05 -0400
Message-ID: <1526639823.3805.16.camel@sipsolutions.net> (sfid-20180518_123710_006115_493585E0)
Subject: Re: [PATCH 2/2] cfg80211: release station info tidstats where needed
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
Cc: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>
Date: Fri, 18 May 2018 12:37:03 +0200
In-Reply-To: <5AFEAA02.2010303@broadcom.com> (sfid-20180518_122509_413575_EC6CFEF6)
References: <20180518094742.10669-1-johannes@sipsolutions.net>
         <20180518094742.10669-2-johannes@sipsolutions.net>
         <5AFEAA02.2010303@broadcom.com> (sfid-20180518_122509_413575_EC6CFEF6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2018-05-18 at 12:25 +0200, Arend van Spriel wrote:
> On 5/18/2018 11:47 AM, Johannes Berg wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > This fixes memory leaks in cases where we got the station
> > info but failed sending it out properly.
> 
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> > Fixes: 8689c051a201 ("cfg80211: dynamically allocate per-tid stats for station info")
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > ---
> >   include/net/cfg80211.h | 13 +++++++++++++
> >   net/wireless/nl80211.c | 11 ++++++++---
> >   2 files changed, 21 insertions(+), 3 deletions(-)
> > 
> > diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> > index 8984d24d68b7..1c6364591856 100644
> > --- a/include/net/cfg80211.h
> > +++ b/include/net/cfg80211.h
> > @@ -5710,6 +5710,19 @@ void cfg80211_remain_on_channel_expired(struct wireless_dev *wdev, u64 cookie,
> >    */
> >   int cfg80211_sinfo_alloc_tid_stats(struct station_info *sinfo, gfp_t gfp);
> > 
> > +/**
> > + * cfg80211_sinfo_release_sinfo - release contents of station info
> 
> Maybe drop one '_sinfo' from the function name? Or 
> cfg80211_sinfo_release_contents?

Heh. I guess I wasn't paying attention, I like _content()

johannes
