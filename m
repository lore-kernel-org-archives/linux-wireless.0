Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43092 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933052AbbLPOPn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2015 09:15:43 -0500
Message-ID: <1450275340.8247.18.camel@sipsolutions.net> (sfid-20151216_151647_868188_6F74080E)
Subject: Re: question on "mac80211_hwsim: support any address in userspace"
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Bob Copeland <me@bobcopeland.com>
Date: Wed, 16 Dec 2015 15:15:40 +0100
In-Reply-To: <56717119.1040701@candelatech.com>
References: <5670DA9A.4010102@candelatech.com>
				 (sfid-20151216_042934_976896_DCE1A2B3) <1450257464.3159.1.camel@sipsolutions.net>
			 <56716386.4070107@candelatech.com>
		 <1450272308.8247.11.camel@sipsolutions.net>
		 <567168AF.4060804@candelatech.com>
	 <1450273362.8247.15.camel@sipsolutions.net>
	 <56717119.1040701@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-12-16 at 06:11 -0800, Ben Greear wrote:

> My code expected that the key was the MAC of the radio, not the
> MAC of a vif.  It set up mappings accordingly in the user-space
> program.
> 
> And, if I change a vif's mac address, the previous 'key' is no longer
> valid with the new patch.  If I have multiple vifs on one radio
> and want to send a broadcast pkt to that radio, then at best the
> patched API is lame because you would have to specify the address
> of one of the vifs on the radio, but it is not really destined for
> just that vif.
> 
> A fair bit of code was written, and not just by me, against the
> API that assumed the MAC of the radio was a unique key.  The
> code can be changed of course, but if Bob's change does not
> really offer any advantage, then I think the patch should
> be reverted.
> 

I guess you were trying to be much smarter than wmediumd :)

Bob, any thoughts?

johannes
