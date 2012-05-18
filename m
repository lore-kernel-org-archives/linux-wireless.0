Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:43813 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965342Ab2ERMDS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2012 08:03:18 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [RFC] initial channel context implementation
Date: Fri, 18 May 2012 14:03:03 +0200
Message-ID: <1337342589-10617-1-git-send-email-michal.kazior@tieto.com> (sfid-20120518_140328_262607_E2FB6604)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

I've done some work on channel contexts. It's based on your recently
posted patches (set_channel, join_mesh, etc). This is course for
multi-channel operation.

This isn't ready/complete yet. Channel selection is unsafe because the
for() shouldn't be limited to the IEEE80211_MAX_CHANNEL_CONTEXTS. It
should be limited by the maximum number of different channels for a
matching interface combination during runtime.

This however seems to be a bit tricky right now. I've looked at your
cfg80211-enforce-beacon_int_infra_match.patch but the
cfg80211_find_current_combination ignores the fact that an interface
may be up and running without a channel contexts being bound (i.e.
without an association whatsoever). For this to work we need to know
whether a given interface is really running/operational for tx.

I've thought about using netif_carrier_on/off for this purpose but
I'm not sure whether we can use it for our purpose. Other idea is to
create a new function that would be able to tell us whether an
interface is using a channel. But what would that be based on? Can we
check that easily for all interface types (monitor)?

My current idea is to make channel contexts work alongside what we
have today. Old drivers would remain to use current structures
(oper_channel, hw.conf.channel, etc), new ones or the ones wanting to
support multi-channel would switch to channel contexts.


--
Pozdrawiam / Best regards,
Michal Kazior.

