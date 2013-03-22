Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49329 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932077Ab3CVK3B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Mar 2013 06:29:01 -0400
Message-ID: <1363948082.8238.9.camel@jlt4.sipsolutions.net> (sfid-20130322_112929_879124_B0D0B907)
Subject: Re: [PATCH 2/2] mac80211:  Make un-found-rate splat a warn-once.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Fri, 22 Mar 2013 11:28:02 +0100
In-Reply-To: <1363727997-1554-2-git-send-email-greearb@candelatech.com> (sfid-20130319_222017_355151_860485B7)
References: <1363727997-1554-1-git-send-email-greearb@candelatech.com>
	 <1363727997-1554-2-git-send-email-greearb@candelatech.com>
	 (sfid-20130319_222017_355151_860485B7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-03-19 at 14:19 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> After that, print it out with net_ratelimit.  We saw a system
> continually hit this warning, for reasons unknown, and it
> seems it bogged the system down enough to make it go OOM.

I'm not really sure I like this ... that points to a deeper problem, and
this just papers over it while causing more cost in the TX path for all
the different checks.

johannes

