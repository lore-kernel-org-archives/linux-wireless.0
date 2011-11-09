Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33621 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab1KINI6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Nov 2011 08:08:58 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.77)
	(envelope-from <johannes@sipsolutions.net>)
	id 1RO7th-0001UE-Cu
	for linux-wireless@vger.kernel.org; Wed, 09 Nov 2011 14:08:57 +0100
Subject: off- & multi-channel operation
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Nov 2011 14:08:54 +0100
Message-ID: <1320844134.3845.61.camel@jlt3.sipsolutions.net> (sfid-20111109_140902_212963_943EDBDE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All,

I'm thinking about all the off-channel bugs and multi-channel operation.

We currently have at least one rather important bug: Almost every call
to ieee80211_tx_skb()/ieee80211_xmit() is wrong because it assumes we
are on the operating channel. This leads to bugs such as
https://bugzilla.redhat.com/attachment.cgi?id=530264
(https://bugzilla.redhat.com/show_bug.cgi?id=749125) where I'd say we
are sending a frame for connection monitoring while doing some work on
another channel.

The other thing is more of a design issue: we have multiple ways to
leave the operating channel: scanning & work. Soon we'll have to deal
with multi-channel *operation* so we'll have multiple operating
channels. I don't even want to have to handle that in mac80211, and I
think we'll have to push it into devices (or drivers in some cases). In
my opinion, these two ways should be consolidated.

Also, as devices (or drivers) get more complex, we find ourselves
further and further away from a model where mac80211 is truly fully
controlling the device. Given the differences in hardware we support
now, I think that it obvious now that we need drivers to be smarter in
many cases.

How do we want to handle these things? I'm sure I want the drivers to
handle multi-channel operation fairly transparently, with multiple
(hardware) queues (in the driver), so mac80211 doesn't have to
start/stop the queues continuously and can just transmit on that
interface, the frame might only go out a bit later.

But then what about scanning? Can we, and should we, force such drivers
to implement hw_scan? I think maybe we should, and maybe drivers such as
brcmsmac & ath9k can share a common scan implementation they call into?

Authenticating & associating seems fairly easy, we create a new vif and
set it to the right channel and then do everything there -- simpler than
what we have now -- but what about FT-OTA? What if the device supports
only two channels and is a P2P GO on channel 1 and now wants to roam on
the infrastructure connection, say from channel 36 to channel 11? How
can we handle that?

Has anyone else started thinking about this?

johannes

