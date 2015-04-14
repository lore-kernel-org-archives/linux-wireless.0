Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56877 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754098AbbDNPGd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Apr 2015 11:06:33 -0400
Message-ID: <1429023990.3019.15.camel@sipsolutions.net> (sfid-20150414_170636_623307_EB650C0A)
Subject: Re: [RFC] mac80211_hwsim: notify user-space about channel change.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 14 Apr 2015 17:06:30 +0200
In-Reply-To: <552D2A90.1070307@candelatech.com>
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
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-04-14 at 07:56 -0700, Ben Greear wrote:

> > Well, the question isn't really that offloading, the question is what
> > happens with the hw-scan logic in hwsim? Though I guess now that I think
> > about it, that wouldn't show up in userspace at all with your changes.
> 
> I think for HW scan and related matters, you treat user-space like a firmware
> target, so you send it a message, and then get some response or action, similar
> to how you would request ath10k or some USB dongle NIC to do things for you.

That's not really how it works today, but it's one possible (probably
the only possible) approach.

> My own interest in hwsim user-space is to make it act more like ath9k
> than a firmware target driver, but I don't think my changes preclude doing
> target based emulation in the future.

True, although I'd like to see the multi-channel issue addressed better.

johannes

