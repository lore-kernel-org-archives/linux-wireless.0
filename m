Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44738 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203Ab0I0Kvn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 06:51:43 -0400
Subject: Re: [PATCH] wireless:  make phy naming independent of phy index.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@gmail.com
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
In-Reply-To: <1285478921-5891-1-git-send-email-greearb@candelatech.com>
References: <1285478921-5891-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Sep 2010 12:51:40 +0200
Message-ID: <1285584700.4043.13.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2010-09-25 at 22:28 -0700, greearb@gmail.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> The recent patch that re-used phy indexes on module reload
> could cause races.  Instead, increment phy-index monitomically
> for each new phy, but choose the first phy%d name that is
> available.
> 
> Also, allow users to rename a phy to any un-used name, including
> phy%d.

You lost the wiphy_counter-- because you'd first removed it and now
reverted that patch ... it'd be easier to review if you actually did a
new patch on top of the revert.

The wiphy_counter-- seems necessary to avoid potential wrapping and then
re-using phy index 0 (yeah, you'd have to have an immense amount of phy
registration going on ... but still)

johannes

