Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54360 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849Ab2LMWqV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 17:46:21 -0500
Message-ID: <1355438798.9463.32.camel@jlt4.sipsolutions.net> (sfid-20121213_234623_873499_9A8D5A6A)
Subject: Re: [RFC 2/2] cfg80211: check (VHT) bandwidth against regulatory
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 13 Dec 2012 23:46:38 +0100
In-Reply-To: <CAB=NE6VCiPXwUGO+KZmi4Bhd5PvUwwUscnQ0F3xtd5FurEDN-A@mail.gmail.com> (sfid-20121213_233433_174271_005A45D4)
References: <1354812784-15845-1-git-send-email-johannes@sipsolutions.net>
	 <1354812784-15845-3-git-send-email-johannes@sipsolutions.net>
	 <1355159190.8083.1.camel@jlt4.sipsolutions.net>
	 <CAB=NE6VCiPXwUGO+KZmi4Bhd5PvUwwUscnQ0F3xtd5FurEDN-A@mail.gmail.com>
	 (sfid-20121213_233433_174271_005A45D4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-12-13 at 14:34 -0800, Luis R. Rodriguez wrote:
> On Mon, Dec 10, 2012 at 9:06 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Thu, 2012-12-06 at 17:53 +0100, Johannes Berg wrote:
> >
> >> +bool reg_check_bandwidth(struct wiphy *wiphy,
> >> +                      u32 center_freq_khz, u32 bw_khz)
> >> +{
> >> +     const struct ieee80211_reg_rule *reg_rule;
> >> +
> >> +     /*
> >> +      * This interpretation is a bit of a strange quirk in the regulatory
> >> +      * rules definitions that we have today: each 20 MHz channel must fit
> >> +      * entirely into a single regulatory range, but if this range forbids
> >> +      * using more than 20 MHz then it forbids even using a small part of
> >> +      * this for the wider channel.
> >> +      */
> >> +
> >> +     reg_rule = freq_reg_info(wiphy, center_freq_khz);
> >> +     if (!IS_ERR(reg_rule))
> >> +             return reg_rule->freq_range.max_bandwidth_khz >= bw_khz;
> >
> > This needs rcu_read_lock() obviously... Fixed in my version in the wip
> > branch.
> 
> Looks good, the get_wiphy_regdom() change above seemed like it'd
> belong on a separate patch though.

Humm, yeah, wtf. That belongs into the RCU change.

johannes

