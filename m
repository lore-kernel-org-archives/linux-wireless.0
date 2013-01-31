Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55231 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab3AaPNs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 10:13:48 -0500
Message-ID: <1359645245.8415.72.camel@jlt4.sipsolutions.net> (sfid-20130131_161351_675591_C4C8CA53)
Subject: Re: [PATCH 2/7] mac80211: Fix tx queue handling during scans
From: Johannes Berg <johannes@sipsolutions.net>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Date: Thu, 31 Jan 2013 16:14:05 +0100
In-Reply-To: <1359503255-18270-3-git-send-email-seth.forshee@canonical.com>
References: <1359503255-18270-1-git-send-email-seth.forshee@canonical.com>
	 <1359503255-18270-3-git-send-email-seth.forshee@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-01-29 at 17:47 -0600, Seth Forshee wrote:

> +		if (offchan_tx_ok) {

unlikely(), this is one of the hottest code paths in mac80211 after
all :-)

> +			/*
> +			 * Always directly transmit off-channel frames
> +			 * unless the driver has stopped the queues.
> +			 */
> +			if (test_bit(IEEE80211_QUEUE_STOP_REASON_DRIVER,
> +				     &local->queue_stop_reasons[q])) {

might there be other reasons to TX, i.e. ignore only
STOP_REASON_OFFCHANNEL?

That might be more efficient too:

offchflag = offchan_tx_ok << log2(STOP_REASON_OFFCHANNEL);

> +		} else if (local->queue_stop_reasons[q] ||

if (local->queue_stop_reasons[q] & ~offchflag || ...

OTOH, I guess you want a different return value too. But that's in a
relatively unlikely code path again, so might still be better to then
again differentiate within that if.

johannes

