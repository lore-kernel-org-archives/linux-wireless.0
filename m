Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56939 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966461Ab3DQPI2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Apr 2013 11:08:28 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1USTyC-0002Vr-PZ
	for linux-wireless@vger.kernel.org; Wed, 17 Apr 2013 17:08:24 +0200
Message-ID: <1366211290.8217.14.camel@jlt4.sipsolutions.net> (sfid-20130417_170832_462951_174C72EB)
Subject: Re: [PATCH] mac80211: fix station entry leak/warning while
 suspending
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Wed, 17 Apr 2013 17:08:10 +0200
In-Reply-To: <1366191727-12395-1-git-send-email-johannes@sipsolutions.net> (sfid-20130417_114220_627188_D0004181)
References: <1366191727-12395-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130417_114220_627188_D0004181)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-04-17 at 11:42 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Since Stanislaw's patches, when suspending while connected,
> cfg80211 will disconnect. This causes the AP station to be
> removed, which uses call_rcu() to clean up. Due to needing
> process context, this queues a work struct on the mac80211
> workqueue. This will warn and fail when already suspended,
> which can happen if the rcu call doesn't happen quickly.
> 
> To fix this, replace the synchronize_net() which is really
> just synchronize_rcu_expedited() with rcu_barrier(), which
> unlike synchronize_rcu() waits until RCU callback have run
> and thus avoids this issue.
> 
> In theory, this can even happen without Stanislaw's change
> to disconnect on suspend since userspace might disconnect
> just before suspending, though then it's unlikely that the
> call_rcu() will be delayed long enough.

Applied.

johannes

