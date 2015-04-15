Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33411 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754134AbbDOJd0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2015 05:33:26 -0400
Message-ID: <1429090400.1784.2.camel@sipsolutions.net> (sfid-20150415_113330_085328_B36F79CA)
Subject: Re: [RFC] mac80211_hwsim: notify user-space about channel change.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 15 Apr 2015 11:33:20 +0200
In-Reply-To: <552D386E.40306@candelatech.com>
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
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-04-14 at 08:55 -0700, Ben Greear wrote:

> > True, although I'd like to see the multi-channel issue addressed better.
> 
> I need a hint or two on what exactly you want changed in my patch to
> address your request, or maybe you or someone else can just address
> the issue in follow-on patches?

So right now you're basically saying to userspace "switch to channel X".
But that's not really how the more generic system works, that's more
"start using channel X (ctx=1)" / "stop using channel X (ctx=1)" /
"change channel to X (ctx=1)" and similar.

It seems to me that such an API should probably be the only API to
userspace. The non-chanctx case in hwsim could simply fake it by
starting with "start using channel X (ctx=0)" and then changing that
channel all the time.

The issue is that with your patch in this can't be addressed in
follow-on patches as it fixes the userspace API.

johannes

