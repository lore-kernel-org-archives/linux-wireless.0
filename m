Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39498 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317Ab2GXO4m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jul 2012 10:56:42 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1StgXR-0006Tj-Rp
	for linux-wireless@vger.kernel.org; Tue, 24 Jul 2012 16:56:42 +0200
Message-ID: <1343141801.4415.42.camel@jlt3.sipsolutions.net> (sfid-20120724_165646_313684_3A95150F)
Subject: Re: [PATCH] mac80211: don't react to beacon loss if HW monitoring
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Tue, 24 Jul 2012 16:56:41 +0200
In-Reply-To: <1342636834-5166-1-git-send-email-johannes@sipsolutions.net> (sfid-20120718_204039_311363_FABADB0C)
References: <1342636834-5166-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20120718_204039_311363_FABADB0C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-07-18 at 20:40 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> If the HW is monitoring connection loss (as advertised
> by IEEE80211_HW_CONNECTION_MONITOR) but not filtering
> beacons (IEEE80211_VIF_BEACON_FILTER) then mac80211 will
> still start the beacon loss timer and if a few beacons
> are lost, e.g. due to scanning, drop the connection.
> 
> If the hardware doesn't advertise connection monitoring,
> then it won't drop the connection right away but probe
> the AP, which is intended, but due to the logic in the
> timer when connection monitoring is done it assumes the
> connection was actually lost.
> 
> Fix this problem by not starting the timer when the HW
> does connection monitoring.

Applied for -next

johannes

