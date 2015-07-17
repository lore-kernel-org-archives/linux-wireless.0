Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51851 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946097AbbGQJF6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2015 05:05:58 -0400
Message-ID: <1437123955.1933.3.camel@sipsolutions.net> (sfid-20150717_110614_486475_B0C53BCA)
Subject: Re: [PATCH] mac80211: don't clear all tx flags when requeing
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless@vger.kernel.org
Date: Fri, 17 Jul 2015 11:05:55 +0200
In-Reply-To: <1435823996-32510-1-git-send-email-michal.kazior@tieto.com> (sfid-20150702_100018_000929_8F93B7A2)
References: <1435823996-32510-1-git-send-email-michal.kazior@tieto.com>
	 (sfid-20150702_100018_000929_8F93B7A2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-07-02 at 09:59 +0200, Michal Kazior wrote:
> When acting as AP and a PS-Poll frame is received
> associated station is marked as one in a Service
> Period. This state is kept until Tx status for
> released frame is reported. While a station is in
> Service Period PS-Poll frames are ignored.
> 
> However if PS-Poll was received during A-MPDU
> teardown it was possible to have the to-be
> released frame re-queued back to pending queue.
> In such case the frame was stripped of 2 important
> flags:
> 
>  (a) IEEE80211_TX_CTL_NO_PS_BUFFER
>  (b) IEEE80211_TX_STATUS_EOSP
> 
> Stripping of (a) led to the frame that was to be
> released to be queued back to ps_tx_buf queue. If
> station remained to use only PS-Poll frames the
> re-queued frame (and new ones) was never actually
> transmitted because mac80211 would ignore
> subsequent PS-Poll frames due to station being in
> Service Period. There was nothing left to clear
> the Service Period bit (no xmit -> no tx status ->
> no SP end), i.e. the AP would have the station
> stuck in Service Period. Beacon TIM would
> repeatedly prompt station to poll for frames but
> it would get none.
> 
> Once (a) is not stripped (b) becomes important
> because it's the main condition to clear the
> Service Period bit of the station when Tx status
> for the released frame is reported back.
> 
> This problem was observed with ath9k acting as P2P
> GO in some testing scenarios but isn't limited to
> it. AP operation with mac80211 based Tx A-MPDU
> control combined with clients using PS-Poll frames
> is subject to this race.

I'm not sure I quite understand - how is the aggregation teardown
causing frame filtering?

johannes
