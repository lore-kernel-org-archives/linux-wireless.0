Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.190]:3849 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbZCPSSp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2009 14:18:45 -0400
Received: by ti-out-0910.google.com with SMTP id d10so2309199tib.23
        for <linux-wireless@vger.kernel.org>; Mon, 16 Mar 2009 11:18:42 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <18878.38992.238041.18093@gargle.gargle.HOWL> (sfid-20090316_191849_392028_A6C4D80F)
Date: Mon, 16 Mar 2009 23:50:00 +0530
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni.Malinen@Atheros.com, me@bobcopeland.com
Subject: Re: [PATCH v2] mac80211: Tear down aggregation sessions for suspend/resume
In-Reply-To: <1237212162.16396.15.camel@johannes.local>
References: <18878.9292.503830.420780@gargle.gargle.HOWL>
	<1237212162.16396.15.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Mon, 2009-03-16 at 15:35 +0530, Sujith wrote:
> 
> > +	/* Tear down aggregation sessions */
> > +	if (hw->flags & IEEE80211_HW_AMPDU_AGGREGATION) {
> > +		list_for_each_entry(sta, &local->sta_list, list) {
> > +			set_sta_flags(sta, WLAN_STA_SUSPEND);
> > +			ieee80211_sta_tear_down_BA_sessions(sta);
> > +		}
> > +	}
> 
> Doesn't that, and the corresponding code in resume, need to be using the
> rcu-safe list iteration primitives and rcu_read_lock(), or acquire the
> sta_lock like the other iteration? While we should be more or less
> quiescent at this point, I wouldn't really want to bet on it.

Ah, right, it should be rcu-protected.
Will send out a v3 tomorrow.

Sujith
