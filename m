Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55026 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756129Ab3CGPro (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Mar 2013 10:47:44 -0500
Message-ID: <5138B69C.4000102@openwrt.org> (sfid-20130307_164747_637911_6E96FF86)
Date: Thu, 07 Mar 2013 16:47:40 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
CC: linux-wireless@vger.kernel.org, thomas@net.t-labs.tu-berlin.de,
	johannes@sipsolutions.net,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: Re: Question regarding minstrel(_ht) and retry limits
References: <20130307153100.GA30608@pandem0nium>
In-Reply-To: <20130307153100.GA30608@pandem0nium>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-03-07 4:31 PM, Simon Wunderlich wrote:
> Hello list,
> 
> as you might be aware, it is possible to set short and long retry limits
> to specify how often a frame should be retransmitted before getting dropped.
> 
> However, it appears that minstrel completely ignores any retry limit, and it is
> also not applied later in the code path. I've hacked minstrel_ht a little bit
> to apply the retry limits in minstrel_get_rate() before returning the rates
> (i.e. just cutting retries at the end from the struct ieee80211_tx_rate array).
> 
> This worked for me, but is probably not clean either and might disturb minstrel
> operation. Also minstrel uses much more retries than default retry limits
> (short: 7, long: 4), so this patch might introduce behaviour changes.
> 
> What is your opinion on this? Can we get it properly supported? Does it hurt
> to just use the first $retry_limit retries, and cut the rest at other rates
> at the end?
I think simply cutting off from the end of the retry chain is a bad idea
- if there are too many scheduled retries in the max throughput rate, it
will not make it to the fallback to a reliable rate if that fails. A
better approach is to make minstrel use fewer retries per rate.

- Felix

