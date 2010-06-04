Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59536 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab0FDK2X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jun 2010 06:28:23 -0400
Subject: Re: rt2800, minstrel_ht & mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Felix Fietkau <nbd@openwrt.org>, Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <201006041222.49820.helmut.schaa@googlemail.com>
References: <201006041222.49820.helmut.schaa@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Jun 2010 12:28:21 +0200
Message-ID: <1275647301.9953.20.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-06-04 at 12:22 +0200, Helmut Schaa wrote:

> This meant that minstrel most of the time selected MCS15 as tx rate which
> resulted in a huge number of retries and thus a very slow throughput.
> 
> status.c:
> 
> 178                 /* the HW cannot have attempted that rate */
> 179                 if (i >= hw->max_rates) {
> 180                         info->status.rates[i].idx = -1;
> 181                         info->status.rates[i].count = 0;
> 
> Johannes, is there a valid reason for this check in status.c. Can we remove
> it without breaking anything else?

IIRC there were/are some drivers that were not terminating the rates[]
array correctly with a -1, thus this code.

> What other options would we have to fix this issue? Just use max_rates = 4 
> in rt2800 even if we will only use the first rate provided by minstrel and
> then fall back to the global fallback setup (I tried that already and it
> works just fine but seems not correct to me)?

p54 kinda does some trickery in this area too, not really sure what to
do though.

johannes

