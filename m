Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54282 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753144AbbAENr2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2015 08:47:28 -0500
Message-ID: <1420465645.9459.13.camel@sipsolutions.net> (sfid-20150105_144731_888509_A636D1CD)
Subject: Re: [PATCH v3] cfg80211: check for carrier state only when
 offchanel CAC supported
From: Johannes Berg <johannes@sipsolutions.net>
To: Avinash Patil <patila@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Cathy Luo <cluo@marvell.com>
Date: Mon, 05 Jan 2015 14:47:25 +0100
In-Reply-To: <CBACCFA0AEB13A41977475BCF3E896FC66736E7A69@SC-VEXCH2.marvell.com> (sfid-20150105_143403_923577_F829B8B6)
References: <1420475584-5533-1-git-send-email-patila@marvell.com>
	 (sfid-20150105_120344_381788_A7E15DA0),<1420462674.9459.9.camel@sipsolutions.net>
	 <CBACCFA0AEB13A41977475BCF3E896FC66736E7A69@SC-VEXCH2.marvell.com>
	 (sfid-20150105_143403_923577_F829B8B6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-01-05 at 05:28 -0800, Avinash Patil wrote:

> > -     if (netif_carrier_ok(dev))
> > +     if (wiphy_ext_feature_isset(&rdev->wiphy,
> > +                                 NL80211_EXT_FEATURE_OFFCHAN_CAC) &&
> > +         netif_carrier_ok(dev))
> >               return -EBUSY;
> 
> >Wait - doesn't that have to be !feature_isset()?
> 
> >johannes
> 
> If Offchannel CAC is supported (driver has set this bit in wiphy's
> extended features) & carrier is ON, return EBUSY as offchannel CAC may
> be ongoing, isnt it?

Well, my thinking is this - a new feature flag should allow something
new.

Therefore, the patch should essentially be this:

+ if (!new_feature)
  if (do_old_check)

Now wrapping that into a single if gives

- if (do_old_check)
+ if (!new_feature && do_old_check)

so the patch looks wrong to me.

johannes

