Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:51532 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751221AbcAEJpK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2016 04:45:10 -0500
Date: Tue, 5 Jan 2016 11:45:04 +0200
From: Jouni Malinen <j@w1.fi>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH] mac80211: add use_minrate param to
 ieee80211_tx_prepare_skb()
Message-ID: <20160105094504.GA3015@w1.fi> (sfid-20160105_104515_723338_CE20DB1B)
References: <1451984419-5727-1-git-send-email-janusz.dziedzic@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1451984419-5727-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 05, 2016 at 10:00:19AM +0100, Janusz Dziedzic wrote:
> Add use_minrate param to ieee80211_tx_prepare_skb() function.
> This is useful in case we would like to send frames
> with lowest rates, eg. nullfunc, probe_resp.

I could kind of understand this for short frames like Data nullfunc and
PS-Poll, but why would we like to hard code Probe Response frames to be
sent at the lowest rate? Shouldn't the frames be sent at a rate that is
most likely to get them through and do so in a manner that does not use
excessive amount of air time?

-- 
Jouni Malinen                                            PGP id EFC895FA
