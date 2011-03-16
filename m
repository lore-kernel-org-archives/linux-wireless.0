Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52664 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab1CPIUP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2011 04:20:15 -0400
Subject: Re: [PATCH] mac80211: fix aggregation frame release during timeout
From: Johannes Berg <johannes@sipsolutions.net>
To: Daniel Halperin <dhalperi@cs.washington.edu>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <507B31BE-2066-4434-870D-108F7DF912A6@cs.washington.edu>
References: <507B31BE-2066-4434-870D-108F7DF912A6@cs.washington.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Mar 2011 09:21:56 +0100
Message-ID: <1300263716.3761.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-03-15 at 16:49 -0700, Daniel Halperin wrote:

> x-T-R1-y-R2,

>  			if (!time_after(jiffies, tid_agg_rx->reorder_time[j] +
> -					HT_RX_REORDER_BUF_TIMEOUT))
> +					HT_RX_REORDER_BUF_TIMEOUT) && skipped)

Wait, your previous example of xT---R worked fine, but if you say x-T-
this patch won't work I think? Basically you're saying if we received
frames 2 and 4 after 3, and 3 times out, we can release 2 through 4. I
agree, but your code won't do that since skipped starts out at 1 due to
the first x. Or am I misreading this?

johannes

