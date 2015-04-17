Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46686 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753581AbbDQLZP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Apr 2015 07:25:15 -0400
Message-ID: <1429269912.1885.4.camel@sipsolutions.net> (sfid-20150417_132526_837779_BA62F838)
Subject: Re: [RFC] mac80211_hwsim: notify user-space about channel change.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 17 Apr 2015 13:25:12 +0200
In-Reply-To: <552E7E70.5070101@candelatech.com>
References: <1424217588-29558-1-git-send-email-greearb@candelatech.com>
				  	  (sfid-20150218_005956_617537_D2A9B91F) <1424692155.2782.6.camel@sipsolutions.net>
				  	 <54EB66CC.1030800@candelatech.com>
				   <1424772714.2192.16.camel@sipsolutions.net>
				   <54EC8C5D.5090400@candelatech.com>
				  <1424788834.2192.34.camel@sipsolutions.net>
				  <5500AE12.6040103@candelatech.com>
				 <1427812067.2057.27.camel@sipsolutions.net>
				 <551AC3B6.1040001@candelatech.com>
			 <1428999215.3019.6.camel@sipsolutions.net>
			 <552D2A90.1070307@candelatech.com>
		 <1429023990.3019.15.camel@sipsolutions.net>
		 <552D386E.40306@candelatech.com>
	 <1429090400.1784.2.camel@sipsolutions.net>
	 <552E7E70.5070101@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-04-15 at 08:06 -0700, Ben Greear wrote:
[...]
> > The issue is that with your patch in this can't be addressed in
> > follow-on patches as it fixes the userspace API.
> 
> Ok, so adding an additional 'uint16 ctx' to the channel change data,
> and providing a 'type' field that includes start-using, stop-using
> would address this problem adequately?
> 
> Start-using seems it would be the same as change-channel, or do I need
> a type for that as well?

Yeah that seems reasonble. You'd need to store the ctx id in the actual
chanctx struct in hwsim I guess (and unconditionally use 0 for the
non-chanctx case)

I'm not sure we should conflate start-using and change-channel,
userspace might have to set up data structures if it really wants to
track multiple channels, so having a separate start-using might be
easier?

johannes

