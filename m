Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55079 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381Ab3AXOnP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2013 09:43:15 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TyO1K-00089V-2H
	for linux-wireless@vger.kernel.org; Thu, 24 Jan 2013 15:43:14 +0100
Message-ID: <1359038619.4639.6.camel@jlt4.sipsolutions.net> (sfid-20130124_154321_132611_498F4C04)
Subject: Re: [RFC] mac80211: fix aggregation state with older drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 24 Jan 2013 15:43:39 +0100
In-Reply-To: <1358550082-24185-1-git-send-email-johannes@sipsolutions.net> (sfid-20130119_000105_716434_54602D73)
References: <1358550082-24185-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130119_000105_716434_54602D73)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2013-01-19 at 00:01 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> For drivers that don't actually flush their queues when
> aggregation stop with the IEEE80211_AMPDU_TX_STOP_FLUSH
> or IEEE80211_AMPDU_TX_STOP_FLUSH_CONT reasons is done,
> like iwlwifi or iwlegacy, mac80211 can then transmit on
> a TID that the driver still considers busy. This happens
> in the following way:

Did some longer testing, so I applied this.

johannes

