Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:50804 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbcHKT2A (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2016 15:28:00 -0400
Subject: Re: [PATCH 1/2] ath9k: use ieee80211_tx_status_noskb where possible
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>,
	linux-wireless@vger.kernel.org
References: <20160804214940.78476-1-nbd@nbd.name>
 <8aeb7913-d955-d894-d82c-4614e17d3ee4@neratec.com>
Cc: kvalo@codeaurora.org
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <9e324227-f105-bc16-f0c0-c2a3a79032e8@nbd.name> (sfid-20160811_212830_736159_6952AD06)
Date: Thu, 11 Aug 2016 21:27:55 +0200
MIME-Version: 1.0
In-Reply-To: <8aeb7913-d955-d894-d82c-4614e17d3ee4@neratec.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-08-11 18:05, Zefir Kurtisi wrote:
> On 08/04/2016 11:49 PM, Felix Fietkau wrote:
>> It removes the need for undoing the padding changes to skb->data and it
>> improves performance by eliminating one tx status lookup per MPDU in the
>> status path. It is also useful for preparing a follow-up fix to better
>> handle powersave filtering.
>> 
> 
> For me, this one introduces a regression to the statistics, e.g.
> 'dot11TransmittedFragmentCount' is now accounted differently since it is not
> updated from within ieee80211_tx_status_noskb().
Is this important? I guess it would be possible to make this more
accurate by extending the API, but I wonder if that's worth doing just
for these debugfs counters.

- Felix

