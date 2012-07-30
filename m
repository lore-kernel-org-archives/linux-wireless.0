Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34250 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236Ab2G3HPq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jul 2012 03:15:46 -0400
Message-ID: <1343632539.4452.0.camel@jlt3.sipsolutions.net> (sfid-20120730_091549_508084_7C2C6EB7)
Subject: Re: [PATCH] mac80211: don't clear sched_scan_sdata on sched scan
 stop request
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 30 Jul 2012 09:15:39 +0200
In-Reply-To: <1343568310-20213-1-git-send-email-eliad@wizery.com> (sfid-20120729_152503_674898_57D552C5)
References: <1343568310-20213-1-git-send-email-eliad@wizery.com>
	 (sfid-20120729_152503_674898_57D552C5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-07-29 at 16:25 +0300, Eliad Peller wrote:
> ieee80211_request_sched_scan_stop() cleared
> local->sched_scan_sdata. However, sched_scan_sdata
> should be cleared only after the driver calls
> ieee80211_sched_scan_stopped() (like with normal hw scan).
> 
> Clearing sched_scan_sdata too early, caused
> ieee80211_sched_scan_stopped_work to exit prematurely
> without properly cleaning all the sched scan resources,
> and without calling cfg80211_sched_scan_stopped (so
> userspace wasn't notified about sched scan completion).

Applied, thanks.

johannes

