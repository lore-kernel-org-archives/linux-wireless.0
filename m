Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f48.google.com ([209.85.214.48]:64273 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932713Ab3CGPn0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Mar 2013 10:43:26 -0500
Received: by mail-bk0-f48.google.com with SMTP id jf20so282863bkc.21
        for <linux-wireless@vger.kernel.org>; Thu, 07 Mar 2013 07:43:25 -0800 (PST)
Date: Thu, 7 Mar 2013 16:40:45 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, nbd@openwrt.org,
	thomas@net.t-labs.tu-berlin.de, johannes@sipsolutions.net,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: Re: Question regarding minstrel(_ht) and retry limits
Message-ID: <20130307154045.GB29428@magnum.frso.rivierawaves.com> (sfid-20130307_164333_935293_957B0A1A)
References: <20130307153100.GA30608@pandem0nium>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20130307153100.GA30608@pandem0nium>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 07, 2013 at 04:31:00PM +0100, Simon Wunderlich wrote:
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
> 
BTW, it also ignores max_rate_tries < 3 and rts thresholds.
 
Karl

