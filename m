Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60347 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbbA0JBg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2015 04:01:36 -0500
Message-ID: <1422349293.1890.54.camel@sipsolutions.net> (sfid-20150127_100139_580414_1EC5D6E8)
Subject: Re: [PATCH] mac80211: handle potential race between suspend and
 scan completion
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 27 Jan 2015 10:01:33 +0100
In-Reply-To: <1422088202-31871-1-git-send-email-luca@coelho.fi>
References: <1422088202-31871-1-git-send-email-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2015-01-24 at 10:30 +0200, Luca Coelho wrote:
> From: Luciano Coelho <luciano.coelho@intel.com>
> 
> If suspend starts while ieee80211_scan_completed() is running, between
> the point where SCAN_COMPLETED is set and the work is queued,
> ieee80211_scan_cancel() will not catch the work and we may finish
> suspending before the work is actually executed, leaving the scan
> running while suspended.
> 
> To fix this race, queue the scan work during resume if the
> SCAN_COMPLETED flag is set and flush it immediately.

Applied. I've put it into mac80211-next, we can look later if we should
send it to various stable trees.

johannes

