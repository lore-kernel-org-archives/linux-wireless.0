Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49116 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab3CVJHo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Mar 2013 05:07:44 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1UIxws-00017L-9R
	for linux-wireless@vger.kernel.org; Fri, 22 Mar 2013 10:07:42 +0100
Message-ID: <1363943249.8238.0.camel@jlt4.sipsolutions.net> (sfid-20130322_100749_993677_E33A6199)
Subject: Re: [PATCH v2 3.9] cfg80211: always check for scan end on P2P device
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Fri, 22 Mar 2013 10:07:29 +0100
In-Reply-To: <1363900367-12036-1-git-send-email-johannes@sipsolutions.net> (sfid-20130321_221258_670247_07D207DE)
References: <1363900367-12036-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130321_221258_670247_07D207DE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-03-21 at 22:12 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> If a P2P device wdev is removed while it has a scan, then the
> scan completion might crash later as it is already freed by
> that time. To avoid the crash always check the scan completion
> when the P2P device is being removed for some reason. If the
> driver already canceled it, don't want and free it, otherwise
> warn and leak it to avoid later crashes.
> 
> In order to do this, locking needs to be changed away from the
> rdev mutex (which can't always be guaranteed). For now, use
> the sched_scan_mtx instead, I'll rename it to just scan_mtx in
> a later patch.

Still broken, in other ways :-(

The locking here is tricky, I think I'll give up on this for 3.9 and
disable P2P Device in iwlmvm there.

johannes

