Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42742 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbaAPOEx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jan 2014 09:04:53 -0500
Message-ID: <1389881089.4345.7.camel@jlt4.sipsolutions.net> (sfid-20140116_150456_635447_F1413670)
Subject: Re: [PATCH] nl80211: Reset split_start when netlink skb is exhausted
From: Johannes Berg <johannes@sipsolutions.net>
To: Pontus Fuchs <pontus.fuchs@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 16 Jan 2014 15:04:49 +0100
In-Reply-To: <1389880840-27863-1-git-send-email-pontus.fuchs@gmail.com> (sfid-20140116_150056_741817_DE840D7C)
References: <1389880840-27863-1-git-send-email-pontus.fuchs@gmail.com>
	 (sfid-20140116_150056_741817_DE840D7C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-01-16 at 15:00 +0100, Pontus Fuchs wrote:
> When the netlink skb is exhausted split_start is left set. In the
> subsequent retry, with a larger buffer, the dump is continued from the
> failing point instead of from the beginning.
> 
> This was causing my rt28xx based USB dongle to now show up when
> running "iw list" with an old iw version without split dump support.

Thanks, applied. I added Cc: stable and Fixes: tags as well as adding "!
state->split" to the conditions.

johannes

