Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54615 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755915Ab3I3KhJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Sep 2013 06:37:09 -0400
Message-ID: <1380537426.14467.9.camel@jlt4.sipsolutions.net> (sfid-20130930_123733_694484_20C41396)
Subject: Re: [PATCH] mac80211: Run deferred scan if last roc_list item is
 not started
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 30 Sep 2013 12:37:06 +0200
In-Reply-To: <20130930093605.GA23614@w1.fi>
References: <20130930093605.GA23614@w1.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-09-30 at 12:36 +0300, Jouni Malinen wrote:
> mac80211 scan processing could get stuck if roc work for pending, but
> not started when a scan request was deferred due to such roc item.
> Normally the deferred scan would be started from
> ieee80211_start_next_roc(), but ieee80211_sw_roc_work() calls that only
> if the finished ROC was started. Fix this by calling
> ieee80211_run_deferred_scan() in the case the last ROC was not actually
> started.
> 
> This issue was hit relatively easily in P2P find operations where Listen
> state (remain-on-channel) and Search state (scan) are repeated in a
> loop.

Applied.

johannes

