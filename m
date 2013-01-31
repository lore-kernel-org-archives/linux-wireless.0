Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:52638 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666Ab3AaQOJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 11:14:09 -0500
Date: Thu, 31 Jan 2013 10:14:04 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [PATCH 2/7] mac80211: Fix tx queue handling during scans
Message-ID: <20130131161404.GC28799@thinkpad-t410> (sfid-20130131_171413_372016_81866123)
References: <1359503255-18270-1-git-send-email-seth.forshee@canonical.com>
 <1359503255-18270-3-git-send-email-seth.forshee@canonical.com>
 <1359645245.8415.72.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1359645245.8415.72.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 31, 2013 at 04:14:05PM +0100, Johannes Berg wrote:
> On Tue, 2013-01-29 at 17:47 -0600, Seth Forshee wrote:
> 
> > +		if (offchan_tx_ok) {
> 
> unlikely(), this is one of the hottest code paths in mac80211 after
> all :-)

Ack, I'll change this for v2.

> > +			/*
> > +			 * Always directly transmit off-channel frames
> > +			 * unless the driver has stopped the queues.
> > +			 */
> > +			if (test_bit(IEEE80211_QUEUE_STOP_REASON_DRIVER,
> > +				     &local->queue_stop_reasons[q])) {
> 
> might there be other reasons to TX, i.e. ignore only
> STOP_REASON_OFFCHANNEL?

I originally wrote it that way, but I'm not sure that all of the stop
reasons need to block tx here. I'll take another look.

> That might be more efficient too:
> 
> offchflag = offchan_tx_ok << log2(STOP_REASON_OFFCHANNEL);
> 
> > +		} else if (local->queue_stop_reasons[q] ||
> 
> if (local->queue_stop_reasons[q] & ~offchflag || ...
> 
> OTOH, I guess you want a different return value too. But that's in a
> relatively unlikely code path again, so might still be better to then
> again differentiate within that if.

Good suggestions, I'll take a look at applying them in some form.

Seth
