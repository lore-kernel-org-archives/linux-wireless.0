Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:52920 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654Ab3LESH3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 13:07:29 -0500
Message-ID: <1386266845.4182.21.camel@jlt4.sipsolutions.net> (sfid-20131205_190732_381834_9D39B5BB)
Subject: Re: [PATCH v2 4/4] cfg80211: don't "leak" uncompleted scans
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 05 Dec 2013 19:07:25 +0100
In-Reply-To: <1386261017-5513-1-git-send-email-eliad@wizery.com> (sfid-20131205_173024_110623_DBFDD19F)
References: <1386261017-5513-1-git-send-email-eliad@wizery.com>
	 (sfid-20131205_173024_110623_DBFDD19F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-12-05 at 18:30 +0200, Eliad Peller wrote:
> ___cfg80211_scan_done() can be called in some cases
> (e.g. on NETDEV_DOWN) before the low level driver
> notified scan completion (which is indicated by
> passing leak=true).
> 
> Clearing rdev->scan_req in this case is buggy, as
> scan_done_wk might have already being queued/running
> (and can't be flushed as it takes rtnl()).
> 
> If a new scan will be requested at this stage, the
> scan_done_wk will try freeing it (instead of the
> previous scan), and this will later result in
> a use after free.
> 
> Simply remove the "leak" option, and replace it with
> a standard WARN_ON.

Applied. I guess buggy drivers will then crash, but that's hardly news.

johannes

