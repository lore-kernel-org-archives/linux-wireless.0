Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56408 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756596Ab1LBNzn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Dec 2011 08:55:43 -0500
Subject: Re: Memory Leak in AMPDU
From: Johannes Berg <johannes@sipsolutions.net>
To: Yogesh Ashok Powar <yogeshp@marvell.com>
Cc: nishants@marvell.com, linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
In-Reply-To: <20111202094123.GB5808@hertz.marvell.com> (sfid-20111202_104129_744336_CBA7657D)
References: <20111202094123.GB5808@hertz.marvell.com>
	 (sfid-20111202_104129_744336_CBA7657D)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Dec 2011 14:55:38 +0100
Message-ID: <1322834138.4124.4.camel@jlt3.sipsolutions.net> (sfid-20111202_145546_153603_AD7BF706)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> We have observed memory leaks because of ampdu tx pending queue not
> being freed before destroying the station info. In
> '__sta_info_destroy' when we attempt the destroy the ampdu sessions
> in 'ieee80211_sta_tear_down_BA_sessions', the driver calls
> 'ieee80211_stop_tx_ba_cb_irqsafe' to delete the ampdu structures
> (tid_tx) and splice the pending queues and this job gets queued in
> sdata workqueue.
> 
> However, the sta entry can get destroyed before the above work gets
> scheduled and hence the race. Purging the queues and freeing the
> tid_tx would avoid the leak, but I wanted to get your thoughts before
> attempting to fix this cleanly. 

Yeah ... the interesting part is whether we want drivers to be able to
deal with a station being removed while an aggregation stop is still
pending? Otherwise we have to somehow postpone the full destruction
until the aggregation stop completes?

Other than that I have no concerns I guess.

johannes

