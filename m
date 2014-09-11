Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55904 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753776AbaIKKJp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2014 06:09:45 -0400
Message-ID: <1410430180.1825.10.camel@jlt4.sipsolutions.net> (sfid-20140911_120948_117448_7AC5BEF3)
Subject: Re: [PATCH v2 2/2] mac80211: improve minstrel_ht rate sorting by
 throughput & probability
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	nbd@nbd.name, ikstream86@gmail.com
Date: Thu, 11 Sep 2014 12:09:40 +0200
In-Reply-To: <1410297734-21187-3-git-send-email-thomas@net.t-labs.tu-berlin.de>
References: <1410297734-21187-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
	 <1410297734-21187-3-git-send-email-thomas@net.t-labs.tu-berlin.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-09-09 at 23:22 +0200, Thomas Huehn wrote:
> This patch improves the way minstrel_ht sorts rates according to throughput
> and success probability. 3 FOR-loops across the entire rate and mcs group set
> in function minstrel_ht_update_stats() which where used to determine the
> fastest, second fastest and most robust rate are reduced to 2 FOR-loop.
> 
> The sorted list of rates according throughput is extended to the best four
> rates as we need them in upcoming joint rate and power control. The sorting
> is done via the new function minstrel_ht_sort_best_tp_rates(). The annotation
> of those 4 best throughput rates in the debugfs file rc-stats is changes to:
> "A,B,C,D", where A is the fastest rate and C the 4th fastest.
> 
> ---
> v2: fix coding style issues, thx the Felix Fietkau
> 
> Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
> Tested-by: Stefan Venz <ikstream86@gmail.com>

The S-o-b etc. should be *before* the --- cutoff ... I'll fix it
manually this time.

johannes

