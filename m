Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38953 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933389AbcAZLSV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 06:18:21 -0500
Message-ID: <1453807098.2759.25.camel@sipsolutions.net> (sfid-20160126_121825_272319_41084237)
Subject: Re: [PATCH-v2 2/2] mac80211: ensure association req uses configured
 ratemask.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com, linux-wireless@vger.kernel.org
Date: Tue, 26 Jan 2016 12:18:18 +0100
In-Reply-To: <1445361858-24976-2-git-send-email-greearb@candelatech.com>
References: <1445361858-24976-1-git-send-email-greearb@candelatech.com>
	 <1445361858-24976-2-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-10-20 at 10:24 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> When sending the association request, pay attention to the
> legacy rates configured by the user, and do not advertise support
> for any that are not configured.
> 
> This makes the assoc request packet look more correct when
> making modern hardware act like a /b mode station, for instance.
> 
This is what I meant by "playing whack-a-mole" :)

Next you'll have to fix TDLS too, etc. I feel that overall this is too
complex and we need to address this at a lower level, to actually get
the capabilities that all the code already looks at into the restricted
state you need for this kind of testing.

johannes
