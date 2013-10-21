Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:60484 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323Ab3JUNEi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Oct 2013 09:04:38 -0400
Message-ID: <1382360675.14310.46.camel@jlt4.sipsolutions.net> (sfid-20131021_150442_019482_26A943CA)
Subject: Re: [PATCH 1/2] cfg80211: fix DFS channel recovery timeout
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 21 Oct 2013 15:04:35 +0200
In-Reply-To: <1382034072-13541-1-git-send-email-michal.kazior@tieto.com> (sfid-20131017_202343_478343_163A6A5A)
References: <1382034072-13541-1-git-send-email-michal.kazior@tieto.com>
	 (sfid-20131017_202343_478343_163A6A5A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-10-17 at 11:21 -0700, Michal Kazior wrote:
> The timeout was not properly converted from msecs
> to jiffies. As a result channel transition to
> NL80211_DFS_USABLE was delayed depending on
> CONFIG_HZ configuration, e.g. HZ=100 would delay
> the NOP from 30 minutes to 300 minutes.

Applied both, but I think getting into 3.12 might be hard.

johannes

