Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59717 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab2EVSnV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 May 2012 14:43:21 -0400
Message-ID: <1337712171.4470.2.camel@jlt3.sipsolutions.net> (sfid-20120522_204326_145855_A1C41682)
Subject: Re: [PATCH v1] mac80211: Handle race condition in replay handling
From: Johannes Berg <johannes@sipsolutions.net>
To: Amit Shakya <amit.shakya@stericsson.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 22 May 2012 20:42:51 +0200
In-Reply-To: <1337672239-27902-1-git-send-email-amit.shakya@stericsson.com>
References: <1337672239-27902-1-git-send-email-amit.shakya@stericsson.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-05-22 at 13:07 +0530, Amit Shakya wrote:

> As a result, when this change in sequence number happens, the
> replay detection handling in MAC gets triggered, causing the
> traffic to stops for some while till PN re-match, with the
> one last updated at MAC.
> 
> The fix takes care of selectively updating the Rx PN during
> this transition phase.

This is still all wrong. If anything, the proper fix should be to leave
the old key around and have the driver somehow indicate which key was
used so the PN comparison can be done against the old key. That would
also solve the problem generically, not just for CCMP in a very hacky
way.

johannes

