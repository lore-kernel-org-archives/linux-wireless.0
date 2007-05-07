Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:44867
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966494AbXEGUpH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2007 16:45:07 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Jiri Benc <jbenc@suse.cz>
Subject: Re: [PATCH] mac80211: Allow sleeping in set_key op
Date: Mon, 7 May 2007 22:44:23 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200705062037.35037.mb@bu3sch.de> <20070507185224.45f98d56@midnight.suse.cz>
In-Reply-To: <20070507185224.45f98d56@midnight.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200705072244.23736.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 07 May 2007 18:52:24 Jiri Benc wrote:
> On Sun, 6 May 2007 20:37:34 +0200 Michael Buesch wrote:
> > [...]
> >  static void finish_sta_info_free(struct ieee80211_local *local,
> >  				 struct sta_info *sta)
> >  {
> > +	sta_info_key_disable(local, sta);
> > +
> >  #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
> >  	printk(KERN_DEBUG "%s: Removed STA " MAC_FMT "\n",
> >  	       local->mdev->name, MAC_ARG(sta->addr));
> > @@ -213,6 +246,16 @@ static void finish_sta_info_free(struct 
> >  	sta_info_put(sta);
> >  }
> 
> There is a race here. You already removed the sta from sta_hash list
> and you're not protected by any lock. Thus, it is possible to add a new
> station with the same address before finish_sta_info_free is called.
> When this happens, you call the set_key handler for the new key and
> after that you call it again with DISABLE_KEY.
> 
> It's not easy to get this right. I remember also problems with
> dereferencing already freed key when I thought about possible ways to
> solve exactly this problem.

I'm not sure this race exists.
You assume that when a new key is added with the same mac as before
it overrides the old key. I think that's a bug in the driver then.
IMO the driver _must_ keep track of used key "slots" and don't
re-allocate them for new keys until disable-key is called.
And that's exactly what bcm43xx does.

IMO it's a bug in the driver, when it overrides a key that's not
DISABLEd.

Short: I don't think there is a race, and if, then it's a driver bug.


This is one of the showstopper bugs for bcm43xx to get merged.
(There are others, though).

-- 
Greetings Michael.
