Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56057 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933033Ab2EKSUr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 May 2012 14:20:47 -0400
Message-Id: <20120511180817.974687689@sipsolutions.net> (sfid-20120511_202052_973077_29570917)
Date: Fri, 11 May 2012 20:08:17 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Dan Williams <dcbw@redhat.com>,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [RFC 0/3] mesh/wds channel changes & clarifications
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This shows the direction I want to take the cfg80211
APIs in wrt. channel settings.

After these patches, there is no more set_channel(),
and set_monitor_channel() is only available when you
 * set the channel on a wiphy
 * set the channel on a monitor netdev
 * set the channel using wext on an unassociated
   managed interface

All these translate into setting the monitor channel
though.

The sole exception is for libertas, so I split that
out into a new function that only it will ever have.
Not the best thing to do, but I don't really see any
good choice that doesn't break libertas.

Note that this requires a lot of patches I've sent
over the last two days, or you can find all of them
on http://j.sipsolutions.net/patches/kernel/all/LATEST/

johannes
