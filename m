Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:46336 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751913Ab1EEPvi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 May 2011 11:51:38 -0400
Received: by mail-ey0-f177.google.com with SMTP id 6so786948eyh.36
        for <linux-wireless@vger.kernel.org>; Thu, 05 May 2011 08:51:37 -0700 (PDT)
Subject: Re: [PATCH 3/3] cfg80211/nl80211: add interval attribute for
 scheduled scans
From: Luciano Coelho <coelho@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ben Greear <greearb@candelatech.com>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1304610524.12586.403.camel@cumari>
References: <1304600420-24227-1-git-send-email-coelho@ti.com>
	 <1304600420-24227-4-git-send-email-coelho@ti.com>
	 <4DC2B78E.3000205@candelatech.com>
	 <1304607108.3594.6.camel@jlt3.sipsolutions.net>
	 <4DC2B941.6@candelatech.com>
	 <1304607500.3594.7.camel@jlt3.sipsolutions.net>
	 (sfid-20110505_165557_965402_0D829BAA)  <1304607552.3594.8.camel@jlt3.sipsolutions.net>
	 <1304610524.12586.403.camel@cumari>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 May 2011 18:51:34 +0300
Message-ID: <1304610694.12586.404.camel@cumari> (sfid-20110505_175142_039519_753D704D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-05-05 at 18:48 +0300, Luciano Coelho wrote:
> On Thu, 2011-05-05 at 16:59 +0200, Johannes Berg wrote:
> > On Thu, 2011-05-05 at 16:58 +0200, Johannes Berg wrote:
> > > On Thu, 2011-05-05 at 07:50 -0700, Ben Greear wrote:
> > > > On 05/05/2011 07:51 AM, Johannes Berg wrote:
> > > > > On Thu, 2011-05-05 at 07:43 -0700, Ben Greear wrote:
> > > > >> On 05/05/2011 06:00 AM, Luciano Coelho wrote:
> > > > >>> Introduce NL80211_ATTR_SCHED_SCAN_INTERVAL as a required attribute for
> > > > >>> NL80211_CMD_START_SCHED_SCAN.  This value informs the driver at which
> > > > >>> intervals the scheduled scan cycles should be executed.
> > > > >>
> > > > >> Please default to something useful instead of requiring
> > > > >> this so that things are backwards compatible.
> > > > >
> > > > > Backward compatible to what?
> > > > 
> > > > To anything sending older style netlink messages?
> > > 
> > > But this is a new feature, and a new command, so I don't quite
> > > understand why an application would think it can send it without the
> > > interval?
> > 
> > Oh wait, I guess you're right, or this should just be part of patch 1
> > instead so we never have the feature without the requirement to have the
> > interval given.
> 
> Yeah, I could squish this with the previous patch (1/3), but I just
> reckoned that patch was getting too big, so I decided to make a separate
> one.
> 
> If this whole patch series is taken at the same time, I guess there
> won't be backwards compatibility problems (except for bisecting,
> maybe?).
> 
> Anyways, I'll leave it as your choice.  Squishing the patch is easy
> enough. ;)

Ah, and one more thought... There's no driver implementing this at this
point, so is there anything to really worry about?

-- 
Cheers,
Luca.

