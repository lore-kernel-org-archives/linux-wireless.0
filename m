Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49036 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767Ab2AQNEf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jan 2012 08:04:35 -0500
Subject: Re: [PATCH] mac80211: Remove dummy STA on deauth
From: Johannes Berg <johannes@sipsolutions.net>
To: Pontus Fuchs <pontus.fuchs@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1326795577-29650-1-git-send-email-pontus.fuchs@gmail.com> (sfid-20120117_111950_717206_DA4AE268)
References: <1326795577-29650-1-git-send-email-pontus.fuchs@gmail.com>
	 (sfid-20120117_111950_717206_DA4AE268)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Jan 2012 14:04:33 +0100
Message-ID: <1326805473.3342.16.camel@jlt3.sipsolutions.net> (sfid-20120117_140439_151455_6D35A685)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-01-17 at 11:19 +0100, Pontus Fuchs wrote:
> Under certain conditions a dummy STA entry could be left in the
> station list.

This happens when a deauth is requested while associating.

>  This causes subsequent connection attempts to fail.
> 
> Logs look like this:
> 
> authenticate with 00:23:69:aa:dd:7b (try 1)
> authenticated
> failed to insert Dummy STA entry for the AP (error -17)
> deauthenticating from 00:23:69:aa:dd:7b by local choice (reason=2)
> 
> Fix this by making sure to remove the dummy STA on deauth.
> 
> Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
> ---
> 
> The problem was introduced by the following commit added in v3.1:
> mac80211: fix race condition between assoc_done and first EAP packet
> 
> This problem is fixed in the recent patch series from 
> Johannes Berg: [PATCH 0/8] more station handling refactoring
> 
> If you need a smaller fix this might fit you.

It doesn't fit me :-)
Could you please make a fix that also fixes the missing
finish_tx_sync()?

Also, I think the code should be moved to the right place inside the
work cancelling in mgd_deauth().

johannes

