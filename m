Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:46738 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752210AbZAZXRM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2009 18:17:12 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 26 Jan 2009 15:17:12 -0800
Date: Mon, 26 Jan 2009 15:16:31 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Invalid JP regulatory domain
Message-ID: <20090126231631.GD19242@tesla> (sfid-20090127_001717_461429_42D9DF5D)
References: <200901261730.29555.herton@mandriva.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <200901261730.29555.herton@mandriva.com.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 26, 2009 at 11:30:28AM -0800, Herton Ronaldo Krzesinski wrote:
> Hi,
> 
> While trying to set JP as regulatory domain I get in my kernel log:
> cfg80211: Calling CRDA for country: JP
> cfg80211: Invalid regulatory domain detected:
> cfg80211: Regulatory domain: JP
>         (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
>         (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm)
>         (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
>         (2474000 KHz - 2494000 KHz @ 40000 KHz), (N/A, 2000 mBm)
>         (4910000 KHz - 4930000 KHz @ 10000 KHz), (N/A, 2300 mBm)
>         (4910000 KHz - 4990000 KHz @ 40000 KHz), (N/A, 2300 mBm)
>         (4930000 KHz - 4950000 KHz @ 10000 KHz), (N/A, 2300 mBm)
>         (5030000 KHz - 5045000 KHz @ 10000 KHz), (N/A, 2300 mBm)
>         (5030000 KHz - 5090000 KHz @ 40000 KHz), (N/A, 2300 mBm)
>         (5050000 KHz - 5060000 KHz @ 10000 KHz), (N/A, 2300 mBm)
>         (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
>         (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
>         (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2300 mBm)
> 
> Looks like the check "freq_range->max_bandwidth_khz > freq_diff" fails in
> net/wireless/reg.c (is_valid_reg_rule function) for the second and third
> ranges. Got this with wireless-regdb-2009-01-15 and kernel 2.6.28.1
>
> Is there some error in regulatory domain ranges for JP, or kernel check
> missing something additional?

You are right, the bandwidth was the issue, I'll send a patch now. Thanks for
reporting this!

> I couldn't find proper information about the
> rules.

I'll try add documentation for that, thanks.

  Luis
