Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:40694 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab3EXU06 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 May 2013 16:26:58 -0400
Message-ID: <1369427208.8290.35.camel@jlt4.sipsolutions.net> (sfid-20130524_222702_045026_3AB62EF6)
Subject: Re: [RFT/RFC 0/4] iwlegacy: workaround for firmware frame tx
 rejection
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org, Jake Edge <jake@lwn.net>
Date: Fri, 24 May 2013 22:26:48 +0200
In-Reply-To: <1369311660-15378-1-git-send-email-sgruszka@redhat.com>
References: <1369311660-15378-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-05-23 at 14:20 +0200, Stanislaw Gruszka wrote:
> Jake, please test this set and check if it not cause association
> problems you reported earlier this month.
> 
> Please apply it together with this mac80211 patch:
> http://marc.info/?l=linux-wireless&m=136879090123023&w=2 
> which I already posted and is queued to upstream. Not having
> it may cause troubles and influence negatively this set test.
> 
> Johannes, is need to check beacon bssid or even if rx frame
> is a beacon to unblock queues? I think if we receive any frame
> (not necessary beacon or our bssid beacon) on passive channel,
> that mean we can use that channel. But that depend how firmware
> is implemented, if firmware require our bssid beacon to unblock
> channel, driver of course need that too.

I _think_ any frame with good CRC will do, but I'm not entirely sure for
3945/4965.

johannes

