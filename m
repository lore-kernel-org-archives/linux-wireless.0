Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33949 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736Ab0FXNWX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jun 2010 09:22:23 -0400
Received: by bwz7 with SMTP id 7so212702bwz.19
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jun 2010 06:22:20 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: rt2x00 & mac80211: correct usage of ieee80211_beacon_get_tim?
Date: Thu, 24 Jun 2010 15:21:47 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201006241521.47623.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I've just reviewed the beacon handling in rt2x00 in AP mode and experienced
some inconsistencies. The DTIM count is not correctly updated: sometimes
multiple beacons are sent out using the same DTIM count.

rt2x00 calls ieee80211_beacon_get_tim right after the current beacon was
sent out to fetch the next one. However, rt2x00 also implements the set_tim
callback and updates the beacon in each call to set_tim. As far as I
understood the code in mac80211 the set_tim callback is called when the
first frame for a powersaving station gets queued.

Since every call to ieee80211_beacon_get_tim updates the DTIM count the
following can happen (assuming a DTIM period of 2):

- the hw sends out the current beacon (DTIM count == 0)
- call to ieee80211_beacon_get_tim fetches the next beacon (DTIM count == 1)
- the first frame for a PS STA gets queued -> set_tim
- again call ieee80211_beacon_get_tim (DTIM count == 0)
- hw sends out the beacon with incorrect DTIM count

A proper way of fixing this issue would be not to use the set_tim callback but
just fetch the next beacon right before it gets send out (like ath* does).
However, that's not easily possible with rt2x00 devices older then rt2800 as
they only generate beacon_done interrupts (which is obviously too late for
fetching the current beacon ;) ).

So, is the current implementation in rt2x00 supposed to work and mac80211
needs fixing?

Could we add a parameter to ieee80211_beacon_get_tim that indicates if a _new_
beacon should be generated or if the _current_ beacon should be updated in
response to the set_tim callback?

Any other ideas?

Thanks,
Helmut
