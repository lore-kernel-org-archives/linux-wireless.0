Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.240]:53624 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890AbYBASrN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2008 13:47:13 -0500
Received: by an-out-0708.google.com with SMTP id d31so296003and.103
        for <linux-wireless@vger.kernel.org>; Fri, 01 Feb 2008 10:47:11 -0800 (PST)
Message-ID: <40f31dec0802011047r6f90b714x8626f9158b963e6d@mail.gmail.com> (sfid-20080201_184719_711629_42C7B6C9)
Date: Fri, 1 Feb 2008 20:47:11 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
Subject: Re: [ath5k-devel] [PATCH 1/1] ath5k: Cleanup after API changes patch
Cc: "Johannes Berg" <johannes@sipsolutions.net>, bruno@thinktube.com,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	jirislaby@gmail.com, linville@tuxdriver.com
In-Reply-To: <43e72e890802010452s510628ear49136748e06fc670@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080201012544.GD28995@ruslug.rutgers.edu>
	 <1201869496.4188.15.camel@johannes.berg>
	 <43e72e890802010441n4770fe0ag69899a537f551080@mail.gmail.com>
	 <1201869970.4188.24.camel@johannes.berg>
	 <43e72e890802010452s510628ear49136748e06fc670@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/2/1, Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>:
> 2008/2/1 Johannes Berg <johannes@sipsolutions.net>:
> >
> > > > What is cap_range and why should it be in struct wiphy?
> > >
> > > Its the device's frequency capability range on the bands.
> >
> > Well since we always need channels I decided to not have such a thing
> > but rather require registering a channels array that is also used for
> > bookkeeping about enabled/disabled channels etc.
> >
> > I guess you could add a helper function that allocates a channels array
> > based on a frequency range.
>
> This is true but also it would be nice as it is the end points which
> drivers may want
> to access every now and then. I think its worth the few bytes.
>
>   Luis

Why mac80211/cfg80211 has to know about phy's channel range ? I mean
driver knows it and that's all we need to create the big (unfiltered)
channel array. These caps are set for some chip revisions (eg. 5210
supports only part of 5GHz band while 5111/5112 support much wider
range) and only used by channel_ok during channel setup (attach), we
don't have any other use for those inside the driver. Other drivers
don't even need such caps because channel ranges are standard for all
their chip revisions, or they get channels from firmware, or use fixed
range/channel table no matter what phy supports etc.

The only use i can imagine for frequency range information on
mac80211/cfg80211 is that the whole channel setup is being done during
wiphy setup (we provide frequency range and supported bands and
mac80211/cfg80211 does the rest) but we'll have (at least for ath5k)
to fill channel flags (hw_value) anyway.

About the patch: You are right that we should use channel_ok in
hw_channel but there is no need for that switch, channel_ok checks the
channel flags (hw_value) and determines the band already (and channel
flags are filled per band -CHANNEL_2GHZ/CHANNEL_5GHZ- during setup so
checking channel->band or channel->hw_vallue is the same).

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
