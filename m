Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47346 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032AbZHGPqF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 11:46:05 -0400
Date: Fri, 7 Aug 2009 11:34:20 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: ivan.kuten@promwad.com, linux-wireless@vger.kernel.org,
	Yauhen Kharuzhy <yauhen.kharuzhy@promwad.com>
Subject: Re: [PATCH] wireless: Compare ethernet addresses by unaligned safe
	way
Message-ID: <20090807153419.GF7545@tuxdriver.com>
References: <1245149672-18063-1-git-send-email-yauhen.kharuzhy@promwad.com> <1245150895.8623.3.camel@johannes.local> <4A475F82.9040007@promwad.com> <1246262320.5947.3.camel@johannes.local> <4A68A465.6020501@promwad.com> <1248371971.634.0.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1248371971.634.0.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 23, 2009 at 07:59:31PM +0200, Johannes Berg wrote:
> On Thu, 2009-07-23 at 20:56 +0300, Ivan Kuten wrote:
> > > On Sun, 2009-06-28 at 15:18 +0300, Ivan Kuten wrote:
> > >> Hello,
> > >>
> > >> In net/wireless/scan.c : cfg80211_wext_siwscan there seems also unaligned allocations
> > >> for creq->ssids and creq->channels. Should it be something like that?
> > > 
> > > Seems alright, but there is more than one instance of this, maybe you
> > > can make a function to allocate a scan request properly and have it be
> > > called from all the places it's needed.
> > > 
> > > johannes
> > > 
> > 
> > Hello Johannes,
> > Can you point to that multiple scan allocations? I see only one kzalloc
> > with followed possible alignment violation - it's in cfg80211_wext_siwscan in scan.c
> 
> I'm sure there's one in nl80211.c too

Ivan/Yauhen,

Will you be posted an updated patch?  Time is short before the next merge window...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
