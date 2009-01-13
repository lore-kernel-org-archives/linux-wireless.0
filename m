Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:34613 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755894AbZAMXSH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 18:18:07 -0500
Received: from mail.atheros.com ([10.10.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 13 Jan 2009 15:18:07 -0800
Date: Tue, 13 Jan 2009 15:17:41 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 00/12] cfg80211/mac80211: fixes/enhancements for
	reg_notifier()
Message-ID: <20090113231741.GU4416@tesla> (sfid-20090114_001832_016251_A9A08345)
References: <1231876675-20518-1-git-send-email-lrodriguez@atheros.com> <1231887621.3728.12.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1231887621.3728.12.camel@johannes>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 13, 2009 at 03:00:21PM -0800, Johannes Berg wrote:
> On Tue, 2009-01-13 at 11:57 -0800, Luis R. Rodriguez wrote:
> > This series contains a few fixes for cfg80211 such as another
> > fix for parsing country IEs, but mostly contains work to help
> > drivers build a more useful reg_notifier(). While at it we remove
> > the CONFIG_WIRELESS_OLD_REGULATORY as we are now on road to 2.6.30.
> > 
> > Luis R. Rodriguez (12):
> >   cfg80211: print correct intersected regulatory domain
> >   cfg80211: add helper to indicate when to follow the driver regd
> >   cfg80211: add option for wiphys to disregard country IEs
> >   cfg80211: split wiphy_update_regulatory() in two
> >   cfg80211: add regulatory_set_custom_rd()
> >   cfg80211: add regdom_intersect_wiphy_regd()
> >   cfg80211: allow driver read access to cfg80211_regdomain
> >   cfg80211: export freq_reg_info()
> >   cfg80211: Fix sanity check on 5 GHz when processing country IE
> >   cfg80211: process user requests only after previous user/driver/core
> >     requests
> >   mac80211: allow mac80211 drivers to get to driver priv from wiphy
> >   cfg80211: Remove CONFIG_WIRELESS_OLD_REGULATORY
> 
> I think this series is pretty much overkill. While I'd like you to
> finish work on this (you know why), I think you should go back and
> describe what you're trying to achieve.
> 
> It seems to me that you're trying to achieve two things:
>  1) have ath9k have its own world regdomain
>  2) restrict ath9k to the channels it has calibration data for
> 
> Am I totally off base?

Well its more of trusting CRDA for country regulatory data on ath9k, and of
allowing ath9k to use its own custom regulatory domains. The calibration data
just follows the regulatory domains and varies through time as updates go into
the wireless-regdb.

> For point (1), I'm not sure how you're doing that right now, but 

It is done via add regulatory_set_custom_rd() which copies the static
regdomain into wiphy->regd (handled then by cfg80211).

> (2) you
> should not do via the regulatory code and the notifier but rather by not
> registering those channels to start with

I did a lot of this work because you had opposed to allow drivers dynamically register
their channels. The size of the code also increases considerably by using static set of
channels for each custom regulatory domain, its possible though.

>, or setting the disabled flag
> before registration if that's easier.

You'll still need some sort of table. Either way -- all these are options of how to
accomplish the same task. I did this as part of cfg80211 as I figured it could be
used by other drivers.

  Luis
