Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55269 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610Ab3AaPP1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 10:15:27 -0500
Message-ID: <1359645350.8415.74.camel@jlt4.sipsolutions.net> (sfid-20130131_161531_332406_C94EFA0D)
Subject: Re: [PATCH 3/7] mac80211: Improve error handling for off-channel
 operation
From: Johannes Berg <johannes@sipsolutions.net>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Date: Thu, 31 Jan 2013 16:15:50 +0100
In-Reply-To: <1359503255-18270-4-git-send-email-seth.forshee@canonical.com>
References: <1359503255-18270-1-git-send-email-seth.forshee@canonical.com>
	 <1359503255-18270-4-git-send-email-seth.forshee@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-01-29 at 17:47 -0600, Seth Forshee wrote:
> Errors in sending nullfunc or probe request frames during off-channel
> operation may have undesirable consequences, e.g. failure to set
> powersave at the AP. Add error handling for failures to transmit these
> frames. In the case of a nullfunc failure, fail to go off-channel and
> return an error to userspace. In the case of a failed probe request,
> abort the scan.

That latter part seems excessive? Maybe increase the time to use a
passive scan? But if there are multiple scan requests ...

Is all of this really worth the effort? The driver queues should be
empty after the flush, after all, and the driver doesn't return any TX
status. So what can really happen?

johannes

