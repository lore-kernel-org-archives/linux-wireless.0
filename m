Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:52662 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613Ab3AaQRQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 11:17:16 -0500
Date: Thu, 31 Jan 2013 10:17:13 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [PATCH 3/7] mac80211: Improve error handling for off-channel
 operation
Message-ID: <20130131161713.GD28799@thinkpad-t410> (sfid-20130131_171720_386572_34C014BA)
References: <1359503255-18270-1-git-send-email-seth.forshee@canonical.com>
 <1359503255-18270-4-git-send-email-seth.forshee@canonical.com>
 <1359645350.8415.74.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1359645350.8415.74.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 31, 2013 at 04:15:50PM +0100, Johannes Berg wrote:
> On Tue, 2013-01-29 at 17:47 -0600, Seth Forshee wrote:
> > Errors in sending nullfunc or probe request frames during off-channel
> > operation may have undesirable consequences, e.g. failure to set
> > powersave at the AP. Add error handling for failures to transmit these
> > frames. In the case of a nullfunc failure, fail to go off-channel and
> > return an error to userspace. In the case of a failed probe request,
> > abort the scan.
> 
> That latter part seems excessive? Maybe increase the time to use a
> passive scan? But if there are multiple scan requests ...
> 
> Is all of this really worth the effort? The driver queues should be
> empty after the flush, after all, and the driver doesn't return any TX
> status. So what can really happen?

Hmm, yeah, maybe it is a bit excessive. The idea of falling back to a
passive scan is interesting though. I'll rip out the scan abort stuff
for v2 and think about doing the passive scan fallback as a future
enhancement.

Seth
