Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35497 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754196AbbAWJzK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 04:55:10 -0500
Message-ID: <1422006905.2728.20.camel@sipsolutions.net> (sfid-20150123_105513_871395_8DC36486)
Subject: Re: [PATCH] mac80211: complete scan work immediately if quiesced or
 suspended
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org,
	Luciano Coelho <luciano.coelho@intel.com>
Date: Fri, 23 Jan 2015 10:55:05 +0100
In-Reply-To: <1421962450-7096-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1421962450-7096-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-01-22 at 23:34 +0200, Emmanuel Grumbach wrote:
> From: Luciano Coelho <luciano.coelho@intel.com>
> 
> It is possible that a deferred scan is queued after the queues are
> flushed in __ieee80211_suspend().  The deferred scan work may be
> scheduled by ROC or ieee80211_stop_poll().
> 
> To make sure don't start a new scan while suspending, check whether
> we're quiescing or suspended and complete the scan immediately if
> that's the case.

Applied.

> Change-Id: I8ec2c8fb4d969833d45c77045b0f5594cc097086
> Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
> Reviewed-on: https://gerrit.rds.intel.com/r/51405
> Tested-by: IWL Jenkins
> Reviewed-by: Johannes Berg <johannes.berg@intel.com>

With all that fixed :)

johannes

