Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47757 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752184AbcF1UEL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jun 2016 16:04:11 -0400
Message-ID: <1467144189.2493.19.camel@sipsolutions.net> (sfid-20160628_220443_971900_C5F7864A)
Subject: Re: [PATCH] mac80211:  ensure info->control.vif is set for queued
 pkts.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
	linux-wireless@vger.kernel.org
Date: Tue, 28 Jun 2016 22:03:09 +0200
In-Reply-To: <57728EB2.2030706@candelatech.com> (sfid-20160628_165029_450743_D8773180)
References: <1466015073-8418-1-git-send-email-greearb@candelatech.com>
	 <1467122419.2493.18.camel@sipsolutions.net>
	 <57728EB2.2030706@candelatech.com> (sfid-20160628_165029_450743_D8773180)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-06-28 at 07:50 -0700, Ben Greear wrote:

> So, maybe a WARN_ON would be appropriate at the place frames are
> enqueued in the backlog queue?  Since this patch did fix my problem,
> maybe that WARN_ON would show the path that allow frames with bad
> control.vif to be inserted?

Yeah that might make sense, if you're willing to test that.

> I had also found another problem with pktgen using the headroom
> wrong, so possibly that would have also fixed my problem..I'm not
> sure which patch I put in first.
> 

That seems very unlikely to be related.

johannes
