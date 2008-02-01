Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.180]:50697 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000AbYBAXAr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2008 18:00:47 -0500
Received: by wa-out-1112.google.com with SMTP id v27so957761wah.23
        for <linux-wireless@vger.kernel.org>; Fri, 01 Feb 2008 15:00:46 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: mac80211 QoS/aggregation questions, thoughts
Date: Sat, 2 Feb 2008 00:00:24 +0100
Cc: Ron Rindjunsky <ron.rindjunsky@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>, Tomas Winkler <tomasw@gmail.com>,
	Patrick McHardy <kaber@trash.net>
References: <1201882512.4188.66.camel@johannes.berg> <200802012325.26163.IvDoorn@gmail.com> <1201905133.4188.91.camel@johannes.berg>
In-Reply-To: <1201905133.4188.91.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200802020000.24604.IvDoorn@gmail.com> (sfid-20080201_230104_213281_0967731F)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 01 February 2008, Johannes Berg wrote:
> 
> > Like I mentioned earlier, ring/queue handling has received an overhaul,
> > so not much of the rt2x00 part of this patch will apply after the update.
> > However the change should be easier afterwards. ;)
> 
> :)
> Keep the patches coming. No need to test them in rt2x00.git first,
> wireless-2.6 git is pretty broken anyway right now. Due to me,
> unfortunately.

Ok. I'll try to implement LED classes this weekend. I already have the initial
patches for that ready, but those were not really correct. Ones those are in
I'll submit all patches as the 2.1.0 release.
If I release them all this weekend they will be compile tested only, and I would
like to have at least 1 run test to make sure no obvious NULL pointers or segmentation
faults are there during init.

> > Personally I think these queue identifiers should be completely seperated from the ieee80211_queue
> > enumeration, and not be used inside a variable mixed.
> > But that will be implementation details for later, and something I should probably take care of. ;)
> 
> Yeah, but this seemed easiest for now. We never use the beacon queue in
> mac80211 and I believe that we shouldn't because not all hardware uses a
> queue for beacons.

I understand the change, and my comment was more a first idea for teh rt2x00 implementation. ;)
I think I'll try to remove the IEEE80211_TX_QUEUE_BEACON tomorrow already and setup the correct
implementation. That value is set as identifier by rt2x00 manually anyways (it never relies on
mac80211 passing that value, so moving it to a different identifier can easily be done seperately from
your patch. Saves you some time updating the patch anyway. :)


> > Other then that, the patch is fine with me, but not this patch probably needs to be respinned after
> > my rt2x00 queue and virtual interfaces overhaul.
> 
> Right, no worries, I'm not entirely sure about this patch anyway.

Ivo
