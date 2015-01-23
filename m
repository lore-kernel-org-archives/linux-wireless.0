Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35482 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031AbbAWJyl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 04:54:41 -0500
Message-ID: <1422006879.2728.19.camel@sipsolutions.net> (sfid-20150123_105444_634390_0730BCBA)
Subject: Re: [PATCH] mac80211: avoid races related to suspend flow
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 23 Jan 2015 10:54:39 +0100
In-Reply-To: <1421962366-7015-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1421962366-7015-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-01-22 at 23:32 +0200, Emmanuel Grumbach wrote:
> When we go to suspend, there is complex set of states that
> avoids races. The quiescing variable is set whlie
> __ieee80211_suspend is running. Then suspended is set.
> The code makes sure there is no window without any of these
> flags.
> 
> The problem is that workers can still be enqueued while we
> are quiescing. This leads to situations where the driver is
> already suspending and other flows like disassociation are
> handled by a worker.
> 
> To fix this, we need to check quiescing and suspended flags
> in the worker itself and not only before enqueueing it.
> I also add here extensive documentation to ease the
> understanding of these complex issues.

Applied.

johannes

