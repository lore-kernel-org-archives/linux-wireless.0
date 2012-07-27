Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51426 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab2G0LRA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 07:17:00 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1SuiXS-0006Bc-Hp
	for linux-wireless@vger.kernel.org; Fri, 27 Jul 2012 13:16:58 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 00/20] mac80211: multi-channel work
Date: Fri, 27 Jul 2012 13:16:36 +0200
Message-Id: <1343387816-9414-1-git-send-email-johannes@sipsolutions.net> (sfid-20120727_131724_863712_473E357A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Building on Michal's work for channel contexts, which I've
kept as the first few patches (some of them modified for a
few small fixes), this actually makes mac80211 support more
than a single channel. How many channels is determined by
the driver and verified by cfg80211, so mac80211 isn't much
involved there.

Internally, mac80211 will exclusively use channel contexts.
It then has some compatibility code that will call the old
config() method of the driver, if the driver isn't updated
to take advantage of channel contexts.

In order to support multi-channel, drivers must:
 * implement the five new channel context methods
 * be able to offload scanning
 * be able to offload remain-on-channel

Trying to advertise multiple channels without support for
channel context methods is an error, advertising multiple
channels without support for scan/roc causes all scan/roc
operations to always fail.

So far, I've only tested this with hwsim, and even then
only the backward compatibility code to make sure that it
won't break drivers that aren't updated. I've tested that
channel contexts are added/removed properly and that the
configuration is updated in the device. I've also tested
with two virtual interfaces to see that compatible channel
types are still possible and result in the desired driver
methods being called.

Comments welcome!

johannes

