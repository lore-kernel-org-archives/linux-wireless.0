Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39261 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466Ab3H3LgT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Aug 2013 07:36:19 -0400
Message-ID: <1377862571.16256.11.camel@jlt4.sipsolutions.net> (sfid-20130830_133623_137190_CE5651DB)
Subject: Re: [PATCH v14 2/2] cfg80211: P2P find phase offload
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Date: Fri, 30 Aug 2013 13:36:11 +0200
In-Reply-To: <5966990.L3xT1qRD5c@lx-vladimir>
References: <1376567489-1863-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1376567489-1863-3-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1377267409.14021.47.camel@jlt4.sipsolutions.net>
	 <5966990.L3xT1qRD5c@lx-vladimir>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-08-26 at 16:26 +0300, Vladimir Kondratiev wrote:
> On Friday, August 23, 2013 04:16:49 PM Johannes Berg wrote:
> > Ilan also pointed out to me that it might be necessary to document (and
> > enforce?) that scan/sched_scan can't be executed in parallel? Or can
> > they?
> 
> Indeed, one can't simultaneously scan and do p2p_find on the same hardware,
> because of contradictionary requirements. I documented it in start_p2p_find:
> > + *     P2P find can't run concurrently with ROC or scan,
> > + *     conflict with scan detected by cfg80211 and -EBUSY returned;
> > + *     and driver should check for ROC and return -EBUSY to indicate
> > conflict.
> 
> Shall I elaborate more, what is appropriate location for this explanation?

Ah, I missed that. I was thinking it should be in nl80211.h so that
users of the API would also be told about it.

In fact, it looks like you have no documentation in nl80211.h for the
new commands at all, you should change that anyway. I'm surprised we
never discussed that before, sorry.

> Regarding locking - I feel I need to do it similar to scan. There, we have
> locked inner function that is invoked from cfg80211_wq.

Yes, we put the 'done' completion on the workqueue. However, we don't
have an explicit stop operation for scan, so things are a bit simpler -
scan is triggered and eventually stops. There's no race.

If you do the same, there's a race:

  driver stops by itself
  driver calls stop
  stop queued to workqueue
                                 userspace calls stop
                                 driver stop invoked

This could lead to confusion I think.

> And, overall - maybe reuse scan pattern in other aspects -
> allocate cfg80211_p2p_find_params like it is done for cfg80211_scan_request
> (and rename struct to cfg80211_p2p_find_request).
> instead of wdev->p2p_find_active, have rdev->p2p_find_req - this will sort
> concurrent p2p_find for sibling wdevs
> 
> Also, same pattern will make p2p_find API more intuitive if it follows same
> conventions as scan 

I guess you can make that work, just due the race above it's a bit
trickier than scan.

johannes

