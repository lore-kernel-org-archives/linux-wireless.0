Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:48459 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641Ab3HZN0O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Aug 2013 09:26:14 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: Re: [PATCH v14 2/2] cfg80211: P2P find phase offload
Date: Mon, 26 Aug 2013 16:26:09 +0300
Message-ID: <5966990.L3xT1qRD5c@lx-vladimir> (sfid-20130826_152617_366085_F17793CB)
In-Reply-To: <1377267409.14021.47.camel@jlt4.sipsolutions.net>
References: <1376567489-1863-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <1376567489-1863-3-git-send-email-qca_vkondrat@qca.qualcomm.com> <1377267409.14021.47.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday, August 23, 2013 04:16:49 PM Johannes Berg wrote:
> Ilan also pointed out to me that it might be necessary to document (and
> enforce?) that scan/sched_scan can't be executed in parallel? Or can
> they?

Indeed, one can't simultaneously scan and do p2p_find on the same hardware,
because of contradictionary requirements. I documented it in start_p2p_find:
> + *     P2P find can't run concurrently with ROC or scan,
> + *     conflict with scan detected by cfg80211 and -EBUSY returned;
> + *     and driver should check for ROC and return -EBUSY to indicate
> conflict.

Shall I elaborate more, what is appropriate location for this explanation?

Regarding locking - I feel I need to do it similar to scan. There, we have
locked inner function that is invoked from cfg80211_wq.

And, overall - maybe reuse scan pattern in other aspects -
allocate cfg80211_p2p_find_params like it is done for cfg80211_scan_request
(and rename struct to cfg80211_p2p_find_request).
instead of wdev->p2p_find_active, have rdev->p2p_find_req - this will sort
concurrent p2p_find for sibling wdevs

Also, same pattern will make p2p_find API more intuitive if it follows same
conventions as scan 

Comments?
