Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36955 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505Ab1LHIcg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 03:32:36 -0500
Subject: Re: [PATCH] mac80211: Purge A-MPDU TX queues before station
 destructions
From: Johannes Berg <johannes@sipsolutions.net>
To: Yogesh Ashok Powar <yogeshp@marvell.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Nishant Sarmukadam <nishants@marvell.com>
In-Reply-To: <20111208064124.GA4406@hertz.marvell.com> (sfid-20111208_074421_606738_7A47FCF3)
References: <20111208064124.GA4406@hertz.marvell.com>
	 (sfid-20111208_074421_606738_7A47FCF3)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Dec 2011 09:32:32 +0100
Message-ID: <1323333152.3332.2.camel@jlt3.sipsolutions.net> (sfid-20111208_093240_047421_648C92AA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-12-08 at 12:11 +0530, Yogesh Ashok Powar wrote:
> When a station leaves suddenly while ampdu traffic to that station is still
> running, there is a possibility that the ampdu pending queues are not freed due
> to a race condition leading to memory leaks. In '__sta_info_destroy' when we
> attempt to destroy the ampdu sessions in 'ieee80211_sta_tear_down_BA_sessions',
> the driver calls 'ieee80211_stop_tx_ba_cb_irqsafe' to delete the ampdu
> structures (tid_tx) and splice the pending queues and this job gets queued in
> sdata workqueue. However, the sta entry can get destroyed before the above work
> gets scheduled and hence the race.

There isn't even a requirement to call tx_ba_cb[_irqsafe]() right away,
so it's not just that race ... but anyway, I guess we cope with this
today so cleaning the frames is good.

Maybe you could add documentation somewhere that it is possible for a
station to be freed before the BA teardown completes? Just as a note for
driver authors.

johannes


