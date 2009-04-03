Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:44324 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933694AbZDCSND (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Apr 2009 14:13:03 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 03 Apr 2009 11:13:02 -0700
Date: Fri, 3 Apr 2009 11:12:59 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 5/5] mac80211: expose HT channel flags through debugfs
Message-ID: <20090403181259.GC10278@tesla> (sfid-20090403_201307_517942_C7BEAE20)
References: <1238711166-2208-1-git-send-email-lrodriguez@atheros.com> <1238711166-2208-6-git-send-email-lrodriguez@atheros.com> <1238750659.27712.15.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1238750659.27712.15.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 03, 2009 at 02:24:19AM -0700, Johannes Berg wrote:
> On Thu, 2009-04-02 at 18:26 -0400, Luis R. Rodriguez wrote:
> 
> > +DEBUGFS_READONLY_FILE(ht40allowed, 20, "%d",
> > +		      !(local->hw.conf.channel->flags &
> > +		      IEEE80211_CHAN_NO_HT40));
> 
> Why don't you just expose
> ...FILE(flags, 20, "%#x", local->hw.conf.channel->flags))

I did first, I didn't like it. What I want is an easy to access
check for ht40- or ht40+. Not to have someone to cat the file and
do some bit map checks on it. This is debugfs afterall.

  Luis
