Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47244 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab0FDKXI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jun 2010 06:23:08 -0400
Received: by bwz11 with SMTP id 11so328533bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 04 Jun 2010 03:23:04 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: rt2800, minstrel_ht & mac80211
Date: Fri, 4 Jun 2010 12:22:49 +0200
Cc: Felix Fietkau <nbd@openwrt.org>, Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201006041222.49820.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

While working on throughput problems with some mcs rates on rt2800 cards I've
noticed a strange issue between rt2800, minstrel_ht and mac80211.

Despite the fact that rt2800 always reported MCS15 as _not_ successful (and
it was really never successful), minstrel_ht's rc_stats always claimed that
the attempt was successful.

rt2800 has a global rate fallback table (something like MCS15 -> MCS14 ->
MCS13 ...), so it is capable of trying a frame at different rates but we
cannot specify the rates to be used for every single frame. Hence, rt2800
does not set hw->max_rates and thus ends up with max_rates = 1 but since
rt2800 will try different rates it will fill the tx status with all the rates
it really tried.

Unfortunately, mac80211 (status.c) decides to drop all reported rates >=
max_rates and thus we end up with minstrel_ht thinking that MCS15 was
successful while rt2800 reported that it tried MCS15,14,13 and 12 was
finally successful.

This meant that minstrel most of the time selected MCS15 as tx rate which
resulted in a huge number of retries and thus a very slow throughput.

status.c:

178                 /* the HW cannot have attempted that rate */
179                 if (i >= hw->max_rates) {
180                         info->status.rates[i].idx = -1;
181                         info->status.rates[i].count = 0;

Johannes, is there a valid reason for this check in status.c. Can we remove
it without breaking anything else?

What other options would we have to fix this issue? Just use max_rates = 4 
in rt2800 even if we will only use the first rate provided by minstrel and
then fall back to the global fallback setup (I tried that already and it
works just fine but seems not correct to me)?

Thanks,
Helmut
