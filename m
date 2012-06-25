Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33350 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757306Ab2FYQFQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2012 12:05:16 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1SjBms-0006ij-N5
	for linux-wireless@vger.kernel.org; Mon, 25 Jun 2012 18:05:14 +0200
Message-ID: <1340640308.27437.16.camel@jlt3.sipsolutions.net> (sfid-20120625_180529_870030_D475B2AD)
Subject: mac80211 auth/assoc in multi-channel scenarios
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 25 Jun 2012 18:05:08 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

Some of us have discussed this before, but I wanted to get some wider
dissemination ...

With multi-channel, one problem that we get is managing the channel
timing for authentication/association. We'll have bound the channel
context (once we have that) before we even send a frame of course, but
setting up the timing as to when to use the channel is very hard, in
particular for connections to P2P GOs that might potentially be asleep.

I see a few obvious choices, open for other suggestions.

1) bring back something like the TX sync API, where the driver sleeps
   until the frame can be transmitted; this is done before every
   transmit
1a) do the same, but asynchronously (somewhat ugly)

2) sleep in sta_state in the driver; this is problematic because while
   we know that the auth frame will be sent right after the AP station
   is created, we don't see the retransmits properly

3) do it in the driver in tx(); this is problematic because it may mean
   delaying the frames quite a bit, and mac80211 might then try to
   retransmit too early etc

4) introduce a sleeping mgmt-tx driver call to send such frames; this is
   ugly in mac80211 code flows with the TX functions

5) do remain-on-channel from mac80211, but this doesn't address P2P GO
   synchronisation requirements

I haven't been able to come up with any other ways, and here we really
don't have much of a choice -- #1 is the only thing that seems sane to
me. Thoughts?

johannes

