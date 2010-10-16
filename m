Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58122 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832Ab0JPTAp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Oct 2010 15:00:45 -0400
Received: by bwz15 with SMTP id 15so1912607bwz.19
        for <linux-wireless@vger.kernel.org>; Sat, 16 Oct 2010 12:00:23 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [mac80211] mac80211:  Support multiple VIFS per AP in debugfs.
Date: Sat, 16 Oct 2010 21:00:02 +0200
Cc: greearb@gmail.com, linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
References: <1285212541-6834-1-git-send-email-greearb@candelatech.com> <1285231018.3691.8.camel@jlt3.sipsolutions.net>
In-Reply-To: <1285231018.3691.8.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201010162100.02477.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 23 September 2010 10:36:58 Johannes Berg wrote:
> On Wed, 2010-09-22 at 20:29 -0700, greearb@gmail.com wrote:
> > From: Ben Greear <greearb@candelatech.com>
> > 
> > Create 'stations' sub-directory under each netdev:[vif-name]
> > directory to hold all stations for that network device.
> > 
> > Signed-off-by: Ben Greear <greearb@candelatech.com>
> 
> Acked-by: Johannes Berg <johannes@sipsolutions.net>

ieee80211_debugfs_key_add needs to be updated (debugfs_key.c).
Either the "station" symlink has to go, or we need to loop up
to which interface the sta belongs. currently it's hard-coded to
"sprintf(buf, "../../stations/%pM", sta->sta.addr);"
(something which no longer exists)

> 
> > ---
> > :100644 100644 e81ef4e... ebd5b69... M	net/mac80211/debugfs.c
> > :100644 100644 20b2998... 3e12430... M	net/mac80211/debugfs_netdev.c
> > :100644 100644 76839d4... 6b7ff9f... M	net/mac80211/debugfs_sta.c
> > :100644 100644 9346a6b... 3c7c230... M	net/mac80211/ieee80211_i.h
> >  net/mac80211/debugfs.c        |    1 -
> >  net/mac80211/debugfs_netdev.c |    3 +++
> >  net/mac80211/debugfs_sta.c    |    2 +-
> >  net/mac80211/ieee80211_i.h    |    2 +-
> >  4 files changed, 5 insertions(+), 3 deletions(-)
> > 
> > diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
> > index e81ef4e..ebd5b69 100644
> > --- a/net/mac80211/debugfs.c
> > +++ b/net/mac80211/debugfs.c
> > @@ -368,7 +368,6 @@ void debugfs_hw_add(struct ieee80211_local *local)
> >  	if (!phyd)
> >  		return;
> >  
> > -	local->debugfs.stations = debugfs_create_dir("stations", phyd);
> >  	local->debugfs.keys = debugfs_create_dir("keys", phyd);
> >  
> >  	DEBUGFS_ADD(frequency);
