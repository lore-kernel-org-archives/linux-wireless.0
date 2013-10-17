Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:44100 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756506Ab3JQOvb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Oct 2013 10:51:31 -0400
Message-ID: <1382021488.14410.17.camel@jlt4.sipsolutions.net> (sfid-20131017_165135_263809_70E219F6)
Subject: Re: [PATCH 2/2] mac80211: store the channel in wdev upon ibss_join
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <antonio@meshcoding.com>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>
Date: Thu, 17 Oct 2013 16:51:28 +0200
In-Reply-To: <20131017144824.GH2596@neomailbox.net>
References: <1381790282-1146-1-git-send-email-antonio@meshcoding.com>
	 <1381790282-1146-2-git-send-email-antonio@meshcoding.com>
	 <1382020588.14410.12.camel@jlt4.sipsolutions.net>
	 <20131017144824.GH2596@neomailbox.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-10-17 at 16:48 +0200, Antonio Quartulli wrote:
> On Thu, Oct 17, 2013 at 04:36:28PM +0200, Johannes Berg wrote:
> > On Tue, 2013-10-15 at 00:38 +0200, Antonio Quartulli wrote:
> > > From: Antonio Quartulli <antonio@open-mesh.com>
> > > 
> > > To allow cfg80211 to use the real channel to pick up the
> > > proper (i)bss object, store the used channel in
> > > wdev->channel during ibss_join
> > 
> > WTF? No, mac80211 can't just randomly modify cfg80211-owned data.
> 
> Mh, ok. :)
> 
> What about setting wdev->channel in __cfg80211_join_ibss() right after having
> set wdev->ssid ?
> This way we leave mac80211 out and we totally handle this thing in cfg80211
> only.

Locking might be problematic though. I also don't know where else the
channel might be used?

johannes

