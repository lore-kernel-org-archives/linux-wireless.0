Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f225.google.com ([209.85.218.225]:53204 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122AbZGAIJj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2009 04:09:39 -0400
Received: by bwz25 with SMTP id 25so341684bwz.37
        for <linux-wireless@vger.kernel.org>; Wed, 01 Jul 2009 01:09:41 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: Some thoughts about background scanning
Date: Wed, 1 Jul 2009 10:03:49 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200907011003.49857.helmut.schaa@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey,

just thought a bit about background scanning (not triggering scans at
any time but just hopping back to the operating channel once in a while
to allow RX/TX).

My current approach is quite easy but works well: Extend the scan state
machine with a new state (OPERATION) which restores the channel and the
correct filter flags and notifies the AP that we're back. The state
machine moves there after every scanned channel. The result is that
the complete scan can take quite some time, something a round 15 seconds.
Scanning multiple channels before switching back would allow us to
reduce the amount of time the scan takes. So, what I'd like to have is
integration with pm_qos in order to determine how much channels may be
scanned at once before we have to switch back. Shouldn't be that
difficult ;) However, the current scan state machine is very inflexible
and I'd have to add a lot of ugly stuff to make it work really good (at
least that's my impression currently).

So, a completely new approach would be to pre-compute all necessary scan
states. Based on the cfg80211 scan request, the current pm_qos values
and the beacon characteristics we could derive a table of necessary scan
states and extend it by operation states. 

For example:
Channel 1, Active Scan, 30ms
Channel 2, Active Scan, 30ms
Channel 3, Active Scan, 30ms
Channel 4, Active Scan, 30ms
Channel 11, Operation Mode, 120ms
Channel 52, Passive Scan, 120ms
Channel 11, Operation Mode, 120ms
...

Advantages:

We could split the actual scan algorithm out of the scan state machine,
for example if pm_qos allows us to stay away for 150ms we could reorder
the channels to scan one active channel followed by one passive channel
before switching back to the operating channel. Should allow us to use
all sorts of insane optimizations.

Disadvantages:

If we compute the table while we're associated but lose association in
the middle of the scan we would either have to update the scan table to
reflect the current state or leave it as is which of course lengthens the
scan. And of course we need more memory to store the table.

In some cases we might shorten the pre-computed values. For example if
we switch back to the operating channel and receive a beacon without
TIM being set for our association and our TX queue is empty we might
immediately proceed with the scan without having to stay on the channel
for the full amount of time. Not sure if we can do this properly without
recomputing the whole table (depends on the actual algorithm used).

I'd like to first get some comments on that idea before thinking about
implementing it :)

Does that kind of approach sound useful? Is it overkill?

Thanks,
Helmut
