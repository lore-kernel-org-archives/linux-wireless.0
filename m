Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:10751 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753719Ab0BCPEY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2010 10:04:24 -0500
Subject: Re: [PATCH v2 1/1] mac80211: tear down all agg queues when
 restart/reconfig hw
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1265186640.29119.83.camel@johannes.local>
References: <1265159851-20682-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1265186640.29119.83.camel@johannes.local>
Content-Type: text/plain
Date: Wed, 03 Feb 2010 07:00:55 -0800
Message-Id: <1265209255.12116.2.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-02-03 at 00:44 -0800, Johannes Berg wrote:
> On Tue, 2010-02-02 at 17:17 -0800, wey-yi.w.guy@intel.com wrote:
> > From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> > 
> > When there is a need to restart/reconfig hw, tear down all the
> > aggregation queues and let the mac80211 and driver get in-sync and have
> > the opportunity to re-establish the aggregation queues.
> > 
> > Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> > ---
> > v2: add rcu_read_lock()
> > ---
> >  net/mac80211/util.c |   10 ++++++++++
> >  1 files changed, 10 insertions(+), 0 deletions(-)
> > 
> > diff --git a/net/mac80211/util.c b/net/mac80211/util.c
> > index ca170b4..27e8833 100644
> > --- a/net/mac80211/util.c
> > +++ b/net/mac80211/util.c
> > @@ -1188,6 +1188,16 @@ int ieee80211_reconfig(struct ieee80211_local *local)
> >  	ieee80211_wake_queues_by_reason(hw,
> >  			IEEE80211_QUEUE_STOP_REASON_SUSPEND);
> >  
> > +	rcu_read_lock();
> > +
> > +	if (hw->flags & IEEE80211_HW_AMPDU_AGGREGATION) {
> > +		list_for_each_entry_rcu(sta, &local->sta_list, list) {
> > +			ieee80211_sta_tear_down_BA_sessions(sta);
> > +		}
> > +	}
> > +
> > +	rcu_read_unlock();
> > +
> 
> I wonder if that shouldn't be _before_ waking up the queues again, since
> otherwise we'd enqueue all the frames that might have come in while
> reconfiguring as aggregation frames still?
> 
not sure, the current place works for my test

