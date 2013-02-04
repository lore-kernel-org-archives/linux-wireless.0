Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43396 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756332Ab3BDPm4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2013 10:42:56 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1U2OC7-00035B-4D
	for linux-wireless@vger.kernel.org; Mon, 04 Feb 2013 16:42:55 +0100
Message-ID: <1359992600.10311.25.camel@jlt4.sipsolutions.net> (sfid-20130204_164305_542657_FCAAE275)
Subject: Re: [PATCH] mac80211: start auth/assoc timeout on frame status
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 04 Feb 2013 16:43:20 +0100
In-Reply-To: <1359638935-16613-1-git-send-email-johannes@sipsolutions.net> (sfid-20130131_142837_609017_1B1D23D2)
References: <1359638935-16613-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130131_142837_609017_1B1D23D2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-01-31 at 14:28 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> When sending authentication/association frames they
> might take a bit of time to go out because we may
> have to synchronise with the AP, in particular in
> the case where it's really a P2P GO. In this case
> the 200ms fixed timeout could potentially be too
> short if the beacon interval is relatively large.
> 
> For drivers that report TX status we can do better.
> Instead of starting the timeout directly, start it
> only when the frame status arrives. Since then the
> frame was out on the air, we can wait shorter (the
> typical response time is supposed to be 30ms, wait
> 100ms.) Also, if the frame failed to be transmitted
> try again right away instead of waiting.

Applied.

johannes

